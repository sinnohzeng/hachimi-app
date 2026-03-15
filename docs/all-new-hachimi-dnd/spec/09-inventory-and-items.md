# 库存与物品规格书（Inventory & Items Specification）

> SSOT for 统一库存系统、魔法装备（稀有度分级）、药水消耗品、Trinkets 收藏品。
> **Status:** Draft
> **Phase:** 2（Trinkets + 药水）、3（魔法装备稀有度 + 完整库存 UI）
> **Evidence:** SRD 5.2.1 Ch.06（Equipment）、Ch.10（Magic Items）
> **Related:** [spec/06-economy.md](06-economy.md)、[spec/08-conditions-and-defenses.md](08-conditions-and-defenses.md)、[spec/10-rest-and-rhythm.md](10-rest-and-rhythm.md)、[spec/12-crafting.md](12-crafting.md)
> **Changelog:**
> - 2026-03-15 — 初版：统一库存模型、稀有度体系、5 种药水、50 个 Trinkets 框架、装备槽位

---

## 1. 概述

本规格整合三个密切关联的物品子系统：

1. **魔法装备（Magic Items）**：有属性加成的可装备道具，按稀有度分级
2. **药水消耗品（Potions）**：一次性使用的增益/治疗物品
3. **Trinkets 收藏品**：可收集的风味小物件，附带微小增益

三者共享一个 **统一库存系统（Inventory）** 和一套 **稀有度分级体系**。

---

## 2. 稀有度体系

### 2.1 稀有度等级

| 等级 | 代码值 | 中文名 | 颜色 | 获取途径 | Phase |
|------|--------|-------|------|---------|-------|
| 1 | `common` | 普通 | 白 #F5F5F5 | 金币商店、冒险掉落、签到 | 2 |
| 2 | `uncommon` | 精良 | 绿 #4CAF50 | 金币高价、冒险奖励 | 2 |
| 3 | `rare` | 稀有 | 蓝 #2196F3 | 星尘商店、制作、3 星通关 | 3 |
| 4 | `epic` | 史诗 | 紫 #9C27B0 | 仅制作、季节活动 | 3+ |
| 5 | `legendary` | 传说 | 金 #FF9800 | Epic Boons 奖励、特殊成就 | 3+ |

### 2.2 稀有度与定价

| 稀有度 | 金币售价 | 星尘售价 | 制作金币成本 | 制作材料 |
|--------|---------|---------|------------|---------|
| 普通 | 30-80🪙 | — | 15-40🪙 | 1-2 材料 |
| 精良 | 100-200🪙 | 50-100⭐ | 50-100🪙 | 3-5 材料 + 1 宝石 |
| 稀有 | — | 200-350⭐ | 200⭐ | 5-10 材料 + 3 宝石 |
| 史诗 | — | — | 500⭐ | 15+ 材料 + 5 宝石 |
| 传说 | — | — | 不可制作 | Epic Boon / 成就 |

> 稀有及以上物品不在金币商店出售——只能通过星尘商店、制作或冒险获取。这确保了星尘的独立价值。

---

## 3. 统一库存系统

### 3.1 数据模型

```dart
/// 统一库存项 — 覆盖装备、药水、Trinkets 三类
class InventoryItem {
  final String id;              // UUID
  final String uid;             // 所属用户
  final String itemDefId;       // 引用 ItemDefinition.id
  final String category;        // 'equipment' | 'potion' | 'trinket'
  final int quantity;           // 装备 = 1, 药水 = 1-99, Trinket = 1
  final bool equipped;          // 仅 equipment 有效
  final String? equippedOn;     // 装备到哪只猫：catId or 'primary'
  final String? equippedSlot;   // 'head' | 'neck' | 'back' | 'charm'(仅主哈基米)
  final DateTime acquiredAt;    // 获得时间
}

/// 物品定义 — 常量，硬编码在 App 中 + 可通过 Remote Config 扩展
class ItemDefinition {
  final String id;
  final String name;            // i18n key
  final String description;     // i18n key
  final String category;        // 'equipment' | 'potion' | 'trinket'
  final String rarity;          // 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'
  final String? slot;           // 装备槽位（仅 equipment）
  final Map<String, int>? statBonuses; // 属性加成 {'INT': 1, 'WIS': 1}（仅 equipment）
  final String? conditionGrant; // 使用时附加的状态（仅 potion）：'focused' | 'lucky' | ...
  final String? conditionClear; // 使用时清除的状态（仅 potion）：'poisoned' | 'frightened' | ...
  final String? microEffect;    // 微效果描述（仅 trinket）
}
```

