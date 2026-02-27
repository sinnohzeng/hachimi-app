/// 远程配置后端抽象接口。
///
/// [RemoteConfigService] 委托此接口获取配置值。
abstract class RemoteConfigBackend {
  /// 后端标识名。
  String get id;

  /// 初始化远程配置（设置默认值、拉取激活）。
  Future<void> initialize(Map<String, dynamic> defaults);

  /// 获取字符串配置值。
  String getString(String key);

  /// 获取整数配置值。
  int getInt(String key);

  /// 获取浮点配置值。
  double getDouble(String key);

  /// 获取布尔配置值。
  bool getBool(String key);

  /// 拉取并激活最新配置。
  Future<void> fetchAndActivate();
}
