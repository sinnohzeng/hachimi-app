import 'package:cloud_firestore/cloud_firestore.dart';

/// Focus session model — maps to Firestore `users/{uid}/habits/{habitId}/sessions/{sessionId}`.
/// Records each focus session with duration, XP earned, and completion status.
class FocusSession {
  final String id;
  final String habitId;
  final String catId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationMinutes;
  final int xpEarned;
  final String mode; // 'countdown' or 'stopwatch'
  final bool completed; // true if finished naturally, false if abandoned

  const FocusSession({
    required this.id,
    required this.habitId,
    required this.catId,
    required this.startedAt,
    this.endedAt,
    required this.durationMinutes,
    required this.xpEarned,
    required this.mode,
    required this.completed,
  });

  factory FocusSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FocusSession(
      id: doc.id,
      habitId: data['habitId'] as String? ?? '',
      catId: data['catId'] as String? ?? '',
      startedAt:
          (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
      durationMinutes: data['durationMinutes'] as int? ?? 0,
      xpEarned: data['xpEarned'] as int? ?? 0,
      mode: data['mode'] as String? ?? 'countdown',
      completed: data['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'catId': catId,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
      'durationMinutes': durationMinutes,
      'xpEarned': xpEarned,
      'mode': mode,
      'completed': completed,
    };
  }
}
