---
level: 2
file_id: plan_03
parent: plan_01
status: pending
created: 2026-03-19 22:00
children: []
---

# 轨道二：LUMI 核心 UI + 导航重组

## 1. 模块概述

### 1.1 交付目标

轨道二是 LUMI 转型的 **UI 实现层 + 导航重组层**，负责将旧 4 Tab 架构完整替换为 LUMI 3-Tab 架构。交付完成后：

- 导航从 `觉知 | 习惯 | 猫咪 | 我的` 变为 `✦ 今天 | 🗺 旅程 | 👤 我的`
- 新 Onboarding 4 页温暖提问替换旧猫咪引导
- `TodayScreen` 完整可用：QuickLightCard + HabitSnapshot + InspirationCard
- `JourneyScreen` 周视图完整可用（月/年/探索为占位）
- `ProfileScreen` 重组：LUMI 统计 + 猫咪伴侣降为二级入口
- `_FirstHabitGate` 强制猫咪领养彻底移除
- `FeatureGateProvider` 渐进解锁机制生效

### 1.2 前置依赖

| 依赖项 | 来源 | 用途 |
|--------|------|------|
| `Mood` 枚举 | `lib/models/mood.dart` | MoodSelector 渲染 5 种心情 |
| `DailyLight` 模型 | `lib/models/daily_light.dart` | QuickLightCard / DailyLightScreen 读写 |
| `WeeklyPlan` 模型 | `lib/models/weekly_plan.dart` | WeeklyPlanCard 读写 |
| `WeeklyReview` 模型 | `lib/models/weekly_review.dart` | WeeklyReviewCard 读写 |
| `Worry` 模型 + `WorryStatus` 枚举 | `lib/models/worry.dart` | WorryJarCard / WorryEditScreen |
| `LumiProfile` 模型 | `lib/models/lumi_profile.dart` | Onboarding 数据存储、ProfileScreen 展示 |
| `awarenessRepositoryProvider` | `lib/providers/service_providers.dart` | 觉知数据操作 |
| `worryRepositoryProvider` | `lib/providers/service_providers.dart` | 烦恼数据操作 |
| `todayLightProvider` | `lib/providers/awareness_providers.dart` | 今日一点光状态 |
| `activeWorriesProvider` | `lib/providers/awareness_providers.dart` | 活跃烦恼列表 |
| `featureGateProvider` | `lib/providers/feature_gate_provider.dart` | 渐进解锁判断 |
| `lumiProfileProvider` | `lib/providers/lumi_profile_provider.dart` | LUMI 用户资料 |

### 1.3 与其他轨道的关系

```
轨道一（数据基础）
    │  提供模型、Repository、Provider
    ▼
【轨道二（核心 UI + 导航重组）】  ← 本文档
    │
    ├──▶ 轨道三（集成）
    │       - 通知调度
    │       - 成就系统扩展
    │       - 飞轮桥接（FocusComplete → 一点光）
    │
    └──▶ 轨道四（月度/年度 + 历史视图）
            - JourneyScreen 本月/年度/探索 Segment 填充
            - 心情热力图、标签统计
```

### 1.4 主题兼容策略

所有新增 Widget 必须在 **Material 3** 和 **Retro Pixel** 两种主题下正确渲染：

- **颜色**：统一使用 `Theme.of(context).colorScheme.*`，绝对禁止硬编码颜色值
- **形状**：使用 `Theme.of(context).cardTheme.shape`，Retro Pixel 模式通过 `ThemeSkin` 自动注入 `PixelBorderShape`
- **文字**：使用 `Theme.of(context).textTheme.*`
- **间距**：使用 `AppSpacing` 常量
- **背景**：Screen 级别使用 `AppScaffold`

---

## 2. 导航重组：4 Tab → 3 Tab

### 2.1 当前结构（待替换）

**文件**：`lib/screens/home/home_screen.dart`

```
当前 4 Tab：
  Tab 0: AwarenessScreen  — 觉知
  Tab 1: TodayTab          — 习惯
  Tab 2: CatRoomScreen     — 猫咪
  Tab 3: ProfileScreen     — 我的
```

### 2.2 新结构

```
新 3 Tab：
  Tab 0: TodayScreen       — ✦ 今天
  Tab 1: JourneyScreen     — 🗺 旅程
  Tab 2: ProfileScreen     — 👤 我的（重组后）
```

### 2.3 `HomeScreen` 改动明细

```dart
// 旧
static const _screens = <Widget>[
  AwarenessScreen(),
  TodayTab(),
  CatRoomScreen(),
  ProfileScreen(),
];

// 新
static const _screens = <Widget>[
  TodayScreen(),      // Tab 0：今天
  JourneyScreen(),    // Tab 1：旅程
  ProfileScreen(),    // Tab 2：我的（重组后）
];
```

**NavigationBar destinations**：

| 索引 | Tab | icon（未选中）| selectedIcon | label L10n key |
|------|-----|-------------|-------------|---------------|
| 0 | 今天 | `Icons.auto_awesome_outlined` | `Icons.auto_awesome` | `homeTabToday` |
| 1 | 旅程 | `Icons.explore_outlined` | `Icons.explore` | `homeTabJourney` |
| 2 | 我的 | `Icons.person_outline` | `Icons.person` | `homeTabProfile` |

