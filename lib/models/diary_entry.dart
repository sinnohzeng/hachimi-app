// ---
// 📘 文件说明：
// DiaryEntry 数据模型 — 猫猫日记条目，存储于本地 SQLite。
//
// 🕒 创建时间：2026-02-19
// ---

/// 猫猫日记条目 — 每猫每天最多一条。
class DiaryEntry {
  final String id;
  final String catId;
  final String habitId;
  final String content;
  final String date; // YYYY-MM-DD
  final String personality;
  final String mood;
  final String stage;
  final int totalMinutes;
  final DateTime createdAt;

  const DiaryEntry({
    required this.id,
    required this.catId,
    required this.habitId,
    required this.content,
    required this.date,
    required this.personality,
    required this.mood,
    required this.stage,
    required this.totalMinutes,
    required this.createdAt,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'] as String,
      catId: map['cat_id'] as String,
      habitId: map['habit_id'] as String,
      content: map['content'] as String,
      date: map['date'] as String,
      personality: map['personality'] as String,
      mood: map['mood'] as String,
      stage: map['stage'] as String,
      totalMinutes: map['total_minutes'] as int,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cat_id': catId,
      'habit_id': habitId,
      'content': content,
      'date': date,
      'personality': personality,
      'mood': mood,
      'stage': stage,
      'total_minutes': totalMinutes,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
