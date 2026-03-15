# 社交与背景出身规格书（Social & Origins Specification）

> SSOT for 背景出身系统（Backgrounds）、酒馆 NPC 态度系统（NPC Attitudes）。
> **Status:** Draft
> **Phase:** 3（背景出身 + NPC 态度系统）
> **Evidence:** SRD 5.2.1 Ch.04（Character Origins — Backgrounds）、Ch.01（Social Interaction — NPC Attitudes）
> **Related:** [spec/01-primary-cat.md](01-primary-cat.md)、[spec/06-economy.md](06-economy.md)、[spec/07-ui-and-navigation.md](07-ui-and-navigation.md)、[spec/09-inventory-and-items.md](09-inventory-and-items.md)
> **Changelog:**
> - 2026-03-15 — 初版：4 种背景、6 位酒馆 NPC、友谊机制、Onboarding 流程更新

---

## 1. 概述

本规格定义两个子系统：

1. **背景出身（Backgrounds）**：主哈基米创建时选择的"前世"，提供小幅属性加成 + 起始 Trinket + 叙事个性化（**Phase 1**）
2. **NPC 态度系统（NPC Attitudes）**：酒馆中的常驻 NPC，通过社交互动建立友谊，解锁折扣、任务和独家物品（**Phase 3**）

---

## Part A：背景出身系统（Phase 1）

## 2. 概念

SRD 中的 Background 代表角色冒险前的经历，提供属性加成、专长和技能熟练。在 Hachimi 中简化为 **轻量化选择**：

- +1 单一属性加成
- 1 件起始 Trinket（风味物品 + 微增益）
- 建议习惯类别（仅建议，无强制）

**设计原则：** 所有背景等价 — 没有"最优选择"，纯粹基于角色扮演偏好。

---

## 3. 背景列表

| 背景 | 代码值 | SRD 灵感 | 属性加成 | 起始 Trinket | 建议习惯类别 | 风味描述 |
|------|--------|---------|---------|-------------|------------|---------|
| 学者 | `scholar` | Sage | INT +1 | 「落满灰尘的笔记本」（+1 金币/次专注） | 心智 | "你曾在古老的图书馆中度过无数个夜晚" |
| 运动员 | `athlete` | Soldier | STR +1 | 「幸运手环」（+2% Trinket 发现率） | 体能 | "你的身体是最好的武器" |
| 治愈者 | `healer` | Acolyte | WIS +1 | 「草药香囊」（+1 星尘/次冒险） | 健康 | "你天生感知周围的生命力" |
| 表演者 | `performer` | Bard-flavored | CHA +1 | 「银色小铃铛」（纯风味无效果） | 社交 | "你的声音能让暴风雨中的海浪也安静下来" |

### 3.1 属性加成规则

- 背景 +1 与原型（Archetype）+2 叠加，但单属性不超过初始上限
- 例：选择 Action 原型（STR/DEX +2）+ Athlete 背景（STR +1）→ STR 起始 = 10 + 2 + 1 = 13

### 3.2 PrimaryCat 模型扩展

```dart
class PrimaryCat {
  // ... existing fields (id, userId, name, archetype, appearance, playerClass)
  final String background; // 'scholar' | 'athlete' | 'healer' | 'performer'
}
```

**SQLite**：`local_primary_cat` 表增加 `background TEXT NOT NULL` 列
**Firestore**：`users/{uid}/primaryCat` 增加 `background` 字段

---

## 4. Onboarding 流程更新

```
原流程：
  选择原型（Action/Mind/Harmony）→ 输入名字 → 初始对话 → 创建习惯 → 主页

新流程：
  选择原型（Action/Mind/Harmony）
  → 选择背景（Scholar/Athlete/Healer/Performer） ← 新增步骤
  → 输入名字
  → 初始对话（融入背景描述）
  → 创建第一个习惯（显示背景建议类别）
  → 主页
```

### 4.1 背景选择界面设计

```
┌─────────────────────────────────────┐
│ 你的过去塑造了你                     │
│                                     │
│ ┌─────────┐  ┌─────────┐           │
│ │ 📚      │  │ 🏃      │           │
│ │ 学者    │  │ 运动员  │           │
│ │ INT +1  │  │ STR +1  │           │
│ └─────────┘  └─────────┘           │
│                                     │
│ ┌─────────┐  ┌─────────┐           │
│ │ 🌿      │  │ 🎭      │           │
│ │ 治愈者  │  │ 表演者  │           │
│ └─────────┘  └─────────┘           │
│                                     │
│ [点击卡片查看详情]                   │
└─────────────────────────────────────┘
```