**FAB 变更**：

- 旧：Tab 1 显示添加习惯 FAB
- 新：Tab 0 显示 FAB（快速记录一点光），点击展开 `DailyLightScreen`

### 2.4 `_FirstHabitGate` 移除

在 `app.dart`（或 `home_screen.dart` 外层）中查找 `_FirstHabitGate` 或类似的"首次必须领养猫咪"逻辑，完全删除。新用户 Onboarding 完成后直接进入 `TodayScreen`，不再强制领养。

---

## 3. Onboarding 重写

### 3.1 概述

完全替换 `lib/screens/onboarding/onboarding_screen.dart`（当前 3 页猫咪引导）为 LUMI 4 页温暖提问。

**新文件路径**：`lib/screens/onboarding/lumi_onboarding_screen.dart`

**旧文件处理**：`onboarding_screen.dart` + `components/` 下 3 个组件标记为 deprecated，待清理删除。

### 3.2 四页结构

#### Page 1：欢迎

```
┌───────────────────────────────────────┐
│                                       │
│            ✦  ✧  ✦                    │
│      （星星缓缓出现动画）               │
│                                       │
│             你好                       │
│          这里是 LUMI                   │
│                                       │
│    每写一行，都是在为你的               │
│    内心宇宙添一颗星                    │
│                                       │
│           [继续]                       │
└───────────────────────────────────────┘
```

- 星星动画：3 颗四角星 `✦` 依次淡入（`AnimatedOpacity` 级联延迟 300ms）
- 主标题：`headlineMedium`，品牌核心语
- 按钮：`FilledButton`（"继续"）

#### Page 2：你是谁

```
┌───────────────────────────────────────┐
│                                       │
│     这本手册的主人是                    │
│     ┌─────────────────────────┐       │
│     │ [名字输入框]              │       │
│     └─────────────────────────┘       │
│                                       │
│     你的生日                           │
│     [月] 月 [日] 日                    │
│                                       │
│           [下一步]                     │
└───────────────────────────────────────┘
```

- 名字输入：`TextField`，`hintText: "写下你的名字"`
- 生日：两个 `DropdownButton`（月 1-12、日 1-31）
- 名字为必填，生日可选
- 按钮：名字为空时 disabled

#### Page 3：开始日期

```
┌───────────────────────────────────────┐
│                                       │
│     你想从哪天开始这段旅程？            │
│                                       │
│     ┌─────────────────────────┐       │
│     │     [日历选择器]          │       │
│     │     （默认：今天）         │       │
│     └─────────────────────────┘       │
│                                       │
│     小字：你可以随时修改                │
│                                       │
│           [下一步]                     │
└───────────────────────────────────────┘
```

- 日历：`showDatePicker` 或内联日历
- 默认值：`DateTime.now()`
- 选择范围：今天往前 30 天 ~ 今天

#### Page 4：快速导览

```
┌───────────────────────────────────────┐
│                                       │
│     LUMI 只有三件小事                  │
│                                       │
│     ┌─────────────────────────┐       │
│     │ ✦ 睡前写一句             │       │
│     │   今天的一点光            │       │
│     └─────────────────────────┘       │
│     ┌─────────────────────────┐       │
│     │ ✦ 周末回顾               │       │
│     │   三个幸福时刻            │       │
│     └─────────────────────────┘       │
│     ┌─────────────────────────┐       │
│     │ ✦ 写下烦恼               │       │
│     │   放进烦恼罐              │       │
│     └─────────────────────────┘       │
│                                       │
│     准备好了吗？                       │
│           [开始旅程]                   │
└───────────────────────────────────────┘
```

- 三个卡片：`Card` + `ListTile` 简化布局
- "开始旅程" 按钮：`FilledButton`，触发数据保存 + 导航到 `HomeScreen`

### 3.3 数据保存

Onboarding 完成时写入 `materialized_state`：

```dart
{
  'lumi_user_name': String,       // 必填
  'lumi_birthday': String?,       // 'MM-dd'，可选
  'lumi_start_date': String,      // 'yyyy-MM-dd'
  'lumi_onboarding_version': 2,   // 区分新旧 Onboarding
}
```

### 3.4 Onboarding 后行为

1. 保存数据 → 设置 `onboardingComplete = true`
2. 导航到 `HomeScreen`（Tab 0: TodayScreen）
3. **不经过猫咪领养**
4. 首次打开 TodayScreen 显示引导气泡："写下今天的第一束光 ✦"

---

## 4. TodayScreen（Tab 0）

### 4.1 概述

**文件路径**：`lib/screens/today/today_screen.dart`

TodayScreen 是用户每天打开 App 的第一个页面，设计为 **10 秒可完成** 的极简记录面。

### 4.2 视觉布局

