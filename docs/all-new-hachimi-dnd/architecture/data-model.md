# 数据模型与存储架构

> **SSOT 声明**：本文件是所有 v2.0 新增数据模型的**唯一权威定义**。
> 其他 spec 文件中出现的模型定义为引用摘要，当与本文件冲突时以本文件为准。
> 远端存储规则使用 backend-agnostic 约束描述，不绑定任何特定云服务商。

> **⚠️ v2.0 大版本声明**：本文件定义全新 schema，**不兼容旧版本**。不存在从旧版本的数据迁移路径。
> SQLite 建表为 v1 schema（`_onCreate`），非 `_onUpgrade` 迁移。用户从 v2.0 全新开始。

> SSOT for v2.0 DnD 融合的所有新增数据模型、SQLite Schema 和远端验证规则。
> **Status:** Draft
> **Evidence:** `lib/models/`、`lib/services/local_database_service.dart`、`firestore.rules`
> **Related:** [spec/01-primary-cat.md](../spec/01-primary-cat.md) · [spec/03-dice-engine.md](../spec/03-dice-engine.md) · [spec/04-adventure.md](../spec/04-adventure.md)
> **Changelog:**
> - 2026-03-15 — 编码前全面修复：新增 ActiveCondition 空壳模型（D47）、region 值统一为完整前缀命名（D48）、background 字段明确 Phase 1 默认语义（D51）、SQLite DDL 补充 active_conditions 列
> - 2026-03-15 — 审计修复：大版本声明、SceneEvent.type/trap 字段、SceneCard.environment、PrimaryCat 序列化与 lastDiscoveryDate、ActionType 补齐至 18 种、stardustEarned 上限 30、materializedState 结构、SQLite 索引、v1 schema（非迁移）
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
  final String background;         // Phase 1 默认 'adventurer'（非用户可选，D51）；Phase 3 提供 4 种可选：'scholar'|'athlete'|'healer'|'performer'
  final Map<int, String> asiChoices;     // {4: 'STR', 8: 'feat:Alert', 12: 'DEX', ...}
  final List<String> selectedFeats;      // ['Alert', 'Lucky']
  final DateTime createdAt;
  final String? lastDiscoveryDate;  // 上次被动感知发现日期 'yyyy-MM-dd'（离线优先：存 SQLite 非 SharedPreferences）
}
```

/// 序列化方法（遵循现有 Cat.toSqlite/fromSqlite 模式）
///
/// toSqlite() → Map<String, dynamic>:
///   - appearance: jsonEncode(appearance.toMap())
///   - asi_choices: jsonEncode(asiChoices.map((k, v) => MapEntry(k.toString(), v)))
///   - selected_feats: jsonEncode(selectedFeats)
///   - created_at: createdAt.toIso8601String()
///
/// factory PrimaryCat.fromSqlite(Map<String, dynamic> map):
///   - appearance: CatAppearance.fromMap(jsonDecode(map['appearance']))
///   - asiChoices: (jsonDecode(map['asi_choices']) as Map).map((k, v) => MapEntry(int.parse(k), v as String))
///   - selectedFeats: (jsonDecode(map['selected_feats']) as List).cast<String>()
///   - createdAt: DateTime.parse(map['created_at'])
///
/// toFirestore() / fromFirestore() 遵循相同结构，
/// DateTime 使用 Timestamp 类型而非 ISO 字符串。

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
  final List<ActiveCondition> activeConditions;  // 当前状态效果（Phase 2，Phase 1 = const []）
  final int pityConsecutiveFailures;    // 保底计数器：连续失败次数（冒险恢复时一并恢复）
  final int pityConsecutiveNonCrits;    // 保底计数器：连续非大成功次数
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
  final String region;             // 'cat_town' | 'misty_forest' | 'ancient_ruins'（D48：统一完整前缀命名）
  final int requiredLevel;
  final List<SceneEvent> eventPool;
  final int eventsPerRun;
  final String completionRewardId;
  final String description;
  final String? environment;       // 环境效果代码：'dim_light' | 'fog' | 'storm' 等（Phase 2，Phase 1 为 null）
}
```

### 1.6 SceneEvent — 场景事件

```dart
class SceneEvent {
  final String id;
  final String ability;            // 'STR' | 'DEX' | 'CON' | 'INT' | 'WIS' | 'CHA'
  final int dc;
  final String type;               // 'ability_check' | 'saving_throw' | 'trap'（Phase 1 默认 'ability_check'）
  final String prompt;
  final String successText;
  final String failText;
  // Phase 2 扩展字段（陷阱类事件使用）
  final int? trapDetectDc;         // 陷阱感知 DC
  final String? trapDisarmAbility; // 解除陷阱使用的属性
  final int? trapDisarmDc;         // 解除陷阱 DC
}
```

