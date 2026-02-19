// ---
// 📘 文件说明：
// CoinService — 金币系统服务。
// 管理每日签到奖励、余额查询、金币消费、饰品购买。
//
// 📋 程序整体伪代码：
// 1. checkIn：判断今日是否已签到，未签到则 +50 金币；
// 2. spendCoins：扣减金币，余额不足返回 false；
// 3. purchaseAccessory：batch 操作：扣币 + 追加饰品到猫；
// 4. watchBalance / getBalance：实时/一次性读取余额；
//
// 🕒 创建时间：2026-02-18
// ---

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:intl/intl.dart';

/// CoinService — 金币签到 + 消费，完全独立不依赖其他 Service。
class CoinService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _userRef(String uid) =>
      _db.collection('users').doc(uid);

  /// 今日日期字符串。
  String _todayDate() => DateFormat('yyyy-MM-dd').format(DateTime.now());

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

  /// 每日签到：若今日未签到则 +50 金币。
  /// 返回 true 表示签到成功，false 表示今日已签到。
  Future<bool> checkIn(String uid) async {
    final today = _todayDate();
    final userRef = _userRef(uid);

    return _db.runTransaction((tx) async {
      final doc = await tx.get(userRef);
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final lastDate = data['lastCheckInDate'] as String?;

      if (lastDate == today) return false;

      tx.update(userRef, {
        'coins': FieldValue.increment(dailyCheckInCoins),
        'lastCheckInDate': today,
      });
      return true;
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

  /// 购买饰品：batch 扣币 + 追加饰品到猫。
  /// 返回 true 表示购买成功。
  Future<bool> purchaseAccessory({
    required String uid,
    required String catId,
    required String accessoryId,
    required int price,
  }) async {
    final userRef = _userRef(uid);
    final catRef = _db
        .collection('users')
        .doc(uid)
        .collection('cats')
        .doc(catId);

    return _db.runTransaction((tx) async {
      final userDoc = await tx.get(userRef);
      final userData = userDoc.data() as Map<String, dynamic>? ?? {};
      final balance = userData['coins'] as int? ?? 0;

      if (balance < price) return false;

      final catDoc = await tx.get(catRef);
      if (!catDoc.exists) return false;

      final catData = catDoc.data() ?? {};
      final accessories = List<String>.from(
          catData['accessories'] as List<dynamic>? ?? []);

      if (accessories.contains(accessoryId)) return false;

      accessories.add(accessoryId);

      tx.update(userRef, {
        'coins': FieldValue.increment(-price),
      });
      tx.update(catRef, {
        'accessories': accessories,
      });
      return true;
    });
  }
}
