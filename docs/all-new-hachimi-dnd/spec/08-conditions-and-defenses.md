# 状态效果与防御检定规格书（Conditions & Defenses Specification）

> SSOT for 状态效果（Conditions）、豁免检定（Saving Throws）、环境效果（Environmental Effects）的完整行为规格。
> **Status:** Draft
> **Phase:** 2（状态效果 + 豁免检定 + 环境效果）
> **Evidence:** SRD 5.2.1 Ch.01（Playing the Game）、Ch.08（Rules Glossary — Conditions）、Ch.09（Gameplay Toolbox — Environmental Effects）
> **Related:** [spec/03-dice-engine.md](03-dice-engine.md)、[spec/04-adventure.md](04-adventure.md)、[spec/05-party-and-class.md](05-party-and-class.md)、[spec/10-rest-and-rhythm.md](10-rest-and-rhythm.md)
> **Changelog:**
> - 2026-03-15 — 初版：8 种适配状态、豁免检定变体、6 种环境修正器

---

## 1. 概述

本规格定义三个紧密关联的子系统：

1. **状态效果（Conditions）**：冒险进行中临时附加在队伍上的 Buff / Debuff
2. **豁免检定（Saving Throws）**：区别于普通属性检定的防御型场景事件
3. **环境效果（Environmental Effects）**：场景卡级别的全局修正器

三者共同构成冒险的"战术层"，让检定不再只是"掷骰子看数字"，而是有策略、有变化、有反馈的完整体验。

### 1.1 核心约束

- **零惩罚原则**：所有负面状态必须 ① 效果轻微（最大 -1 或单次劣势） ② 持续极短（1-2 个事件） ③ 可被短休/药水清除
- **正面为主**：8 种状态中正面 5 种、负面 3 种，正面状态触发频率远高于负面
- **无永久效果**：所有状态在冒险结束时强制清除，不跨冒险持续

---

## 2. 状态效果系统（Conditions）

### 2.1 状态一览

#### 正面状态（5 种）

| 状态 | 代码值 | SRD 灵感 | 效果 | 触发条件 | 持续 |
|------|--------|---------|------|---------|------|
| 受鼓舞 | `inspired` | Charmed | 下次检定获得 **优势**（Advantage） | CHA 检定大成功 / Bard 职业被动 | 1 次检定后消失 |
| 专注 | `focused` | Concentration | INT / WIS 检定 **+2** | 健康类习惯连续完成 ≥ 14 天 | 整次冒险 |
| 充能 | `energized` | 原创 | 所有检定 **+1** | 长休触发（Full House） | 3 个事件 |
| 幸运 | `lucky` | Lucky feat | 可 **重投** 1 次失败的检定 | Lucky 专长 / 幸运药水 | 1 次使用后消失 |
| 祝福 | `blessed` | Protection | 忽略下次失败（**自动转为成功**） | Cleric 职业被动 / 祝福药水 | 1 次使用后消失 |

#### 负面状态（3 种）

| 状态 | 代码值 | SRD 灵感 | 效果 | 触发条件 | 持续 | 清除方式 |
|------|--------|---------|------|---------|------|---------|
| 疲惫 | `exhausted` | Exhaustion Lv1 | 下次检定 **-1** | 连续 ≥ 3 天未完成任何习惯 | 1 个事件后自动清除 | 短休 / 治愈药水 |
| 惊吓 | `frightened` | Frightened | 下次检定获得 **劣势**（Disadvantage） | Legendary 难度环境事件 / 特定陷阱 | 1 个事件后自动清除 | 勇气药水 |
| 中毒 | `poisoned` | Poisoned | 所有检定 **-1** | 陷阱失败（毒针锁等） | 2 个事件后自动清除 | 短休 / 治愈药水 |

### 2.2 状态堆叠规则

- **同名状态不叠加**：获得已有的状态 → 刷新持续时间（取较长者）
- **不同状态可共存**：例如同时拥有 `energized`（+1）和 `poisoned`（-1）→ 效果抵消
- **优势/劣势互相抵消**：`inspired`（优势）+ `frightened`（劣势）= 正常掷骰（SRD 规则）
- **数值修正累加**：`energized`（+1）+ `focused`（+2）= +3（但 `poisoned`（-1）可抵消其中 1 点）

### 2.3 数据模型

```dart
class ActiveCondition {
  final String id;                // UUID
  final String conditionType;     // 'inspired' | 'focused' | 'energized' | 'lucky' | 'blessed' | 'exhausted' | 'frightened' | 'poisoned'
  final int remainingEvents;      // 正数 = 剩余 N 个事件后消失; -1 = 持续到冒险结束; 0 = 下次检定后消失
  final bool isPositive;          // true = buff, false = debuff（用于 UI 排序）
  final DateTime appliedAt;       // 获得时间
}
```

**存储位置：**
- **AdventureProgress 内嵌**：`activeConditions: List<ActiveCondition>` 字段
- 不单独持久化——状态仅在冒险进行中存在，冒险结束时清空
- Firestore / SQLite 均通过 `adventure_progress` 记录的 JSON 序列化字段存储

