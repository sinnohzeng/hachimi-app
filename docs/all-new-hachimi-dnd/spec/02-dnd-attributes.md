# DnD 属性系统规格书

> SSOT for the six-attribute DnD system applied to companion cats, including formulas, stage caps, modifier table, growth curves, and required new services.
> **Status:** Draft
> **Evidence:** `lib/models/cat.dart`, `lib/models/focus_session.dart`, `lib/models/habit.dart`, `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md §3`, `docs/all-new-hachimi-dnd/research/comprehensive-analysis.md §9.2–§10.3`
> **Related:** `docs/all-new-hachimi-dnd/spec/01-primary-cat.md`, `docs/architecture/data-model.md`
> **Changelog:** 2026-03-15 — 初版

---

## 概述

每只**伙伴猫**（即习惯猫，对应现有 `Cat` 模型）具备 6 个 DnD 属性：STR（力量）、DEX（敏捷）、CON（体质）、INT（智力）、WIS（感知）、CHA（魅力）。

**核心设计原则：**

- 属性是**计算型字段**，从现有数据（`totalMinutes`、`streak`、`completionRatio`、`goalMinutes`）派生
- **不修改 Cat 模型**，不引入新的写路径，不影响 Firestore/SQLite 序列化
- 用 Dart `extension` 实现，添加到 `lib/models/cat.dart`（或独立文件 `lib/models/cat_abilities.dart`）
- 属性值范围：**10–20**（SRD 5.2.1 标准人类区间），初始全部为 10

---

## 伙伴猫属性公式

### 属性一览

| 属性 | 语义 | 数据源 | 公式摘要 |
|------|------|--------|---------|
| STR 力量 | 总投入量 | `cat.totalMinutes`（SQLite `local_cats.total_minutes`） | 每 +120 分钟 → +1 |
| DEX 敏捷 | 完成效率 | 近 30 次 `session.completionRatio` 均值 | ≥0.95→18，≥0.90→16，以此类推 |
| CON 体质 | 坚持韧性 | 当前连续打卡天数（streak days） | 每 +7 天 → +1 |
| INT 智力 | 目标难度 | `habit.goalMinutes` | 目标越高 → 基础越高，分段映射 |
| WIS 感知 | 规律性 | 近 30 天有专注记录的天数 / 30 | ≥0.90→18，≥0.80→16，以此类推 |
| CHA 魅力 | 幸福度 | `cat.computedMood` + `cat.displayStage` | happy+adult→20，阶梯映射 |

---

## completionRatio 定义（关键）

`completionRatio` 来自 `FocusSession.completionRatio`（`lib/models/focus_session.dart` 字段已存在）：

```
completionRatio = session.durationMinutes / habit.goalMinutes
```

- 结果强制 clamp 至 **0.0–1.0**（已在 `FocusSession` 写入时保证）
- **边界情况**：若 `habit.goalMinutes` 为 0 或 null，则 `completionRatio = 1.0`（视为完成）
- 正计时模式（`mode = 'stopwatch'`）下 `completionRatio` 固定为 `1.0`（代码已如此设定）

---

## 属性公式详解

以下 extension 方法定义在 `lib/models/cat_abilities.dart`（新建）或 `lib/models/cat.dart` 末尾：

