import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 清单类型枚举。
enum ListType {
  book('book'),
  movie('movie'),
  custom('custom');

  const ListType(this.value);
  final String value;

  static ListType fromValue(String value) {
    return ListType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ListType.custom,
    );
  }
}

/// 清单条目 — 书籍/电影/自定义清单中的单项。
class ListItem {
  final String title;
  final String? date; // 完成日期
  final String? genre; // 类型/标签
  final int rating; // 1-5 星
  final String? keywords; // 关键词/短评

  const ListItem({
    required this.title,
    this.date,
    this.genre,
    this.rating = 3,
    this.keywords,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'genre': genre,
      'rating': rating,
      'keywords': keywords,
    };
  }

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      title: json['title'] as String? ?? '',
      date: json['date'] as String?,
      genre: json['genre'] as String?,
      rating: json['rating'] as int? ?? 3,
      keywords: json['keywords'] as String?,
    );
  }

  ListItem copyWith({
    String? title,
    String? date,
    bool clearDate = false,
    String? genre,
    bool clearGenre = false,
    int? rating,
    String? keywords,
    bool clearKeywords = false,
  }) {
    return ListItem(
      title: title ?? this.title,
      date: clearDate ? null : (date ?? this.date),
      genre: clearGenre ? null : (genre ?? this.genre),
      rating: rating ?? this.rating,
      keywords: clearKeywords ? null : (keywords ?? this.keywords),
    );
  }
}

/// 用户清单 — 年度阅读/观影/自定义清单。
///
/// 对应 SQLite 表 `local_user_lists`，
/// Firestore 路径 `users/{uid}/userLists/{id}`。
class UserList {
  final String id;
  final int year;
  final ListType type;
  final String? customTitle; // type=custom 时的自定义标题
  final List<ListItem> items;
  final String? yearPick; // 年度之选
  final String? yearInsight; // 年度感悟
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserList({
    required this.id,
    required this.year,
    required this.type,
    this.customTitle,
    this.items = const [],
    this.yearPick,
    this.yearInsight,
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
      'custom_title': customTitle,
      'items': jsonEncode(items.map((i) => i.toJson()).toList()),
      'year_pick': yearPick,
      'year_insight': yearInsight,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserList.fromSqlite(Map<String, dynamic> map) {
    return UserList(
      id: map['id'] as String,
      year: map['year'] as int,
      type: ListType.fromValue(map['type'] as String? ?? 'custom'),
      customTitle: map['custom_title'] as String?,
      items: _decodeItemsFromSqlite(map['items']),
      yearPick: map['year_pick'] as String?,
      yearInsight: map['year_insight'] as String?,
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
      'customTitle': customTitle,
      'items': items.map((i) => i.toJson()).toList(),
      'yearPick': yearPick,
      'yearInsight': yearInsight,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserList(
      id: doc.id,
      year: data['year'] as int? ?? 0,
      type: ListType.fromValue(data['type'] as String? ?? 'custom'),
      customTitle: data['customTitle'] as String?,
      items: _decodeItemsFromFirestore(data['items']),
      yearPick: data['yearPick'] as String?,
      yearInsight: data['yearInsight'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  UserList copyWith({
    String? id,
    int? year,
    ListType? type,
    String? customTitle,
    bool clearCustomTitle = false,
    List<ListItem>? items,
    String? yearPick,
    bool clearYearPick = false,
    String? yearInsight,
    bool clearYearInsight = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserList(
      id: id ?? this.id,
      year: year ?? this.year,
      type: type ?? this.type,
      customTitle: clearCustomTitle ? null : (customTitle ?? this.customTitle),
      items: items ?? this.items,
      yearPick: clearYearPick ? null : (yearPick ?? this.yearPick),
      yearInsight: clearYearInsight ? null : (yearInsight ?? this.yearInsight),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─── 私有辅助 ───

  static List<ListItem> _decodeItemsFromSqlite(dynamic raw) {
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(ListItem.fromJson)
              .toList();
        }
      } on FormatException {
        // 损坏数据静默降级
      }
    }
    return [];
  }

  static List<ListItem> _decodeItemsFromFirestore(dynamic raw) {
    if (raw is List<dynamic>) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(ListItem.fromJson)
          .toList();
    }
    return [];
  }
}
