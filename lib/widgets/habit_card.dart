import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// HabitCard — displays a single habit with progress, streak, and today's time.
class HabitCard extends StatelessWidget {
  final Habit habit;
  final int todayMinutes;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.todayMinutes,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Semantics(
      label: '${habit.name}, ${habit.progressText}',
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Row(
              children: [
                // Icon + Progress ring
                ProgressRing(
                  progress: habit.progressPercent,
                  size: 56,
                  child: Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.base),

                // Name + progress text + today
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        habit.progressText,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (todayMinutes > 0) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          context.l10n.habitTodayMinutes(todayMinutes),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 累计天数
                if (habit.totalCheckInDays > 0)
                  Chip(
                    avatar: const Icon(Icons.calendar_today, size: 14),
                    label: Text('${habit.totalCheckInDays}d'),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide.none,
                  ),

                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onDelete,
                  tooltip: context.l10n.habitDeleteTooltip,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
