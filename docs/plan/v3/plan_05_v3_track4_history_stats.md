---
level: 2
file_id: plan_05
parent: plan_01
status: pending
created: 2026-03-19
children: []
estimated_time: 600分钟
prerequisites: [plan_03]
---

# 模块：轨道四 — 月度与年度规划 + 灵感系统

## 1. 模块概述

### 模块目标

本模块实现 LUMI 旅程 Tab 中的 **月度视图** 和 **年度视图**，补全完整的时间维度层级（日 → 周 → 月 → 年）。同时交付灵感系统，为空状态页面提供温暖的预填充内容。

核心价值：
- **月度规划**：心情热力图 + 月目标 + 小赢挑战 + 习惯追踪 + 心情追踪 + 月记忆
- **年度规划**：年度寄语 + 成长计划 + 年历 + 清单 + 小赢 100 天 + 幸福/高光时刻 + 旅行活动
- **灵感系统**：`lumi_constants.dart` 静态常量 + `InspirationProvider` 每日轮换

### 在项目中的位置

```
V3 LUMI 点亮内心宇宙
├── 轨道一：数据基础（plan_02）        ✅ 前置
├── 轨道二：核心 UI（plan_03）          ✅ 前置
├── 轨道三：集成 + 导航（plan_04）      ✅ 前置
├── ★ 轨道四：月度/年度 + 灵感（本文件）
└── 轨道五：丰富度 + 活动（plan_06）
```

### 版本归属

- **目标版本**：Phase 2
- **周定义**：ISO 8601（周一为一周第一天，周日为最后一天）
- **主题支持**：Material 3 + Retro Pixel 双主题

---

## 2. 月度视图（JourneyScreen · 本月 Segment）

### 2.1 整体布局

```
JourneyScreen [本月] Segment
└── CustomScrollView
    ├── MonthlyCalendar（心情热力图，复用 MoodCalendar）
    ├── MonthlyGoals（5 个月目标 + 完成进度）
    ├── SmallWinChallenge（31 天打卡网格 + 四法则 + 奖励）
    ├── HabitTrackers（4 个小习惯 x 31 天网格）
    ├── MoodTracker（5 周 x 7 天心情矩阵 + 心情分布统计）
    └── MonthlyMemory（本月记忆 + 本月成就）
```

### 2.2 MonthlyCalendar

复用轨道二的 `MoodCalendar` 组件：
- 7 列（周一到周日）x 最多 6 行
- 有记录的日期显示对应 Mood 的 emoji
- 无记录的日期显示空心圆圈
- 当天有环形高亮
- 点击日期跳转到 DailyDetailScreen 或 DailyLightScreen

### 2.3 MonthlyGoals

```
┌──────────────────────────────────────┐
│  本月目标                            │
│                                      │
│  ☐ 1. ________________________      │
│  ☐ 2. ________________________      │
│  ☐ 3. ________________________      │
│  ☐ 4. ________________________      │
│  ☐ 5. ________________________      │
│                                      │
│  完成 2/5                            │
└──────────────────────────────────────┘
```

- 5 个目标条目，每条 `TextField` + `Checkbox`
- 数据存储在 `MonthlyPlan.goals` 字段（JSON 数组）
- 可随时编辑、随时保存

### 2.4 SmallWinChallenge

```
┌──────────────────────────────────────┐
│  小赢挑战                            │
│  习惯：阅读 30 分钟                   │
│  四法则：看得见 / 想去做 / 易上手 / 有奖励 │
│                                      │
│  一 二 三 四 五 六 日                  │
│  ● ● ● ○ ● ○ ○                      │
│  ● ○ ● ● ○ ○ ○                      │
│  ...                                 │
│                                      │
│  已完成 8/31 天                       │
│  奖励：买一本新书                     │
│  每一天都算数 ✦                       │
└──────────────────────────────────────┘
```

- 31 天打卡网格（`GridTracker(days: 31)`）
- 关联四法则设计（看得见 / 想去做 / 易上手 / 有奖励）
- 月末显示完成统计 + 奖励是否达成

### 2.5 HabitTrackers

```
┌──────────────────────────────────────┐
│  本月热爱与坚持                       │
│                                      │
│  早起  [31天网格]  完成 20/31         │
│  阅读  [31天网格]  完成 15/31         │
│  运动  [31天网格]  完成 22/31         │
│  冥想  [31天网格]  完成 8/31          │
│                                      │
│  + 添加习惯（最多 4 个）              │
└──────────────────────────────────────┘
```