```dart
/// 伙伴猫 DnD 属性扩展 — 纯计算，不修改 Cat 模型，不影响序列化。
/// 调用方需提前通过 Service 注入 [avgCompletionRate]、[streakDays]、[thirtyDayCoverage]。
extension CompanionCatAbilities on Cat {

  /// STR：每 120 分钟 +1，基础 10
  int strengthScore(int capForStage) =>
      _capByStage(_minutesToStr(totalMinutes), capForStage);

  /// DEX：近 30 次 completionRatio 均值
  int dexterityScore(double avgCompletionRate, int capForStage) =>
      _capByStage(_completionToDex(avgCompletionRate), capForStage);

  /// CON：当前连续打卡天数，每 7 天 +1
  int constitutionScore(int streakDays, int capForStage) =>
      _capByStage(_streakToCon(streakDays), capForStage);

  /// INT：habit.goalMinutes 分段映射
  int intelligenceScore(int habitGoalMinutes, int capForStage) =>
      _capByStage(_goalToInt(habitGoalMinutes), capForStage);

  /// WIS：30 天覆盖率（0.0~1.0）
  int wisdomScore(double thirtyDayCoverage, int capForStage) =>
      _capByStage(_coverageToWis(thirtyDayCoverage), capForStage);

  /// CHA：心情 + 阶段组合映射
  int charismaScore(int capForStage) =>
      _capByStage(_moodAndStageToCha(computedMood, displayStage), capForStage);

  // --- 内联公式（私有辅助函数）---

  static int _minutesToStr(int minutes) => (10 + minutes ~/ 120).clamp(10, 20);

  static int _completionToDex(double rate) {
    if (rate >= 0.95) return 18;
    if (rate >= 0.90) return 16;
    if (rate >= 0.75) return 14;
    if (rate >= 0.50) return 12;
    return 10;
  }

  static int _streakToCon(int days) => (10 + days ~/ 7).clamp(10, 20);

  static int _goalToInt(int goalMinutes) {
    if (goalMinutes >= 90) return 18;
    if (goalMinutes >= 60) return 16;
    if (goalMinutes >= 45) return 14;
    if (goalMinutes >= 30) return 12;
    return 10;
  }

  static int _coverageToWis(double coverage) {
    if (coverage >= 0.90) return 18;
    if (coverage >= 0.80) return 16;
    if (coverage >= 0.60) return 14;
    if (coverage >= 0.40) return 12;
    return 10;
  }

  static int _moodAndStageToCha(String mood, String stage) {
    const moodScore = {'happy': 2, 'neutral': 1, 'lonely': 0, 'missing': 0};
    const stageScore = {'adult': 2, 'adolescent': 1, 'kitten': 0};
    final total = (moodScore[mood] ?? 0) + (stageScore[stage] ?? 0);
    // total: 0~4 → 映射到 10~20
    return 10 + total * 2; // 范围：10, 12, 14, 16, 18, 20（最大 4×2+10=18，加阶段上限）
  }

  static int _capByStage(int raw, int cap) => raw.clamp(10, cap);
}
```

---

## 修正值（SRD 5.2.1 标准）

修正值（Modifier）由属性分（Score）按 SRD 公式推导：

```
modifier = floor((score - 10) / 2)
```

### 修正值对照表

| 属性分（Score） | 修正值（Modifier） |
|----------------|------------------|
| 10 | +0 |
| 11 | +0 |
| 12 | +1 |
| 13 | +1 |
| 14 | +2 |
| 15 | +2 |
| 16 | +3 |
| 17 | +3 |
| 18 | +4 |
| 19 | +4 |
| 20 | +5 |

```dart
/// SRD 5.2.1 修正值公式
int modifier(int score) => (score - 10) ~/ 2;
```

这个函数在 `lib/services/dice_engine_service.dart` 中作为工具函数暴露，供骰子检定计算调用。

---

## 阶段上限（Stage Cap）

猫咪的成长阶段（`cat.displayStage`，来自 `lib/models/cat.dart`）决定属性的最大值：

| 阶段（Stage） | 属性上限（Cap） | 修正值上限 | 对应 totalMinutes |
|-------------|--------------|----------|-----------------|
| kitten 幼猫 | 14 | +2 | 0–1199 分钟（0–19.9h） |
| adolescent 少年猫 | 17 | +3 | 1200–5999 分钟（20–99.9h） |
| adult 成年猫 | 20 | +5 | ≥6000 分钟（≥100h） |

**阶段上限的代码实现：**

上限值通过查表（`Map<String, int>`）获取，不用 if/else 链：

```dart
const _stageCap = {
  'kitten':     14,
  'adolescent': 17,
  'adult':      20,
};

int stageCapFor(Cat cat) => _stageCap[cat.displayStage] ?? 14;
```

这个辅助函数定义在 `lib/models/cat_abilities.dart` 的顶层，与 extension 同文件。

### 属性提升里程碑（ASI）

在冒险等级 4/8/12/16/19 时，用户可以选择：
- **属性提升**：一个属性永久 +1（上限 20，叠加在计算值之上）
- **专长**：获得一个被动效果（详见 [spec/05](05-party-and-class.md) §专长系统）

ASI 选择持久化在 PrimaryCat 模型中（新增 `asiChoices: Map<int, String>` 字段）。

> **SRD 对齐**：SRD 5.2.1 在 Level 4/8/12/16/19 提供 Ability Score Improvement。我们保留了相同的等级节点，但简化为 +1（SRD 原文是 +2/+1 二选一）。

### 设计意图

伙伴猫的属性公式与主哈基米不同，这是有意设计。伙伴猫的属性仅由其对应习惯的数据驱动，不受其他习惯影响。这确保每只猫都是其习惯的"忠实镜像"——运动猫的 STR 高说明用户运动做得好，而不是因为其他习惯拉高了平均值。

