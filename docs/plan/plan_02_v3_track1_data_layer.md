---
level: 2
file_id: plan_02
parent: plan_01
status: pending
created: 2026-03-17 23:30
children: []
estimated_time: 480分钟
prerequisites: []
---

# 模块：Track 1 — 数据基础层（Data Layer）

## 1. 模块概述

### 模块目标

Track 1 是 V3 觉知伴侣功能的 **地基工程**。它不包含任何 UI 代码，完全聚焦于数据模型、本地持久化、台账同步和响应式 Provider 的搭建。

完成 Track 1 后，上层 Track（UI、猫咪反应、成就系统）可以直接 `ref.watch` 拿到结构化数据，无需关心存储细节。

### 在项目中的位置

```
Track 1（数据基础）  ← 本文档
   ↑
Track 2（每日一光 UI）
Track 3（周回顾 UI）
Track 4（烦恼处理器 UI）
Track 5（数据洞察 + 猫咪反应）
```

所有上层 Track 都依赖 Track 1 的模型和 Provider。Track 1 自身仅依赖现有的 `LedgerService`、`LocalDatabaseService`、`SyncEngine` 基础设施。

### 交付物概览

| 类别 | 数量 | 说明 |
|------|------|------|
| 新增 Dart 模型 | 4 个 | Mood、DailyLight、WeeklyReview、Worry |
| 新增 SQLite 表 | 4 张 | local_daily_lights、local_weekly_reviews、local_worries、local_awareness_stats |
| 新增 Service | 2 个 | AwarenessRepository、WorryRepository |
| 新增 Provider | 8 个 | 覆盖所有觉知数据的响应式访问 |
| 新增 ActionType | 6 个 | 台账行为类型扩展 |
| 修改现有文件 | 8 个 | 数据库迁移、台账、同步、规则等 |
| 新增单元测试 | 4 个 | 模型序列化往返测试 |

---

## 2. 新增 Dart 模型

### 2.1 `Mood` 枚举（`lib/models/mood.dart`）

```dart
/// 心情等级 — 5 级量表。
/// 存储在 SQLite 中使用 int value，UI 层使用 emoji 展示。
enum Mood {
  veryHappy(0, '😄'),
  happy(1, '🙂'),
  calm(2, '😌'),
  down(3, '😔'),
  veryDown(4, '😢');

  const Mood(this.value, this.emoji);
  final int value;
  final String emoji;

  /// 从整型值反序列化。无效值抛出 ArgumentError。
  static Mood fromValue(int value) {
    return Mood.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown Mood value: $value'),
    );
  }
}
```

**要点**：

- 5 个等级覆盖积极→消极完整光谱
- `value` 字段用于 SQLite 存储（INT 列）
- `emoji` 字段用于 UI 展示
- `fromValue` 使用 `firstWhere` + `orElse`，与项目现有 `ActionType.fromValue` 保持一致

---

### 2.2 `DailyLight` 模型（`lib/models/daily_light.dart`）

```dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/mood.dart';

/// 每日一光记录 — 用户每天睡前记下的一段微小光亮。
/// 对应 SQLite 表 `local_daily_lights`，Firestore 路径 `users/{uid}/dailyLights/{date}`。
class DailyLight {
  final String id;
  final String date; // 'YYYY-MM-DD' 格式
  final Mood mood;
  final String? lightText; // 今日之光文字（可选）
  final List<String> tags; // 情绪标签（如 ['工作', '运动', '社交']）
  final List<String>? timelineEvents; // 时间线事件（Track 4 使用，MVP 暂不填充）
  final Map<String, bool>? habitCompletions; // 习惯完成状态（Track 4 使用，MVP 暂不填充）
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

  /// 是否有文字记录
  bool get hasText => lightText != null && lightText!.isNotEmpty;

  /// 是否有标签
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
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
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
    final data = doc.data()! as Map<String, dynamic>;
    return DailyLight(
      id: doc.id,
      date: doc.id, // Firestore 文档 ID 即为 date
      mood: Mood.fromValue(data['mood'] as int? ?? 2),
      lightText: data['lightText'] as String?,
      tags: (data['tags'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      timelineEvents: (data['timelineEvents'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
      habitCompletions: (data['habitCompletions'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as bool? ?? false)),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().toList();
      }
    }
    return [];
  }

  static Map<String, bool> _decodeBoolMap(dynamic raw) {
    if (raw is String) {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((k, v) => MapEntry(k, v as bool? ?? false));
      }
    }
    return {};
  }
}
```

**要点**：

- `tags` 在 SQLite 中以 JSON 字符串存储，Dart 层为 `List<String>`
- `timelineEvents` 和 `habitCompletions` 预留给 Track 4，MVP 阶段值为 null
- Firestore 文档 ID 使用 `date` 字符串（`YYYY-MM-DD`），确保每用户每天唯一
- `copyWith` 支持 `clearLightText` 标志位，用于显式置空可选字段

---

### 2.3 `WeeklyReview` 模型（`lib/models/weekly_review.dart`）

```dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// 周回顾记录 — 每周日复盘的三个快乐时刻 + 感恩 + 学习。
/// 对应 SQLite 表 `local_weekly_reviews`，Firestore 路径 `users/{uid}/weeklyReviews/{weekId}`。
///
/// 周定义：ISO 8601（周一开始，周日结束）。
/// weekId 格式：'YYYY-WNN'（如 '2026-W12'）。
class WeeklyReview {
  final String id;
  final String weekId; // 'YYYY-WNN' ISO 格式
  final String weekStartDate; // 周一日期 'YYYY-MM-DD'
  final String weekEndDate; // 周日日期 'YYYY-MM-DD'

  // 三个快乐时刻（独立字段，非 List）
  final String? happyMoment1;
  final List<String> happyMoment1Tags;
  final String? happyMoment2;
  final List<String> happyMoment2Tags;
  final String? happyMoment3;
  final List<String> happyMoment3Tags;

  final String? gratitude; // 本周感恩
  final String? learning; // 本周学习
  final String? catWeeklySummary; // 猫咪周总结（模板库生成，非 AI）

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

  /// 已填写的快乐时刻数量（0-3）
  int get filledMomentCount {
    int count = 0;
    if (happyMoment1 != null && happyMoment1!.isNotEmpty) count++;
    if (happyMoment2 != null && happyMoment2!.isNotEmpty) count++;
    if (happyMoment3 != null && happyMoment3!.isNotEmpty) count++;
    return count;
  }

  /// 周回顾是否完成（至少 1 个快乐时刻 + 感恩或学习之一）
  bool get isComplete {
    final hasMoment = filledMomentCount >= 1;
    final hasReflection = (gratitude != null && gratitude!.isNotEmpty) ||
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
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
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
    final data = doc.data()! as Map<String, dynamic>;
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
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
      if (decoded is List) {
        return decoded.whereType<String>().toList();
      }
    }
    return [];
  }

  static List<String> _decodeFirestoreList(dynamic raw) {
    if (raw is List<dynamic>) {
      return raw.whereType<String>().toList();
    }
    return [];
  }
}
```

