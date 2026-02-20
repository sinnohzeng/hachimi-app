// ---
// 📘 文件说明：
// HabitStats 单元测试 — 验证聚合统计计算属性。
//
// 🧩 文件结构：
// - HabitStats 构造: 默认值、自定义值
// - 计算属性: totalHoursLogged, remainingMinutes, overallProgress
// - 边界: 零 targetHours, 大数值, 超过目标
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/providers/stats_provider.dart';

void main() {
  group('HabitStats — defaults', () {
    test('default constructor has all zeros', () {
      const stats = HabitStats();
      expect(stats.totalHabits, equals(0));
      expect(stats.totalMinutesLogged, equals(0));
      expect(stats.longestStreak, equals(0));
      expect(stats.totalTargetHours, equals(0));
    });
  });

  group('HabitStats — totalHoursLogged & remainingMinutes', () {
    test('converts minutes to hours and remainder', () {
      const stats = HabitStats(totalMinutesLogged: 150);
      expect(stats.totalHoursLogged, equals(2));
      expect(stats.remainingMinutes, equals(30));
    });

    test('exact hour boundary has zero remainder', () {
      const stats = HabitStats(totalMinutesLogged: 120);
      expect(stats.totalHoursLogged, equals(2));
      expect(stats.remainingMinutes, equals(0));
    });

    test('less than one hour returns 0 hours', () {
      const stats = HabitStats(totalMinutesLogged: 45);
      expect(stats.totalHoursLogged, equals(0));
      expect(stats.remainingMinutes, equals(45));
    });

    test('zero minutes returns zeros', () {
      const stats = HabitStats(totalMinutesLogged: 0);
      expect(stats.totalHoursLogged, equals(0));
      expect(stats.remainingMinutes, equals(0));
    });
  });

  group('HabitStats — overallProgress', () {
    test('returns 0 when totalTargetHours is 0', () {
      const stats = HabitStats(
        totalMinutesLogged: 100,
        totalTargetHours: 0,
      );
      expect(stats.overallProgress, equals(0.0));
    });

    test('calculates progress ratio correctly', () {
      const stats = HabitStats(
        totalMinutesLogged: 300, // 5 hours
        totalTargetHours: 10, // 10 hours = 600 min
      );
      expect(stats.overallProgress, closeTo(0.5, 0.001));
    });

    test('clamps to 1.0 when exceeding target', () {
      const stats = HabitStats(
        totalMinutesLogged: 1200, // 20 hours
        totalTargetHours: 10, // 10 hours
      );
      expect(stats.overallProgress, equals(1.0));
    });

    test('exactly 100% progress', () {
      const stats = HabitStats(
        totalMinutesLogged: 600,
        totalTargetHours: 10,
      );
      expect(stats.overallProgress, closeTo(1.0, 0.001));
    });

    test('small progress value', () {
      const stats = HabitStats(
        totalMinutesLogged: 6, // 0.1 hours
        totalTargetHours: 100, // 100 hours
      );
      expect(stats.overallProgress, closeTo(0.001, 0.0005));
    });
  });
}