### 3.2 持久化

| 存储层 | 路径 | 说明 |
|--------|------|------|
| SQLite | `local_inventory` 表 | 离线优先，主存储 |
| Firestore | `users/{uid}/inventory/{itemId}` | 云端同步，Ledger 模式 |

```sql
CREATE TABLE local_inventory (
  id              TEXT PRIMARY KEY,
  uid             TEXT NOT NULL,
  item_def_id     TEXT NOT NULL,
  category        TEXT NOT NULL,
  quantity        INTEGER NOT NULL DEFAULT 1,
  equipped        INTEGER NOT NULL DEFAULT 0,
  equipped_on     TEXT,
  equipped_slot   TEXT,
  acquired_at     TEXT NOT NULL
);
```

### 3.3 库存容量限制

| 类别 | 上限 | 超出处理 |
|------|------|---------|
| 装备 | 50 件 | 提示"库存已满，请出售或分解" |
| 药水 | 每种 10 瓶 | 超出自动转为金币（售价 50%） |
| Trinkets | 无上限 | 收藏品不限制 |

---

## 4. 魔法装备（Magic Items）

### 4.1 装备槽位

| 槽位 | 代码值 | 可装备者 | 说明 |
|------|--------|---------|------|
| 头部 | `head` | 所有猫 | 帽子、头冠、发饰 |
| 脖颈 | `neck` | 所有猫 | 项圈、围巾、项链 |
| 背部 | `back` | 所有猫 | 斗篷、背包、翅膀 |
| 饰品 | `charm` | 仅主哈基米 | 铃铛、胸针、徽章 |

**规则：**
- 每只猫每个槽位最多装备 **1 件**
- 同一件装备不可同时装备在多只猫上
- 装备/卸下操作在 Cat Detail 页面完成

### 4.2 装备属性加成

装备通过 `statBonuses` 字段提供属性检定加成，在 `DiceEngineService.performCheck()` 中参与计算：

```
Total = d20 + abilityMod + proficiency + flatBonuses + conditionMod + environmentMod + equipmentMod

equipmentMod = sum(该猫所有装备对当前检定属性的加成)
```

### 4.3 Phase 2 初始装备表（6 件，1 件/属性）

| 装备名 | 槽位 | 稀有度 | 属性加成 | 金币价格 | 获取 |
|--------|------|--------|---------|---------|------|
| 学者的眼镜 | head | 精良 | INT +1 | 150🪙 | 商店 |
| 冒险者围巾 | neck | 精良 | DEX +1 | 150🪙 | 商店 |
| 毅力护甲 | back | 精良 | CON +1 | 150🪙 | 商店 |
| 力量手环 | charm | 精良 | STR +1 | 150🪙 | 商店（主哈基米） |
| 智慧吊坠 | neck | 精良 | WIS +1 | 150🪙 | 商店 |
| 魅力铃铛 | charm | 精良 | CHA +1 | 150🪙 | 商店（主哈基米） |

### 4.4 Phase 3 进阶装备示例

| 装备名 | 槽位 | 稀有度 | 属性加成 | 特殊效果 | 获取 |
|--------|------|--------|---------|---------|------|
| 专注斗篷 | back | 稀有 | INT +1, WIS +1 | — | 制作 |
| 毅力项圈 | neck | 稀有 | CON +1 | 短休额外清除 1 负面状态 | 制作 |
| 幸运猫铃 | charm | 史诗 | — | 每次冒险 +10% Trinket 发现率 | 制作 |
| 星尘王冠 | head | 传说 | 全属性 +1 | 星尘收入 ×1.2 | Lv 19 Epic Boon 奖励 |

