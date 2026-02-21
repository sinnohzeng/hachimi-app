// ---
// FocusSession 模型单元测试 — 验证 toFirestore() 输出格式和字段正确性。
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
        status: 'completed',
        coinsEarned: 250,
      );

      final map = session.toFirestore();

      expect(map, contains('habitId'));
      expect(map, contains('catId'));
      expect(map, contains('startedAt'));
      expect(map, contains('endedAt'));
      expect(map, contains('durationMinutes'));
      expect(map, contains('targetDurationMinutes'));
      expect(map, contains('pausedSeconds'));
      expect(map, contains('status'));
      expect(map, contains('completionRatio'));
      expect(map, contains('xpEarned'));
      expect(map, contains('mode'));
      expect(map, contains('coinsEarned'));
      expect(map, contains('clientVersion'));
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
        targetDurationMinutes: 25,
        pausedSeconds: 30,
        xpEarned: 30,
        mode: 'countdown',
        status: 'completed',
        completionRatio: 1.0,
        coinsEarned: 250,
        clientVersion: '2.7.0',
      );

      final map = session.toFirestore();

      expect(map['habitId'], equals('habit-1'));
      expect(map['catId'], equals('cat-1'));
      expect(map['durationMinutes'], equals(25));
      expect(map['targetDurationMinutes'], equals(25));
      expect(map['pausedSeconds'], equals(30));
      expect(map['status'], equals('completed'));
      expect(map['completionRatio'], equals(1.0));
      expect(map['xpEarned'], equals(30));
      expect(map['mode'], equals('countdown'));
      expect(map['coinsEarned'], equals(250));
      expect(map['clientVersion'], equals('2.7.0'));
      expect(map['startedAt'], isA<Timestamp>());
      expect(map['endedAt'], isA<Timestamp>());
    });

    test('abandoned session serializes status correctly', () {
      final session = FocusSession(
        id: 'session-2',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19, 10, 0),
        endedAt: DateTime(2026, 2, 19, 10, 3),
        durationMinutes: 3,
        xpEarned: 0,
        mode: 'stopwatch',
        status: 'abandoned',
      );

      final map = session.toFirestore();

      expect(map['status'], equals('abandoned'));
      expect(map['mode'], equals('stopwatch'));
      expect(session.isCompleted, isFalse);
      expect(session.isAbandoned, isTrue);
    });

    test('does not include id in toFirestore output', () {
      final session = FocusSession(
        id: 'session-3',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 10),
        durationMinutes: 10,
        xpEarned: 10,
        mode: 'countdown',
        status: 'completed',
      );

      final map = session.toFirestore();

      // Firestore doc ID is managed by Firestore, not in the map
      expect(map.containsKey('id'), isFalse);
    });

    test('checksum is excluded when null', () {
      final session = FocusSession(
        id: 'session-4',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 25),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        status: 'completed',
      );

      final map = session.toFirestore();
      expect(map.containsKey('checksum'), isFalse);
    });

    test('checksum is included when present', () {
      final session = FocusSession(
        id: 'session-5',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 25),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        status: 'completed',
        checksum: 'abc123',
      );

      final map = session.toFirestore();
      expect(map['checksum'], equals('abc123'));
    });
  });

  group('FocusSession.durationMinutes', () {
    test('stores correct value', () {
      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 45),
        durationMinutes: 45,
        xpEarned: 45,
        mode: 'countdown',
        status: 'completed',
      );

      expect(session.durationMinutes, equals(45));
    });

    test('default coinsEarned is 0', () {
      final session = FocusSession(
        id: 'session-1',
        habitId: 'habit-1',
        catId: 'cat-1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 25),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        status: 'completed',
      );

      expect(session.coinsEarned, equals(0));
    });
  });

  group('FocusSession convenience getters', () {
    test('isCompleted returns true for completed status', () {
      final session = FocusSession(
        id: 's1',
        habitId: 'h1',
        catId: 'c1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 25),
        durationMinutes: 25,
        xpEarned: 25,
        mode: 'countdown',
        status: 'completed',
      );

      expect(session.isCompleted, isTrue);
      expect(session.isAbandoned, isFalse);
    });

    test('isAbandoned returns true for abandoned status', () {
      final session = FocusSession(
        id: 's2',
        habitId: 'h1',
        catId: 'c1',
        startedAt: DateTime(2026, 2, 19),
        endedAt: DateTime(2026, 2, 19, 0, 5),
        durationMinutes: 5,
        xpEarned: 0,
        mode: 'countdown',
        status: 'abandoned',
      );

      expect(session.isAbandoned, isTrue);
      expect(session.isCompleted, isFalse);
    });
  });
}