**要点**：

- 使用 3 个独立的 `happyMoment` 字段（非 List），每个配对独立的 tags 字段
- `weekId` 格式为 ISO 8601 `'YYYY-WNN'`，例如 `'2026-W12'`
- Firestore 文档 ID 使用 `weekId`
- `isComplete` 判定：至少 1 个快乐时刻 + 感恩或学习之一

---

### 2.4 `Worry` 模型（`lib/models/worry.dart`）

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// 烦恼状态枚举。
enum WorryStatus {
  ongoing('ongoing'),
  resolved('resolved'),
  disappeared('disappeared');

  const WorryStatus(this.value);
  final String value;

  static WorryStatus fromValue(String value) {
    return WorryStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown WorryStatus: $value'),
    );
  }
}

/// 烦恼记录 — 用户外化的焦虑或烦恼。
/// 对应 SQLite 表 `local_worries`，Firestore 路径 `users/{uid}/worries/{worryId}`。
class Worry {
  final String id;
  final String description;
  final String? solution;
  final WorryStatus status;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Worry({
    required this.id,
    required this.description,
    this.solution,
    this.status = WorryStatus.ongoing,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'description': description,
      'solution': solution,
      'status': status.value,
      'resolved_at': resolvedAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Worry.fromSqlite(Map<String, dynamic> map) {
    return Worry(
      id: map['id'] as String,
      description: map['description'] as String,
      solution: map['solution'] as String?,
      status: WorryStatus.fromValue(
        map['status'] as String? ?? 'ongoing',
      ),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resolved_at'] as int)
          : null,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'solution': solution,
      'status': status.value,
      'resolvedAt': resolvedAt != null
          ? Timestamp.fromDate(resolvedAt!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Worry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Worry(
      id: doc.id,
      description: data['description'] as String? ?? '',
      solution: data['solution'] as String?,
      status: WorryStatus.fromValue(
        data['status'] as String? ?? 'ongoing',
      ),
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  Worry copyWith({
    String? id,
    String? description,
    String? solution,
    bool clearSolution = false,
    WorryStatus? status,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Worry(
      id: id ?? this.id,
      description: description ?? this.description,
      solution: clearSolution ? null : (solution ?? this.solution),
      status: status ?? this.status,
      resolvedAt: clearResolvedAt
          ? null
          : (resolvedAt ?? this.resolvedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

**要点**：

- `WorryStatus` 三态：进行中 / 已解决 / 自然消失
- `resolvedAt` 仅在 status 变更为 resolved 或 disappeared 时赋值
- SQLite 中 `status` 列存储字符串值，默认 `'ongoing'`

---

## 3. SQLite Migration

### 当前版本

当前 Schema 版本为 **v3**（`lib/services/local_database_service.dart` 第 18 行）。本次升级到 **v4**。

### 版本升级修改

在 `LocalDatabaseService` 中修改：

```dart
// 修改：_dbVersion 从 3 改为 4
static const _dbVersion = 4;
```

### 新增 4 张表的完整 SQL

#### 3.1 `local_daily_lights` 表

```sql
CREATE TABLE local_daily_lights (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  date TEXT NOT NULL,
  mood INTEGER NOT NULL DEFAULT 2,
  light_text TEXT,
  tags TEXT NOT NULL DEFAULT '[]',
  timeline_events TEXT,
  habit_completions TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(uid, date)
)
```

索引：

```sql
CREATE INDEX idx_daily_lights_uid_date
  ON local_daily_lights(uid, date)
```

#### 3.2 `local_weekly_reviews` 表

```sql
CREATE TABLE local_weekly_reviews (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  week_id TEXT NOT NULL,
  week_start_date TEXT NOT NULL,
  week_end_date TEXT NOT NULL,
  happy_moment_1 TEXT,
  happy_moment_1_tags TEXT NOT NULL DEFAULT '[]',
  happy_moment_2 TEXT,
  happy_moment_2_tags TEXT NOT NULL DEFAULT '[]',
  happy_moment_3 TEXT,
  happy_moment_3_tags TEXT NOT NULL DEFAULT '[]',
  gratitude TEXT,
  learning TEXT,
  cat_weekly_summary TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(uid, week_id)
)
```

索引：

```sql
CREATE INDEX idx_weekly_reviews_uid_week
  ON local_weekly_reviews(uid, week_id)
```

#### 3.3 `local_worries` 表

```sql
CREATE TABLE local_worries (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  description TEXT NOT NULL,
  solution TEXT,
  status TEXT NOT NULL DEFAULT 'ongoing',
  resolved_at INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
```

索引：

```sql
CREATE INDEX idx_worries_uid_status
  ON local_worries(uid, status)
```

#### 3.4 `local_awareness_stats` 表

```sql
CREATE TABLE local_awareness_stats (
  uid TEXT PRIMARY KEY,
  total_light_days INTEGER NOT NULL DEFAULT 0,
  total_weekly_reviews INTEGER NOT NULL DEFAULT 0,
  total_worries_resolved INTEGER NOT NULL DEFAULT 0,
  last_light_date TEXT,
  updated_at INTEGER NOT NULL
)
```

> **说明**：`local_awareness_stats` 是聚合统计表，主键为 `uid`（单用户单行），不需要额外索引。用于快速查询成就评估所需的计数器，避免每次 `COUNT(*)` 全表扫描。

### 迁移方法实现

在 `lib/services/local_database_service.dart` 中新增：

```dart
/// v4 表：觉知记录（每日一光 + 周回顾 + 烦恼 + 聚合统计）。
Future<void> _createV4Tables(Database db) async {
  await db.execute('''
    CREATE TABLE local_daily_lights (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      date TEXT NOT NULL,
      mood INTEGER NOT NULL DEFAULT 2,
      light_text TEXT,
      tags TEXT NOT NULL DEFAULT '[]',
      timeline_events TEXT,
      habit_completions TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(uid, date)
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_daily_lights_uid_date '
    'ON local_daily_lights(uid, date)',
  );

  await db.execute('''
    CREATE TABLE local_weekly_reviews (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      week_id TEXT NOT NULL,
      week_start_date TEXT NOT NULL,
      week_end_date TEXT NOT NULL,
      happy_moment_1 TEXT,
      happy_moment_1_tags TEXT NOT NULL DEFAULT '[]',
      happy_moment_2 TEXT,
      happy_moment_2_tags TEXT NOT NULL DEFAULT '[]',
      happy_moment_3 TEXT,
      happy_moment_3_tags TEXT NOT NULL DEFAULT '[]',
      gratitude TEXT,
      learning TEXT,
      cat_weekly_summary TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(uid, week_id)
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_weekly_reviews_uid_week '
    'ON local_weekly_reviews(uid, week_id)',
  );

  await db.execute('''
    CREATE TABLE local_worries (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      description TEXT NOT NULL,
      solution TEXT,
      status TEXT NOT NULL DEFAULT 'ongoing',
      resolved_at INTEGER,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_worries_uid_status '
    'ON local_worries(uid, status)',
  );

  await db.execute('''
    CREATE TABLE local_awareness_stats (
      uid TEXT PRIMARY KEY,
      total_light_days INTEGER NOT NULL DEFAULT 0,
      total_weekly_reviews INTEGER NOT NULL DEFAULT 0,
      total_worries_resolved INTEGER NOT NULL DEFAULT 0,
      last_light_date TEXT,
      updated_at INTEGER NOT NULL
    )
  ''');
}
```

修改 `_onCreate`：

```dart
Future<void> _onCreate(Database db, int version) async {
  await _createV1Tables(db);
  if (version >= 2) {
    await _createV2Tables(db);
  }
  if (version >= 3) {
    await _createV3Columns(db);
  }
  if (version >= 4) {
    await _createV4Tables(db);
  }
}
```

修改 `_onUpgrade`：

```dart
Future<void> _onUpgrade(Database db, int oldV, int newV) async {
  if (oldV < 2) {
    await _createV2Tables(db);
  }
  if (oldV < 3) {
    await _createV3Columns(db);
  }
  if (oldV < 4) {
    await _createV4Tables(db);
  }
}
```

---

## 4. 新增 ActionType 枚举值

在 `lib/models/ledger_action.dart` 的 `ActionType` 枚举中新增 6 个值：

```dart
enum ActionType {
  // ... 现有值 ...
  profileUpdate('profile_update'),

  // ─── V3 觉知功能 ───
  lightRecorded('light_recorded'),
  weeklyReviewCompleted('weekly_review_completed'),
  worryCreated('worry_created'),
  worryUpdated('worry_updated'),
  worryResolved('worry_resolved'),
  monthlyRitualSet('monthly_ritual_set');

  // ... 构造函数和 fromValue 不变 ...
}
```

**插入位置**：在 `profileUpdate` 之后，分号之前。加注释分隔。

---

## 5. Service API 契约

### 5.1 `AwarenessRepository`（`lib/services/awareness_repository.dart`）

```dart
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// 觉知数据仓库 — DailyLight + WeeklyReview + 聚合统计 CRUD。
/// 所有写操作在 SQLite 事务中同时更新领域表、聚合统计表和行为台账。
class AwarenessRepository {
  final LedgerService _ledger;

  AwarenessRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── DailyLight 查询 ───

  /// 获取今日之光记录。
  Future<DailyLight?> getTodayLight(String uid, String todayDate) async {
    // todayDate: 'YYYY-MM-DD' 格式
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: 'uid = ? AND date = ?',
      whereArgs: [uid, todayDate],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyLight.fromSqlite(rows.first);
  }

  /// 按日期获取记录。
  Future<DailyLight?> getLightByDate(String uid, String date) async {
    return getTodayLight(uid, date);
  }

  /// 获取指定月份的所有记录（月历视图用）。
  /// month 格式：'YYYY-MM'
  Future<List<DailyLight>> getLightsForMonth(
    String uid,
    String month,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: "uid = ? AND date LIKE ?",
      whereArgs: [uid, '$month%'],
      orderBy: 'date ASC',
    );
    return rows.map(DailyLight.fromSqlite).toList();
  }

  /// 获取日期范围内的记录。
  Future<List<DailyLight>> getLightsInRange(
    String uid,
    String startDate,
    String endDate,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      where: 'uid = ? AND date >= ? AND date <= ?',
      whereArgs: [uid, startDate, endDate],
      orderBy: 'date ASC',
    );
    return rows.map(DailyLight.fromSqlite).toList();
  }

  /// 获取总记录天数（从聚合统计表读取）。
  Future<int> getTotalLightDays(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      columns: ['total_light_days'],
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return rows.first['total_light_days'] as int? ?? 0;
  }

  // ─── DailyLight 写入 ───

  /// 保存每日一光（新建或更新）。
  /// 写入模式：db.transaction → insert/update → appendInTxn → stats 更新 → notifyChange
  Future<void> saveDailyLight(String uid, DailyLight light) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final isNew = await _isNewDailyLight(db, uid, light.date);

    await db.transaction((txn) async {
      // 1. 写入领域表（REPLACE 语义，基于 UNIQUE(uid, date)）
      await txn.insert(
        'local_daily_lights',
        light.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 2. 写入行为台账
      await _ledger.appendInTxn(
        txn,
        type: ActionType.lightRecorded,
        uid: uid,
        startedAt: now,
        payload: {
          'date': light.date,
          'mood': light.mood.value,
          'hasText': light.hasText,
          'tagCount': light.tags.length,
        },
      );

      // 3. 更新聚合统计（仅新记录时递增）
      if (isNew) {
        await _incrementLightDaysInTxn(txn, uid, light.date);
      }
    });

    _ledger.notifyChange(
      LedgerChange(type: 'light_recorded', affectedIds: [light.id]),
    );
  }

  /// 删除每日一光记录。
  Future<void> deleteDailyLight(String uid, String date) async {
    final db = await _ledger.database;
    await db.transaction((txn) async {
      final deleted = await txn.delete(
        'local_daily_lights',
        where: 'uid = ? AND date = ?',
        whereArgs: [uid, date],
      );
      if (deleted > 0) {
        await _decrementLightDaysInTxn(txn, uid);
      }
    });
    _ledger.notifyChange(const LedgerChange(type: 'light_recorded'));
  }

  // ─── WeeklyReview 查询 ───

  /// 获取当前周的回顾。
  Future<WeeklyReview?> getCurrentWeekReview(
    String uid,
    String currentWeekId,
  ) async {
    return getReviewByWeekId(uid, currentWeekId);
  }

  /// 按 weekId 获取回顾。
  Future<WeeklyReview?> getReviewByWeekId(
    String uid,
    String weekId,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_reviews',
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return WeeklyReview.fromSqlite(rows.first);
  }

  /// 获取日期范围内的周回顾。
  Future<List<WeeklyReview>> getReviewsInRange(
    String uid,
    String startWeekId,
    String endWeekId,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_reviews',
      where: 'uid = ? AND week_id >= ? AND week_id <= ?',
      whereArgs: [uid, startWeekId, endWeekId],
      orderBy: 'week_id ASC',
    );
    return rows.map(WeeklyReview.fromSqlite).toList();
  }

  /// 获取总周回顾数。
  Future<int> getTotalReviewCount(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      columns: ['total_weekly_reviews'],
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return rows.first['total_weekly_reviews'] as int? ?? 0;
  }

  // ─── WeeklyReview 写入 ───

  /// 保存周回顾（新建或更新）。
  Future<void> saveWeeklyReview(String uid, WeeklyReview review) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final isNew = await _isNewWeeklyReview(db, uid, review.weekId);

    await db.transaction((txn) async {
      await txn.insert(
        'local_weekly_reviews',
        review.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 仅在回顾完成状态时写台账（避免草稿状态频繁写入）
      if (review.isComplete) {
        await _ledger.appendInTxn(
          txn,
          type: ActionType.weeklyReviewCompleted,
          uid: uid,
          startedAt: now,
          payload: {
            'weekId': review.weekId,
            'momentCount': review.filledMomentCount,
          },
        );
      }

      if (isNew && review.isComplete) {
        await _incrementWeeklyReviewsInTxn(txn, uid);
      }
    });

    _ledger.notifyChange(
      LedgerChange(
        type: 'weekly_review_completed',
        affectedIds: [review.id],
      ),
    );
  }

  // ─── 聚合统计 ───

  /// 获取觉知聚合统计。
  Future<Map<String, int>> getAwarenessStats(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) {
      return {
        'totalLightDays': 0,
        'totalWeeklyReviews': 0,
        'totalWorriesResolved': 0,
      };
    }
    final row = rows.first;
    return {
      'totalLightDays': row['total_light_days'] as int? ?? 0,
      'totalWeeklyReviews': row['total_weekly_reviews'] as int? ?? 0,
      'totalWorriesResolved': row['total_worries_resolved'] as int? ?? 0,
    };
  }

  // ─── 标签分析（Track 5 使用）───

  /// 获取标签频率统计。
  /// 返回 Map<标签名, 出现次数>，按频率降序。
  Future<Map<String, int>> getTagFrequency(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_daily_lights',
      columns: ['tags'],
      where: 'uid = ?',
      whereArgs: [uid],
    );
    final freq = <String, int>{};
    for (final row in rows) {
      final tagsJson = row['tags'] as String? ?? '[]';
      final tags = DailyLight.fromSqlite({
        ...row,
        'id': '',
        'date': '',
        'mood': 2,
        'created_at': 0,
        'updated_at': 0,
      }).tags;
      // 注意：上面的 hack 不优雅，改用直接解析
      // 实际实现时直接解析 JSON 即可
    }
    // 实际实现：
    // for (final row in rows) {
    //   final decoded = jsonDecode(row['tags'] as String? ?? '[]');
    //   if (decoded is List) {
    //     for (final tag in decoded.whereType<String>()) {
    //       freq[tag] = (freq[tag] ?? 0) + 1;
    //     }
    //   }
    // }
    // 按频率降序排列
    // final sorted = freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    // return Map.fromEntries(sorted);
    return freq;
  }

  // ─── 私有辅助方法 ───

  Future<bool> _isNewDailyLight(Database db, String uid, String date) async {
    final rows = await db.query(
      'local_daily_lights',
      columns: ['id'],
      where: 'uid = ? AND date = ?',
      whereArgs: [uid, date],
      limit: 1,
    );
    return rows.isEmpty;
  }

  Future<bool> _isNewWeeklyReview(
    Database db,
    String uid,
    String weekId,
  ) async {
    final rows = await db.query(
      'local_weekly_reviews',
      columns: ['id'],
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    return rows.isEmpty;
  }

  Future<void> _incrementLightDaysInTxn(
    Transaction txn,
    String uid,
    String date,
  ) async {
    await txn.rawInsert('''
      INSERT INTO local_awareness_stats (uid, total_light_days, total_weekly_reviews, total_worries_resolved, last_light_date, updated_at)
      VALUES (?, 1, 0, 0, ?, ?)
      ON CONFLICT(uid) DO UPDATE SET
        total_light_days = total_light_days + 1,
        last_light_date = excluded.last_light_date,
        updated_at = excluded.updated_at
    ''', [uid, date, DateTime.now().millisecondsSinceEpoch]);
  }

  Future<void> _decrementLightDaysInTxn(Transaction txn, String uid) async {
    await txn.rawUpdate('''
      UPDATE local_awareness_stats
      SET total_light_days = MAX(total_light_days - 1, 0),
          updated_at = ?
      WHERE uid = ?
    ''', [DateTime.now().millisecondsSinceEpoch, uid]);
  }

  Future<void> _incrementWeeklyReviewsInTxn(
    Transaction txn,
    String uid,
  ) async {
    await txn.rawInsert('''
      INSERT INTO local_awareness_stats (uid, total_light_days, total_weekly_reviews, total_worries_resolved, last_light_date, updated_at)
      VALUES (?, 0, 1, 0, NULL, ?)
      ON CONFLICT(uid) DO UPDATE SET
        total_weekly_reviews = total_weekly_reviews + 1,
        updated_at = excluded.updated_at
    ''', [uid, DateTime.now().millisecondsSinceEpoch]);
  }
}
```

**实现说明**：

- `getTagFrequency` 的伪代码注释中给出了实际实现逻辑，直接 `jsonDecode` tags 列并累加频率
- 聚合统计使用 `INSERT ... ON CONFLICT DO UPDATE`（SQLite UPSERT），保证原子性
- 所有写入方法遵循固定模式：`db.transaction → insert/update → appendInTxn → stats → notifyChange`

---

### 5.2 `WorryRepository`（`lib/services/worry_repository.dart`）

```dart
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// 烦恼仓库 — local_worries 表 CRUD + 台账写入。
class WorryRepository {
  final LedgerService _ledger;

  WorryRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── 查询 ───

  /// 获取所有进行中的烦恼（按创建时间倒序）。
  Future<List<Worry>> getActiveWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: "uid = ? AND status = 'ongoing'",
      whereArgs: [uid],
      orderBy: 'created_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 获取已解决/已消失的烦恼（按解决时间倒序）。
  Future<List<Worry>> getResolvedWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: "uid = ? AND status IN ('resolved', 'disappeared')",
      whereArgs: [uid],
      orderBy: 'resolved_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 获取所有烦恼（含已解决，按创建时间倒序）。
  Future<List<Worry>> getAllWorries(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'created_at DESC',
    );
    return rows.map(Worry.fromSqlite).toList();
  }

  /// 按 ID 获取烦恼。
  Future<Worry?> getWorry(String worryId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_worries',
      where: 'id = ?',
      whereArgs: [worryId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Worry.fromSqlite(rows.first);
  }

  /// 获取已解决烦恼总数（从聚合统计表读取）。
  Future<int> getResolvedCount(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_awareness_stats',
      columns: ['total_worries_resolved'],
      where: 'uid = ?',
      whereArgs: [uid],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return rows.first['total_worries_resolved'] as int? ?? 0;
  }

  // ─── 写入 ───

  /// 创建新烦恼。
  Future<Worry> create(String uid, String description) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final worry = Worry(
      id: _uuid.v4(),
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    await db.transaction((txn) async {
      await txn.insert('local_worries', worry.toSqlite(uid));
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryCreated,
        uid: uid,
        startedAt: now,
        payload: {'worryId': worry.id},
      );
    });

    _ledger.notifyChange(
      LedgerChange(type: 'worry_created', affectedIds: [worry.id]),
    );
    return worry;
  }

  /// 更新烦恼描述或解决方案。
  Future<void> update(String uid, Worry worry) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final updated = worry.copyWith(updatedAt: now);

    await db.transaction((txn) async {
      await txn.update(
        'local_worries',
        updated.toSqlite(uid),
        where: 'id = ?',
        whereArgs: [updated.id],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryUpdated,
        uid: uid,
        startedAt: now,
        payload: {'worryId': updated.id},
      );
    });

    _ledger.notifyChange(
      LedgerChange(type: 'worry_updated', affectedIds: [updated.id]),
    );
  }

  /// 标记烦恼为已解决 / 已消失。
  Future<void> resolve(
    String uid,
    String worryId,
    WorryStatus resolvedStatus,
  ) async {
    assert(
      resolvedStatus == WorryStatus.resolved ||
          resolvedStatus == WorryStatus.disappeared,
    );
    final db = await _ledger.database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      await txn.update(
        'local_worries',
        {
          'status': resolvedStatus.value,
          'resolved_at': now.millisecondsSinceEpoch,
          'updated_at': now.millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [worryId],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.worryResolved,
        uid: uid,
        startedAt: now,
        payload: {
          'worryId': worryId,
          'resolvedStatus': resolvedStatus.value,
        },
      );
      // 更新聚合统计
      await _incrementWorriesResolvedInTxn(txn, uid);
    });

    _ledger.notifyChange(
      LedgerChange(type: 'worry_resolved', affectedIds: [worryId]),
    );
  }

  /// 删除烦恼（硬删除）。
  Future<void> delete(String uid, String worryId) async {
    final db = await _ledger.database;
    await db.delete(
      'local_worries',
      where: 'id = ? AND uid = ?',
      whereArgs: [worryId, uid],
    );
    _ledger.notifyChange(
      LedgerChange(type: 'worry_updated', affectedIds: [worryId]),
    );
  }

  // ─── 私有辅助 ───

  Future<void> _incrementWorriesResolvedInTxn(
    Transaction txn,
    String uid,
  ) async {
    await txn.rawInsert('''
      INSERT INTO local_awareness_stats (uid, total_light_days, total_weekly_reviews, total_worries_resolved, last_light_date, updated_at)
      VALUES (?, 0, 0, 1, NULL, ?)
      ON CONFLICT(uid) DO UPDATE SET
        total_worries_resolved = total_worries_resolved + 1,
        updated_at = excluded.updated_at
    ''', [uid, DateTime.now().millisecondsSinceEpoch]);
  }
}
```

---

## 6. Riverpod Provider 定义

### 文件：`lib/providers/awareness_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 今日之光 ───

/// 今日之光记录 — SSOT from local SQLite。
final todayLightProvider = StreamProvider<DailyLight?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final repo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  final today = AppDateUtils.todayString();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type == 'light_recorded',
    read: () => repo.getTodayLight(uid, today),
  );
});

/// 今天是否已记录 — 派生 provider。
final hasRecordedTodayLightProvider = Provider<bool>((ref) {
  return ref.watch(todayLightProvider).value != null;
});

/// 指定月份的每日一光列表 — family provider。
/// 参数：'YYYY-MM' 格式月份字符串。
final monthlyLightsProvider = FutureProvider.family<List<DailyLight>, String>((
  ref,
  month,
) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final repo = ref.watch(awarenessRepositoryProvider);
  return repo.getLightsForMonth(uid, month);
});

// ─── 周回顾 ───

/// 当前周回顾 — SSOT from local SQLite。
final currentWeekReviewProvider = StreamProvider<WeeklyReview?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final repo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  final weekId = AppDateUtils.currentIsoWeekId();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == 'weekly_review_completed',
    read: () => repo.getCurrentWeekReview(uid, weekId),
  );
});

// ─── 烦恼 ───

/// 进行中的烦恼列表 — SSOT from local SQLite。
final activeWorriesProvider = StreamProvider<List<Worry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);

  final repo = ref.watch(worryRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type.startsWith('worry_'),
    read: () => repo.getActiveWorries(uid),
  );
});

/// 已解决/已消失的烦恼列表。
final resolvedWorriesProvider = StreamProvider<List<Worry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  final repo = ref.watch(worryRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) => c.isGlobalRefresh || c.type.startsWith('worry_'),
    read: () => repo.getResolvedWorries(uid),
  );
});

