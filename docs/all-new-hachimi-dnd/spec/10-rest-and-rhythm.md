# 休息与节奏规格书（Rest & Rhythm Specification）

> SSOT for 短休（Short Rest）、长休（Long Rest）与日常习惯节奏的映射关系。
> **Status:** Draft
> **Phase:** 2
> **Evidence:** SRD 5.2.1 Ch.01（Playing the Game — Resting）
> **Related:** [spec/08-conditions-and-defenses.md](08-conditions-and-defenses.md)、[spec/05-party-and-class.md](05-party-and-class.md)、[spec/06-economy.md](06-economy.md)、[spec/09-inventory-and-items.md](09-inventory-and-items.md)
> **Changelog:**
> - 2026-03-15 — 初版：短休/长休映射、效果定义、计算型 Provider 设计

---

## 1. 概述

SRD 的休息系统（Short Rest / Long Rest）是角色恢复资源的核心节奏。在 Hachimi 中，这一系统完美映射到习惯完成的日常节奏：

| SRD 概念 | Hachimi 映射 | 触发条件 |
|---------|-------------|---------|
| Short Rest（短休息，1 小时） | 短休 | 完成一次专注时段（≥ 25 分钟） |
| Long Rest（长休息，8 小时） | 长休 | Full House（当天所有习惯至少完成 1 次） |

**核心设计原则：** 休息 **只有正面效果**。缺少休息不会产生惩罚——用户只是无法获得休息带来的增益。

---

## 2. 短休（Short Rest）

### 2.1 触发条件

用户完成一次 ≥ 25 分钟的专注时段（`FocusSession.status == 'completed'`）时，系统自动触发短休。

**限制：** 每天最多触发 **3 次** 短休效果（防止刷次数）。第 4 次及之后的专注仍正常记录经验和金币，但不再触发额外短休效果。

### 2.2 效果

| # | 效果 | 条件 | 说明 |
|---|------|------|------|
| 1 | 清除 1 个负面状态 | 存在活跃负面状态时 | 按优先级清除：exhausted > poisoned > frightened |
| 2 | 伙伴猫心情恢复 | 伙伴猫处于 lonely 或 missing 时 | 复用现有 `lastSessionAt` 机制，短休叙事包装 |
| 3 | 充能物品恢复 1 点 | 持有"每短休充能"物品时 | Phase 3 功能，预留接口 |

### 2.3 叙事表现

专注完成界面增加一行 DnD 风味文本（位于现有奖励信息下方）：

```
┌─────────────────────────────────────┐
│ 🎯 专注完成！获得 50 金币 + 1 骰子    │
│                                     │
│ ⛺ 短休生效                          │
│   ✓ 疲惫状态已清除                    │
│   ✓ [猫名] 心情好转了                 │
└─────────────────────────────────────┘
```

如果没有可清除的状态或可恢复的心情，则显示：

```
│ ⛺ 短暂休息 — 精力充沛，准备继续冒险    │
```

---

## 3. 长休（Long Rest）

### 3.1 触发条件

当天所有活跃习惯均至少完成 1 次专注时段（即 Full House）**且** 跨过午夜（00:00）时，长休生效。

**触发时机：** 两种场景
1. **实时触发**：用户在当天内完成最后一个习惯时，立即显示长休通知
2. **延迟触发**：用户在第二天首次打开 App 时，显示"昨日长休"回顾

### 3.2 效果

| # | 效果 | 说明 |
|---|------|------|
| 1 | 清除 **所有** 负面状态 | 无论数量，一次性清空 |
| 2 | 附加「充能」状态（Energized） | 所有检定 +1，持续 3 个事件（下次冒险生效） |
| 3 | 重置"每长休 1 次"能力 | Lucky 专长重投、Bard CHA 自动优势、Ranger 额外掉落 |
| 4 | 发放 Full House 金币奖励 | 复用现有 20🪙 奖励，叙事包装为"长休奖金" |
| 5 | 触发被动感知发现事件 | 酒馆中发现隐藏物品（Trinket / 金币）的概率检查 |

### 3.3 被动感知发现事件

长休触发后，系统自动进行一次被动感知检查：

```
被动感知 = 10 + WIS 修正 + 熟练加值（若 WIS 豁免熟练）

若 被动感知 ≥ 隐藏 DC（随机 12-16）：
  → 发现隐藏物品（70% Trinket、20% 金币 10-50、10% 药水）
  → 显示发现通知

若 被动感知 < 隐藏 DC：
  → 无事发生，不显示任何提示（玩家不知道错过了什么）
```

