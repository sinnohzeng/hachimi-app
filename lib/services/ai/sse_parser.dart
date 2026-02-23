import 'dart:convert';

/// SSE（Server-Sent Events）流解析工具。
///
/// 将 HTTP 响应的字节流转换为 OpenAI 兼容的增量 token 字符串流。
/// 适用于 MiniMax、千问、Gemini 等使用 SSE 协议的大模型 API。
class SseParser {
  SseParser._();

  /// 将 SSE 行流转换为 token 字符串流。
  ///
  /// 输入：HTTP 响应 body 经 utf8 + LineSplitter 处理后的行流。
  /// 输出：每个 delta.content 的增量文本。
  static Stream<String> parse(Stream<String> lines) async* {
    await for (final line in lines) {
      final token = _extractToken(line);
      if (token != null) yield token;
    }
  }

  /// 从单行 SSE 数据中提取 token。
  ///
  /// 返回 null 表示该行不含有效 token（空行、注释、[DONE] 等）。
  static String? _extractToken(String line) {
    if (!line.startsWith('data: ')) return null;

    final jsonStr = line.substring(6).trim();
    if (jsonStr.isEmpty || jsonStr == '[DONE]') return null;

    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) return null;

    final first = choices[0] as Map<String, dynamic>;
    final delta = first['delta'] as Map<String, dynamic>?;
    return delta?['content'] as String?;
  }
}
