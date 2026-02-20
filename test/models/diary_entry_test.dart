// ---
// 📘 文件说明：
// DiaryEntry 模型单元测试 — 验证 toMap() / fromMap() 往返一致性。
//
// 🧩 文件结构：
// - toMap() / fromMap() 往返测试；
// - toMap() 输出键值验证；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/diary_entry.dart';

void main() {
  group('DiaryEntry toMap() / fromMap() round-trip', () {
    test('round-trip preserves all fields', () {
      final original = DiaryEntry(
        id: 'diary-001',
        catId: 'cat-1',
        habitId: 'habit-1',
        content: 'Today we practiced reading together. Mochi was very focused!',
        date: '2026-02-19',
        personality: 'curious',
        mood: 'happy',
        stage: 'adolescent',
        totalMinutes: 350,
        createdAt: DateTime(2026, 2, 19, 22, 0),
      );

      final map = original.toMap();
      final restored = DiaryEntry.fromMap(map);

      expect(restored.id, equals(original.id));
      expect(restored.catId, equals(original.catId));
      expect(restored.habitId, equals(original.habitId));
      expect(restored.content, equals(original.content));
      expect(restored.date, equals(original.date));
      expect(restored.personality, equals(original.personality));
      expect(restored.mood, equals(original.mood));
      expect(restored.stage, equals(original.stage));
      expect(restored.totalMinutes, equals(original.totalMinutes));
      expect(
        restored.createdAt.millisecondsSinceEpoch,
        equals(original.createdAt.millisecondsSinceEpoch),
      );
    });

    test('toMap() produces correct key names (snake_case)', () {
      final entry = DiaryEntry(
        id: 'diary-002',
        catId: 'cat-2',
        habitId: 'habit-2',
        content: 'A quiet day.',
        date: '2026-02-18',
        personality: 'shy',
        mood: 'neutral',
        stage: 'kitten',
        totalMinutes: 60,
        createdAt: DateTime(2026, 2, 18, 20, 0),
      );

      final map = entry.toMap();

      // 验证 snake_case 键名
      expect(map, contains('id'));
      expect(map, contains('cat_id'));
      expect(map, contains('habit_id'));
      expect(map, contains('content'));
      expect(map, contains('date'));
      expect(map, contains('personality'));
      expect(map, contains('mood'));
      expect(map, contains('stage'));
      expect(map, contains('total_minutes'));
      expect(map, contains('created_at'));
    });

    test('toMap() values are of correct types', () {
      final entry = DiaryEntry(
        id: 'diary-003',
        catId: 'cat-1',
        habitId: 'habit-1',
        content: 'Testing types.',
        date: '2026-02-19',
        personality: 'brave',
        mood: 'happy',
        stage: 'adult',
        totalMinutes: 500,
        createdAt: DateTime(2026, 2, 19, 12, 0),
      );

      final map = entry.toMap();

      expect(map['id'], isA<String>());
      expect(map['cat_id'], isA<String>());
      expect(map['habit_id'], isA<String>());
      expect(map['content'], isA<String>());
      expect(map['date'], isA<String>());
      expect(map['personality'], isA<String>());
      expect(map['mood'], isA<String>());
      expect(map['stage'], isA<String>());
      expect(map['total_minutes'], isA<int>());
      expect(map['created_at'], isA<int>());
    });

    test('round-trip with different personality and mood values', () {
      final entries = [
        ('lazy', 'missing', 'senior'),
        ('playful', 'lonely', 'kitten'),
        ('clingy', 'happy', 'adult'),
      ];

      for (final (personality, mood, stage) in entries) {
        final original = DiaryEntry(
          id: 'diary-$personality',
          catId: 'cat-1',
          habitId: 'habit-1',
          content: 'Entry for $personality cat.',
          date: '2026-02-19',
          personality: personality,
          mood: mood,
          stage: stage,
          totalMinutes: 100,
          createdAt: DateTime(2026, 2, 19),
        );

        final restored = DiaryEntry.fromMap(original.toMap());
        expect(restored.personality, equals(personality));
        expect(restored.mood, equals(mood));
        expect(restored.stage, equals(stage));
      }
    });
  });
}
