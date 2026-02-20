// ---
// 📘 文件说明：
// Reminder Card — 每日提醒卡片组件。
// 展示/设置/修改/移除每日专注提醒。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 Habit 和 Cat 数据；
// 2. 判断是否已设置提醒；
// 3. 已设置：显示时间 + 修改/删除按钮；
// 4. 未设置：显示"设置提醒"按钮；
// 5. 调用 Firestore + NotificationService 完成操作；
//
// 🧩 文件结构：
// - ReminderCard：每日提醒卡片 ConsumerWidget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Shows/sets/removes a daily reminder for this quest.
class ReminderCard extends ConsumerWidget {
  final Habit habit;
  final Cat cat;

  const ReminderCard({super.key, required this.habit, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final hasReminder =
        habit.reminderTime != null && habit.reminderTime!.isNotEmpty;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Row(
          children: [
            Icon(
              hasReminder
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              color: hasReminder
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.catDetailDailyReminder,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    hasReminder
                        ? context.l10n.catDetailEveryDay(habit.reminderTime!)
                        : context.l10n.catDetailNoReminder,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (hasReminder) ...[
              TextButton(
                onPressed: () => _setReminder(context, ref),
                child: Text(context.l10n.catDetailChange),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: colorScheme.error),
                onPressed: () => _removeReminder(context, ref),
                tooltip: context.l10n.catDetailRemoveReminder,
                visualDensity: VisualDensity.compact,
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => _setReminder(context, ref),
                icon: const Icon(Icons.add_alarm, size: 18),
                label: Text(context.l10n.catDetailSet),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _setReminder(BuildContext context, WidgetRef ref) async {
    final initial = habit.reminderTime != null
        ? _parseTime(habit.reminderTime!)
        : const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !context.mounted) return;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final timeStr = _formatTimeOfDay(picked);

    await ref
        .read(firestoreServiceProvider)
        .updateHabit(uid: uid, habitId: habit.id, reminderTime: timeStr);
    await ref
        .read(notificationServiceProvider)
        .scheduleDailyReminder(
          habitId: habit.id,
          habitName: habit.name,
          catName: cat.name,
          hour: picked.hour,
          minute: picked.minute,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.catDetailReminderSet(timeStr)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _removeReminder(BuildContext context, WidgetRef ref) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    await ref
        .read(firestoreServiceProvider)
        .updateHabit(uid: uid, habitId: habit.id, clearReminder: true);
    await ref.read(notificationServiceProvider).cancelDailyReminder(habit.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.catDetailReminderRemoved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _formatTimeOfDay(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
