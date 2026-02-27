import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/user_profile_service.dart';

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
  Future<void> createProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    // 1. Firestore 文档创建
    await ref
        .read(userProfileServiceProvider)
        .createProfile(uid: uid, email: email, displayName: displayName);

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
    try {
      await ref.read(authServiceProvider).updateDisplayName(newName);
    } catch (_) {
      // 离线时 Auth 更新失败不阻断，下次在线会通过 SyncEngine 同步
    }

    // 3. Firestore best-effort（fire-and-forget）
    // ignore: unawaited_futures
    ref
        .read(userProfileServiceProvider)
        .syncToFirestore(uid: uid, displayName: newName);
  }

  /// 登出 — 停止同步引擎 + 执行 Auth signOut。
  ///
  /// 屏幕层调用此方法而非直接调用 authService.signOut()，
  /// 确保后端切换时只需改一处。
  Future<void> logout() async {
    ref.read(syncEngineProvider).stop();
    await ref.read(authServiceProvider).signOut();
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
    // ignore: unawaited_futures
    ref
        .read(userProfileServiceProvider)
        .syncToFirestore(uid: uid, currentTitle: titleId);
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
    // ignore: unawaited_futures
    ref
        .read(userProfileServiceProvider)
        .syncToFirestore(uid: uid, avatarId: avatarId);
  }
}

/// 用户资料操作 Provider — 统一入口。
final userProfileNotifierProvider = NotifierProvider<UserProfileNotifier, void>(
  UserProfileNotifier.new,
);

/// UserProfileService — singleton provider。
final userProfileServiceProvider = Provider<UserProfileService>(
  (ref) => UserProfileService(backend: ref.watch(userProfileBackendProvider)),
);
