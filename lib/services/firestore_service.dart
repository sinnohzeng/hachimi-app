import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/models/reminder_config.dart';
import 'package:intl/intl.dart';

/// FirestoreService — wraps Firestore CRUD for users, habits, sessions, stats.
/// Cat-specific CRUD has been extracted to CatFirestoreService.
/// Coin operations are in CoinService.
/// See docs/architecture/data-model.md for schema definition.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── User Profile ───

  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'displayName': displayName ?? email.split('@').first,
      'coins': 0,
      'inventory': <String>[],
      'lastCheckInDate': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 更新用户资料字段（displayName、avatarId）。
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? avatarId,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (avatarId != null) updates['avatarId'] = avatarId;
    if (updates.isEmpty) return;
    await _db.collection('users').doc(uid).update(updates);
  }

  /// 监听用户头像 ID。返回 null 表示未设置头像（使用首字母兜底）。
  Stream<String?> watchAvatarId(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data()?['avatarId'] as String?);
  }

  // ─── Habits ───

  CollectionReference _habitsRef(String uid) =>
      _db.collection('users').doc(uid).collection('habits');

  CollectionReference _catsRef(String uid) =>
      _db.collection('users').doc(uid).collection('cats');

  Stream<List<Habit>> watchHabits(String uid) {
    return _habitsRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Habit.fromFirestore).toList());
  }

  Future<Habit?> getHabit(String uid, String habitId) async {
    final doc = await _habitsRef(uid).doc(habitId).get();
    if (!doc.exists) return null;
    return Habit.fromFirestore(doc);
  }

  Future<String> createHabit({
    required String uid,
    required String name,
    int? targetHours,
    int goalMinutes = 25,
    List<ReminderConfig>? reminders,
    String? catId,
  }) async {
    final docRef = await _habitsRef(uid).add({
      'name': name,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminders': reminders?.map((r) => r.toMap()).toList() ?? [],
      'catId': catId,
      'isActive': true,
      'totalMinutes': 0,
      'lastCheckInDate': null,
      'totalCheckInDays': 0,
      'targetCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Create a habit and its bound cat in a single batch.
  Future<({String habitId, String catId})> createHabitWithCat({
    required String uid,
    required String name,
    int? targetHours,
    required int goalMinutes,
    List<ReminderConfig>? reminders,
    String? motivationText,
    DateTime? deadlineDate,
    required Cat cat,
  }) async {
    final batch = _db.batch();

    // 1. Create habit document
    final habitRef = _habitsRef(uid).doc();
    batch.set(habitRef, {
      'name': name,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminders': reminders?.map((r) => r.toMap()).toList() ?? [],
      'motivationText': ?motivationText,
      if (deadlineDate != null)
        'deadlineDate': Timestamp.fromDate(deadlineDate),
      'catId': '', // Will update after cat is created
      'isActive': true,
      'totalMinutes': 0,
      'lastCheckInDate': null,
      'totalCheckInDays': 0,
      'targetCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Create cat document with pixel cat appearance
    final catRef = _catsRef(uid).doc();
    final catData = cat.copyWith(boundHabitId: habitRef.id).toFirestore();
    catData['createdAt'] = FieldValue.serverTimestamp();
    batch.set(catRef, catData);

    // 3. Update habit with cat reference
    batch.update(habitRef, {'catId': catRef.id});

    try {
      await batch.commit();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'FirestoreService',
        operation: 'createHabitWithCat',
      );
      rethrow;
    }
    return (habitId: habitRef.id, catId: catRef.id);
  }

  /// Update a habit's editable fields.
  Future<void> updateHabit({
    required String uid,
    required String habitId,
    String? name,
    int? goalMinutes,
    int? targetHours,
    bool clearTargetHours = false,
    List<ReminderConfig>? reminders,
    bool clearReminders = false,
    String? motivationText,
    bool clearMotivation = false,
    DateTime? deadlineDate,
    bool clearDeadlineDate = false,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null && name.trim().isNotEmpty) updates['name'] = name.trim();
    if (goalMinutes != null) updates['goalMinutes'] = goalMinutes;
    if (clearTargetHours) {
      updates['targetHours'] = null;
    } else if (targetHours != null) {
      updates['targetHours'] = targetHours;
    }
    if (reminders != null) {
      updates['reminders'] = reminders.map((r) => r.toMap()).toList();
    }
    if (clearReminders) updates['reminders'] = [];
    if (motivationText != null && motivationText.trim().isNotEmpty) {
      updates['motivationText'] = motivationText.trim();
    }
    if (clearMotivation) updates['motivationText'] = null;
    if (clearDeadlineDate) {
      updates['deadlineDate'] = null;
    } else if (deadlineDate != null) {
      updates['deadlineDate'] = Timestamp.fromDate(deadlineDate);
    }
    if (updates.isEmpty) return;

    await _habitsRef(uid).doc(habitId).update(updates);
  }

  Future<void> deleteHabit({
    required String uid,
    required String habitId,
  }) async {
    // Graduate the bound cat when its habit is deleted
    final habitDoc = await _habitsRef(uid).doc(habitId).get();
    if (habitDoc.exists) {
      final habit = Habit.fromFirestore(habitDoc);
      if (habit.catId != null && habit.catId!.isNotEmpty) {
        await _catsRef(
          uid,
        ).doc(habit.catId!).update({'state': CatState.graduated});
      }
    }
    await _habitsRef(uid).doc(habitId).delete();
  }

  // ─── Focus Sessions ───

  CollectionReference _sessionsRef(String uid, String habitId) =>
      _habitsRef(uid).doc(habitId).collection('sessions');

  /// Log a completed focus session with atomic batch updates:
  /// 1. Write session document
  /// 2. Update habit totals (cumulative, no streak)
  /// 3. Update cat totalMinutes + lastSessionAt + highestStage (fixed ladder)
  /// 4. Award focus coins
  /// 5. Check target completion (milestone mode)
  Future<void> logFocusSession({
    required String uid,
    required FocusSession session,
    String habitName = '',
  }) => AppTraces.trace('log_focus_session', () async {
    final today = AppDateUtils.todayString();
    final batch = _db.batch();

    // 1. Write session document
    final sessionRef = _sessionsRef(uid, session.habitId).doc();
    batch.set(sessionRef, session.toFirestore());

    // 2. Update habit totals
    final habitRef = _habitsRef(uid).doc(session.habitId);
    final habitDoc = await habitRef.get();

    if (habitDoc.exists) {
      final habit = Habit.fromFirestore(habitDoc);

      // 今日首次 session 时，累计打卡天数 +1
      final isFirstSessionToday = habit.lastCheckInDate != today;

      final habitUpdates = <String, dynamic>{
        'totalMinutes': FieldValue.increment(session.durationMinutes),
        'lastCheckInDate': today,
        if (isFirstSessionToday) 'totalCheckInDays': FieldValue.increment(1),
      };

      // 5. 目标达成检测（里程碑模式）
      if (habit.targetHours != null && !habit.targetCompleted) {
        final newTotalMinutes = habit.totalMinutes + session.durationMinutes;
        if (newTotalMinutes >= habit.targetHours! * 60) {
          habitUpdates['targetCompleted'] = true;
        }
      }

      batch.update(habitRef, habitUpdates);
    }

    // 3. Update cat totalMinutes + lastSessionAt + highestStage (fixed ladder)
    if (session.catId.isNotEmpty) {
      final catRef = _catsRef(uid).doc(session.catId);
      final catUpdates = <String, dynamic>{
        'totalMinutes': FieldValue.increment(session.durationMinutes),
        'lastSessionAt': FieldValue.serverTimestamp(),
      };

      // 检测是否升阶，原子更新 highestStage
      final catDoc = await catRef.get();
      if (catDoc.exists) {
        final cat = Cat.fromFirestore(catDoc);
        final newTotalMinutes = cat.totalMinutes + session.durationMinutes;
        // 固定阶梯：200h (12000min) = 1.0
        final newProgress = (newTotalMinutes / 12000.0).clamp(0.0, 1.0);
        final newStage = stageForProgress(newProgress);
        final currentHighest = cat.highestStage ?? cat.computedStage;
        if (stageOrder(newStage) > stageOrder(currentHighest)) {
          catUpdates['highestStage'] = newStage;
        }
      }

      batch.update(catRef, catUpdates);
    }

    // 4. Award focus coins + increment totalSessionCount
    final userRef = _db.collection('users').doc(uid);
    final userUpdates = <String, dynamic>{
      'totalSessionCount': FieldValue.increment(1),
    };
    if (session.coinsEarned > 0) {
      userUpdates['coins'] = FieldValue.increment(session.coinsEarned);
    }
    batch.update(userRef, userUpdates);

    try {
      await batch.commit();
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'FirestoreService',
        operation: 'logFocusSession',
      );
      rethrow;
    }
  });

  // ─── Session Queries ───

  /// 监听今日所有 session（跨习惯），替代旧的 watchTodayCheckIns。
  Stream<List<FocusSession>> watchTodaySessions(
    String uid,
    List<String> habitIds,
  ) {
    if (habitIds.isEmpty) return Stream.value([]);

    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final todayTimestamp = Timestamp.fromDate(todayStart);

    // 并行监听每个 habit 的 sessions 子集合，合并为单一 stream
    final streams = habitIds.map((habitId) {
      return _sessionsRef(uid, habitId)
          .where('endedAt', isGreaterThanOrEqualTo: todayTimestamp)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs.map(FocusSession.fromFirestore).toList(),
          );
    });

    // 合并所有 habit 的 session streams
    return _mergeStreams(streams.toList());
  }

  /// 分页查询专注历史（按 endedAt 降序）。
  /// [startDate] / [endDate] 用于月份筛选（endedAt 范围）。
  Future<({List<FocusSession> sessions, DocumentSnapshot? lastDoc})>
  getSessionHistory({
    required String uid,
    required List<String> habitIds,
    String? habitId,
    int limit = 20,
    DocumentSnapshot? startAfter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // 单个 habit 查询
    if (habitId != null) {
      Query query = _sessionsRef(
        uid,
        habitId,
      ).orderBy('endedAt', descending: true);
      if (startDate != null) {
        query = query.where(
          'endedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where('endedAt', isLessThan: Timestamp.fromDate(endDate));
      }
      query = query.limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      final sessions = snapshot.docs.map(FocusSession.fromFirestore).toList();
      final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      return (sessions: sessions, lastDoc: lastDocument);
    }

    // 跨 habit 查询：并行查询所有 habit 的 sessions，客户端合并排序
    final allSessions = <FocusSession>[];
    DocumentSnapshot? lastDocument;

    final futures = habitIds.map((hId) async {
      Query query = _sessionsRef(uid, hId).orderBy('endedAt', descending: true);
      if (startDate != null) {
        query = query.where(
          'endedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where('endedAt', isLessThan: Timestamp.fromDate(endDate));
      }
      // 分页对跨集合查询无法直接用 startAfter，使用时间戳过滤
      if (startAfter != null) {
        final lastData = startAfter.data() as Map<String, dynamic>?;
        if (lastData != null && lastData['endedAt'] != null) {
          query = _sessionsRef(uid, hId).orderBy('endedAt', descending: true);
          if (startDate != null) {
            query = query.where(
              'endedAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            );
          }
          query = query
              .where('endedAt', isLessThan: lastData['endedAt'])
              .limit(limit);
        } else {
          query = query.limit(limit);
        }
      } else {
        query = query.limit(limit);
      }
      return query.get();
    });

    final snapshots = await Future.wait(
      futures,
    ).timeout(const Duration(seconds: 10));
    for (final snapshot in snapshots) {
      allSessions.addAll(snapshot.docs.map(FocusSession.fromFirestore));
    }

    // 按 endedAt 降序排列，取前 limit 条
    allSessions.sort((a, b) => b.endedAt.compareTo(a.endedAt));
    final trimmed = allSessions.take(limit).toList();

    // 获取最后一个文档的原始 snapshot 作为游标
    if (trimmed.isNotEmpty) {
      final lastSession = trimmed.last;
      for (final snapshot in snapshots) {
        for (final doc in snapshot.docs) {
          if (doc.id == lastSession.id) {
            lastDocument = doc;
            break;
          }
        }
        if (lastDocument != null) break;
      }
    }

    return (sessions: trimmed, lastDoc: lastDocument);
  }

  /// 获取最近 N 天每日总分钟数（从 sessions 聚合）。
  Future<Map<String, int>> getDailyMinutesFromSessions({
    required String uid,
    required List<String> habitIds,
    required int lastNDays,
  }) async {
    if (habitIds.isEmpty) return {};

    final cutoff = DateTime.now().subtract(Duration(days: lastNDays));
    final cutoffTimestamp = Timestamp.fromDate(cutoff);
    final result = <String, int>{};

    final futures = habitIds.map((habitId) async {
      final snapshot = await _sessionsRef(
        uid,
        habitId,
      ).where('endedAt', isGreaterThanOrEqualTo: cutoffTimestamp).get();
      return snapshot.docs.map(FocusSession.fromFirestore).toList();
    });

    final allResults = await Future.wait(
      futures,
    ).timeout(const Duration(seconds: 10));

    for (final sessions in allResults) {
      for (final session in sessions) {
        final key = DateFormat('yyyy-MM-dd').format(session.endedAt);
        result[key] = (result[key] ?? 0) + session.durationMinutes;
      }
    }

    return result;
  }

  /// 获取最近 N 条 session（统计页预览用）。
  Future<List<FocusSession>> getRecentSessions({
    required String uid,
    required List<String> habitIds,
    int limit = 5,
  }) async {
    if (habitIds.isEmpty) return [];

    final allSessions = <FocusSession>[];
    final futures = habitIds.map((habitId) async {
      final snapshot = await _sessionsRef(
        uid,
        habitId,
      ).orderBy('endedAt', descending: true).limit(limit).get();
      return snapshot.docs.map(FocusSession.fromFirestore).toList();
    });

    final results = await Future.wait(futures);
    for (final sessions in results) {
      allSessions.addAll(sessions);
    }

    allSessions.sort((a, b) => b.endedAt.compareTo(a.endedAt));
    return allSessions.take(limit).toList();
  }

  /// 获取指定 habit 的每日专注分钟数（热力图用）。
  Future<Map<String, int>> getDailyMinutesForHabit({
    required String uid,
    required String habitId,
    required int lastNDays,
  }) async {
    final cutoff = DateTime.now().subtract(Duration(days: lastNDays));
    final cutoffTimestamp = Timestamp.fromDate(cutoff);

    final snapshot = await _sessionsRef(
      uid,
      habitId,
    ).where('endedAt', isGreaterThanOrEqualTo: cutoffTimestamp).get();

    final result = <String, int>{};
    for (final doc in snapshot.docs) {
      final session = FocusSession.fromFirestore(doc);
      final key = DateFormat('yyyy-MM-dd').format(session.endedAt);
      result[key] = (result[key] ?? 0) + session.durationMinutes;
    }
    return result;
  }

  // ─── Stats ───

  Future<List<String>> getCheckInDates({
    required String uid,
    required List<String> habitIds,
    required int lastNDays,
  }) async {
    // 使用 sessions 数据聚合活跃日期
    final dailyMinutes = await getDailyMinutesFromSessions(
      uid: uid,
      habitIds: habitIds,
      lastNDays: lastNDays,
    );
    return dailyMinutes.keys.toList();
  }

  /// 合并多个 stream 为一个，每次任一 stream 更新时重新汇总。
  Stream<List<FocusSession>> _mergeStreams(
    List<Stream<List<FocusSession>>> streams,
  ) {
    if (streams.isEmpty) return Stream.value([]);
    if (streams.length == 1) return streams.first;

    // 维护每个 stream 的最新值，任一更新时合并输出
    final latestValues = List<List<FocusSession>>.filled(
      streams.length,
      const [],
    );

    return Stream.multi((controller) {
      final subscriptions = <int, dynamic>{};

      for (int i = 0; i < streams.length; i++) {
        subscriptions[i] = streams[i].listen((data) {
          latestValues[i] = data;
          final merged = latestValues.expand((e) => e).toList();
          controller.add(merged);
        }, onError: controller.addError);
      }

      controller.onCancel = () {
        for (final sub in subscriptions.values) {
          (sub as dynamic).cancel();
        }
      };
    });
  }
}