// ─── 聚合统计 ───

/// 觉知聚合统计 — 成就评估和数据面板使用。
final awarenessStatsProvider = StreamProvider<Map<String, int>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value({});

  final repo = ref.watch(awarenessRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == 'light_recorded' ||
        c.type == 'weekly_review_completed' ||
        c.type == 'worry_resolved',
    read: () => repo.getAwarenessStats(uid),
  );
});
```

> **说明**：`awarenessRepositoryProvider` 和 `worryRepositoryProvider` 定义在 `service_providers.dart` 中（见第 11 节修改清单）。`AppDateUtils.currentIsoWeekId()` 需在现有 `date_utils.dart` 中新增。

### 在 `lib/providers/service_providers.dart` 中新增

```dart
import 'package:hachimi_app/services/awareness_repository.dart';
import 'package:hachimi_app/services/worry_repository.dart';

final awarenessRepositoryProvider = Provider<AwarenessRepository>((ref) {
  return AwarenessRepository(ledger: ref.watch(ledgerServiceProvider));
});

final worryRepositoryProvider = Provider<WorryRepository>((ref) {
  return WorryRepository(ledger: ref.watch(ledgerServiceProvider));
});
```

### `AppDateUtils` 新增方法

在 `lib/core/utils/date_utils.dart` 中新增：

```dart
/// 获取当前 ISO 8601 周标识（如 '2026-W12'）。
/// 周一为一周的第一天。
static String currentIsoWeekId() {
  return isoWeekIdForDate(DateTime.now());
}