```
┌─────────────────────────────────────────────┐
│  ContentWidthConstraint                     │
│  ┌─────────────────────────────────────────┐│
│  │ CustomScrollView                        ││
│  │                                         ││
│  │ SliverAppBar(floating: true)            ││
│  │   title: "✦ 今天"                       ││
│  │   subtitle: "3 月 19 日，星期三"         ││
│  │                                         ││
│  │ ── 1. QuickLightCard ──                 ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ 已记录状态：                         │ ││
│  │ │   [😌] "阳光很好" · 14:30           │ ││
│  │ │   [编辑] 按钮                        │ ││
│  │ │                                     │ ││
│  │ │ 未记录状态：                         │ ││
│  │ │   MoodSelector(compact) 5 emoji     │ ││
│  │ │   TextField(一句话，inline)           │ ││
│  │ │   [记录 ✦] 按钮                      │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ ── 2. HabitSnapshot ──                  ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ "今日习惯" section header            │ ││
│  │ │                                     │ ││
│  │ │ habitsProvider.when(...)             │ ││
│  │ │   有习惯: 简化列表 + 勾选状态         │ ││
│  │ │   无习惯: SizedBox.shrink()          │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ ── 3. InspirationCard ──                ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ Card(surfaceVariant)                 │ ││
│  │ │   ✦ 灵感轮换文案                     │ ││
│  │ │   "在厌倦之前就收笔"                  │ ││
│  │ │   — 张晓萌                           │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ SizedBox(height: 100) // NavBar space   ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

### 4.3 QuickLightCard 规格

**文件路径**：`lib/widgets/today/quick_light_card.dart`

```dart
/// 快速一点光卡片 — inline 心情 + 一句话，10 秒完成。
///
/// 两种状态：
/// - 未记录：显示 MoodSelector(compact) + TextField + 保存按钮
/// - 已记录：显示心情 emoji + 文字预览 + 编辑按钮
class QuickLightCard extends ConsumerStatefulWidget {
  const QuickLightCard({super.key});
}
```

**未记录状态布局**：

```
┌─────────────────────────────────────────┐
│  Card                                   │
│                                         │
│  "今天有什么让你微笑的事？"              │
│   bodyLarge, onSurfaceVariant           │
│                                         │
│  [😄] [🙂] [😌] [😔] [😢]             │
│  MoodSelector(compact: true)            │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ TextField                       │    │
│  │ hintText: "写一句话..."          │    │
│  │ maxLines: 2                     │    │
│  └─────────────────────────────────┘    │
│                                         │
│  Align(right):                          │
│    FilledButton.tonal("记录 ✦")          │
│    disabled if mood == null              │
│                                         │
└─────────────────────────────────────────┘
```

**已记录状态布局**：

```
┌─────────────────────────────────────────┐
│  Card                                   │
│                                         │
│  Row:                                   │
│    [😌 emoji] + "阳光很好" (bodyMedium)  │
│    Spacer                               │
│    Text("14:30") + IconButton(编辑)      │
│                                         │
└─────────────────────────────────────────┘
```

**交互**：

1. 未记录 → 选心情 → 写一句话（可选）→ 点击「记录 ✦」→ 保存 → 卡片变为已记录状态
2. 已记录 → 点击编辑 → 跳转 `DailyLightScreen`（完整编辑模式）
3. 保存失败 → `SnackBar` 显示错误信息

### 4.4 HabitSnapshot 规格

**文件路径**：`lib/widgets/today/habit_snapshot.dart`

```dart
/// 今日习惯快照 — 显示来自月度计划的习惯勾选状态。
///
/// 如果用户没有任何习惯，此 Widget 返回 SizedBox.shrink()。
class HabitSnapshot extends ConsumerWidget {
  const HabitSnapshot({super.key});
}
```

- 复用 `habitsProvider`，以简化列表展示
- 每个条目：`ListTile`（leading: 勾选图标，title: 习惯名，subtitle: 今日分钟数）
- 点击条目：导航到 `AppRouter.focusSetup`
- 无习惯时：不显示（`SizedBox.shrink()`），不显示"去领养猫"之类的引导

### 4.5 InspirationCard 规格

**文件路径**：`lib/widgets/today/inspiration_card.dart`

```dart
/// 灵感提示卡 — 来自张晓萌语录的每日轮换激励。
class InspirationCard extends StatelessWidget {
  const InspirationCard({super.key});
}
```

- 内容来源：`lib/core/constants/inspiration_constants.dart`（静态常量列表）
- 轮换逻辑：`dayOfYear % inspirations.length`
- 布局：`Card(color: surfaceContainerLow)` + `Text`（引用文案）+ `Text`（来源）
- 文案风格："在厌倦之前就收笔" — 张晓萌

---

## 5. JourneyScreen（Tab 1）

### 5.1 概述

**文件路径**：`lib/screens/journey/journey_screen.dart`

JourneyScreen 是 LUMI 的 **时间维度旅程**，通过 `SegmentedButton` 在不同时间粒度间切换。

### 5.2 SegmentedButton 切换

```dart
enum JourneySegment { week, month, year, explore }
```

| Segment | label | 解锁条件（FeatureGateProvider）|
|---------|-------|------------------------------|
| 本周 | `journeySegmentWeek` | Day 1（记录 1 天）|
| 本月 | `journeySegmentMonth` | Day 3（记录 3 天）|
| 年度 | `journeySegmentYear` | Day 14（记录 14 天）|
| 探索 | `journeySegmentExplore` | Day 30（记录 30 天）|

**未解锁 Segment 的呈现**：

不使用灰色锁图标。使用温暖的占位卡片：

```
┌─────────────────────────────────────────┐
│  Center                                 │
│                                         │
│  ✦                                      │
│  "再记录 X 天，就可以开始年度规划了"      │
│  "不急，慢慢来"                          │
│                                         │
│  bodyMedium, onSurfaceVariant           │
└─────────────────────────────────────────┘
```

### 5.3 视觉布局

```
┌─────────────────────────────────────────────┐
│  ContentWidthConstraint                     │
│  ┌─────────────────────────────────────────┐│
│  │ NestedScrollView                        ││
│  │                                         ││
│  │ SliverAppBar(floating: true)            ││
│  │   title: "旅程"                         ││
│  │   bottom: SegmentedButton               ││
│  │     [本周] [本月] [年度] [探索]          ││
│  │                                         ││
│  │ body: AnimatedSwitcher                  ││
│  │   [_WeekView]                           ││
│  │   [_MonthView]    (占位)                ││
│  │   [_YearView]     (占位)                ││
│  │   [_ExploreView]  (占位)                ││
│  │                                         ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

