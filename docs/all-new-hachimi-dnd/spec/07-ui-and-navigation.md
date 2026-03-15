# UI 与导航结构规格

> SSOT for 3-tab navigation structure, Tab 3 Adventure Journal layout, new routes, tavern visual upgrade, and onboarding flow.
> **Status:** Draft
> **Evidence:** `docs/all-new-hachimi-dnd/specs/2026-03-15-dnd-integration-design.md` §1, §2.2, §9
> **Related:** `spec/01-primary-cat.md`, `spec/03-dice-and-checks.md`, `spec/04-scene-cards.md`, `lib/core/router/app_router.dart`, `lib/screens/home/home_screen.dart`
> **Changelog:** 2026-03-15 — 初版

---

## 1. 概述

Hachimi v2.0 保持 **3 Tab 导航结构**不变。Tab 3 从"成就"升级为"冒险者日志"，Tab 2 在保持网格布局的前提下进行酒馆视觉升级。新增 6 条路由支持 DnD 功能。

核心设计约束：**打开 App 到开始专注 ≤ 3 次点击**，导航变更不可破坏此路径。

---

## 2. Tab 结构变更总览

### 2.1 变更对比

```
变更前：📅 Today  |  🐱 Cat House    |  🏆 Achievements
变更后：📅 Today  |  🐱 Cat Tavern   |  📖 Journal
```

| Tab | 变更前 | 变更后 | 变更范围 |
|-----|-------|-------|---------|
| Tab 1 今日 | 精选猫 + 习惯列表 + 快速专注 | 不变 | 无 |
| Tab 2 猫咪酒馆 | Cat House（猫屋网格）| Cat Tavern（酒馆网格）| 视觉升级，布局不变 |
| Tab 3 冒险者日志 | Achievements（成就列表）| Journal（档案 + 骰子 + 冒险 + 成就）| 完整重构 |

### 2.2 Tab 1 约束

Tab 1 不做任何功能变更。专注完成后，显示"+1 🎲"提示（Toast 或底部 Banner），告知用户获得了一枚待投骰子。此提示不阻断用户操作。

---

## 3. Tab 2：猫咪酒馆视觉升级

### 3.1 升级范围

Tab 2 的升级**仅限视觉层**，不修改任何业务逻辑：

- 背景替换为像素风酒馆插画（日间 / 夜间两张）
- 添加装饰性精灵覆盖层（壁炉、木桌、书架等，8 个装饰件）
- 标题从"Cat House"改为"Cat Tavern"
- 猫咪网格布局、点击行为、选中状态保持完全不变

### 3.2 背景资源规格

| 资源 | 尺寸 | 文件路径 | 切换条件 |
|------|------|----------|---------|
| 酒馆背景（日间）| 360×640 px | `assets/images/tavern_bg_day.png` | 06:00–18:00 本地时间 |
| 酒馆背景（夜间）| 360×640 px | `assets/images/tavern_bg_night.png` | 18:00–06:00 本地时间 |

背景图以 `BoxFit.cover` 铺满 Tab 2 背景，不影响猫咪网格的可读性（需保证猫咪卡片有足够对比度）。

### 3.3 装饰精灵覆盖

8 个装饰件以 `Stack` + `Positioned` 方式叠加在背景与猫咪网格之间，均为静态图片，不可交互：

| 装饰 | 尺寸 | 位置（参考 360px 宽）|
|------|------|---------------------|
| 壁炉 | 32×32 | 右下角 |
| 木桌 ×2 | 32×32 | 左中 / 右中 |
| 书架 | 32×32 | 左上角 |
| 挂画 | 32×32 | 右上角 |
| 花桶 | 32×32 | 左下角 |
| 灯笼 ×2 | 32×32 | 顶部两侧 |

精确位置在 Phase 3 视觉验收时调整，此处仅为布局参考。

### 3.3.1 被动感知发现事件（Tab 2）

当被动感知触发发现事件时（详见 [spec/04](04-adventure.md) §被动感知发现事件），Tab 2 酒馆中展示：

- 一个闪烁的光点出现在酒馆场景中（如沙发下、窗台上、书架旁）
- 用户点击光点 → 弹出发现卡片（插画 + 描述文字 + 奖励）
- 触觉反馈：`HapticFeedback.selectionClick()`
- 每日最多 1 次

### 3.4 Phase 2 功能扩展（预留位置，Phase 1 不实现）

以下功能预留布局锚点，Phase 2/3 逐步添加，不在当前 UI 中显示：

- **冒险告示板（Notice Board）**：快捷进入场景选择，位于 Tab 2 上方区域
- **吧台（Bar Counter）**：快捷进入配件商店，位于 Tab 2 下方区域
- **队长专座（Captain's Seat）**：主哈基米固定展示在网格特殊位置（Phase 1 已实现）