点击卡片展开显示：风味描述 + 属性加成 + 起始 Trinket 名称。

### 4.2 与初始对话的融合

背景选择影响主哈基米的第一句对话内容：

| 背景 | 初始对话（原型 Action 为例） |
|------|--------------------------|
| Scholar | "虽然我更喜欢用拳头解决问题...但不得不承认，在图书馆学到的东西偶尔也管用。" |
| Athlete | "准备好了吗？我从小就在跑道上长大，没有什么能阻止我们！" |
| Healer | "别看我动作大，其实我很擅长照顾伙伴的。来，让我看看你的状态。" |
| Performer | "嘿！我可不只是个打手——你应该听听我的即兴说唱！" |

---

## Part B：NPC 态度系统（Phase 3）

## 5. 概念

SRD 定义了 NPC 的三种态度：Friendly、Indifferent、Hostile。在 Hachimi 中：

- **只有 Indifferent 和 Friendly**（无 Hostile — 零惩罚原则）
- **友谊永不倒退**（进度只增不减）
- NPC 位于 Tab 2（酒馆），是酒馆生态的核心内容

---

## 6. NPC 列表

| NPC 名 | 代码值 | 主属性 | 角色描述 | Friendly 解锁 |
|--------|--------|--------|---------|-------------|
| 铁匠猫 | `blacksmith` | STR | 粗犷但热心的铁匠，打造最坚固的装备 | 装备折扣 10%、每日锻造任务 |
| 杂技猫 | `acrobat` | DEX | 身手敏捷的街头艺人 | 独家 Trinket「杂技猫的花环」、训练小游戏 |
| 厨师猫 | `chef` | CON | 酒馆的大厨，掌握各种食谱 | 独家药水配方（可制作）、免费小食（+1 金币） |
| 管理员猫 | `librarian` | INT | 安静的图书管理员，知道一切秘密 | 场景卡线索（预览事件）、智慧格言 |
| 占卜师猫 | `fortune_teller` | WIS | 神秘的占卜师，能看透表象 | 被动感知 **+1 永久加成**、预知下个事件 |
| 酒馆老板猫 | `tavern_keeper` | CHA | 酒馆的灵魂人物，认识所有人 | 所有 NPC 友谊进度 ×1.5、独家对话 |

---

## 7. 友谊机制

### 7.1 友谊积分

```
interact(npc, cost: 20🪙) → CHA 检定 vs DC 12
  成功 → 友谊 +15 点
  失败 → 友谊 +5 点（失败也有进度，只是慢）
  性格匹配 → 额外 +5 点（伙伴猫性格与 NPC 主属性匹配时）

每日与每位 NPC 互动上限：3 次
```

### 7.2 友谊阶段

| 积分范围 | 态度 | 效果 |
|---------|------|------|
| 0-49 | Indifferent（冷淡） | 可互动但无特殊奖励 |
| 50-99 | Friendly（友好） | 解锁该 NPC 的专属奖励 |
| 100 | Best Friend（挚友） | 解锁终极奖励（独家 Trinket + 永久增益） |

### 7.3 友谊积分估算

- 每日 3 次互动 × 20🪙 = 60🪙/天/NPC
- 每次平均 +12 点（加权：60% 成功率 × 15 + 40% × 5 + 30% 匹配 × 5）
- 达到 Friendly（50 点）≈ 5 天
- 达到 Best Friend（100 点）≈ 9 天

**经济影响：** 6 位 NPC 全部到 Friendly ≈ 30 天 × 60🪙 = 1,800🪙 总消耗，创造持续的金币需求。

---

## 8. 数据模型

```dart
class NpcFriendship {
  final String id;              // UUID
  final String uid;             // 用户 ID
  final String npcId;           // 'blacksmith' | 'acrobat' | 'chef' | ...
  final int friendshipPoints;   // 0-100
  final int interactionsToday;  // 今日已互动次数（每日重置）
  final DateTime lastInteractedAt;
}

// attitude 由 friendshipPoints 推导：
// <50 = 'indifferent', 50-99 = 'friendly', 100 = 'best_friend'
```

### 8.1 持久化

| 存储层 | 路径 |
|--------|------|
| SQLite | `local_npc_friendship` 表（6 行，每 NPC 一行） |
| Firestore | `users/{uid}/npcFriendships/{npcId}` |

```sql
CREATE TABLE local_npc_friendship (
  id                  TEXT PRIMARY KEY,
  uid                 TEXT NOT NULL,
  npc_id              TEXT NOT NULL,
  friendship_points   INTEGER NOT NULL DEFAULT 0,
  interactions_today  INTEGER NOT NULL DEFAULT 0,
  last_interacted_at  TEXT,
  UNIQUE(uid, npc_id)
);
```

