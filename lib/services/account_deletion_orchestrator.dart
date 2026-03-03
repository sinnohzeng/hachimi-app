import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
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

  Future<void> deleteAccount({required String uid}) async {
    if (_isLocalGuestUid(uid)) {
      await _deletionService.cleanLocalData();
      await _clearPending();
      return;
    }

    await _storePending(uid: uid, retryCount: 0);
    await _deletionService.cleanLocalData(
      preservePrefs: _pendingPrefsSnapshot(),
    );
    if (await _isOnline()) await _attemptRemoteDeletion(uid);
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
      await _attemptRemoteDeletion(uid);
      return true;
    } catch (_) {
      await _clearPending();
      return false;
    }
  }

  Future<void> _attemptRemoteDeletion(String uid) async {
    try {
      if (_authBackend.currentUid != uid) {
        await _incrementRetry();
        return;
      }

      await _lifecycleBackend.deleteAccountHard();
      await _authBackend.signOut();
      await _clearPending();
    } catch (e, stack) {
      await _incrementRetry();
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'AccountDeletionOrchestrator',
        operation: 'attemptRemoteDeletion',
      );
    }
  }

  Future<void> _storePending({
    required String uid,
    required int retryCount,
  }) async {
    final payload = jsonEncode({
      'uid': uid,
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

  Future<bool> _isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  bool _isLocalGuestUid(String uid) => uid.startsWith('guest_');
}
