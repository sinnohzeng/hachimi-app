import 'package:hachimi_app/core/backend/user_profile_backend.dart';

/// UserProfileService — 用户资料读写门面。
///
/// 委托 [UserProfileBackend] 执行实际 I/O，
/// 运行时根据后端区域自动切换 Firebase / CloudBase。
class UserProfileService {
  final UserProfileBackend _backend;

  UserProfileService({required UserProfileBackend backend})
    : _backend = backend;

  /// 注册时初始化用户文档。
  Future<void> createProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    await _backend.createProfile(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }

  /// Best-effort 同步资料字段到云端。
  /// 失败时不抛出异常（由 backend 内部处理错误）。
  Future<void> syncToFirestore({
    required String uid,
    String? displayName,
    String? avatarId,
    String? currentTitle,
  }) async {
    await _backend.syncFields(
      uid: uid,
      displayName: displayName,
      avatarId: avatarId,
      currentTitle: currentTitle,
    );
  }
}