---

## 4. Tab 3：冒险者日志

### 4.1 整体布局（线框图）

```
┌──────────────────────────────────┐
│  冒险者档案                         │  ← Section A：PrimaryCat 档案
│  [头像] 橘子 · Lv.3 · 游侠         │
│  STR  DEX  CON  INT  WIS  CHA    │
│  [ 六边形雷达图 CustomPainter ]   │
│  被动感知: 14  👁️               │  ← 10 + WIS mod + proficiency
├──────────────────────────────────┤
│  🎲 待投骰子 ×3  [立即投掷]        │  ← Section B：骰子入口
├──────────────────────────────────┤
│  📍 当前冒险                        │  ← Section C：冒险进度（无冒险时隐藏）
│  市集广场 ★☆☆  已完成 2/5 事件    │
│  [队伍：橘子 + 豆腐 + 芝麻]        │
├──────────────────────────────────┤
│  🏆 成就（163）           ▸        │  ← Section D：成就（折叠，展开显示原有列表）
│  最近解锁：连续打卡 7 天             │
└──────────────────────────────────┘
```

### 4.2 Section A：冒险者档案

| 元素 | 内容 | 数据来源 |
|------|------|---------|
| 猫咪头像 | PrimaryCat 完整像素渲染（现有 13 层管线）| `primaryCatProvider` |
| 名字 | PrimaryCat.name | `primaryCatProvider` |
| 等级标签 | "Lv.X" | `userLevelProvider`，由 XP 阈值计算 |
| 职业标签 | 职业名称 + 图标（等级 3 前显示"冒险者"）| `primaryCatProvider.playerClass` |
| 六维雷达图 | STR / DEX / CON / INT / WIS / CHA | `primaryCatAbilitiesProvider`（extension 计算） |
| 被动感知 | 10 + WIS 修正值 + 熟练加值（如有 Perception 技能） | `primaryCatAbilitiesProvider`（派生计算） |

**雷达图技术实现**：

- 使用 `CustomPainter` 绘制正六边形框 + 填充六边形
- 坐标系以中心点为原点，6 个顶点分别对应 6 个属性
- 属性值 10–20 映射为内径 0%–100%
- 颜色方案：填充色 = `AppTheme.primaryColor.withOpacity(0.3)`，边框色 = `AppTheme.primaryColor`
- 不依赖 `fl_chart` 库（零新依赖原则），纯 `CustomPainter` 实现

```dart
// 核心绘制逻辑（伪代码）
void paint(Canvas canvas, Size size) {
  final center = Offset(size.width / 2, size.height / 2);
  final radius = size.width / 2 * 0.8;
  // 1. 绘制背景六边形网格（3 层：33%、66%、100%）
  _drawHexGrid(canvas, center, radius);
  // 2. 绘制属性多边形
  final points = _buildAttributePoints(abilities, center, radius);
  _drawFilledPolygon(canvas, points, fillPaint);
  _drawPolygonBorder(canvas, points, strokePaint);
  // 3. 绘制属性标签
  _drawLabels(canvas, center, radius);
}
```

### 4.3 Section B：待投骰子入口

| 状态 | 显示内容 |
|------|---------|
| 有待投骰子（n > 0）| "🎲 待投骰子 ×n" + [立即投掷] 按钮（高亮） |
| 无待投骰子（n = 0）| "🎲 今日无待投骰子" + 灰色说明文字 |

点击"立即投掷"→ 导航至 `/dice-roll`（`DiceRollScreen`）。

待投骰子数量实时监听 `pendingDiceCountProvider`（`StreamProvider<int>`），专注完成后自动刷新，不需要手动下拉刷新。

### 4.4 Section C：当前冒险进度

| 状态 | 显示内容 |
|------|---------|
| 有进行中的冒险 | 场景名 + 星级评价 + 已完成事件数 / 总事件数 + 当前队伍预览 |
| 无进行中的冒险 | "还没有冒险" + [选择场景] 按钮 |
| 冒险已完成（待结算）| "冒险完成！" + [查看奖励] 按钮 |

点击场景卡区域 → 导航至 `/scene-select`（`SceneSelectScreen`）。

### 4.5 Section D：成就（折叠）

- 默认折叠，仅显示成就总数和最近解锁的一条
- 点击展开 → 展开显示完整的现有成就列表（`AchievementsScreen` 的 Widget 级复用）
- 成就系统逻辑不做任何修改，仅改变入口位置

---

## 5. 新增路由

### 5.1 路由表

