# 队伍与职业系统规格

> SSOT for Party composition rules, companion bonuses, class system, habit categories, and user level progression.
> **Status:** Draft
> **Evidence:** `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md` §6, §7, §8.3
> **Related:** `spec/01-primary-cat.md`, `spec/03-dice-and-checks.md`, `spec/06-economy.md`, `lib/models/habit.dart`, `lib/providers/cat_provider.dart`
> **Changelog:**
> - 2026-03-15 — 初版
> - 2026-03-15 — 深度增强：替换为完整 20 级冒险等级表（含进化阶段 + 熟练加值）；性格代码值统一为 brave/playful/lazy/curious/shy/clingy；伙伴加成改写为双层结构（主属性 +2 加值 + 性格 Advantage）；新增专长系统（§8b，Phase 3+）；新增技能子分类（§8c，Phase 3+）；里程碑触发表扩展为 8 个节点

---

## 1. 概述

Party（队伍）由一只固定的主哈基米（PrimaryCat）加上最多 2 只可选伙伴猫（CompanionCat）组成。伙伴猫来自用户的现有习惯猫。空位不产生惩罚，主哈基米可单独冒险。

职业（Class）系统在用户达到 **等级 3**（即所有猫累计 XP ≥ 360 分钟）时解锁，为主哈基米提供专注领域加成。

---

## 2. 队伍编成规则

### 2.1 槽位结构

| 槽位 | 内容 | 规则 |
|------|------|------|
| Slot 1（队长）| PrimaryCat | 固定，不可移除，不可替换 |
| Slot 2（伙伴 A）| CompanionCat，可选 | 从已激活习惯猫中选择 |
| Slot 3（伙伴 B）| CompanionCat，可选 | 从已激活习惯猫中选择，不可与 Slot 2 重复 |

- 空 Slot 不显示惩罚提示，无任何负面效果
- 两个 Slot 均为空时，队伍仍然有效，可正常开始冒险

### 2.2 选择约束

- 每只习惯猫只能出现在队伍中的一个 Slot
- 已退休（retired）或已删除的猫不可选入队伍
- 更换伙伴猫在**场景开始前**随时可操作；场景进行中禁止更换（见 §3 锁定规则）

---

## 3. 队伍数据模型

### 3.1 Party 模型

```dart
class Party {
  final String id;           // UUID，全局唯一
  final String userId;       // 所属用户
  final String primaryCatId; // 主哈基米 ID（永远不为 null）
  final String? companion1Id; // 伙伴 A，null = 空位
  final String? companion2Id; // 伙伴 B，null = 空位
  final DateTime updatedAt;   // 最后更新时间
}
```

### 3.2 持久化

- **SQLite**：`local_party` 表，单行（每用户一条记录，upsert by userId）
- **远端**：通过 LedgerChange 同步（`party_update` ActionType）
- 冒险开始时，将当前队伍的猫咪 ID 列表写入 `AdventureProgress.partyMemberIds`，之后队伍变更不影响进行中的冒险

### 3.3 队伍快照统一定义

> **统一定义**：冒险开始时，`AdventureProgress.partyMemberIds` 记录当前队伍的猫咪 ID 列表（`[primaryCatId, companion1Id?, companion2Id?]`）。这是一个 ID 快照，不是完整的 Party 对象副本。冒险期间即使 Party 记录被更新，`partyMemberIds` 不变。

`partyMemberIds` 存储于 `AdventureProgress.partyMemberIds`（`List<String>`），冒险结算时使用此列表还原参与猫咪，不引用当前 `local_party` 表的状态。

> **废弃说明**：此前规格草稿中出现的 `AdventurePartySnapshot` 独立类已废弃。所有队伍快照逻辑统一通过 `AdventureProgress.partyMemberIds` 实现，不存在独立的 snapshot 模型。

---

## 4. 同伴加成机制

### 4.1 加成效果汇总

伙伴猫提供**两个独立加成层**，可同时触发：

**第一层：主属性贡献 → +2 属性加值**