### 2.4 状态与检定公式的集成

更新 `spec/03-dice-engine.md` 中的检定公式：

```
// 原公式
Total = d20（含保底）+ 属性修正 + 熟练加值 + 固定加值

// 新公式
Total = d20（含保底）+ 属性修正 + 熟练加值 + 固定加值 + 状态修正值（conditionModifier）

其中 conditionModifier = sum(所有数值型状态效果)
例：energized(+1) + focused(+2) + poisoned(-1) = conditionModifier = +2
```

**优势/劣势型状态** 不影响 `conditionModifier`，而是影响骰子投掷方式（2d20 取高/低）。

### 2.5 状态获取与清除时序

```
┌────────────────────────────────────────────────┐
│ 冒险开始前                                       │
│  → 检查长休状态 → 若有效：附加 energized          │
│  → 检查连续未完成天数 → 若 ≥3：附加 exhausted     │
│  → 检查习惯连续天数 → 若 ≥14（健康类）：附加 focused │
│  → 检查职业被动 → Bard: inspired / Cleric: blessed │
│  → 用户使用药水 → 附加对应正面状态                 │
└────────────────────────────────────────────────┘
           │
┌──────────▼─────────────────────────────────────┐
│ 每个事件结算后                                    │
│  → 减少所有 remainingEvents > 0 的状态计数         │
│  → 移除 remainingEvents == 0 的状态               │
│  → 如事件结果附加新状态（陷阱失败 → poisoned 等）   │
│  → 用户可选择使用药水清除负面状态                   │
└────────────────────────────────────────────────┘
           │
┌──────────▼─────────────────────────────────────┐
│ 冒险结束                                         │
│  → 强制清除所有状态                               │
│  → 状态不写入任何持久化存储                        │
└────────────────────────────────────────────────┘
```

---

## 3. 豁免检定（Saving Throws）

### 3.1 概念

SRD 区分两类 d20 检定：
- **属性检定（Ability Check）**：主动行为 → "你能做到吗？"
- **豁免检定（Saving Throw）**：被动防御 → "你能抵挡住吗？"

在 Hachimi 中，豁免检定是 `SceneEvent` 的一种子类型（`type: 'saving_throw'`），与普通属性检定共享同一个骰子引擎，但在以下方面有区别：

### 3.2 与普通检定的区别

| 维度 | 普通检定（Ability Check） | 豁免检定（Saving Throw） |
|------|------------------------|----------------------|
| 叙事语气 | "你能攀上这面墙吗？" | "一块巨石滚来，你能躲开吗？" |
| 触发方式 | 主动行为（攀爬、说服、解谜） | 被动防御（躲避、抵抗、意志） |
| 熟练来源 | 技能熟练（Phase 3+ 的 12 技能） | **职业豁免熟练**（每职业 2 个） |
| 视觉标识 | ⚔️ 剑 icon | 🛡️ 盾 icon |
| 公式 | d20 + ability mod + proficiency（若技能熟练）+ bonuses | d20 + ability mod + proficiency（若职业豁免熟练）+ bonuses |

### 3.3 职业豁免熟练表

| 职业 | 豁免熟练 1 | 豁免熟练 2 | 设计理由 |
|------|-----------|-----------|---------|
| Ranger（游侠） | STR | DEX | 体能型，擅长闪避和力量抵抗 |
| Wizard（法师） | INT | WIS | 心智型，擅长智力和意志抵抗 |
| Cleric（牧师） | WIS | CHA | 信仰型，擅长意志和灵魂抵抗 |
| Bard（诗人） | DEX | CHA | 灵巧型，擅长闪避和魅力抵抗 |
| Rogue（盗贼） | DEX | INT | 敏捷型，擅长闪避和机智抵抗 |
| Fighter（战士） | STR | CON | 刚毅型，擅长力量和耐力抵抗 |

> 此表需同步写入 `spec/05-party-and-class.md` §8 节

### 3.4 SceneEvent 类型扩展

```dart
class SceneEvent {
  final String id;
  final String ability;     // 检定属性：'STR' | 'DEX' | 'CON' | 'INT' | 'WIS' | 'CHA'
  final int dc;             // 难度等级
  final String prompt;      // 事件描述文本
  final String successText; // 成功叙事
  final String failText;    // 失败叙事

  // === 新增字段 ===
  final String type;        // 'ability_check'（默认）| 'saving_throw' | 'trap'
}
```

### 3.5 豁免检定的业务价值

豁免检定让 **职业选择** 产生真实的策略意义：

- 选择 Fighter 的玩家在 STR / CON 豁免事件中自动加熟练加值
- 选择 Wizard 的玩家在 INT / WIS 豁免事件中更有优势
- 这意味着不同职业在同一场景中的体验不同，增加重玩价值

**建议比例**：每个场景卡的事件池中，约 30% 为豁免检定事件，70% 为普通属性检定。

---

## 4. 环境效果（Environmental Effects）

### 4.1 概念

