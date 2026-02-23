import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 实时金币余额 — 从 SQLite materialized_state 读取。
final coinBalanceProvider = StreamProvider<int>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield 0;
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  final balance = await ledger.getMaterializedInt(uid, 'coins');
  yield balance ?? 0;

  await for (final change in ledger.changes) {
    if (change.type == 'check_in' ||
        change.type == 'focus_complete' ||
        change.type == 'purchase' ||
        change.type == 'achievement_unlocked') {
      final updated = await ledger.getMaterializedInt(uid, 'coins');
      yield updated ?? 0;
    }
  }
});

/// 今日是否已签到 — 从 SQLite materialized_state 读取。
final hasCheckedInTodayProvider = StreamProvider<bool>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield false;
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  final today = AppDateUtils.todayString();
  final lastDate = await ledger.getMaterialized(uid, 'last_check_in_date');
  yield lastDate == today;

  await for (final change in ledger.changes) {
    if (change.type == 'check_in') {
      final updated = await ledger.getMaterialized(uid, 'last_check_in_date');
      yield updated == today;
    }
  }
});

/// 当月签到进度 — 从 SQLite local_monthly_checkins 读取。
final monthlyCheckInProvider = StreamProvider<MonthlyCheckIn?>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield null;
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  final month = AppDateUtils.currentMonth();

  yield await _readMonthlyCheckIn(ledger, uid, month);

  await for (final change in ledger.changes) {
    if (change.type == 'check_in') {
      yield await _readMonthlyCheckIn(ledger, uid, month);
    }
  }
});

Future<MonthlyCheckIn?> _readMonthlyCheckIn(
  LedgerService ledger,
  String uid,
  String month,
) async {
  final db = await ledger.database;
  final rows = await db.query(
    'local_monthly_checkins',
    where: 'uid = ? AND month = ?',
    whereArgs: [uid, month],
    limit: 1,
  );
  if (rows.isEmpty) return null;
  return MonthlyCheckIn.fromSqlite(rows.first);
}