| 触发条件 | 效果 | 叠加上限 |
|----------|------|---------|
| 伙伴猫的最高属性与当前检定属性匹配 | 主哈基米该属性检定 **+2** | 两只伙伴均匹配时最大 **+4** |

**第二层：性格匹配 → 优势（Advantage）**

| 触发条件 | 效果 | 叠加规则 |
|----------|------|---------|
| 伙伴猫性格标签（`brave`/`playful`/`lazy`/`curious`/`shy`/`clingy`）与场景事件属性标签匹配 | 主哈基米获得 **优势（Advantage，投 2d20 取高）** | 优势不叠加，任意一只匹配即触发 |

**其他效果**

| 机制 | 触发条件 | 效果 |
|------|----------|------|
| 双猫同行 | Slot 2 与 Slot 3 均有伙伴猫 | 可能触发组合对话（概率 30%，对话内容见 `party_dialogues.dart`） |
| 空 Slot | 一个或两个 Slot 为空 | 无惩罚，主哈基米正常检定 |

### 4.2 属性匹配判断逻辑

> **平局处理**：如果伙伴猫有多个属性并列最高，按 STR→DEX→CON→INT→WIS→CHA 的固定顺序取第一个。这个顺序与 SRD 5.2.1 的标准属性排列一致。

```dart
// 伪代码，实现位于 dice_engine_service.dart
bool companionContributes(CompanionCat companion, String checkAbility) {
  final topAbility = companion.highestAbility; // STR/DEX/CON/INT/WIS/CHA
  return topAbility == checkAbility;
}

int calculateCompanionBonus(Party party, String checkAbility) {
  int bonus = 0;
  if (party.companion1 != null && companionContributes(party.companion1!, checkAbility)) bonus += 2;
  if (party.companion2 != null && companionContributes(party.companion2!, checkAbility)) bonus += 2;
  return bonus; // 最大 +4（两只伙伴均匹配时）
}

> **阶段上限约束**：「最高属性」使用经过 `stageCapFor(cat)` 约束后的计算值。幼猫阶段上限 14 的伙伴猫，即使原始公式算出 STR=16，在匹配判定中使用 14。
```

### 4.3 优势判断逻辑

性格（personality）与事件属性（event ability）的映射关系（代码值 → 属性）：

| 伙伴猫性格（代码值）| 中文 | 匹配的事件属性 |
|-------------------|------|--------------|
| `brave` | 勇敢 | STR |
| `playful` | 活泼 | DEX |
| `lazy` | 慵懒 | CON |
| `curious` | 好奇 | INT |
| `shy` | 害羞 | WIS |
| `clingy` | 粘人 | CHA |

> **规范说明**：以上代码值与 `cat_constants.dart` 中的 `CatPersonality` 枚举保持一致。任何文档或代码中的 `Agile`、`Resilient`、`Wise`、`Charming` 等旧名称均已废弃，统一使用上表中的代码值。

若队伍中**任意一只**伙伴猫的性格匹配当前事件属性，主哈基米获得优势。两只均匹配时，优势不叠加（优势已是最大值）。

---

## 5. 队伍锁定规则

### 5.1 锁定时机

- 用户点击"开始冒险"（确认场景卡后）→ 队伍快照写入 `AdventureProgress.partyMemberIds` → 锁定生效
- 锁定期间，Party Provider 中 companion1Id / companion2Id 仍可修改（为下次冒险准备），但当前冒险不受影响

### 5.2 解锁时机

- 当前场景冒险**全部完成**（所有事件结算后）→ 自动解锁
- 用户主动**放弃当前冒险**（进度丢失）→ 解锁

### 5.3 场景切换行为

- 场景进行中，用户选择切换场景卡：
  1. 当前冒险置为 `abandoned`（进度永久丢失，已获得的即时星尘不回收）
  2. 用户选择新场景卡并配置新队伍
  3. 同时只能激活 **1 个**进行中的冒险
  4. 新场景卡开始时重新锁定队伍

---

