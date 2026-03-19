import 'package:sqflite/sqflite.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 计划仓库 — WeeklyPlan + MonthlyPlan + YearlyPlan CRUD + 台账写入。
/// 所有写操作在 SQLite 事务中同时更新领域表和行为台账。
class PlanRepository {
  final LedgerService _ledger;

  PlanRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── WeeklyPlan ───

  /// 按 weekId 获取周计划。
  Future<WeeklyPlan?> getWeeklyPlan(String uid, String weekId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_plans',
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return WeeklyPlan.fromSqlite(rows.first);
  }

  /// 保存周计划（新增或更新）。
  Future<void> saveWeeklyPlan(String uid, WeeklyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_weekly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.weeklyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'weekId': plan.weekId},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.weeklyPlanSaved, affectedIds: [plan.id]),
    );
  }

  // ─── MonthlyPlan ───

  /// 按 monthId 获取月计划。
  Future<MonthlyPlan?> getMonthlyPlan(String uid, String monthId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_monthly_plans',
      where: 'uid = ? AND month_id = ?',
      whereArgs: [uid, monthId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MonthlyPlan.fromSqlite(rows.first);
  }

  /// 保存月计划（新增或更新）。
  Future<void> saveMonthlyPlan(String uid, MonthlyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_monthly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.monthlyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'monthId': plan.monthId},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.monthlyPlanSaved, affectedIds: [plan.id]),
    );
  }

  // ─── YearlyPlan ───

  /// 按年份获取年计划。
  Future<YearlyPlan?> getYearlyPlan(String uid, int year) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_yearly_plans',
      where: 'uid = ? AND year = ?',
      whereArgs: [uid, year],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return YearlyPlan.fromSqlite(rows.first);
  }

  /// 保存年计划（新增或更新）。
  Future<void> saveYearlyPlan(String uid, YearlyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_yearly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.yearlyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'year': plan.year},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.yearlyPlanSaved, affectedIds: [plan.id]),
    );
  }
}
