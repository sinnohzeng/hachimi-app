import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/mood.dart';

/// 每日一光记录 — 用户每天睡前记下的一段微小光亮。
///
/// 对应 SQLite 表 `local_daily_lights`，
/// Firestore 路径 `users/{uid}/dailyLights/{date}`。
class DailyLight {
  final String id;
  final String date; // 'YYYY-MM-DD'
  final Mood mood;
  final String? lightText;
  final List<String> tags;
  final List<String>? timelineEvents; // Track 4 使用，MVP 暂不填充
  final Map<String, bool>? habitCompletions; // Track 4 使用，MVP 暂不填充
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyLight({
    required this.id,
    required this.date,
    required this.mood,
    this.lightText,
    this.tags = const [],
    this.timelineEvents,
    this.habitCompletions,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasText => lightText != null && lightText!.isNotEmpty;

  bool get hasTags => tags.isNotEmpty;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'date': date,
      'mood': mood.value,
      'light_text': lightText,
      'tags': jsonEncode(tags),
      'timeline_events': timelineEvents != null
          ? jsonEncode(timelineEvents)
          : null,
      'habit_completions': habitCompletions != null
          ? jsonEncode(habitCompletions)
          : null,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DailyLight.fromSqlite(Map<String, dynamic> map) {
    return DailyLight(
      id: map['id'] as String,
      date: map['date'] as String,
      mood: Mood.fromValue(map['mood'] as int),
      lightText: map['light_text'] as String?,
      tags: _decodeStringList(map['tags']),
      timelineEvents: map['timeline_events'] != null
          ? _decodeStringList(map['timeline_events'])
          : null,
      habitCompletions: map['habit_completions'] != null
          ? _decodeBoolMap(map['habit_completions'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'mood': mood.value,
      'lightText': lightText,
      'tags': tags,
      'timelineEvents': timelineEvents,
      'habitCompletions': habitCompletions,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory DailyLight.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return DailyLight(
      id: doc.id,
      date: doc.id, // Firestore 文档 ID 即为 date
      mood: Mood.fromValue(data['mood'] as int? ?? Mood.calm.value),
      lightText: data['lightText'] as String?,
      tags:
          (data['tags'] as List<dynamic>?)?.whereType<String>().toList() ?? [],
      timelineEvents: (data['timelineEvents'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
      habitCompletions: (data['habitCompletions'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as bool? ?? false)),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  DailyLight copyWith({
    String? id,
    String? date,
    Mood? mood,
    String? lightText,
    bool clearLightText = false,
    List<String>? tags,
    List<String>? timelineEvents,
    Map<String, bool>? habitCompletions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyLight(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      lightText: clearLightText ? null : (lightText ?? this.lightText),
      tags: tags ?? this.tags,
      timelineEvents: timelineEvents ?? this.timelineEvents,
      habitCompletions: habitCompletions ?? this.habitCompletions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static List<String> _decodeStringList(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.whereType<String>().toList();
      } on FormatException {
        // 损坏数据静默降级为空列表
      }
    }
    return [];
  }

  static Map<String, bool> _decodeBoolMap(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded.map((k, v) => MapEntry(k, v as bool? ?? false));
        }
      } on FormatException {
        // 损坏数据静默降级为空 Map
      }
    }
    return {};
  }
}
