import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/constants/sync_constants.dart';
import 'package:hachimi_app/core/observability/correlation_id_factory.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/account_deletion_result.dart';
import 'package:hachimi_app/services/account_deletion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDeletionOrchestrator {
  final AccountDeletionService _deletionService;
  final AccountLifecycleBackend _lifecycleBackend;
  final AuthBackend _authBackend;
  final SharedPreferences _prefs;
  final Connectivity _connectivity;

  AccountDeletionOrchestrator({
    required AccountDeletionService deletionService,
    required AccountLifecycleBackend lifecycleBackend,
    required AuthBackend authBackend,
    required SharedPreferences prefs,
    Connectivity? connectivity,
  }) : _deletionService = deletionService,
       _lifecycleBackend = lifecycleBackend,
       _authBackend = authBackend,
       _prefs = prefs,
       _connectivity = connectivity ?? Connectivity();

  Future<AccountDeletionResult> deleteAccount({required String uid}) async {
    if (_isLocalGuestUid(uid)) {
      await _deletionService.cleanLocalData();
      await _clearPending();
      return const AccountDeletionResult(
        localDeleted: true,
        remoteDeleted: true,
        queued: false,
      );
    }

    final correlationId = CorrelationIdFactory.newId();
    await _storePending(uid: uid, retryCount: 0, correlationId: correlationId);
    await _deletionService.cleanLocalData(
      preservePrefs: _pendingPrefsSnapshot(),
    );
    if (!await _isOnline()) {
      return const AccountDeletionResult(
        localDeleted: true,
        remoteDeleted: false,
        queued: true,
      );
    }
    return _attemptRemoteDeletion(
      uid,
      correlationId: correlationId,
      localDeleted: true,
    );
  }

  Future<bool> resumePendingDeletion() async {
    final pending = _prefs.getString(AppPrefsKeys.pendingDeletionJob);
    if (pending == null || pending.isEmpty) return false;
    if (!await _isOnline()) return false;

    try {
      final data = jsonDecode(pending) as Map<String, dynamic>;
      final uid = data['uid'] as String?;
      if (uid == null || uid.isEmpty) {
        await _clearPending();
        return false;
      }
      final correlationId = data['correlation_id'] as String?;
      await _attemptRemoteDeletion(uid, correlationId: correlationId);
      return true;
    } catch (_) {
      await _clearPending();
      return false;
    }
  }

  Future<AccountDeletionResult> _attemptRemoteDeletion(
    String uid, {
    String? correlationId,
    bool localDeleted = false,
  }) async {
    final retryCount = _prefs.getInt(AppPrefsKeys.deletionRetryCount) ?? 0;

    // 终止条件 1：UID 不匹配 — 用户已重新注册，无法以旧身份认证
    if (_authBackend.currentUid != uid) {
      await _clearPending();
      return AccountDeletionResult(
        localDeleted: localDeleted,
        remoteDeleted: false,
        queued: false,
        errorCode: 'deletion_uid_mismatch',
      );
    }

    // 终止条件 2：重试耗尽
    if (retryCount >= SyncConstants.deletionMaxRetryCount) {
      await _clearPending();
      await ErrorHandler.recordOperation(
        Exception('deletion_max_retries_exceeded'),
        feature: 'AccountDeletionOrchestrator',
        operation: 'attemptRemoteDeletion',
        operationStage: 'account_deletion',
        retryCount: retryCount,
        errorCode: 'max_retries_exceeded',
      );
      return AccountDeletionResult(
        localDeleted: localDeleted,
        remoteDeleted: false,
        queued: false,
        errorCode: 'max_retries_exceeded',
      );
    }

    final opContext = OperationContext.capture(
      operationStage: 'account_deletion',
      retryCount: retryCount,
      correlationId: correlationId,
    );
    try {
      await _lifecycleBackend.deleteAccountHard(context: opContext);
      await _authBackend.signOut();
      ObservabilityRuntime.clearUidHash();
      try {
        await FirebaseCrashlytics.instance.setUserIdentifier('');
      } catch (_) {}
      await _clearPending();
      return AccountDeletionResult(
        localDeleted: localDeleted,
        remoteDeleted: true,
        queued: false,
      );
    } catch (e, stack) {
      final retryable = _isRetryableRemoteError(e);
      final errorCode = _toRemoteErrorCode(e);
      if (retryable) {
        await _incrementRetry();
      } else {
        await _clearPending();
      }
      await ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'AccountDeletionOrchestrator',
        operation: 'attemptRemoteDeletion',
        operationStage: 'account_deletion',
        retryCount: retryCount,
        correlationId: opContext.correlationId,
        errorCode: errorCode,
        extras: {'retryable': retryable.toString()},
      );
      return AccountDeletionResult(
        localDeleted: localDeleted,
        remoteDeleted: false,
        queued: retryable,
        errorCode: errorCode,
      );
    }
  }

  /// 用户主动放弃待处理的远程删除。
  Future<void> abandonPendingDeletion() async {
    await _clearPending();
  }

  Future<void> _storePending({
    required String uid,
    required int retryCount,
    required String correlationId,
  }) async {
    final payload = jsonEncode({
      'uid': uid,
      'correlation_id': correlationId,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await _prefs.setString(AppPrefsKeys.pendingDeletionJob, payload);
    await _prefs.setBool(AppPrefsKeys.deletionTombstone, true);
    await _prefs.setInt(AppPrefsKeys.deletionRetryCount, retryCount);
  }

  Map<String, Object?> _pendingPrefsSnapshot() {
    return {
      AppPrefsKeys.pendingDeletionJob: _prefs.getString(
        AppPrefsKeys.pendingDeletionJob,
      ),
      AppPrefsKeys.deletionTombstone: true,
      AppPrefsKeys.deletionRetryCount:
          _prefs.getInt(AppPrefsKeys.deletionRetryCount) ?? 0,
    };
  }

  Future<void> _clearPending() async {
    await _prefs.remove(AppPrefsKeys.pendingDeletionJob);
    await _prefs.remove(AppPrefsKeys.deletionTombstone);
    await _prefs.remove(AppPrefsKeys.deletionRetryCount);
  }

  Future<void> _incrementRetry() async {
    final next = (_prefs.getInt(AppPrefsKeys.deletionRetryCount) ?? 0) + 1;
    await _prefs.setInt(AppPrefsKeys.deletionRetryCount, next);
  }

  bool _isRetryableRemoteError(Object error) {
    if (error is FirebaseFunctionsException) {
      const retryableCodes = <String>{
        'cancelled',
        'unknown',
        'deadline-exceeded',
        'resource-exhausted',
        'internal',
        'unavailable',
        'data-loss',
      };
      return retryableCodes.contains(error.code);
    }
    return true;
  }

  String _toRemoteErrorCode(Object error) {
    if (error is FirebaseFunctionsException) {
      final normalized = error.code.replaceAll('-', '_');
      return 'functions_$normalized';
    }
    return 'delete_account_remote_failed';
  }

  Future<bool> _isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  bool _isLocalGuestUid(String uid) => uid.startsWith('guest_');
}
