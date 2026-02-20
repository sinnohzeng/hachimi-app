// ---
// 📘 文件说明：
// ChatState 单元测试 — 验证聊天状态值对象的 copyWith 和默认值。
//
// 🧩 文件结构：
// - ChatState 默认值
// - ChatState.copyWith 行为
// - ChatStatus 枚举
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/providers/chat_provider.dart';

void main() {
  group('ChatStatus — enum values', () {
    test('has all expected values', () {
      expect(ChatStatus.values.length, equals(4));
      expect(ChatStatus.values, contains(ChatStatus.idle));
      expect(ChatStatus.values, contains(ChatStatus.loading));
      expect(ChatStatus.values, contains(ChatStatus.generating));
      expect(ChatStatus.values, contains(ChatStatus.error));
    });
  });

  group('ChatState — defaults', () {
    test('default state is idle with empty messages', () {
      const s = ChatState();
      expect(s.messages, isEmpty);
      expect(s.status, equals(ChatStatus.idle));
      expect(s.partialResponse, isEmpty);
      expect(s.error, isNull);
    });
  });

  group('ChatState — copyWith', () {
    test('preserves unmodified fields', () {
      const s = ChatState(status: ChatStatus.loading);
      final s2 = s.copyWith(partialResponse: 'hello');
      expect(s2.status, equals(ChatStatus.loading));
      expect(s2.partialResponse, equals('hello'));
      expect(s2.messages, isEmpty);
    });

    test('can set status to generating', () {
      const s = ChatState();
      final s2 = s.copyWith(status: ChatStatus.generating);
      expect(s2.status, equals(ChatStatus.generating));
    });

    test('can set error message', () {
      const s = ChatState();
      final s2 = s.copyWith(
        status: ChatStatus.error,
        error: 'Something failed',
      );
      expect(s2.status, equals(ChatStatus.error));
      expect(s2.error, equals('Something failed'));
    });

    test('error becomes null when not passed in copyWith', () {
      final s = const ChatState().copyWith(
        status: ChatStatus.error,
        error: 'old error',
      );
      expect(s.error, equals('old error'));

      // copyWith without error → error becomes null (explicit design)
      final s2 = s.copyWith(status: ChatStatus.idle);
      expect(s2.error, isNull);
    });

    test('partialResponse accumulates tokens', () {
      const s = ChatState(
        status: ChatStatus.generating,
        partialResponse: 'Hello',
      );
      final s2 = s.copyWith(partialResponse: '${s.partialResponse} world');
      expect(s2.partialResponse, equals('Hello world'));
    });
  });
}
