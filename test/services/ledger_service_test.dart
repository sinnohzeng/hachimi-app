// ---
// LedgerService 变更广播契约测试。
//
// LedgerService 构造需要 LocalDatabaseService（依赖 sqflite 平台通道），
// 因此无法在纯单元测试中实例化。本文件测试两件事：
// 1. FakeLedgerService 的广播契约（验证消费者依赖的接口行为）
// 2. LedgerChange 语义属性
//
// 真实 LedgerService 的 SQLite 操作需要 integration_test 覆盖。
// ---

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/ledger_action.dart';

import '../helpers/fakes.dart';

void main() {
  group('LedgerService broadcast contract (via FakeLedgerService)', () {
    late FakeLedgerService ledger;

    setUp(() {
      ledger = FakeLedgerService();
    });

    test('changes stream is empty by default', () {
      // FakeLedgerService.changes 返回 Stream.empty()
      expectLater(ledger.changes, emitsDone);
    });

    test('notifyChange records the call', () {
      const change = LedgerChange(
        type: ActionType.focusComplete,
        affectedIds: ['session-1'],
      );
      ledger.notifyChange(change);

      expect(ledger.callLog, contains('notifyChange'));
      expect(ledger.notifiedChanges, hasLength(1));
      expect(ledger.notifiedChanges.first.type, ActionType.focusComplete);
      expect(ledger.notifiedChanges.first.affectedIds, ['session-1']);
    });

    test('multiple notifyChange calls are all recorded', () {
      ledger.notifyChange(const LedgerChange(type: ActionType.checkIn));
      ledger.notifyChange(const LedgerChange(type: ActionType.purchase));
      ledger.notifyChange(const LedgerChange(type: ActionType.hydrate));

      expect(ledger.notifiedChanges, hasLength(3));
      expect(
        ledger.notifiedChanges.map((c) => c.type).toList(),
        equals([ActionType.checkIn, ActionType.purchase, ActionType.hydrate]),
      );
    });
  });

  group('LedgerChange semantics', () {
    test('hydrate is the only global refresh type', () {
      for (final type in ActionType.values) {
        final change = LedgerChange(type: type);
        expect(
          change.isGlobalRefresh,
          equals(type == ActionType.hydrate),
          reason: '${type.name}.isGlobalRefresh',
        );
      }
    });
  });

  group('StreamController.broadcast behavior (contract verification)', () {
    // 验证 broadcast StreamController 的行为 — LedgerService 内部使用此模式
    test('broadcast stream supports multiple listeners', () async {
      final controller = StreamController<LedgerChange>.broadcast();
      addTearDown(controller.close);

      final results1 = <ActionType>[];
      final results2 = <ActionType>[];

      controller.stream.listen((c) => results1.add(c.type));
      controller.stream.listen((c) => results2.add(c.type));

      controller.add(const LedgerChange(type: ActionType.checkIn));
      controller.add(const LedgerChange(type: ActionType.focusComplete));

      // 让事件传播
      await Future<void>.delayed(Duration.zero);

      expect(results1, equals([ActionType.checkIn, ActionType.focusComplete]));
      expect(results2, equals([ActionType.checkIn, ActionType.focusComplete]));
    });

    test('late listener does not receive past events', () async {
      final controller = StreamController<LedgerChange>.broadcast();
      addTearDown(controller.close);

      controller.add(const LedgerChange(type: ActionType.checkIn));
      await Future<void>.delayed(Duration.zero);

      final lateResults = <ActionType>[];
      controller.stream.listen((c) => lateResults.add(c.type));

      controller.add(const LedgerChange(type: ActionType.purchase));
      await Future<void>.delayed(Duration.zero);

      // 迟到的监听者只收到 purchase，不会收到 checkIn
      expect(lateResults, equals([ActionType.purchase]));
    });
  });
}
