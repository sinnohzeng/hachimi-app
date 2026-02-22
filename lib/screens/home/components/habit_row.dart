import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

class HabitRow extends StatelessWidget {
  final Habit habit;
  final Cat? cat;
  final int todayMinutes;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HabitRow({
    super.key,
    required this.habit,
    required this.cat,
    required this.todayMinutes,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Row(
            children: [
              // Cat avatar or habit emoji
              if (cat != null)
                PixelCatSprite.fromCat(cat: cat!, size: 48)
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 24,
                    color: colorScheme.primary,
                  ),
                ),
              const SizedBox(width: AppSpacing.md),

              // Habit info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (todayMinutes > 0) ...[
                          Text(
                            context.l10n.todayMinToday(todayMinutes),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / ${habit.goalMinutes}min',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ] else
                          Text(
                            context.l10n.todayGoalMinPerDay(habit.goalMinutes),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // 累计天数
              if (habit.totalCheckInDays > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${habit.totalCheckInDays}d',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],

              // Start button
              IconButton(
                icon: Icon(
                  Icons.play_circle_filled,
                  color: colorScheme.primary,
                  size: 32,
                ),
                onPressed: onTap,
                tooltip: context.l10n.todayStartFocus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
