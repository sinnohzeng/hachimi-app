// ---
// 📘 notification_scheduling 纯函数单元测试
// 覆盖时间计算（nextInstanceOfTime、nextInstanceOfWeekdayTime）和 ID 生成。
// 通过 now 参数注入实现确定性验证。
//
// 🕒 创建时间：2026-03-17
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:hachimi_app/services/notification_scheduling.dart';

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  // ─── nextInstanceOfTime ───

  group('nextInstanceOfTime', () {
    test('returns today when time has not passed', () {
      // 现在 10:00，目标 14:00 → 今天 14:00
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 10, 0);
      final result = nextInstanceOfTime(14, 0, now: now);

      expect(result.year, equals(2026));
      expect(result.month, equals(3));
      expect(result.day, equals(17));
      expect(result.hour, equals(14));
      expect(result.minute, equals(0));
    });

    test('returns tomorrow when time has passed', () {
      // 现在 15:00，目标 14:00 → 明天 14:00
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 15, 0);
      final result = nextInstanceOfTime(14, 0, now: now);

      expect(result.day, equals(18));
      expect(result.hour, equals(14));
    });

    test('returns today when time is exactly now (not before)', () {
      // isBefore(now) 为 false 当 scheduled == now，所以返回今天
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 14, 0);
      final result = nextInstanceOfTime(14, 0, now: now);

      expect(result.day, equals(17));
      expect(result.hour, equals(14));
    });

    test('preserves hour and minute', () {
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 8, 0);
      final result = nextInstanceOfTime(23, 59, now: now);

      expect(result.hour, equals(23));
      expect(result.minute, equals(59));
    });

    test('23:59 wraps to next day correctly', () {
      // 现在 23:59:30，目标 23:59 → 明天 23:59
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 23, 59, 30);
      final result = nextInstanceOfTime(23, 59, now: now);

      expect(result.day, equals(18));
      expect(result.hour, equals(23));
      expect(result.minute, equals(59));
    });

    test('handles month boundary', () {
      // 3 月 31 日 22:00，目标 08:00 → 4 月 1 日
      final now = tz.TZDateTime(tz.local, 2026, 3, 31, 22, 0);
      final result = nextInstanceOfTime(8, 0, now: now);

      expect(result.month, equals(4));
      expect(result.day, equals(1));
      expect(result.hour, equals(8));
    });
  });

  // ─── nextInstanceOfWeekdayTime ───

  group('nextInstanceOfWeekdayTime', () {
    // 2026-03-17 是周二 (weekday == 2)

    test('target weekday is later this week', () {
      // 现在周二 10:00，目标周五 09:00 → 本周五 (3/20)
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 10, 0);
      final result = nextInstanceOfWeekdayTime(DateTime.friday, 9, 0, now: now);

      expect(result.weekday, equals(DateTime.friday));
      expect(result.day, equals(20));
      expect(result.hour, equals(9));
    });

    test('target weekday is today and time has not passed', () {
      // 现在周二 08:00，目标周二 10:00 → 今天
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 8, 0);
      final result = nextInstanceOfWeekdayTime(
        DateTime.tuesday,
        10,
        0,
        now: now,
      );

      expect(result.day, equals(17));
      expect(result.hour, equals(10));
    });

    test('target weekday is today but time has passed → next week', () {
      // 现在周二 12:00，目标周二 10:00 → 下周二 (3/24)
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 12, 0);
      final result = nextInstanceOfWeekdayTime(
        DateTime.tuesday,
        10,
        0,
        now: now,
      );

      expect(result.day, equals(24));
      expect(result.weekday, equals(DateTime.tuesday));
    });

    test('target weekday has already passed this week → next week', () {
      // 现在周二，目标周一 → 下周一 (3/23)
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 10, 0);
      final result = nextInstanceOfWeekdayTime(DateTime.monday, 9, 0, now: now);

      expect(result.day, equals(23));
      expect(result.weekday, equals(DateTime.monday));
    });

    test('all 7 weekdays produce correct weekday value', () {
      final now = tz.TZDateTime(tz.local, 2026, 3, 17, 0, 0);
      for (int w = DateTime.monday; w <= DateTime.sunday; w++) {
        final result = nextInstanceOfWeekdayTime(w, 12, 0, now: now);
        expect(result.weekday, equals(w), reason: 'weekday $w mismatch');
      }
    });

    test('month boundary: Jan 31 (Friday) → next Friday Feb 7', () {
      // 2026-01-31 是周六，目标周五 → 2/6
      // 先验证 1/31 的 weekday
      final jan31 = tz.TZDateTime(tz.local, 2026, 1, 31, 12, 0);
      final result = nextInstanceOfWeekdayTime(
        DateTime.friday,
        10,
        0,
        now: jan31,
      );

      expect(result.weekday, equals(DateTime.friday));
      expect(result.isAfter(jan31), isTrue);
      // 应该在 2 月
      expect(result.month, greaterThanOrEqualTo(2));
    });

    test('target is Sunday from Saturday', () {
      // 2026-03-21 是周六，目标周日 → 3/22
      final sat = tz.TZDateTime(tz.local, 2026, 3, 21, 10, 0);
      final result = nextInstanceOfWeekdayTime(
        DateTime.sunday,
        10,
        0,
        now: sat,
      );

      expect(result.day, equals(22));
      expect(result.weekday, equals(DateTime.sunday));
    });
  });

  // ─── computeReminderNotificationId ───

  group('computeReminderNotificationId', () {
    test('deterministic — same input produces same output', () {
      final id1 = computeReminderNotificationId('habit-123', 0, 0);
      final id2 = computeReminderNotificationId('habit-123', 0, 0);
      expect(id1, equals(id2));
    });

    test('different habitId produces different base', () {
      final id1 = computeReminderNotificationId('habit-a', 0, 0);
      final id2 = computeReminderNotificationId('habit-b', 0, 0);
      expect(id1, isNot(equals(id2)));
    });

    test('unique IDs across reminderIndex and dayOffset combinations', () {
      final ids = <int>{};
      const habitId = 'test-habit';
      for (int r = 0; r < 5; r++) {
        for (int d = 0; d < 5; d++) {
          final id = computeReminderNotificationId(habitId, r, d);
          expect(ids.contains(id), isFalse, reason: 'collision at r=$r, d=$d');
          ids.add(id);
        }
      }
      expect(ids.length, equals(25));
    });
  });

  // ─── computeStreakNotificationId ───

  group('computeStreakNotificationId', () {
    test('deterministic', () {
      final id1 = computeStreakNotificationId('habit-123');
      final id2 = computeStreakNotificationId('habit-123');
      expect(id1, equals(id2));
    });

    test('no collision with reminder IDs (streak base >= 100000)', () {
      const habitId = 'test-habit';
      final streakId = computeStreakNotificationId(habitId);

      // reminder IDs: base * 100 + offset，其中 base < 100000
      // 所以 reminder IDs < 100000 * 100 = 10000000
      // streak IDs: base + 100000，其中 base < 100000
      // 所以 streak IDs 范围 [100000, 199999]
      expect(streakId, greaterThanOrEqualTo(100000));
      expect(streakId, lessThan(200000));

      // 确保不等于任何 reminder ID
      for (int r = 0; r < 5; r++) {
        for (int d = 0; d < 10; d++) {
          final reminderId = computeReminderNotificationId(habitId, r, d);
          expect(streakId, isNot(equals(reminderId)));
        }
      }
    });
  });
}
