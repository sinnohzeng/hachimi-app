import 'package:timezone/timezone.dart' as tz;

/// 通知调度纯函数 — 从 NotificationService 提取，支持确定性测试。
///
/// 所有函数接受可选 [now] 参数，默认使用 tz.TZDateTime.now(tz.local)。

/// 计算下一个 (hour:minute) 的时刻 — 今天或明天。
tz.TZDateTime nextInstanceOfTime(int hour, int minute, {tz.TZDateTime? now}) {
  final current = now ?? tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(
    tz.local,
    current.year,
    current.month,
    current.day,
    hour,
    minute,
  );
  if (scheduled.isBefore(current)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

/// 计算下一个指定星期几 + 时间的时刻。
/// [weekday] 遵循 DateTime.monday(1) ~ DateTime.sunday(7)。
tz.TZDateTime nextInstanceOfWeekdayTime(
  int weekday,
  int hour,
  int minute, {
  tz.TZDateTime? now,
}) {
  final current = now ?? tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(
    tz.local,
    current.year,
    current.month,
    current.day,
    hour,
    minute,
  );

  // 调整到目标星期几
  while (scheduled.weekday != weekday) {
    scheduled = scheduled.add(const Duration(days: 1));
  }

  // 如果已过去，推到下周
  if (scheduled.isBefore(current)) {
    scheduled = scheduled.add(const Duration(days: 7));
  }

  return scheduled;
}

/// 计算提醒通知 ID — 确定性、防碰撞。
///
/// ID 方案: base * 100 + reminderIndex * 10 + dayOffset
/// - base = habitId.hashCode.abs() % 100000
int computeReminderNotificationId(
  String habitId,
  int reminderIndex,
  int dayOffset,
) {
  final base = habitId.hashCode.abs() % 100000;
  return base * 100 + reminderIndex * 10 + dayOffset;
}

/// 计算 streak-at-risk 通知 ID — 与 reminder ID 空间分离。
int computeStreakNotificationId(String habitId) {
  return (habitId.hashCode.abs() % 100000) + 100000;
}