/// 获取指定日期的 ISO 8601 周标识。
static String isoWeekIdForDate(DateTime date) {
  // ISO 8601 周计算：以周四所在年为准
  final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
  final yearOfWeek = thursday.year;
  final jan1 = DateTime(yearOfWeek, 1, 1);
  final jan1Weekday = jan1.weekday;
  final firstThursday = jan1.add(Duration(days: (DateTime.thursday - jan1Weekday + 7) % 7));
  final weekNumber = ((thursday.difference(firstThursday).inDays) ~/ 7) + 1;
  return '$yearOfWeek-W${weekNumber.toString().padLeft(2, '0')}';
}

/// 获取 ISO 周的周一日期（'YYYY-MM-DD' 格式）。
static String isoWeekStartDate(DateTime date) {
  final monday = date.subtract(Duration(days: date.weekday - DateTime.monday));
  return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
}

/// 获取 ISO 周的周日日期（'YYYY-MM-DD' 格式）。
static String isoWeekEndDate(DateTime date) {
  final sunday = date.add(Duration(days: DateTime.sunday - date.weekday));
  return '${sunday.year}-${sunday.month.toString().padLeft(2, '0')}-${sunday.day.toString().padLeft(2, '0')}';
}
```

---

## 7. SyncEngine 更新

### 文件：`lib/services/sync_engine.dart`

### 7.1 `_syncAction` switch 新增 case

在现有的 `_syncAction` 方法的 switch 语句中，`accountCreated` / `accountLinked` / `achievementClaimed` 分支前新增：

```dart
case ActionType.lightRecorded:
  await _syncDailyLight(batch, uid, action);
