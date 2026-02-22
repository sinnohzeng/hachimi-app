import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';

/// HabitDetailScreen — shows detailed stats and history for a single habit.
class HabitDetailScreen extends ConsumerWidget {
  final String habitId;

  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return habitsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(child: Text(context.l10n.commonErrorWithDetail('$e'))),
      ),
      data: (habits) {
        final habit = habits.where((h) => h.id == habitId).firstOrNull;
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(context.l10n.habitDetailQuestNotFound)),
          );
        }

        final l10n = context.l10n;
        return Scaffold(
          appBar: AppBar(title: Text(habit.name)),
          body: Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              children: [
                // Large progress ring
                ProgressRing(
                  progress: habit.progressPercent,
                  size: 160,
                  strokeWidth: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(habit.progressPercent * 100).round()}%',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        l10n.habitDetailComplete,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Stats
                _DetailRow(
                  icon: Icons.timer,
                  label: l10n.habitDetailTotalTime,
                  value: habit.progressText,
                ),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: l10n.habitDetailBestStreak,
                  value: l10n.habitDetailDaysUnit(habit.totalCheckInDays),
                ),
                if (habit.targetHours != null)
                  _DetailRow(
                    icon: Icons.flag,
                    label: l10n.habitDetailTarget,
                    value: l10n.habitDetailHoursUnit(habit.targetHours!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSpacing.paddingVSm,
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.base),
          Expanded(child: Text(label, style: textTheme.bodyLarge)),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