---

## 5. 药水消耗品（Potions）

### 5.1 药水列表

| 药水名 | 代码值 | 稀有度 | 效果 | 金币价格 | 星尘价格 | 制作成本 |
|--------|--------|--------|------|---------|---------|---------|
| 治愈药水 | `potion_healing` | 普通 | 清除 `poisoned` | 30🪙 | — | 15🪙 + 1 草药 |
| 勇气药水 | `potion_courage` | 普通 | 清除 `frightened` + CHA +1（2 事件） | 40🪙 | — | 20🪙 + 1 草药 |
| 专注药水 | `potion_focus` | 精良 | 附加 `focused`（INT/WIS +2，本次冒险） | 80🪙 | — | 40🪙 + 2 草药 |
| 幸运药水 | `potion_luck` | 精良 | 附加 `lucky`（可重投 1 次失败） | 100🪙 | — | 50🪙 + 1 宝石 |
| 祝福药水 | `potion_blessing` | 稀有 | 附加 `blessed`（忽略下次失败） | — | 200⭐ | 100⭐ + 2 宝石 |

### 5.2 使用规则

- **使用时机**：冒险开始前（队伍选择界面）或冒险进行中（每个事件结算后）
- **每次冒险上限**：最多使用 **3 瓶** 药水（不区分种类）
- **叠加规则**：不同种类药水的效果可叠加；同种药水不可重复使用（第二瓶刷新持续时间）
- **不采用** Potion Miscibility（药水混合表）——过于复杂且有惩罚风险

### 5.3 药水使用流程

```
用户在冒险界面点击「使用药水」按钮
  → 弹出药水选择弹窗（显示库存中的药水 + 剩余使用次数 "2/3"）
  → 选择药水 → 确认使用
  → InventoryItem.quantity -= 1
  → AdventureProgress.activeConditions.add(对应状态)
  → 动画：药水瓶倒空 + 状态图标出现
  → 冒险继续
```

---

## 6. Trinkets 收藏品

### 6.1 概念

SRD 有一张 100 个随机小物件的 Trinket Table。在 Hachimi 中，Trinkets 是猫主题化的可收集风味物品，提供微小增益，主要驱动 **收集成就感**。

### 6.2 Trinket 分类

| 类别 | 代码值 | 数量 | 微效果 | 示例 |
|------|--------|------|--------|------|
| 神秘物品 | `mysterious` | 10 | +1 金币/次专注 | 「永远不响的小铃铛」「自行旋转的指南针」 |
| 自然宝物 | `natural` | 10 | +2% Trinket 发现概率 | 「会微微发光的蘑菇」「恒温的小石头」 |
| 古代遗物 | `ancient` | 10 | +1 星尘/次冒险 | 「断裂的古剑碎片」「褪色的魔法卷轴」 |
| 日常趣味 | `everyday` | 10 | 纯风味（无效果） | 「永远打不开的小锁头」「写着名字的旧项圈」 |
| 稀有珍品 | `precious` | 10 | +5% 暴击概率 | 「瓶中的缩小彩虹」「冻结时间的怀表」 |

> 初始 50 个 Trinkets，可通过 Remote Config 持续扩充。

### 6.3 获取方式

| 来源 | 概率/条件 | Phase |
|------|---------|-------|
| 被动感知发现 | 冒险中 Passive Perception ≥ 隐藏 DC → 发现 Trinket | 2 |
| 冒险 3 星完成 | 30% 概率掉落随机 Trinket | 2 |
| 每日签到随机 | 5% 概率掉落 | 2 |
| 长休发现事件 | 70% 概率获得 Trinket（见 spec/10） | 2 |
| NPC Friendly 赠送 | 达到 Friendly 后一次性赠送独家 Trinket | 3 |
| 制作 | 30🪙 + 1 碎片 → 随机 Trinket | 3+ |

### 6.4 Trinket 微效果计算

Trinkets 的微效果是 **全局被动加成**，在后台自动生效：

