import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 后台静默同步引擎 — 将未同步台账条目推送到 Firestore。
/// 触发条件：auth 完成后 / offline→online / 新行为写入（debounce 2s）。
/// 对用户完全透明，无 UI 反馈。
class SyncEngine {
  final LedgerService _ledger;
  final FirebaseFirestore _db;
  final Connectivity _connectivity;

  StreamSubscription<LedgerChange>? _ledgerSub;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _debounce;
  bool _isSyncing = false;
  String? _uid;

  SyncEngine({
    required LedgerService ledger,
    FirebaseFirestore? db,
    Connectivity? connectivity,
  }) : _ledger = ledger,
       _db = db ?? FirebaseFirestore.instance,
       _connectivity = connectivity ?? Connectivity();

  /// 启动同步引擎。
  void start(String uid) {
    _uid = uid;

    // 监听台账变更（debounce 2s）
    _ledgerSub = _ledger.changes.listen((_) => _scheduleSync());

    // 监听网络恢复
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) _scheduleSync();
    });

    // 首次启动立即同步
    _scheduleSync();
  }

  /// 停止同步引擎。
  void stop() {
    _ledgerSub?.cancel();
    _connectivitySub?.cancel();
    _debounce?.cancel();
    _ledgerSub = null;
    _connectivitySub = null;
    _debounce = null;
    _uid = null;
  }

  void _scheduleSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), _sync);
  }

  Future<void> _sync() async {
    if (_isSyncing || _uid == null) return;
    _isSyncing = true;

    try {
      final actions = await _ledger.getUnsyncedActions(limit: 20);
      if (actions.isEmpty) {
        await _ledger.cleanOldSyncedActions();
        return;
      }

      for (final action in actions) {
        await _syncAction(action);
      }

      // 同步完成后清理旧台账
      await _ledger.cleanOldSyncedActions();

      debugPrint('SyncEngine: synced ${actions.length} actions');
    } catch (e) {
      debugPrint('SyncEngine error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncAction(LedgerAction action) async {
    try {
      final uid = action.uid;
      final batch = _db.batch();

      switch (action.type) {
        case ActionType.checkIn:
          _syncCheckIn(batch, uid, action);
        case ActionType.focusComplete:
        case ActionType.focusAbandon:
          _syncSession(batch, uid, action);
        case ActionType.purchase:
          _syncPurchase(batch, uid, action);
        case ActionType.equip:
        case ActionType.unequip:
          _syncEquip(batch, uid, action);
        case ActionType.habitCreate:
        case ActionType.habitUpdate:
        case ActionType.habitDelete:
          _syncHabit(batch, uid, action);
        case ActionType.achievementUnlocked:
          _syncAchievement(batch, uid, action);
        case ActionType.accountCreated:
        case ActionType.accountLinked:
        case ActionType.achievementClaimed:
          // 这些类型暂不需要同步
          await _ledger.markSynced(action.id);
          return;
      }

      await batch.commit();
      await _ledger.markSynced(action.id);
    } catch (e) {
      final attempts = action.syncAttempts + 1;
      await _ledger.markSyncFailed(action.id, e.toString(), attempts);
      debugPrint('SyncEngine: failed to sync ${action.id}: $e');
    }
  }

  void _syncCheckIn(WriteBatch batch, String uid, LedgerAction action) {
    final month = action.payload['month'] as String?;
    final day = action.payload['day'] as int?;
    final coins = action.result['coins'] as int? ?? 0;
    final milestone = action.result['milestone'] as int? ?? 0;

    if (month == null || day == null) return;

    final userRef = _db.collection('users').doc(uid);
    final monthRef = userRef.collection('monthlyCheckIns').doc(month);

    batch.set(monthRef, {
      'checkedDays': FieldValue.arrayUnion([day]),
      'totalCoins': FieldValue.increment(coins),
      if (milestone > 0)
        'milestonesClaimed': FieldValue.arrayUnion([milestone]),
    }, SetOptions(merge: true));

    batch.update(userRef, {
      'coins': FieldValue.increment(coins),
      'lastCheckInDate': action.startedAt.toIso8601String().substring(0, 10),
    });
  }

  void _syncSession(WriteBatch batch, String uid, LedgerAction action) {
    final habitId = action.payload['habitId'] as String?;
    final catId = action.payload['catId'] as String?;
    final minutes = action.payload['minutes'] as int? ?? 0;
    final coins = action.result['coins'] as int? ?? 0;
    final xp = action.result['xp'] as int? ?? 0;

    if (habitId == null || catId == null) return;

    final sessionRef = _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId)
        .collection('sessions')
        .doc(action.id);

    batch.set(sessionRef, {
      'habitId': habitId,
      'catId': catId,
      'startedAt': Timestamp.fromDate(action.startedAt),
      'endedAt': Timestamp.fromDate(action.endedAt ?? action.startedAt),
      'durationMinutes': minutes,
      'status': action.type == ActionType.focusComplete
          ? 'completed'
          : 'abandoned',
      'mode': action.payload['mode'] ?? 'countdown',
      'xpEarned': xp,
      'coinsEarned': coins,
    });

    // 更新 habit 累计
    if (action.type == ActionType.focusComplete) {
      final habitRef = _db
          .collection('users')
          .doc(uid)
          .collection('habits')
          .doc(habitId);
      batch.update(habitRef, {'totalMinutes': FieldValue.increment(minutes)});

      // 更新 cat 累计
      final catRef = _db
          .collection('users')
          .doc(uid)
          .collection('cats')
          .doc(catId);
      batch.update(catRef, {
        'totalMinutes': FieldValue.increment(minutes),
        'lastSessionAt': Timestamp.fromDate(action.endedAt ?? action.startedAt),
      });

      // 更新用户金币
      if (coins > 0) {
        batch.update(_db.collection('users').doc(uid), {
          'coins': FieldValue.increment(coins),
        });
      }
    }
  }

  void _syncPurchase(WriteBatch batch, String uid, LedgerAction action) {
    final accessoryId = action.payload['accessoryId'] as String?;
    final price = action.payload['price'] as int? ?? 0;

    if (accessoryId == null) return;

    final userRef = _db.collection('users').doc(uid);
    batch.update(userRef, {
      'coins': FieldValue.increment(-price),
      'inventory': FieldValue.arrayUnion([accessoryId]),
    });
  }

  void _syncEquip(WriteBatch batch, String uid, LedgerAction action) {
    final catId = action.payload['catId'] as String?;
    final accessoryId = action.payload['accessoryId'] as String?;

    if (catId == null) return;

    final userRef = _db.collection('users').doc(uid);
    final catRef = userRef.collection('cats').doc(catId);

    if (action.type == ActionType.equip) {
      final previousId = action.payload['previousId'] as String?;
      batch.update(userRef, {
        'inventory': FieldValue.arrayRemove([accessoryId]),
      });
      if (previousId != null && previousId.isNotEmpty) {
        batch.update(userRef, {
          'inventory': FieldValue.arrayUnion([previousId]),
        });
      }
      batch.update(catRef, {'equippedAccessory': accessoryId});
    } else {
      batch.update(userRef, {
        'inventory': FieldValue.arrayUnion([accessoryId]),
      });
      batch.update(catRef, {'equippedAccessory': null});
    }
  }

  void _syncHabit(WriteBatch batch, String uid, LedgerAction action) {
    final habitId = action.payload['habitId'] as String?;
    if (habitId == null) return;

    final habitRef = _db
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId);

    switch (action.type) {
      case ActionType.habitCreate:
        // 创建时从本地表读取完整数据来同步
        // 简化处理：仅标记台账已同步，完整数据由对账补齐
        break;
      case ActionType.habitDelete:
        batch.update(habitRef, {'isActive': false});
      default:
        break;
    }
  }

  void _syncAchievement(WriteBatch batch, String uid, LedgerAction action) {
    final achievementId = action.payload['achievementId'] as String?;
    if (achievementId == null) return;

    final coins = action.result['coins'] as int? ?? 0;

    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('achievements')
        .doc(achievementId);

    batch.set(ref, {
      'unlockedAt': FieldValue.serverTimestamp(),
      'rewardClaimed': true,
    });

    if (coins > 0) {
      batch.update(_db.collection('users').doc(uid), {
        'coins': FieldValue.increment(coins),
      });
    }

    final title = action.result['title'] as String?;
    if (title != null) {
      batch.update(_db.collection('users').doc(uid), {
        'unlockedTitles': FieldValue.arrayUnion([title]),
      });
    }
  }
}