- 最多 4 个小习惯
- 每个习惯 31 天打卡网格
- 复用现有 `Habit` 模型，被月度规划引用

### 2.6 MoodTracker

```
┌──────────────────────────────────────┐
│  心情追踪                            │
│                                      │
│      一  二  三  四  五  六  日        │
│  W1  😄 🙂 😌 😄 🙂 😌 😔            │
│  W2  🙂 😄 😌 🙂 😄 😌 😌            │
│  W3  ...                             │
│  W4  ...                             │
│  W5  ...                             │
│                                      │
│  心情分布                            │
│  😄 ████████████  45%                │
│  🙂 ████████     30%                │
│  😌 ████         15%                │
│  😔 ██            8%                │
│  😢 █             2%                │
└──────────────────────────────────────┘
```

- 5 周 x 7 天心情矩阵
- 数据来源：`monthlyLightsProvider`
- 底部显示心情分布柱状图

### 2.7 MonthlyMemory

```
┌──────────────────────────────────────┐
│  本月记忆                            │
│  ┌─────────────────────────────┐    │
│  │ 这个月最难忘的事...          │    │
│  └─────────────────────────────┘    │
│                                      │
│  本月成就                            │
│  ┌─────────────────────────────┐    │
│  │ 这个月我最骄傲的...          │    │
│  └─────────────────────────────┘    │
└──────────────────────────────────────┘
```

- 两个自由文本输入区
- 数据存储在 `MonthlyPlan.memory` 和 `MonthlyPlan.achievement` 字段

---

## 3. 年度视图（JourneyScreen · 年度 Segment）

### 3.1 整体布局

```
JourneyScreen [年度] Segment
└── CustomScrollView
    ├── YearlyMessages（7 个提问）
    ├── GrowthPlan（8 维度成长计划）
    ├── AnnualCalendar（12 月 x 31 天点阵概览）
    ├── Lists（书单/影单/自定义清单 + 年度精选）
    ├── SmallWin100（100 天挑战 + 25 天里程碑）
    ├── HighlightMoments（幸福时刻 + 高光时刻）
    └── TravelActivities（旅行与活动）
```

### 3.2 YearlyMessages（年度寄语）

7 个提问卡片，每个卡片一个 `TextField`：

| 序号 | 提问 | Hint |
|------|------|------|
| 1 | 我希望成为…… | 描述你理想中的自己 |
| 2 | 我想要达成…… | 今年最想达成的目标 |
| 3 | 我要突破性地完成…… | 跳出舒适区的事 |
| 4 | 我不再做…… | 放下的习惯或想法 |
| 5 | 我的年度关键词 | 用一个词概括今年 |
| 6 | 给亲爱的未来的我 | 写给年末的自己 |
| 7 | 我的座右铭 | 今年的座右铭 |

### 3.3 GrowthPlan（8 维度成长计划）

8 个维度卡片，每个卡片含：
- 维度名称 + 图标
- 灵感提示（来自 `lumi_constants.dart`）
- 3 个具体目标输入框
- 进度标记（完成/进行中/未开始）

| 维度 | 图标 |
|------|------|
| 认真学习 | 📚 |
| 身心健康 | 😊 |
| 勇敢自信 | 💪 |
| 养成习惯 | ⏰ |
| 接纳自己 | 🫂 |
| 创意创作 | 💡 |
| 关系连接 | 💕 |
| 善意行动 | ❤️ |

### 3.4 AnnualCalendar（年历）

- 12 列（月）x 31 行（日）的紧凑点阵视图
- 有记录的日期显示心情颜色点
- 无记录的日期显示浅灰色点
- 点击某月可跳转到月度视图

### 3.5 Lists（清单系统）

见 plan_06 详细定义。年度视图中展示入口卡片：
- 书单（10 条）
- 影单（10 条）
- 自定义清单（10 条）
- 每个清单含年度精选（宝藏推荐 + 灵感一击 + 精华墙）

### 3.6 SmallWin100（100 天挑战）

- 100 天打卡网格（10 x 10）
- 25 天里程碑：25 / 50 / 75 / 100 天各有奖励
- 关联一个年度习惯挑战
- 中断不惩罚：「打了一半也是进步 ✦」

