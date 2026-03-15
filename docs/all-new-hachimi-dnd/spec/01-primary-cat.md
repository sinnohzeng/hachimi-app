# 主哈基米（Primary Cat）系统规格书

> SSOT for the Primary Cat model, starter selection flow, attribute computation, and onboarding integration.
> **Status:** Draft
> **Evidence:** `lib/models/cat.dart`, `lib/models/cat_appearance.dart`, `lib/core/constants/cat_constants.dart`, `lib/services/pixel_cat_renderer.dart`, `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md §2`
> **Related:** `docs/all-new-hachimi-dnd/spec/02-dnd-attributes.md`, `docs/architecture/data-model.md`, `docs/architecture/state-management.md`, [spec/11-social-and-origins.md](11-social-and-origins.md)
> **Changelog:**
> - 2026-03-15 — 初版
> - 2026-03-15 — 增加 `background` 字段（SRD Backgrounds 适配，详见 spec/11）
> - 2026-03-15 — 新增 PrimaryCat 生命周期状态图、各原型 peltColor 白名单；确认背景选择推迟到 Phase 3

---

## 概述

主哈基米（Primary Cat）是用户本人的化身（Avatar），是 v2.0 "主哈基米 + 伙伴猫"（Route C）双层组队架构的核心。

**关键区别于伙伴猫（Companion Cat）：**

- **主哈基米不绑定任何单一习惯** — 它代表用户整体，属性从所有习惯/所有伙伴猫数据聚合计算
- **伙伴猫** = 现有的 `Cat` 模型，每只绑定一个习惯，存于 `local_cats` 表
- **主哈基米** = 全新的 `PrimaryCat` 模型，每用户唯一，存于独立的 `local_primary_cat` 表

主哈基米是 Onboarding 的入口，也是冒险/骰子系统中固定出席的队长角色。

---

## 御三家选择机制

新用户在 Onboarding 中从 3 种原型（Archetype）中选择主哈基米的性格方向。

### 原型对照表

| 原型 | 图标 | 性格 | 优势属性 | 色系范围 | 标语 |
|------|------|------|---------|---------|------|
| 行动派 Action | 🔥 | Brave | STR、DEX | 橘/红暖色系 | "用行动说话" |
| 思考派 Mind | 📚 | Curious | INT、WIS | 灰/蓝冷色系 | "知识就是力量" |
| 平衡派 Harmony | 🌿 | Shy | CON、CHA | 白/奶油柔色系 | "细水长流，温柔坚定" |

**色系范围的技术含义**：限制随机外观时 `CatAppearance.peltColor` 的候选集合。各原型对应的 `peltColor` 白名单在 `lib/models/starter_archetype.dart` 中定义为常量列表，不在渲染层写死。

### 各原型 peltColor 白名单

```dart
const archetypeColorRanges = {
  'action': ['GINGER', 'GOLDEN', 'DARKGINGER', 'CREAM', 'APRICOT'],
  'mind': ['BLUE', 'SILVER', 'GREY', 'PALEGREY', 'DARKGREY'],
  'harmony': ['WHITE', 'CREAM', 'PALECREAM', 'GHOST', 'LILAC'],
};
```

### 属性映射规则

| 原型 | 优势属性（各 +2 加成） |
|------|----------------------|
| Action | STR、DEX |
| Mind | INT、WIS |
| Harmony | CON、CHA |

"优势属性"加成在属性扩展方法 `PrimaryCatAbilities` 中以常量映射表实现，不用 if/else 分支。

---

## 创建仪式（五步流程）

路由：`/starter-selection`，对应 `lib/screens/starter_selection/starter_selection_screen.dart`

### 步骤 1 — 开场白

全屏过场文字，逐字渐显：

> "每个人都有一只属于自己的哈基米…"

### 步骤 2 — 三选一

- 同时展示 3 只猫咪卡片，每只卡片：
  - 原型名称 + 图标
  - 随机生成的外观（受原型色系约束）
  - 2 行性格描述
- **[换一批] 按钮**：重新随机 3 只猫的外观（性格框架不变），最多可刷新 **3 次**
- 刷新次数由本地 `int _refreshCount`（0–3）追踪，耗尽后按钮置灰

### 步骤 3 — 确认选择

- 用户点击某张卡片 → 卡片放大至 70% 屏幕宽度，其余卡片淡出
- 展示该原型的完整性格描述 + [确认] / [返回] 按钮

