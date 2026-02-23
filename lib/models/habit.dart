import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/reminder_config.dart';

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
  final List<ReminderConfig> reminders; // 提醒列表（上限 5 个）
  final String? motivationText; // 激励语，max 240 chars
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
    this.reminders = const [],
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

  /// 是否有提醒
  bool get hasReminders => reminders.isNotEmpty;

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

    // 防御性解析 reminders 数组（跳过畸形数据）
    final rawReminders = data['reminders'] as List<dynamic>?;
    final reminders =
        rawReminders
            ?.whereType<Map<String, dynamic>>()
            .map(ReminderConfig.tryFromMap)
            .whereType<ReminderConfig>()
            .toList() ??
        [];

    return Habit(
      id: doc.id,
      name: data['name'] as String? ?? '',
      targetHours: data['targetHours'] as int?,
      goalMinutes: data['goalMinutes'] as int? ?? 25,
      reminders: reminders,
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
      'reminders': reminders.map((r) => r.toMap()).toList(),
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

  /// SQLite 序列化 — 对应 local_habits 表。
  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'target_hours': targetHours,
      'goal_minutes': goalMinutes,
      'reminders': jsonEncode(reminders.map((r) => r.toMap()).toList()),
      'motivation_text': motivationText,
      'cat_id': catId,
      'is_active': isActive ? 1 : 0,
      'total_minutes': totalMinutes,
      'last_check_in_date': lastCheckInDate,
      'total_check_in_days': totalCheckInDays,
      'deadline_date': deadlineDate?.millisecondsSinceEpoch,
      'target_completed': targetCompleted ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// 从 SQLite 行反序列化。
  factory Habit.fromSqlite(Map<String, dynamic> map) {
    final rawReminders = map['reminders'] as String? ?? '[]';
    final remindersList = (jsonDecode(rawReminders) as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(ReminderConfig.tryFromMap)
        .whereType<ReminderConfig>()
        .toList();

    return Habit(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      targetHours: map['target_hours'] as int?,
      goalMinutes: map['goal_minutes'] as int? ?? 25,
      reminders: remindersList,
      motivationText: map['motivation_text'] as String?,
      catId: map['cat_id'] as String?,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      totalMinutes: map['total_minutes'] as int? ?? 0,
      lastCheckInDate: map['last_check_in_date'] as String?,
      totalCheckInDays: map['total_check_in_days'] as int? ?? 0,
      deadlineDate: map['deadline_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline_date'] as int)
          : null,
      targetCompleted: (map['target_completed'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    int? targetHours,
    bool clearTargetHours = false,
    int? goalMinutes,
    List<ReminderConfig>? reminders,
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
      reminders: reminders ?? this.reminders,
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
