import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// Computed statistics — derived from habitsProvider.
class HabitStats {
  final int totalHabits;
  final int totalMinutesLogged;
  final int totalTargetHours;

  const HabitStats({
    this.totalHabits = 0,
    this.totalMinutesLogged = 0,
    this.totalTargetHours = 0,
  });

  int get totalHoursLogged => totalMinutesLogged ~/ 60;
  int get remainingMinutes => totalMinutesLogged % 60;

  double get overallProgress {
    if (totalTargetHours <= 0) return 0;
    return (totalMinutesLogged / (totalTargetHours * 60)).clamp(0.0, 1.0);
  }
}

/// Stats provider — SSOT for computed statistics.
final statsProvider = Provider<HabitStats>((ref) {
  final habits = ref.watch(habitsProvider).value ?? <Habit>[];

  if (habits.isEmpty) return const HabitStats();

  int totalMinutes = 0;
  int totalTargetHours = 0;

  for (final habit in habits) {
    totalMinutes += habit.totalMinutes;
    totalTargetHours += habit.targetHours ?? 0;
  }

  return HabitStats(
    totalHabits: habits.length,
    totalMinutesLogged: totalMinutes,
    totalTargetHours: totalTargetHours,
  );
});
