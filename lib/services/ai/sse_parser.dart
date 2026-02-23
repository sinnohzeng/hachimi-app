import 'dart:convert';

/// Token 提取函数签名 — 从已解析的 JSON 中提取增量文本。
typedef SseTokenExtractor = String? Function(Map<String, dynamic> data);

/// SSE（Server-Sent Events）流解析工具。
///
/// 将 HTTP 响应的字节流转换为增量 token 字符串流。
/// 适用于 MiniMax、Gemini 等使用 SSE 协议的大模型 API。
class SseParser {
  SseParser._();

  /// 默认 token 提取器（OpenAI / MiniMax 兼容格式）。
  ///
  /// 路径：`choices[0].delta.content`
  static String? defaultExtractor(Map<String, dynamic> data) {
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;
    final first = choices[0] as Map<String, dynamic>;
    final delta = first['delta'] as Map<String, dynamic>?;
    return delta?['content'] as String?;
  }

  /// 将 SSE 行流转换为 token 字符串流。
  ///
  /// 输入：HTTP 响应 body 经 utf8 + LineSplitter 处理后的行流。
  /// [extractToken] 自定义 JSON → token 提取逻辑，默认 OpenAI 格式。
  static Stream<String> parse(
    Stream<String> lines, {
    SseTokenExtractor? extractToken,
  }) async* {
    final extractor = extractToken ?? defaultExtractor;
    await for (final line in lines) {
      if (!line.startsWith('data: ')) continue;
      final jsonStr = line.substring(6).trim();
      if (jsonStr.isEmpty || jsonStr == '[DONE]') continue;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final token = extractor(data);
      if (token != null) yield token;
    }
  }
}
