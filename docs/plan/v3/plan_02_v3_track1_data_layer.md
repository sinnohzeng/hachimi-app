---
level: 2
file_id: plan_02
parent: plan_01
status: pending
created: 2026-03-19 22:00
children: []
---

# 模块：Track 1 — 数据基础层（LUMI Pivot）

## 1. 模块概述

### 模块目标

Track 1 是 LUMI 功能的 **地基工程**。完全聚焦于数据模型、本地持久化、台账同步和响应式 Provider 的搭建，不包含任何 UI 代码。

**LUMI Pivot 关键变更**：

- **无迁移** — 所有用户都是新用户，只建全新 Schema，不需要 v3→v4 升级路径
- **新增 5 个模型** — YearlyPlan、MonthlyPlan、WeeklyPlan、UserList、HighlightEntry
- **保留 4 个已实现模型** — DailyLight、WeeklyReview、Worry、Mood（代码已存在）
- **WeeklyReview 扩展** — 新增 `freeNote` 和 `worrySummary` 两个 TEXT 字段
- **双持久化** — 所有模型遵循 SQLite（本地 SSOT）+ Firestore（云备份）架构
- **ledgerDrivenStream** — 所有 Provider 使用台账驱动流模式

### 在项目中的位置

```
Track 1（数据基础）  ← 本文档
   ↑
Track 2（LUMI 核心 UI）
Track 3（计划系统 UI）
Track 4（列表 + 高光 UI）
Track 5（数据洞察 + 猫咪反应）
```

### 交付物概览

| 类别 | 数量 | 说明 |
|------|------|------|
| 新增 Dart 模型 | 5 个 | YearlyPlan、MonthlyPlan、WeeklyPlan、UserList、HighlightEntry |
| 已有模型（保留） | 4 个 | DailyLight、WeeklyReview、Worry、Mood |
| WeeklyReview 扩展 | 2 字段 | `freeNote`（TEXT）、`worrySummary`（TEXT） |
| 新增 SQLite 表 | 5 张 | 对应 5 个新模型 |
| WeeklyReview 表变更 | 2 列 | ALTER TABLE 新增 `free_note`、`worry_summary` |
| 新增 Service | 2 个 | PlanRepository、ListHighlightRepository |
| 新增 Provider | 10+ 个 | 覆盖所有 LUMI 数据的响应式访问 |
| 新增 ActionType | 5 个 | 计划、列表、高光相关 |
| 新增单元测试 | 5 个 | 新模型序列化往返测试 |

---

## 2. 已有模型（保留，不修改）

以下 4 个模型已在代码库中实现，LUMI Pivot 直接复用：

### 2.1 `Mood` 枚举（`lib/models/mood.dart`）

- 5 级心情量表：veryHappy(0) → happy(1) → calm(2) → down(3) → veryDown(4)
- `value` 用于 SQLite 存储，`emoji` 用于 UI 展示
- 已有 `themeColor(ColorScheme)` 方法

### 2.2 `DailyLight` 模型（`lib/models/daily_light.dart`）

- 每日一光记录，SQLite 表 `local_daily_lights`
- Firestore 路径 `users/{uid}/dailyLights/{date}`
- 字段：id、date、mood、lightText、tags、timelineEvents、habitCompletions、createdAt、updatedAt

### 2.3 `WeeklyReview` 模型（`lib/models/weekly_review.dart`）

- 周回顾记录，SQLite 表 `local_weekly_reviews`
- Firestore 路径 `users/{uid}/weeklyReviews/{weekId}`
- 字段：id、weekId、weekStartDate、weekEndDate、happyMoment1~3（含 tags）、gratitude、learning、catWeeklySummary、createdAt、updatedAt

### 2.4 `Worry` 模型（`lib/models/worry.dart`）

- 烦恼记录，SQLite 表 `local_worries`
- Firestore 路径 `users/{uid}/worries/{worryId}`
- 三态：ongoing / resolved / disappeared

---

## 3. WeeklyReview 扩展

### 3.1 新增字段

在 `WeeklyReview` 模型中新增 2 个可选 TEXT 字段：

```dart
class WeeklyReview {
  // ... 现有字段 ...

  final String? freeNote;       // 自由笔记（用户随手写的周记）
  final String? worrySummary;   // 本周烦恼摘要（从 Worry 列表自动生成或手动填写）

  // 构造函数新增参数
  const WeeklyReview({
    // ... 现有参数 ...
    this.freeNote,
    this.worrySummary,
  });
}
```

### 3.2 SQLite 序列化更新

`toSqlite` 新增：

```dart
'free_note': freeNote,
'worry_summary': worrySummary,
```

`fromSqlite` 新增：

```dart
freeNote: map['free_note'] as String?,
worrySummary: map['worry_summary'] as String?,
```

### 3.3 Firestore 序列化更新

`toFirestore` 新增：

```dart
'freeNote': freeNote,
'worrySummary': worrySummary,
```

`fromFirestore` 新增：

```dart
freeNote: data['freeNote'] as String?,
worrySummary: data['worrySummary'] as String?,
```

### 3.4 copyWith 更新

```dart
WeeklyReview copyWith({
  // ... 现有参数 ...
  String? freeNote,
  bool clearFreeNote = false,
  String? worrySummary,
  bool clearWorrySummary = false,
}) {
  return WeeklyReview(
    // ... 现有赋值 ...
    freeNote: clearFreeNote ? null : (freeNote ?? this.freeNote),
    worrySummary: clearWorrySummary ? null : (worrySummary ?? this.worrySummary),
  );
}
```

### 3.5 SQLite 表变更

```sql
ALTER TABLE local_weekly_reviews ADD COLUMN free_note TEXT;
ALTER TABLE local_weekly_reviews ADD COLUMN worry_summary TEXT;
```

---

## 4. 新增 Dart 模型

### 4.1 `YearlyPlan` 模型（`lib/models/yearly_plan.dart`）

```dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/json_helpers.dart';

/// 年度计划 — 用户设定的年度关键词和大方向。
///
/// 对应 SQLite 表 `local_yearly_plans`，
/// Firestore 路径 `users/{uid}/yearlyPlans/{year}`。
///
/// 每用户每年一条记录，year 格式：'YYYY'（如 '2026'）。
class YearlyPlan {
  final String id;
  final String year;          // 'YYYY'
  final String? keyword;      // 年度关键词（如"成长"、"平衡"）
  final String? vision;       // 年度愿景描述
  final List<String> goals;   // 年度目标列表（3-5 条）
  final DateTime createdAt;
  final DateTime updatedAt;

  const YearlyPlan({
    required this.id,
    required this.year,
    this.keyword,
    this.vision,
    this.goals = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasKeyword => keyword != null && keyword!.isNotEmpty;
  bool get hasGoals => goals.isNotEmpty;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'year': year,
      'keyword': keyword,
      'vision': vision,
      'goals': jsonEncode(goals),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory YearlyPlan.fromSqlite(Map<String, dynamic> map) {
    return YearlyPlan(
      id: map['id'] as String,
      year: map['year'] as String,
      keyword: map['keyword'] as String?,
      vision: map['vision'] as String?,
      goals: decodeJsonStringList(map['goals']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'keyword': keyword,
      'vision': vision,
      'goals': goals,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory YearlyPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return YearlyPlan(
      id: doc.id,
      year: doc.id,
      keyword: data['keyword'] as String?,
      vision: data['vision'] as String?,
      goals: (data['goals'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  YearlyPlan copyWith({
    String? id,
    String? year,
    String? keyword,
    bool clearKeyword = false,
    String? vision,
    bool clearVision = false,
    List<String>? goals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return YearlyPlan(
      id: id ?? this.id,
      year: year ?? this.year,
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
      vision: clearVision ? null : (vision ?? this.vision),
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

### 4.2 `MonthlyPlan` 模型（`lib/models/monthly_plan.dart`）

```dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/json_helpers.dart';

/// 月度计划 — 从年度目标拆解的月度行动计划。
///
/// 对应 SQLite 表 `local_monthly_plans`，
/// Firestore 路径 `users/{uid}/monthlyPlans/{monthId}`。
///
/// monthId 格式：'YYYY-MM'（如 '2026-03'）。
class MonthlyPlan {
  final String id;
  final String monthId;       // 'YYYY-MM'
  final String? theme;        // 月度主题（如"健康月"、"学习月"）
  final List<String> tasks;   // 月度任务列表
  final String? reflection;   // 月末反思
  final DateTime createdAt;
  final DateTime updatedAt;