### 5.4 周视图（`_WeekView`）— 本轨道完整实现

```
┌─────────────────────────────────────────────┐
│  ListView                                   │
│                                             │
│  ── 1. WeeklyPlanCard ──                    │
│  ┌─────────────────────────────────────────┐│
│  │ "本周计划" section header               ││
│  │                                         ││
│  │ 已填写: 一句话预览 + 四象限概要           ││
│  │ 未填写: "给这周的自己说句话？"            ││
│  │         [开始规划] 按钮                   ││
│  │                                         ││
│  │ onTap → WeeklyPlanScreen               ││
│  └─────────────────────────────────────────┘│
│                                             │
│  ── 2. WeekMoodDots ──                     │
│  ┌─────────────────────────────────────────┐│
│  │ Row: 7 天心情圆点（Mon-Sun）             ││
│  │ 已记录: 对应心情颜色圆点                  ││
│  │ 未记录: 灰色空心圆点                      ││
│  └─────────────────────────────────────────┘│
│                                             │
│  ── 3. WeeklyReviewCard ──                 │
│  ┌─────────────────────────────────────────┐│
│  │ "周回顾" section header                 ││
│  │                                         ││
│  │ 已完成: 幸福时刻数 + 感恩主题摘要         ││
│  │ 未完成: "回忆本周的幸福时刻"              ││
│  │         [开始回顾] 按钮                   ││
│  │                                         ││
│  │ onTap → WeeklyReviewScreen             ││
│  └─────────────────────────────────────────┘│
│                                             │
│  ── 4. WorryJarCard ──                     │
│  ┌─────────────────────────────────────────┐│
│  │ "烦恼处理器" section header             ││
│  │                                         ││
│  │ activeWorriesProvider.when(...)          ││
│  │   empty: "没有烦恼，真好！"              ││
│  │   data: WorryItemCard list (max 3)      ││
│  │         + "查看全部" TextButton           ││
│  │                                         ││
│  │ OutlinedButton("+ 写下烦恼")             ││
│  │   → WorryEditScreen(worryId: null)      ││
│  └─────────────────────────────────────────┘│
│                                             │
│  SizedBox(height: 100)                      │
└─────────────────────────────────────────────┘
```

### 5.5 月/年/探索视图（占位实现）

本轨道仅实现占位，轨道四填充完整内容：

```dart
class _MonthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gate = ref.watch(featureGateProvider);
    if (!gate.monthUnlocked) {
      return _LockedPlaceholder(
        daysNeeded: gate.daysUntilMonth,
        message: context.l10n.journeyLockedMonth,
      );
    }
    return Center(
      child: Text(context.l10n.journeyComingSoon),
    );
  }
}
```

---

## 6. ProfileScreen 重组

### 6.1 概述

**文件路径**：`lib/screens/profile/profile_screen.dart`（原地重构）

ProfileScreen 从"用户统计 + 成就"变为"LUMI 统计 + 猫咪伴侣入口 + 设置"。

### 6.2 新布局

