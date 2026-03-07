// ChatService unit tests — ChatRole, ChatMessage serialization,
// constants, and getRemainingMessages boundary conditions.

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
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

    test('recentMessagesFetchLimit is 50', () {
      expect(ChatService.recentMessagesFetchLimit, equals(50));
    });
  });

  group('AiConstants.chatDailyLimit', () {
    test('daily limit is 5', () {
      expect(AiConstants.chatDailyLimit, equals(5));
    });
  });

  group('getRemainingMessages — boundary logic', () {
    // Tests the clamping arithmetic: (limit - sent).clamp(0, limit)
    // where limit = AiConstants.chatDailyLimit = 5.
    const limit = AiConstants.chatDailyLimit;

    test('0 sent → 5 remaining', () {
      expect((limit - 0).clamp(0, limit), equals(5));
    });

    test('1 sent → 4 remaining', () {
      expect((limit - 1).clamp(0, limit), equals(4));
    });

    test('4 sent → 1 remaining', () {
      expect((limit - 4).clamp(0, limit), equals(1));
    });

    test('5 sent → 0 remaining (at limit)', () {
      expect((limit - 5).clamp(0, limit), equals(0));
    });

    test('6 sent → 0 remaining (clamp prevents negative)', () {
      expect((limit - 6).clamp(0, limit), equals(0));
    });

    test('100 sent → 0 remaining (far exceeds limit)', () {
      expect((limit - 100).clamp(0, limit), equals(0));
    });
  });
}
