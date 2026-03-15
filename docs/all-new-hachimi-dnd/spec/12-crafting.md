# 制作系统规格书（Crafting System Specification）

> SSOT for 制作系统——材料获取、配方、制作进度、产出。
> **Status:** Draft
> **Phase:** 3+
> **Evidence:** SRD 5.2.1 Ch.10（Magic Items — Crafting Magic Items）
> **Related:** [spec/06-economy.md](06-economy.md)、[spec/09-inventory-and-items.md](09-inventory-and-items.md)、[spec/10-rest-and-rhythm.md](10-rest-and-rhythm.md)、[spec/11-social-and-origins.md](11-social-and-origins.md)
> **Changelog:**
> - 2026-03-15 — 初版：6 种材料、5 类配方、制作进度模型、产出规则

---

## 1. 概述

SRD 的制作系统要求 **时间 + 材料 + 工具熟练度** 三要素。在 Hachimi 中：

| SRD 要素 | Hachimi 映射 |
|---------|-------------|
| 时间（天数） | 专注时段次数（1 次专注 = 1 次制作进度） |
| 材料（金币 + 稀有材料） | 金币/星尘 + 制作材料（草药/织物/矿石/墨水/宝石/碎片） |
| 工具熟练度 | 习惯类别匹配（匹配时制作进度 ×1.5） |

**核心原则：**
- **制作永不失败**（零惩罚原则）
- 制作进度 = 完成专注时段，不需要额外操作
- 材料来自日常习惯完成（自然获取，不需要刻意刷）

---

## 2. 制作材料体系

### 2.1 材料类型

| 材料 | 代码值 | 获取来源 | 掉落条件 | Phase |
|------|--------|---------|---------|-------|
| 草药（Herb） | `herb` | 健康/养生类习惯专注 | 每次完成专注 20% 概率 | 3 |
| 织物（Fabric） | `fabric` | 社交/创意类习惯专注 | 每次完成专注 20% 概率 | 3 |
| 矿石（Ore） | `ore` | 体能/运动类习惯专注 | 每次完成专注 20% 概率 | 3 |
| 墨水（Ink） | `ink` | 学习/心智类习惯专注 | 每次完成专注 20% 概率 | 3 |
| 宝石（Gem） | `gem` | 冒险 3 星通关 | 100% 掉落 1 颗 | 3 |
| 碎片（Scrap） | `scrap` | 分解重复 Trinket | 1 Trinket → 1 碎片 | 3 |

### 2.2 习惯类别与材料映射

| 习惯类别 | 对应材料 | 匹配制作类别 |
|---------|---------|------------|
| 体能（physical） | 矿石 | 装备类配方 |
| 心智（mental） | 墨水 | 卷轴类配方（Phase 4 预留） |
| 健康（wellness） | 草药 | 药水类配方 |
| 社交（social） | 织物 | 配饰类配方 |
| 通用（general） | 随机（等概率） | 任意 |

### 2.3 材料存储

材料作为 `InventoryItem` 存储在统一库存系统中（`category: 'material'`）：

```dart
// 材料是 InventoryItem 的一种，quantity 可叠加
InventoryItem(
  itemDefId: 'material_herb',
  category: 'material',
  quantity: 5,  // 当前拥有 5 个草药
  equipped: false,
  // ...
)
```

### 2.4 材料获取频率估算

| 用户类型 | 每日专注次数 | 每日材料获取 | 每周材料 |
|---------|------------|------------|---------|
| 轻度（1 习惯，1 次/天） | 1 | ~0.2 个 | ~1.4 个 |
| 中度（3 习惯，1 次/天） | 3 | ~0.6 个 | ~4.2 个 |
| 重度（5 习惯，2 次/天） | 10 | ~2 个 | ~14 个 |

---

## 3. 配方系统

### 3.1 配方表

#### 药水类（对应 spec/09 药水列表）

| 配方名 | 代码值 | 材料消耗 | 所需专注次数 | 产出 |
|--------|--------|---------|------------|------|
| 制作治愈药水 | `recipe_potion_healing` | 15🪙 + 1 草药 | 1 次 | 1× 治愈药水 |
| 制作勇气药水 | `recipe_potion_courage` | 20🪙 + 1 草药 | 1 次 | 1× 勇气药水 |
| 制作专注药水 | `recipe_potion_focus` | 40🪙 + 2 草药 | 2 次 | 1× 专注药水 |
| 制作幸运药水 | `recipe_potion_luck` | 50🪙 + 1 宝石 | 2 次 | 1× 幸运药水 |
| 制作祝福药水 | `recipe_potion_blessing` | 100⭐ + 2 宝石 | 3 次 | 1× 祝福药水 |

