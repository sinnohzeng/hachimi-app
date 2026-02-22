// ---
// 📘 文件说明：
// XpService 单元测试 — 验证 XP 计算逻辑（base / streak / milestone / fullHouse）。
//
// 🧩 文件结构：
// - base XP 计算（minutes x 1）；
// - streak bonus 计算（streak >= 3 ? +5 : 0）；
// - milestone bonus 触发（7/14/30 天 → +30）；
// - fullHouse bonus（+10）；
// - xpMultiplier 乘数应用；
//
// 🕒 创建时间：2026-02-19
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
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 0,
        allHabitsDone: false,
      );

      expect(result.baseXp, equals(25));
    });

    test('0 minutes yields 0 base XP', () {
      final result = xpService.calculateXp(
        minutes: 0,
        streakDays: 0,
        allHabitsDone: false,
      );

      expect(result.baseXp, equals(0));
      expect(result.totalXp, equals(0));
    });

    test('total XP equals base XP when no bonuses apply', () {
      final result = xpService.calculateXp(
        minutes: 30,
        streakDays: 1,
        allHabitsDone: false,
      );

      expect(result.baseXp, equals(30));
      expect(result.streakBonus, equals(0));
      expect(result.milestoneBonus, equals(0));
      expect(result.fullHouseBonus, equals(0));
      expect(result.totalXp, equals(30));
    });
  });

  group('XpService.calculateXp - streak bonus', () {
    test('no streak bonus when streak < 3', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 2,
        allHabitsDone: false,
      );

      expect(result.streakBonus, equals(0));
    });

    test('+5 streak bonus when streak == 3', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 3,
        allHabitsDone: false,
      );

      expect(result.streakBonus, equals(5));
      expect(result.totalXp, equals(30)); // 25 + 5
    });

    test('+5 streak bonus when streak > 3', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 10,
        allHabitsDone: false,
      );

      expect(result.streakBonus, equals(5));
    });
  });

  group('XpService.calculateXp - milestone bonus', () {
    test('+30 milestone bonus at 7-day streak', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 7,
        allHabitsDone: false,
      );

      expect(result.milestoneBonus, equals(30));
      // 25 base + 5 streak + 30 milestone = 60
      expect(result.totalXp, equals(60));
    });

    test('+30 milestone bonus at 14-day streak', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 14,
        allHabitsDone: false,
      );

      expect(result.milestoneBonus, equals(30));
    });

    test('+30 milestone bonus at 30-day streak', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 30,
        allHabitsDone: false,
      );

      expect(result.milestoneBonus, equals(30));
    });

    test('no milestone bonus at non-milestone streaks', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 8,
        allHabitsDone: false,
      );

      expect(result.milestoneBonus, equals(0));
    });

    test('no milestone bonus at streak 6', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 6,
        allHabitsDone: false,
      );

      expect(result.milestoneBonus, equals(0));
    });
  });

  group('XpService.calculateXp - full house bonus', () {
    test('+10 when all habits done today', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 1,
        allHabitsDone: true,
      );

      expect(result.fullHouseBonus, equals(10));
      expect(result.totalXp, equals(35)); // 25 + 10
    });

    test('no full house bonus when not all habits done', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 1,
        allHabitsDone: false,
      );

      expect(result.fullHouseBonus, equals(0));
    });
  });

  group('XpService.calculateXp - xpMultiplier', () {
    test('multiplier of 2.0 doubles total XP', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 0,
        allHabitsDone: false,
        xpMultiplier: 2.0,
      );

      expect(result.totalXp, equals(50)); // 25 * 2.0
    });

    test('default multiplier is 1.0', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 0,
        allHabitsDone: false,
      );

      expect(result.totalXp, equals(25));
    });

    test('multiplier of 1.5 rounds correctly', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 3,
        allHabitsDone: true,
      );
      // raw = 25 + 5 + 0 + 10 = 40
      expect(result.totalXp, equals(40));

      final multiplied = xpService.calculateXp(
        minutes: 25,
        streakDays: 3,
        allHabitsDone: true,
        xpMultiplier: 1.5,
      );
      // raw = 40, * 1.5 = 60
      expect(multiplied.totalXp, equals(60));
    });
  });

  group('XpService.calculateXp - combined scenarios', () {
    test('all bonuses active at 7-day streak with full house', () {
      final result = xpService.calculateXp(
        minutes: 25,
        streakDays: 7,
        allHabitsDone: true,
      );

      expect(result.baseXp, equals(25));
      expect(result.streakBonus, equals(5));
      expect(result.milestoneBonus, equals(30));
      expect(result.fullHouseBonus, equals(10));
      // 25 + 5 + 30 + 10 = 70
      expect(result.totalXp, equals(70));
    });
  });

  group('XpService.checkStageUp', () {
    test('no stage up within same stage', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 100,
        newTotalMinutes: 150,
        targetMinutes: 1000,
      );

      expect(result.didStageUp, isFalse);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('kitten'));
    });

    test('stage up from kitten to adolescent at 33%', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 320,
        newTotalMinutes: 340,
        targetMinutes: 1000,
      );

      expect(result.didStageUp, isTrue);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('adolescent'));
    });

    test('targetMinutes == 0 returns kitten with no stage up', () {
      final result = xpService.checkStageUp(
        oldTotalMinutes: 100,
        newTotalMinutes: 200,
        targetMinutes: 0,
      );

      expect(result.didStageUp, isFalse);
      expect(result.oldStage, equals('kitten'));
      expect(result.newStage, equals('kitten'));
    });
  });
}
