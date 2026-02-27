/// 用户资料后端抽象接口。
///
/// 负责用户文档的云端读写。
/// [UserProfileService] 委托此接口执行 I/O。
abstract class UserProfileBackend {
  /// 后端标识名。
  String get id;

  /// 注册时创建用户文档。
  Future<void> createProfile({
    required String uid,
    required String email,
    String? displayName,
  });

  /// Best-effort 同步资料字段到云端。
  /// 失败时不抛出异常（由实现方内部处理错误）。
  Future<void> syncFields({
    required String uid,
    String? displayName,
    String? avatarId,
    String? currentTitle,
  });
}
