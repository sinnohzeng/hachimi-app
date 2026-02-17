import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/models/check_in.dart';
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
  }) async {
    final docRef = await _habitsRef(uid).add({
      'name': name,
      'icon': icon,
      'targetHours': targetHours,
      'totalMinutes': 0,
      'currentStreak': 0,
      'bestStreak': 0,
      'lastCheckInDate': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> deleteHabit({
    required String uid,
    required String habitId,
  }) async {
    await _habitsRef(uid).doc(habitId).delete();
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
}
