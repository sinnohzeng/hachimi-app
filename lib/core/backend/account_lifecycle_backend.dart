/// 账户生命周期后端抽象。
///
/// 提供账户硬删与业务数据清空能力，用于离线优先删号与访客升级合并。
abstract class AccountLifecycleBackend {
  String get id;

  /// 删除当前用户所有业务数据，并删除 Auth 账户。
  Future<void> deleteAccountHard();

  /// 仅清空当前用户业务数据，保留 Auth 账户。
  Future<void> wipeUserData();
}
