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
}
