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

金币通过 **每日签到** 获得：
- 当天首次会话奖励 **+50 金币**
- 每个日历日仅一次签到奖励（通过用户文档上的 `lastCheckInDate` 追踪）

金币余额存储于 `users/{uid}` 文档的 `coins` 字段，并通过 `coinBalanceProvider` 暴露。

### 配饰

配饰是叠加在猫咪精灵图上的装饰物品。每件配饰售价 **150 金币**，购买后永久解锁至对应猫咪。

- 已购买的配饰存储于猫咪的 `accessories` 字段（`List<String>` 类型的配饰 ID 列表）
- 配饰图层绘制在第 13 层（色调叠加）之上
- 通过 `CatDetailScreen` 中的 `AccessoryShopSection` 组件购买配饰

### 签到横幅

`CheckInBanner` 组件在用户尚未领取当日金币奖励时显示于 HomeScreen 上。当用户完成当天首次专注会话后，横幅更新为显示「+50 金币已到账！」，同时 `hasCheckedInTodayProvider` 翻转为 `true`。

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