### 3.7 HighlightMoments（幸福时刻 + 高光时刻）

两个子 Tab：

**幸福时刻（10 条）**：
- 幸福的事
- 和谁一起
- 感受
- 日期
- 幸福仪表盘（5 级评分）

**高光时刻（10 条）**：
- 发生了什么
- 我做了什么
- 感受
- 日期
- 勋章图标

### 3.8 TravelActivities（旅行与活动）

- 12 个预设 + 4 个自定义条目
- 每条：时间 / 地点 / 感受 / 五星评分
- 带背景图标装饰

---

## 4. 灵感系统

### 4.1 灵感常量文件

**文件**：`lib/core/constants/lumi_constants.dart`

#### 习惯养成范例（9 个，含四法则设计）

每个范例包含：看得见 / 想去做 / 易上手 / 有奖励 + 行动宣言

```dart
class LumiConstants {
  LumiConstants._();

  /// 习惯养成范例（9 个，含四法则设计）
  static const List<HabitTemplate> habitTemplates = [
    HabitTemplate(
      name: '提前 30 分钟睡觉',
      cueVisible: '手机闹钟提醒',
      craving: '听轻音乐入睡',
      easyStart: '先尝试提前 15 分钟',
      reward: '第二天醒来状态更好',
    ),
    // ... 共 9 个
  ];

  /// 爱自己活动建议（~50 条）
  static const List<String> selfCareActivities = [
    '尝试做新的菜肴',
    '买喜欢的文具',
    '写下自己的优点',
    // ... 共约 50 条
  ];

  /// 8 维度成长计划灵感
  static const Map<GrowthDimension, List<String>> growthInspirations = {
    GrowthDimension.learning: [
      '记笔记更有条理',
      '每天背诵 10 分钟',
      // ...
    ],
    // ... 共 8 维度
  };
}
```

### 4.2 InspirationProvider

```dart
/// 文件：lib/providers/inspiration_provider.dart
///
/// 每日灵感轮换：根据当天日期选择灵感内容，
/// 确保每天看到不同的提示。
final dailyInspirationProvider = Provider<String>((ref) {
  final today = DateTime.now();
  final dayOfYear = today.difference(
    DateTime(today.year, 1, 1),
  ).inDays;
  final activities = LumiConstants.selfCareActivities;
  return activities[dayOfYear % activities.length];
});

/// 习惯灵感 Provider（随机选取一个模板）
final habitInspirationProvider = Provider<HabitTemplate>((ref) {
  final today = DateTime.now();
  final index = today.day % LumiConstants.habitTemplates.length;
  return LumiConstants.habitTemplates[index];
});
```

### 4.3 灵感使用位置

| 位置 | 灵感类型 | 说明 |
|------|---------|------|
| TodayScreen `InspirationCard` | 爱自己活动 | 每日轮换一条活动建议 |
| 小赢挑战设定页 | 习惯模板 | 展示 9 个范例供参考 |
| 月度「爱自己活动」清单 | 爱自己活动 | 空页面自动显示灵感提示 |
| 年度成长计划 | 8 维度灵感 | 每个维度展示灵感列表 |
| 空状态页面 | 各类灵感 | 任何空页面都有预填充提示 |

---

## 5. 新增 Provider

### 5.1 journey_providers.dart

```dart
/// 年度计划 Provider
final yearlyPlanProvider = FutureProvider.family<YearlyPlan?, int>(
  (ref, year) async {
    final repo = ref.watch(journeyRepositoryProvider);
    final uid = ref.watch(currentUidProvider);
    return repo.getYearlyPlan(uid, year);
  },
);

/// 月度计划 Provider
final monthlyPlanProvider = FutureProvider.family<MonthlyPlan?, String>(
  (ref, monthKey) async {
    // monthKey 格式：'yyyy-MM'
    final repo = ref.watch(journeyRepositoryProvider);
    final uid = ref.watch(currentUidProvider);
    return repo.getMonthlyPlan(uid, monthKey);
  },
);

/// 周计划 Provider
final weeklyPlanProvider = FutureProvider.family<WeeklyPlan?, String>(
  (ref, weekId) async {
    final repo = ref.watch(journeyRepositoryProvider);
    final uid = ref.watch(currentUidProvider);
    return repo.getWeeklyPlan(uid, weekId);
  },
);
```

### 5.2 feature_gate_provider.dart