#### 装备类

| 配方名 | 代码值 | 材料消耗 | 所需专注次数 | 产出 |
|--------|--------|---------|------------|------|
| 锻造普通装备 | `recipe_equip_common` | 100🪙 + 3 材料（任意） | 3 次 | 随机普通装备 |
| 锻造精良装备 | `recipe_equip_uncommon` | 200🪙 + 5 材料 + 1 宝石 | 5 次 | 可选择精良装备 |
| 锻造稀有装备 | `recipe_equip_rare` | 500🪙 + 10 材料 + 3 宝石 | 10 次 | 可选择稀有装备 |

#### Trinket 类

| 配方名 | 代码值 | 材料消耗 | 所需专注次数 | 产出 |
|--------|--------|---------|------------|------|
| 合成 Trinket | `recipe_trinket` | 30🪙 + 1 碎片 | 1 次 | 随机未拥有 Trinket |

#### NPC 解锁配方（通过 NPC Friendly 获得）

| 配方名 | 解锁条件 | 材料消耗 | 所需专注次数 | 产出 |
|--------|---------|---------|------------|------|
| 厨师秘方药水 | 厨师猫 Friendly | 30🪙 + 2 草药 | 1 次 | 1× 随机普通/精良药水 |
| 铁匠精锻装备 | 铁匠猫 Best Friend | 300🪙 + 8 矿石 + 2 宝石 | 8 次 | 1× 可选择史诗装备 |

### 3.2 配方解锁

| 条件 | 解锁的配方 |
|------|-----------|
| 制作系统上线（Phase 3） | 所有药水配方 + 普通装备 + Trinket 合成 |
| 冒险等级 ≥ 6 | 精良装备配方 |
| 冒险等级 ≥ 12 | 稀有装备配方 |
| NPC Friendly / Best Friend | 对应 NPC 独家配方 |

---

## 4. 制作流程

### 4.1 开始制作

```
用户打开制作台 → 选择配方
  → 检查材料是否充足
    → 不足：显示"材料不足"+ 缺少的材料列表
    → 充足：扣除材料 + 金币/星尘 → 创建 CraftingProject
  → 显示"制作中！完成 N 次专注即可获得 [物品名]"
```

### 4.2 推进制作

```
用户完成一次专注时段（≥ 25 分钟）
  → 检查是否有进行中的 CraftingProject
    → 有：completedSessions += 1
      → 若习惯类别匹配配方类别：额外 +0.5 进度（向下取整后实际效果 = 2 次匹配专注 = 3 次进度）
      → 若 completedSessions ≥ requiredSessions：制作完成！
        → 产出物品加入库存
        → CraftingProject.status → 'completed'
        → 显示制作完成通知
    → 无：正常计算（不影响专注奖励）
```

### 4.3 并行限制

- 同时只能有 **1 个** 进行中的制作项目
- 完成或取消当前项目后才能开始新项目
- 取消制作 → 已消耗的材料 **不退还**，但已投入的进度保留 → 可稍后"继续制作"

### 4.4 匹配加成细节

| 配方类别 | 匹配习惯类别 | 加成效果 |
|---------|------------|---------|
| 药水配方 | 健康（wellness） | 每 2 次匹配专注算 3 次进度 |
| 装备配方 | 体能（physical） | 每 2 次匹配专注算 3 次进度 |
| Trinket 配方 | 任意 | 无额外加成（1 次即可完成） |

> 匹配加成使用 `bonusProgress` 累加器：每次匹配专注 +0.5，累加至 ≥1.0 时转化为 1 次额外进度。

---

## 5. 数据模型

```dart
class CraftingProject {
  final String id;                // UUID
  final String uid;               // 用户 ID
  final String recipeId;          // 配方 ID
  final int completedSessions;    // 已完成的专注次数
  final int requiredSessions;     // 配方要求的总次数
  final double bonusProgress;     // 匹配加成累加器（0.0-0.9）
  final String status;            // 'in_progress' | 'completed' | 'cancelled'
  final DateTime startedAt;       // 开始时间
  final DateTime? completedAt;    // 完成时间
}

class Recipe {
  final String id;
  final String name;              // i18n key
  final String outputItemDefId;   // 产出物品 ID
  final int outputQuantity;       // 产出数量（通常 1）
  final bool outputIsRandom;      // 产出是否随机（普通装备/Trinket）
  final int requiredSessions;     // 所需专注次数
  final int goldCost;             // 金币消耗
  final int stardustCost;         // 星尘消耗（0 = 不需要）
  final Map<String, int> materialCost; // 材料消耗 {'herb': 2, 'gem': 1}
  final String? matchingCategory; // 匹配习惯类别（null = 无匹配加成）
  final String? unlockCondition;  // 解锁条件描述
}
```

