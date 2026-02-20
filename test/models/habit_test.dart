// ---
// 📘 文件说明：
// Habit 模型单元测试 — 验证计算属性 progressPercent / progressText / isActive。
//
// 🧩 文件结构：
// - progressPercent 百分比计算；
// - progressText 格式化输出；
// - isActive 布尔值验证；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/habit.dart';

/// 创建一个测试用 Habit 实例。
Habit _createTestHabit({
  int totalMinutes = 0,
  int targetHours = 100,
  bool isActive = true,
}) {
  return Habit(
    id: 'test-habit-id',
    name: 'Reading',
    icon: '📚',
    targetHours: targetHours,
    totalMinutes: totalMinutes,
    isActive: isActive,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('Habit.progressPercent', () {
    test('returns 0 when totalMinutes is 0', () {
      final habit = _createTestHabit(totalMinutes: 0, targetHours: 100);
      expect(habit.progressPercent, equals(0.0));
    });

    test('returns correct ratio for normal values', () {
      // 3000 minutes / (100 hours * 60) = 3000 / 6000 = 0.5
      final habit = _createTestHabit(totalMinutes: 3000, targetHours: 100);
      expect(habit.progressPercent, closeTo(0.5, 0.001));
    });

    test('clamps to 1.0 when totalMinutes exceeds target', () {
      // 7000 minutes / (100 hours * 60) = 7000 / 6000 > 1.0
      final habit = _createTestHabit(totalMinutes: 7000, targetHours: 100);
      expect(habit.progressPercent, equals(1.0));
    });

    test('returns 0 when targetHours is 0', () {
      final habit = _createTestHabit(totalMinutes: 500, targetHours: 0);
      expect(habit.progressPercent, equals(0));
    });

    test('returns 0 when targetHours is negative', () {
      final habit = _createTestHabit(totalMinutes: 500, targetHours: -10);
      expect(habit.progressPercent, equals(0));
    });
  });

  group('Habit.progressText', () {
    test('formats correctly for 0 minutes', () {
      final habit = _createTestHabit(totalMinutes: 0, targetHours: 100);
      expect(habit.progressText, equals('0h 0m / 100h'));
    });

    test('formats correctly for mixed hours and minutes', () {
      // 150 minutes = 2h 30m
      final habit = _createTestHabit(totalMinutes: 150, targetHours: 50);
      expect(habit.progressText, equals('2h 30m / 50h'));
    });

    test('formats correctly for exact hours', () {
      // 120 minutes = 2h 0m
      final habit = _createTestHabit(totalMinutes: 120, targetHours: 10);
      expect(habit.progressText, equals('2h 0m / 10h'));
    });

    test('formats correctly for minutes only', () {
      // 45 minutes = 0h 45m
      final habit = _createTestHabit(totalMinutes: 45, targetHours: 10);
      expect(habit.progressText, equals('0h 45m / 10h'));
    });

    test('formats correctly for large values', () {
      // 6150 minutes = 102h 30m
      final habit = _createTestHabit(totalMinutes: 6150, targetHours: 200);
      expect(habit.progressText, equals('102h 30m / 200h'));
    });
  });

  group('Habit.isActive', () {
    test('returns true when active', () {
      final habit = _createTestHabit(isActive: true);
      expect(habit.isActive, isTrue);
    });

    test('returns false when inactive', () {
      final habit = _createTestHabit(isActive: false);
      expect(habit.isActive, isFalse);
    });
  });

  group('Habit.totalHours and remainingMinutes', () {
    test('totalHours is integer division of totalMinutes by 60', () {
      final habit = _createTestHabit(totalMinutes: 150);
      expect(habit.totalHours, equals(2));
    });

    test('remainingMinutes is modulo 60', () {
      final habit = _createTestHabit(totalMinutes: 150);
      expect(habit.remainingMinutes, equals(30));
    });
  });
}
