// ---
// LedgerAction 单元测试 — 验证 ActionType 枚举往返、LedgerAction 序列化/反序列化、
// 以及防御性 fromSqliteSafe 对损坏数据的处理。
//
// 纯单元测试，无数据库依赖。
// ---

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/ledger_action.dart';

void main() {
  group('ActionType.fromValue', () {
    test('all enum values round-trip correctly', () {
      for (final type in ActionType.values) {
        expect(
          ActionType.fromValue(type.value),
          equals(type),
          reason: '${type.name} should round-trip via value "${type.value}"',
        );
      }
    });

    test('unknown value throws ArgumentError', () {
      expect(
        () => ActionType.fromValue('nonexistent_action'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('empty string throws ArgumentError', () {
      expect(() => ActionType.fromValue(''), throwsA(isA<ArgumentError>()));
    });
  });

  group('ActionType properties', () {
    test('isHabitAction returns true for habit actions only', () {
      const habitActions = [
        ActionType.habitCreate,
        ActionType.habitUpdate,
        ActionType.habitDelete,
        ActionType.habitRestore,
      ];
      for (final type in ActionType.values) {
        expect(
          type.isHabitAction,
          habitActions.contains(type),
          reason: '${type.name}.isHabitAction',
        );
      }
    });

    test('isWorryAction returns true for worry actions only', () {
      const worryActions = [
        ActionType.worryCreated,
        ActionType.worryUpdated,
        ActionType.worryResolved,
        ActionType.worryDeleted,
      ];
      for (final type in ActionType.values) {
        expect(
          type.isWorryAction,
          worryActions.contains(type),
          reason: '${type.name}.isWorryAction',
        );
      }
    });
  });

  group('LedgerAction.toSqlite / fromSqlite', () {
    final now = DateTime(2026, 3, 17, 10, 30, 0);
    final action = LedgerAction(
      id: 'test-id-001',
      type: ActionType.focusComplete,
      uid: 'user-abc',
      startedAt: now,
      endedAt: now.add(const Duration(minutes: 25)),
      payload: {'habitId': 'h1', 'minutes': 25},
      result: {'coins': 250, 'xp': 25},
      synced: 1,
      syncedAt: now.add(const Duration(seconds: 30)),
      syncAttempts: 1,
      syncError: null,
      createdAt: now,
    );

    test('round-trip preserves all fields', () {
      final map = action.toSqlite();
      final restored = LedgerAction.fromSqlite(map);

      expect(restored.id, equals(action.id));
      expect(restored.type, equals(action.type));
      expect(restored.uid, equals(action.uid));
      expect(restored.startedAt, equals(action.startedAt));
      expect(restored.endedAt, equals(action.endedAt));
      expect(restored.payload, equals(action.payload));
      expect(restored.result, equals(action.result));
      expect(restored.synced, equals(action.synced));
      expect(restored.syncedAt, equals(action.syncedAt));
      expect(restored.syncAttempts, equals(action.syncAttempts));
      expect(restored.syncError, isNull);
      expect(restored.createdAt, equals(action.createdAt));
    });

    test('toSqlite encodes payload and result as JSON strings', () {
      final map = action.toSqlite();
      expect(map['payload'], isA<String>());
      expect(map['result'], isA<String>());
      expect(jsonDecode(map['payload'] as String), equals(action.payload));
      expect(jsonDecode(map['result'] as String), equals(action.result));
    });

    test('fromSqlite handles null optional fields', () {
      final minimalMap = {
        'id': 'min-id',
        'type': 'check_in',
        'uid': 'user-1',
        'started_at': now.millisecondsSinceEpoch,
        'ended_at': null,
        'payload': '{}',
        'result': '{}',
        'synced': null,
        'synced_at': null,
        'sync_attempts': null,
        'sync_error': null,
        'created_at': now.millisecondsSinceEpoch,
      };

      final restored = LedgerAction.fromSqlite(minimalMap);
      expect(restored.endedAt, isNull);
      expect(restored.synced, equals(0));
      expect(restored.syncedAt, isNull);
      expect(restored.syncAttempts, equals(0));
    });
  });

  group('LedgerAction.fromSqliteSafe', () {
    test('corrupted data returns null', () {
      expect(LedgerAction.fromSqliteSafe({'garbage': true}), isNull);
    });

    test('missing required field returns null', () {
      // 缺少 id 字段
      expect(
        LedgerAction.fromSqliteSafe({
          'type': 'check_in',
          'uid': 'u1',
          'started_at': 1000000,
          'created_at': 1000000,
        }),
        isNull,
      );
    });

    test('invalid action type returns null', () {
      expect(
        LedgerAction.fromSqliteSafe({
          'id': 'x',
          'type': 'invalid_type',
          'uid': 'u1',
          'started_at': 1000000,
          'created_at': 1000000,
        }),
        isNull,
      );
    });

    test('valid data returns LedgerAction', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final result = LedgerAction.fromSqliteSafe({
        'id': 'valid-id',
        'type': 'check_in',
        'uid': 'u1',
        'started_at': now,
        'created_at': now,
        'payload': '{}',
        'result': '{}',
      });
      expect(result, isNotNull);
      expect(result!.type, equals(ActionType.checkIn));
    });
  });

  group('LedgerChange', () {
    test('isGlobalRefresh true only for hydrate', () {
      expect(
        const LedgerChange(type: ActionType.hydrate).isGlobalRefresh,
        isTrue,
      );
      expect(
        const LedgerChange(type: ActionType.checkIn).isGlobalRefresh,
        isFalse,
      );
    });

    test('affectedIds defaults to empty list', () {
      const change = LedgerChange(type: ActionType.checkIn);
      expect(change.affectedIds, isEmpty);
    });
  });
}
