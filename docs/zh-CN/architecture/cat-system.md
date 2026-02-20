# 猫咪系统 — 游戏设计 SSOT（单一真值来源）

> **SSOT（Single Source of Truth，单一真值来源）**：本文档是所有猫咪游戏机制的单一权威来源。`lib/core/constants/cat_constants.dart` 和 `lib/core/constants/pixel_cat_constants.dart` 的实现必须与本规范完全一致。

---

## 概览

猫咪系统是 Hachimi 的情感核心。它将抽象的习惯追踪转化为一种养育体验：你坚持的每一个习惯都会培育出一只独特的虚拟伙伴。该系统的设计目标：

1. **奖励坚持** —— 成长阶段和心情改善通过定期专注获得
2. **建立依附** —— 像素风外观、性格和名字让每只猫咪都感觉是你的
3. **可视化进步** —— 猫咪进化为习惯连续记录提供清晰、有情感共鸣的反馈
4. **随雄心扩展** —— CatHouse 网格展示无限数量的猫咪；猫咪相册数量同样无限制

---

## 外观参数系统

猫咪外观通过 **pixel-cat-maker** 参数系统生成。每只猫的外观由一组存储于 Firestore 中 `Map<String, dynamic>` 类型的外观参数定义。这些参数在领养后不可变更——它们定义了猫咪一生的视觉身份。

### 外观参数

| 参数 | 类型 | 说明 | 示例值 |
|------|------|------|--------|
| `peltType` | String | 基础毛皮图案类型 | `"tabby"`、`"solid"`、`"ticked"`、`"mackerel"` |
| `peltColor` | String | 主要毛色 | `"orange"`、`"black"`、`"cream"`、`"grey"` |
| `eyeColor` | String | 眼睛颜色 | `"green"`、`"blue"`、`"amber"`、`"copper"` |
| `skinColor` | String | 鼻子和内耳颜色 | `"pink"`、`"darkBrown"`、`"black"` |
| `whitePatches` | String? | 白色斑块分布模式 | `"chest"`、`"tuxedo"`、`"mittens"`、`null` |
| `points` | String? | 重点色模式（暹罗猫风格） | `"seal"`、`"blue"`、`null` |
| `vitiligo` | bool | 是否有白斑病斑块 | `true`、`false` |
| `tortieBases` | String? | 玳瑁猫基础色（如适用） | `"tortie"`、`"calico"`、`null` |
| `tortiePatterns` | String? | 玳瑁猫花纹变体 | `"classic"`、`"mackerel"`、`null` |
| `tortieColors` | String? | 玳瑁猫第二颜色 | `"ginger"`、`"cream"`、`null` |
| `isLonghair` | bool | 长毛或短毛 | `true`、`false` |
| `reverse` | bool | 是否水平翻转精灵图 | `true`、`false` |
| `spriteVariant` | int | 精灵图变体索引 | `0`、`1`、`2` |
| `tint` | String? | 整体色调叠加层 | `"warm"`、`"cool"`、`null` |
| `whitePatchesTint` | String? | 白色斑块的色调叠加 | `"cream"`、`"ivory"`、`null` |

所有参数存储于猫咪 Firestore 文档的 `appearance` 字段中，并传递给 `PixelCatRenderer` 进行精灵图合成。

---

## 性格

共有 **6 种性格**，每种性格影响：

- 对话气泡文案
- 待机动画键（未来功能）

| 性格 ID | 显示名称 | Emoji | 性格语录 |
|---------|---------|-------|---------|
| `lazy` | 慵懒 | 😴 | 「嘘……再睡五分钟……」 |
| `curious` | 好奇 | 🔍 | 「今天外面有什么新鲜事？」 |
| `playful` | 活泼 | 🎮 | 「玩！玩！玩！」 |
| `shy` | 害羞 | 🙈 | 「哦！没想到你在这里……」 |
| `brave` | 勇敢 | 🦁 | 「这个地方交给我守护！」 |
| `clingy` | 黏人 | 🤗 | 「别走！陪我待在这里！」 |

性格在领养时随机分配。

---

## 成长阶段

