import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/screens/cat_detail/components/edit_quest_sheet.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_button.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_card.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_section_header.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_stat_row.dart';

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

    final pixel = context.pixel;

    return PixelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PixelSectionHeader(
            title: context.l10n.catDetailQuestBadge,
            icon: Icons.flag_outlined,
          ),
          Text(
            habit.name,
            style: pixel.pixelHeading.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (habit.motivationText != null && habit.motivationText!.isNotEmpty)
            Text(
              habit.motivationText!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: AppSpacing.md),

          // Stats grid as PixelStatRow
          PixelStatRow(
            icon: Icons.flag_outlined,
            label: context.l10n.catDetailDailyGoal,
            value: '${habit.goalMinutes} min',
          ),
          PixelStatRow(
            icon: Icons.today,
            label: context.l10n.catDetailTodaysFocus,
            value: '$todayMinutes min',
          ),
          PixelStatRow(
            icon: Icons.timer_outlined,
            label: context.l10n.catDetailTotalFocus,
            value: '${habit.totalMinutes ~/ 60}h ${habit.totalMinutes % 60}m',
          ),
          PixelStatRow(
            icon: Icons.emoji_events_outlined,
            label: context.l10n.catDetailTargetLabel,
            value: habit.targetHours != null ? '${habit.targetHours}h' : '∞',
          ),
          PixelStatRow(
            icon: Icons.pie_chart_outline,
            label: context.l10n.catDetailCompletion,
            value: habit.targetHours != null
                ? '${(habit.progressPercent * 100).toStringAsFixed(0)}%'
                : '—',
          ),
          PixelStatRow(
            icon: Icons.trending_up,
            label: context.l10n.catDetailAvgDaily,
            value: '${avgDaily}m',
          ),
          PixelStatRow(
            icon: Icons.calendar_today_outlined,
            label: context.l10n.catDetailDaysActive,
            value: '$daysActive',
          ),
          PixelStatRow(
            icon: Icons.check_circle_outline,
            label: context.l10n.catDetailCheckInDays,
            value: '${habit.totalCheckInDays}',
          ),
          if (habit.deadlineDate != null && !habit.isUnlimited)
            PixelStatRow(
              icon: Icons.event,
              label: context.l10n.adoptionDeadlineLabel,
              value: _formatDate(habit.deadlineDate!),
            ),
          const SizedBox(height: AppSpacing.base),

          // Action buttons
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
                child: PixelButton(
                  label: context.l10n.catDetailStartFocus,
                  icon: Icons.play_arrow,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRouter.focusSetup, arguments: habit.id);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showEditQuestSheet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EditQuestSheet(habit: habit, cat: cat),
      ),
    );
  }
}