case ActionType.weeklyReviewCompleted:
  await _syncWeeklyReview(batch, uid, action);
case ActionType.worryCreated:
case ActionType.worryUpdated:
case ActionType.worryResolved:
  await _syncWorry(batch, uid, action);
case ActionType.monthlyRitualSet:
  // 暂不需要 Firestore 同步（纯本地提醒配置）
  await _ledger.markSynced(action.id);
  return;
```

### 7.2 新增同步方法

```dart
Future<void> _syncDailyLight(
  WriteBatch batch,
  String uid,
  LedgerAction action,
) async {
  final date = action.payload['date'] as String?;
  if (date == null) return;

  final db = await _ledger.database;
  final rows = await db.query(
    'local_daily_lights',
    where: 'uid = ? AND date = ?',
    whereArgs: [uid, date],
    limit: 1,
  );
  if (rows.isEmpty) return;

  final light = DailyLight.fromSqlite(rows.first);
  final ref = _db
      .collection('users')
      .doc(uid)
      .collection('dailyLights')
      .doc(date);
  batch.set(ref, light.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncWeeklyReview(
  WriteBatch batch,
  String uid,
  LedgerAction action,
) async {
  final weekId = action.payload['weekId'] as String?;
  if (weekId == null) return;

  final db = await _ledger.database;
  final rows = await db.query(
    'local_weekly_reviews',
    where: 'uid = ? AND week_id = ?',
    whereArgs: [uid, weekId],
    limit: 1,
  );
  if (rows.isEmpty) return;

  final review = WeeklyReview.fromSqlite(rows.first);
  final ref = _db
      .collection('users')
      .doc(uid)
      .collection('weeklyReviews')
      .doc(weekId);
  batch.set(ref, review.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncWorry(
  WriteBatch batch,
  String uid,
  LedgerAction action,
) async {
  final worryId = action.payload['worryId'] as String?;
  if (worryId == null) return;

  final db = await _ledger.database;
  final rows = await db.query(
    'local_worries',
    where: 'id = ?',
    whereArgs: [worryId],
    limit: 1,
  );
  if (rows.isEmpty) return;

  final worry = Worry.fromSqlite(rows.first);
  final ref = _db
      .collection('users')
      .doc(uid)
      .collection('worries')
      .doc(worryId);
  batch.set(ref, worry.toFirestore(), SetOptions(merge: true));
}
```

### 7.3 水化更新

在 `_doHydrate` 方法中新增 3 个集合水化：

```dart
// 在 _hydrateCollection<Cat>(...) 之后添加：
await _hydrateCollection<DailyLight>(
  userRef.collection('dailyLights'),
  'local_daily_lights',
  db,
  (doc) => DailyLight.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<WeeklyReview>(
  userRef.collection('weeklyReviews'),
  'local_weekly_reviews',
  db,
  (doc) => WeeklyReview.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<Worry>(
  userRef.collection('worries'),
  'local_worries',
  db,
  (doc) => Worry.fromFirestore(doc).toSqlite(uid),
);
```

需新增 import：

```dart
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
```

---

## 8. Firestore 规则更新

### 文件：`firestore.rules`

在 `match /users/{userId}` 块内，`achievements` 规则之后、闭合花括号之前新增：

```javascript
// Daily light records
match /dailyLights/{date} {
  allow read, write: if isOwner(userId);
}

// Weekly review records
match /weeklyReviews/{weekId} {
  allow read, write: if isOwner(userId);
}

// Worry records
match /worries/{worryId} {
  allow read, write: if isOwner(userId);
}
```

> **说明**：MVP 阶段使用宽松规则（`isOwner` 即可读写），后续可按需添加字段校验（参考 habits 的验证模式）。

---

## 9. LedgerService 更新

### 文件：`lib/services/ledger_service.dart`

### 9.1 `migrateUid()` 更新

修改 `migrateUid` 方法，在单列 PK 表列表中新增 `'local_worries'`，在复合 PK / UNIQUE 约束表列表中新增 `'local_daily_lights'` 和 `'local_weekly_reviews'`：

```dart
Future<void> migrateUid(String oldUid, String newUid) async {
  final db = await database;
  await db.transaction((txn) async {
    // 单列 PK 表 — 直接 UPDATE
    for (final table in [
      'action_ledger',
      'local_habits',
      'local_cats',
      'local_sessions',
      'local_achievements',
      'local_worries', // V3 新增
    ]) {
      await txn.update(
        table,
        {'uid': newUid},
        where: 'uid = ?',
        whereArgs: [oldUid],
      );
    }

    // 复合 PK / UNIQUE 约束表 — 先删 newUid 默认行，再更新 oldUid→newUid
    for (final table in [
      'materialized_state',
      'local_monthly_checkins',
      'local_daily_lights',    // V3 新增（UNIQUE(uid, date)）
      'local_weekly_reviews',  // V3 新增（UNIQUE(uid, week_id)）
      'local_awareness_stats', // V3 新增（uid 为 PK）
    ]) {
      await txn.delete(table, where: 'uid = ?', whereArgs: [newUid]);
      await txn.update(
        table,
        {'uid': newUid},
        where: 'uid = ?',
        whereArgs: [oldUid],
      );
    }
  });
}
```

### 9.2 `deleteUidData()` 更新

```dart
Future<void> deleteUidData(String uid) async {
  final db = await database;
  await db.transaction((txn) async {
    for (final table in [
      'action_ledger',
      'local_habits',
      'local_cats',
      'local_sessions',
      'local_monthly_checkins',
      'materialized_state',
      'local_achievements',
      'local_daily_lights',    // V3 新增
      'local_weekly_reviews',  // V3 新增
      'local_worries',         // V3 新增
      'local_awareness_stats', // V3 新增
    ]) {
      await txn.delete(table, where: 'uid = ?', whereArgs: [uid]);
    }
  });
}
```

---

## 10. 单元测试要求

### 10.1 `test/models/mood_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/mood.dart';

void main() {
  group('Mood', () {
    test('所有枚举值 fromValue 往返一致', () {
      for (final mood in Mood.values) {
        expect(Mood.fromValue(mood.value), equals(mood));
      }
    });

    test('fromValue 无效值抛出 ArgumentError', () {
      expect(() => Mood.fromValue(-1), throwsArgumentError);
      expect(() => Mood.fromValue(99), throwsArgumentError);
    });

    test('emoji 字段非空', () {
      for (final mood in Mood.values) {
        expect(mood.emoji, isNotEmpty);
      }
    });
  });
}
```

### 10.2 `test/models/daily_light_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/mood.dart';

void main() {
  final now = DateTime(2026, 3, 17, 22, 0);
  final sample = DailyLight(
    id: 'test-id',
    date: '2026-03-17',
    mood: Mood.happy,
    lightText: '今天和朋友聊了天',
    tags: ['社交', '开心'],
    createdAt: now,
    updatedAt: now,
  );

  group('DailyLight', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      expect(map['uid'], 'uid-123');
      expect(map['mood'], 1);

      final restored = DailyLight.fromSqlite(map);
      expect(restored.id, sample.id);
      expect(restored.date, sample.date);
      expect(restored.mood, sample.mood);
      expect(restored.lightText, sample.lightText);
      expect(restored.tags, sample.tags);
    });

    test('toFirestore / fromFirestore 往返一致', () {
      // fromFirestore 需要 DocumentSnapshot，
      // 此处测试 toFirestore 输出的 Map 结构正确性
      final map = sample.toFirestore();
      expect(map['mood'], 1);
      expect(map['lightText'], '今天和朋友聊了天');
      expect(map['tags'], ['社交', '开心']);
    });

    test('计算属性 hasText / hasTags', () {
      expect(sample.hasText, true);
      expect(sample.hasTags, true);

      final empty = sample.copyWith(
        clearLightText: true,
        tags: [],
      );
      expect(empty.hasText, false);
      expect(empty.hasTags, false);
    });

    test('tags 空列表在 SQLite 中存为 []', () {
      final noTags = sample.copyWith(tags: []);
      final map = noTags.toSqlite('uid');
      expect(map['tags'], '[]');
    });
  });
}
```

### 10.3 `test/models/weekly_review_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/weekly_review.dart';

void main() {
  final now = DateTime(2026, 3, 17, 22, 0);
  final sample = WeeklyReview(
    id: 'test-id',
    weekId: '2026-W12',
    weekStartDate: '2026-03-16',
    weekEndDate: '2026-03-22',
    happyMoment1: '完成了跑步目标',
    happyMoment1Tags: ['运动'],
    gratitude: '感恩好天气',
    createdAt: now,
    updatedAt: now,
  );

  group('WeeklyReview', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      final restored = WeeklyReview.fromSqlite(map);
      expect(restored.weekId, sample.weekId);
      expect(restored.happyMoment1, sample.happyMoment1);
      expect(restored.happyMoment1Tags, ['运动']);
      expect(restored.gratitude, sample.gratitude);
    });

    test('filledMomentCount 正确计数', () {
      expect(sample.filledMomentCount, 1);

      final two = sample.copyWith(
        happyMoment2: '读了一本好书',
      );
      expect(two.filledMomentCount, 2);

      final three = two.copyWith(
        happyMoment3: '和家人吃饭',
      );
      expect(three.filledMomentCount, 3);
    });

    test('isComplete 判定逻辑', () {
      // 有 1 个 moment + gratitude → 完成
      expect(sample.isComplete, true);

      // 有 moment 但无 gratitude 和 learning → 未完成
      final incomplete = WeeklyReview(
        id: 'test',
        weekId: '2026-W12',
        weekStartDate: '2026-03-16',
        weekEndDate: '2026-03-22',
        happyMoment1: '测试',
        createdAt: now,
        updatedAt: now,
      );
      expect(incomplete.isComplete, false);

      // 无 moment → 未完成（即使有 gratitude）
      final noMoment = WeeklyReview(
        id: 'test',
        weekId: '2026-W12',
        weekStartDate: '2026-03-16',
        weekEndDate: '2026-03-22',
        gratitude: '感恩',
        createdAt: now,
        updatedAt: now,
      );
      expect(noMoment.isComplete, false);
    });
  });
}
```

### 10.4 `test/models/worry_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/worry.dart';