```
┌─────────────────────────────────────────────┐
│  AppScaffold                                │
│  CustomScrollView                           │
│  ┌─────────────────────────────────────────┐│
│  │ SliverAppBar                            ││
│  │   用户头像 + 名字 + 开始日期             ││
│  │                                         ││
│  │ ── 1. LumiStatsCard ──                  ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ Row:                                │ ││
│  │ │   ✦ 星星总数    📅 记录天数           │ ││
│  │ │   🔥 当前连续   💪 最长连续           │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ ── 2. CatCompanionCard ──              ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ Card:                               │ ││
│  │ │   PixelCatSprite + "你的猫咪伙伴"    │ ││
│  │ │   subtitle: 猫咪数量                 │ ││
│  │ │   onTap → CatRoomScreen             │ ││
│  │ │                                     │ ││
│  │ │ 无猫咪时:                            │ ││
│  │ │   "领养一只猫咪伙伴？"               │ ││
│  │ │   onTap → AdoptionFlowScreen        │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ ── 3. 设置区域 ──                       ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ ListTile: 提醒时间                   │ ││
│  │ │ ListTile: 语言                      │ ││
│  │ │ ListTile: 主题                      │ ││
│  │ │ ListTile: UI 风格                   │ ││
│  │ │ ListTile: 数据导出                   │ ││
│  │ │ ListTile: 关于 LUMI                 │ ││
│  │ └─────────────────────────────────────┘ ││
│  │                                         ││
│  │ ── 4. 账号区域 ──                       ││
│  │ ┌─────────────────────────────────────┐ ││
│  │ │ 登出 / 删除账号                      │ ││
│  │ └─────────────────────────────────────┘ ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

### 6.3 关键变更

| 项目 | 旧 | 新 |
|------|----|----|
| 顶部统计 | 专注总时长 + 猫咪数 | LUMI 星星 + 记录天数 + 连续天数 |
| 猫咪入口 | 无（猫咪是一级 Tab）| `CatCompanionCard`（二级入口）|
| 成就入口 | 无（成就是独立 Tab 或子页面）| 暂时移除（轨道三恢复）|
| 习惯入口 | 无（习惯是一级 Tab）| 无（习惯在月度规划中）|

---

## 7. 渐进解锁（FeatureGateProvider）

### 7.1 概述

**文件路径**：`lib/providers/feature_gate_provider.dart`

渐进解锁的核心原则："不用写满、不用做对、不用从头到尾完成。从你想开始的地方开始。"

### 7.2 解锁时间表

| 阶段 | 条件 | 解锁内容 | UI 体现 |
|------|------|---------|---------|
| Day 0 | 完成 Onboarding | TodayScreen（每日一点光）| 默认可用 |
| Day 1 | 记录 1 天 | JourneyScreen · 本周视图 | 本周 Segment 可点击 |
| Day 3 | 记录 3 天 | JourneyScreen · 本月视图 | 本月 Segment 可点击 |
| Day 14 | 记录 14 天 | JourneyScreen · 年度视图 | 年度 Segment 可点击 |
| Day 30 | 记录 30 天 | JourneyScreen · 探索（月度活动）| 探索 Segment 可点击 |
| Day 90 | 记录 90 天 | ProfileScreen · 成长回望 | 新卡片出现 |

### 7.3 Provider 定义

```dart
/// 记录天数 = 用户有多少天记录了 DailyLight。
/// 不要求连续，Day 3 只需要累计 3 天有记录。
final featureGateProvider = Provider<FeatureGate>((ref) {
  final totalDays = ref.watch(totalLightDaysProvider).value ?? 0;
  return FeatureGate(totalLightDays: totalDays);
});

class FeatureGate {
  final int totalLightDays;

  const FeatureGate({required this.totalLightDays});

  bool get weekUnlocked => totalLightDays >= 1;
  bool get monthUnlocked => totalLightDays >= 3;
  bool get yearUnlocked => totalLightDays >= 14;
  bool get exploreUnlocked => totalLightDays >= 30;
  bool get growthReviewUnlocked => totalLightDays >= 90;

  int get daysUntilWeek => (1 - totalLightDays).clamp(0, 1);
  int get daysUntilMonth => (3 - totalLightDays).clamp(0, 3);
  int get daysUntilYear => (14 - totalLightDays).clamp(0, 14);
  int get daysUntilExplore => (30 - totalLightDays).clamp(0, 30);
}
```

### 7.4 未解锁呈现

温暖提示卡片（不使用灰色锁图标）：

```dart
class LockedSegmentPlaceholder extends StatelessWidget {
  final int daysRemaining;
  final String featureName;