猫咪根据 `totalMinutes` 占 `targetMinutes`（由习惯的 `targetHours` 派生的累计分钟目标）的百分比经历 **4 个阶段**：

| 阶段 | ID | 名称 | Emoji | 条件 | 描述 |
|------|-----|------|-------|------|------|
| 1 | `kitten` | 幼猫 | 🐱 | 进度 < 20% | 刚出生，小小的，充满潜力 |
| 2 | `adolescent` | 少年猫 | 🐈 | 20% <= 进度 < 45% | 快速成长，更有表情 |
| 3 | `adult` | 成年猫 | 🐈‍⬛ | 45% <= 进度 < 75% | 完全成形，充满自信 |
| 4 | `senior` | 长老猫 | 🎓🐈 | 进度 >= 75% | 智慧长者，气质不凡 |

**阶段计算** 在读取时从 `totalMinutes` 和 `targetMinutes` 派生，不单独存储于 Firestore（防止漂移）。计算属性 `cat.computedStage` 始终返回权威阶段。

**进度公式：**
```
progress = totalMinutes / targetMinutes
stage = kitten     若 progress < 0.20
        adolescent 若 progress < 0.45
        adult      若 progress < 0.75
        senior     若 progress >= 0.75
```

**阶段内进度**（用于阶段内进度条）：
```
stageProgress = (progress - 阶段下限) / (阶段上限 - 阶段下限)
```
达到最高阶段（长老猫）时，`stageProgress` 从 0.75 缩放到 1.0，上限为 `1.0`。

---

## 心情系统

猫咪心情根据 `lastSessionAt`（最近一次专注会话的时间戳）计算。心情 **不存储** 于 Firestore（在读取时重新计算，以始终反映当前现实）。

| 心情 ID | 名称 | Emoji | 条件 | 表现 |
|---------|------|-------|------|------|
| `happy` | 开心 | 😸 | 最近会话在 24 小时内 | 默认显示，猫咪活泼 |
| `neutral` | 平静 | 😐 | 最近会话在 1-3 天内 | 略显低落 |
| `lonely` | 孤独 | 😿 | 最近会话在 3-7 天内 | 悲伤精灵，担忧的话语 |
| `missing` | 思念 | 💔 | 最近会话超过 7 天 | 非常悲伤，触发召回通知 |

> Remote Config（远程配置）键 `mood_threshold_lonely_days`（默认值：3）控制孤独阈值（天数）。

**心情影响：**

- 猫咪精灵选择（开心/平静/悲伤姿势变体）
- 对话气泡文字内容
- CatHouse 卡片氛围（休眠猫咪显示为淡化状态）

---

## 对话气泡文案

对话文案遵循「性格：心情」矩阵。每种组合有 1-3 条文案变体，当前实现每种组合返回一条。

| | `happy` | `neutral` | `lonely` | `missing` |
|--|---------|-----------|---------|---------|
| `lazy` | 「今天是睡懒觉的完美时光……」 | 「唔，我还好吧。」 | 「我好怀念我们一起懒散的日子……」 | 「你去哪了？我的地方都凉了……」 |
| `curious` | 「今天我有了新发现！」 | 「一切都……还算正常吧。」 | 「我好奇你最近在探索什么……」 | 「你忘了我们的冒险了吗？」 |
| `playful` | 「一起玩！一起玩！」 | 「我等着玩耍……」 | 「没有人陪我玩太难过了……」 | 「求你回来陪我玩……」 |
| `shy` | 「哦！你来了！（脸红）」 | 「我一直在安静地等待……」 | 「我担心你忘记我了……」 | 「我好想你，都快心疼了……」 |
| `brave` | 「我一直在守护这里！」 | 「还在巡逻中。」 | 「没有你，这个家感觉空荡荡的。」 | 「我很勇敢地等了你这么久……」 |
| `clingy` | 「别走！陪我待着！」 | 「我需要更多抱抱……」 | 「求你别让我独处……」 | 「我把每一秒都数了遍……」 |

---

## XP 系统

XP 在每次专注会话结束时获得。所有计算在 `XpService`（纯 Dart，无 Firebase 依赖）中完成。

### XP 公式

```
totalXp = baseXp + streakBonus + milestoneBonus + fullHouseBonus
```

