import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';

/// 最近 30 天每日总分钟数（热力图 + 活跃天数用）。
final dailyMinutesProvider = FutureProvider<Map<String, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};

  final habits = ref.watch(habitsProvider).value ?? [];
  if (habits.isEmpty) return {};

  final habitIds = habits.map((h) => h.id).toList();
  return ref
      .watch(firestoreServiceProvider)
      .getDailyMinutesFromSessions(uid: uid, habitIds: habitIds, lastNDays: 30);
});

/// 最近 7 天每日总分钟数（周趋势图用）。
final weeklyTrendProvider = FutureProvider<Map<String, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};

  final habits = ref.watch(habitsProvider).value ?? [];
  if (habits.isEmpty) return {};

  final habitIds = habits.map((h) => h.id).toList();
  return ref
      .watch(firestoreServiceProvider)
      .getDailyMinutesFromSessions(uid: uid, habitIds: habitIds, lastNDays: 7);
});

/// 最近 5 条专注记录（统计首页预览用）。
final recentSessionsProvider = FutureProvider<List<FocusSession>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final habits = ref.watch(habitsProvider).value ?? [];
  if (habits.isEmpty) return [];

  final habitIds = habits.map((h) => h.id).toList();
  return ref
      .watch(firestoreServiceProvider)
      .getRecentSessions(uid: uid, habitIds: habitIds, limit: 5);
});