| 路由路径 | Screen 类名 | 文件路径 | 入口点 |
|---------|-----------|---------|-------|
| `/starter-selection` | `StarterSelectionScreen` | `lib/screens/starter_selection/starter_selection_screen.dart` | Onboarding（全新用户） |
| `/adventure-journal` | `AdventureJournalScreen` | `lib/screens/adventure_journal/adventure_journal_screen.dart` | Tab 3 |
| `/scene-select` | `SceneSelectScreen` | `lib/screens/scene_select/scene_select_screen.dart` | Tab 3 Section C、Cat Detail 冒险区块 |
| `/dice-roll` | `DiceRollScreen` | `lib/screens/dice_roll/dice_roll_screen.dart` | Tab 3 Section B |
| `/party-select` | `PartySelectScreen` | `lib/screens/party_select/party_select_screen.dart` | Tab 3 Scene Select 前置流程 |
| `/class-select` | `ClassSelectScreen` | `lib/screens/class_select/class_select_screen.dart` | 等级 3 达成后触发弹窗 |

### 5.2 路由变更方式

在 `lib/core/router/app_router.dart` 中追加上述 6 条路由定义，使用 GoRouter `GoRoute`：

```dart
GoRoute(
  path: '/starter-selection',
  builder: (context, state) => const StarterSelectionScreen(),
),
GoRoute(
  path: '/adventure-journal',
  builder: (context, state) => const AdventureJournalScreen(),
),
// ... 其余 4 条
```

### 5.3 路由参数

| 路由 | 参数 | 类型 | 说明 |
|------|------|------|------|
| `/scene-select` | `catId`（可选）| `String?` | 若从 Cat Detail 进入，传入猫咪 ID 预选 |
| `/dice-roll` | 无 | — | 总是展示所有待投骰子 |
| `/party-select` | `sceneCardId` | `String` | 选中场景卡后进入队伍配置 |
| `/class-select` | 无 | — | 弹窗形式，通过 `showDialog` 调用，不作为独立路由 |

注：`/class-select` 使用 `showDialog` 覆盖当前页面（不 push 新路由），避免 Tab 导航被破坏。

---

## 6. Cat Detail 页冒险入口

Cat Detail 页新增"当前冒险"区块，位于猫咪属性面板下方：

```
┌──────────────────────────────────┐
│  [现有：猫咪外观 + 属性面板]          │
├──────────────────────────────────┤
│  📍 当前冒险                        │  ← 新增区块
│  市集广场  ★☆☆  2/5 事件           │  （有冒险时）
│  [继续冒险]  [更换场景]              │
│  ─────────────────────────────   │
│  还未开始冒险                        │  （无冒险时）
│  [选择场景卡]                        │
└──────────────────────────────────┘
```

- 点击"继续冒险"或"选择场景卡"→ `/scene-select?catId={id}`
- 此区块对**所有习惯猫**（CompanionCat）显示，用于为其绑定场景卡

---

## 7. Onboarding 流程（全新用户）

> 注意：v2.0 不存在老用户迁移问题（无真实用户），此流程仅针对全新安装用户。

### 7.1 流程步骤

```
App 首次启动
  ↓
Step 1：StarterSelectionScreen（御三家选择）
  - 展示 3 只原型猫（Action / Mind / Harmony）
  - 每只展示：性格标签 + 优势属性 + 色系预览
  - 可点击 [换一批外观] 最多 3 次（性格/原型固定，随机外观参数）
  - 点击选中猫 → 放大动画 → [确认选择] 按钮
  ↓
Step 2：命名
  - TextField 输入猫咪名字
  - 名字确认后：名字气泡从猫咪头顶弹出（动画）
  ↓
Step 3：第一次对话
  - 根据原型播放初始台词（来自 primary_cat_dialogues.dart）
  - Action："让我们一起动起来吧！"
  - Mind："好多知识等着我们去探索。"
  - Harmony："每一天，我们慢慢变好就好。"
  - 点击继续
  ↓
Step 4：创建第一个习惯（现有 Adoption Flow）
  - 复用现有 HabitCreationScreen，不修改
  ↓
Step 5：进入首页（Tab 1 Today）
  - 完成，正式进入 App
```

### 7.1.1 进化阶段展示（Onboarding）

StarterSelectionScreen 中每只原型猫卡片底部展示 **3 段进化条**（Stage Strip），对应：

| 阶段编号 | 阶段名称 | 阶段名（英文）|
|---------|---------|------------|
| 1 | 幼年 | Kitten |
| 2 | 少年 | Adolescent |
| 3 | 成年 | Adult |

**注意**：系统共 3 个成长阶段，无"长老（Senior）"阶段。进化条仅展示 3 格，不展示第 4 格。

### 7.2 御三家数据结构

