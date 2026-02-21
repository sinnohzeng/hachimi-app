import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/core/utils/performance_traces.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/core/utils/streak_utils.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/check_in.dart';
import 'package:hachimi_app/models/focus_session.dart';
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
    required int targetHours,
    int goalMinutes = 25,
    String? reminderTime,
    String? catId,
  }) async {
    final docRef = await _habitsRef(uid).add({
      'name': name,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminderTime': reminderTime,
      'catId': catId,
      'isActive': true,
      'totalMinutes': 0,
      'currentStreak': 0,
      'bestStreak': 0,
      'lastCheckInDate': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Create a habit and its bound cat in a single batch.
  /// Cat stores appearance Map + targetMinutes (targetHours × 60).
  Future<({String habitId, String catId})> createHabitWithCat({
    required String uid,
    required String name,
    required int targetHours,
    required int goalMinutes,
    String? reminderTime,
    required Cat cat,
  }) async {
    final batch = _db.batch();

    // 1. Create habit document
    final habitRef = _habitsRef(uid).doc();
    batch.set(habitRef, {
      'name': name,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminderTime': reminderTime,
      'catId': '', // Will update after cat is created
      'isActive': true,
      'totalMinutes': 0,
      'currentStreak': 0,
      'bestStreak': 0,
      'lastCheckInDate': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Create cat document with pixel cat appearance
    final catRef = _catsRef(uid).doc();
    final catData = cat
        .copyWith(boundHabitId: habitRef.id, targetMinutes: targetHours * 60)
        .toFirestore();
    catData['createdAt'] = FieldValue.serverTimestamp();
    batch.set(catRef, catData);

    // 3. Update habit with cat reference
    batch.update(habitRef, {'catId': catRef.id});

    try {
      await batch.commit();
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'FirestoreService', operation: 'createHabitWithCat');
      rethrow;
    }
    return (habitId: habitRef.id, catId: catRef.id);
  }

  /// Update a habit's editable fields.
  /// When [targetHours] changes, syncs [cat.targetMinutes] = targetHours × 60.
  Future<void> updateHabit({
    required String uid,
    required String habitId,
    String? name,
    int? goalMinutes,
    int? targetHours,
    String? reminderTime,
    bool clearReminder = false,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null && name.trim().isNotEmpty) updates['name'] = name.trim();
    if (goalMinutes != null) updates['goalMinutes'] = goalMinutes;
    if (targetHours != null) updates['targetHours'] = targetHours;
    if (reminderTime != null) updates['reminderTime'] = reminderTime;
    if (clearReminder) updates['reminderTime'] = null;
    if (updates.isEmpty) return;

    await _habitsRef(uid).doc(habitId).update(updates);

    // Sync cat.targetMinutes when targetHours changes
    if (targetHours != null) {
      final habitDoc = await _habitsRef(uid).doc(habitId).get();
      if (habitDoc.exists) {
        final catId =
            (habitDoc.data() as Map<String, dynamic>)['catId'] as String?;
        if (catId != null && catId.isNotEmpty) {
          await _catsRef(
            uid,
          ).doc(catId).update({'targetMinutes': targetHours * 60});
        }
      }
    }
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
  /// 2. Update habit totals + streak
  /// 3. Update cat totalMinutes + lastSessionAt
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

    // 2. Add check-in entry
    final entryRef = _entriesRef(uid, today).doc();
    batch.set(entryRef, {
      'habitId': session.habitId,
      'habitName': habitName,
      'minutes': session.durationMinutes,
      'completedAt': FieldValue.serverTimestamp(),
    });

    // 3. Update habit totals and streak
    final habitRef = _habitsRef(uid).doc(session.habitId);
    final habitDoc = await habitRef.get();

    if (habitDoc.exists) {
      final habit = Habit.fromFirestore(habitDoc);
      final yesterday = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(const Duration(days: 1)));

      final newStreak = StreakUtils.calculateNewStreak(
        lastCheckInDate: habit.lastCheckInDate,
        today: today,
        yesterday: yesterday,
        currentStreak: habit.currentStreak,
      );

      final newBest = newStreak > habit.bestStreak
          ? newStreak
          : habit.bestStreak;

      batch.update(habitRef, {
        'totalMinutes': FieldValue.increment(session.durationMinutes),
        'currentStreak': newStreak,
        'bestStreak': newBest,
        'lastCheckInDate': today,
      });
    }

    // 4. Update cat totalMinutes + lastSessionAt (time-based growth)
    if (session.catId.isNotEmpty) {
      final catRef = _catsRef(uid).doc(session.catId);
      batch.update(catRef, {
        'totalMinutes': FieldValue.increment(session.durationMinutes),
        'lastSessionAt': FieldValue.serverTimestamp(),
      });
    }

    // 5. Award focus coins (durationMinutes × coinsPerMinute)
    if (session.coinsEarned > 0) {
      final userRef = _db.collection('users').doc(uid);
      batch.update(userRef, {
        'coins': FieldValue.increment(session.coinsEarned),
      });
    }

    try {
      await batch.commit();
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'FirestoreService', operation: 'logFocusSession');
      rethrow;
    }
  });

  // ─── Check-ins ───

  CollectionReference _entriesRef(String uid, String date) => _db
      .collection('users')
      .doc(uid)
      .collection('checkIns')
      .doc(date)
      .collection('entries');

  Stream<List<CheckInEntry>> watchTodayCheckIns(String uid) {
    final today = AppDateUtils.todayString();
    return _entriesRef(uid, today)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(CheckInEntry.fromFirestore).toList(),
        );
  }

  Future<void> logCheckIn({
    required String uid,
    required String habitId,
    required String habitName,
    required int minutes,
  }) async {
    final today = AppDateUtils.todayString();
    final batch = _db.batch();

    // 1. Add check-in entry
    final entryRef = _entriesRef(uid, today).doc();
    batch.set(entryRef, {
      'habitId': habitId,
      'habitName': habitName,
      'minutes': minutes,
      'completedAt': FieldValue.serverTimestamp(),
    });

    // 2. Update habit totals and streak
    final habitRef = _habitsRef(uid).doc(habitId);
    final habitDoc = await habitRef.get();

    if (habitDoc.exists) {
      final habit = Habit.fromFirestore(habitDoc);
      final yesterday = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(const Duration(days: 1)));

      final newStreak = StreakUtils.calculateNewStreak(
        lastCheckInDate: habit.lastCheckInDate,
        today: today,
        yesterday: yesterday,
        currentStreak: habit.currentStreak,
      );

      final newBest = newStreak > habit.bestStreak
          ? newStreak
          : habit.bestStreak;

      batch.update(habitRef, {
        'totalMinutes': FieldValue.increment(minutes),
        'currentStreak': newStreak,
        'bestStreak': newBest,
        'lastCheckInDate': today,
      });
    }

    try {
      await batch.commit();
    } catch (e, stack) {
      ErrorHandler.record(e, stackTrace: stack, source: 'FirestoreService', operation: 'logCheckIn');
      rethrow;
    }
  }

  // ─── Stats ───

  Future<List<String>> getCheckInDates({
    required String uid,
    required int lastNDays,
  }) async {
    final allDates = List.generate(
      lastNDays,
      (i) => DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(Duration(days: i))),
    );

    final results = await Future.wait(
      allDates.map((date) async {
        final snapshot = await _entriesRef(uid, date).limit(1).get();
        return snapshot.docs.isNotEmpty ? date : null;
      }),
    );

    return results.whereType<String>().toList();
  }

  /// Get daily focus minutes for a specific habit over the last N days.
  /// Queries run in parallel with a 10-second timeout for performance.
  Future<Map<String, int>> getDailyMinutesForHabit({
    required String uid,
    required String habitId,
    required int lastNDays,
  }) async {
    final dates = List.generate(
      lastNDays,
      (i) => DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(Duration(days: i))),
    );

    final futures = dates.map((date) async {
      final snapshot = await _entriesRef(
        uid,
        date,
      ).where('habitId', isEqualTo: habitId).limit(100).get();
      int dayTotal = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        dayTotal += (data['minutes'] as int? ?? 0);
      }
      return MapEntry(date, dayTotal);
    });

    final entries = await Future.wait(
      futures,
    ).timeout(const Duration(seconds: 10));

    final result = <String, int>{};
    for (final entry in entries) {
      if (entry.value > 0) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}
