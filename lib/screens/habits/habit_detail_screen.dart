import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (habits) {
        final habit = habits.where((h) => h.id == habitId).firstOrNull;
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Habit not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(habit.name)),
          body: Padding(
            padding: const EdgeInsets.all(24),
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
                        'complete',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Stats
                _DetailRow(
                  icon: Icons.timer,
                  label: 'Total Time',
                  value: habit.progressText,
                ),
                _DetailRow(
                  icon: Icons.local_fire_department,
                  label: 'Current Streak',
                  value: '${habit.currentStreak} days',
                ),
                _DetailRow(
                  icon: Icons.emoji_events,
                  label: 'Best Streak',
                  value: '${habit.bestStreak} days',
                ),
                _DetailRow(
                  icon: Icons.flag,
                  label: 'Target',
                  value: '${habit.targetHours} hours',
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: textTheme.bodyLarge),
          ),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
