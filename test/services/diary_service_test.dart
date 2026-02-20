// ---
// 📘 文件说明：
// DiaryEntry 单元测试 — 验证日记条目序列化 roundtrip。
//
// 🧩 文件结构：
// - toMap / fromMap roundtrip
// - 字段名映射 (camelCase → snake_case)
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/diary_entry.dart';

void main() {
  group('DiaryEntry — toMap / fromMap roundtrip', () {
    test('all fields round-trip correctly', () {
      final now = DateTime(2026, 2, 20, 10, 30, 0);
      final entry = DiaryEntry(
        id: 'test-id',
        catId: 'cat-1',
        habitId: 'habit-1',
        content: 'Dear diary, today was fun!',
        date: '2026-02-20',
        personality: 'playful',
        mood: 'happy',
        stage: 'kitten',
        totalMinutes: 120,
        createdAt: now,
      );

      final map = entry.toMap();

      // 验证 snake_case key 映射
      expect(map['id'], equals('test-id'));
      expect(map['cat_id'], equals('cat-1'));
      expect(map['habit_id'], equals('habit-1'));
      expect(map['content'], equals('Dear diary, today was fun!'));
      expect(map['date'], equals('2026-02-20'));
      expect(map['personality'], equals('playful'));
      expect(map['mood'], equals('happy'));
      expect(map['stage'], equals('kitten'));
      expect(map['total_minutes'], equals(120));
      expect(map['created_at'], equals(now.millisecondsSinceEpoch));

      final restored = DiaryEntry.fromMap(map);
      expect(restored.id, equals(entry.id));
      expect(restored.catId, equals(entry.catId));
      expect(restored.habitId, equals(entry.habitId));
      expect(restored.content, equals(entry.content));
      expect(restored.date, equals(entry.date));
      expect(restored.personality, equals(entry.personality));
      expect(restored.mood, equals(entry.mood));
      expect(restored.stage, equals(entry.stage));
      expect(restored.totalMinutes, equals(entry.totalMinutes));
      expect(restored.createdAt, equals(now));
    });

    test('zero totalMinutes is preserved', () {
      final entry = DiaryEntry(
        id: 'e1',
        catId: 'c1',
        habitId: 'h1',
        content: 'test',
        date: '2026-02-20',
        personality: 'lazy',
        mood: 'neutral',
        stage: 'adolescent',
        totalMinutes: 0,
        createdAt: DateTime(2026, 1, 1),
      );

      final restored = DiaryEntry.fromMap(entry.toMap());
      expect(restored.totalMinutes, equals(0));
    });

    test('long content is preserved', () {
      final longContent = 'A' * 5000;
      final entry = DiaryEntry(
        id: 'e2',
        catId: 'c1',
        habitId: 'h1',
        content: longContent,
        date: '2026-02-20',
        personality: 'playful',
        mood: 'happy',
        stage: 'kitten',
        totalMinutes: 60,
        createdAt: DateTime.now(),
      );

      final restored = DiaryEntry.fromMap(entry.toMap());
      expect(restored.content.length, equals(5000));
    });
  });
}