---

## 9. NPC 互动 UI

### 9.1 酒馆 NPC 面板（Tab 2）

```
┌─────────────────────────────────────┐
│ 🍺 酒馆居民                         │
├─────────────────────────────────────┤
│ [铁匠猫头像]  铁匠猫      友好 ❤️    │
│  "嘿！今天要不要看看新打造的装备？"    │
│  [交谈 20🪙] [查看商品]              │
│                                     │
│ [厨师猫头像]  厨师猫      冷淡 💤    │
│  "...需要点什么吗？"                 │
│  [交谈 20🪙]                        │
│                                     │
│ [更多NPC...]                        │
└─────────────────────────────────────┘
```

### 9.2 互动流程

```
点击「交谈」→ 扣除 20🪙
  → CHA 检定动画（复用骰子引擎 UI）
  → 成功：NPC 高兴的对话 + 友谊 +15
  → 失败：NPC 礼貌的对话 + 友谊 +5
  → 匹配加成：额外 +5 + 特殊对话
  → 友谊变化动画（进度条 +N）
  → 若达到新阶段 → 弹出阶段解锁通知
```

---

## 10. NPC 解锁奖励详情

### 10.1 铁匠猫（STR）

| 阶段 | 奖励 |
|------|------|
| Friendly | 装备商店所有物品 **-10% 金币**；每日锻造任务（完成 → 1 矿石） |
| Best Friend | 独家 Trinket「铁匠的旧锤子」（STR 检定 +1，持续 1 事件/冒险）；解锁独家史诗装备配方 |

### 10.2 杂技猫（DEX）

| 阶段 | 奖励 |
|------|------|
| Friendly | 独家 Trinket「杂技猫的花环」（+3% Trinket 发现率）；解锁"敏捷训练"小游戏（完成 → 1 织物） |
| Best Friend | 独家 Trinket「空中飞人护符」（DEX 检定 +1，持续 1 事件/冒险） |

### 10.3 厨师猫（CON）

| 阶段 | 奖励 |
|------|------|
| Friendly | 解锁药水制作配方（可在制作台制作药水）；每日免费小食（+1🪙） |
| Best Friend | 独家 Trinket「厨师的秘方书」（药水效果持续 +1 事件）；解锁独家稀有药水配方 |

### 10.4 管理员猫（INT）

| 阶段 | 奖励 |
|------|------|
| Friendly | 场景卡线索：冒险开始前可预览 1 个事件的属性需求；每日智慧格言（无机制效果，纯风味） |
| Best Friend | 独家 Trinket「管理员的旧眼镜」（INT 检定 +1，持续 1 事件/冒险）；预览扩展为 2 个事件 |

### 10.5 占卜师猫（WIS）

| 阶段 | 奖励 |
|------|------|
| Friendly | **被动感知 +1 永久加成**（最有价值的 NPC 奖励）；可预知下个事件的 DC 范围 |
| Best Friend | 独家 Trinket「水晶球碎片」（WIS 检定 +1，持续 1 事件/冒险）；被动感知再 +1（累计 +2） |

### 10.6 酒馆老板猫（CHA）

| 阶段 | 奖励 |
|------|------|
| Friendly | 所有其他 NPC 的友谊进度 **×1.5**；独家酒馆老板对话（包含游戏提示和世界观故事） |
| Best Friend | 独家 Trinket「酒馆金钥匙」（每日签到金币 +5🪙）；解锁酒馆装饰更换功能 |

---

## 11. 两系统交互

| 背景 | NPC 交互加成 |
|------|-------------|
| Scholar | 与管理员猫互动时友谊 +3 额外点数 |
| Athlete | 与铁匠猫互动时友谊 +3 额外点数 |
| Healer | 与占卜师猫互动时友谊 +3 额外点数 |
| Performer | 与酒馆老板猫互动时友谊 +3 额外点数 |

> 背景选择在 Phase 1 做出，NPC 系统在 Phase 3 实装——但背景影响在 NPC 上线后自动生效，不需要回溯修改。

---

## 12. 验证要点

- [ ] 4 种背景的属性加成与原型加成可叠加且不超上限
- [ ] PrimaryCat 模型扩展与 spec/01 兼容
- [ ] Onboarding 新步骤不超过"5 步仪式"上限
- [ ] NPC 友谊只增不减（零惩罚）
- [ ] NPC 互动金币消耗与经济系统（spec/06）平衡
- [ ] 占卜师猫的被动感知 +1/+2 加成与被动感知公式兼容
- [ ] 所有独家 Trinket 已定义在 Trinket 列表中