### 5.1 持久化

| 存储层 | 路径 |
|--------|------|
| SQLite | `local_crafting_project` 表（单行，每用户至多 1 个 in_progress） |
| Firestore | `users/{uid}/craftingProject`（单文档） |

```sql
CREATE TABLE local_crafting_project (
  id                  TEXT PRIMARY KEY,
  uid                 TEXT NOT NULL,
  recipe_id           TEXT NOT NULL,
  completed_sessions  INTEGER NOT NULL DEFAULT 0,
  required_sessions   INTEGER NOT NULL,
  bonus_progress      REAL NOT NULL DEFAULT 0.0,
  status              TEXT NOT NULL DEFAULT 'in_progress',
  started_at          TEXT NOT NULL,
  completed_at        TEXT
);
```

---

## 6. 制作台 UI

### 6.1 入口

Tab 2（酒馆）中的「制作台」按钮，或 Tab 3（冒险者日志）中的「制作」快捷入口。

### 6.2 制作台主界面

```
┌─────────────────────────────────────┐
│ ⚒️ 制作台                           │
├─────────────────────────────────────┤
│                                     │
│ 📋 当前项目：锻造精良装备             │
│ ████████░░░░░░ 4/5 次专注           │
│ "再完成 1 次专注即可完成！"           │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ 📖 可用配方                          │
│                                     │
│ [🧪 治愈药水]  1次 | 15🪙+1草药     │
│ [⚔️ 普通装备]  3次 | 100🪙+3材料   │
│ [⚔️ 精良装备]  5次 | 200🪙+5材+1宝 │
│ [🔮 合成Trinket] 1次 | 30🪙+1碎片   │
│                                     │
│ [🔒 稀有装备] 需要冒险等级 12        │
│                                     │
├─────────────────────────────────────┤
│ 💎 材料库存                          │
│ 草药×3  织物×5  矿石×2  墨水×4      │
│ 宝石×1  碎片×2                      │
└─────────────────────────────────────┘
```

### 6.3 制作完成通知

```
┌─────────────────────────────────────┐
│ ⚒️ 制作完成！                        │
│                                     │
│   [精良·冒险者围巾]                   │
│   DEX +1                            │
│   "一条经过精心编织的围巾"            │
│                                     │
│ [装备] [放入库存]                    │
└─────────────────────────────────────┘
```

---

## 7. 经济平衡

### 7.1 制作 vs 购买对比

| 获取方式 | 金币成本 | 材料成本 | 时间成本 | 适合 |
|---------|---------|---------|---------|------|
| 商店购买 | 全价（150🪙） | 无 | 无 | 金币充裕、想立即获得 |
| 制作获取 | 半价（100🪙） | 需要材料 | 3-10 次专注 | 材料充裕、不急用 |

**设计意图：** 制作 = 用时间和材料换取更便宜的价格。两种获取方式并存，给不同类型用户选择权。

### 7.2 制作对经济的影响

- 制作消耗金币（金币沉淀渠道）
- 制作消耗材料（材料来自专注，间接激励习惯完成）
- 制作不产出金币（避免通过制作+出售套利）

---

## 8. 与其他系统交互

| 系统 | 交互 |
|------|------|
| 库存（spec/09） | 材料从库存扣除，产出加入库存 |
| 经济（spec/06） | 制作消耗金币/星尘；材料作为第三类资源 |
| 休息（spec/10） | 长休不重置制作进度；短休/长休不影响制作 |
| NPC（spec/11） | NPC Friendly 解锁独家配方 |
| 习惯类别 | 习惯类别决定材料掉落类型 + 匹配加成 |

---

## 9. 验证要点

- [ ] 所有配方的材料消耗与 spec/06 经济平衡一致
- [ ] 制作产出的物品 ID 与 spec/09 物品定义一致
- [ ] 制作进度基于专注时段完成，不需要额外用户操作
- [ ] 匹配加成逻辑（+0.5 累加器）正确处理小数
- [ ] 同时只能有 1 个进行中的制作项目
- [ ] 取消制作不退材料但保留进度的规则清晰
- [ ] NPC 解锁配方的条件与 spec/11 一致
