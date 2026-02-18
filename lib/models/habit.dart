import 'package:cloud_firestore/cloud_firestore.dart';

/// Habit data model — maps to Firestore `users/{uid}/habits/{habitId}`.
/// See docs/architecture/data-model.md for the SSOT schema.
class Habit {
  final String id;
  final String name;
  final String icon; // emoji string (e.g. '📚') or Material icon key for legacy
  final int targetHours; // long-term cumulative target
  final int goalMinutes; // daily focus goal (default: 25)
  final String? reminderTime; // 'HH:mm' or null
  final String? catId; // reference to bound cat
  final bool isActive;
  final int totalMinutes;
  final int currentStreak;
  final int bestStreak;
  final String? lastCheckInDate;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.targetHours,
    this.goalMinutes = 25,
    this.reminderTime,
    this.catId,
    this.isActive = true,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCheckInDate,
    required this.createdAt,
  });

  double get progressPercent {
    if (targetHours <= 0) return 0;
    final targetMinutes = targetHours * 60;
    return (totalMinutes / targetMinutes).clamp(0.0, 1.0);
  }

  int get totalHours => totalMinutes ~/ 60;
  int get remainingMinutes => totalMinutes % 60;

  String get progressText {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return '${hours}h ${mins}m / ${targetHours}h';
  }

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] as String? ?? '',
      icon: data['icon'] as String? ?? '📝',
      targetHours: data['targetHours'] as int? ?? 0,
      goalMinutes: data['goalMinutes'] as int? ?? 25,
      reminderTime: data['reminderTime'] as String?,
      catId: data['catId'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      totalMinutes: data['totalMinutes'] as int? ?? 0,
      currentStreak: data['currentStreak'] as int? ?? 0,
      bestStreak: data['bestStreak'] as int? ?? 0,
      lastCheckInDate: data['lastCheckInDate'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminderTime': reminderTime,
      'catId': catId,
      'isActive': isActive,
      'totalMinutes': totalMinutes,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastCheckInDate': lastCheckInDate,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    String? icon,
    int? targetHours,
    int? goalMinutes,
    String? reminderTime,
    String? catId,
    bool? isActive,
    int? totalMinutes,
    int? currentStreak,
    int? bestStreak,
    String? lastCheckInDate,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      targetHours: targetHours ?? this.targetHours,
      goalMinutes: goalMinutes ?? this.goalMinutes,
      reminderTime: reminderTime ?? this.reminderTime,
      catId: catId ?? this.catId,
      isActive: isActive ?? this.isActive,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
