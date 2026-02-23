import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 最近 30 天每日总分钟数（热力图 + 活跃天数用）— 从 SQLite 读取。
final dailyMinutesProvider = FutureProvider<Map<String, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};

  final sessionRepo = ref.watch(localSessionRepositoryProvider);
  return sessionRepo.getDailyMinutes(uid, 30);
});

/// 最近 7 天每日总分钟数（周趋势图用）— 从 SQLite 读取。
final weeklyTrendProvider = FutureProvider<Map<String, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};

  final sessionRepo = ref.watch(localSessionRepositoryProvider);
  return sessionRepo.getDailyMinutes(uid, 7);
});

/// 最近 5 条专注记录（统计首页预览用）— 从 SQLite 读取。
final recentSessionsProvider = FutureProvider<List<FocusSession>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final sessionRepo = ref.watch(localSessionRepositoryProvider);
  return sessionRepo.getRecentSessions(uid, limit: 5);
});
