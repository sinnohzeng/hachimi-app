import 'dart:convert';

import 'package:sqflite/sqflite.dart' show ConflictAlgorithm, Transaction;

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

    try {
      final db = await _ledger.database;
      return await db.transaction((txn) async {
        final existing = await _loadMonthlyCheckIn(txn, uid, today, month);
        if (existing == null) return null; // 今日已签到

        final rewards = _calculateRewards(now, existing, month);
        await _persistCheckIn(txn, uid, now, today, month, existing, rewards);
        return rewards.toResult();
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

  /// 加载当月签到记录，若今日已签到返回 null。
  Future<MonthlyCheckIn?> _loadMonthlyCheckIn(
    Transaction txn,
    String uid,
    String today,
    String month,
  ) async {
    final lastDate = await _ledger.getMaterializedInTxn(
      txn,
      uid,
      'last_check_in_date',
    );
    if (lastDate == today) return null;

    final rows = await txn.query(
      'local_monthly_checkins',
      where: 'uid = ? AND month = ?',
      whereArgs: [uid, month],
      limit: 1,
    );
    return rows.isNotEmpty
        ? MonthlyCheckIn.fromSqlite(rows.first)
        : MonthlyCheckIn.empty(month);
  }

  /// 纯计算：每日奖励 + 里程碑奖励。
  _CheckInRewards _calculateRewards(
    DateTime now,
    MonthlyCheckIn existing,
    String month,
  ) {
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final dailyCoins = isWeekend ? checkInCoinsWeekend : checkInCoinsWeekday;
    final newDays = [...existing.checkedDays, now.day];
    final newCount = newDays.length;

    int milestoneBonus = 0;
    final newMilestones = <int>[];
    for (final entry in checkInMilestones.entries) {
      if (newCount >= entry.key &&
          !existing.milestonesClaimed.contains(entry.key)) {
        milestoneBonus += entry.value;
        newMilestones.add(entry.key);
      }
    }

    final totalDays = _daysInMonth(now);
    if (newCount == totalDays &&
        !existing.milestonesClaimed.contains(totalDays)) {
      milestoneBonus += checkInFullMonthBonus;
      newMilestones.add(totalDays);
    }

    return _CheckInRewards(
      dailyCoins: dailyCoins,
      milestoneBonus: milestoneBonus,
      newMilestones: newMilestones,
      newDays: newDays,
      allMilestones: [...existing.milestonesClaimed, ...newMilestones],
      totalCoins: existing.totalCoins + dailyCoins + milestoneBonus,
    );
  }

  /// 持久化签到数据：月度表 + 物化状态 + 台账。
  Future<void> _persistCheckIn(
    Transaction txn,
    String uid,
    DateTime now,
    String today,
    String month,
    MonthlyCheckIn existing,
    _CheckInRewards rewards,
  ) async {
    await txn.insert(
      'local_monthly_checkins',
      MonthlyCheckIn(
        month: month,
        checkedDays: rewards.newDays,
        totalCoins: rewards.totalCoins,
        milestonesClaimed: rewards.allMilestones,
      ).toSqlite(uid),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final totalReward = rewards.dailyCoins + rewards.milestoneBonus;
    final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
    final newCoins = (int.tryParse(raw ?? '0') ?? 0) + totalReward;
    await _ledger.setMaterializedInTxn(txn, uid, 'coins', newCoins.toString());
    await _ledger.setMaterializedInTxn(txn, uid, 'last_check_in_date', today);

    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    await _ledger.appendInTxn(
      txn,
      type: ActionType.checkIn,
      uid: uid,
      startedAt: now,
      payload: {'month': month, 'day': now.day, 'isWeekend': isWeekend},
      result: {'coins': totalReward, 'milestone': rewards.milestoneBonus},
    );
  }

  /// 扣减金币。余额不足返回 false。
  Future<bool> spendCoins({required String uid, required int amount}) async {
    if (amount <= 0)
      throw ArgumentError('amount must be positive, got $amount');
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
    if (price <= 0) throw ArgumentError('price must be positive, got $price');
    if (accessoryId.isEmpty) {
      throw ArgumentError('accessoryId must not be empty');
    }
    final db = await _ledger.database;

    try {
      final result = await db.transaction(
        (txn) => _executePurchaseTxn(txn, uid, accessoryId, price),
      );
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

  /// 购买事务：校验余额 → 校验库存 → 扣币 → 追加配饰 → 写台账。
  Future<bool> _executePurchaseTxn(
    Transaction txn,
    String uid,
    String accessoryId,
    int price,
  ) async {
    final raw = await _ledger.getMaterializedInTxn(txn, uid, 'coins');
    final balance = int.tryParse(raw ?? '0') ?? 0;
    if (balance < price) return false;

    final invRaw = await _ledger.getMaterializedInTxn(txn, uid, 'inventory');
    final inventory = _decodeInventory(invRaw);
    if (inventory.contains(accessoryId)) return false;

    await _ledger.setMaterializedInTxn(
      txn,
      uid,
      'coins',
      (balance - price).toString(),
    );

    inventory.add(accessoryId);
    await _ledger.setMaterializedInTxn(
      txn,
      uid,
      'inventory',
      jsonEncode(inventory),
    );

    await _ledger.appendInTxn(
      txn,
      type: ActionType.purchase,
      uid: uid,
      startedAt: DateTime.now(),
      payload: {'accessoryId': accessoryId, 'price': price},
      result: {'coins': -price},
    );

    return true;
  }

  /// 增加金币（计时奖励用）。
  Future<void> earnCoins({required String uid, required int amount}) async {
    if (amount <= 0)
      throw ArgumentError('amount must be positive, got $amount');
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
    if (decoded is List) return decoded.whereType<String>().toList();
    return [];
  }
}

/// 签到奖励计算结果（内部使用）。
class _CheckInRewards {
  final int dailyCoins;
  final int milestoneBonus;
  final List<int> newMilestones;
  final List<int> newDays;
  final List<int> allMilestones;
  final int totalCoins;

  const _CheckInRewards({
    required this.dailyCoins,
    required this.milestoneBonus,
    required this.newMilestones,
    required this.newDays,
    required this.allMilestones,
    required this.totalCoins,
  });

  CheckInResult toResult() => CheckInResult(
    dailyCoins: dailyCoins,
    milestoneBonus: milestoneBonus,
    newMilestones: newMilestones,
  );
}