  // 显示：✦ + "再记录 {daysRemaining} 天，就可以开始{featureName}了。不急，慢慢来"
}
```

---

## 8. Widget 规格

### 8.1 新增 Widget 清单

| 文件路径 | Widget | 用途 |
|---------|--------|------|
| `lib/widgets/today/quick_light_card.dart` | `QuickLightCard` | TodayScreen 内联一点光记录 |
| `lib/widgets/today/habit_snapshot.dart` | `HabitSnapshot` | TodayScreen 今日习惯快照 |
| `lib/widgets/today/inspiration_card.dart` | `InspirationCard` | TodayScreen 灵感轮换卡片 |
| `lib/widgets/journey/weekly_plan_card.dart` | `WeeklyPlanCard` | JourneyScreen 周计划摘要卡 |
| `lib/widgets/journey/weekly_review_card.dart` | `WeeklyReviewCard` | JourneyScreen 周回顾摘要卡 |
| `lib/widgets/journey/worry_jar_card.dart` | `WorryJarCard` | JourneyScreen 烦恼处理器摘要卡 |
| `lib/widgets/journey/week_mood_dots.dart` | `WeekMoodDots` | JourneyScreen 7 天心情圆点概览 |
| `lib/widgets/journey/locked_segment_placeholder.dart` | `LockedSegmentPlaceholder` | 未解锁 Segment 温暖占位 |
| `lib/widgets/profile/lumi_stats_card.dart` | `LumiStatsCard` | ProfileScreen LUMI 统计卡 |
| `lib/widgets/profile/cat_companion_card.dart` | `CatCompanionCard` | ProfileScreen 猫咪伴侣入口 |

### 8.2 复用现有 Widget

| Widget | 来源 | 在本轨道中的用途 |
|--------|------|----------------|
| `MoodSelector` | `lib/widgets/awareness/mood_selector.dart` | QuickLightCard 内联心情选择 |
| `LightInputCard` | `lib/widgets/awareness/light_input_card.dart` | DailyLightScreen 文字输入 |
| `TagSelector` | `lib/widgets/awareness/tag_selector.dart` | DailyLightScreen 标签选择 |
| `WorryItemCard` | `lib/widgets/awareness/worry_item_card.dart` | WorryJarCard 烦恼条目 |
| `HappyMomentCard` | `lib/widgets/awareness/happy_moment_card.dart` | WeeklyReviewScreen 幸福时刻 |
| `CatBedtimeAnimation` | `lib/widgets/awareness/cat_bedtime_animation.dart` | DailyLightScreen 保存后动画 |
| `AwarenessEmptyState` | `lib/widgets/awareness/awareness_empty_state.dart` | 各处空状态 |
| `ContentWidthConstraint` | `lib/widgets/content_width_constraint.dart` | 全部 Screen 宽度约束 |
| `AppScaffold` | `lib/widgets/app_scaffold.dart` | 全部 Screen 外层 |
| `PixelCatSprite` | `lib/widgets/pixel_cat_sprite.dart` | CatCompanionCard 猫咪展示 |

---

## 9. Screen 规格

### 9.1 新增 Screen 清单

| 文件路径 | Screen | 用途 |
|---------|--------|------|
| `lib/screens/today/today_screen.dart` | `TodayScreen` | Tab 0：今天 |
| `lib/screens/journey/journey_screen.dart` | `JourneyScreen` | Tab 1：旅程 |
| `lib/screens/onboarding/lumi_onboarding_screen.dart` | `LumiOnboardingScreen` | 新 LUMI Onboarding |

### 9.2 保留并修改的 Screen

| 文件路径 | 改动 |
|---------|------|
| `lib/screens/home/home_screen.dart` | 4 Tab → 3 Tab，导航目标替换 |
| `lib/screens/profile/profile_screen.dart` | 重组为 LUMI 统计 + 猫咪二级入口 |
| `lib/screens/awareness/daily_light_screen.dart` | 保留完整记录页，从 QuickLightCard 编辑入口进入 |
| `lib/screens/awareness/weekly_review_screen.dart` | 保留，从 JourneyScreen WeeklyReviewCard 进入 |
| `lib/screens/awareness/worry_processor_screen.dart` | 保留，从 JourneyScreen WorryJarCard "查看全部" 进入 |
| `lib/screens/awareness/worry_edit_screen.dart` | 保留 |

### 9.3 移除或降级的 Screen

| 文件路径 | 处理 |
|---------|------|
| `lib/screens/home/components/today_tab.dart` | 被 `TodayScreen` 替代，标记 deprecated |
| `lib/screens/awareness/awareness_screen.dart` | 3 子 Tab 结构不再使用，由 JourneyScreen 承担，标记 deprecated |
| `lib/screens/onboarding/onboarding_screen.dart` | 被 `LumiOnboardingScreen` 替代，标记 deprecated |
| `lib/screens/cat_room/cat_room_screen.dart` | 从一级 Tab 降为 ProfileScreen 二级入口，代码不变 |

---

## 10. 路由变更

### 10.1 新增路由

在 `lib/core/router/app_router.dart` 中：

```dart
// --- LUMI Core (Track 2) ---
static const String today = '/today';           // TodayScreen
static const String journey = '/journey';       // JourneyScreen
static const String weeklyPlan = '/weekly-plan'; // WeeklyPlanScreen
```

### 10.2 新增 case 分支

```dart
case today:
  return MaterialPageRoute(builder: (_) => const TodayScreen());

case journey:
  return MaterialPageRoute(builder: (_) => const JourneyScreen());

case weeklyPlan:
  return MaterialPageRoute(builder: (_) => const WeeklyPlanScreen());
