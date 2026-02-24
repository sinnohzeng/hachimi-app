import 'dart:convert';

import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// CoinService — 金币签到 + 消费，委托 LedgerService 本地 SQLite 事务。
class CoinService {
  final LedgerService _ledger;

  CoinService({required LedgerService ledger}) : _ledger = ledger;

  /// 当月总天数。
  int _daysInMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

  /// 每日签到（月度系统）— 本地 SQLite 事务。
  /// 返回 CheckInResult 表示签到成功及奖励详情，null 表示今日已签到。
  Future<CheckInResult?> checkIn(String uid) async {
    final now = DateTime.now();
    final today = AppDateUtils.todayString();
    final month = AppDateUtils.currentMonth();
    final dayOfMonth = now.day;
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final totalDaysInMonth = _daysInMonth(now);

    try {
      final db = await _ledger.database;

      return await db.transaction((txn) async {
        // 1. 检查今日是否已签到
        final lastDate = await _ledger.getMaterializedInTxn(
          txn,
          uid,
          'last_check_in_date',
        );
        if (lastDate == today) return null;

        // 2. 读取当月签到数据
        final rows = await txn.query(
          'local_monthly_checkins',
          where: 'uid = ? AND month = ?',
          whereArgs: [uid, month],
          limit: 1,
        );
        final existing = rows.isNotEmpty
            ? MonthlyCheckIn.fromSqlite(rows.first)
            : MonthlyCheckIn.empty(month);

        // 3. 计算每日奖励
        final dailyCoins = isWeekend
            ? checkInCoinsWeekend
            : checkInCoinsWeekday;

        // 4. 计算新的签到天数
        final newDays = [...existing.checkedDays, dayOfMonth];
        final newCount = newDays.length;

        // 5. 检查里程碑
        int milestoneBonus = 0;
        final newMilestones = <int>[];

        for (final entry in checkInMilestones.entries) {
          if (newCount >= entry.key &&
              !existing.milestonesClaimed.contains(entry.key)) {
            milestoneBonus += entry.value;
            newMilestones.add(entry.key);
          }
        }

        // 6. 检查全月奖励
        if (newCount == totalDaysInMonth &&
            !existing.milestonesClaimed.contains(totalDaysInMonth)) {
          milestoneBonus += checkInFullMonthBonus;
          newMilestones.add(totalDaysInMonth);
        }

        final totalReward = dailyCoins + milestoneBonus;

        // 7. 更新月度签到表
        final allMilestones = [...existing.milestonesClaimed, ...newMilestones];
        await txn.insert(
          'local_monthly_checkins',
          MonthlyCheckIn(
            month: month,
            checkedDays: newDays,
            totalCoins: existing.totalCoins + totalReward,
            milestonesClaimed: allMilestones,
          ).toSqlite(uid),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // 8. 更新物化状态：金币 + lastCheckInDate
        final currentCoins = await _ledger.getMaterializedInTxn(
          txn,
          uid,
          'coins',
        );
        final newCoins = (int.tryParse(currentCoins ?? '0') ?? 0) + totalReward;
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'coins',
          newCoins.toString(),
        );
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'last_check_in_date',
          today,
        );

        // 9. 写入行为台账
        await _ledger.appendInTxn(
          txn,
          type: ActionType.checkIn,
          uid: uid,
          startedAt: now,
          payload: {'month': month, 'day': dayOfMonth, 'isWeekend': isWeekend},
          result: {'coins': totalReward, 'milestone': milestoneBonus},
        );

        return CheckInResult(
          dailyCoins: dailyCoins,
          milestoneBonus: milestoneBonus,
          newMilestones: newMilestones,
        );
      });
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'CoinService',
        operation: 'checkIn',
      );
      rethrow;
    } finally {
      _ledger.notifyChange(const LedgerChange(type: 'check_in'));
    }
  }

  /// 扣减金币。余额不足返回 false。
  Future<bool> spendCoins({required String uid, required int amount}) async {
    assert(amount > 0, 'amount must be positive');
    final db = await _ledger.database;

    try {
      return await db.transaction((txn) async {
        final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
        final balance = int.tryParse(raw ?? '0') ?? 0;
        if (balance < amount) return false;

        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'coins',
          (balance - amount).toString(),
        );
        return true;
      });
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'CoinService',
        operation: 'spendCoins',
      );
      rethrow;
    }
  }

  /// 购买饰品：扣币 + 追加配饰到 inventory。
  Future<bool> purchaseAccessory({
    required String uid,
    required String accessoryId,
    required int price,
  }) async {
    assert(price > 0, 'price must be positive');
    assert(accessoryId.isNotEmpty, 'accessoryId must not be empty');
    final db = await _ledger.database;
    final now = DateTime.now();

    try {
      final result = await db.transaction((txn) async {
        final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
        final balance = int.tryParse(raw ?? '0') ?? 0;
        if (balance < price) return false;

        // 读取 inventory
        final invRaw = await _ledger.getMaterializedInTxn(
          txn,
          uid,
          'inventory',
        );
        final inventory = _decodeInventory(invRaw);
        if (inventory.contains(accessoryId)) return false;

        // 扣币
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'coins',
          (balance - price).toString(),
        );

        // 追加配饰
        inventory.add(accessoryId);
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'inventory',
          jsonEncode(inventory),
        );

        // 写台账
        await _ledger.appendInTxn(
          txn,
          type: ActionType.purchase,
          uid: uid,
          startedAt: now,
          payload: {'accessoryId': accessoryId, 'price': price},
          result: {'coins': -price},
        );

        return true;
      });

      if (result) {
        _ledger.notifyChange(const LedgerChange(type: 'purchase'));
      }
      return result;
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'CoinService',
        operation: 'purchaseAccessory',
      );
      rethrow;
    }
  }

  /// 增加金币（计时奖励用）。
  Future<void> earnCoins({required String uid, required int amount}) async {
    assert(amount > 0, 'amount must be positive');
    final db = await _ledger.database;

    try {
      await db.transaction((txn) async {
        final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
        final balance = int.tryParse(raw ?? '0') ?? 0;
        await _ledger.setMaterializedInTxn(
          txn,
          uid,
          'coins',
          (balance + amount).toString(),
        );
      });
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'CoinService',
        operation: 'earnCoins',
      );
      rethrow;
    } finally {
      _ledger.notifyChange(const LedgerChange(type: 'coins_earned'));
    }
  }

  List<String> _decodeInventory(String? raw) {
    if (raw == null) return [];
    final decoded = jsonDecode(raw);
    if (decoded is List) return decoded.cast<String>();
    return [];
  }
}