| 组成部分 | 公式 | 条件 |
|---------|------|------|
| `baseXp`（基础 XP） | `分钟数 x 1` | 始终 |
| `streakBonus`（连击奖励） | `+5` / 会话 | `currentStreak >= 3` |
| `milestoneBonus`（里程碑奖励） | `+30` 一次性 | 连续记录达到 7、14 或 30 天 |
| `fullHouseBonus`（全家福奖励） | `+10` / 会话 | 今日所有习惯均已完成 |

来自 Remote Config 的 XP 倍率（键：`xp_multiplier`，默认值：`1.0`）用于活动期间缩放 `totalXp`。

### 放弃会话

提前结束（放弃）的会话，若用户专注时间 **>= 5 分钟** 仍可获得 XP：

- XP = `已专注分钟数 x 1`（仅基础部分，无连击或奖励 XP）
- 会话在 Firestore 中标记为 `completed: false`

---

## 毛色背景映射

`pixel_cat_constants.dart` 中的 `peltColorToMaterial()` 函数将 19 种 `peltColor` ID 映射到柔和的 Material 颜色。此颜色在 CatDetailScreen 头部渐变中以 70% 的权重混合（另 30% 为阶段色），为每只猫提供个性化的背景。

| 颜色分组 | 毛色 ID | Material 颜色范围 |
|---------|---------|-----------------|
| 白/灰系 | WHITE、PALEGREY、SILVER、GREY、DARKGREY、GHOST | #E0E0E0 – #546E7A |
| 黑色 | BLACK | #455A64（已提亮以保证渐变可视性） |
| 橘/奶油系 | CREAM、PALEGINGER、GOLDEN、GINGER、DARKGINGER、SIENNA | #FFE0B2 – #E65100 |
| 棕色系 | LIGHTBROWN、LILAC、BROWN、GOLDEN-BROWN、DARKBROWN、CHOCOLATE | #BCAAA4 – #4E342E |

**实现**：`Color peltColorToMaterial(String peltColor)`，位于 `lib/core/constants/pixel_cat_constants.dart`。

---

## TappableCatSprite — 可复用点击切换组件

**文件：** `lib/widgets/tappable_cat_sprite.dart`

`TappableCatSprite` 是一个可复用的 `StatefulWidget`，封装了 `PixelCatSprite` 并添加了点击切换姿势动画和弹跳反馈。在应用中所有出现猫咪精灵图的页面（10+ 个）都使用此组件。

**属性：**

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `cat` | `Cat` | 必填 | 要显示的猫咪 |
| `size` | `double` | 必填 | 精灵图显示大小（逻辑像素） |
| `enableTap` | `bool` | `true` | 是否启用点击切换 |

**内部状态：**
- `_displayVariant`（int?）—— 纯本地姿势索引，不持久化。组件销毁时重置。
- `_bounceController` —— `AnimationController`（200ms），用于缩放弹跳动画。

**行为：**
- **点击**：循环 variant = `(current + 1) % 3`，触发 `HapticFeedback.lightImpact()`，播放弹跳
- **动画**：缩放弹跳（0.9x → 1.0x，约 200ms），通过 `TweenSequence` 实现
- **精灵图**：使用本地变体覆盖调用 `computeSpriteIndex(stage, _displayVariant, isLonghair)`
- **构建**：`GestureDetector` → `AnimatedBuilder` → `Transform.scale` → `PixelCatSprite`

**使用位置（10+ 个文件）：**
- `cat_detail_screen.dart`（120px）、`home_screen.dart`（72px 精选猫咪卡片）、`focus_setup_screen.dart`（120px）、`timer_screen.dart`（100px）、`focus_complete_screen.dart`（120px）、`cat_room_screen.dart`（80px）、`profile_screen.dart`（48px）、`adoption_flow_screen.dart`（预览）

> **注意：** `PixelCatSprite` 保留为底层渲染组件。`TappableCatSprite` 是交互层包装。

---

## 外观参数人类可读描述

**文件：** `lib/core/utils/appearance_descriptions.dart`

为所有猫咪外观参数提供人类可读的描述。用于猫咪详情页增强版 Cat Info Card。

