import 'package:cloud_firestore/cloud_firestore.dart';

/// CheckInEntry data model — maps to Firestore `users/{uid}/checkIns/{date}/entries/{entryId}`.
/// See docs/architecture/data-model.md for the SSOT schema.
class CheckInEntry {
  final String id;
  final String habitId;
  final String habitName;
  final int minutes;
  final DateTime completedAt;

  const CheckInEntry({
    required this.id,
    required this.habitId,
    required this.habitName,
    required this.minutes,
    required this.completedAt,
  });

  factory CheckInEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CheckInEntry(
      id: doc.id,
      habitId: data['habitId'] as String? ?? '',
      habitName: data['habitName'] as String? ?? '',
      minutes: data['minutes'] as int? ?? 0,
      completedAt:
          (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'habitName': habitName,
      'minutes': minutes,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
