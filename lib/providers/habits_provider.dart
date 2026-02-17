import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Habits list — SSOT for user's habits.
/// Streams from Firestore habits subcollection.
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).watchHabits(uid);
});

/// Today's check-ins — SSOT for today's completed entries.
final todayCheckInsProvider = StreamProvider<List<CheckInEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).watchTodayCheckIns(uid);
});

/// Today's minutes per habit — derived from todayCheckInsProvider.
/// Returns a map of habitId → total minutes logged today.
final todayMinutesPerHabitProvider = Provider<Map<String, int>>((ref) {
  final checkIns = ref.watch(todayCheckInsProvider).value ?? [];
  final map = <String, int>{};
  for (final entry in checkIns) {
    map[entry.habitId] = (map[entry.habitId] ?? 0) + entry.minutes;
  }
  return map;
});