> **序列化**：SceneCard 和 SceneEvent 使用 `static final` 列表定义（不使用 `const` 构造——`List<SceneEvent>` 字段在 const 上下文中无法使用 `fromJson()` 逻辑）。支持 `fromJson()`/`toJson()`（用于 Phase 3+ Remote Config 季节性场景卡）。
> 基础卡定义在 `lib/core/constants/adventure_constants.dart` 中作为 `static final` 实例。

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

### 1.10 ActiveCondition — 状态效果（D47）

```dart
/// 冒险中的临时 Buff/Debuff 状态效果。
/// Phase 1 中 AdventureProgress.activeConditions 始终为 const []。
/// Phase 2 启用后，由 SceneEvent 结果触发，冒险结束时强制清空。
class ActiveCondition {
  final String id;                 // UUID
  final String type;               // 'well_rested' | 'inspired' | 'poisoned' | 'blessed' 等
  final int? remainingEvents;      // 剩余生效事件数（null = 持续到冒险结束）
}
```

> **Phase 1 处理**：`ActiveCondition` 类定义必须存在（Dart 编译需要），但 `AdventureProgress` 构造时传入 `const []`。
> Phase 2 实现状态效果系统时，在 spec/08-conditions-and-defenses.md 中定义完整的状态效果列表。
>
> **序列化**：`activeConditions` 序列化为 JSON 数组存入 SQLite TEXT 列，格式为 `[{"id":"...","type":"...","remainingEvents":3}]`。

---

## 2. SQLite Schema

### Schema 策略

**v2.0 全新 schema**：所有表（含 `local_habits`）在 `_onCreate` 中创建。
`local_habits` 表定义直接包含 `category TEXT` 字段，无需 ALTER TABLE。

> ⚠️ v2.0 是大版本更新，不保留旧版数据。用户升级后从头开始。

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
  last_discovery_date TEXT,          -- 被动感知上次发现日期 yyyy-MM-dd
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
  active_conditions          TEXT NOT NULL DEFAULT '[]',   -- JSON array of ActiveCondition（D47，Phase 1 = '[]'）
  pity_consecutive_failures  INTEGER NOT NULL DEFAULT 0,
  pity_consecutive_non_crits INTEGER NOT NULL DEFAULT 0,
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

### 2.2 local_habits 表包含新字段

`local_habits` 建表 DDL 中直接包含 `category TEXT` 列（无需迁移）。

### 2.3 推荐索引

```sql
-- 属性计算服务（CompletionRate/Coverage）的 30 天窗口查询优化
CREATE INDEX IF NOT EXISTS idx_sessions_uid_status_ended
  ON local_sessions(uid, status, ended_at);

-- DiceResult 查询优化（按用户和时间排序）
CREATE INDEX IF NOT EXISTS idx_dice_results_uid_rolled
  ON local_dice_results(uid, rolled_at);
```

### 2.4 materialized_state 新增 key

| Key | Value 类型 | 说明 |
|-----|-----------|------|
| `stardust` | INTEGER | 当前星尘余额 |
| `adventure_xp` | INTEGER | 冒险等级 XP（含职业加成累积） |
| `lucky_reroll_used_today` | TEXT | Lucky 专长今日重投日期 'yyyy-MM-dd'（非当天则可用） |

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
| `diceResults.stardustEarned` | `∈ [0, 30]` | 单次检定最大 15 × 职业加成 1.5 = 22.5，向上取整预留空间 |
| `materializedState.gold` | `≥ 0` | 金币不可为负 |
| `materializedState.stardust` | `≥ 0` | 星尘不可为负 |

### 远端 materializedState 存储结构

`materializedState` 存储为 `users/{uid}` 文档的嵌套 map 字段：

```json
{
  "materializedState": {
    "gold": 1234,
    "stardust": 567,
    "adventure_xp": 8900,
    "lucky_reroll_used_today": "2026-03-15"
  }
}
```

安全规则应验证：
- `request.resource.data.materializedState.gold >= 0`
- `request.resource.data.materializedState.stardust >= 0`

---

## 4. LedgerChange 新增 ActionType

```dart
// 18 种新增 ActionType

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
adventure_abandon,

// 队伍
party_update,

// 职业
class_select,

// 难度解锁
scene_difficulty_unlock,

// 星尘
stardust_earn,
stardust_spend,

// 习惯
habit_category_update,

// 冒险 XP
adventure_xp_earn,
```

> **前向兼容**：`ActionType.fromValue()` 必须改为 `tryFromValue()` 模式——遇到未知值返回 `null` 而非抛出 `ArgumentError`。
> 这确保新版本写入的 ActionType 不会导致旧版本崩溃。
>
> **Phase 1 首个 PR 必须项**：`ActionType.fromValue()` 改为 `tryFromValue()` 模式。此变更属于 Phase 1 基础设施准备，必须在任何 DnD 功能代码之前完成。
