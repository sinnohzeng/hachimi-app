/// AI 消息角色。
enum AiRole { system, user, assistant }

/// 通用 AI 消息模型 — 适用于所有大模型提供商。
class AiMessage {
  final AiRole role;
  final String content;

  const AiMessage({required this.role, required this.content});

  /// 系统消息快捷构造。
  const AiMessage.system(this.content) : role = AiRole.system;

  /// 用户消息快捷构造。
  const AiMessage.user(this.content) : role = AiRole.user;

  /// 助手消息快捷构造。
  const AiMessage.assistant(this.content) : role = AiRole.assistant;

  /// 序列化为 OpenAI 兼容 JSON 格式。
  Map<String, String> toJson() => {'role': role.name, 'content': content};
}

/// AI 生成响应。
class AiResponse {
  /// 生成的文本内容。
  final String content;

  /// Token 用量（prompt + completion）。
  final AiUsage? usage;

  const AiResponse({required this.content, this.usage});
}

/// Token 用量统计。
class AiUsage {
  final int promptTokens;
  final int completionTokens;

  const AiUsage({required this.promptTokens, required this.completionTokens});

  int get totalTokens => promptTokens + completionTokens;
}