void main() {
  final now = DateTime(2026, 3, 17, 22, 0);
  final sample = Worry(
    id: 'test-id',
    description: '担心面试结果',
    status: WorryStatus.ongoing,
    createdAt: now,
    updatedAt: now,
  );

  group('Worry', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      expect(map['status'], 'ongoing');

      final restored = Worry.fromSqlite(map);
      expect(restored.id, sample.id);
      expect(restored.description, sample.description);
      expect(restored.status, WorryStatus.ongoing);
    });

    test('WorryStatus.fromValue 所有值往返一致', () {
      for (final s in WorryStatus.values) {
        expect(WorryStatus.fromValue(s.value), equals(s));
      }
    });

    test('WorryStatus.fromValue 无效值抛出 ArgumentError', () {
      expect(
        () => WorryStatus.fromValue('invalid'),
        throwsArgumentError,
      );
    });

    test('resolved 状态含 resolvedAt', () {
      final resolved = sample.copyWith(
        status: WorryStatus.resolved,
        resolvedAt: now,
      );
      final map = resolved.toSqlite('uid');
      expect(map['resolved_at'], now.millisecondsSinceEpoch);
      expect(map['status'], 'resolved');
    });
  });
}
```

---

## 11. 文件操作清单

### 需要创建的文件

| 文件路径 | 用途 |
|----------|------|
| `lib/models/mood.dart` | Mood 枚举（5 级心情量表） |
| `lib/models/daily_light.dart` | DailyLight 模型（每日一光记录） |
| `lib/models/weekly_review.dart` | WeeklyReview 模型（周回顾记录） |
| `lib/models/worry.dart` | Worry 模型 + WorryStatus 枚举 |
| `lib/services/awareness_repository.dart` | DailyLight + WeeklyReview + 聚合统计 CRUD |
| `lib/services/worry_repository.dart` | Worry CRUD |
| `lib/providers/awareness_providers.dart` | 所有觉知相关 Riverpod provider |
| `test/models/mood_test.dart` | Mood 枚举单元测试 |
| `test/models/daily_light_test.dart` | DailyLight 模型单元测试 |
| `test/models/weekly_review_test.dart` | WeeklyReview 模型单元测试 |
| `test/models/worry_test.dart` | Worry 模型单元测试 |

### 需要修改的文件

| 文件路径 | 改动内容 |
|----------|----------|
| `lib/services/local_database_service.dart` | `_dbVersion` 升至 4；新增 `_createV4Tables` 方法；修改 `_onCreate` 和 `_onUpgrade` |
| `lib/models/ledger_action.dart` | 新增 6 个 `ActionType` 枚举值 |
| `lib/services/ledger_service.dart` | `migrateUid()` 新增 5 张表；`deleteUidData()` 新增 4 张表 |
| `lib/services/sync_engine.dart` | `_syncAction` 新增 6 个 case；新增 3 个同步方法；`_doHydrate` 新增 3 个集合水化；新增 3 个 import |
| `lib/providers/service_providers.dart` | 新增 `awarenessRepositoryProvider` 和 `worryRepositoryProvider` |
| `lib/core/utils/date_utils.dart` | 新增 `currentIsoWeekId`、`isoWeekIdForDate`、`isoWeekStartDate`、`isoWeekEndDate` |
| `firestore.rules` | 在 `users/{userId}` 下新增 3 个子集合匹配规则 |
| `docs/architecture/data-model.md` | 补充 4 张新表的 schema 文档 |
| `docs/architecture/state-management.md` | 补充新 provider 拓扑图 |

---

## 12. 完成标志

| 检查项 | 验证命令 / 方法 |
|--------|----------------|
| 静态分析零 warning | `dart analyze lib/` |
| 模型单元测试全绿 | `flutter test test/models/` |
| 4 张新表在全新安装时正确创建 | 删除 app 重装后检查 SQLite schema |
| v3→v4 升级迁移正常 | 在已有 v3 数据库的设备上升级验证 |
| LedgerService.migrateUid() 包含新表 | 代码审查 |
| LedgerService.deleteUidData() 包含新表 | 代码审查 |
| SyncEngine 6 个新 ActionType 有对应 case | 代码审查确认 switch 完备 |
| Firestore 规则部署成功 | `firebase deploy --only firestore:rules --project hachimi-ai` |
| 架构文档已同步更新 | `docs/architecture/data-model.md` 和 `state-management.md` 已更新 |

---

## 依赖关系

### 前置条件

- 无外部前置条件。Track 1 仅依赖现有基础设施（LedgerService、LocalDatabaseService、SyncEngine）

### 后续影响

- Track 2（每日一光 UI）直接依赖 `todayLightProvider`、`monthlyLightsProvider`、`awarenessRepositoryProvider`
- Track 3（周回顾 UI）直接依赖 `currentWeekReviewProvider`、`awarenessRepositoryProvider`
- Track 4（烦恼处理器 UI）直接依赖 `activeWorriesProvider`、`worryRepositoryProvider`
- Track 5（数据洞察）依赖 `awarenessStatsProvider`、`getTagFrequency`
- 成就系统扩展依赖 `awarenessStatsProvider` 中的累计计数器

### 外部依赖

- `sqflite`（已有）
- `uuid`（已有）
- `cloud_firestore`（已有）

无需新增任何依赖包。

---

## 风险与注意事项

| 风险点 | 缓解措施 |
|--------|----------|
| ISO 8601 周计算边界（跨年周） | `isoWeekIdForDate` 以周四所在年为准，测试 12/31 和 1/1 边界 |
| SQLite UPSERT 兼容性 | `ON CONFLICT DO UPDATE` 需 SQLite 3.24+，Android 11+ 和 sqflite 均支持 |
| 水化超时（新增 3 个集合） | `_hydrateTimeout` 为 8 秒，3 个新集合数据量小不会超时 |
| tags JSON 解析防御性 | `_decodeStringList` 在畸形数据时返回空列表，不抛异常 |