  const MonthlyPlan({
    required this.id,
    required this.monthId,
    this.theme,
    this.tasks = const [],
    this.reflection,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasTheme => theme != null && theme!.isNotEmpty;
  bool get hasTasks => tasks.isNotEmpty;
  bool get hasReflection => reflection != null && reflection!.isNotEmpty;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'month_id': monthId,
      'theme': theme,
      'tasks': jsonEncode(tasks),
      'reflection': reflection,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory MonthlyPlan.fromSqlite(Map<String, dynamic> map) {
    return MonthlyPlan(
      id: map['id'] as String,
      monthId: map['month_id'] as String,
      theme: map['theme'] as String?,
      tasks: decodeJsonStringList(map['tasks']),
      reflection: map['reflection'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'theme': theme,
      'tasks': tasks,
      'reflection': reflection,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory MonthlyPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MonthlyPlan(
      id: doc.id,
      monthId: doc.id,
      theme: data['theme'] as String?,
      tasks: (data['tasks'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      reflection: data['reflection'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  MonthlyPlan copyWith({
    String? id,
    String? monthId,
    String? theme,
    bool clearTheme = false,
    List<String>? tasks,
    String? reflection,
    bool clearReflection = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MonthlyPlan(
      id: id ?? this.id,
      monthId: monthId ?? this.monthId,
      theme: clearTheme ? null : (theme ?? this.theme),
      tasks: tasks ?? this.tasks,
      reflection: clearReflection ? null : (reflection ?? this.reflection),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

### 4.3 `WeeklyPlan` 模型（`lib/models/weekly_plan.dart`）

```dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/json_helpers.dart';

/// 周计划 — 从月度任务拆解的每周行动项。
///
/// 对应 SQLite 表 `local_weekly_plans`，
/// Firestore 路径 `users/{uid}/weeklyPlans/{weekId}`。
///
/// weekId 格式：'YYYY-WNN'（如 '2026-W12'），与 WeeklyReview 使用相同周标识。
class WeeklyPlan {
  final String id;
  final String weekId;        // 'YYYY-WNN' ISO 格式
  final String weekStartDate; // 周一 'YYYY-MM-DD'
  final String weekEndDate;   // 周日 'YYYY-MM-DD'
  final List<String> tasks;   // 本周任务列表
  final String? focus;        // 本周聚焦重点（一句话）
  final DateTime createdAt;
  final DateTime updatedAt;

  const WeeklyPlan({
    required this.id,
    required this.weekId,
    required this.weekStartDate,
    required this.weekEndDate,
    this.tasks = const [],
    this.focus,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasTasks => tasks.isNotEmpty;
  bool get hasFocus => focus != null && focus!.isNotEmpty;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'week_id': weekId,
      'week_start_date': weekStartDate,
      'week_end_date': weekEndDate,
      'tasks': jsonEncode(tasks),
      'focus': focus,
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
      tasks: decodeJsonStringList(map['tasks']),
      focus: map['focus'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'weekStartDate': weekStartDate,
      'weekEndDate': weekEndDate,
      'tasks': tasks,
      'focus': focus,
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
      tasks: (data['tasks'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      focus: data['focus'] as String?,
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
    List<String>? tasks,
    String? focus,
    bool clearFocus = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeeklyPlan(
      id: id ?? this.id,
      weekId: weekId ?? this.weekId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      tasks: tasks ?? this.tasks,
      focus: clearFocus ? null : (focus ?? this.focus),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

### 4.4 `UserList` 模型（`lib/models/user_list.dart`）

```dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/json_helpers.dart';

/// 用户列表类型枚举。
enum ListType {
  gratitude('gratitude'),   // 感恩清单
  wish('wish'),             // 心愿清单
  bucket('bucket'),         // 人生清单
  custom('custom');         // 自定义清单

  const ListType(this.value);
  final String value;

  static ListType fromValue(String value) {
    return ListType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown ListType: $value'),
    );
  }
}

/// 用户自定义列表 — 感恩清单、心愿清单、人生清单等。
///
/// 对应 SQLite 表 `local_user_lists`，
/// Firestore 路径 `users/{uid}/userLists/{listId}`。
///
/// 每个列表包含一个标题和多个条目（items）。
/// items 以 JSON 数组存储在 SQLite 中。
class UserList {
  final String id;
  final ListType listType;
  final String title;         // 列表标题（如"2026 心愿清单"）
  final List<String> items;   // 列表条目
  final int sortOrder;        // 排序权重（越小越靠前）
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserList({
    required this.id,
    required this.listType,
    required this.title,
    this.items = const [],
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasItems => items.isNotEmpty;
  int get itemCount => items.length;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'list_type': listType.value,
      'title': title,
      'items': jsonEncode(items),
      'sort_order': sortOrder,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserList.fromSqlite(Map<String, dynamic> map) {
    return UserList(
      id: map['id'] as String,
      listType: ListType.fromValue(map['list_type'] as String),
      title: map['title'] as String,
      items: decodeJsonStringList(map['items']),
      sortOrder: map['sort_order'] as int? ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'listType': listType.value,
      'title': title,
      'items': items,
      'sortOrder': sortOrder,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserList(
      id: doc.id,
      listType: ListType.fromValue(data['listType'] as String? ?? 'custom'),
      title: data['title'] as String? ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [],
      sortOrder: data['sortOrder'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  UserList copyWith({
    String? id,
    ListType? listType,
    String? title,
    List<String>? items,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserList(
      id: id ?? this.id,
      listType: listType ?? this.listType,
      title: title ?? this.title,
      items: items ?? this.items,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

### 4.5 `HighlightEntry` 模型（`lib/models/highlight_entry.dart`）

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// 高光时刻记录 — 用户主动标记的值得纪念的瞬间。
///
/// 对应 SQLite 表 `local_highlights`，
/// Firestore 路径 `users/{uid}/highlights/{highlightId}`。
///
/// 与 DailyLight 的区别：DailyLight 是每日记录（一天一条），
/// HighlightEntry 是事件驱动的（随时记录，不限数量）。
class HighlightEntry {
  final String id;
  final String date;          // 发生日期 'YYYY-MM-DD'
  final String title;         // 高光标题（一句话描述）
  final String? description;  // 详细描述（可选）
  final String? category;     // 分类标签（如"成就"、"感动"、"突破"）
  final DateTime createdAt;
  final DateTime updatedAt;

  const HighlightEntry({
    required this.id,
    required this.date,
    required this.title,
    this.description,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─── 计算属性 ───

  bool get hasDescription => description != null && description!.isNotEmpty;
  bool get hasCategory => category != null && category!.isNotEmpty;

  // ─── SQLite 序列化 ───

  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'date': date,
      'title': title,
      'description': description,
      'category': category,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory HighlightEntry.fromSqlite(Map<String, dynamic> map) {
    return HighlightEntry(
      id: map['id'] as String,
      date: map['date'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  // ─── Firestore 序列化 ───

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'title': title,
      'description': description,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory HighlightEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HighlightEntry(
      id: doc.id,
      date: data['date'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      category: data['category'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ─── copyWith ───

  HighlightEntry copyWith({
    String? id,
    String? date,
    String? title,
    String? description,
    bool clearDescription = false,
    String? category,
    bool clearCategory = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HighlightEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      category: clearCategory ? null : (category ?? this.category),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

## 5. SQLite Schema（全部表）

> **无迁移策略**：所有用户都是新用户，Schema 版本直接升至 v5。无需 v4→v5 升级路径。
> 仅 WeeklyReview 表需要 ALTER TABLE（因为 v4 已建表，需要加列）。

### 5.1 已有表（v4 已创建，保留不变）

#### `local_daily_lights`

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
);
CREATE INDEX idx_daily_lights_uid_date ON local_daily_lights(uid, date);
```

#### `local_weekly_reviews`（v5 新增 2 列）

```sql
-- v4 原始表结构
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
);
CREATE INDEX idx_weekly_reviews_uid_week ON local_weekly_reviews(uid, week_id);

-- v5 新增列
ALTER TABLE local_weekly_reviews ADD COLUMN free_note TEXT;
ALTER TABLE local_weekly_reviews ADD COLUMN worry_summary TEXT;
```

#### `local_worries`

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
);
CREATE INDEX idx_worries_uid_status ON local_worries(uid, status);
```

#### `local_awareness_stats`

```sql
CREATE TABLE local_awareness_stats (
  uid TEXT PRIMARY KEY,
  total_light_days INTEGER NOT NULL DEFAULT 0,
  total_weekly_reviews INTEGER NOT NULL DEFAULT 0,
  total_worries_resolved INTEGER NOT NULL DEFAULT 0,
  last_light_date TEXT,
  updated_at INTEGER NOT NULL
);
```

### 5.2 新增表（v5）

#### `local_yearly_plans`

```sql
CREATE TABLE local_yearly_plans (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  year TEXT NOT NULL,
  keyword TEXT,
  vision TEXT,
  goals TEXT NOT NULL DEFAULT '[]',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(uid, year)
);
CREATE INDEX idx_yearly_plans_uid_year ON local_yearly_plans(uid, year);
```

#### `local_monthly_plans`

```sql
CREATE TABLE local_monthly_plans (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  month_id TEXT NOT NULL,
  theme TEXT,
  tasks TEXT NOT NULL DEFAULT '[]',
  reflection TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(uid, month_id)
);
CREATE INDEX idx_monthly_plans_uid_month ON local_monthly_plans(uid, month_id);
```

#### `local_weekly_plans`

```sql
CREATE TABLE local_weekly_plans (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  week_id TEXT NOT NULL,
  week_start_date TEXT NOT NULL,
  week_end_date TEXT NOT NULL,
  tasks TEXT NOT NULL DEFAULT '[]',
  focus TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(uid, week_id)
);
CREATE INDEX idx_weekly_plans_uid_week ON local_weekly_plans(uid, week_id);
```

#### `local_user_lists`

```sql
CREATE TABLE local_user_lists (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  list_type TEXT NOT NULL DEFAULT 'custom',
  title TEXT NOT NULL,
  items TEXT NOT NULL DEFAULT '[]',
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX idx_user_lists_uid_type ON local_user_lists(uid, list_type);
```

#### `local_highlights`

```sql
CREATE TABLE local_highlights (
  id TEXT PRIMARY KEY,
  uid TEXT NOT NULL,
  date TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
CREATE INDEX idx_highlights_uid_date ON local_highlights(uid, date);
```

### 5.3 数据库版本升级

在 `LocalDatabaseService` 中：

```dart
// _dbVersion 从 4 改为 5
static const _dbVersion = 5;
```

新增 `_createV5Tables` 方法：

```dart
/// v5 表：LUMI Pivot — 计划系统 + 列表 + 高光 + WeeklyReview 扩展。
Future<void> _createV5Tables(Database db) async {
  // WeeklyReview 新增列
  await db.execute('ALTER TABLE local_weekly_reviews ADD COLUMN free_note TEXT');
  await db.execute('ALTER TABLE local_weekly_reviews ADD COLUMN worry_summary TEXT');

  // 年度计划
  await db.execute('''
    CREATE TABLE local_yearly_plans (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      year TEXT NOT NULL,
      keyword TEXT,
      vision TEXT,
      goals TEXT NOT NULL DEFAULT '[]',
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(uid, year)
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_yearly_plans_uid_year ON local_yearly_plans(uid, year)',
  );

  // 月度计划
  await db.execute('''
    CREATE TABLE local_monthly_plans (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      month_id TEXT NOT NULL,
      theme TEXT,
      tasks TEXT NOT NULL DEFAULT '[]',
      reflection TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(uid, month_id)
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_monthly_plans_uid_month ON local_monthly_plans(uid, month_id)',
  );

  // 周计划
  await db.execute('''
    CREATE TABLE local_weekly_plans (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      week_id TEXT NOT NULL,
      week_start_date TEXT NOT NULL,
      week_end_date TEXT NOT NULL,
      tasks TEXT NOT NULL DEFAULT '[]',
      focus TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      UNIQUE(uid, week_id)
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_weekly_plans_uid_week ON local_weekly_plans(uid, week_id)',
  );

  // 用户列表
  await db.execute('''
    CREATE TABLE local_user_lists (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      list_type TEXT NOT NULL DEFAULT 'custom',
      title TEXT NOT NULL,
      items TEXT NOT NULL DEFAULT '[]',
      sort_order INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_user_lists_uid_type ON local_user_lists(uid, list_type)',
  );

  // 高光时刻
  await db.execute('''
    CREATE TABLE local_highlights (
      id TEXT PRIMARY KEY,
      uid TEXT NOT NULL,
      date TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      category TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  await db.execute(
    'CREATE INDEX idx_highlights_uid_date ON local_highlights(uid, date)',
  );
}
```

修改 `_onCreate`：

```dart
Future<void> _onCreate(Database db, int version) async {
  await _createV1Tables(db);
  if (version >= 2) await _createV2Tables(db);
  if (version >= 3) await _createV3Columns(db);
  if (version >= 4) await _createV4Tables(db);
  if (version >= 5) await _createV5Tables(db);
}
```

修改 `_onUpgrade`：

```dart
Future<void> _onUpgrade(Database db, int oldV, int newV) async {
  if (oldV < 2) await _createV2Tables(db);
  if (oldV < 3) await _createV3Columns(db);
  if (oldV < 4) await _createV4Tables(db);
  if (oldV < 5) await _createV5Tables(db);
}
```

---

## 6. Firestore 集合结构

```
users/{uid}/
  ├── dailyLights/{date}           ← 已有（DailyLight）
  ├── weeklyReviews/{weekId}       ← 已有（WeeklyReview，新增 freeNote/worrySummary 字段）
  ├── worries/{worryId}            ← 已有（Worry）
  ├── yearlyPlans/{year}           ← 新增（YearlyPlan）
  ├── monthlyPlans/{monthId}       ← 新增（MonthlyPlan）
  ├── weeklyPlans/{weekId}         ← 新增（WeeklyPlan）
  ├── userLists/{listId}           ← 新增（UserList）
  └── highlights/{highlightId}     ← 新增（HighlightEntry）
```

**文档 ID 策略**：

| 集合 | 文档 ID | 唯一性保证 |
|------|---------|-----------|
| yearlyPlans | `year`（如 `2026`） | 每用户每年一条 |
| monthlyPlans | `monthId`（如 `2026-03`） | 每用户每月一条 |
| weeklyPlans | `weekId`（如 `2026-W12`） | 每用户每周一条 |
| userLists | UUID | 多列表允许 |
| highlights | UUID | 多条目允许 |

---

## 7. 新增 ActionType 枚举值

在 `lib/models/ledger_action.dart` 的 `ActionType` 枚举中新增 5 个值：

```dart
enum ActionType {
  // ... 现有 V3 觉知模块值 ...
  monthlyRitualSet('monthly_ritual_set'),

  // LUMI Pivot — 计划系统 + 列表 + 高光
  yearlyPlanSaved('yearly_plan_saved'),
  monthlyPlanSaved('monthly_plan_saved'),
  weeklyPlanSaved('weekly_plan_saved'),
  listUpdated('list_updated'),
  highlightRecorded('highlight_recorded'),

  // 仅通知用途 ...
  hydrate('hydrate'),
  // ...
}
```

**插入位置**：在 `monthlyRitualSet` 之后、`hydrate`（仅通知用途分隔线）之前。

同时新增分组 getter：

```dart
/// 是否为计划相关操作。
bool get isPlanAction =>
    this == yearlyPlanSaved ||
    this == monthlyPlanSaved ||
    this == weeklyPlanSaved;
```

---

## 8. Repository 层

### 8.1 `PlanRepository`（`lib/services/plan_repository.dart`）

遵循现有 `AwarenessRepository` 模式：所有写操作在 SQLite 事务中同时更新领域表和行为台账。

```dart
import 'package:sqflite/sqflite.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 计划仓库 — YearlyPlan + MonthlyPlan + WeeklyPlan CRUD + 台账写入。
class PlanRepository {
  final LedgerService _ledger;

  PlanRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── YearlyPlan ───

  Future<YearlyPlan?> getYearlyPlan(String uid, String year) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_yearly_plans',
      where: 'uid = ? AND year = ?',
      whereArgs: [uid, year],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return YearlyPlan.fromSqlite(rows.first);
  }

  Future<void> saveYearlyPlan(String uid, YearlyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_yearly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.yearlyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'year': plan.year, 'hasKeyword': plan.hasKeyword},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.yearlyPlanSaved, affectedIds: [plan.id]),
    );
  }

  // ─── MonthlyPlan ───

  Future<MonthlyPlan?> getMonthlyPlan(String uid, String monthId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_monthly_plans',
      where: 'uid = ? AND month_id = ?',
      whereArgs: [uid, monthId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return MonthlyPlan.fromSqlite(rows.first);
  }

  Future<List<MonthlyPlan>> getMonthlyPlansForYear(
    String uid,
    String year,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_monthly_plans',
      where: 'uid = ? AND month_id LIKE ?',
      whereArgs: [uid, '$year%'],
      orderBy: 'month_id ASC',
    );
    return rows.map(MonthlyPlan.fromSqlite).toList();
  }

  Future<void> saveMonthlyPlan(String uid, MonthlyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_monthly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.monthlyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'monthId': plan.monthId, 'taskCount': plan.tasks.length},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.monthlyPlanSaved, affectedIds: [plan.id]),
    );
  }

  // ─── WeeklyPlan ───

  Future<WeeklyPlan?> getWeeklyPlan(String uid, String weekId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_weekly_plans',
      where: 'uid = ? AND week_id = ?',
      whereArgs: [uid, weekId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return WeeklyPlan.fromSqlite(rows.first);
  }

  Future<void> saveWeeklyPlan(String uid, WeeklyPlan plan) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    await db.transaction((txn) async {
      await txn.insert(
        'local_weekly_plans',
        plan.toSqlite(uid),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.weeklyPlanSaved,
        uid: uid,
        startedAt: now,
        payload: {'weekId': plan.weekId, 'taskCount': plan.tasks.length},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.weeklyPlanSaved, affectedIds: [plan.id]),
    );
  }
}
```

---

### 8.2 `ListHighlightRepository`（`lib/services/list_highlight_repository.dart`）

```dart
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/services/ledger_service.dart';

const _uuid = Uuid();

/// 列表 + 高光仓库 — UserList + HighlightEntry CRUD + 台账写入。
class ListHighlightRepository {
  final LedgerService _ledger;

  ListHighlightRepository({required LedgerService ledger}) : _ledger = ledger;

  // ─── UserList 查询 ───

  /// 获取用户的所有列表（按 sort_order + created_at 排序）。
  Future<List<UserList>> getAllLists(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_user_lists',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'sort_order ASC, created_at ASC',
    );
    return rows.map(UserList.fromSqlite).toList();
  }

  /// 按类型获取列表。
  Future<List<UserList>> getListsByType(String uid, ListType type) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_user_lists',
      where: 'uid = ? AND list_type = ?',
      whereArgs: [uid, type.value],
      orderBy: 'sort_order ASC, created_at ASC',
    );
    return rows.map(UserList.fromSqlite).toList();
  }

  /// 按 ID 获取列表。
  Future<UserList?> getList(String listId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_user_lists',
      where: 'id = ?',
      whereArgs: [listId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserList.fromSqlite(rows.first);
  }

  // ─── UserList 写入 ───

  /// 创建新列表。
  Future<UserList> createList(
    String uid, {
    required ListType listType,
    required String title,
    List<String> items = const [],
  }) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final list = UserList(
      id: _uuid.v4(),
      listType: listType,
      title: title,
      items: items,
      createdAt: now,
      updatedAt: now,
    );
    await db.transaction((txn) async {
      await txn.insert('local_user_lists', list.toSqlite(uid));
      await _ledger.appendInTxn(
        txn,
        type: ActionType.listUpdated,
        uid: uid,
        startedAt: now,
        payload: {'listId': list.id, 'action': 'created', 'listType': listType.value},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.listUpdated, affectedIds: [list.id]),
    );
    return list;
  }

  /// 更新列表。
  Future<void> updateList(String uid, UserList list) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final updated = list.copyWith(updatedAt: now);
    await db.transaction((txn) async {
      await txn.update(
        'local_user_lists',
        updated.toSqlite(uid),
        where: 'id = ?',
        whereArgs: [updated.id],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.listUpdated,
        uid: uid,
        startedAt: now,
        payload: {'listId': updated.id, 'action': 'updated', 'itemCount': updated.items.length},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.listUpdated, affectedIds: [updated.id]),
    );
  }

  /// 删除列表。
  Future<void> deleteList(String uid, String listId) async {
    final db = await _ledger.database;
    await db.delete(
      'local_user_lists',
      where: 'id = ? AND uid = ?',
      whereArgs: [listId, uid],
    );
    _ledger.notifyChange(
      LedgerChange(type: ActionType.listUpdated, affectedIds: [listId]),
    );
  }

  // ─── HighlightEntry 查询 ───

  /// 获取所有高光时刻（按日期倒序）。
  Future<List<HighlightEntry>> getAllHighlights(String uid) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_highlights',
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'date DESC, created_at DESC',
    );
    return rows.map(HighlightEntry.fromSqlite).toList();
  }

  /// 按日期范围获取高光时刻。
  Future<List<HighlightEntry>> getHighlightsInRange(
    String uid,
    String startDate,
    String endDate,
  ) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_highlights',
      where: 'uid = ? AND date >= ? AND date <= ?',
      whereArgs: [uid, startDate, endDate],
      orderBy: 'date DESC, created_at DESC',
    );
    return rows.map(HighlightEntry.fromSqlite).toList();
  }

  /// 按 ID 获取高光时刻。
  Future<HighlightEntry?> getHighlight(String highlightId) async {
    final db = await _ledger.database;
    final rows = await db.query(
      'local_highlights',
      where: 'id = ?',
      whereArgs: [highlightId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return HighlightEntry.fromSqlite(rows.first);
  }

  // ─── HighlightEntry 写入 ───

  /// 创建高光时刻。
  Future<HighlightEntry> createHighlight(
    String uid, {
    required String date,
    required String title,
    String? description,
    String? category,
  }) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final entry = HighlightEntry(
      id: _uuid.v4(),
      date: date,
      title: title,
      description: description,
      category: category,
      createdAt: now,
      updatedAt: now,
    );
    await db.transaction((txn) async {
      await txn.insert('local_highlights', entry.toSqlite(uid));
      await _ledger.appendInTxn(
        txn,
        type: ActionType.highlightRecorded,
        uid: uid,
        startedAt: now,
        payload: {'highlightId': entry.id, 'date': date, 'hasCategory': entry.hasCategory},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.highlightRecorded, affectedIds: [entry.id]),
    );
    return entry;
  }

  /// 更新高光时刻。
  Future<void> updateHighlight(String uid, HighlightEntry entry) async {
    final db = await _ledger.database;
    final now = DateTime.now();
    final updated = entry.copyWith(updatedAt: now);
    await db.transaction((txn) async {
      await txn.update(
        'local_highlights',
        updated.toSqlite(uid),
        where: 'id = ?',
        whereArgs: [updated.id],
      );
      await _ledger.appendInTxn(
        txn,
        type: ActionType.highlightRecorded,
        uid: uid,
        startedAt: now,
        payload: {'highlightId': updated.id, 'action': 'updated'},
      );
    });
    _ledger.notifyChange(
      LedgerChange(type: ActionType.highlightRecorded, affectedIds: [updated.id]),
    );
  }

  /// 删除高光时刻。
  Future<void> deleteHighlight(String uid, String highlightId) async {
    final db = await _ledger.database;
    await db.delete(
      'local_highlights',
      where: 'id = ? AND uid = ?',
      whereArgs: [highlightId, uid],
    );
    _ledger.notifyChange(
      LedgerChange(type: ActionType.highlightRecorded, affectedIds: [highlightId]),
    );
  }
}
```

---

## 9. Riverpod Provider 定义

### 文件：`lib/providers/plan_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/yearly_plan.dart';
import 'package:hachimi_app/models/monthly_plan.dart';
import 'package:hachimi_app/models/weekly_plan.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 年度计划 ───

/// 当前年度计划。
final currentYearlyPlanProvider = StreamProvider<YearlyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final repo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  final year = DateTime.now().year.toString();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.yearlyPlanSaved,
    read: () => repo.getYearlyPlan(uid, year),
  );
});

// ─── 月度计划 ───

/// 当前月度计划。
final currentMonthlyPlanProvider = StreamProvider<MonthlyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final repo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  final monthId = AppDateUtils.currentMonthId();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.monthlyPlanSaved,
    read: () => repo.getMonthlyPlan(uid, monthId),
  );
});

/// 指定年份的所有月度计划。
final monthlyPlansForYearProvider =
    FutureProvider.family<List<MonthlyPlan>, String>((ref, year) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final repo = ref.watch(planRepositoryProvider);
  ref.listen(ledgerChangesProvider, (_, _) {});

  return repo.getMonthlyPlansForYear(uid, year);
});

// ─── 周计划 ───

/// 当前周计划。
final currentWeeklyPlanProvider = StreamProvider<WeeklyPlan?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);

  final repo = ref.watch(planRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);
  final weekId = AppDateUtils.currentWeekId();

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.weeklyPlanSaved,
    read: () => repo.getWeeklyPlan(uid, weekId),
  );
});
```

### 文件：`lib/providers/list_highlight_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';

// ─── 用户列表 ───

/// 所有用户列表。
final allUserListsProvider = StreamProvider<List<UserList>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<UserList>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.listUpdated,
    read: () => repo.getAllLists(uid),
  );
});

/// 按类型获取列表 — family provider。
final userListsByTypeProvider =
    StreamProvider.family<List<UserList>, ListType>((ref, type) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<UserList>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.listUpdated,
    read: () => repo.getListsByType(uid, type),
  );
});

// ─── 高光时刻 ───

/// 所有高光时刻（按日期倒序）。
final allHighlightsProvider = StreamProvider<List<HighlightEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<HighlightEntry>[]);

  final repo = ref.watch(listHighlightRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh || c.type == ActionType.highlightRecorded,
    read: () => repo.getAllHighlights(uid),
  );
});

/// 日期范围内的高光时刻 — family provider（参数：(startDate, endDate)）。
final highlightsInRangeProvider =
    FutureProvider.family<List<HighlightEntry>, (String, String)>((
  ref,
  params,
) async {
  final (startDate, endDate) = params;
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];

  final repo = ref.watch(listHighlightRepositoryProvider);
  ref.listen(ledgerChangesProvider, (_, _) {});

  return repo.getHighlightsInRange(uid, startDate, endDate);
});
```

### 在 `lib/providers/service_providers.dart` 中新增

```dart
import 'package:hachimi_app/services/plan_repository.dart';
import 'package:hachimi_app/services/list_highlight_repository.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(ledger: ref.watch(ledgerServiceProvider));
});

final listHighlightRepositoryProvider = Provider<ListHighlightRepository>((ref) {
  return ListHighlightRepository(ledger: ref.watch(ledgerServiceProvider));
});
```

---

## 10. SyncEngine 更新

### 10.1 `_syncAction` switch 新增 case

```dart
case ActionType.yearlyPlanSaved:
  await _syncYearlyPlan(batch, uid, action);
case ActionType.monthlyPlanSaved:
  await _syncMonthlyPlan(batch, uid, action);
case ActionType.weeklyPlanSaved:
  await _syncWeeklyPlan(batch, uid, action);
case ActionType.listUpdated:
  await _syncUserList(batch, uid, action);
case ActionType.highlightRecorded:
  await _syncHighlight(batch, uid, action);
```

### 10.2 新增同步方法

```dart
Future<void> _syncYearlyPlan(WriteBatch batch, String uid, LedgerAction action) async {
  final year = action.payload['year'] as String?;
  if (year == null) return;
  final db = await _ledger.database;
  final rows = await db.query(
    'local_yearly_plans',
    where: 'uid = ? AND year = ?',
    whereArgs: [uid, year],
    limit: 1,
  );
  if (rows.isEmpty) return;
  final plan = YearlyPlan.fromSqlite(rows.first);
  final ref = _db.collection('users').doc(uid).collection('yearlyPlans').doc(year);
  batch.set(ref, plan.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncMonthlyPlan(WriteBatch batch, String uid, LedgerAction action) async {
  final monthId = action.payload['monthId'] as String?;
  if (monthId == null) return;
  final db = await _ledger.database;
  final rows = await db.query(
    'local_monthly_plans',
    where: 'uid = ? AND month_id = ?',
    whereArgs: [uid, monthId],
    limit: 1,
  );
  if (rows.isEmpty) return;
  final plan = MonthlyPlan.fromSqlite(rows.first);
  final ref = _db.collection('users').doc(uid).collection('monthlyPlans').doc(monthId);
  batch.set(ref, plan.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncWeeklyPlan(WriteBatch batch, String uid, LedgerAction action) async {
  final weekId = action.payload['weekId'] as String?;
  if (weekId == null) return;
  final db = await _ledger.database;
  final rows = await db.query(
    'local_weekly_plans',
    where: 'uid = ? AND week_id = ?',
    whereArgs: [uid, weekId],
    limit: 1,
  );
  if (rows.isEmpty) return;
  final plan = WeeklyPlan.fromSqlite(rows.first);
  final ref = _db.collection('users').doc(uid).collection('weeklyPlans').doc(weekId);
  batch.set(ref, plan.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncUserList(WriteBatch batch, String uid, LedgerAction action) async {
  final listId = action.payload['listId'] as String?;
  if (listId == null) return;
  final db = await _ledger.database;
  final rows = await db.query(
    'local_user_lists',
    where: 'id = ?',
    whereArgs: [listId],
    limit: 1,
  );
  if (rows.isEmpty) return;
  final list = UserList.fromSqlite(rows.first);
  final ref = _db.collection('users').doc(uid).collection('userLists').doc(listId);
  batch.set(ref, list.toFirestore(), SetOptions(merge: true));
}

Future<void> _syncHighlight(WriteBatch batch, String uid, LedgerAction action) async {
  final highlightId = action.payload['highlightId'] as String?;
  if (highlightId == null) return;
  final db = await _ledger.database;
  final rows = await db.query(
    'local_highlights',
    where: 'id = ?',
    whereArgs: [highlightId],
    limit: 1,
  );
  if (rows.isEmpty) return;
  final entry = HighlightEntry.fromSqlite(rows.first);
  final ref = _db.collection('users').doc(uid).collection('highlights').doc(highlightId);
  batch.set(ref, entry.toFirestore(), SetOptions(merge: true));
}
```

### 10.3 水化更新

在 `_doHydrate` 方法中新增 5 个集合水化：

```dart
await _hydrateCollection<YearlyPlan>(
  userRef.collection('yearlyPlans'),
  'local_yearly_plans',
  db,
  (doc) => YearlyPlan.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<MonthlyPlan>(
  userRef.collection('monthlyPlans'),
  'local_monthly_plans',
  db,
  (doc) => MonthlyPlan.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<WeeklyPlan>(
  userRef.collection('weeklyPlans'),
  'local_weekly_plans',
  db,
  (doc) => WeeklyPlan.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<UserList>(
  userRef.collection('userLists'),
  'local_user_lists',
  db,
  (doc) => UserList.fromFirestore(doc).toSqlite(uid),
);
await _hydrateCollection<HighlightEntry>(
  userRef.collection('highlights'),
  'local_highlights',
  db,
  (doc) => HighlightEntry.fromFirestore(doc).toSqlite(uid),
);
```

---

## 11. LedgerService 更新

### 11.1 `migrateUid()` 更新

```dart
// 单列 PK 表新增：
'local_user_lists',
'local_highlights',

// 复合 PK / UNIQUE 约束表新增：
'local_yearly_plans',  // UNIQUE(uid, year)
'local_monthly_plans', // UNIQUE(uid, month_id)
'local_weekly_plans',  // UNIQUE(uid, week_id)
```

### 11.2 `deleteUidData()` 更新

新增 5 张表到删除列表：

```dart
'local_yearly_plans',
'local_monthly_plans',
'local_weekly_plans',
'local_user_lists',
'local_highlights',
```

---

## 12. Firestore 规则更新

在 `match /users/{userId}` 块内新增：

```javascript
// Yearly plans
match /yearlyPlans/{year} {
  allow read, write: if isOwner(userId);
}

// Monthly plans
match /monthlyPlans/{monthId} {
  allow read, write: if isOwner(userId);
}

// Weekly plans
match /weeklyPlans/{weekId} {
  allow read, write: if isOwner(userId);
}

// User lists
match /userLists/{listId} {
  allow read, write: if isOwner(userId);
}

// Highlight entries
match /highlights/{highlightId} {
  allow read, write: if isOwner(userId);
}
```

---

## 13. `AppDateUtils` 新增方法

在 `lib/core/utils/date_utils.dart` 中确保存在以下方法（部分可能已实现）：

```dart
/// 获取当前月份 ID（'YYYY-MM' 格式）。
static String currentMonthId() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}
```

> 注：`currentWeekId()` 和 `isoWeekId()` 在 V3 Track 1 中已实现。

---

## 14. 单元测试

### 14.1 `test/models/yearly_plan_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/yearly_plan.dart';

void main() {
  final now = DateTime(2026, 3, 19, 22, 0);
  final sample = YearlyPlan(
    id: 'test-id',
    year: '2026',
    keyword: '成长',
    vision: '成为更好的自己',
    goals: ['坚持运动', '读 12 本书', '学一门新技能'],
    createdAt: now,
    updatedAt: now,
  );

  group('YearlyPlan', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      expect(map['uid'], 'uid-123');
      expect(map['year'], '2026');

      final restored = YearlyPlan.fromSqlite(map);
      expect(restored.id, sample.id);
      expect(restored.year, sample.year);
      expect(restored.keyword, sample.keyword);
      expect(restored.goals, sample.goals);
    });

    test('计算属性 hasKeyword / hasGoals', () {
      expect(sample.hasKeyword, true);
      expect(sample.hasGoals, true);

      final empty = sample.copyWith(clearKeyword: true, goals: []);
      expect(empty.hasKeyword, false);
      expect(empty.hasGoals, false);
    });

    test('goals 空列表在 SQLite 中存为 []', () {
      final noGoals = sample.copyWith(goals: []);
      final map = noGoals.toSqlite('uid');
      expect(map['goals'], '[]');
    });
  });
}
```

### 14.2 `test/models/monthly_plan_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/monthly_plan.dart';

void main() {
  final now = DateTime(2026, 3, 19, 22, 0);
  final sample = MonthlyPlan(
    id: 'test-id',
    monthId: '2026-03',
    theme: '健康月',
    tasks: ['每周运动 3 次', '每天睡前冥想'],
    createdAt: now,
    updatedAt: now,
  );

  group('MonthlyPlan', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      final restored = MonthlyPlan.fromSqlite(map);
      expect(restored.monthId, sample.monthId);
      expect(restored.theme, sample.theme);
      expect(restored.tasks, sample.tasks);
    });

    test('计算属性 hasTheme / hasTasks / hasReflection', () {
      expect(sample.hasTheme, true);
      expect(sample.hasTasks, true);
      expect(sample.hasReflection, false);

      final withReflection = sample.copyWith(reflection: '本月收获很大');
      expect(withReflection.hasReflection, true);
    });
  });
}
```

### 14.3 `test/models/weekly_plan_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/weekly_plan.dart';

void main() {
  final now = DateTime(2026, 3, 19, 22, 0);
  final sample = WeeklyPlan(
    id: 'test-id',
    weekId: '2026-W12',
    weekStartDate: '2026-03-16',
    weekEndDate: '2026-03-22',
    tasks: ['完成设计稿', '写单元测试'],
    focus: '专注数据层重构',
    createdAt: now,
    updatedAt: now,
  );

  group('WeeklyPlan', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      final restored = WeeklyPlan.fromSqlite(map);
      expect(restored.weekId, sample.weekId);
      expect(restored.weekStartDate, sample.weekStartDate);
      expect(restored.tasks, sample.tasks);
      expect(restored.focus, sample.focus);
    });

    test('计算属性 hasTasks / hasFocus', () {
      expect(sample.hasTasks, true);
      expect(sample.hasFocus, true);

      final empty = WeeklyPlan(
        id: 'test',
        weekId: '2026-W12',
        weekStartDate: '2026-03-16',
        weekEndDate: '2026-03-22',
        createdAt: now,
        updatedAt: now,
      );
      expect(empty.hasTasks, false);
      expect(empty.hasFocus, false);
    });
  });
}
```

### 14.4 `test/models/user_list_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/user_list.dart';

void main() {
  final now = DateTime(2026, 3, 19, 22, 0);
  final sample = UserList(
    id: 'test-id',
    listType: ListType.gratitude,
    title: '2026 感恩清单',
    items: ['健康的身体', '支持我的朋友'],
    createdAt: now,
    updatedAt: now,
  );

  group('UserList', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      expect(map['list_type'], 'gratitude');

      final restored = UserList.fromSqlite(map);
      expect(restored.id, sample.id);
      expect(restored.listType, ListType.gratitude);
      expect(restored.title, sample.title);
      expect(restored.items, sample.items);
    });

    test('ListType.fromValue 所有值往返一致', () {
      for (final type in ListType.values) {
        expect(ListType.fromValue(type.value), equals(type));
      }
    });

    test('ListType.fromValue 无效值抛出 ArgumentError', () {
      expect(() => ListType.fromValue('invalid'), throwsArgumentError);
    });

    test('计算属性 hasItems / itemCount', () {
      expect(sample.hasItems, true);
      expect(sample.itemCount, 2);

      final empty = sample.copyWith(items: []);
      expect(empty.hasItems, false);
      expect(empty.itemCount, 0);
    });
  });
}
```

### 14.5 `test/models/highlight_entry_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/highlight_entry.dart';

void main() {
  final now = DateTime(2026, 3, 19, 22, 0);
  final sample = HighlightEntry(
    id: 'test-id',
    date: '2026-03-19',
    title: '第一次完成 5 公里跑步',
    description: '在公园跑完了全程，很有成就感',
    category: '成就',
    createdAt: now,
    updatedAt: now,
  );

  group('HighlightEntry', () {
    test('toSqlite / fromSqlite 往返一致', () {
      final map = sample.toSqlite('uid-123');
      expect(map['uid'], 'uid-123');
      expect(map['date'], '2026-03-19');

      final restored = HighlightEntry.fromSqlite(map);
      expect(restored.id, sample.id);
      expect(restored.title, sample.title);
      expect(restored.description, sample.description);
      expect(restored.category, sample.category);
    });

    test('toFirestore 输出正确', () {
      final map = sample.toFirestore();
      expect(map['date'], '2026-03-19');
      expect(map['title'], '第一次完成 5 公里跑步');
      expect(map['description'], isNotNull);
      expect(map['category'], '成就');
    });

    test('计算属性 hasDescription / hasCategory', () {
      expect(sample.hasDescription, true);
      expect(sample.hasCategory, true);

      final minimal = sample.copyWith(
        clearDescription: true,
        clearCategory: true,
      );
      expect(minimal.hasDescription, false);
      expect(minimal.hasCategory, false);
    });
  });
}
```

---

## 15. 文件操作清单

### 需要创建的文件

| 文件路径 | 用途 |
|----------|------|
| `lib/models/yearly_plan.dart` | YearlyPlan 模型 |
| `lib/models/monthly_plan.dart` | MonthlyPlan 模型 |
| `lib/models/weekly_plan.dart` | WeeklyPlan 模型 |
| `lib/models/user_list.dart` | UserList 模型 + ListType 枚举 |
| `lib/models/highlight_entry.dart` | HighlightEntry 模型 |
| `lib/services/plan_repository.dart` | 计划 CRUD |
| `lib/services/list_highlight_repository.dart` | 列表 + 高光 CRUD |
| `lib/providers/plan_providers.dart` | 计划相关 Provider |
| `lib/providers/list_highlight_providers.dart` | 列表 + 高光相关 Provider |
| `test/models/yearly_plan_test.dart` | YearlyPlan 单元测试 |
| `test/models/monthly_plan_test.dart` | MonthlyPlan 单元测试 |
| `test/models/weekly_plan_test.dart` | WeeklyPlan 单元测试 |
| `test/models/user_list_test.dart` | UserList 单元测试 |
| `test/models/highlight_entry_test.dart` | HighlightEntry 单元测试 |

### 需要修改的文件

| 文件路径 | 改动内容 |
|----------|----------|
| `lib/models/weekly_review.dart` | 新增 `freeNote`、`worrySummary` 字段 + 序列化 + copyWith |
| `lib/services/local_database_service.dart` | `_dbVersion` 升至 5；新增 `_createV5Tables`；修改 `_onCreate` 和 `_onUpgrade` |
| `lib/models/ledger_action.dart` | 新增 5 个 `ActionType` + `isPlanAction` getter |
| `lib/services/ledger_service.dart` | `migrateUid()` 新增 5 张表；`deleteUidData()` 新增 5 张表 |
| `lib/services/sync_engine.dart` | `_syncAction` 新增 5 个 case；新增 5 个同步方法；`_doHydrate` 新增 5 个集合水化 |
| `lib/providers/service_providers.dart` | 新增 `planRepositoryProvider` 和 `listHighlightRepositoryProvider` |
| `lib/core/utils/date_utils.dart` | 新增 `currentMonthId()`（如不存在） |
| `firestore.rules` | 新增 5 个子集合匹配规则 |
| `docs/architecture/data-model.md` | 补充 5 张新表 + WeeklyReview 扩展字段 |
| `docs/architecture/state-management.md` | 补充新 Provider 拓扑图 |

---

## 16. 完成标志

| 检查项 | 验证命令 / 方法 |
|--------|----------------|
| 静态分析零 warning | `dart analyze lib/` |
| 新模型单元测试全绿 | `flutter test test/models/` |
| 5 张新表在全新安装时正确创建 | 删除 app 重装后检查 SQLite schema |
| WeeklyReview 新增列在升级时正确添加 | v4 数据库升级到 v5 验证 |
| LedgerService.migrateUid() 包含新表 | 代码审查 |
| LedgerService.deleteUidData() 包含新表 | 代码审查 |
| SyncEngine 5 个新 ActionType 有对应 case | 代码审查确认 switch 完备 |
| 5 个新 Provider 使用 ledgerDrivenStream | 代码审查确认模式一致 |
| Firestore 规则部署成功 | `firebase deploy --only firestore:rules --project hachimi-ai` |
| 架构文档已同步更新 | `data-model.md` 和 `state-management.md` 已更新 |

---

## 依赖关系

### 前置条件

- 无外部前置条件。仅依赖现有基础设施（LedgerService、LocalDatabaseService、SyncEngine）+ V3 Track 1 已实现的 4 个模型

### 后续影响

- Track 2（LUMI 核心 UI）依赖所有 awareness Provider
- Track 3（计划系统 UI）依赖 `currentYearlyPlanProvider`、`currentMonthlyPlanProvider`、`currentWeeklyPlanProvider`、`planRepositoryProvider`
- Track 4（列表 + 高光 UI）依赖 `allUserListsProvider`、`allHighlightsProvider`、`listHighlightRepositoryProvider`
- Track 5（数据洞察 + 猫咪反应）依赖 `awarenessStatsProvider` + 各模型的聚合查询

### 外部依赖

- `sqflite`（已有）
- `uuid`（已有）
- `cloud_firestore`（已有）

无需新增任何依赖包。

---

## 风险与注意事项

| 风险点 | 缓解措施 |
|--------|----------|
| WeeklyReview ALTER TABLE 兼容性 | SQLite ALTER TABLE ADD COLUMN 自 3.2.0 起支持，sqflite 全平台兼容 |
| 水化超时（新增 5 个集合） | 新集合数据量小（计划表每年最多 12+52 条），不会超时 |
| UserList items JSON 解析 | 复用 `json_helpers.dart` 的 `decodeJsonStringList`，畸形数据返回空列表 |
| WeeklyPlan 与 WeeklyReview 的 weekId 一致性 | 共用 `AppDateUtils.currentWeekId()` 和 `isoWeekId()` 方法 |
| 无迁移策略的风险 | 所有用户为新用户，无历史数据，无需迁移。已有 v4 用户通过 `_onUpgrade` 走 v5 升级路径 |
