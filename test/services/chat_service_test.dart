// ---
// 📘 文件说明：
// ChatMessage 与 ChatRole 单元测试 — 验证聊天消息序列化和角色解析。
//
// 🧩 文件结构：
// - ChatRole 枚举: value, fromString
// - ChatMessage: toMap / fromMap roundtrip
// - ChatService.maxHistoryMessages 常量
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/chat_message.dart';
import 'package:hachimi_app/services/chat_service.dart';

void main() {
  group('ChatRole — value & fromString', () {
    test('user role value is "user"', () {
      expect(ChatRole.user.value, equals('user'));
    });

    test('assistant role value is "assistant"', () {
      expect(ChatRole.assistant.value, equals('assistant'));
    });

    test('fromString parses "user"', () {
      expect(ChatRole.fromString('user'), equals(ChatRole.user));
    });

    test('fromString parses "assistant"', () {
      expect(ChatRole.fromString('assistant'), equals(ChatRole.assistant));
    });

    test('fromString defaults to assistant for unknown', () {
      expect(ChatRole.fromString('unknown'), equals(ChatRole.assistant));
      expect(ChatRole.fromString(''), equals(ChatRole.assistant));
    });
  });

  group('ChatMessage — toMap / fromMap roundtrip', () {
    test('user message roundtrips correctly', () {
      final now = DateTime(2026, 2, 20, 12, 0, 0);
      final msg = ChatMessage(
        id: 'msg-1',
        catId: 'cat-1',
        role: ChatRole.user,
        content: 'Hello kitty!',
        createdAt: now,
      );

      final map = msg.toMap();
      expect(map['id'], equals('msg-1'));
      expect(map['cat_id'], equals('cat-1'));
      expect(map['role'], equals('user'));
      expect(map['content'], equals('Hello kitty!'));
      expect(map['created_at'], equals(now.millisecondsSinceEpoch));

      final restored = ChatMessage.fromMap(map);
      expect(restored.id, equals(msg.id));
      expect(restored.catId, equals(msg.catId));
      expect(restored.role, equals(ChatRole.user));
      expect(restored.content, equals(msg.content));
      expect(restored.createdAt, equals(now));
    });

    test('assistant message roundtrips correctly', () {
      final msg = ChatMessage(
        id: 'msg-2',
        catId: 'cat-1',
        role: ChatRole.assistant,
        content: 'Meow~ *purrs*',
        createdAt: DateTime(2026, 2, 20),
      );

      final map = msg.toMap();
      expect(map['role'], equals('assistant'));

      final restored = ChatMessage.fromMap(map);
      expect(restored.role, equals(ChatRole.assistant));
      expect(restored.content, equals('Meow~ *purrs*'));
    });
  });

  group('ChatService — constants', () {
    test('maxHistoryMessages is 20', () {
      expect(ChatService.maxHistoryMessages, equals(20));
    });
  });
}