## 6. 职业系统

### 6.1 解锁条件

用户 XP（即所有猫 `totalMinutes` 之和）达到对应等级 3 阈值时，触发职业选择弹窗。

等级 3 的 XP 阈值参见 §8 用户等级表。

### 6.2 职业一览

| 职业 | 英文 | 优势领域（习惯 category）| XP 加成 | 主哈基米被动 |
|------|------|------------------------|---------|------------|
| 游侠 | Ranger | physical | +25% | 场景完成后随机发现额外道具（20% 概率） |
| 法师 | Wizard | mental | +25% | 知识类场景事件（INT 检定）DC -2 |
| 牧师 | Cleric | wellness | +25% | 队伍所有猫心情（mood）+1 级 |
| 诗人 | Bard | social | +25% | CHA 检定自动获得优势 |
| 盗贼 | Rogue | skill | +25% | 所有星尘奖励 ×1.5（向下取整） |
| 战士 | Fighter | general（通用）| +10% | 主哈基米 STR 和 CON 各 +1 |

### 6.3 XP 加成计算规则

- **目标习惯的 category 必须与职业优势领域匹配**，才触发 +25% 加成
- 加成应用于该次专注会话结束后的 XP 增量，不回溯
- 战士（Fighter）的 +10% 加成适用于**所有 category 的习惯**
- 多职兼修时，同一次专注最多叠加一个主职 +25%（或 Fighter +10%）和一个副职的 50% 加成（见 §7 多职兼修）

### 6.4 职业数据存储

- 存储于 `PrimaryCat.playerClass`（字符串字段）
- 枚举值：`'ranger'` / `'wizard'` / `'cleric'` / `'bard'` / `'rogue'` / `'fighter'`
- `null` = 未选择（等级 3 前的状态）

### 6.5 职业选择流程

```
用户 XP 触达等级 3 阈值
  → ClassSelectScreen 弹窗（不可跳过，但可延迟至下次打开 App）
  → 展示 6 个职业卡片，每张卡片包含：名称 + 图标 + 优势领域 + XP 加成 + 被动描述
  → 用户点击选择 → 确认弹窗 → 写入 PrimaryCat.playerClass
  → 弹窗关闭，首页展示职业徽章
```

---

## 7. 习惯分类标签（Habit Category）

### 7.1 模型变更

`Habit` 模型新增可选字段：

```dart
class Habit {
  // ... 现有字段 ...
  final String? category; // 新增，可为 null
}
```

- `null` 等同于 `'general'`，在职业加成计算时按 `general` 处理
- 用户可随时在习惯设置页修改 category，不影响历史 XP

### 7.2 Category 枚举值

| 值 | 中文标签 | 适合习惯示例 |
|----|---------|------------|
| `physical` | 运动 / 健身 | 跑步、健身、瑜伽 |
| `mental` | 学习 / 阅读 | 读书、刷题、学语言 |
| `wellness` | 冥想 / 健康 | 冥想、睡眠日记、喝水 |
| `social` | 社交 / 创作 | 写作、绘画、社群互动 |
| `skill` | 技能 / 手工 | 编程、弹琴、手工 |
| `general` | 通用 | 其他所有习惯 |

### 7.3 UI 入口

- 习惯编辑页（Habit Edit Screen）新增"分类"选择器（单选 Chip 或 DropdownButton）
- 习惯卡片可选展示 category 小标签（视觉优化，非 MVP 必需）

### 7.4 SQLite 迁移

```sql
ALTER TABLE habits ADD COLUMN category TEXT; -- nullable，默认 null
```

数据库版本号需从当前版本 +1，通过 `sqflite` migration 回调执行。

---

## 8. 多职兼修

### 8.1 解锁条件

用户 XP 达到**等级 10 阈值**（4,800 分钟，约 80 小时），且已选择主职业。

### 8.2 机制