| 函数 | 输入 → 输出 | 示例 |
|------|------------|------|
| `peltTypeDescription(String)` | 毛皮类型 ID → 可读名称 | `"tabby"` → `"Classic tabby stripes"` |
| `peltColorDescription(String)` | 毛色 ID → 可读名称 | `"GINGER"` → `"Bright ginger"` |
| `eyeDescription(String, String?)` | 眼睛颜色 + 第二眼 → 描述 | `"BLUE", "GREEN"` → `"Heterochromia (Blue / Green)"` |
| `furLengthDescription(bool)` | isLonghair → 可读 | `true` → `"Longhair"` |
| `fullSummary(CatAppearance)` | 完整外观 → 1 行摘要 | `"Ginger tabby, golden eyes, longhair"` |

---

## 猫咪详情页布局

猫咪详情页（`CatDetailScreen`）是猫咪及其关联任务的 **信息中枢**。布局从上到下：

```
┌─────────────────────────────────────┐
│ SliverAppBar（280px）               │
│   TappableCatSprite（120px）        │
│   猫咪名字 + 重命名按钮             │
│   性格徽章                          │
├─────────────────────────────────────┤
│ 心情徽章                            │
├─────────────────────────────────────┤
│ 成长进度卡片                        │
├─────────────────────────────────────┤
│ 专注统计卡片                        │
│   habit.icon + 名称 + [编辑]        │
│   2 列统计网格（9 项指标）           │
│   [开始专注] 按钮                   │
├─────────────────────────────────────┤
│ 提醒卡片                            │
│   设置 / 修改 / 移除提醒            │
├─────────────────────────────────────┤
│ 活动热力图卡片                      │
├─────────────────────────────────────┤
│ 配饰卡片                            │
├─────────────────────────────────────┤
│ 猫咪信息卡片（可展开）              │
│   性格 + 性格语录                   │
│   1 行外观摘要                      │
│   [展开] 完整外观详情               │
│   状态 + 领养日期                   │
└─────────────────────────────────────┘
```

---

## 精灵图渲染管线

`PixelCatRenderer` 通过从 `assets/pixel_cat/` 目录叠加 13 个图层来合成猫咪精灵图。图层从底部到顶部按以下顺序绘制：

| 顺序 | 图层 | 资源路径模式 | 条件 |
|------|------|------------|------|
| 1 | 基础身体 | `body/{peltType}_{spriteVariant}.png` | 始终 |
| 2 | 毛色叠加 | `pelt/{peltColor}.png` | 始终 |
| 3 | 白色斑块 | `white/{whitePatches}.png` | 仅当 `whitePatches != null` |
| 4 | 白斑色调 | `white_tint/{whitePatchesTint}.png` | 仅当 `whitePatchesTint != null` |
| 5 | 重点色 | `points/{points}.png` | 仅当 `points != null` |
| 6 | 白斑病 | `vitiligo/vitiligo.png` | 仅当 `vitiligo == true` |
| 7 | 玳瑁基础 | `tortie/{tortieBases}.png` | 仅当 `tortieBases != null` |
| 8 | 玳瑁花纹 | `tortie_pattern/{tortiePatterns}.png` | 仅当 `tortiePatterns != null` |
| 9 | 玳瑁颜色 | `tortie_color/{tortieColors}.png` | 仅当 `tortieColors != null` |
| 10 | 毛发长度 | `fur/{isLonghair ? "long" : "short"}.png` | 始终 |
| 11 | 眼睛 | `eyes/{eyeColor}.png` | 始终 |
| 12 | 皮肤（鼻/耳） | `skin/{skinColor}.png` | 始终 |
| 13 | 色调叠加 | `tint/{tint}.png` | 仅当 `tint != null` |

合成完成后，若 `reverse == true` 则可选择性地水平翻转精灵图。最终的 `dart:ui.Image` 按 `catId` 进行缓存，避免重复渲染。

---

## 猫咪生成

`PixelCatGenerationService.generateRandomCat()` 方法为领养流程生成一只随机猫咪：

```
generateRandomCat(boundHabitId, targetMinutes) -> Cat
```

**算法：**