### 步骤 4 — 命名输入

- 文本输入框，验证规则：**1 到 30 个字符**（含 Unicode），不允许纯空格
- 输入完成后，猫咪头顶出现名字气泡动画（Flutter `AnimationController` 控制）
- 使用现有的 `CatMood` 视觉风格

> **动画细节**：气泡渐入 300ms（`Curves.easeOut`），停留 1s，可点击任意位置跳过直接进入步骤 5。

### 步骤 5 — 第一次对话

根据原型 personality 播放不同的初始台词（来自 `lib/core/constants/primary_cat_dialogues.dart`）：

| 原型 | 示例台词 |
|------|---------|
| Action（Brave） | "嗯！我会陪你完成每一个挑战的！" |
| Mind（Curious） | "你好，我对你的计划很好奇…告诉我更多吧。" |
| Harmony（Shy） | "…嗨。我…我会在这里陪着你的。" |

台词格式与伙伴猫对话一致，走 `primary_cat_dialogues.dart` 常量池，不走网络。

### 原子性保证

**创建仪式的 5 步流程必须全部完成才会持久化数据。**

- 步骤 1-5 期间，所有选择（原型、外观、名字）暂存在内存（`StarterSelectionState`），不写入 SQLite 或远端
- 仅当步骤 5 的首次对话播放完毕且用户点击 [继续] 后，才执行一次性写入：
  1. SQLite `local_primary_cat` INSERT（事务内）
  2. 远端同步（异步，通过 LedgerChange 推送，失败不阻塞）
  3. Ledger 记录 `primary_cat_create`
- 中途退出（杀 App、返回键、系统中断）：不保存任何数据，下次打开 App 重新进入 `/starter-selection`
- Android 返回键在步骤 1-5 期间**不触发退出**（`WillPopScope` / `PopScope` 拦截），仅在步骤 2-5 回退到上一步

**错误处理**：
- SQLite 写入失败：显示重试 Toast，保持在步骤 5 画面
- 远端写入失败：静默失败，本地数据有效，下次联网时通过 LedgerChange 同步

### PrimaryCat 生命周期状态

```
null ──→ created ──→ updated ──→ ... (持续更新)
                         │
                         └──→ deleted（仅账户删除触发）
```

| 状态 | 触发 | 说明 |
|------|------|------|
| `null` | App 首次启动 | Onboarding 未完成 |
| `created` | Onboarding 五步完成 | SQLite + Ledger 原子写入 |
| `updated` | 外观/职业/ASI/专长变更 | 通过 PrimaryCatService 方法 |
| `deleted` | 账户删除 | AccountDeletionService 级联清理 |

> **不可重建**：主哈基米一旦创建，不存在"重置"流程。用户必须删除账户才能重新创建。

---

## PrimaryCat 数据模型

文件路径：`lib/models/primary_cat.dart`

> **SSOT**：PrimaryCat 完整模型定义见 [architecture/data-model.md](../architecture/data-model.md) §1.1。
> 以下为关键字段摘要，当与 data-model.md 冲突时以 data-model.md 为准。

关键字段：
- `archetype`：'action' | 'mind' | 'harmony'（御三家选择）
- `personality`：映射自 archetype（'brave' | 'curious' | 'shy'）
- `background`：背景出身，默认 'adventurer'（Phase 1 暂不暴露选择 UI）
- `playerClass`：等级 3 后选择的职业（null = 未选）
- `asiChoices`：ASI/专长选择历史（Phase 3 数据预留）

> **Phase 1 处理**：`background` 字段在 Phase 1 数据模型中预留，默认值 'adventurer'。
> 创建仪式（五步流程）中不展示背景选择 UI。
> Phase 3 启用 spec/11 社交系统后，在 Onboarding 中新增背景选择步骤。

### 存储位置

| 层级 | 路径 / 表名 | 说明 |
|------|-----------|------|
| 远端 | 通过 `AdventureBackend.savePrimaryCat()` 同步 | 自动通过 LedgerChange 推送 |
| SQLite | `local_primary_cat`（每用户一行） | 离线主数据源 |

> **SQLite 表结构**见 [architecture/data-model.md](../architecture/data-model.md) §2.1。

**属性字段不存储** — 全部由 `PrimaryCatAbilities` extension 在运行时从 Provider 数据聚合计算。

---

## PrimaryCat 与 Cat 的关系