见 plan_04 第 5 节定义。

### 5.3 inspiration_provider.dart

见第 4.2 节定义。

---

## 6. 文件操作清单

### 需要创建的文件

| 文件路径 | 类型 | 说明 |
|---------|------|------|
| `lib/core/constants/lumi_constants.dart` | Constants | 灵感清单常量（习惯模板 + 爱自己活动 + 成长灵感）|
| `lib/providers/journey_providers.dart` | Provider | yearlyPlan / monthlyPlan / weeklyPlan providers |
| `lib/providers/inspiration_provider.dart` | Provider | 每日灵感轮换 |
| `lib/screens/journey/monthly_view.dart` | Screen | 月度视图（6 个子组件）|
| `lib/screens/journey/yearly_view.dart` | Screen | 年度视图（7 个子组件）|
| `lib/widgets/lumi/grid_tracker.dart` | Widget | 通用网格打卡组件（31 天 / 100 天）|
| `lib/widgets/lumi/mood_tracker_matrix.dart` | Widget | 5 周 x 7 天心情矩阵 |
| `lib/widgets/lumi/monthly_goals_card.dart` | Widget | 月目标卡片 |
| `lib/widgets/lumi/small_win_challenge.dart` | Widget | 小赢挑战卡片 |
| `lib/widgets/lumi/yearly_messages_page.dart` | Widget | 年度寄语 7 问 |
| `lib/widgets/lumi/growth_plan_card.dart` | Widget | 成长计划 8 维度 |
| `lib/widgets/lumi/annual_calendar_grid.dart` | Widget | 年历点阵 |
| `lib/widgets/lumi/inspiration_card.dart` | Widget | 灵感卡片 |

### 需要修改的文件

| 文件路径 | 改动说明 |
|---------|---------|
| `lib/screens/journey/journey_screen.dart` | 添加「本月」和「年度」Segment 内容 |
| `lib/providers/awareness_providers.dart` | 新增 monthlyLightsProvider 等 |
| `lib/core/router/app_router.dart` | 新增月度/年度相关路由 |
| `lib/l10n/app_en.arb` | 新增约 40 个 l10n key |
| `lib/l10n/app_zh.arb` | 新增约 40 个 l10n key（中文）|

---

## 7. 完成标志

### 功能验收

- [ ] 月度视图：MoodCalendar 正确显示心情热力图
- [ ] 月度视图：5 个月目标可编辑、可勾选完成
- [ ] 月度视图：小赢挑战 31 天网格正确打卡
- [ ] 月度视图：4 个小习惯追踪网格正常工作
- [ ] 月度视图：心情矩阵正确渲染 5 周 x 7 天
- [ ] 月度视图：月记忆和月成就文本可保存
- [ ] 年度视图：7 个年度寄语提问可编辑保存
- [ ] 年度视图：8 维度成长计划含灵感提示
- [ ] 年度视图：年历点阵正确渲染 12 x 31
- [ ] 灵感系统：TodayScreen 显示每日轮换灵感
- [ ] 灵感系统：空状态页面显示预填充提示
- [ ] 渐进解锁：月度视图在 Day 3 后可见，年度视图在 Day 14 后可见

### 代码质量

- [ ] `dart analyze lib/` 零 warning / error
- [ ] 所有新文件行数 ≤ 800 行
- [ ] 所有新函数行数 ≤ 30 行
- [ ] 无硬编码颜色值

---

## 依赖关系

### 前置条件

- **轨道一（plan_02）**：`MonthlyPlan`、`YearlyPlan` 数据模型和 SQLite 表就绪
- **轨道二（plan_03）**：JourneyScreen 骨架 + SegmentedButton 切换就绪
- **轨道三（plan_04）**：渐进解锁 FeatureGateProvider 就绪

### 后续影响

- 轨道五（plan_06）的清单系统、高光时刻、100 天挑战在年度视图中展示入口

---

## 风险与挑战

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 月度/年度视图组件数量多 | 开发量大 | 使用通用 `GridTracker` 组件复用 |
| 灵感常量文件较大 | 接近 800 行红线 | 按类型拆分为子文件 |
| 年历 12x31 点阵渲染性能 | 可能卡顿 | `CustomPaint` + 缓存渲染 |
| 数据存储方案（JSON 数组在 SQLite 中）| 查询不便 | 简单场景用 JSON，复杂查询用独立表 |