SRD 定义了多种环境危害（Extreme Cold、Heavy Rain、Strong Wind 等），在 Hachimi 中适配为 **场景卡级别的全局修正器**——进入某个场景卡后，该场景的所有事件都受到环境影响。

### 4.2 环境修正器表

| 环境标签 | 代码值 | 适用场景 | 效果 | 叙事文本 |
|---------|--------|---------|------|---------|
| 极寒 | `extreme_cold` | 迷雾森林 Lv5+、古代遗迹 Lv10+ | CON 检定 **-1** | "刺骨的寒风让每一步都更艰难" |
| 酷热 | `extreme_heat` | 猫镇集市（夏季变体） | CON 检定 **-1** | "烈日炙烤着石板路" |
| 暴雨 | `heavy_rain` | 迷雾森林（雨季变体） | WIS 检定 **-1** | "倾盆大雨模糊了视线" |
| 强风 | `strong_wind` | 瞭望塔、浮空桥 | DEX 检定 **-1** | "狂风让每次跳跃都充满未知" |
| 昏暗 | `dim_light` | 蘑菇洞穴、封印之门 | INT 检定 **-1** | "昏暗中难以辨认文字" |
| 圣地 | `blessed_ground` | 精灵之泉 | WIS 检定 **+1** | "神圣的气息让心灵更加清明" |

### 4.3 设计约束

- 每张场景卡最多 **1 个** 环境标签（不叠加）
- 环境修正最大为 **±1**（不会出现 -2 或更大的修正）
- 负面环境仅影响 **单一属性**，不是全属性 penalty
- 至少 1 种正面环境（`blessed_ground`），确保"环境不总是坏事"
- 环境标签在场景卡选择界面即可看到，玩家可据此调整队伍

### 4.4 SceneCard 数据模型扩展

```dart
class SceneCard {
  // ... existing fields
  final String? environment; // null = 无环境效果; 'extreme_cold' | 'extreme_heat' | ...
}
```

### 4.5 环境效果与检定公式的集成

环境修正在 `DiceEngineService.performCheck()` 中作为 `environmentModifier` 参与计算：

```
Total = d20 + abilityMod + proficiencyBonus + flatBonuses + conditionModifier + environmentModifier
```

`environmentModifier` 仅在检定属性与环境影响属性匹配时生效。例如：
- 场景环境 = `heavy_rain`（WIS -1）
- 当前事件检定属性 = WIS → environmentModifier = -1
- 当前事件检定属性 = STR → environmentModifier = 0（不影响）

### 4.6 环境与远程配置

环境标签通过 Remote Config 可动态更新：
- 可添加季节性环境变体（春季 → blessed_ground，冬季 → extreme_cold）
- 可为节日活动添加特殊环境（"星光之夜" → 所有检定 +1）

---

## 5. 三系统交互矩阵

| 系统 A | 系统 B | 交互方式 |
|--------|--------|---------|
| 状态效果 | 骰子引擎 | conditionModifier 参与检定公式 |
| 状态效果 | 短休/长休 | 短休清除 1 个负面；长休清除全部 + 附加 energized |
| 状态效果 | 药水 | 治愈药水清除 poisoned/exhausted；专注药水附加 focused |
| 状态效果 | 陷阱 | 陷阱失败附加 poisoned / frightened / exhausted |
| 状态效果 | 职业被动 | Bard 冒险开始附加 inspired；Cleric 附加 blessed |
| 豁免检定 | 职业系统 | 职业决定豁免熟练（加熟练加值） |
| 豁免检定 | 陷阱 | 陷阱触发后的抵抗阶段使用豁免检定 |
| 环境效果 | 骰子引擎 | environmentModifier 参与检定公式 |
| 环境效果 | 场景卡 | 每张场景卡最多 1 个环境标签 |

---

## 6. UI 指引

### 6.1 状态效果显示

- **冒险界面顶部**：水平图标条，显示当前所有活跃状态
  - 正面状态：绿色/蓝色图标 + 剩余次数徽章
  - 负面状态：红色/紫色图标 + 剩余次数徽章
- **掷骰结果界面**：显示状态对本次检定的具体影响（"+1 from Energized"、"-1 from Poisoned"）

### 6.2 豁免检定显示

- 事件卡标题旁显示 🛡️ 盾牌图标（区别于普通检定的 ⚔️ 剑图标）
- 检定结果显示"豁免成功！"/"未能抵挡"（区别于"检定成功！"/"检定失败"）

### 6.3 环境效果显示

- 场景卡选择界面：环境标签以 chip 形式显示在场景卡下方（如 ❄️ 极寒、🌧️ 暴雨）
- 冒险进行中：顶部状态条旁显示当前环境图标

---

## 7. 验证要点

- [ ] 8 种状态的触发、效果、持续、清除逻辑均可从本文档推导
- [ ] 豁免检定公式与 `spec/03-dice-engine.md` 的检定公式兼容
- [ ] 环境修正器仅影响匹配属性，不影响其他属性
- [ ] 所有负面状态均有至少 2 种清除途径（自动消失 + 药水/短休）
- [ ] 无任何永久性负面效果
