import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/screens/cat_detail/components/edit_quest_sheet.dart';

/// Shows quest info, 2-column stats grid, and Start Focus button.
class FocusStatsCard extends ConsumerWidget {
  final Habit habit;
  final Cat cat;

  const FocusStatsCard({super.key, required this.habit, required this.cat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final todayMap = ref.watch(todayMinutesPerHabitProvider);
    final todayMinutes = todayMap[habit.id] ?? 0;
    final daysActive = max(
      1,
      DateTime.now().difference(habit.createdAt).inDays,
    );
    final avgDaily = habit.totalMinutes ~/ daysActive;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [B4] Header: 标题 + 副标题（纵向布局）
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.catDetailQuestBadge,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  habit.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (habit.motivationText != null &&
                    habit.motivationText!.isNotEmpty)
                  Text(
                    habit.motivationText!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),

            // 2-column stats grid
            Table(
              children: [
                _statRow(
                  context,
                  Icons.flag_outlined,
                  context.l10n.catDetailDailyGoal,
                  '${habit.goalMinutes} min',
                  Icons.today,
                  context.l10n.catDetailTodaysFocus,
                  '$todayMinutes min',
                ),
                _statRow(
                  context,
                  Icons.timer_outlined,
                  context.l10n.catDetailTotalFocus,
                  '${habit.totalMinutes ~/ 60}h ${habit.totalMinutes % 60}m',
                  Icons.emoji_events_outlined,
                  context.l10n.catDetailTargetLabel,
                  '${habit.targetHours}h',
                ),
                _statRow(
                  context,
                  Icons.pie_chart_outline,
                  context.l10n.catDetailCompletion,
                  '${(habit.progressPercent * 100).toStringAsFixed(0)}%',
                  Icons.local_fire_department,
                  context.l10n.catDetailCurrentStreak,
                  '${habit.currentStreak}d',
                ),
                _statRow(
                  context,
                  Icons.star_outline,
                  context.l10n.catDetailBestStreakLabel,
                  '${habit.bestStreak}d',
                  Icons.trending_up,
                  context.l10n.catDetailAvgDaily,
                  '${avgDaily}m',
                ),
                _statRow(
                  context,
                  Icons.calendar_today_outlined,
                  context.l10n.catDetailDaysActive,
                  '$daysActive',
                  null,
                  null,
                  null,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),

            // Action buttons: Edit + Start Focus
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showEditQuestSheet(context),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(context.l10n.catDetailEditQuest),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRouter.focusSetup, arguments: habit.id);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.catDetailStartFocus),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _statRow(
    BuildContext context,
    IconData icon1,
    String label1,
    String value1,
    IconData? icon2,
    String? label2,
    String? value2,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: StatCell(icon: icon1, label: label1, value: value1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: icon2 != null
              ? StatCell(icon: icon2, label: label2!, value: value2!)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showEditQuestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: EditQuestSheet(habit: habit),
      ),
    );
  }
}

/// A single stat cell displaying icon + label + value.
class StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCell({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