```dart
int calculateTrinketBonus(List<InventoryItem> trinkets, String bonusType) {
  // bonusType: 'gold_per_focus' | 'discovery_percent' | 'stardust_per_adventure' | 'crit_percent'
  return trinkets
    .where((t) => t.category == 'trinket')
    .map((t) => getItemDef(t.itemDefId).microEffect)
    .where((e) => e?.type == bonusType)
    .fold(0, (sum, e) => sum + e!.value);
}
```

**上限设计**：微效果有 **硬上限** 防止极端叠加：
- 金币加成：最大 +5🪙/次专注
- 发现概率：最大 +10%
- 星尘加成：最大 +5⭐/次冒险
- 暴击概率：最大 +10%

### 6.5 Trinket 图鉴 UI

Tab 3（冒险者日志）底部折叠区域：

```
┌─────────────────────────────────────┐
│ 📖 收藏图鉴  [23/50]               │
├─────────────────────────────────────┤
│ 🔮 神秘物品  ■■■□□□□□□□  3/10     │
│ 🌿 自然宝物  ■■■■■□□□□□  5/10     │
│ ⚔️ 古代遗物  ■■■■□□□□□□  4/10     │
│ 🎲 日常趣味  ■■■■■■□□□□  6/10     │
│ 💎 稀有珍品  ■■■■■□□□□□  5/10     │
├─────────────────────────────────────┤
│ 点击展开查看详情                     │
└─────────────────────────────────────┘
```

展开后：网格布局，已获得的显示图标 + 名字，未获得的显示灰色剪影 + "???"。

### 6.6 重复 Trinket 处理

获得已拥有的 Trinket 时：
- 自动转化为 **1 碎片（Scrap）**（制作材料）
- 显示提示："已拥有此物品，转化为 1 碎片"

---

## 7. 物品获取与经济集成

### 7.1 商店系统

Tab 2（酒馆）中的商店面板：

| 商店 | 货币 | 商品 | 刷新频率 |
|------|------|------|---------|
| 日用商店 | 金币 | 普通药水、普通装备 | 每日刷新 |
| 冒险商店 | 星尘 | 精良药水、精良装备 | 每周刷新 |
| 稀有商店 | 星尘 | 稀有药水、稀有装备 | 每月刷新 / 随机出现 |

> 商店货品通过 Remote Config 可动态更新

### 7.2 冒险掉落表

| 冒险结果 | 掉落 |
|---------|------|
| 普通事件成功 | 10% 概率掉落普通装备/药水 |
| 大成功（Nat 20） | 30% 概率掉落精良物品 |
| 3 星通关 | 100% 掉落精良物品 + 30% Trinket + 1 宝石 |
| 3 星通关（Legendary 难度） | 100% 掉落稀有物品 + 50% Trinket + 2 宝石 |

---

## 8. 物品与其他系统交互

| 系统 | 交互 |
|------|------|
| 状态效果（spec/08） | 药水附加/清除状态；装备特殊效果可能附加状态 |
| 休息节奏（spec/10） | 部分装备"每短休充能"；长休发现事件产出 Trinket |
| 经济（spec/06） | 物品是金币/星尘的主要消耗渠道 |
| 制作（spec/12） | 制作系统产出装备、药水、Trinket |
| 冒险（spec/04） | 冒险掉落物品；冒险中使用药水 |
| NPC 社交（spec/11） | NPC Friendly 赠送独家 Trinket；NPC 提供商店折扣 |

---

## 9. 验证要点

- [ ] 统一库存模型覆盖三类物品（equipment、potion、trinket）
- [ ] 稀有度体系与经济系统（spec/06）的定价一致
- [ ] 药水效果与状态系统（spec/08）的条件定义一致
- [ ] Trinket 微效果有硬上限，不会造成数值膨胀
- [ ] 重复 Trinket → 碎片的转化逻辑完整
- [ ] 装备 equipmentMod 已集成到检定公式
- [ ] 库存容量限制合理（装备 50、药水 10/种、Trinket 无限）
