import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 实时金币余额 — 从 SQLite materialized_state 读取。
final coinBalanceProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(0);

  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == ActionType.checkIn ||
        c.type == ActionType.focusComplete ||
        c.type == ActionType.purchase ||
        c.type == ActionType.achievementUnlocked,
    read: () async => await ledger.getMaterializedInt(uid, 'coins') ?? 0,
  );
});

/// 今日是否已签到 — 从 SQLite materialized_state 读取。
final hasCheckedInTodayProvider = StreamProvider<bool>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(false);

  final ledger = ref.watch(ledgerServiceProvider);
  final today = AppDateUtils.todayString();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.checkIn,
    read: () async {
      final lastDate = await ledger.getMaterialized(uid, 'last_check_in_date');
      return lastDate == today;
    },
  );
});

/// 当月签到进度 — 从 SQLite local_monthly_checkins 读取。
final monthlyCheckInProvider = StreamProvider<MonthlyCheckIn?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final ledger = ref.watch(ledgerServiceProvider);
  final month = AppDateUtils.currentMonth();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == ActionType.checkIn,
    read: () => _readMonthlyCheckIn(ledger, uid, month),
  );
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
