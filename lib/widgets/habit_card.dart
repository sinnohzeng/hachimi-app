import 'package:flutter/material.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/widgets/progress_ring.dart';
import 'package:hachimi_app/widgets/streak_indicator.dart';

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

  static const Map<String, IconData> iconMap = {
    'code': Icons.code,
    'book': Icons.book,
    'school': Icons.school,
    'psychology': Icons.psychology,
    'work': Icons.work,
    'fitness_center': Icons.fitness_center,
    'brush': Icons.brush,
    'music_note': Icons.music_note,
    'language': Icons.language,
    'check_circle': Icons.check_circle,
    'star': Icons.star,
    'rocket_launch': Icons.rocket_launch,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final icon = iconMap[habit.icon] ?? Icons.check_circle;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon + Progress ring
              ProgressRing(
                progress: habit.progressPercent,
                size: 56,
                child: Icon(icon, color: colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),

              // Name + progress text + today
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.name, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      habit.progressText,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (todayMinutes > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Today: ${todayMinutes}min',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Streak badge
              if (habit.currentStreak > 0)
                StreakIndicator(streak: habit.currentStreak),

              // Delete button
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: colorScheme.onSurfaceVariant),
                onPressed: onDelete,
                tooltip: 'Delete habit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
