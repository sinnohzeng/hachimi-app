/// 数据分析后端抽象接口。
///
/// 提供通用的事件记录和用户属性设置原语。
/// [AnalyticsService] 保持领域专用方法，委托此接口做实际 I/O。
abstract class AnalyticsBackend {
  /// 后端标识名。
  String get id;

  /// 记录自定义事件。
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });

  /// 设置用户属性。
  Future<void> setUserProperty({required String name, required String? value});

  /// 记录登录事件。
  Future<void> logLogin({String? method});

  /// 记录注册事件。
  Future<void> logSignUp({String? method});
}
