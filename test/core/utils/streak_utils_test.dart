// ---
// 📘 文件说明：
// StreakUtils 单元测试 — 验证连续打卡天数计算逻辑。
//
// 🧩 文件结构：
// - 今天已打卡 → streak 不变；
// - 昨天打卡 → streak +1；
// - 超过一天未打卡 → streak 重置为 1；
// - lastCheckInDate 为 null → streak = 1；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/utils/streak_utils.dart';

void main() {
  group('StreakUtils.calculateNewStreak', () {
    const today = '2026-02-19';
    const yesterday = '2026-02-18';

    test('today already checked in -> streak unchanged', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: today,
        today: today,
        yesterday: yesterday,
        currentStreak: 5,
      );

      expect(result, equals(5));
    });

    test('yesterday checked in -> streak +1', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: yesterday,
        today: today,
        yesterday: yesterday,
        currentStreak: 5,
      );

      expect(result, equals(6));
    });

    test('more than one day gap -> streak resets to 1', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: '2026-02-16',
        today: today,
        yesterday: yesterday,
        currentStreak: 10,
      );

      expect(result, equals(1));
    });

    test('null lastCheckInDate -> streak = 1', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: null,
        today: today,
        yesterday: yesterday,
        currentStreak: 0,
      );

      expect(result, equals(1));
    });

    test('null lastCheckInDate with existing streak -> still resets to 1', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: null,
        today: today,
        yesterday: yesterday,
        currentStreak: 7,
      );

      expect(result, equals(1));
    });

    test('streak starts from 0 when yesterday checked in -> becomes 1', () {
      final result = StreakUtils.calculateNewStreak(
        lastCheckInDate: yesterday,
        today: today,
        yesterday: yesterday,
        currentStreak: 0,
      );

      expect(result, equals(1));
    });
  });
}
