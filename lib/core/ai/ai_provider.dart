import 'package:hachimi_app/core/ai/ai_config.dart';
import 'package:hachimi_app/core/ai/ai_message.dart';

/// 大模型提供商抽象接口 — 策略模式。
///
/// 每个大模型厂商（MiniMax、千问、Gemini 等）实现此接口。
/// [ChatService] 和 [DiaryService] 仅依赖此抽象，永远不直接导入具体实现。
abstract class AiProvider {
  /// 提供商标识名（如 'minimax'、'qwen'、'gemini'）。
  String get id;

  /// 用户可见的显示名称。
  String get displayName;

  /// 是否已配置（API Key 等前置条件满足）。
  bool get isConfigured;

  /// 一次性生成（日记等场景）。
  ///
  /// 返回完整的 [AiResponse]，包含生成文本和 token 用量。
  Future<AiResponse> generate(List<AiMessage> messages, AiRequestConfig config);

  /// 流式生成（聊天等场景）。
  ///
  /// 返回 token 字符串流，每个事件是一个增量 token。
  Stream<String> generateStream(
    List<AiMessage> messages,
    AiRequestConfig config,
  );

  /// 取消当前进行中的请求。
  Future<void> cancel();

  /// 验证连接和 API Key 有效性。
  Future<bool> validateConnection();
}
