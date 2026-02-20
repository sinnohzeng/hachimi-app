// ---
// 📘 文件说明：
// LlmService 单元测试 — 验证 cleanResponse() 方法的文本清理逻辑。
// 不测试模型加载/推理（需要实际模型文件和 Isolate 环境）。
//
// 🧩 文件结构：
// - cleanResponse() 移除特殊 token 标记；
// - 空字符串输入；
// - 无标记的普通文本不变；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/services/llm_service.dart';

void main() {
  late LlmService service;

  setUp(() {
    service = LlmService();
  });

  group('LlmService.cleanResponse()', () {
    test('removes <|im_end|> marker', () {
      final result = service.cleanResponse('Hello world<|im_end|>');
      expect(result, equals('Hello world'));
    });

    test('removes <|im_start|> marker', () {
      final result = service.cleanResponse('<|im_start|>Hello world');
      expect(result, equals('Hello world'));
    });

    test('removes <|endoftext|> marker', () {
      final result = service.cleanResponse('Hello world<|endoftext|>');
      expect(result, equals('Hello world'));
    });

    test('removes all markers from a single string', () {
      final result = service.cleanResponse(
        '<|im_start|>assistant\nHello!<|im_end|><|endoftext|>',
      );
      expect(result, equals('assistant\nHello!'));
    });

    test('removes multiple occurrences of the same marker', () {
      final result = service.cleanResponse(
        '<|im_end|>Hello<|im_end|> world<|im_end|>',
      );
      expect(result, equals('Hello world'));
    });

    test('empty string input returns empty string', () {
      final result = service.cleanResponse('');
      expect(result, equals(''));
    });

    test('whitespace-only input returns empty string after trim', () {
      final result = service.cleanResponse('   \n  ');
      expect(result, equals(''));
    });

    test('normal text without markers is unchanged', () {
      const text = 'Today was a wonderful day! Mochi played with yarn.';
      final result = service.cleanResponse(text);
      expect(result, equals(text));
    });

    test('text with surrounding whitespace is trimmed', () {
      final result = service.cleanResponse('  Hello world  ');
      expect(result, equals('Hello world'));
    });

    test('markers with surrounding whitespace are cleaned and trimmed', () {
      final result = service.cleanResponse(
        '  <|im_start|>assistant\nNya~!<|im_end|>  ',
      );
      expect(result, equals('assistant\nNya~!'));
    });
  });
}