- 可选择一个**不同于主职**的副职业
- 副职业提供其正常 XP 加成的 **50%**（Fighter 副职提供 +5%）
- 副职业的**被动技能不激活**（仅享受 XP 加成）
- 同一次专注的 XP 加成计算：`XP × (1 + 主职加成%) × (1 + 副职加成% × 0.5)`

> **取整规则**：副职 XP 加成 = `(mainClassBonus * 0.5).floor()`。示例：Ranger 副职 = floor(25% × 0.5) = floor(12.5%) = 12%。最终乘数为 `1 + 0.12 = 1.12`。

### 8.3 示例

主职 Wizard（+25%，mental 习惯）+ 副职 Rogue（+25% × 50% = +12.5%）：
- mental 习惯专注 30 分钟 → XP = 30 × 1.25 × 1.125 ≈ 42 XP

---

## 8b. 专长系统（Phase 3+）

> **SRD 灵感**：SRD 5.2.1 在 Level 4/8/12/16/19 提供 Feat 选择。我们在相同等级节点提供"ASI 或专长"二选一。

在冒险等级 4/8/12/16/19 时，用户选择：
- **属性提升（ASI）**：一个属性永久 +1（上限 20）
- **专长**：获得一个被动效果

### 初始专长列表

| 专长名 | SRD 灵感 | 效果 | 适合场景 |
|--------|---------|------|---------|
| 🔔 警觉 Alert | Alert | 被动感知 +5（大幅增加酒馆发现事件概率） | 偏好探索的用户 |
| 📚 专精 Skilled | Skilled | 新增 1 个习惯分类获得熟练加值 | 多习惯用户 |
| 💪 坚毅 Tough | Tough | CON 检定修正值额外 +1 | 连击型用户 |
| 🍀 幸运 Lucky | Lucky | 每日 1 次重掷骰子（可选择保留新结果或旧结果） | 所有用户 |
| 🎯 专注射手 Sharpshooter | Sharpshooter | DEX 检定在 DC ≤ 12 时自动成功 | 高效率用户 |
| 🛡️ 韧性 Resilient | Resilient | 选择一个属性获得该属性检定的熟练 | 弱项补强 |

专长选择持久化在 PrimaryCat 模型（`asiChoices: Map<int, String>` 字段）。每个专长只能选择一次。

> **不可修改**：ASI 和专长选择一经确认后**永久锁定**，不可撤销或重选。若用户后悔，需等待下一个 ASI 节点（Lv 8/12/16/19）。

### 验收标准
- [ ] Level 4/8/12/16/19 触发选择界面
- [ ] ASI +1 正确叠加在计算值之上
- [ ] 专长效果在对应系统中生效（如 Alert 影响被动感知）
- [ ] 每个专长只能选一次，已选的灰显

---

## 8c. 技能子分类（Phase 3+）

> **SRD 灵感**：SRD 5.2.1 定义了 18 个技能（Skills），每个映射到一个能力值。我们从中精选了 12 个最适合习惯追踪场景的技能作为可选子分类。

### 技能-属性-习惯映射

| 属性 | 习惯大类 | 可选子技能 | 习惯示例 |
|------|---------|----------|---------|
| STR | physical | Athletics 运动 | 跑步、健身、游泳 |
| DEX | physical | Acrobatics 柔韧 | 瑜伽、舞蹈、拉伸 |
| DEX | physical | Stealth 静心 | 冥想、深呼吸 |
| CON | wellness | Medicine 健康 | 健康管理、用药 |
| CON | wellness | Survival 生存 | 饮食记录、睡眠 |
| INT | mental | Arcana 技术 | 编程、技术学习 |
| INT | mental | History 知识 | 阅读、课程学习 |
| INT | mental | Investigation 研究 | 深度研究、写作 |
| WIS | wellness | Insight 洞察 | 日记、反思 |
| WIS | wellness | Perception 觉察 | 正念、觉察练习 |
| CHA | social | Performance 创作 | 绘画、音乐、创作 |
| CHA | social | Persuasion 沟通 | 社交、演讲 |

### 技能熟练机制

