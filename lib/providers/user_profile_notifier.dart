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

  /// 登出 — Navigation-First：先导航，后清理。
  ///
  /// 这是所有登出操作的唯一入口。屏幕层不得直接调用 authBackend.signOut()。
  /// 设计原则：用户反馈必须立即可见。
  /// Phase 1-2 是同步操作，保证瞬间完成。
  /// Phase 3 是异步清理，在后台 fire-and-forget。
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final uid = ref.read(currentUidProvider);

    // Phase 1: 停止后台引擎（同步、幂等）
    ref.read(syncEngineProvider).stop();

    // Phase 2: 导航触发 — 用户立即看到引导页
    ref.read(onboardingCompleteProvider.notifier).reset();

    // Phase 3: 后台清理（fire-and-forget，失败不影响用户）
    _cleanupAfterLogout(uid);
  }

  /// 登出后台清理 — 全部 best-effort，失败仅记录不阻塞。
  void _cleanupAfterLogout(String? uid) {
    Future(() async {
      try {
        if (uid != null) {
          await ref.read(ledgerServiceProvider).deleteUidData(uid);
        }
        await ref.read(notificationServiceProvider).cancelAll();
      } catch (e, stack) {
        _recordLogoutError(e, stack, 'data_cleanup');
      }

      _clearUserLocalState();

      try {
        await ref.read(authBackendProvider).signOut();
        ObservabilityRuntime.clearUidHash();
        await FirebaseCrashlytics.instance.setUserIdentifier('');
      } catch (e, stack) {
        _recordLogoutError(e, stack, 'auth_signout');
      }

      _isLoggingOut = false;
    });
  }

  /// 访客数据重置 — 清除数据后回到引导。
  Future<void> resetGuestData() async {
    final uid = ref.read(currentUidProvider);
    if (uid != null) {
      await ref
          .read(accountDeletionOrchestratorProvider)
          .deleteAccount(uid: uid);
      ref.read(onboardingCompleteProvider.notifier).reset();
    }
  }

  /// 清理全量用户级 SharedPreferences — 保留应用级设置（theme、locale）。
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
