# 数据模型与存储架构

> **SSOT 声明**：本文件是所有 v2.0 新增数据模型的**唯一权威定义**。
> 其他 spec 文件中出现的模型定义为引用摘要，当与本文件冲突时以本文件为准。
> 远端存储规则使用 backend-agnostic 约束描述，不绑定任何特定云服务商。

> SSOT for v2.0 DnD 融合的所有新增数据模型、SQLite Schema 和远端验证规则。
> **Status:** Draft
> **Evidence:** `lib/models/`、`lib/services/local_database_service.dart`、`firestore.rules`
> **Related:** [spec/01-primary-cat.md](../spec/01-primary-cat.md) · [spec/03-dice-engine.md](../spec/03-dice-engine.md) · [spec/04-adventure.md](../spec/04-adventure.md)
> **Changelog:**
> - 2026-03-15 — Fix: 合并 background 字段、AdventureProgress 增加 abandoned 状态与 activeDeviceId、DiceResult 注释修正、新增 SceneDifficultyUnlock 模型、安全规则改为 backend-agnostic、SSOT 声明
> - 2026-03-15 — 初版（整合自审查修复 + agent 起草）

---

## 1. 新增 Dart 模型（9 个）

> **重要区分**：`PrimaryCat`（主哈基米）与 `Cat`（伙伴猫）是**两个完全独立的模型**，不共享任何继承关系。
> - **PrimaryCat** = 用户本人的 RPG 化身，每用户唯一，属性从所有伙伴猫数据聚合计算
> - **Cat** = 绑定单一习惯的伙伴猫，可有多只，属性仅反映自身习惯数据
> - 两者都复用 `CatAppearance` 结构体，但存储在不同的 SQLite 表和远端路径中
> - 详见 [spec/01-primary-cat.md §PrimaryCat 与 Cat 的关系](../spec/01-primary-cat.md)

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
  final String background;         // 背景出身：'scholar'|'athlete'|'healer'|'performer'|'adventurer'（默认 'adventurer'）
  final Map<int, String> asiChoices;     // {4: 'STR', 8: 'feat:Alert', 12: 'DEX', ...}
  final List<String> selectedFeats;      // ['Alert', 'Lucky']
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
  final int totalResult;           // 由 DiceEngineService 计算写入，完整公式见 spec/03 §6.5
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
  final String status;             // 'active' | 'paused' | 'completed' | 'abandoned'
  final int? starRating;           // 1-3；完成后赋值
  final String? activeDeviceId;    // 设备锁定，防止多设备冲突
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

**状态转换规则：**

```
active → paused     （用户主动暂停或开始新冒险）
active → completed  （所有事件完成）
active → abandoned  （用户切换场景卡）
paused → active     （用户恢复冒险）
paused → abandoned  （用户切换场景卡）
completed → ×       （终态，不可变）
abandoned → ×       （终态，不可变）
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

### 1.9 SceneDifficultyUnlock — 场景难度解锁状态

```dart
/// 场景难度解锁状态 — 每个场景卡独立
class SceneDifficultyUnlock {
  final String id;               // = sceneCardId
  final String uid;
  final bool hardUnlocked;       // Normal 通关后为 true
  final bool legendaryUnlocked;  // Hard 通关后为 true
  final DateTime updatedAt;
}
```

---

## 2. SQLite Schema

### 迁移策略

**SQLite 版本：v3 → v4**

虽然 DnD 功能对已有用户是全新的（无需迁移 PrimaryCat/Adventure 数据），但 `local_habits` 表已经存在且包含用户数据，必须通过 ALTER TABLE 添加 `category` 字段。

```dart
// LocalDatabaseService._onUpgrade
if (oldVersion < 4) {
  // 1. 新增 DnD 表（全新，无数据迁移）
  await db.execute('''CREATE TABLE IF NOT EXISTS local_primary_cat (...)''');
  await db.execute('''CREATE TABLE IF NOT EXISTS local_pending_dice (...)''');
  await db.execute('''CREATE TABLE IF NOT EXISTS local_dice_results (...)''');
  await db.execute('''CREATE TABLE IF NOT EXISTS local_adventure_progress (...)''');
  await db.execute('''CREATE TABLE IF NOT EXISTS local_party (...)''');
  await db.execute('''CREATE TABLE IF NOT EXISTS local_scene_difficulty_unlock (...)''');

  // 2. 现有表修改：添加习惯分类字段
  await db.execute('ALTER TABLE local_habits ADD COLUMN category TEXT');
  // NULL 视作 'general'，不自动填充默认值
  // 用户可在习惯设置页手动选择分类
}
```

**默认值策略**：
- `category = NULL` 在所有计算中视为 `'general'`
- 不自动根据习惯名推断分类（避免误判）
- 用户首次进入职业选择（Lv 3）时，引导页提示"为习惯设置分类以获得职业 XP 加成"

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
  background         TEXT NOT NULL DEFAULT 'adventurer',  -- 背景出身
  asi_choices        TEXT NOT NULL DEFAULT '{}',     -- JSON: Map<int, String>
  selected_feats     TEXT NOT NULL DEFAULT '[]',     -- JSON: List<String>
  created_at         TEXT NOT NULL,        -- ISO 8601
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
  active_device_id     TEXT,                   -- 设备锁定 ID
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

CREATE TABLE IF NOT EXISTS local_scene_difficulty_unlock (
  id                 TEXT PRIMARY KEY,  -- = sceneCardId
  uid                TEXT NOT NULL,
  hard_unlocked      INTEGER NOT NULL DEFAULT 0,
  legendary_unlocked INTEGER NOT NULL DEFAULT 0,
  updated_at         TEXT NOT NULL,
  UNIQUE(uid, id)
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

## 3. 远端验证规则

> 以下验证约束适用于任何后端实现（Firebase、CloudBase、自建服务等）。
> 具体的 rules 语法由各 Backend 实现文档提供。
> 参考实现见 `lib/services/firebase/firebase_adventure_backend.dart`。

### 远端存储路径

| 路径 | 说明 |
|------|------|
| `users/{uid}/primaryCat` | 主哈基米（单文档/记录） |
| `users/{uid}/pendingDice/{diceId}` | 待投骰子 |
| `users/{uid}/diceResults/{resultId}` | 检定结果 |
| `users/{uid}/adventureProgress/{progressId}` | 冒险进度 |
| `users/{uid}/party` | 当前队伍（单文档/记录） |
| `users/{uid}/sceneDifficultyUnlock/{sceneCardId}` | 场景难度解锁状态 |

### 字段验证约束

| 集合 | 约束 | 说明 |
|------|------|------|
| primaryCat | 仅所有者可读写（`request.uid == uid`） | 每用户唯一 |
| pendingDice | 仅所有者可 CRUD | — |
| diceResults | 仅所有者可读、可创建；**不可更新、不可删除**（结果不可篡改） | 审计日志性质 |
| adventureProgress | 仅所有者可 CRUD | — |
| party | 仅所有者可读写 | 每用户唯一 |
| sceneDifficultyUnlock | 仅所有者可读写 | — |

### 值域约束

| 字段 | 约束 | 说明 |
|------|------|------|
| `diceResults.naturalRoll` | `∈ [1, 20]` | d20 骰子值域 |
| `diceResults.stardustEarned` | `∈ [0, 20]` | 单次检定最大 15 + 场景奖励 |
| `materializedState.gold` | `≥ 0` | 金币不可为负 |
| `materializedState.stardust` | `≥ 0` | 星尘不可为负 |

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

// 难度解锁
difficulty_unlock,

// 星尘
stardust_earn,
stardust_spend,

// 习惯
habit_category_update,
```
