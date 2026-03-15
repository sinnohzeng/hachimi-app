# 数据模型与存储架构

> SSOT for v2.0 DnD 融合的所有新增数据模型、SQLite Schema 和 Firestore 安全规则。
> **Status:** Draft
> **Evidence:** `lib/models/`、`lib/services/local_database_service.dart`、`firestore.rules`
> **Related:** [spec/01-primary-cat.md](../spec/01-primary-cat.md) · [spec/03-dice-engine.md](../spec/03-dice-engine.md) · [spec/04-adventure.md](../spec/04-adventure.md)
> **Changelog:** 2026-03-15 — 初版（整合自审查修复 + agent 起草）

---

## 1. 新增 Dart 模型（8 个）

### 1.1 PrimaryCat — 主哈基米

```dart
class PrimaryCat {
  final String id;
  final String userId;
  final String name;
  final String archetype;          // 'action' | 'mind' | 'harmony'
  final String personality;        // 映射自 archetype：'brave' | 'curious' | 'shy'
  final CatAppearance appearance;  // 复用现有 CatAppearance
  final String? equippedAccessory;
  final String? playerClass;       // 等级 3 后选择；null = 未选
  final DateTime createdAt;
}
```

### 1.2 PendingDice — 待投骰子

```dart
class PendingDice {
  final String id;
  final String uid;
  final String catId;
  final String habitId;
  final int focusMinutes;
  final DateTime earnedAt;
  // 不含 sceneCardId — 骰子是通用资源，投掷时绑定当前冒险
}
```

### 1.3 DiceResult — 检定结果

```dart
class DiceResult {
  final String id;
  final String uid;
  final String pendingDiceId;
  final String sceneCardId;
  final String eventId;
  final int naturalRoll;           // 1-20
  final int modifier;              // 属性修正值
  final int proficiencyBonus;      // 默认 0
  final int totalResult;           // naturalRoll + modifier + proficiencyBonus
  final int dc;
  final String outcome;            // 'critical_success' | 'success' | 'failure' | 'critical_failure'
  final bool hadAdvantage;
  final bool hadDisadvantage;
  final int stardustEarned;
  final DateTime rolledAt;
}
```

### 1.4 AdventureProgress — 冒险进度

```dart
class AdventureProgress {
  final String id;
  final String uid;
  final String sceneCardId;
  final String difficulty;         // 'normal' | 'hard' | 'legendary'
  final List<String> partyMemberIds;
  final List<String> selectedEventIds;
  final int currentEventIndex;
  final List<String> eventResultIds;
  final int successCount;
  final String status;             // 'active' | 'paused' | 'completed'
  final int? starRating;           // 1-3；完成后赋值
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

### 1.5 SceneCard — 场景卡模板

```dart
class SceneCard {
  final String id;
  final String name;
  final String region;             // 'town' | 'forest' | 'ruins'
  final int requiredLevel;
  final List<SceneEvent> eventPool;
  final int eventsPerRun;
  final String completionRewardId;
  final String description;
}
```

### 1.6 SceneEvent — 场景事件

```dart
class SceneEvent {
  final String id;
  final String ability;            // 'STR' | 'DEX' | 'CON' | 'INT' | 'WIS' | 'CHA'
  final int dc;
  final String prompt;
  final String successText;
  final String failText;
}
```

### 1.7 StarterArchetype — 御三家原型

```dart
class StarterArchetype {
  final String id;                 // 'action' | 'mind' | 'harmony'
  final String displayName;
  final String emoji;
  final String personality;
  final List<String> primaryAbilities;
  final List<String> colorRange;
  final String tagline;
}
```

编译期常量，定义在 `lib/core/constants/adventure_constants.dart`。

### 1.8 Party — 当前队伍

```dart
class Party {
  final String id;
  final String userId;
  final String primaryCatId;
  final String? companion1Id;
  final String? companion2Id;
  final DateTime updatedAt;
}
```

---

## 2. SQLite Schema

没有老用户，不需要迁移路径。直接定义目标态 schema。

### 2.1 新增表

```sql
CREATE TABLE IF NOT EXISTS local_primary_cat (
  id                 TEXT PRIMARY KEY,
  uid                TEXT NOT NULL,
  name               TEXT NOT NULL,
  archetype          TEXT NOT NULL,
  personality        TEXT NOT NULL,
  appearance         TEXT NOT NULL,        -- JSON
  equipped_accessory TEXT,
  player_class       TEXT,
  created_at         TEXT NOT NULL,
  UNIQUE(uid)
);

