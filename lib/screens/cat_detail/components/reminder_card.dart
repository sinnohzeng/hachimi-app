import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/reminder_picker_sheet.dart';

/// 提醒列表卡片 — 显示 habit 的多条提醒，支持增删。
class ReminderCard extends ConsumerWidget {
  final Habit habit;
  final Cat cat;

  const ReminderCard({super.key, required this.habit, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final hasReminders = habit.hasReminders;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              children: [
                Icon(
                  hasReminders
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  color: hasReminders
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.catDetailDailyReminder,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // 已有提醒列表
            if (hasReminders) ...[
              const SizedBox(height: AppSpacing.md),
              for (int i = 0; i < habit.reminders.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      const SizedBox(width: 36), // 与图标对齐
                      Expanded(
                        child: Text(
                          _reminderDescription(context, habit.reminders[i]),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: colorScheme.error,
                        ),
                        onPressed: () => _removeReminder(context, ref, i),
                        tooltip: l10n.catDetailRemoveReminder,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
            ] else ...[
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  l10n.catDetailNoReminder,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],

            // 添加按钮
            if (habit.reminders.length < 5)
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: TextButton.icon(
                  onPressed: () => _addReminder(context, ref),
                  icon: const Icon(Icons.add_alarm, size: 18),
                  label: Text(l10n.reminderAddMore),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(left: 36, top: AppSpacing.xs),
                child: Text(
                  l10n.reminderMaxReached,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _reminderDescription(BuildContext context, ReminderConfig reminder) =>
      reminder.localizedDescription(context.l10n);

  Future<void> _addReminder(BuildContext context, WidgetRef ref) async {
    final result = await showReminderPickerSheet(context);
    if (result == null || !context.mounted) return;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    try {
      final newReminders = [...habit.reminders, result];
      await ref
          .read(firestoreServiceProvider)
          .updateHabit(uid: uid, habitId: habit.id, reminders: newReminders);

      if (!context.mounted) return;

      // 重新调度通知
      final l10n = context.l10n;
      await ref
          .read(notificationServiceProvider)
          .scheduleReminders(
            habitId: habit.id,
            habitName: habit.name,
            catName: cat.name,
            reminders: newReminders,
            title: l10n.reminderNotificationTitle(cat.name),
            body: l10n.reminderNotificationBody(habit.name),
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.catDetailReminderSet(result.timeString)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeReminder(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    try {
      final newReminders = [...habit.reminders]..removeAt(index);

      if (newReminders.isEmpty) {
        await ref
            .read(firestoreServiceProvider)
            .updateHabit(uid: uid, habitId: habit.id, clearReminders: true);
        await ref
            .read(notificationServiceProvider)
            .cancelAllRemindersForHabit(habit.id);
      } else {
        await ref
            .read(firestoreServiceProvider)
            .updateHabit(uid: uid, habitId: habit.id, reminders: newReminders);
        if (!context.mounted) return;
        final l10n = context.l10n;
        await ref
            .read(notificationServiceProvider)
            .scheduleReminders(
              habitId: habit.id,
              habitName: habit.name,
              catName: cat.name,
              reminders: newReminders,
              title: l10n.reminderNotificationTitle(cat.name),
              body: l10n.reminderNotificationBody(habit.name),
            );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.catDetailReminderRemoved),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
