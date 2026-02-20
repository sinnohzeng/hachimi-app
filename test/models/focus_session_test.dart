// ---
// 📘 文件说明：
// FocusSession 模型单元测试 — 验证 toFirestore() 输出格式和字段正确性。
//
// 🧩 文件结构：
// - toFirestore() 键值验证；
// - durationMinutes 字段验证；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/focus_session.dart';

void main() {
  group('FocusSession.toFirestore()', () {
    test('contains all expected keys', () {
      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19, 10, 0),
        endedAt: DateTime(2026, 2, 19, 10, 25),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        completed: true,
        coinsEarned: 250,
      );

      final map = session.toFirestore();

      expect(map, contains('habitId'));
      expect(map, contains('catId'));
      expect(map, contains('startedAt'));
      expect(map, contains('endedAt'));
      expect(map, contains('durationMinutes'));
      expect(map, contains('xpEarned'));
      expect(map, contains('mode'));
      expect(map, contains('completed'));
      expect(map, contains('coinsEarned'));
    });

    test('values are serialized correctly', () {
      final startTime = DateTime(2026, 2, 19, 10, 0);
      final endTime = DateTime(2026, 2, 19, 10, 25);

      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: startTime,
        endedAt: endTime,
        durationMinutes: 25,
        xpEarned: 30,
        mode: 'countdown',
        completed: true,
        coinsEarned: 250,
      );

      final map = session.toFirestore();

      expect(map['habitId'], equals('habit-1'));
      expect(map['catId'], equals('cat-1'));
      expect(map['durationMinutes'], equals(25));
      expect(map['xpEarned'], equals(30));
      expect(map['mode'], equals('countdown'));
      expect(map['completed'], isTrue);
      expect(map['coinsEarned'], equals(250));
      expect(map['startedAt'], isA<Timestamp>());
      expect(map['endedAt'], isA<Timestamp>());
    });

    test('endedAt is null when session has no end time', () {
      final session = FocusSession(
        id: 'session-2',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19, 10, 0),
        endedAt: null,
        durationMinutes: 0,
        xpEarned: 0,
        mode: 'stopwatch',
        completed: false,
      );

      final map = session.toFirestore();

      expect(map['endedAt'], isNull);
      expect(map['mode'], equals('stopwatch'));
      expect(map['completed'], isFalse);
    });

    test('does not include id in toFirestore output', () {
      final session = FocusSession(
        id: 'session-3',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        durationMinutes: 10,
        xpEarned: 10,
        mode: 'countdown',
        completed: true,
      );

      final map = session.toFirestore();

      // Firestore doc ID is managed by Firestore, not in the map
      expect(map.containsKey('id'), isFalse);
    });
  });

  group('FocusSession.durationMinutes', () {
    test('stores correct value', () {
      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        durationMinutes: 45,
        xpEarned: 45,
        mode: 'countdown',
        completed: true,
      );

      expect(session.durationMinutes, equals(45));
    });

    test('default coinsEarned is 0', () {
      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        completed: true,
      );

      expect(session.coinsEarned, equals(0));
    });
  });
}
