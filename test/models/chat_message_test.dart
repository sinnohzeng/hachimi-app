// ---
// 📘 文件说明：
// ChatMessage 模型单元测试 — 验证 toMap() / fromMap() 往返一致性和 ChatRole 序列化。
//
// 🧩 文件结构：
// - toMap() / fromMap() 往返测试；
// - ChatRole 枚举序列化/反序列化；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/chat_message.dart';

void main() {
  group('ChatMessage toMap() / fromMap() round-trip', () {
    test('user message round-trip preserves all fields', () {
      final original = ChatMessage(
        id: 'msg-001',
        catId: 'cat-1',
        role: ChatRole.user,
        content: 'Hello, kitty!',
        createdAt: DateTime(2026, 2, 19, 14, 30),
      );

      final map = original.toMap();
      final restored = ChatMessage.fromMap(map);

      expect(restored.id, equals(original.id));
      expect(restored.catId, equals(original.catId));
      expect(restored.role, equals(original.role));
      expect(restored.content, equals(original.content));
      expect(
        restored.createdAt.millisecondsSinceEpoch,
        equals(original.createdAt.millisecondsSinceEpoch),
      );
    });

    test('assistant message round-trip preserves all fields', () {
      final original = ChatMessage(
        id: 'msg-002',
        catId: 'cat-2',
        role: ChatRole.assistant,
        content: 'Nya~ Nice to meet you!',
        createdAt: DateTime(2026, 2, 19, 14, 31),
      );

      final map = original.toMap();
      final restored = ChatMessage.fromMap(map);

      expect(restored.id, equals(original.id));
      expect(restored.catId, equals(original.catId));
      expect(restored.role, equals(ChatRole.assistant));
      expect(restored.content, equals(original.content));
    });

    test('toMap() produces correct key-value pairs', () {
      final msg = ChatMessage(
        id: 'msg-003',
        catId: 'cat-1',
        role: ChatRole.user,
        content: 'Test content',
        createdAt: DateTime(2026, 2, 19, 10, 0),
      );

      final map = msg.toMap();

      expect(map['id'], equals('msg-003'));
      expect(map['cat_id'], equals('cat-1'));
      expect(map['role'], equals('user'));
      expect(map['content'], equals('Test content'));
      expect(map['created_at'], isA<int>());
    });
  });

  group('ChatRole enum serialization', () {
    test('user role value is "user"', () {
      expect(ChatRole.user.value, equals('user'));
    });

    test('assistant role value is "assistant"', () {
      expect(ChatRole.assistant.value, equals('assistant'));
    });

    test('fromString("user") returns ChatRole.user', () {
      expect(ChatRole.fromString('user'), equals(ChatRole.user));
    });

    test('fromString("assistant") returns ChatRole.assistant', () {
      expect(ChatRole.fromString('assistant'), equals(ChatRole.assistant));
    });

    test('fromString with unknown value defaults to assistant', () {
      expect(ChatRole.fromString('unknown'), equals(ChatRole.assistant));
      expect(ChatRole.fromString(''), equals(ChatRole.assistant));
      expect(ChatRole.fromString('system'), equals(ChatRole.assistant));
    });
  });
}