**PrimaryCat 是独立模型，不继承、不扩展 Cat。**

| 维度 | Cat（伙伴猫） | PrimaryCat（主哈基米） |
|------|------------|---------------------|
| 数据模型 | `lib/models/cat.dart` | `lib/models/primary_cat.dart` |
| SQLite 表 | `local_cats`（多行） | `local_primary_cat`（单行） |
| 远端路径 | `users/{uid}/cats/{catId}` | `users/{uid}/primaryCat` |
| 绑定关系 | 绑定单一 `habitId` | 不绑定任何习惯 |
| 属性来源 | 自身 `totalMinutes`/`streak` 等 | 所有伙伴猫聚合 |

**复用点：**

- `CatAppearance` — 外观参数结构完全复用，不新建类型
- `PixelCatRenderer`（`lib/services/pixel_cat_renderer.dart`）— 渲染管线直接复用，传入相同的 `CatAppearance` 即可
- `CatMood` / `calculateMood`（`lib/core/constants/cat_constants.dart`）— 心情计算逻辑复用

**视觉区分 — 皇冠/标记 Overlay：**

- 主哈基米在渲染时叠加一个 **16×16 像素的皇冠精灵**，位于猫咪头顶
- Overlay 由 `PixelCatRenderer` 通过新增参数 `bool showCrownOverlay` 控制（默认 `false`）
- 皇冠精灵资源：`assets/sprites/crown_marker.png`（16×16，需美术新增）

> **渲染层级**：皇冠精灵在 `PixelCatRenderer` 的 13 层渲染管线完成后，作为第 14 层叠加。相对于猫咪头部中心点向上偏移 8px。不同成长阶段（幼猫/少年/成年）使用相同偏移值（头部尺寸一致）。

---

## 主哈基米属性计算

文件路径：`lib/models/primary_cat.dart`（extension 写在同一文件）

```dart
extension PrimaryCatAbilities on PrimaryCat {
  /// STR：全部伙伴猫 totalMinutes 之和，每 120 分钟 +1，基础 10
  int get strength => _applyBonus('str', _clamp(_minutesToScore(allCatsTotalMinutes)));

  /// DEX：近 30 次专注的 completionRatio 均值驱动
  int get dexterity => _applyBonus('dex', _clamp(_efficiencyToScore(overallCompletionRate)));

  /// CON：所有习惯合并后的历史最长连续打卡天数
  int get constitution => _applyBonus('con', _clamp(_streakToScore(longestEverStreak)));

  /// INT：活跃习惯数量 + 平均目标时长的复合分
  int get intelligence => _applyBonus('int', _clamp(_habitDiversityToScore(activeHabitCount, avgGoalMinutes)));

  /// WIS：最近 30 天内有专注记录的天数占比
  int get wisdom => _applyBonus('wis', _clamp(_consistencyToScore(thirtyDayCoverage)));

  /// CHA：所有活跃伙伴猫的平均心情分
  int get charisma => _applyBonus('cha', _clamp(_happinessToScore(averageCatMood)));

  /// 原型优势属性加成 +2，通过 Map 查表，不用 if/else
  static const _archetypeBonusMap = {
    'action':  {'str', 'dex'},
    'mind':    {'int', 'wis'},
    'harmony': {'con', 'cha'},
  };

  int _applyBonus(String attr, int base) {
    final bonusAttrs = _archetypeBonusMap[archetype] ?? {};
    return bonusAttrs.contains(attr) ? (base + 2).clamp(10, 20) : base;
  }

  int _clamp(int raw) => raw.clamp(10, 20);
}
```

### 设计意图

主哈基米的属性公式与伙伴猫不同，这是有意设计：
- **主哈基米** = 用户的综合化身，属性反映所有习惯的整体表现（聚合计算）
- **伙伴猫** = 单个习惯的代表，属性仅反映该习惯的独立表现（个体计算）

两套公式的差异确保：主哈基米是"全局视角"，伙伴猫是"局部视角"。用户通过主哈基米看到自己的整体成长，通过伙伴猫看到每个习惯的独立进度。

### 各公式输入的数据来源（关键）

以下输入值由 `PrimaryCatProvider` 在调用属性扩展前注入，不由扩展方法自行查数据库。

| 输入参数 | 数据来源 | 涉及的表/Provider |
|---------|---------|-----------------|
| `allCatsTotalMinutes` | `SELECT SUM(total_minutes) FROM local_cats WHERE uid = ?` | 现有 `catProvider` |

