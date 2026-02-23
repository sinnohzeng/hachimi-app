/// AI 请求配置 — 控制生成行为的参数。
class AiRequestConfig {
  /// 最大生成 token 数。
  final int maxTokens;

  /// 采样温度（0-1，越高越随机）。
  final double temperature;

  /// Top-p 核采样。
  final double topP;

  const AiRequestConfig({
    required this.maxTokens,
    this.temperature = 0.7,
    this.topP = 0.9,
  });

  /// 聊天场景默认配置。
  static const chat = AiRequestConfig(
    maxTokens: 150,
    temperature: 0.7,
    topP: 0.9,
  );

  /// 日记生成默认配置。
  static const diary = AiRequestConfig(
    maxTokens: 200,
    temperature: 0.7,
    topP: 0.9,
  );

  /// 连接验证用的最小配置。
  static const validation = AiRequestConfig(
    maxTokens: 1,
    temperature: 0.0,
    topP: 1.0,
  );
}
