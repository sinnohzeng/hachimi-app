import 'package:cloud_firestore/cloud_firestore.dart';

/// 高光时刻类型枚举。
enum HighlightType {
  happy('happy'),
  highlight('highlight');

  const HighlightType(this.value);
  final String value;

  static HighlightType fromValue(String value) {
    return HighlightType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HighlightType.happy,
    );
  }
}

/// 高光时刻 — 年度快乐/高光事件记录。
///
/// 对应 SQLite 表 `local_highlight_entries`，
/// Firestore 路径 `users/{uid}/highlightEntries/{id}`。
class HighlightEntry {
  final String id;
  final int year;
  final HighlightType type;
  final String description;
  final String? companion; // 和谁在一起
  final String? feeling; // 当时的感受
  final String date; // 'YYYY-MM-DD'
  final int rating; // 1-5 星
  final DateTime createdAt;
  final DateTime updatedAt;

  const HighlightEntry({
    required this.id,
    required this.year,
    required this.type,
    required this.description,
    this.companion,
    this.feeling,
    required this.date,
    this.rating = 3,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'year': year,
      'type': type.value,
      'description': description,
      'companion': companion,
      'feeling': feeling,
      'date': date,
      'rating': rating,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory HighlightEntry.fromSqlite(Map<String, dynamic> map) {
    return HighlightEntry(
      id: map['id'] as String,
      year: map['year'] as int,
      type: HighlightType.fromValue(map['type'] as String? ?? 'happy'),
      description: map['description'] as String? ?? '',
      companion: map['companion'] as String?,
      feeling: map['feeling'] as String?,
      date: map['date'] as String? ?? '',
      rating: map['rating'] as int? ?? 3,
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
      'type': type.value,
      'description': description,
      'companion': companion,
      'feeling': feeling,
      'date': date,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory HighlightEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HighlightEntry(
      id: doc.id,
      year: data['year'] as int? ?? 0,
      type: HighlightType.fromValue(data['type'] as String? ?? 'happy'),
      description: data['description'] as String? ?? '',
      companion: data['companion'] as String?,
      feeling: data['feeling'] as String?,
      date: data['date'] as String? ?? '',
      rating: data['rating'] as int? ?? 3,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  HighlightEntry copyWith({
    String? id,
    int? year,
    HighlightType? type,
    String? description,
    String? companion,
    bool clearCompanion = false,
    String? feeling,
    bool clearFeeling = false,
    String? date,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HighlightEntry(
      id: id ?? this.id,
      year: year ?? this.year,
      type: type ?? this.type,
      description: description ?? this.description,
      companion: clearCompanion ? null : (companion ?? this.companion),
      feeling: clearFeeling ? null : (feeling ?? this.feeling),
      date: date ?? this.date,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
