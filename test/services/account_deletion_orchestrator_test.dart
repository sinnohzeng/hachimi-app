import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/backend/auth_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/constants/sync_constants.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/services/account_deletion_orchestrator.dart';
import 'package:hachimi_app/services/account_deletion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Fakes ───

class FakeAccountDeletionService implements AccountDeletionService {
  bool cleanLocalDataCalled = false;

  @override
  Future<void> cleanLocalData({
    Map<String, Object?> preservePrefs = const {},
  }) async {
    cleanLocalDataCalled = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAccountLifecycleBackend implements AccountLifecycleBackend {
  @override
  String get id => 'fake';

  bool deleteAccountHardCalled = false;
  Object? deleteAccountHardError;

  @override
  Future<void> deleteAccountHard({required OperationContext context}) async {
    deleteAccountHardCalled = true;
    if (deleteAccountHardError != null) {
      throw deleteAccountHardError!;
    }
  }

  @override
  Future<void> wipeUserData({required OperationContext context}) async {}
}

class FakeAuthBackend implements AuthBackend {
  @override
  String get id => 'fake';

  String? _currentUid;
  @override
  String? get currentUid => _currentUid;

  bool signOutCalled = false;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  // 其他方法 — 测试不需要
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeConnectivity implements Connectivity {
  List<ConnectivityResult> result = [ConnectivityResult.wifi];

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFunctionsException extends FirebaseFunctionsException {
  FakeFunctionsException(String code)
    : super(message: 'functions error', code: code);
}

// ─── Helpers ───

void _seedPendingJob(
  Map<String, Object> values,
  String uid, {
  int retryCount = 0,
}) {
  values[AppPrefsKeys.pendingDeletionJob] = jsonEncode({
    'uid': uid,
    'correlation_id': 'test-corr',
  });
  values[AppPrefsKeys.deletionTombstone] = true;
  values[AppPrefsKeys.deletionRetryCount] = retryCount;
}

bool _hasNoMarkers(SharedPreferences prefs) {
  return prefs.getString(AppPrefsKeys.pendingDeletionJob) == null &&
      prefs.getBool(AppPrefsKeys.deletionTombstone) == null &&
      prefs.getInt(AppPrefsKeys.deletionRetryCount) == null;
}

// ─── Tests ───

void main() {
  late FakeAccountDeletionService fakeDeletionService;
  late FakeAccountLifecycleBackend fakeLifecycleBackend;
  late FakeAuthBackend fakeAuthBackend;
  late FakeConnectivity fakeConnectivity;
  late SharedPreferences prefs;
  late AccountDeletionOrchestrator orchestrator;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // ErrorHandler 内部使用 Connectivity() 读取网络状态，需要 mock 平台通道
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (call) async => ['wifi'],
        );
  });

  setUp(() async {
    fakeDeletionService = FakeAccountDeletionService();
    fakeLifecycleBackend = FakeAccountLifecycleBackend();
    fakeAuthBackend = FakeAuthBackend();
    fakeConnectivity = FakeConnectivity();
  });

  Future<void> buildOrchestrator(Map<String, Object> initialValues) async {
    SharedPreferences.setMockInitialValues(initialValues);
    prefs = await SharedPreferences.getInstance();
    orchestrator = AccountDeletionOrchestrator(
      deletionService: fakeDeletionService,
      lifecycleBackend: fakeLifecycleBackend,
      authBackend: fakeAuthBackend,
      prefs: prefs,
      connectivity: fakeConnectivity,
    );
  }

  group('resumePendingDeletion', () {
    test('returns false when no pending job exists', () async {
      await buildOrchestrator({});
      final result = await orchestrator.resumePendingDeletion();
      expect(result, isFalse);
    });

    test('returns false when offline', () async {
      final values = <String, Object>{};
      _seedPendingJob(values, 'uid_abc');
      await buildOrchestrator(values);

      fakeConnectivity.result = [ConnectivityResult.none];
      final result = await orchestrator.resumePendingDeletion();
      expect(result, isFalse);
    });
  });

  group('_attemptRemoteDeletion — termination conditions', () {
    test('UID mismatch clears all markers', () async {
      final values = <String, Object>{};
      _seedPendingJob(values, 'old_uid');
      await buildOrchestrator(values);

      // 当前 UID 与 pending UID 不匹配 — 用户已重新注册
      fakeAuthBackend._currentUid = 'new_uid';
      fakeConnectivity.result = [ConnectivityResult.wifi];

      await orchestrator.resumePendingDeletion();

      expect(_hasNoMarkers(prefs), isTrue);
      expect(fakeLifecycleBackend.deleteAccountHardCalled, isFalse);
    });

    test('retries exhausted clears all markers', () async {
      final values = <String, Object>{};
      _seedPendingJob(
        values,
        'uid_abc',
        retryCount: SyncConstants.deletionMaxRetryCount,
      );
      await buildOrchestrator(values);

      fakeAuthBackend._currentUid = 'uid_abc';
      fakeConnectivity.result = [ConnectivityResult.wifi];

      await orchestrator.resumePendingDeletion();

      expect(_hasNoMarkers(prefs), isTrue);
      expect(fakeLifecycleBackend.deleteAccountHardCalled, isFalse);
    });

    test('remote failure increments retry count', () async {
      final values = <String, Object>{};
      _seedPendingJob(values, 'uid_abc', retryCount: 1);
      await buildOrchestrator(values);

      fakeAuthBackend._currentUid = 'uid_abc';
      fakeLifecycleBackend.deleteAccountHardError = Exception(
        'remote_delete_failed',
      );

      await orchestrator.resumePendingDeletion();

      expect(prefs.getInt(AppPrefsKeys.deletionRetryCount), 2);
      // markers 仍存在，等待下次重试
      expect(prefs.getString(AppPrefsKeys.pendingDeletionJob), isNotNull);
    });

    test('non-retryable functions error clears pending markers', () async {
      final values = <String, Object>{};
      _seedPendingJob(values, 'uid_abc', retryCount: 1);
      await buildOrchestrator(values);

      fakeAuthBackend._currentUid = 'uid_abc';
      fakeLifecycleBackend.deleteAccountHardError = FakeFunctionsException(
        'unimplemented',
      );

      await orchestrator.resumePendingDeletion();

      expect(_hasNoMarkers(prefs), isTrue);
    });
  });

  group('deleteAccount result state', () {
    test('returns queued when offline after local delete', () async {
      await buildOrchestrator({});
      fakeConnectivity.result = [ConnectivityResult.none];

      final result = await orchestrator.deleteAccount(uid: 'uid_abc');

      expect(result.localDeleted, isTrue);
      expect(result.remoteDeleted, isFalse);
      expect(result.queued, isTrue);
    });

    test('returns remoteDeleted when remote call succeeds', () async {
      await buildOrchestrator({});
      fakeAuthBackend._currentUid = 'uid_abc';

      final result = await orchestrator.deleteAccount(uid: 'uid_abc');

      expect(result.localDeleted, isTrue);
      expect(result.remoteDeleted, isTrue);
      expect(result.queued, isFalse);
      expect(fakeAuthBackend.signOutCalled, isTrue);
    });
  });

  group('abandonPendingDeletion', () {
    test('clears all 3 markers', () async {
      final values = <String, Object>{};
      _seedPendingJob(values, 'uid_abc', retryCount: 3);
      await buildOrchestrator(values);

      await orchestrator.abandonPendingDeletion();

      expect(_hasNoMarkers(prefs), isTrue);
    });
  });
}
