// ---
// 📘 文件说明：
// CoinService — 金币系统服务。
// 管理月度签到奖励（weekday/weekend + 里程碑）、余额查询、金币消费、饰品购买。
//
// 📋 程序整体伪代码：
// 1. checkIn：判断今日是否已签到，未签到则按 weekday/weekend 发放金币 + 检查里程碑；
// 2. watchMonthlyCheckIn：实时监听当月签到文档；
// 3. spendCoins：扣减金币，余额不足返回 false；
// 4. purchaseAccessory：事务操作：扣币 + 追加饰品到用户 inventory；
// 5. watchBalance / getBalance：实时/一次性读取余额；
//
// 🕒 创建时间：2026-02-18
// 🔄 更新：2026-02-19 — 重构为月度签到系统
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:intl/intl.dart';

/// CoinService — 金币签到 + 消费，完全独立不依赖其他 Service。
class CoinService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _userRef(String uid) =>
      _db.collection('users').doc(uid);

  DocumentReference _monthlyCheckInRef(String uid, String month) =>
      _db.collection('users').doc(uid).collection('monthlyCheckIns').doc(month);

  /// 今日日期字符串。
  String _todayDate() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 当月字符串，如 "2026-02"。
  String _currentMonth() => DateFormat('yyyy-MM').format(DateTime.now());

  /// 当月总天数。
  int _daysInMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0).day;

  /// 实时监听金币余额。
  Stream<int> watchBalance(String uid) {
    return _userRef(uid).snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return data?['coins'] as int? ?? 0;
    });
  }

  /// 一次性获取金币余额。
  Future<int> getBalance(String uid) async {
    final doc = await _userRef(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    return data?['coins'] as int? ?? 0;
  }

  /// 检查今日是否已签到。
  Future<bool> hasCheckedInToday(String uid) async {
    final doc = await _userRef(uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    final lastDate = data?['lastCheckInDate'] as String?;
    return lastDate == _todayDate();
  }

  /// 实时监听当月签到文档。
  Stream<MonthlyCheckIn?> watchMonthlyCheckIn(String uid) {
    final month = _currentMonth();
    return _monthlyCheckInRef(uid, month).snapshots().map((doc) {
      if (!doc.exists) return MonthlyCheckIn.empty(month);
      return MonthlyCheckIn.fromFirestore(doc);
    });
  }

  /// 每日签到（月度系统）。
  /// 返回 CheckInResult 表示签到成功及奖励详情，null 表示今日已签到。
  Future<CheckInResult?> checkIn(String uid) async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final month = DateFormat('yyyy-MM').format(now);
    final dayOfMonth = now.day;
    final isWeekend = now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday;
    final totalDaysInMonth = _daysInMonth(now);

    final userRef = _userRef(uid);
    final monthRef = _monthlyCheckInRef(uid, month);

    return _db.runTransaction((tx) async {
      // 1. 检查今日是否已签到
      final userDoc = await tx.get(userRef);
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      final lastDate = userData['lastCheckInDate'] as String?;
      if (lastDate == today) return null;

      // 2. 读取当月签到文档
      final monthDoc = await tx.get(monthRef);
      final existingDays = monthDoc.exists
          ? List<int>.from(
              (monthDoc.data() as Map<String, dynamic>)['checkedDays']
                      as List<dynamic>? ??
                  [])
          : <int>[];
      final existingMilestones = monthDoc.exists
          ? List<int>.from(
              (monthDoc.data() as Map<String, dynamic>)['milestonesClaimed']
                      as List<dynamic>? ??
                  [])
          : <int>[];
      // 3. 计算每日奖励
      final dailyCoins = isWeekend ? checkInCoinsWeekend : checkInCoinsWeekday;

      // 4. 计算新的签到天数
      final newDays = [...existingDays, dayOfMonth];
      final newCount = newDays.length;

      // 5. 检查里程碑
      int milestoneBonus = 0;
      final newMilestones = <int>[];

      for (final entry in checkInMilestones.entries) {
        if (newCount >= entry.key && !existingMilestones.contains(entry.key)) {
          milestoneBonus += entry.value;
          newMilestones.add(entry.key);
        }
      }

      // 6. 检查全月奖励
      if (newCount == totalDaysInMonth &&
          !existingMilestones.contains(totalDaysInMonth)) {
        milestoneBonus += checkInFullMonthBonus;
        newMilestones.add(totalDaysInMonth);
      }

      final totalReward = dailyCoins + milestoneBonus;

      // 7. 更新月度签到文档
      if (monthDoc.exists) {
        tx.update(monthRef, {
          'checkedDays': FieldValue.arrayUnion([dayOfMonth]),
          'totalCoins': FieldValue.increment(totalReward),
          if (newMilestones.isNotEmpty)
            'milestonesClaimed': FieldValue.arrayUnion(newMilestones),
        });
      } else {
        tx.set(monthRef, {
          'checkedDays': [dayOfMonth],
          'totalCoins': totalReward,
          'milestonesClaimed': newMilestones,
        });
      }

      // 8. 更新用户金币 + lastCheckInDate
      tx.update(userRef, {
        'coins': FieldValue.increment(totalReward),
        'lastCheckInDate': today,
      });

      return CheckInResult(
        dailyCoins: dailyCoins,
        milestoneBonus: milestoneBonus,
        newMilestones: newMilestones,
      );
    });
  }

  /// 扣减金币。余额不足返回 false。
  Future<bool> spendCoins({
    required String uid,
    required int amount,
  }) async {
    final userRef = _userRef(uid);

    return _db.runTransaction((tx) async {
      final doc = await tx.get(userRef);
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final balance = data['coins'] as int? ?? 0;

      if (balance < amount) return false;

      tx.update(userRef, {
        'coins': FieldValue.increment(-amount),
      });
      return true;
    });
  }

  /// 购买饰品：扣币 + 追加配饰到用户 inventory。
  /// 返回 true 表示购买成功。
  Future<bool> purchaseAccessory({
    required String uid,
    required String accessoryId,
    required int price,
  }) async {
    final userRef = _userRef(uid);

    return _db.runTransaction((tx) async {
      final userDoc = await tx.get(userRef);
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      final balance = userData['coins'] as int? ?? 0;

      if (balance < price) return false;

      // 检查是否已在 inventory 中
      final inventory = List<String>.from(
          userData['inventory'] as List<dynamic>? ?? []);
      if (inventory.contains(accessoryId)) return false;

      tx.update(userRef, {
        'coins': FieldValue.increment(-price),
        'inventory': FieldValue.arrayUnion([accessoryId]),
      });
      return true;
    });
  }
}