CREATE TABLE IF NOT EXISTS local_pending_dice (
  id             TEXT PRIMARY KEY,
  uid            TEXT NOT NULL,
  cat_id         TEXT NOT NULL,
  habit_id       TEXT NOT NULL,
  focus_minutes  INTEGER NOT NULL,
  earned_at      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS local_dice_results (
  id                  TEXT PRIMARY KEY,
  uid                 TEXT NOT NULL,
  pending_dice_id     TEXT NOT NULL,
  scene_card_id       TEXT NOT NULL,
  event_id            TEXT NOT NULL,
  natural_roll        INTEGER NOT NULL,
  modifier            INTEGER NOT NULL,
  proficiency_bonus   INTEGER NOT NULL DEFAULT 0,
  total_result        INTEGER NOT NULL,
  dc                  INTEGER NOT NULL,
  outcome             TEXT NOT NULL,
  had_advantage       INTEGER NOT NULL DEFAULT 0,
  had_disadvantage    INTEGER NOT NULL DEFAULT 0,
  stardust_earned     INTEGER NOT NULL DEFAULT 0,
  rolled_at           TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS local_adventure_progress (
  id                   TEXT PRIMARY KEY,
  uid                  TEXT NOT NULL,
  scene_card_id        TEXT NOT NULL,
  difficulty           TEXT NOT NULL DEFAULT 'normal',
  party_member_ids     TEXT NOT NULL,          -- JSON array
  selected_event_ids   TEXT NOT NULL,          -- JSON array
  current_event_index  INTEGER NOT NULL DEFAULT 0,
  event_results        TEXT NOT NULL DEFAULT '[]',
  success_count        INTEGER NOT NULL DEFAULT 0,
  status               TEXT NOT NULL DEFAULT 'active',
  star_rating          INTEGER,
  started_at           TEXT NOT NULL,
  completed_at         TEXT
);

CREATE TABLE IF NOT EXISTS local_party (
  id              TEXT PRIMARY KEY,
  uid             TEXT NOT NULL,
  primary_cat_id  TEXT NOT NULL,
  companion_1_id  TEXT,
  companion_2_id  TEXT,
  updated_at      TEXT NOT NULL,
  UNIQUE(uid)
);
```

### 2.2 现有表修改

```sql
-- local_habits 新增可选分类字段
ALTER TABLE local_habits ADD COLUMN category TEXT;
-- 可选值：'physical' | 'mental' | 'wellness' | 'social' | 'skill' | 'general'
-- NULL 视作 'general'
```

### 2.3 materialized_state 新增 key

| Key | Value 类型 | 说明 |
|-----|-----------|------|
| `stardust` | INTEGER | 当前星尘余额 |

---

## 3. Firestore 安全规则增量

追加至 `firestore.rules` 的 `match /users/{uid}` 块：

```js
match /primaryCat/{document=**} {
  allow read, write: if request.auth.uid == uid;
}

match /pendingDice/{diceId} {
  allow read, create, update, delete: if request.auth.uid == uid;
}

match /diceResults/{resultId} {
  allow read: if request.auth.uid == uid;
  allow create: if request.auth.uid == uid;
  allow update, delete: if false;  // 结果不可篡改
}

match /adventureProgress/{progressId} {
  allow read, create, update, delete: if request.auth.uid == uid;
}

match /party/{document=**} {
  allow read, write: if request.auth.uid == uid;
}
```

---

## 4. LedgerChange 新增 ActionType

```dart
// 主哈基米
primary_cat_create,
primary_cat_update,

// 骰子
dice_earned,
dice_consumed,
dice_overflow,

// 冒险
adventure_start,
adventure_event,
adventure_complete,
adventure_pause,

// 队伍
party_update,

// 职业
class_select,

// 星尘
stardust_earn,
stardust_spend,

// 习惯
habit_category_update,
```
