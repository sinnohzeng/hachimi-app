import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/check_in.dart';
import 'package:hachimi_app/models/focus_session.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:intl/intl.dart';

/// FirestoreService — wraps all Firestore CRUD operations.
/// Firestore is the SSOT for all business data.
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
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Habits ───

  CollectionReference _habitsRef(String uid) =>
      _db.collection('users').doc(uid).collection('habits');

  Stream<List<Habit>> watchHabits(String uid) {
    return _habitsRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList());
  }

  Future<Habit?> getHabit(String uid, String habitId) async {
    final doc = await _habitsRef(uid).doc(habitId).get();
    if (!doc.exists) return null;
    return Habit.fromFirestore(doc);
  }

  Future<String> createHabit({
    required String uid,
    required String name,
    required String icon,
    required int targetHours,
    int goalMinutes = 25,
    String? reminderTime,
    String? catId,
  }) async {
    final docRef = await _habitsRef(uid).add({
      'name': name,
      'icon': icon,
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
  Future<({String habitId, String catId})> createHabitWithCat({
    required String uid,
    required String name,
    required String icon,
    required int goalMinutes,
    String? reminderTime,
    required Cat cat,
  }) async {
    final batch = _db.batch();

    // 1. Create habit document
    final habitRef = _habitsRef(uid).doc();
    batch.set(habitRef, {
      'name': name,
      'icon': icon,
      'targetHours': 0, // Will accumulate over time
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

    // 2. Create cat document
    final catRef = _catsRef(uid).doc();
    final catData = cat.copyWith(boundHabitId: habitRef.id).toFirestore();
    catData['createdAt'] = FieldValue.serverTimestamp();
    batch.set(catRef, catData);

    // 3. Update habit with cat reference
    batch.update(habitRef, {'catId': catRef.id});

    await batch.commit();
    return (habitId: habitRef.id, catId: catRef.id);
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
        await graduateCat(uid: uid, catId: habit.catId!);
      }
    }
    await _habitsRef(uid).doc(habitId).delete();
  }

  // ─── Cats ───

  CollectionReference _catsRef(String uid) =>
      _db.collection('users').doc(uid).collection('cats');

  /// Watch all active cats for a user.
  Stream<List<Cat>> watchCats(String uid) {
    return _catsRef(uid)
        .where('state', isEqualTo: 'active')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cat.fromFirestore(doc)).toList());
  }

  /// Watch all cats (including graduated/dormant) for the Cat Album.
  Stream<List<Cat>> watchAllCats(String uid) {
    return _catsRef(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cat.fromFirestore(doc)).toList());
  }

  /// Get a single cat by ID.
  Future<Cat?> getCat(String uid, String catId) async {
    final doc = await _catsRef(uid).doc(catId).get();
    if (!doc.exists) return null;
    return Cat.fromFirestore(doc);
  }

  /// Update cat XP and recalculate stage.
  Future<void> updateCatXp({
    required String uid,
    required String catId,
    required int xpDelta,
  }) async {
    final catRef = _catsRef(uid).doc(catId);
    final catDoc = await catRef.get();
    if (!catDoc.exists) return;

    final cat = Cat.fromFirestore(catDoc);
    final newXp = cat.xp + xpDelta;
    final newStage = stageForXp(newXp);

    await catRef.update({
      'xp': newXp,
      'stage': newStage,
      'lastSessionAt': FieldValue.serverTimestamp(),
      'mood': 'happy', // Just had a session
    });
  }

  /// Update cat mood.
  Future<void> updateCatMood({
    required String uid,
    required String catId,
    required String mood,
  }) async {
    await _catsRef(uid).doc(catId).update({'mood': mood});
  }

  /// Refresh moods for all active cats based on lastSessionAt.
  Future<void> refreshAllCatMoods(String uid) async {
    final snapshot = await _catsRef(uid)
        .where('state', isEqualTo: 'active')
        .get();

    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      final cat = Cat.fromFirestore(doc);
      final newMood = calculateMood(cat.lastSessionAt);
      if (newMood != cat.mood) {
        batch.update(doc.reference, {'mood': newMood});
      }
    }
    await batch.commit();
  }

  /// Archive a cat (set state to dormant).
  Future<void> archiveCat({
    required String uid,
    required String catId,
  }) async {
    await _catsRef(uid).doc(catId).update({'state': 'dormant'});
  }

  /// Graduate a cat (set state to graduated, freeze stats).
  Future<void> graduateCat({
    required String uid,
    required String catId,
  }) async {
    await _catsRef(uid).doc(catId).update({'state': 'graduated'});
  }

  /// Get breeds owned by the user (for draft algorithm variety).
  Future<List<String>> getOwnedBreeds(String uid) async {
    final snapshot = await _catsRef(uid).get();
    return snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['breed'] as String)
        .toSet()
        .toList();
  }

  // ─── Focus Sessions ───

  CollectionReference _sessionsRef(String uid, String habitId) =>
      _habitsRef(uid).doc(habitId).collection('sessions');

  /// Log a completed focus session with atomic batch updates:
  /// 1. Write session document
  /// 2. Update habit totals + streak
  /// 3. Update cat XP + stage + mood
  Future<void> logFocusSession({
    required String uid,
    required FocusSession session,
  }) async {
    final today = _todayDate();
    final batch = _db.batch();

    // 1. Write session document
    final sessionRef = _sessionsRef(uid, session.habitId).doc();
    batch.set(sessionRef, session.toFirestore());

    // 2. Add legacy check-in entry (backward compat with existing stats)
    final entryRef = _entriesRef(uid, today).doc();
    batch.set(entryRef, {
      'habitId': session.habitId,
      'habitName': '', // Will be filled by caller if needed
      'minutes': session.durationMinutes,
      'completedAt': FieldValue.serverTimestamp(),
    });

    // 3. Update habit totals and streak
    final habitRef = _habitsRef(uid).doc(session.habitId);
    final habitDoc = await habitRef.get();

    if (habitDoc.exists) {
      final habit = Habit.fromFirestore(habitDoc);
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));

      int newStreak = habit.currentStreak;
      if (habit.lastCheckInDate == today) {
        newStreak = habit.currentStreak;
      } else if (habit.lastCheckInDate == yesterday) {
        newStreak = habit.currentStreak + 1;
      } else {
        newStreak = 1;
      }

      final newBest =
          newStreak > habit.bestStreak ? newStreak : habit.bestStreak;

      batch.update(habitRef, {
        'totalMinutes': FieldValue.increment(session.durationMinutes),
        'currentStreak': newStreak,
        'bestStreak': newBest,
        'lastCheckInDate': today,
      });
    }

    // 4. Update cat XP + stage + mood
    if (session.catId.isNotEmpty) {
      final catRef = _catsRef(uid).doc(session.catId);
      final catDoc = await catRef.get();

      if (catDoc.exists) {
        final cat = Cat.fromFirestore(catDoc);
        final newXp = cat.xp + session.xpEarned;
        final newStage = stageForXp(newXp);

        batch.update(catRef, {
          'xp': newXp,
          'stage': newStage,
          'mood': 'happy',
          'lastSessionAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  // ─── Check-ins ───

  String _todayDate() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference _entriesRef(String uid, String date) => _db
      .collection('users')
      .doc(uid)
      .collection('checkIns')
      .doc(date)
      .collection('entries');

  Stream<List<CheckInEntry>> watchTodayCheckIns(String uid) {
    final today = _todayDate();
    return _entriesRef(uid, today)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CheckInEntry.fromFirestore(doc)).toList());
  }

  Future<void> logCheckIn({
    required String uid,
    required String habitId,
    required String habitName,
    required int minutes,
  }) async {
    final today = _todayDate();
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
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));

      int newStreak = habit.currentStreak;
      if (habit.lastCheckInDate == today) {
        // Already checked in today, just add minutes
        newStreak = habit.currentStreak;
      } else if (habit.lastCheckInDate == yesterday) {
        // Consecutive day
        newStreak = habit.currentStreak + 1;
      } else {
        // Streak broken, start at 1
        newStreak = 1;
      }

      final newBest =
          newStreak > habit.bestStreak ? newStreak : habit.bestStreak;

      batch.update(habitRef, {
        'totalMinutes': FieldValue.increment(minutes),
        'currentStreak': newStreak,
        'bestStreak': newBest,
        'lastCheckInDate': today,
      });
    }

    await batch.commit();
  }

  // ─── Stats ───

  Future<List<String>> getCheckInDates({
    required String uid,
    required int lastNDays,
  }) async {
    final dates = <String>[];
    for (int i = 0; i < lastNDays; i++) {
      final date = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: i)));
      final snapshot = await _entriesRef(uid, date).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        dates.add(date);
      }
    }
    return dates;
  }

  /// Get daily focus minutes for a specific habit over the last N days.
  /// Returns a map of date strings (yyyy-MM-dd) to minutes.
  Future<Map<String, int>> getDailyMinutesForHabit({
    required String uid,
    required String habitId,
    required int lastNDays,
  }) async {
    final result = <String, int>{};
    for (int i = 0; i < lastNDays; i++) {
      final date = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: i)));
      final snapshot = await _entriesRef(uid, date)
          .where('habitId', isEqualTo: habitId)
          .get();
      int dayTotal = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        dayTotal += (data['minutes'] as int? ?? 0);
      }
      if (dayTotal > 0) {
        result[date] = dayTotal;
      }
    }
    return result;
  }
}