1. 通过从 `pixel_cat_constants.dart` 中定义的有效值集合独立选取每个字段来生成随机外观参数
2. 分配随机性格（概率相等）
3. 从 `catNames` 池生成随机名字
4. 返回一个 `Cat` 对象，初始状态：`state: 'active'`、`totalMinutes: 0`、`targetMinutes: targetMinutes`，无 `id`（由 Firestore 在创建时分配）

**刷新机制：** 领养界面每次显示一只猫咪。用户可以点击「刷新」按钮重新随机生成一只新猫咪，确认领养前可以无限次刷新。每次刷新都会重新调用 `generateRandomCat()`。

---

## CatHouse 网格

CatHouse 用 **2 列 GridView** 布局替代了之前的房间场景。每只活跃猫咪以 `CatHouseCard` 组件展示，包含：

1. 合成的像素风精灵图（来自 `PixelCatRenderer`）
2. 猫咪名字
3. 当前心情指示器
4. 阶段进度条
5. 绑定习惯的名称

卡片按 `createdAt` 降序排列（最近领养的排在最前）。点击卡片导航至 `CatDetailScreen`。

休眠猫咪以 70% 不透明度显示。毕业猫咪以 50% 不透明度显示，并带有「已毕业」标签。

---

## 金币与配饰

### 金币经济

金币通过两个渠道获得：

1. **专注奖励**：每次专注会话完成后奖励 **每分钟 +10 金币**（按实际专注时长计算）。放弃但 ≥ 5 分钟的会话仍可获得按分钟计算的奖励；< 5 分钟则不获得金币。
2. **每日签到（月度系统）**：在 HomeScreen 加载时自动触发。每个日历月重置。奖励按日期类型差异化，并累积至月度里程碑。

#### 签到每日奖励

| 日期类型 | 金币 |
|---------|------|
| 工作日（周一至周五） | 10 |
| 周末（周六、周日） | 15 |

#### 月度里程碑

里程碑在当月累计签到天数达到阈值时一次性发放奖励：

| 里程碑 | 奖励金币 |
|--------|---------|
| 7 天 | +30 |
| 14 天 | +50 |
| 21 天 | +80 |
| 全月（所有天数） | +150 |

**每月签到最大收益：约 640-660 金币**（每日奖励 + 所有里程碑）。专注奖励（10 金币/分钟）仍为主要金币来源。

金币余额存储于 `users/{uid}` 文档的 `coins` 字段，并通过 `coinBalanceProvider` 暴露。签到进度追踪于 `users/{uid}/monthlyCheckIns/{YYYY-MM}`，通过 `monthlyCheckInProvider` 暴露。每分钟专注奖励率定义于 `pixel_cat_constants.dart` 的 `focusRewardCoinsPerMinute`。

### 配饰

配饰是叠加在猫咪精灵图上的装饰物品。每件配饰采用 **梯度定价**，购买后永久加入用户的 **道具箱**。猫咪可以 **装备** 一件配饰，装备后会渲染在精灵图上。配饰可在不同猫咪间自由转移。

#### 梯度定价体系

| 等级 | 价格（金币） | 攒币天数 | 代表饰品 |
|------|------------|---------|---------|
| Budget（基础） | 50 | 1 | 常见植物：Maple Leaf、Holly、Herbs、Clover、Daisy、全部 Dry 系列 |
| Standard（标准） | 100 | 2 | 花卉/浆果：全部 Poppy、Bluebells、Snapdragon + 普通项圈 |
| Premium（优质） | 150 | 3 | 稀有植物：Lavender、Catmint、Juniper、全部 Bulb + Bell/Bow 项圈 |
| Rare（稀有） | 250 | 5 | 野生配饰：羽毛、蛾翅/蝶翅/蝉翼 + Nylon 项圈 |
| Legendary（传说） | 350 | 7 | Rainbow/Spikes/Multi 项圈 + Lily of the Valley、Oak Leaves、Maple Seed |

价格数据定义于 `pixel_cat_constants.dart` 的 `accessoryPriceMap`。

#### 道具箱模型

配饰采用 **用户级道具箱** 模型，而非按猫存储：