> **「活跃伙伴猫」定义**：`state != 'retired' && state != 'deleted'`。已退休或已删除的猫不参与主哈基米属性计算。上述 SQL 查询需加上此过滤条件。
| `overallCompletionRate` | `CompletionRateService.averageForAllCats(lastN: 30)` | **新增** `CompletionRateService` |
| `longestEverStreak` | `StreakService.longestEverAcrossAllHabits()` | **新增** `StreakService` |
| `activeHabitCount` | 活跃习惯数：`local_habits` 中 `state != 'graduated'` 的行数 | 现有 `habitsProvider` |
| `avgGoalMinutes` | 活跃习惯的 `goal_minutes` 均值 | 现有 `habitsProvider` |
| `thirtyDayCoverage` | `CoverageService.coverageLastThirtyDays()` | **新增** `CoverageService` |
| `averageCatMood` | 所有活跃猫的 `computedMood` 转数值后求均值 | 现有 `catProvider` |

心情转数值映射（用于 `averageCatMood` 计算）：

| computedMood | 数值 |
|-------------|------|
| `happy` | 4 |
| `neutral` | 3 |
| `lonely` | 2 |
| `missing` | 1 |

**属性公式参考（内联辅助函数，私有，写在 extension 内部）：**

```dart
/// 每 120 分钟 +1，基础 10，上限由 _clamp 保证
int _minutesToScore(int totalMinutes) => 10 + totalMinutes ~/ 120;

/// completionRate 0.0~1.0 → 10~18 的线性区间
int _efficiencyToScore(double rate) {
  if (rate >= 0.95) return 18;
  if (rate >= 0.90) return 16;
  if (rate >= 0.75) return 14;
  if (rate >= 0.50) return 12;
  return 10;
}

/// 每 7 天连击 +1
int _streakToScore(int streakDays) => 10 + streakDays ~/ 7;

/// 多样性分：habitCount × avgGoal 的对数近似
int _habitDiversityToScore(int habitCount, double avgGoal) {
  final base = (avgGoal / 15.0).clamp(1.0, 3.0);
  return (10 + habitCount * base).clamp(10, 20).toInt();
}

/// 30 天覆盖率 0.0~1.0 → 10~18
int _consistencyToScore(double coverage) {
  if (coverage >= 0.90) return 18;
  if (coverage >= 0.80) return 16;
  if (coverage >= 0.60) return 14;
  if (coverage >= 0.40) return 12;
  return 10;
}

/// 心情均值（1~4）→ 10~20
int _happinessToScore(double avgMood) => (10 + (avgMood - 1) * 3.33).round().clamp(10, 20);
```

---

## 主哈基米心情

主哈基米的心情基于**所有伙伴猫中最近一次专注结束时间**，复用现有 `calculateMood` 逻辑。

```dart
extension PrimaryCatMood on PrimaryCat {
  /// 取所有伙伴猫 lastSessionAt 的最大值作为主哈基米的"最近专注时间"
  DateTime? lastAnySessionAt(List<Cat> companionCats) =>
      companionCats
          .map((c) => c.lastSessionAt)
          .whereType<DateTime>()
          .fold<DateTime?>(null, (prev, dt) => prev == null || dt.isAfter(prev) ? dt : prev);

  /// 复用 cat_constants.dart 中的 calculateMood(lastSessionAt, createdAt: ...)
  String computedMood(List<Cat> companionCats) =>
      calculateMood(lastAnySessionAt(companionCats), createdAt: createdAt);
}
```

`calculateMood` 来源：`lib/core/constants/cat_constants.dart`，已有完整实现，不新增逻辑。

> **空值处理**：若所有伙伴猫的 `lastSessionAt` 均为 null（如用户创建后从未专注），则使用主哈基米 `createdAt` 作为心情计算的基准时间。即 `lastAnySessionAt` 返回 null 时，`computedMood` 中传入 `createdAt` 作为 fallback。

---

## 外观微调

- **触发条件**：用户在主哈基米详情页点击 [重新随机外观] 按钮
- **费用**：消耗 **500 金币**，从现有 `CoinService` 扣款
- **效果**：在原型色系范围内重新随机 `CatAppearance`，**性格（personality）和 archetype 不变**
- **操作次数**：无限制（每次需 500 金币）
- **实现**：调用 `PrimaryCatService.randomizeAppearance(primaryCat, archetype)`，写入 SQLite + 远端同步