当用户为习惯选择了子技能标签后：
- 该习惯的伙伴猫在对应属性检定中获得**熟练加值**（而非仅靠职业匹配）
- 子技能选择为可选操作，不影响不选择子技能的用户

### 验收标准
- [ ] 习惯设置页面可选择子技能标签（或不选）
- [ ] 选择子技能后，对应检定获得熟练加值
- [ ] 子技能选择不影响现有 6 大类分类逻辑

---

## 9. 用户等级系统

### 9.1 XP 计算

```dart
/// 冒险等级 XP（materialized，含职业加成）
///
/// 基础公式：XP = sum(每次专注的加成后分钟数)
/// 职业加成：选择职业后，匹配 category 的专注分钟数 × 职业加成率
///
/// 注意：职业加成不回溯。选择 Wizard 前的 360 分钟不受 +25% 影响。
/// 实现方式：每次专注完成时，将加成后的 XP 增量写入 materialized_state['adventure_xp']，
/// 而非运行时重新计算全部历史。
int get adventureXP => materializedState['adventure_xp'] ?? allCatsTotalMinutes;
```

注意：此 XP 与现有 `xp_service.dart` 的 XP 体系**相互独立**。现有 XP 包含 `fullHouseBonus` 和 Remote Config 倍率，DnD 等级系统使用**物化累积值**（每次专注写入增量），以保持简洁可预期。

### XP 系统关系图

Hachimi 有两套独立的 XP 体系，互不干扰：

```
┌─────────────────────────────────────────────────────┐
│  冒险等级 XP（Adventure Level XP）                    │
│  计算：物化累积值（每次专注完成时写入增量）           │
│  增量公式：专注分钟 × (1 + 职业加成率)               │
│  用途：DnD 等级（1-20）、区域解锁、职业选择          │
│  存储：materialized_state['adventure_xp']            │
│  受职业加成影响：✅（Ranger +25% physical 等）        │
│  回退策略：若 adventure_xp 为空，降级为              │
│            allCatsTotalMinutes（无加成的原始值）      │
├─────────────────────────────────────────────────────┤
│  现有 XP（xp_service.dart）                          │
│  计算：分钟 × Remote Config 倍率 + fullHouseBonus    │
│  用途：成就系统、猫咪等级显示                         │
│  存储：materialized_state['xp']                      │
│  受职业加成影响：❌（完全独立）                       │
└─────────────────────────────────────────────────────┘
```

**职业 XP 加成规则**：
- 加成只作用于**冒险等级 XP**，不影响现有 xp_service
- 加成从**选择职业后的首次相关类别专注**开始生效
- **不回溯**历史 XP — 选择职业前已物化的 adventure_xp 值不变
- 每次专注完成时的写入流程：
  1. 计算基础增量 = 本次专注分钟数
  2. 若用户有职业且习惯 category 匹配 → 增量 × (1 + 加成率)
  3. `adventure_xp += 增量`（写入 `materialized_state`）
- 示例：用户在 Lv 3（360 min）选择 Wizard → 之后 mental 类专注 30 分钟 → 增量 = 30 × 1.25 = 37 XP → 但前 360 min 不变

### 9.2 冒险等级表（20 级）

> **命名约定**：此等级系统称为"冒险等级"（Adventure Level），与现有 `xp_service.dart` 的经验值系统完全独立。冒险等级 XP = `materialized_state['adventure_xp']`（物化累积值，含职业加成；降级值为所有猫 `totalMinutes` 之和）。

