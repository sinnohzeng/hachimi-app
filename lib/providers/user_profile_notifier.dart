import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// UserProfileNotifier — 用户资料变更的统一入口。
///
/// 所有资料操作（注册初始化、修改名称、修改头像）统一在此编排，
/// 屏幕层只需调用一个方法，无需自行协调 Auth + Ledger + Firestore。
///
/// State 类型为 void — 这是操作型 Notifier，不持有状态。
/// 资料数据由 avatarIdProvider、authStateProvider 分别管理。
class UserProfileNotifier extends Notifier<void> {
  @override
  void build() {}

  /// 注册后初始化用户资料（Firestore + 本地 Ledger）。
  Future<void> ensureProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    // 1. Firestore 文档创建
    await ref
        .read(userProfileServiceProvider)
        .ensureProfile(uid: uid, email: email, displayName: displayName);

    // 2. 本地 materialized_state 初始化
    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'coins', '0');
    await ledger.setMaterialized(uid, 'last_check_in_date', '');
    await ledger.setMaterialized(uid, 'inventory', '[]');
    if (displayName != null) {
      await ledger.setMaterialized(uid, 'display_name', displayName);
    }
    ledger.notifyChange(const LedgerChange(type: 'hydrate'));
  }

  /// 更新显示名称（本地优先 → Auth + Firestore fire-and-forget）。
  Future<void> updateDisplayName(String newName) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // 1. 本地 SSOT（离线安全）
    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'display_name', newName);
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'displayName', 'value': newName},
    );

    // 2. Firebase Auth best-effort（fire-and-forget）
    _syncBestEffort(
      () => ref.read(authBackendProvider).updateDisplayName(newName),
      'updateDisplayName(auth)',
    );

    // 3. Firestore best-effort（fire-and-forget）
    _syncBestEffort(
      () => ref
          .read(userProfileServiceProvider)
          .syncToFirestore(uid: uid, displayName: newName),
      'updateDisplayName(firestore)',
    );
  }

  bool _isLoggingOut = false;

  /// 登出 — Clean-Then-Navigate：先清理关键状态，再触发导航。
  ///
  /// 这是所有登出操作的唯一入口。屏幕层不得直接调用 authBackend.signOut()。
  ///
  /// 设计原则：关键状态（本地缓存 + Auth 会话）必须在导航重置前清除，
  /// 否则新会话的 _ensureLocalUid / _autoSignInAnonymously 会与旧会话的
  /// fire-and-forget signOut 产生竞态，导致用户卡死在加载页。
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      final uid = ref.read(currentUidProvider);

      ref.read(syncEngineProvider).stop(); // Phase 1: 停止后台引擎
      _clearUserLocalState(); // Phase 2: SharedPreferences
      await _destroySessionData(uid); // Phase 3-4: SQLite + Firebase

      // Phase 5: 导航触发 — 用户看到引导页（此时旧会话已彻底销毁）
      ref.read(onboardingCompleteProvider.notifier).reset();

      _cleanupNonCritical(); // Phase 6: 通知 + Crashlytics（fire-and-forget）
    } finally {
      _isLoggingOut = false;
    }
  }

  /// 销毁用户会话数据 — SQLite 台账 + Firebase Auth。
  ///
  /// 每个操作独立 try-catch，单个失败不影响后续清理。
  Future<void> _destroySessionData(String? uid) async {
    if (uid != null) {
      try {
        await ref.read(ledgerServiceProvider).deleteUidData(uid);
      } catch (e, stack) {
        _recordLogoutError(e, stack, 'delete_uid_data');
      }
    }
    try {
      await ref.read(authBackendProvider).signOut();
    } catch (e, stack) {
      _recordLogoutError(e, stack, 'auth_signout');
    }
    ObservabilityRuntime.clearUidHash();
  }

  /// 登出后台清理 — 非关键操作，best-effort。
  ///
  /// 仅负责通知取消和 Crashlytics 用户标识清理。
  /// SQLite 数据已在 Phase 3 同步清除，此处不再处理。
  void _cleanupNonCritical() {
    Future(() async {
      try {
        await ref.read(notificationServiceProvider).cancelAll();
        await FirebaseCrashlytics.instance.setUserIdentifier('');
      } catch (e, stack) {
        _recordLogoutError(e, stack, 'non_critical_cleanup');
      }
    });
  }

  /// 访客数据重置 — 清除数据后回到引导。
  ///
  /// 与删号相同，清除 hasOnboardedBefore 让用户看到完整引导教程。
  Future<void> resetGuestData() async {
    final uid = ref.read(currentUidProvider);
    if (uid != null) {
      await ref
          .read(accountDeletionOrchestratorProvider)
          .deleteAccount(uid: uid);
      ref
          .read(sharedPreferencesProvider)
          .remove(AppPrefsKeys.hasOnboardedBefore);
      ref.read(onboardingCompleteProvider.notifier).reset();
    }
  }

  /// 清理全量用户级 SharedPreferences — 保留应用级设置。
  ///
  /// 以下键被刻意保留：
  /// - [AppPrefsKeys.hasOnboardedBefore] — 登出后跳过引导教程
  /// - theme / locale 等应用级设置由各自 Provider 管理，不在此清理范围
  void _clearUserLocalState() {
    final prefs = ref.read(sharedPreferencesProvider);
    for (final key in const [
      AppPrefsKeys.cachedUid,
      AppPrefsKeys.localGuestUid,
      AppPrefsKeys.dataHydrated,
      AppPrefsKeys.onboardingComplete,
      AppPrefsKeys.lastAppOpen,
      AppPrefsKeys.consecutiveDays,
      AppPrefsKeys.diaryPendingRetries,
      AppPrefsKeys.pendingDeletionJob,
      AppPrefsKeys.deletionTombstone,
      AppPrefsKeys.deletionRetryCount,
    ]) {
      prefs.remove(key);
    }
  }

  void _recordLogoutError(Object e, StackTrace stack, String phase) {
    ErrorHandler.recordOperation(
      e,
      stackTrace: stack,
      feature: 'UserProfileNotifier',
      operation: 'logout_$phase',
      errorCode: 'logout_${phase}_failed',
    );
  }

  /// 更新当前佩戴称号（本地优先 → Firestore fire-and-forget）。
  Future<void> updateTitle(String? titleId) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // 1. 本地 SSOT（离线安全）
    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'current_title', titleId ?? '');
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'currentTitle', 'value': titleId ?? ''},
    );

    // 2. Firestore best-effort（fire-and-forget）
    _syncBestEffort(
      () => ref
          .read(userProfileServiceProvider)
          .syncToFirestore(uid: uid, currentTitle: titleId),
      'updateTitle',
    );
  }

  /// 更新头像（本地优先 → Firestore fire-and-forget）。
  Future<void> updateAvatar(String avatarId) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    // 1. 本地 SSOT（离线安全）
    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'avatar_id', avatarId);
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'avatarId', 'value': avatarId},
    );

    // 2. Firestore best-effort（fire-and-forget）
    _syncBestEffort(
      () => ref
          .read(userProfileServiceProvider)
          .syncToFirestore(uid: uid, avatarId: avatarId),
      'updateAvatar',
    );
  }

  /// 尽力同步 — 失败时记录错误但不阻塞用户操作。
  void _syncBestEffort(Future<void> Function() action, String operation) {
    action().catchError((Object e, StackTrace stack) {
      ErrorHandler.recordOperation(
        e,
        stackTrace: stack,
        feature: 'UserProfileNotifier',
        operation: operation,
      );
    });
  }
}

/// 用户资料操作 Provider — 统一入口。
final userProfileNotifierProvider = NotifierProvider<UserProfileNotifier, void>(
  UserProfileNotifier.new,
);
