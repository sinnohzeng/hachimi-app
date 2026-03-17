import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 私有辅助 ───

/// 获取今日日期字符串（'YYYY-MM-DD'）。
String _todayDateString() {
  final now = DateTime.now();
  return '${now.year}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
}

/// 获取当前 ISO 周 ID（'YYYY-WNN'）。
///
/// ISO 8601 算法：
/// 1. 找到本周四 → 确定 ISO 年
/// 2. 找到该 ISO 年第 1 周的周一（包含 1 月 4 日的那一周）
/// 3. 周数 = (本周四 - 第 1 周周一) / 7 + 1
String _currentWeekId() {
  final now = DateTime.now();
  // 本周四确定 ISO 年
  final thursday = now.add(Duration(days: DateTime.thursday - now.weekday));
  final isoYear = thursday.year;
  // 1 月 4 日始终在 ISO 第 1 周内
  final jan4 = DateTime(isoYear, 1, 4);
  // 第 1 周的周一
  final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));
  final weekNumber = (thursday.difference(week1Monday).inDays ~/ 7) + 1;
  return '$isoYear-W${weekNumber.toString().padLeft(2, '0')}';
}

// ─── 每日一光 ───

/// 今日的每日一光记录 — 从本地 SQLite 读取，台账变更自动刷新。
final todayLightProvider = StreamProvider<DailyLight?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == 'light_recorded' ||
        c.type == 'light_deleted',
    read: () => awarenessRepo.getTodayLight(uid, _todayDateString()),
  );
});

/// 今日是否已记录每日一光 — 从 todayLightProvider 派生。
/// 加载中和错误状态均视为「未知」（返回 false），避免在错误时误导用户。
/// FocusCompleteScreen 桥接横幅依赖此 provider；错误时横幅仍会显示，
/// 但录入操作会独立降级，MVP 阶段可接受。
final hasRecordedTodayLightProvider = Provider<bool>((ref) {
  final async = ref.watch(todayLightProvider);
  // 仅在数据成功加载且非 null 时返回 true
  return async.whenData((light) => light != null).value ?? false;
});

/// 指定月份的每日一光列表 — 按月加载（参数格式：'YYYY-MM'）。
final monthlyLightsProvider = FutureProvider.family<List<DailyLight>, String>((
  ref,
  month,
) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);

  // 监听台账变更以自动刷新
  ref.listen(ledgerChangesProvider, (_, _) {});

  return awarenessRepo.getLightsForMonth(uid, month);
});

// ─── 周回顾 ───

/// 当前周的周回顾记录 — 从本地 SQLite 读取，台账变更自动刷新。
final currentWeekReviewProvider = StreamProvider<WeeklyReview?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == 'weekly_review_completed' ||
        c.type == 'weekly_review_saved',
    read: () => awarenessRepo.getCurrentWeekReview(uid, _currentWeekId()),
  );
});

// ─── 烦恼 ───

/// 进行中的烦恼列表 — 从本地 SQLite 读取，台账变更自动刷新。
final activeWorriesProvider = StreamProvider<List<Worry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<Worry>[]);

  final worryRepo = ref.watch(worryRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type.startsWith('worry_'),
    read: () => worryRepo.getActiveWorries(uid),
  );
});

/// 已终结的烦恼列表 — 从本地 SQLite 读取，台账变更自动刷新。
final resolvedWorriesProvider = StreamProvider<List<Worry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<Worry>[]);

  final worryRepo = ref.watch(worryRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type.startsWith('worry_'),
    read: () => worryRepo.getResolvedWorries(uid),
  );
});

// ─── 按日期查询单条记录（Track 4） ───

/// 按日期获取单条 DailyLight 记录。
final dailyLightByDateProvider = FutureProvider.family<DailyLight?, String>((
  ref,
  date,
) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return null;

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);
  return awarenessRepo.getLightByDate(uid, date);
});

// ─── 按月周回顾列表（Track 4） ───

/// 查询某月内所有 ISO 周的 WeeklyReview 记录。
final weeklyReviewsForMonthProvider =
    FutureProvider.family<List<WeeklyReview>, (int, int)>((ref, params) async {
      final (year, month) = params;
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return [];

      final awarenessRepo = ref.watch(awarenessRepositoryProvider);

      ref.listen(ledgerChangesProvider, (_, _) {});

      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);

      final startWeekId = _isoWeekId(firstDay);
      final endWeekId = _isoWeekId(lastDay);

      return awarenessRepo.getReviewsInRange(uid, startWeekId, endWeekId);
    });

// ─── 心情分布统计（Track 4） ───

/// 心情分布统计 — 按 Mood 聚合所有 DailyLight 的计数。
final moodDistributionProvider = FutureProvider<Map<Mood, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);

  ref.listen(ledgerChangesProvider, (_, _) {});

  // 查全量数据：从 2020 年到当前月末
  final now = DateTime.now();
  final lastDay = DateTime(now.year, now.month + 1, 0).day;
  final endDate =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-'
      '${lastDay.toString().padLeft(2, '0')}';
  final lights = await awarenessRepo.getLightsInRange(
    uid,
    '2020-01-01',
    endDate,
  );

  final distribution = <Mood, int>{};
  for (final light in lights) {
    distribution[light.mood] = (distribution[light.mood] ?? 0) + 1;
  }
  return distribution;
});

/// ISO 8601 周 ID 计算。
String _isoWeekId(DateTime date) {
  final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
  final isoYear = thursday.year;
  final jan4 = DateTime(isoYear, 1, 4);
  final week1Monday = jan4.subtract(Duration(days: jan4.weekday - 1));
  final weekNumber = (thursday.difference(week1Monday).inDays ~/ 7) + 1;
  return '$isoYear-W${weekNumber.toString().padLeft(2, '0')}';
}

// ─── 统计 ───

/// 觉知模块统计数据 — 台账变更自动刷新。
final awarenessStatsProvider = StreamProvider<Map<String, int>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    return Stream.value(<String, int>{
      'totalLightDays': 0,
      'totalWeeklyReviews': 0,
      'totalWorriesResolved': 0,
    });
  }

  final awarenessRepo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == 'light_recorded' ||
        c.type == 'light_deleted' ||
        c.type == 'weekly_review_completed' ||
        c.type.startsWith('worry_'),
    read: () => awarenessRepo.getAwarenessStats(uid),
  );
});
