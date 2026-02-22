import 'package:cloud_firestore/cloud_firestore.dart';

/// Habit data model — maps to Firestore `users/{uid}/habits/{habitId}`.
/// See docs/architecture/data-model.md for the SSOT schema.
///
/// 目标模式：
/// - 永续模式：targetHours == null，无上限，持续累积
/// - 里程碑模式：targetHours != null，达成后 targetCompleted = true 自动转永续
class Habit {
  final String id;
  final String name;
  final int? targetHours; // 累计目标小时数（可选，null = 永续模式）
  final int goalMinutes; // 每日专注目标（默认 25 分钟）
  final String? reminderTime; // 'HH:mm' or null
  final String? motivationText; // 激励语，max 40 chars
  final String? catId; // 绑定的猫咪 ID
  final bool isActive;
  final int totalMinutes; // 累计专注分钟数
  final String? lastCheckInDate; // 最近打卡日期 'yyyy-MM-dd'
  final int totalCheckInDays; // 累计打卡天数
  final DateTime? deadlineDate; // 截止日期（可选，仅里程碑模式有意义）
  final bool targetCompleted; // 目标是否已达成
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.name,
    this.targetHours,
    this.goalMinutes = 25,
    this.reminderTime,
    this.motivationText,
    this.catId,
    this.isActive = true,
    this.totalMinutes = 0,
    this.lastCheckInDate,
    this.totalCheckInDays = 0,
    this.deadlineDate,
    this.targetCompleted = false,
    required this.createdAt,
  });

  /// 是否为永续模式（无目标或目标已达成）
  bool get isUnlimited => targetHours == null || targetCompleted;

  /// 目标进度百分比（仅里程碑模式有意义）
  double get progressPercent {
    if (targetHours == null || targetHours! <= 0) return 0;
    final targetMinutes = targetHours! * 60;
    return (totalMinutes / targetMinutes).clamp(0.0, 1.0);
  }

  int get totalHours => totalMinutes ~/ 60;
  int get remainingMinutes => totalMinutes % 60;

  /// 进度文案
  String get progressText {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (targetHours != null) {
      return '${hours}h ${mins}m / ${targetHours}h';
    }
    return '${hours}h ${mins}m';
  }

  /// 截止日期前建议的每日专注分钟数
  int? get suggestedDailyMinutes {
    if (targetHours == null || deadlineDate == null || targetCompleted) {
      return null;
    }
    final remainingHours = targetHours! - (totalMinutes / 60);
    if (remainingHours <= 0) return null;
    final remainingDays = deadlineDate!
        .difference(DateTime.now())
        .inDays
        .clamp(1, 99999);
    return (remainingHours * 60 / remainingDays).ceil();
  }

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] as String? ?? '',
      targetHours: data['targetHours'] as int?,
      goalMinutes: data['goalMinutes'] as int? ?? 25,
      reminderTime: data['reminderTime'] as String?,
      motivationText: data['motivationText'] as String?,
      catId: data['catId'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      totalMinutes: data['totalMinutes'] as int? ?? 0,
      lastCheckInDate: data['lastCheckInDate'] as String?,
      totalCheckInDays: data['totalCheckInDays'] as int? ?? 0,
      deadlineDate: (data['deadlineDate'] as Timestamp?)?.toDate(),
      targetCompleted: data['targetCompleted'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'targetHours': targetHours,
      'goalMinutes': goalMinutes,
      'reminderTime': reminderTime,
      'motivationText': motivationText,
      'catId': catId,
      'isActive': isActive,
      'totalMinutes': totalMinutes,
      'lastCheckInDate': lastCheckInDate,
      'totalCheckInDays': totalCheckInDays,
      'deadlineDate': deadlineDate != null
          ? Timestamp.fromDate(deadlineDate!)
          : null,
      'targetCompleted': targetCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    int? targetHours,
    bool clearTargetHours = false,
    int? goalMinutes,
    String? reminderTime,
    String? motivationText,
    String? catId,
    bool? isActive,
    int? totalMinutes,
    String? lastCheckInDate,
    int? totalCheckInDays,
    DateTime? deadlineDate,
    bool clearDeadlineDate = false,
    bool? targetCompleted,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      targetHours: clearTargetHours ? null : (targetHours ?? this.targetHours),
      goalMinutes: goalMinutes ?? this.goalMinutes,
      reminderTime: reminderTime ?? this.reminderTime,
      motivationText: motivationText ?? this.motivationText,
      catId: catId ?? this.catId,
      isActive: isActive ?? this.isActive,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      totalCheckInDays: totalCheckInDays ?? this.totalCheckInDays,
      deadlineDate: clearDeadlineDate
          ? null
          : (deadlineDate ?? this.deadlineDate),
      targetCompleted: targetCompleted ?? this.targetCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
