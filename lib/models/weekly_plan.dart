import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/json_helpers.dart';

/// 周计划 — 用户每周的四象限任务规划。
///
/// 对应 SQLite 表 `local_weekly_plans`，
/// Firestore 路径 `users/{uid}/weeklyPlans/{weekId}`。
///
/// weekId 格式：`'YYYY-WNN'`（ISO 8601）。
class WeeklyPlan {
  final String id;
  final String weekId; // 'YYYY-WNN'
  final String weekStartDate; // 'YYYY-MM-DD'
  final String weekEndDate; // 'YYYY-MM-DD'
  final String? oneLineForSelf; // 给自己的一句话
  final List<String> urgentImportant; // 紧急且重要
  final List<String> importantNotUrgent; // 重要不紧急
  final List<String> urgentNotImportant; // 紧急不重要
  final List<String> wantToDo; // 想做的事
  final DateTime createdAt;
  final DateTime updatedAt;

  const WeeklyPlan({
    required this.id,
    required this.weekId,
    required this.weekStartDate,
    required this.weekEndDate,
    this.oneLineForSelf,
    this.urgentImportant = const [],
    this.importantNotUrgent = const [],
    this.urgentNotImportant = const [],
    this.wantToDo = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'week_id': weekId,
      'week_start_date': weekStartDate,
      'week_end_date': weekEndDate,
      'one_line_for_self': oneLineForSelf,
      'urgent_important': jsonEncode(urgentImportant),
      'important_not_urgent': jsonEncode(importantNotUrgent),
      'urgent_not_important': jsonEncode(urgentNotImportant),
      'want_to_do': jsonEncode(wantToDo),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory WeeklyPlan.fromSqlite(Map<String, dynamic> map) {
    return WeeklyPlan(
      id: map['id'] as String,
      weekId: map['week_id'] as String,
      weekStartDate: map['week_start_date'] as String,
      weekEndDate: map['week_end_date'] as String,
      oneLineForSelf: map['one_line_for_self'] as String?,
      urgentImportant: decodeJsonStringList(map['urgent_important']),
      importantNotUrgent: decodeJsonStringList(map['important_not_urgent']),
      urgentNotImportant: decodeJsonStringList(map['urgent_not_important']),
      wantToDo: decodeJsonStringList(map['want_to_do']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updated_at'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'weekStartDate': weekStartDate,
      'weekEndDate': weekEndDate,
      'oneLineForSelf': oneLineForSelf,
      'urgentImportant': urgentImportant,
      'importantNotUrgent': importantNotUrgent,
      'urgentNotImportant': urgentNotImportant,
      'wantToDo': wantToDo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory WeeklyPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WeeklyPlan(
      id: doc.id,
      weekId: doc.id,
      weekStartDate: data['weekStartDate'] as String? ?? '',
      weekEndDate: data['weekEndDate'] as String? ?? '',
      oneLineForSelf: data['oneLineForSelf'] as String?,
      urgentImportant: _decodeFirestoreList(data['urgentImportant']),
      importantNotUrgent: _decodeFirestoreList(data['importantNotUrgent']),
      urgentNotImportant: _decodeFirestoreList(data['urgentNotImportant']),
      wantToDo: _decodeFirestoreList(data['wantToDo']),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  WeeklyPlan copyWith({
    String? id,
    String? weekId,
    String? weekStartDate,
    String? weekEndDate,
    String? oneLineForSelf,
    bool clearOneLineForSelf = false,
    List<String>? urgentImportant,
    List<String>? importantNotUrgent,
    List<String>? urgentNotImportant,
    List<String>? wantToDo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeeklyPlan(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      oneLineForSelf: clearOneLineForSelf
          ? null
          : (oneLineForSelf ?? this.oneLineForSelf),
      urgentImportant: urgentImportant ?? this.urgentImportant,
      importantNotUrgent: importantNotUrgent ?? this.importantNotUrgent,
      urgentNotImportant: urgentNotImportant ?? this.urgentNotImportant,
      wantToDo: wantToDo ?? this.wantToDo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static List<String> _decodeFirestoreList(dynamic raw) {
    if (raw is List<dynamic>) return raw.whereType<String>().toList();
    return [];
  }
}
