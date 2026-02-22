// ---
// XpService 单元测试 — 验证 XP 计算逻辑（base / fullHouse）和固定阶梯阶段检测。
//
// 🧩 文件结构：
// - base XP 计算（minutes x 1）；
// - fullHouse bonus（+10）；
// - xpMultiplier 乘数应用；
// - checkStageUp 固定阶梯（0/20/100/200h）；
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/services/xp_service.dart';

void main() {
  late XpService xpService;

  setUp(() {
    xpService = XpService();
  });

  group('XpService.calculateXp - base XP', () {
    test('base XP equals minutes focused', () {
      final result = xpService.calculateXp(minutes: 25, allHabitsDone: false);

      expect(result.baseXp, equals(25));
    });

    test('0 minutes yields 0 base XP', () {
      final result = xpService.calculateXp(minutes: 0, allHabitsDone: false);

      expect(result.baseXp, equals(0));
      expect(result.totalXp, equals(0));
    });

    test('total XP equals base XP when no bonuses apply', () {
      final result = xpService.calculateXp(minutes: 30, allHabitsDone: false);

      expect(result.baseXp, equals(30));
      expect(result.fullHouseBonus, equals(0));
      expect(result.totalXp, equals(30));
    });
  });

  group('XpService.calculateXp - full house bonus', () {
    test('+10 when all habits done today', () {
      final result = xpService.calculateXp(minutes: 25, allHabitsDone: true);

      expect(result.fullHouseBonus, equals(10));
      expect(result.totalXp, equals(35)); // 25 + 10
    });

    test('no full house bonus when not all habits done', () {
      final result = xpService.calculateXp(minutes: 25, allHabitsDone: false);

      expect(result.fullHouseBonus, equals(0));
    });
  });

  group('XpService.calculateXp - xpMultiplier', () {
    test('multiplier of 2.0 doubles total XP', () {
      final result = xpService.calculateXp(
        minutes: 25,
        allHabitsDone: false,
        xpMultiplier: 2.0,
      );

      expect(result.totalXp, equals(50)); // 25 * 2.0
    });

    test('default multiplier is 1.0', () {
      final result = xpService.calculateXp(minutes: 25, allHabitsDone: false);

      expect(result.totalXp, equals(25));
    });

    test('multiplier of 1.5 with full house bonus', () {
      final result = xpService.calculateXp(
        minutes: 25,
        allHabitsDone: true,
        xpMultiplier: 1.5,
      );
      // raw = 25 + 10 = 35, * 1.5 = 52.5 → 53
      expect(result.totalXp, equals(53));
    });
  });

  group('XpService.checkStageUp (fixed 200h ladder)', () {
    test('no stage up within same stage', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 100,
        newTotalMinutes: 500,
      );

      expect(result.didStageUp, isFalse);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('kitten'));
    });

    test('stage up from kitten to adolescent at 20h (1200 min)', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 1100,
        newTotalMinutes: 1300,
      );

      expect(result.didStageUp, isTrue);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('adolescent'));
    });

    test('stage up from adolescent to adult at 100h (6000 min)', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 5900,
        newTotalMinutes: 6100,
      );

      expect(result.didStageUp, isTrue);
      expect(result.oldStage, equals('adolescent'));
      expect(result.newStage, equals('adult'));
    });

    test('stage up from adult to senior at 200h (12000 min)', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 11900,
        newTotalMinutes: 12100,
      );

      expect(result.didStageUp, isTrue);
      expect(result.oldStage, equals('adult'));
      expect(result.newStage, equals('senior'));
    });

    test('no stage up at 0 minutes', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 0,
        newTotalMinutes: 0,
      );

      expect(result.didStageUp, isFalse);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('kitten'));
    });
  });
}