### 3.4 叙事表现

长休通知（App 内横幅或 Tab 2 酒馆特效）：

```
┌─────────────────────────────────────┐
│ 🏰 长休 — 完美的一天！               │
│                                     │
│ ✓ 所有负面状态已清除                  │
│ ✓ 获得「充能」+1 所有检定（3 事件）    │
│ ✓ 所有能力已重置                     │
│ ✓ 获得 20 金币长休奖金                │
│                                     │
│ 🔍 你在酒馆角落发现了什么...           │
│   「会微微发光的蘑菇」已加入收藏！     │
└─────────────────────────────────────┘
```

---

## 4. 技术方案

### 4.1 RestState（计算型，非持久化）

```dart
/// 从现有数据推导的休息状态，不需要额外持久化字段
class RestState {
  final DateTime? lastShortRestAt;  // 最近一次短休时间
  final int shortRestCountToday;    // 今日短休次数（0-3）
  final DateTime? lastLongRestAt;   // 最近一次长休时间
  final bool isLongRestActive;      // 长休是否在有效期内
  final bool hasEnergyBuff;         // 是否持有长休附加的 energized 状态
}
```

### 4.2 Provider 设计

```dart
/// restStateProvider — 从现有数据推导，无额外存储
final restStateProvider = Provider<RestState>((ref) {
  final sessions = ref.watch(todayFocusSessionsProvider);
  final habits = ref.watch(activeHabitsProvider);

  // 短休：今日完成的 ≥25min 专注次数（max 3）
  final completedSessions = sessions.where((s) => s.status == 'completed' && s.durationMinutes >= 25);
  final shortRestCount = completedSessions.length.clamp(0, 3);
  final lastShort = completedSessions.isEmpty ? null : completedSessions.last.completedAt;

  // 长休：今日所有活跃习惯均完成 ≥1 次
  final allHabitsCompleted = habits.every((h) =>
    sessions.any((s) => s.habitId == h.id && s.status == 'completed'));
  final isLongRest = allHabitsCompleted && habits.isNotEmpty;

  return RestState(
    lastShortRestAt: lastShort,
    shortRestCountToday: shortRestCount,
    lastLongRestAt: isLongRest ? DateTime.now() : null,
    isLongRestActive: isLongRest,
    hasEnergyBuff: isLongRest, // energized 状态在下次冒险开始时附加
  );
});
```

### 4.3 与现有系统的集成点

| 集成点 | 位置 | 修改 |
|--------|------|------|
| 专注完成回调 | `FocusTimerService.onSessionComplete()` | 检查短休触发 → 清除 1 个负面状态 |
| Full House 检测 | `HabitCompletionProvider` | 检查长休触发 → 附加 energized + 发现事件 |
| 冒险开始 | `AdventureService.startAdventure()` | 读取 RestState → 附加 energized 到 AdventureProgress |
| 能力重置 | `DiceEngineService.performCheck()` | 读取"每长休 1 次"能力是否已使用 |

---

## 5. 休息频率与经济平衡

### 5.1 预估频率

| 用户类型 | 每日短休 | 每周长休 | 每周 energized 冒险 |
|---------|---------|---------|-------------------|
| 轻度用户（1 个习惯） | 1 次 | 5-7 次 | 5-7 次 |
| 中度用户（3 个习惯） | 2-3 次 | 3-5 次 | 3-5 次 |
| 重度用户（5+ 个习惯） | 3 次（上限） | 2-3 次 | 2-3 次 |

**设计意图：** 习惯越多 → 长休越难触发（因为需要全部完成）→ energized buff 更珍贵 → 激励完成 **所有** 习惯而非只做容易的。

### 5.2 与经济系统的关系

- 短休本身不产生金币（金币来自专注本身）
- 长休奖金 = 现有 Full House 20🪙 奖励（不增加额外收入）
- 长休发现事件可能产出 Trinket 或 10-50🪙（平均 ~15🪙/天，对经济影响有限）

---

## 6. 验证要点

- [ ] 短休触发条件与现有 `FocusSession` 完成机制兼容
- [ ] 长休触发条件与现有 Full House 检测逻辑一致
- [ ] RestState 可完全从现有数据推导，无需新持久化字段
- [ ] energized 状态与 `spec/08-conditions-and-defenses.md` 定义一致
- [ ] 每日短休上限（3 次）防止滥用
- [ ] 长休发现事件的 Trinket 产出与 `spec/09-inventory-and-items.md` 兼容