- `users/{uid}.inventory` — 未装备的配饰 ID 列表（「箱子」）
- 每只猫的 `equippedAccessory` — 当前渲染在猫身上的一件配饰
- 每个配饰 ID **只存在于一个位置**：要么在 `inventory` 中，要么在某只猫的 `equippedAccessory` 上

#### 装备/卸下

- 每只猫有 `equippedAccessory` 字段（可空 String）—— 当前装备的配饰 ID
- 每只猫同时只能装备一件配饰
- 装备：`InventoryService.equipAccessory()` —— 从道具箱移除，设置到猫上（若猫已有装备，旧配饰自动返回道具箱）
- 卸下：`InventoryService.unequipAccessory()` —— 从猫上移除，返回道具箱
- 装备的配饰 ID 流经渲染管线：`Cat.equippedAccessory` → `PixelCatSprite.accessoryId` → `CatSpriteParams.accessoryId` → `PixelCatRenderer.renderCat(accessoryId:)`
- CatDetailScreen 显示「Accessories」卡片，数据来源为 `inventoryProvider`

#### 饰品商店

- 从 CatRoomScreen AppBar（商店图标）进入 → 路由 `/accessory-shop`
- 3 个标签：Plants、Wild、Collars
- 每个标签：3 列网格展示 `AccessoryCard` 组件
- 购买流程：点击未拥有饰品 → 确认对话框 → `CoinService.purchaseAccessory()`
- 购买的配饰进入 `users/{uid}.inventory`（不绑定到特定猫）
- 「已拥有」判断：配饰在 `inventory` 中 **或** 在任一猫的 `equippedAccessory` 上
- 配饰图层绘制在渲染管线的第 13 层

#### 道具箱页面

- 从 CatRoomScreen AppBar（道具箱图标）进入 → 路由 `/inventory`
- 两个区域：「箱中」（来自 `inventoryProvider`）和「已装备在猫上」（来自所有猫的 `equippedAccessory`）
- 点击箱中道具 → 选猫 → 装备到选中的猫
- 点击已装备道具 → 卸下（返回箱中）

### 签到横幅

`CheckInBanner` 是 HomeScreen 上的可视卡片组件，展示月度签到进度：

- **未签到**：显示「签到领取 +10 金币」，加载时自动触发签到。通过 SnackBar 显示成功反馈（如触发里程碑则额外提示）。
- **已签到**：显示「X/N 天 · 今日 +Y 金币」摘要。点击跳转至 `CheckInScreen`（`/check-in` 路由）查看完整月度详情。

数据来源：`monthlyCheckInProvider` + `hasCheckedInTodayProvider`。

### 签到详情页

`CheckInScreen`（`/check-in` 路由）展示完整月度签到详情：

1. **统计卡片** — 已签到 X/N 天，本月获得 Y 金币，下一个里程碑信息
2. **日历网格** — 7 列网格展示已签到/未签到/未来日期，周末列高亮显示
3. **里程碑卡片** — 7/14/21/全月里程碑进度，带已完成/待完成指示器
4. **奖励说明** — 工作日 10 金币、周末 15 金币参考卡片

---

## Hachimi 日记（AI 猫猫日记）

Hachimi 日记赋予每只猫每天撰写日记的能力，日记内容基于用户的习惯完成情况、猫咪的性格和心情。日记生成需要下载本地 LLM 模型并启用 AI 功能。

### 生成时机

1. **主触发**：完成专注会话后（`FocusCompleteScreen`），后台触发日记生成
2. **次触发**：打开 `CatDetailScreen` 时，若当天尚无日记则后台触发
3. **频率限制**：每只猫每天最多一条（`UNIQUE(cat_id, date)` 约束）

### Prompt 设计

日记 prompt 使用 ChatML 格式（`<|im_start|>system/assistant<|im_end|>`），包含：
- 猫咪名称、性格及性格描述
- 当前心情及距上次会话的小时数
- 成长阶段及进度百分比
- 习惯详情（今日专注、连续天数、总进度）
- 指令：2-4 句话、第一人称、根据性格调整语气
- 双语模板（根据 app locale 选择中文或英文）

**常量定义：** `lib/core/constants/llm_constants.dart` -> `class DiaryPrompt`

### 猫咪详情页集成