| 等级 | 所需 XP (分钟) | 等效小时 | 进化阶段 | 熟练加值 | 解锁内容 |
|------|--------------|---------|---------|---------|---------|
| 1 | 0 | 0h | 幼猫 Kitten | +2 | 基础场景（猫咪小镇） |
| 2 | 120 | 2h | 幼猫 | +2 | — |
| 3 | 360 | 6h | 幼猫 | +2 | 职业选择 |
| 4 | 720 | 12h | 幼猫 | +2 | ASI / 专长选择 |
| 5 | 1,080 | 18h | 幼猫 | +3 | — |
| 6 | 1,200 | 20h | 幼猫→少年猫 | +3 | **第一次进化！** |
| 7 | 1,800 | 30h | 少年猫 Adolescent | +3 | 迷雾森林区域 |
| 8 | 2,700 | 45h | 少年猫 | +3 | ASI / 专长选择 |
| 9 | 3,600 | 60h | 少年猫 | +4 | — |
| 10 | 4,800 | 80h | 少年猫 | +4 | 多职兼修 |
| 11 | 5,400 | 90h | 少年猫 | +4 | — |
| 12 | 6,000 | 100h | 少年猫→成年猫 | +4 | **第二次进化！** + ASI / 专长 |
| 13 | 7,200 | 120h | 成年猫 Adult | +5 | 远古遗迹区域 |
| 14 | 8,400 | 140h | 成年猫 | +5 | — |
| 15 | 9,600 | 160h | 成年猫 | +5 | — |
| 16 | 12,000 | 200h | 成年猫 | +5 | ASI / 专长选择 |
| 17 | 15,000 | 250h | 成年猫 | +6 | 传奇场景 |
| 18 | 18,000 | 300h | 成年猫 | +6 | — |
| 19 | 24,000 | 400h | 成年猫 | +6 | ASI / 专长选择 |
| 20 | 36,000 | 600h | 成年猫 | +6 | 全内容解锁 |

**设计思路**：
- Lv 1-6 密集升级（2-4h 间隔）→ 前 20 小时 6 次升级 = 强正反馈
- Lv 6 和 Lv 12 对齐进化时刻 → "升级 + 进化"双重庆祝
- Lv 13+ 间隔逐步拉大 → 长期目标，保持追求感
- 日均 1h 专注的用户节奏：~1 月到 Lv 6（首次进化），~3 月到 Lv 12（二次进化），~10 月到 Lv 16

> **SRD 对齐**：SRD 5.2.1 的 20 级 XP 表（0/300/900/.../355,000）为核心 RPG 设计。我们保留了 20 级结构和熟练加值递增规则（+2→+6），但 XP 阈值按"1 分钟 = 1 XP"重新设计，以匹配习惯追踪的时间粒度。

### 9.3 里程碑触发事件

| 里程碑 | XP 阈值 | 触发事件 |
|--------|--------|---------|
| 等级 3 | 360 分钟 | 显示 `ClassSelectScreen` 弹窗，选择主职业 |
| 等级 4 | 720 分钟 | 显示 ASI / 专长选择界面（首次） |
| 等级 6 | 1,200 分钟 | **进化**：幼猫 → 少年猫，触发进化动画 |
| 等级 8 | 2,700 分钟 | 显示 ASI / 专长选择界面 |
| 等级 10 | 4,800 分钟 | 显示多职兼修提示，可选副职业 |
| 等级 12 | 6,000 分钟 | **进化**：少年猫 → 成年猫，触发进化动画；ASI / 专长选择 |
| 等级 16 | 12,000 分钟 | 显示 ASI / 专长选择界面 |
| 等级 19 | 24,000 分钟 | 显示 ASI / 专长选择界面（最终） |

---

## 10. Provider 依赖关系

```
userLevelProvider
  └── partyProvider
        ├── primaryCatProvider        (主哈基米数据)
        ├── catsProvider              (所有习惯猫，用于伙伴选择)
        └── adventureProgressProvider (读取快照，判断是否锁定)

classProvider
  ├── primaryCatProvider
  └── userLevelProvider
```

所有 Provider 遵循项目依赖流规则：Screen → Provider → Service → Firebase SDK。

---

## 11. 验收标准

### 队伍与锁定
- [ ] Party 数据正确持久化（SQLite + 远端，离线优先）
- [ ] 冒险开始时锁定队伍快照，写入 `AdventureProgress.partyMemberIds`
- [ ] 冒险进行中，修改 Party 不影响当前冒险结算

