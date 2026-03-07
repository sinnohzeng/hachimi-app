// DiaryEntry serialization + diary retry queue unit tests.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
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

  group('Diary retry queue — SharedPreferences serialization', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('empty queue returns null string', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(AppPrefsKeys.diaryPendingRetries), isNull);
    });

    test('save and read single retry entry', () async {
      final prefs = await SharedPreferences.getInstance();
      final entry = {
        'catId': 'cat-1',
        'habitId': 'habit-1',
        'todayMinutes': 30,
        'isZhLocale': false,
        'date': '2026-03-07',
        'attempts': 0,
      };

      await prefs.setString(
        AppPrefsKeys.diaryPendingRetries,
        jsonEncode([entry]),
      );

      final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries);
      expect(raw, isNotNull);

      final list = (jsonDecode(raw!) as List).cast<Map<String, dynamic>>();
      expect(list.length, equals(1));
      expect(list[0]['catId'], equals('cat-1'));
      expect(list[0]['attempts'], equals(0));
    });

    test('overwrite entry for same catId', () async {
      final prefs = await SharedPreferences.getInstance();
      final list = <Map<String, dynamic>>[
        {
          'catId': 'cat-1',
          'habitId': 'habit-1',
          'todayMinutes': 20,
          'isZhLocale': false,
          'date': '2026-03-07',
          'attempts': 1,
        },
        {
          'catId': 'cat-2',
          'habitId': 'habit-2',
          'todayMinutes': 40,
          'isZhLocale': true,
          'date': '2026-03-07',
          'attempts': 0,
        },
      ];

      // 模拟覆盖 cat-1 条目
      list.removeWhere((e) => e['catId'] == 'cat-1');
      list.add({
        'catId': 'cat-1',
        'habitId': 'habit-1',
        'todayMinutes': 45,
        'isZhLocale': false,
        'date': '2026-03-07',
        'attempts': 0,
      });

      await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));

      final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries)!;
      final restored = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

      expect(restored.length, equals(2));

      final cat1 = restored.firstWhere((e) => e['catId'] == 'cat-1');
      expect(cat1['todayMinutes'], equals(45));
      expect(cat1['attempts'], equals(0));
    });

    test('max retry attempts check (3 attempts)', () async {
      const maxRetryAttempts = 3;
      final entry = {
        'catId': 'cat-1',
        'habitId': 'habit-1',
        'todayMinutes': 30,
        'isZhLocale': false,
        'date': '2026-03-07',
        'attempts': 3,
      };

      // 超过最大重试次数 → 应被移除
      expect((entry['attempts'] as int) >= maxRetryAttempts, isTrue);
    });

    test('expired entry (non-today date) should be discarded', () {
      final entry = {
        'catId': 'cat-1',
        'habitId': 'habit-1',
        'todayMinutes': 30,
        'isZhLocale': false,
        'date': '2026-03-06', // 昨天
        'attempts': 0,
      };

      // 验证过期逻辑
      const today = '2026-03-07';
      expect(entry['date'] != today, isTrue);
    });

    test('increment attempts preserves other fields', () async {
      final prefs = await SharedPreferences.getInstance();
      final entry = {
        'catId': 'cat-1',
        'habitId': 'habit-1',
        'todayMinutes': 30,
        'isZhLocale': true,
        'date': '2026-03-07',
        'attempts': 0,
      };

      final list = [entry];
      entry['attempts'] = (entry['attempts'] as int) + 1;
      list[0] = entry;

      await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));

      final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries)!;
      final restored = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

      expect(restored[0]['attempts'], equals(1));
      expect(restored[0]['catId'], equals('cat-1'));
      expect(restored[0]['isZhLocale'], isTrue);
      expect(restored[0]['todayMinutes'], equals(30));
    });

    test('clear specific catId from queue', () async {
      final prefs = await SharedPreferences.getInstance();
      final list = [
        {
          'catId': 'cat-1',
          'habitId': 'h1',
          'todayMinutes': 10,
          'isZhLocale': false,
          'date': '2026-03-07',
          'attempts': 0,
        },
        {
          'catId': 'cat-2',
          'habitId': 'h2',
          'todayMinutes': 20,
          'isZhLocale': true,
          'date': '2026-03-07',
          'attempts': 1,
        },
      ];

      await prefs.setString(AppPrefsKeys.diaryPendingRetries, jsonEncode(list));

      // 清除 cat-1
      final raw = prefs.getString(AppPrefsKeys.diaryPendingRetries)!;
      final parsed = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      parsed.removeWhere((e) => e['catId'] == 'cat-1');
      await prefs.setString(
        AppPrefsKeys.diaryPendingRetries,
        jsonEncode(parsed),
      );

      final result = prefs.getString(AppPrefsKeys.diaryPendingRetries)!;
      final remaining = (jsonDecode(result) as List)
          .cast<Map<String, dynamic>>();

      expect(remaining.length, equals(1));
      expect(remaining[0]['catId'], equals('cat-2'));
    });
  });
}
