// ---
// SSE Parser 单元测试 — 验证 SSE 流解析逻辑。
//
// 🕒 创建时间：2026-02-23
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/services/ai/sse_parser.dart';

void main() {
  group('SseParser.parse()', () {
    test('extracts token from valid SSE line', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[{"delta":{"content":"Hello"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hello']));
    });

    test('handles multiple tokens', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[{"delta":{"content":"Hello"}}]}',
        'data: {"choices":[{"delta":{"content":" world"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hello', ' world']));
    });

    test('skips empty lines', () async {
      final lines = Stream.fromIterable([
        '',
        'data: {"choices":[{"delta":{"content":"Hi"}}]}',
        '',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hi']));
    });

    test('skips [DONE] signal', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[{"delta":{"content":"Hello"}}]}',
        'data: [DONE]',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hello']));
    });

    test('skips lines without data: prefix', () async {
      final lines = Stream.fromIterable([
        ': comment',
        'event: message',
        'data: {"choices":[{"delta":{"content":"Hi"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hi']));
    });

    test('skips delta without content field', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[{"delta":{"role":"assistant"}}]}',
        'data: {"choices":[{"delta":{"content":"Hi"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hi']));
    });

    test('handles empty choices list', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[]}',
        'data: {"choices":[{"delta":{"content":"OK"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['OK']));
    });

    test('returns empty for empty stream', () async {
      final lines = Stream<String>.empty();
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, isEmpty);
    });
  });

  group('SseParser.parse() with custom extractToken', () {
    // Gemini 格式提取器
    String? geminiExtractor(Map<String, dynamic> data) {
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) return null;
      final first = candidates[0] as Map<String, dynamic>;
      final content = first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) return null;
      final firstPart = parts[0] as Map<String, dynamic>;
      return firstPart['text'] as String?;
    }

    test('extracts token from Gemini SSE format', () async {
      final lines = Stream.fromIterable([
        'data: {"candidates":[{"content":{"parts":[{"text":"Hello"}]}}]}',
      ]);
      final tokens = await SseParser.parse(
        lines,
        extractToken: geminiExtractor,
      ).toList();
      expect(tokens, equals(['Hello']));
    });

    test('handles multiple Gemini tokens', () async {
      final lines = Stream.fromIterable([
        'data: {"candidates":[{"content":{"parts":[{"text":"Hello"}]}}]}',
        'data: {"candidates":[{"content":{"parts":[{"text":" world"}]}}]}',
      ]);
      final tokens = await SseParser.parse(
        lines,
        extractToken: geminiExtractor,
      ).toList();
      expect(tokens, equals(['Hello', ' world']));
    });

    test('skips Gemini chunk with empty candidates', () async {
      final lines = Stream.fromIterable([
        'data: {"candidates":[]}',
        'data: {"candidates":[{"content":{"parts":[{"text":"OK"}]}}]}',
      ]);
      final tokens = await SseParser.parse(
        lines,
        extractToken: geminiExtractor,
      ).toList();
      expect(tokens, equals(['OK']));
    });

    test('custom extractor does not affect default behavior', () async {
      final lines = Stream.fromIterable([
        'data: {"choices":[{"delta":{"content":"Hi"}}]}',
      ]);
      final tokens = await SseParser.parse(lines).toList();
      expect(tokens, equals(['Hi']));
    });
  });

  group('SseParser.defaultExtractor', () {
    test('extracts content from choices[0].delta', () {
      final data = {
        'choices': [
          {
            'delta': {'content': 'Hello'},
          },
        ],
      };
      expect(SseParser.defaultExtractor(data), equals('Hello'));
    });

    test('returns null for empty choices', () {
      final data = {'choices': <dynamic>[]};
      expect(SseParser.defaultExtractor(data), isNull);
    });

    test('returns null for missing choices', () {
      final data = <String, dynamic>{'id': 'test'};
      expect(SseParser.defaultExtractor(data), isNull);
    });

    test('returns null for delta without content', () {
      final data = {
        'choices': [
          {
            'delta': {'role': 'assistant'},
          },
        ],
      };
      expect(SseParser.defaultExtractor(data), isNull);
    });
  });
}