---

## 数值曲线

### STR（力量）—— 总时长驱动

公式：`STR = clamp(10 + totalMinutes ~/ 120, 10, stageCap)`

| STR 值 | 所需 totalMinutes | 等效小时数 | 修正值 |
|--------|-----------------|----------|-------|
| 10 | 0 | 0h | +0 |
| 12 | 240 | 4h | +1 |
| 14 | 480 | 8h（幼猫上限） | +2 |
| 17 | 840 | 14h（少年猫上限） | +3 |
| 20 | 1200 | 20h（需成年猫阶段） | +5 |

> 注意：STR 提升较快（对比综合研究报告 §10.3 的"70h→STR16"设定，此处采用设计文档 §3.1 的"每 120 分钟 +1"公式，后者更贴近实际进度节奏）。阶段上限是实际约束：幼猫最多 STR 14，少年猫最多 STR 17，即使时长超过阈值也不突破上限，直到进化到下一阶段。

### CON（体质）—— 连击天数驱动，曲线更陡

公式：`CON = clamp(10 + streakDays ~/ 7, 10, stageCap)`

| CON 值 | 所需连续天数 | 设计意图 |
|--------|-----------|---------|
| 10 | 0 天 | 初始值 |
| 12 | 14 天 | 两周里程碑 |
| 14 | 28 天 | 月度里程碑（幼猫上限） |
| 17 | 49 天 | 七周（少年猫上限） |
| 20 | 70 天 | 需成年猫阶段，约两个半月 |

**曲线设计原则：**

- **前期快速成长**：10→14 相对容易，给予早期正反馈（约 28 天）
- **后期指数放缓**：17→20 需要极大投入（连续 70 天 + 必须是成年猫），保证长期追求
- 参考 SRD XP 表设计思路：前几级升得快，后续越来越慢

### WIS（感知）—— 覆盖率分段

| WIS 值 | 30 天覆盖率 | 语义 |
|--------|-----------|------|
| 10 | < 40% | 不规律 |
| 12 | ≥ 40% | 偶尔 |
| 14 | ≥ 60% | 一般 |
| 16 | ≥ 80% | 良好 |
| 18 | ≥ 90% | 优秀（少年猫上限 17，受阶段约束） |
| 20 | — | 需成年猫，且覆盖率 ≥ 90% |

---

## 新增 Service 依赖

以下 3 个 Service 为**纯计算服务**：无网络调用、无副作用、只读 SQLite，可在任意 Provider 中直接调用。

### CompletionRateService

**文件：** `lib/services/completion_rate_service.dart`

**职责：** 从 `local_sessions` 查询指定猫咪最近 N 次专注记录，计算 `completionRatio` 的均值。

```dart
class CompletionRateService {
  final LocalDatabaseService _db;
  const CompletionRateService(this._db);

  /// 返回 [catId] 猫咪最近 [lastN] 条已完成 session 的 completionRatio 均值。
  /// 若无记录则返回 0.0。
  Future<double> averageForCat(String catId, {int lastN = 30}) async { ... }

  /// 返回所有猫咪合并后最近 [lastN] 条的 completionRatio 均值（供 PrimaryCat 使用）。
  Future<double> averageForAllCats({int lastN = 30}) async { ... }
}
```

**SQL 依据（`local_sessions` 表）：**

```sql
SELECT AVG(completion_ratio)
FROM (
  SELECT completion_ratio
  FROM local_sessions
  WHERE cat_id = ? AND status = 'completed'
  ORDER BY ended_at DESC
  LIMIT 30
);
```

**边界处理：**

- `goal_minutes = 0`：`completionRatio` 在写入时已被设为 `1.0`，此处无需特殊处理
- 查询结果为空（猫咪还没有任何 session）：返回 `0.0`，对应 DEX = 10

---

### StreakService

**文件：** `lib/services/streak_service.dart`

**职责：** 从 `local_sessions` 计算指定习惯（或所有习惯）的最长连续打卡天数。

```dart
class StreakService {
  final LocalDatabaseService _db;
  const StreakService(this._db);

  /// 返回 [habitId] 习惯的当前连续打卡天数（截止到今日）。
  /// "打卡"定义：该日期内有至少 1 条 status='completed' 的 session。
  Future<int> currentStreakForHabit(String habitId) async { ... }

  /// 返回所有习惯中最长的连续打卡天数（供 PrimaryCat CON 计算使用）。
  Future<int> longestAcrossAllHabits(String uid) async { ... }
}
```

