import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

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
        c.type == ActionType.lightRecorded ||
        c.type == ActionType.lightDeleted,
    read: () => awarenessRepo.getTodayLight(uid, AppDateUtils.todayString()),
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

/// 日期范围内的每日一光列表 — 参数格式：(startDate, endDate)，YYYY-MM-DD。
/// 用于跨月场景（如本周跨月时 WeekMoodDots 需要两个月的数据）。
final lightsInRangeProvider =
    FutureProvider.family<List<DailyLight>, (String, String)>((
      ref,
      range,
    ) async {
      final (startDate, endDate) = range;
      final uid = ref.watch(currentUidProvider);
      if (uid == null) return [];

      final awarenessRepo = ref.watch(awarenessRepositoryProvider);

      // 监听台账变更以自动刷新
      ref.listen(ledgerChangesProvider, (_, _) {});

      return awarenessRepo.getLightsInRange(uid, startDate, endDate);
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
        c.type == ActionType.weeklyReviewCompleted ||
        c.type == ActionType.weeklyReviewSaved,
    read: () =>
        awarenessRepo.getCurrentWeekReview(uid, AppDateUtils.currentWeekId()),
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
    filter: (c) => c.isGlobalRefresh || c.type.isWorryAction,
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
    filter: (c) => c.isGlobalRefresh || c.type.isWorryAction,
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

      final startWeekId = AppDateUtils.isoWeekId(firstDay);
      final endWeekId = AppDateUtils.isoWeekId(lastDay);

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
  final endDate = AppDateUtils.formatDay(DateTime(now.year, now.month + 1, 0));
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
        c.type == ActionType.lightRecorded ||
        c.type == ActionType.lightDeleted ||
        c.type == ActionType.weeklyReviewCompleted ||
        c.type.isWorryAction,
    read: () => awarenessRepo.getAwarenessStats(uid),
  );
});
