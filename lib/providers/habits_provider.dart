import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// Habits list — SSOT for user's habits.
/// Streams from Firestore habits subcollection.
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).watchHabits(uid);
});

/// Today's sessions — SSOT for today's completed focus sessions.
/// 替代旧的 todayCheckInsProvider，直接从 sessions 子集合监听。
final todaySessionsProvider = StreamProvider<List<FocusSession>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);

  final habits = ref.watch(habitsProvider).value ?? [];
  if (habits.isEmpty) return Stream.value([]);

  final habitIds = habits.map((h) => h.id).toList();
  return ref.watch(firestoreServiceProvider).watchTodaySessions(uid, habitIds);
});

/// Today's minutes per habit — derived from todaySessionsProvider.
/// Returns a map of habitId → total minutes logged today.
final todayMinutesPerHabitProvider = Provider<Map<String, int>>((ref) {
  final sessions = ref.watch(todaySessionsProvider).value ?? [];
  final map = <String, int>{};
  for (final session in sessions) {
    map[session.habitId] =
        (map[session.habitId] ?? 0) + session.durationMinutes;
  }
  return map;
});
