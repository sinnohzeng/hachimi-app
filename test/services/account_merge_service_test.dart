import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/account_merge_service.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/services/sync_engine.dart';
import 'package:hachimi_app/services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Fakes ───

/// 记录方法调用顺序的 LedgerService fake。
///
/// 只实现 AccountMergeService 用到的方法：migrateUid、deleteUidData、notifyChange。
class FakeLedgerService implements LedgerService {
  final List<String> callLog = [];
  bool migrateUidCalled = false;
  String? migrateOldUid;
  String? migrateNewUid;

  @override
  Future<void> migrateUid(String oldUid, String newUid) async {
    callLog.add('migrateUid');
    migrateUidCalled = true;
    migrateOldUid = oldUid;
    migrateNewUid = newUid;
  }

  @override
  Future<void> deleteUidData(String uid) async {
    callLog.add('deleteUidData');
  }

  @override
  void notifyChange(LedgerChange change) {
    callLog.add('notifyChange');
  }

  @override
  Stream<LedgerChange> get changes => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 记录 start/stop 调用的 SyncEngine fake。
class FakeSyncEngine implements SyncEngine {
  final List<String> callLog = [];
  String? lastStartUid;

  @override
  void start(String uid) {
    callLog.add('start');
    lastStartUid = uid;
  }

  @override
  void stop() {
    callLog.add('stop');
  }

  @override
  Future<void> hydrateFromFirestore(String uid) async {
    callLog.add('hydrate');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserProfileService implements UserProfileService {
  bool ensureProfileCalled = false;

  @override
  Future<void> ensureProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    ensureProfileCalled = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAccountLifecycleBackend implements AccountLifecycleBackend {
  @override
  String get id => 'fake';

  bool wipeCalled = false;
  bool shouldFail = false;

  @override
  Future<void> wipeUserData({required OperationContext context}) async {
    wipeCalled = true;
    if (shouldFail) throw Exception('cloud_wipe_failed');
  }

  @override
  Future<void> deleteAccountHard({required OperationContext context}) async {}
}

// ─── Tests ───

void main() {
  late FakeLedgerService fakeLedger;
  late FakeSyncEngine fakeSyncEngine;
  late FakeUserProfileService fakeProfileService;
  late FakeAccountLifecycleBackend fakeLifecycleBackend;
  late SharedPreferences prefs;
  late AccountMergeService mergeService;

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
    fakeLedger = FakeLedgerService();
    fakeSyncEngine = FakeSyncEngine();
    fakeProfileService = FakeUserProfileService();
    fakeLifecycleBackend = FakeAccountLifecycleBackend();

    SharedPreferences.setMockInitialValues({
      AppPrefsKeys.localGuestUid: 'guest_old',
      AppPrefsKeys.cachedUid: 'guest_old',
    });
    prefs = await SharedPreferences.getInstance();

    mergeService = AccountMergeService(
      ledger: fakeLedger,
      syncEngine: fakeSyncEngine,
      profileService: fakeProfileService,
      lifecycleBackend: fakeLifecycleBackend,
      prefs: prefs,
    );
  });

  group('keepLocal', () {
    test('migrateUid succeeds even when cloud wipe fails', () async {
      fakeLifecycleBackend.shouldFail = true;

      await mergeService.keepLocal(
        oldUid: 'guest_old',
        newUid: 'firebase_abc',
        email: 'a@b.com',
      );

      // migrateUid 在云端清理之前完成
      expect(fakeLedger.migrateUidCalled, isTrue);
      expect(fakeLedger.migrateOldUid, 'guest_old');
      expect(fakeLedger.migrateNewUid, 'firebase_abc');

      // 云端清理是 fire-and-forget，不阻塞也不抛异常
      // 等待 microtask 让 catchError 执行
      await Future<void>.delayed(Duration.zero);
      expect(fakeLifecycleBackend.wipeCalled, isTrue);
    });

    test('prefs updated correctly after keepLocal', () async {
      await mergeService.keepLocal(
        oldUid: 'guest_old',
        newUid: 'firebase_abc',
        email: 'a@b.com',
        displayName: 'Alice',
      );

      // localGuestUid 已清除
      expect(prefs.getString(AppPrefsKeys.localGuestUid), isNull);
      // cachedUid 更新为新 UID
      expect(prefs.getString(AppPrefsKeys.cachedUid), 'firebase_abc');
      // dataHydrated 标记为 true（本地数据是权威来源）
      expect(prefs.getBool(AppPrefsKeys.dataHydrated), isTrue);
    });

    test('operations execute in correct order', () async {
      await mergeService.keepLocal(
        oldUid: 'guest_old',
        newUid: 'firebase_abc',
        email: 'a@b.com',
      );

      // stop → migrateUid → ... → start → notifyChange
      expect(fakeSyncEngine.callLog.first, 'stop');
      expect(fakeLedger.callLog.first, 'migrateUid');

      final startIdx = fakeSyncEngine.callLog.indexOf('start');
      expect(startIdx, greaterThan(0));
      expect(fakeSyncEngine.lastStartUid, 'firebase_abc');

      final notifyIdx = fakeLedger.callLog.indexOf('notifyChange');
      expect(notifyIdx, greaterThan(0));
    });

    test('skips migrateUid when oldUid equals newUid', () async {
      await mergeService.keepLocal(
        oldUid: 'same_uid',
        newUid: 'same_uid',
        email: 'a@b.com',
      );

      expect(fakeLedger.migrateUidCalled, isFalse);
      // 其他操作仍正常执行
      expect(fakeProfileService.ensureProfileCalled, isTrue);
    });
  });

  group('keepCloud', () {
    test('deletes old uid data and hydrates from cloud', () async {
      await mergeService.keepCloud(oldUid: 'guest_old', newUid: 'firebase_abc');

      expect(fakeLedger.callLog.contains('deleteUidData'), isTrue);
      expect(fakeSyncEngine.callLog.contains('hydrate'), isTrue);
      expect(prefs.getString(AppPrefsKeys.localGuestUid), isNull);
      expect(prefs.getString(AppPrefsKeys.cachedUid), 'firebase_abc');
      // dataHydrated 为 false — 等待水化完成后由 SyncEngine 标记
      expect(prefs.getBool(AppPrefsKeys.dataHydrated), isFalse);
    });
  });
}
