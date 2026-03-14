import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/observability_runtime.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

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
    await ref
        .read(userProfileServiceProvider)
        .ensureProfile(uid: uid, email: email, displayName: displayName);

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

    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'display_name', newName);
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'displayName', 'value': newName},
    );

    _syncBestEffort(
      () => ref.read(authBackendProvider).updateDisplayName(newName),
      'updateDisplayName(auth)',
    );
    _syncBestEffort(
      () => ref
          .read(userProfileServiceProvider)
          .syncToFirestore(uid: uid, displayName: newName),
      'updateDisplayName(firestore)',
    );
  }

  bool _isLoggingOut = false;

  /// 登出 — 简化为 3 步，依赖 Provider 级联自动清理下游状态。
  ///
  /// 行业最佳实践：signOut() 触发 authStateProvider 发出 null →
  /// appAuthStateProvider 重算为 GuestState → 所有下游 provider 自动失效。
  /// 不再需要手动清理 10 个 SharedPreferences key。
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      final oldUid = ref.read(appAuthStateProvider).uid;

      // Step 1: 停止后台引擎（在身份切换前停止 Firestore 监听）
      ref.read(syncEngineProvider).stop();

      // Step 2: 清理旧用户数据 + Firebase 登出
      if (oldUid.isNotEmpty) {
        try {
          await ref.read(ledgerServiceProvider).deleteUidData(oldUid);
        } catch (e, stack) {
          _recordLogoutError(e, stack, 'delete_uid_data');
        }
      }
      try {
        await ref.read(authBackendProvider).signOut();
      } catch (e, stack) {
        _recordLogoutError(e, stack, 'auth_signout');
      }

      // Step 3: 创建新访客身份 + 触发导航重置
      final prefs = ref.read(sharedPreferencesProvider);
      prefs.setString(AppPrefsKeys.localGuestUid, 'guest_${const Uuid().v4()}');
      prefs.remove(AppPrefsKeys.dataHydrated);
      prefs.remove(AppPrefsKeys.onboardingComplete);

      ObservabilityRuntime.clearUidHash();
      ref.read(onboardingCompleteProvider.notifier).reset();
      _cleanupNonCritical();
    } finally {
      _isLoggingOut = false;
    }
  }

  /// 登出后台清理 — 非关键操作，best-effort。
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

    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'current_title', titleId ?? '');
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'currentTitle', 'value': titleId ?? ''},
    );

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

    final ledger = ref.read(ledgerServiceProvider);
    await ledger.setMaterialized(uid, 'avatar_id', avatarId);
    await ledger.append(
      type: ActionType.profileUpdate,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'field': 'avatarId', 'value': avatarId},
    );

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
