import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 年度计划 — 用户年度愿景、关键词、成长维度等。
///
/// 对应 SQLite 表 `local_yearly_plans`，
/// Firestore 路径 `users/{uid}/yearlyPlans/{year}`。
class YearlyPlan {
  final String id;
  final int year;
  final String? becomePerson; // 想成为什么样的人
  final String? achieveGoals; // 想达成的目标
  final String? breakthrough; // 想突破的事
  final String? dontDo; // 不再做的事
  final String? yearKeyword; // 年度关键词
  final String? futureMessage; // 给未来自己的话
  final String? motto; // 年度座右铭
  final Map<String, String>? growthDimensions; // 成长维度 → 描述
  final DateTime createdAt;
  final DateTime updatedAt;

  const YearlyPlan({
    required this.id,
    required this.year,
    this.becomePerson,
    this.achieveGoals,
    this.breakthrough,
    this.dontDo,
    this.yearKeyword,
    this.futureMessage,
    this.motto,
    this.growthDimensions,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'year': year,
      'become_person': becomePerson,
      'achieve_goals': achieveGoals,
      'breakthrough': breakthrough,
      'dont_do': dontDo,
      'year_keyword': yearKeyword,
      'future_message': futureMessage,
      'motto': motto,
      'growth_dimensions': growthDimensions != null
          ? jsonEncode(growthDimensions)
          : null,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory YearlyPlan.fromSqlite(Map<String, dynamic> map) {
    return YearlyPlan(
      id: map['id'] as String,
      year: map['year'] as int,
      becomePerson: map['become_person'] as String?,
      achieveGoals: map['achieve_goals'] as String?,
      breakthrough: map['breakthrough'] as String?,
      dontDo: map['dont_do'] as String?,
      yearKeyword: map['year_keyword'] as String?,
      futureMessage: map['future_message'] as String?,
      motto: map['motto'] as String?,
      growthDimensions: _decodeStringMapFromSqlite(map['growth_dimensions']),
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
      'year': year,
      'becomePerson': becomePerson,
      'achieveGoals': achieveGoals,
      'breakthrough': breakthrough,
      'dontDo': dontDo,
      'yearKeyword': yearKeyword,
      'futureMessage': futureMessage,
      'motto': motto,
      'growthDimensions': growthDimensions,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory YearlyPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return YearlyPlan(
      id: doc.id,
      year: data['year'] as int? ?? 0,
      becomePerson: data['becomePerson'] as String?,
      achieveGoals: data['achieveGoals'] as String?,
      breakthrough: data['breakthrough'] as String?,
      dontDo: data['dontDo'] as String?,
      yearKeyword: data['yearKeyword'] as String?,
      futureMessage: data['futureMessage'] as String?,
      motto: data['motto'] as String?,
      growthDimensions: (data['growthDimensions'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as String? ?? '')),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  YearlyPlan copyWith({
    String? id,
    int? year,
    String? becomePerson,
    bool clearBecomePerson = false,
    String? achieveGoals,
    bool clearAchieveGoals = false,
    String? breakthrough,
    bool clearBreakthrough = false,
    String? dontDo,
    bool clearDontDo = false,
    String? yearKeyword,
    bool clearYearKeyword = false,
    String? futureMessage,
    bool clearFutureMessage = false,
    String? motto,
    bool clearMotto = false,
    Map<String, String>? growthDimensions,
    bool clearGrowthDimensions = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return YearlyPlan(
      id: id ?? this.id,
      year: year ?? this.year,
      becomePerson: clearBecomePerson
          ? null
          : (becomePerson ?? this.becomePerson),
      achieveGoals: clearAchieveGoals
          ? null
          : (achieveGoals ?? this.achieveGoals),
      breakthrough: clearBreakthrough
          ? null
          : (breakthrough ?? this.breakthrough),
      dontDo: clearDontDo ? null : (dontDo ?? this.dontDo),
      yearKeyword: clearYearKeyword ? null : (yearKeyword ?? this.yearKeyword),
      futureMessage: clearFutureMessage
          ? null
          : (futureMessage ?? this.futureMessage),
      motto: clearMotto ? null : (motto ?? this.motto),
      growthDimensions: clearGrowthDimensions
          ? null
          : (growthDimensions ?? this.growthDimensions),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static Map<String, String>? _decodeStringMapFromSqlite(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded.map((k, v) => MapEntry(k, v as String? ?? ''));
        }
      } on FormatException {
        // 损坏数据静默降级
      }
    }
    return null;
  }
}
