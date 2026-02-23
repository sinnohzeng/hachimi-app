/// AI API 错误类型。
enum AiErrorType {
  /// 网络不可达、DNS 解析失败、超时。
  networkError,

  /// API Key 无效或未配置。
  authFailure,

  /// 请求过于频繁。
  rateLimited,

  /// 账户余额不足。
  insufficientBalance,

  /// 服务端错误（5xx）。
  serverError,

  /// 用户主动取消。
  cancelled,

  /// 未配置 AI 提供商。
  unconfigured,
}

/// AI API 异常。
class AiException implements Exception {
  final AiErrorType type;
  final String message;

  const AiException(this.type, this.message);

  @override
  String toString() => 'AiException($type): $message';
}