**日记预览卡** 插入在专注统计卡和提醒卡之间：

```
成长进度卡
专注统计卡
─────────────────────
🆕 Hachimi 日记卡
   📖 今日日记预览（2 行）
   [查看全部日记] →
─────────────────────
提醒卡
```

点击「查看全部」导航至 `CatDiaryScreen`（`/cat-diary` 路由）。

---

## 猫猫聊天（AI Chat）

用户可以与猫咪进行文字对话。猫咪根据其性格特征进行角色扮演式回复。聊天需要下载本地 LLM 模型并启用 AI 功能。

### 入口

`CatDetailScreen` AppBar 中的聊天图标按钮（仅在 `LlmAvailability.ready` 时可见）。

### 聊天 UI

标准消息列表布局：
- 猫猫消息在左侧（猫猫 sprite 头像）
- 用户消息在右侧
- 底部文本输入框 + 发送按钮
- 生成中显示 typing indicator
- Token-by-token 流式显示

### 上下文窗口管理

为保持推理速度，限制 prompt 的 token 预算：
- System prompt：~300 tokens
- 最近 10 轮对话（20 条消息）：~1500 tokens
- 用户新消息：~100 tokens
- 生成预算：最多 150 tokens

超出 20 条时，滑动窗口截断最早的消息。

### System Prompt

使用 ChatML 格式，包含性格、心情、成长阶段和习惯上下文。规则：保持猫猫角色、回复简短（1-3 句话）、偶尔使用猫咪拟声词、鼓励习惯完成、不提及 AI 身份。

**常量定义：** `lib/core/constants/llm_constants.dart` -> `class ChatPrompt`

---

## 模型测试聊天（Model Test Chat）

一个轻量聊天页面，位于 **设置 → AI 模型 → 「测试模型」**，用户下载本地 LLM 后可快速验证模型是否正常工作，无需导航至特定猫咪页面。

### 用途

下载 1.2 GB 模型后，用户需要一种零摩擦的方式确认一切正常。测试聊天提供了这个功能。

### 与猫猫聊天的区别

| 方面 | 猫猫聊天 | 模型测试聊天 |
|------|---------|------------|
| 入口 | CatDetailScreen AppBar | 设置 → AI 模型区块 |
| 角色 | 猫猫性格角色扮演 | 通用 AI 助手 |
| 消息持久化 | SQLite（应用重启后保留） | 仅内存（退出即丢失） |
| System prompt | 性格 + 心情 + 习惯上下文 | 简单的「helpful assistant」提示 |
| 服务层 | ChatService（含历史记录） | 直接调用 LlmService.generateStream() |

### 入口

「测试模型」按钮仅在 `LlmAvailability == ready` 时显示于 AI 模型设置区块。导航至 `/model-test-chat` 路由。

### System Prompt

通过 `TestPrompt.buildPrompt()` 使用最小化 ChatML 格式 prompt：
```
<|im_start|>system
You are a helpful AI assistant. Respond concisely in 1-2 sentences.
<|im_end|>
<|im_start|>user
{message}<|im_end|>
<|im_start|>assistant
```

**常量定义：** `lib/core/constants/llm_constants.dart` -> `class TestPrompt`

---

## 猫咪状态

| 状态 | 含义 | 显示 |
|------|------|------|
| `active` | 绑定活跃习惯，出现在 CatHouse 网格中 | 全色显示 |
| `dormant` | 习惯已停用，猫咪在休息 | 略微淡化 |
| `graduated` | 习惯已删除，猫咪永久移入相册 | 灰化，统计数据冻结 |

状态转换：

- `active` -> `dormant`：习惯标记为不活跃
- `active` -> `graduated`：习惯被删除（`FirestoreService` 中的 `deleteHabit`）
- `dormant` -> `active`：习惯重新激活（未来功能）

---

## 猫咪相册

猫咪相册（`allCatsProvider` —— 包含所有状态）显示：

- **活跃**猫咪：全色显示，可点击跳转至 CatHouse 位置
- **休眠**猫咪：70% 不透明度
- **毕业**猫咪：50% 不透明度，显示「已毕业」标签

猫咪按 `createdAt` 降序排列（最近领养的排在最前）。