**算法说明：**

1. 查询该习惯所有 `status = 'completed'` 的 session，提取 `ended_at` 日期（本地时区，格式 `yyyy-MM-dd`）
2. 去重为日期集合（Set），按降序排列
3. 从最新日期向过去遍历，计算连续天数（相邻两天差值为 1）
4. 遇到断层即停止，返回连续计数

**时区处理：** 使用设备本地时区（`DateTime.now().toLocal()`），`ended_at` 存储为 `millisecondsSinceEpoch`，转换时用 `.toLocal()` 确保与用户日历对齐。

---

### CoverageService

**文件：** `lib/services/coverage_service.dart`

**职责：** 计算过去 30 天内，有至少 1 条 session 的天数占比（供 WIS 和 PrimaryCat WIS 计算）。

```dart
class CoverageService {
  final LocalDatabaseService _db;
  const CoverageService(this._db);

  /// 返回过去 30 个自然日中有专注记录的天数 / 30（0.0~1.0）。
  /// [catId] 可选：传入则只统计该猫，null 则统计所有猫（供 PrimaryCat 使用）。
  Future<double> coverageLastThirtyDays(String uid, {String? catId}) async { ... }
}
```

**SQL 依据：**

```sql
SELECT COUNT(DISTINCT DATE(ended_at / 1000, 'unixepoch', 'localtime'))
FROM local_sessions
WHERE uid = ?
  AND (cat_id = ? OR ? IS NULL)
  AND ended_at >= ?  -- 30 天前的 epoch ms
  AND status = 'completed';
```

**边界处理：** 部分月份不足 30 天（即不存在"30 天前"到今天有 31 天的情况）—— 固定取 **30 个自然日**，无需按月计算。

---

## 技术实现要点

### Extension 调用约定

`CompanionCatAbilities` 的方法需要外部注入运行时数据（避免 extension 内部异步查询）。Provider 层负责在调用前将数据准备好：

```dart
// 在 cat_provider.dart 或专用 Provider 中：
final cat = ref.watch(catByIdProvider(catId));
final avgRate = await completionRateService.averageForCat(catId);
final streak = await streakService.currentStreakForHabit(cat.boundHabitId);
final coverage = await coverageService.coverageLastThirtyDays(uid, catId: catId);
final cap = stageCapFor(cat);

final str = cat.strengthScore(cap);
final dex = cat.dexterityScore(avgRate, cap);
final con = cat.constitutionScore(streak, cap);
final int_ = cat.intelligenceScore(habit.goalMinutes, cap);
final wis = cat.wisdomScore(coverage, cap);
final cha = cat.charismaScore(cap);
```

### 不修改 Cat 模型的保证

`extension CompanionCatAbilities on Cat`：

- 不添加任何存储字段
- 不重写 `toSqlite`、`toFirestore`、`fromSqlite`、`fromFirestore`
- 不在 `Cat.copyWith` 中引入新参数

---

## 验收标准

- [ ] STR 边界：`totalMinutes = 0` → STR = 10；`totalMinutes = 1200` 且为幼猫 → STR = 14（受 cap 限制，不超过 14）
- [ ] STR 边界：`totalMinutes = 24000` 且为成年猫 → STR = 20（clamp 生效，不超过 20）
- [ ] DEX 边界：`avgCompletionRate = 0.0` → DEX = 10；`= 1.0` → DEX = 18（受阶段上限约束）
- [ ] `goalMinutes = 0` 的 session `completionRatio` 在 `CompletionRateService` 中被正确处理（不出现 NaN 或除零）
- [ ] 阶段上限严格执行：幼猫任意属性不超过 14，即使底层公式返回更高的值
- [ ] SRD 修正值公式：STR=20→+5，STR=10→+0，STR=11→+0，STR=13→+1（整除行为正确）
- [ ] `CompletionRateService`：无 session 时返回 `0.0`（不崩溃）
- [ ] `StreakService`：跨时区切换时（`ended_at` 时区转换）连击天数计算正确
- [ ] `StreakService`：中间断一天即停止计数（不跳过断层）
- [ ] `CoverageService`：查询范围精确为 30 个自然日，不多不少
- [ ] `modifier(10) == 0`，`modifier(20) == 5`，`modifier(11) == 0`，`modifier(13) == 1`（1000 次随机属性分单元测试）
- [ ] Extension 方法不触发 `toSqlite`/`toFirestore`（序列化测试：Cat 序列化前后字段一致）
