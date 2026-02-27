/// 崩溃上报后端抽象接口。
///
/// [ErrorHandler] 委托此接口记录错误和日志。
abstract class CrashBackend {
  /// 后端标识名。
  String get id;

  /// 记录捕获的异常。
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// 设置自定义键值对。
  Future<void> setCustomKey(String key, String value);

  /// 追加日志消息。
  void log(String message);
}