```

### 10.3 保留的路由

以下路由不变，继续使用：

```
/daily-light      → DailyLightScreen
/weekly-review    → WeeklyReviewScreen
/worry-processor  → WorryProcessorScreen
/worry-edit       → WorryEditScreen
/cat-detail       → CatDetailScreen
/adoption         → AdoptionFlowScreen
/settings         → SettingsScreen
```

### 10.4 新增 import

```dart
import 'package:hachimi_app/screens/today/today_screen.dart';
import 'package:hachimi_app/screens/journey/journey_screen.dart';
import 'package:hachimi_app/screens/onboarding/lumi_onboarding_screen.dart';
```

---

## 11. L10n Key 清单

### 11.1 导航

| Key | EN | ZH-CN |
|-----|-----|-------|
| `homeTabToday` | Today | 今天 |
| `homeTabJourney` | Journey | 旅程 |
| `homeTabProfile` | Profile | 我的 |

### 11.2 TodayScreen

| Key | EN | ZH-CN |
|-----|-----|-------|
| `todayTitle` | Today | ✦ 今天 |
| `todayQuickLightPrompt` | What made you smile today? | 今天有什么让你微笑的事？ |
| `todayQuickLightHint` | Write a line... | 写一句话... |
| `todayQuickLightRecord` | Record ✦ | 记录 ✦ |
| `todayQuickLightEdit` | Edit | 编辑 |
| `todayHabitSection` | Today's habits | 今日习惯 |
| `todayFirstLightGuide` | Write your first light ✦ | 写下今天的第一束光 ✦ |

### 11.3 JourneyScreen

| Key | EN | ZH-CN |
|-----|-----|-------|
| `journeyTitle` | Journey | 旅程 |
| `journeySegmentWeek` | This Week | 本周 |
| `journeySegmentMonth` | This Month | 本月 |
| `journeySegmentYear` | Year | 年度 |
| `journeySegmentExplore` | Explore | 探索 |
| `journeyComingSoon` | Coming soon | 即将推出 |
| `journeyLockedWeek` | Record 1 day to unlock weekly view. No rush ✦ | 记录 1 天后解锁本周视图。不急，慢慢来 ✦ |
| `journeyLockedMonth` | Record {days} more days to start monthly planning. No rush ✦ | 再记录 {days} 天，就可以开始月度规划了。不急，慢慢来 ✦ |
| `journeyLockedYear` | Record {days} more days to start yearly planning. No rush ✦ | 再记录 {days} 天，就可以开始年度规划了。不急，慢慢来 ✦ |
| `journeyLockedExplore` | Record {days} more days to unlock exploration. No rush ✦ | 再记录 {days} 天，就可以开启探索之旅了。不急，慢慢来 ✦ |

### 11.4 周视图

| Key | EN | ZH-CN |
|-----|-----|-------|
| `weekPlanSection` | Weekly Plan | 本周计划 |
| `weekPlanEmpty` | Say something to this week? | 给这周的自己说句话？ |
| `weekPlanStart` | Start planning | 开始规划 |
| `weekReviewSection` | Weekly Review | 周回顾 |
| `weekReviewEmpty` | Recall this week's happy moments | 回忆本周的幸福时刻 |
| `weekReviewStart` | Start review | 开始回顾 |
| `weekWorrySection` | Worry Processor | 烦恼处理器 |
| `weekWorryEmpty` | No worries right now. Great! | 没有烦恼，真好！ |
| `weekWorryAdd` | + Write down a worry | + 写下烦恼 |
| `weekWorryViewAll` | View all | 查看全部 |

### 11.5 Onboarding

| Key | EN | ZH-CN |
|-----|-----|-------|
| `onboardingWelcomeTitle` | Hello | 你好 |
| `onboardingWelcomeSubtitle` | This is LUMI | 这里是 LUMI |
| `onboardingWelcomeSlogan` | Every line you write adds a star to your innerverse | 每写一行，都是在为你的内心宇宙添一颗星 |
| `onboardingContinue` | Continue | 继续 |
| `onboardingNameTitle` | The owner of this journal is | 这本手册的主人是 |
| `onboardingNameHint` | Write your name | 写下你的名字 |
| `onboardingBirthdayTitle` | Your birthday | 你的生日 |
| `onboardingNext` | Next | 下一步 |
| `onboardingDateTitle` | When do you want to start this journey? | 你想从哪天开始这段旅程？ |
| `onboardingDateHint` | You can change it anytime | 你可以随时修改 |
| `onboardingGuideTitle` | LUMI is just three little things | LUMI 只有三件小事 |
| `onboardingGuide1` | Write a line before bed — today's light | 睡前写一句 — 今天的一点光 |
| `onboardingGuide2` | Weekend review — three happy moments | 周末回顾 — 三个幸福时刻 |
| `onboardingGuide3` | Write down worries — put them in the jar | 写下烦恼 — 放进烦恼罐 |
| `onboardingReady` | Ready? | 准备好了吗？ |
| `onboardingStart` | Start the journey | 开始旅程 |

### 11.6 ProfileScreen 新增

| Key | EN | ZH-CN |
|-----|-----|-------|
| `profileLumiStars` | Stars | 星星 |
| `profileRecordDays` | Days recorded | 记录天数 |
| `profileCurrentStreak` | Current streak | 当前连续 |
| `profileLongestStreak` | Longest streak | 最长连续 |
| `profileCatCompanion` | Cat companion | 猫咪伙伴 |
| `profileCatCompanionSubtitle` | {count} cats | {count} 只猫咪 |
| `profileAdoptCat` | Adopt a cat companion? | 领养一只猫咪伙伴？ |
| `profileAboutLumi` | About LUMI | 关于 LUMI |

**合计**：约 50 个新/修改 L10n key。

---

## 12. 文件操作清单

### 12.1 新建文件

| 文件路径 | 说明 |
|---------|------|
| `lib/screens/today/today_screen.dart` | Tab 0：TodayScreen |
| `lib/screens/journey/journey_screen.dart` | Tab 1：JourneyScreen |
| `lib/screens/onboarding/lumi_onboarding_screen.dart` | 新 LUMI Onboarding |
| `lib/widgets/today/quick_light_card.dart` | 内联一点光卡片 |
| `lib/widgets/today/habit_snapshot.dart` | 今日习惯快照 |
| `lib/widgets/today/inspiration_card.dart` | 灵感提示卡 |
| `lib/widgets/journey/weekly_plan_card.dart` | 周计划摘要卡 |
| `lib/widgets/journey/weekly_review_card.dart` | 周回顾摘要卡 |
| `lib/widgets/journey/worry_jar_card.dart` | 烦恼处理器摘要卡 |
| `lib/widgets/journey/week_mood_dots.dart` | 7 天心情圆点 |
| `lib/widgets/journey/locked_segment_placeholder.dart` | 未解锁温暖占位 |
| `lib/widgets/profile/lumi_stats_card.dart` | LUMI 统计卡 |
| `lib/widgets/profile/cat_companion_card.dart` | 猫咪伴侣入口卡 |
| `lib/providers/feature_gate_provider.dart` | 渐进解锁 Provider |
| `lib/core/constants/inspiration_constants.dart` | 灵感清单常量 |

### 12.2 修改文件

| 文件路径 | 改动内容 |
|---------|---------|
| `lib/screens/home/home_screen.dart` | 4 Tab → 3 Tab，替换 `_screens` 列表、NavigationBar destinations、FAB 逻辑 |
| `lib/screens/profile/profile_screen.dart` | 重组：LUMI 统计 + CatCompanionCard + 设置 |
| `lib/core/router/app_router.dart` | 新增 3 个路由常量 + case 分支 + import |
| `lib/l10n/app_en.arb` | 新增约 50 个英文 L10n key |
| `lib/l10n/app_zh.arb` | 新增约 50 个中文 L10n key |
| `lib/l10n/` 其他 ARB | 同步新增 key |
| `app.dart` 或相关入口文件 | 移除 `_FirstHabitGate`，Onboarding 入口替换 |

### 12.3 标记 deprecated（不立即删除）

| 文件路径 | 原因 |
|---------|------|
| `lib/screens/home/components/today_tab.dart` | 被 TodayScreen 替代 |
| `lib/screens/awareness/awareness_screen.dart` | 3 子 Tab 结构被 JourneyScreen 替代 |
| `lib/screens/onboarding/onboarding_screen.dart` | 被 LumiOnboardingScreen 替代 |
| `lib/screens/onboarding/components/*.dart` | 旧 Onboarding 组件 |

### 12.4 SSOT 文档更新（编码前必须先完成）

| 文件路径 | 改动内容 |
|---------|---------|
| `docs/architecture/folder-structure.md` | 新增 `screens/today/`、`screens/journey/`、`widgets/today/`、`widgets/journey/`、`widgets/profile/` |
| `docs/zh-CN/architecture/folder-structure.md` | 同步中文版 |

---

## 13. 完成标志

### 13.1 导航重组

- [ ] HomeScreen 变为 3 Tab（今天 / 旅程 / 我的）
- [ ] 旧 4 Tab（觉知 / 习惯 / 猫咪 / 我的）不再出现
- [ ] `_FirstHabitGate` 完全移除，新用户不经过猫咪领养
- [ ] NavigationBar 图标和文案与设计一致

### 13.2 Onboarding

- [ ] 4 页 LUMI Onboarding 流程可完整走通（欢迎 → 名字 → 日期 → 导览 → HomeScreen）
- [ ] 名字必填校验生效
- [ ] Onboarding 数据正确写入 `materialized_state`
- [ ] 旧猫咪 Onboarding 不再触发

### 13.3 TodayScreen

- [ ] QuickLightCard 未记录状态：选心情 → 写一句话 → 保存 → 切换为已记录状态
- [ ] QuickLightCard 已记录状态：显示心情 + 预览 + 编辑按钮
- [ ] HabitSnapshot：有习惯时显示列表，无习惯时不显示
- [ ] InspirationCard：显示灵感文案，每天轮换

### 13.4 JourneyScreen

- [ ] SegmentedButton 4 段（本周/本月/年度/探索）切换正常
- [ ] 本周视图：WeeklyPlanCard + WeekMoodDots + WeeklyReviewCard + WorryJarCard
- [ ] WeeklyPlanCard 点击进入 WeeklyPlanScreen
- [ ] WeeklyReviewCard 点击进入 WeeklyReviewScreen
- [ ] WorryJarCard 显示活跃烦恼，"查看全部"进入 WorryProcessorScreen
- [ ] 未解锁 Segment 显示温暖占位卡片

### 13.5 ProfileScreen

- [ ] LumiStatsCard 显示星星/记录天数/连续天数
- [ ] CatCompanionCard 有猫显示猫咪+数量，无猫显示领养入口
- [ ] 设置区域正常可用

### 13.6 渐进解锁

- [ ] Day 0（新用户）：仅 TodayScreen 可用，JourneyScreen 全部 Segment 锁定
- [ ] Day 1：本周 Segment 解锁
- [ ] Day 3：本月 Segment 解锁
- [ ] Day 14：年度 Segment 解锁
- [ ] Day 30：探索 Segment 解锁

### 13.7 主题验证

- [ ] Material 3 主题下所有新屏幕正确渲染
- [ ] Retro Pixel 主题下所有新屏幕正确渲染
- [ ] 两种主题切换后无崩溃

### 13.8 代码质量

- [ ] `dart analyze lib/` 零 warning / error
- [ ] `dart format lib/ test/ --set-exit-if-changed` 零格式问题
- [ ] 所有新文件不超过 800 行
- [ ] 所有新函数不超过 30 行
- [ ] 无硬编码颜色值
- [ ] 所有 Widget 使用 `const` 构造函数

### 13.9 L10n 验证

- [ ] 约 50 个新 key 在 EN 和 ZH-CN 下均有值
- [ ] `flutter gen-l10n` 无报错
- [ ] 其他 13 个语言 ARB 文件同步