```dart
class StarterArchetype {
  final String id;           // 'action' / 'mind' / 'harmony'
  final String displayName;  // 本地化后的名称
  final String personality;  // 'brave' / 'curious' / 'shy'
  final List<String> primaryAbilities; // ['STR', 'DEX'] 等
  final Color themeColor;    // 代表色
  final String openingLine;  // 第一次对话台词（本地化 key）
}
```

御三家配置存储于 `lib/core/constants/adventure_constants.dart`，不走网络请求。

### 7.3 Onboarding 状态管理

- 完成 Onboarding 后，在 SharedPreferences 写入 `onboarding_v2_complete = true`
- App 启动时检查此 flag，若未完成 → 跳转至 `/starter-selection`，否则正常启动
- Onboarding 流程中不可通过返回键跳过（Android back button 在此流程禁用）

---

## 8. 视觉与交互规范

### 8.1 雷达图尺寸

- 推荐尺寸：160×160 dp
- 属性标签字体大小：10sp
- 动画：Tab 3 首次渲染时从中心向外展开（300ms ease-out）

### 8.2 Tab 图标变更

| Tab | 旧图标 | 新图标 |
|-----|-------|-------|
| Tab 2 | `Icons.home` | `Icons.local_bar`（或像素风酒馆自定义 SVG）|
| Tab 3 | `Icons.emoji_events` | `Icons.auto_stories`（或像素风书本 SVG）|

### 8.3 骰子入口 Badge

当 `pendingDiceCount > 0` 时，Tab 3 图标右上角显示数字 Badge（使用 Flutter 内置 `Badge` Widget）。Badge 颜色：`AppTheme.errorColor`（红色）。

---

## 9. 技术实现要点

### 9.1 Tab 3 Screen 拆分要求

`AdventureJournalScreen` 包含 4 个 Section，每个 Section 拆分为独立 Widget：

```
AdventureJournalScreen
  ├── AdventurerProfileSection     (Section A)
  │     └── AbilityRadarChart      (CustomPainter)
  ├── PendingDiceSection           (Section B)
  ├── ActiveAdventureSection       (Section C)
  └── AchievementsSummarySection   (Section D)
```

每个 Section Widget 文件不超过 800 行（代码质量红线）。

### 9.2 Provider 依赖（Tab 3）

```
AdventureJournalScreen
  ├── ref.watch(primaryCatProvider)         → Section A 数据
  ├── ref.watch(primaryCatAbilitiesProvider) → 雷达图数据
  ├── ref.watch(userLevelProvider)           → 等级 + 熟练加值
  ├── ref.watch(pendingDiceCountProvider)    → Section B 骰子数
  ├── ref.watch(activeAdventureProvider)     → Section C 冒险进度
  └── ref.watch(achievementSummaryProvider) → Section D 成就摘要
```

### 9.3 Tab 2 视觉升级实现

```dart
// CatRoomScreen（修改后）的 build 方法示意
Stack(
  children: [
    // Layer 1：酒馆背景
    TavernBackground(isDay: _isDaytime()),
    // Layer 2：装饰精灵（静态）
    const TavernDecorations(),
    // Layer 3：现有猫咪网格（完全不变）
    ExistingCatGrid(),
  ],
)
```

`TavernBackground` 和 `TavernDecorations` 为新增 Widget，不修改现有 `ExistingCatGrid` 的任何逻辑。

---

## 10. 验收标准

- [ ] Tab 3 显示冒险者档案，数据来自正确的 PrimaryCat Provider
- [ ] 雷达图通过 `CustomPainter` 正确渲染 6 个属性值，属性值变化时图形实时更新
- [ ] Tab 3 Section B：待投骰子数量实时更新（专注完成后无需手动刷新）
- [ ] Tab 3 Section C：有进行中冒险时显示进度，无冒险时显示引导入口
- [ ] Tab 3 Section D：成就列表仍可访问（折叠展开正常）
- [ ] Tab 3 图标 Badge 在 `pendingDiceCount > 0` 时正确显示数字
- [ ] 6 条新路由均可正常导航，参数传递正确
- [ ] `/class-select` 以弹窗形式覆盖，不破坏 Tab 导航
- [ ] Tab 2 背景切换为酒馆主题（日间 / 夜间），猫咪网格布局和功能不变
- [ ] Onboarding 完整流程：御三家选择 → 命名 → 初始对话 → 创建习惯 → 进入首页
- [ ] Onboarding 完成后写入 `onboarding_v2_complete` flag，重启不再触发
- [ ] Tab 1 专注完成后显示"+1 🎲"提示，不阻断用户操作
- [ ] 打开 App → 开始专注 ≤ 3 次点击（回归验证，不可破坏）
- [ ] 被动感知数值在 Tab 3 冒险者档案中显示
- [ ] Tab 2 发现事件气泡正确出现和消失
- [ ] Onboarding 展示 3 段进化（无 Senior）
