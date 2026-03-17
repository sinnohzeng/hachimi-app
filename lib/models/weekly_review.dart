import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 周回顾记录 — 每周复盘的三个快乐时刻 + 感恩 + 学习。
///
/// 对应 SQLite 表 `local_weekly_reviews`，
/// Firestore 路径 `users/{uid}/weeklyReviews/{weekId}`。
///
/// 周定义：ISO 8601（周一开始，周日结束）。
/// weekId 格式：`'YYYY-WNN'`（如 `'2026-W12'`）。
class WeeklyReview {
  final String id;
  final String weekId; // 'YYYY-WNN' ISO 格式
  final String weekStartDate; // 周一 'YYYY-MM-DD'
  final String weekEndDate; // 周日 'YYYY-MM-DD'

  // 三个快乐时刻（独立字段，非 List，SQLite 存储更简单）
  final String? happyMoment1;
  final List<String> happyMoment1Tags;
  final String? happyMoment2;
  final List<String> happyMoment2Tags;
  final String? happyMoment3;
  final List<String> happyMoment3Tags;

  final String? gratitude;
  final String? learning;
  final String? catWeeklySummary; // 模板库生成，非 AI

  final DateTime createdAt;
  final DateTime updatedAt;

  const WeeklyReview({
    required this.id,
    required this.weekId,
    required this.weekStartDate,
    required this.weekEndDate,
    this.happyMoment1,
    this.happyMoment1Tags = const [],
    this.happyMoment2,
    this.happyMoment2Tags = const [],
    this.happyMoment3,
    this.happyMoment3Tags = const [],
    this.gratitude,
    this.learning,
    this.catWeeklySummary,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  /// 已填写的快乐时刻数量（0-3）。
  int get filledMomentCount {
    int count = 0;
    if (happyMoment1 != null && happyMoment1!.isNotEmpty) count++;
    if (happyMoment2 != null && happyMoment2!.isNotEmpty) count++;
    if (happyMoment3 != null && happyMoment3!.isNotEmpty) count++;
    return count;
  }

  /// 周回顾是否完成（至少 1 个快乐时刻 + 感恩或学习之一）。
  bool get isComplete {
    final hasMoment = filledMomentCount >= 1;
    final hasReflection =
        (gratitude != null && gratitude!.isNotEmpty) ||
        (learning != null && learning!.isNotEmpty);
    return hasMoment && hasReflection;
  }

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'week_id': weekId,
      'week_start_date': weekStartDate,
      'week_end_date': weekEndDate,
      'happy_moment_1': happyMoment1,
      'happy_moment_1_tags': jsonEncode(happyMoment1Tags),
      'happy_moment_2': happyMoment2,
      'happy_moment_2_tags': jsonEncode(happyMoment2Tags),
      'happy_moment_3': happyMoment3,
      'happy_moment_3_tags': jsonEncode(happyMoment3Tags),
      'gratitude': gratitude,
      'learning': learning,
      'cat_weekly_summary': catWeeklySummary,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory WeeklyReview.fromSqlite(Map<String, dynamic> map) {
    return WeeklyReview(
      id: map['id'] as String,
      weekId: map['week_id'] as String,
      weekStartDate: map['week_start_date'] as String,
      weekEndDate: map['week_end_date'] as String,
      happyMoment1: map['happy_moment_1'] as String?,
      happyMoment1Tags: _decodeStringList(map['happy_moment_1_tags']),
      happyMoment2: map['happy_moment_2'] as String?,
      happyMoment2Tags: _decodeStringList(map['happy_moment_2_tags']),
      happyMoment3: map['happy_moment_3'] as String?,
      happyMoment3Tags: _decodeStringList(map['happy_moment_3_tags']),
      gratitude: map['gratitude'] as String?,
      learning: map['learning'] as String?,
      catWeeklySummary: map['cat_weekly_summary'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'weekStartDate': weekStartDate,
      'weekEndDate': weekEndDate,
      'happyMoment1': happyMoment1,
      'happyMoment1Tags': happyMoment1Tags,
      'happyMoment2': happyMoment2,
      'happyMoment2Tags': happyMoment2Tags,
      'happyMoment3': happyMoment3,
      'happyMoment3Tags': happyMoment3Tags,
      'gratitude': gratitude,
      'learning': learning,
      'catWeeklySummary': catWeeklySummary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory WeeklyReview.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return WeeklyReview(
      id: doc.id,
      weekId: doc.id, // Firestore 文档 ID 即为 weekId
      weekStartDate: data['weekStartDate'] as String? ?? '',
      weekEndDate: data['weekEndDate'] as String? ?? '',
      happyMoment1: data['happyMoment1'] as String?,
      happyMoment1Tags: _decodeFirestoreList(data['happyMoment1Tags']),
      happyMoment2: data['happyMoment2'] as String?,
      happyMoment2Tags: _decodeFirestoreList(data['happyMoment2Tags']),
      happyMoment3: data['happyMoment3'] as String?,
      happyMoment3Tags: _decodeFirestoreList(data['happyMoment3Tags']),
      gratitude: data['gratitude'] as String?,
      learning: data['learning'] as String?,
      catWeeklySummary: data['catWeeklySummary'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  WeeklyReview copyWith({
    String? id,
    String? weekId,
    String? weekStartDate,
    String? weekEndDate,
    String? happyMoment1,
    bool clearHappyMoment1 = false,
    List<String>? happyMoment1Tags,
    String? happyMoment2,
    bool clearHappyMoment2 = false,
    List<String>? happyMoment2Tags,
    String? happyMoment3,
    bool clearHappyMoment3 = false,
    List<String>? happyMoment3Tags,
    String? gratitude,
    bool clearGratitude = false,
    String? learning,
    bool clearLearning = false,
    String? catWeeklySummary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeeklyReview(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      happyMoment1: clearHappyMoment1
          ? null
          : (happyMoment1 ?? this.happyMoment1),
      happyMoment1Tags: happyMoment1Tags ?? this.happyMoment1Tags,
      happyMoment2: clearHappyMoment2
          ? null
          : (happyMoment2 ?? this.happyMoment2),
      happyMoment2Tags: happyMoment2Tags ?? this.happyMoment2Tags,
      happyMoment3: clearHappyMoment3
          ? null
          : (happyMoment3 ?? this.happyMoment3),
      happyMoment3Tags: happyMoment3Tags ?? this.happyMoment3Tags,
      gratitude: clearGratitude ? null : (gratitude ?? this.gratitude),
      learning: clearLearning ? null : (learning ?? this.learning),
      catWeeklySummary: catWeeklySummary ?? this.catWeeklySummary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static List<String> _decodeStringList(dynamic raw) {
    if (raw is String) {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.whereType<String>().toList();
    }
    return [];
  }

  static List<String> _decodeFirestoreList(dynamic raw) {
    if (raw is List<dynamic>) return raw.whereType<String>().toList();
    return [];
  }
}
