import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 周计划 ───

/// 当前周的周计划 — 从本地 SQLite 读取，台账变更自动刷新。
final currentWeekPlanProvider = StreamProvider<WeeklyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final planRepo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.weeklyPlanSaved,
    read: () => planRepo.getWeeklyPlan(uid, AppDateUtils.currentWeekId()),
  );
});

// ─── 月计划 ───

/// 当前月的月计划 — 从本地 SQLite 读取，台账变更自动刷新。
final currentMonthPlanProvider = StreamProvider<MonthlyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final planRepo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.monthlyPlanSaved,
    read: () => planRepo.getMonthlyPlan(uid, AppDateUtils.currentMonth()),
  );
});

// ─── 年计划 ───

/// 当前年的年计划 — 从本地 SQLite 读取，台账变更自动刷新。
final currentYearPlanProvider = StreamProvider<YearlyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final planRepo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.yearlyPlanSaved,
    read: () => planRepo.getYearlyPlan(uid, DateTime.now().year),
  );
});