### 伙伴加成（双层机制）
- [ ] 伙伴猫最高属性匹配检定属性时，正确叠加 **+2 加值**（双伙伴均匹配时最大 +4）
- [ ] 伙伴猫性格代码值（`brave`/`playful`/`lazy`/`curious`/`shy`/`clingy`）匹配事件属性时，主哈基米获得 **Advantage（2d20 取高）**
- [ ] Advantage 不叠加：任意一只伙伴匹配即触发，两只均匹配效果相同

### 职业系统
- [ ] 等级 3（XP ≥ 360）才显示职业选择入口（`ClassSelectScreen`）
- [ ] 职业 XP 加成仅对匹配 category 的习惯生效（Fighter 对全 category 生效）
- [ ] 多职兼修在等级 10（XP ≥ 4,800）解锁，副职加成为正常值的 50%

### 习惯分类
- [ ] Habit `category` 字段：null 等同于 `general`，SQLite 迁移正确执行

### 等级系统
- [ ] 用户冒险 XP = `materialized_state['adventure_xp']`（物化累积值，含职业加成），降级为所有猫 `totalMinutes` 之和；与现有 `xp_service.dart` XP 体系独立
- [ ] 20 级等级表阈值与熟练加值（Proficiency Bonus）对应正确
- [ ] 等级 6（XP = 1,200）和等级 12（XP = 6,000）触发进化动画
- [ ] 三个进化阶段（幼猫 Kitten / 少年猫 Adolescent / 成年猫 Adult）对应正确图资

### 专长系统（Phase 3+）
- [ ] 等级 4/8/12/16/19 触发 ASI / 专长选择界面
- [ ] ASI +1 正确叠加，每个属性上限 20
- [ ] 专长效果在对应系统中生效（如 Alert 影响被动感知）
- [ ] 每个专长只能选一次，已选的灰显

### 技能子分类（Phase 3+）
- [ ] 习惯设置页面可选择子技能标签（或不选）
- [ ] 选择子技能后，对应检定获得熟练加值
- [ ] 子技能选择不影响现有 6 大类分类逻辑
- [ ] **职业变更后 XP**：选择新职业后，从该时刻起新职业加成生效；历史 adventureXP 物化值不变
- [ ] **Lv 6/12 进化并发**：若多只猫同时达到进化阈值（unlikely but possible），进化动画仅播放 1 次（取最先触发的）
- [ ] **ASI 不可逆**：已确认的 ASI/Feat 选择在 UI 中灰显为"已选"，不可修改

---

## 附录 A：SRD 深度借鉴扩展

### A.1 职业豁免熟练表（Phase 2，详见 spec/08 §3.3）

每个职业精通 2 种豁免检定属性。当场景事件 `type == 'saving_throw'` 时，若检定属性在职业豁免熟练列表中，则加熟练加值。

| 职业 | 豁免熟练 1 | 豁免熟练 2 |
|------|-----------|-----------|
| Ranger（游侠） | STR | DEX |
| Wizard（法师） | INT | WIS |
| Cleric（牧师） | WIS | CHA |
| Bard（诗人） | DEX | CHA |
| Rogue（盗贼） | DEX | INT |
| Fighter（战士） | STR | CON |

### A.2 史诗恩赐（Phase 3+，详见计划文档）

等级 19-20 的 ASI/Feat 节点新增 **Epic Boon** 选项（7 种），作为极长期用户的终极奖励：

| Boon 名 | 效果摘要 |
|---------|---------|
| 恒毅恩赐 | STR/CON +1（可超 20 上限至 22） |
| 命运恩赐 | 每次冒险可修改 1 次骰子结果 ±3 |
| 传送恩赐 | 冒险中可跳过 1 个事件 |
| 不朽恩赐 | Nat 20 额外 +20 星尘 |
| 法术恩赐 | 每次长休后获得 1 瓶免费祝福药水 |
| 领袖恩赐 | 所有伙伴猫心情永久 +1 级 |
| 全知恩赐 | 被动感知 +5，100% 发现陷阱和 Trinket |