---

## Onboarding 流程

> **注意：无用户迁移需求** — 本项目目前不存在真实用户，v2.0 为全新安装体验。

### 新用户完整流程

```
App 启动
  → [无 primaryCat 记录]
  → StarterSelectionScreen（/starter-selection）
      步骤 1~5：选择原型 → 随机外观 → 命名 → 第一次对话
  → CreateHabitScreen（创建第一个习惯 + 伙伴猫）
  → HomeScreen（Tab 1，正式进入 App）
```

### 流程状态判断

`AppRouter`（`lib/core/router/app_router.dart`）在 `redirect` 回调中检查：

1. 未登录 → `/login`
2. 已登录但无 `primaryCat` → `/starter-selection`
3. 已登录且有 `primaryCat` 但无习惯 → `/create-habit`
4. 正常 → `/home`

Provider：`primaryCatProvider`（`lib/providers/primary_cat_provider.dart`）返回 `AsyncValue<PrimaryCat?>`，Router 用 `.valueOrNull` 判断。

> **不使用 SharedPreferences flag**：Onboarding 完成状态通过 `primaryCat != null` 推断，不额外存储 flag。避免 SharedPreferences 与 Provider 状态不同步的风险。

---

## 新增文件清单

| 文件路径 | 职责 |
|---------|------|
| `lib/models/primary_cat.dart` | PrimaryCat 数据模型 + 两个 extension |
| `lib/models/starter_archetype.dart` | 3 个原型的元数据常量（色系、性格、标语、优势属性） |
| `lib/providers/primary_cat_provider.dart` | `primaryCatProvider`（`AsyncNotifierProvider`） |
| `lib/services/primary_cat_service.dart` | CRUD + 外观随机化，读写 SQLite + 远端同步 |
| `lib/screens/starter_selection/starter_selection_screen.dart` | 五步创建仪式 UI |
| `lib/core/constants/primary_cat_dialogues.dart` | 3 个原型 × 4 心情 × 5 变体的初始对话池 |
| `assets/sprites/crown_marker.png` | 16×16 皇冠 Overlay 精灵（美术资源） |

**新增 Service（纯计算，无副作用）：**

| 文件路径 | 职责 |
|---------|------|
| `lib/services/completion_rate_service.dart` | 从 `local_sessions` 计算 completionRatio 均值 |
| `lib/services/streak_service.dart` | 从 `local_sessions` 计算最长连续打卡天数 |
| `lib/services/coverage_service.dart` | 从 `local_sessions` 计算 30 天覆盖率 |

---

## 验收标准

- [ ] `PrimaryCat` 模型可正确在 SQLite（`local_primary_cat` 表）和远端（通过 `AdventureBackend`）中创建、读取、删除
- [ ] `StarterSelectionScreen` 展示 3 个原型卡片，外观受对应色系约束
- [ ] [换一批] 按钮在第 3 次使用后置灰，不可再刷新
- [ ] 名字输入校验：空字符串或纯空格不允许提交，超过 30 字符截断
- [ ] 第一次对话台词根据原型正确选取（3 条台词各自对应 action/mind/harmony）
- [ ] 属性计算边界用例：`allCatsTotalMinutes = 0` 时 STR = 10，`= 24000` 时 STR 不超过 20
- [ ] `_applyBonus` 对优势属性加 2 后不超过 20（clamp 生效）
- [ ] 皇冠 Overlay 仅在 `showCrownOverlay: true` 时渲染，不影响其他猫咪显示
- [ ] 外观微调扣款 500 金币，余额不足时按钮提示而非崩溃
- [ ] `AppRouter` redirect 逻辑：无 primaryCat 时正确导向 `/starter-selection`
- [ ] 30 天覆盖率、最长连击、completionRatio 均值在单元测试中通过边界值验证
- [ ] **ID 冲突检测**：PrimaryCat.id 与 Cat.id 使用不同的 UUID 命名空间或前缀，确保无碰撞
- [ ] **外观微调余额不足**：金币 < 500 时，[重新随机外观] 按钮显示价格标签并置灰，点击提示"金币不足"，不崩溃
- [ ] **Onboarding 原子性**：中途杀 App 后重新打开，local_primary_cat 表为空，重新进入 /starter-selection
