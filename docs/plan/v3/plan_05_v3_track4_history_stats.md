---
level: 2
file_id: plan_05
parent: plan_01
status: pending
created: 2026-03-17 23:30
children: []
estimated_time: 480分钟
prerequisites: [plan_03]
---

# 模块：历史视图 + 觉知统计（轨道四）

## 1. 模块概述

### 模块目标

本模块实现觉知系统的**回顾与统计**能力，补全 AwarenessScreen 「回顾」子 Tab 的占位内容，并在 ProfileScreen 中嵌入觉知统计卡片。核心价值：

- **回顾**：用户可按月浏览历史心情记录，快速定位某一天的详情
- **统计**：将散落的觉知数据聚合为直观的分布图和关键指标，增强「资产价值」感知
- **可选增强**：TimelineEditor 为每日一点光提供时间轴补充录入能力

### 在项目中的位置

```
V3 觉知伴侣
├── 轨道一：数据基础（plan_02）        ✅ 前置
├── 轨道二：觉知核心 UI（plan_03）      ✅ 前置
├── 轨道三：飞轮桥接 + 导航（plan_04）  ✅ 前置
├── ★ 轨道四：历史视图 + 觉知统计（本文件）
└── 轨道五：模板库 + 模式发现（plan_06）
```

### 版本归属

- **目标版本**：v2.36.0
- **周定义**：ISO 8601（周一为一周第一天，周日为最后一天）
- **主题支持**：Material 3 + Retro Pixel 双主题

---

## 2. MoodCalendar Widget

### 文件路径

`lib/widgets/awareness/mood_calendar.dart`

### 接口定义

```dart
class MoodCalendar extends ConsumerWidget {
  /// 当前显示的年份
  final int year;

  /// 当前显示的月份（1-12）
  final int month;

  /// 用户点击某一天时触发，传入被点击日期
  final ValueChanged<DateTime> onDayTapped;

  /// 用户切换月份时触发，传入 (year, month) 元组
  final ValueChanged<(int, int)> onMonthChanged;

  const MoodCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.onDayTapped,
    required this.onMonthChanged,
  });
}
```

### 视觉规格

#### 月份导航栏

- 居中显示月份标题，格式：`2026年3月`（中文）/ `March 2026`（英文），使用 l10n
- 左侧：`Icons.chevron_left` 按钮，点击 → `onMonthChanged((year, month - 1))`，需处理跨年
- 右侧：`Icons.chevron_right` 按钮，点击 → `onMonthChanged((year, month + 1))`
- 不允许导航到未来月份（右侧按钮在当前月份时 disabled）

#### 星期表头

- 7 列，周一到周日，使用 l10n key（`calendarMon` ~ `calendarSun`）
- Material 3 主题：`colorScheme.onSurfaceVariant`，`labelSmall` 字体
- Retro Pixel 主题：像素风小号文字

#### 日期网格

- 标准 7 列网格，每月最多 6 行
- **有记录的日期**：显示对应 Mood 的 emoji（😄🙂😌😔😢）
  - emoji 尺寸：20dp，居中于日期格
  - 日期数字显示在 emoji 下方，`labelSmall` 字体
- **无记录的日期**：空心圆圈
  - Material 3：`colorScheme.surfaceContainerHigh` 填充的圆圈，直径 32dp
  - Retro Pixel：像素风虚线边框圆圈（使用 `PixelBorderShape`）
- **当天**：额外添加一圈环形高亮
  - Material 3：`colorScheme.primary` 描边，宽度 2dp
  - Retro Pixel：像素风实线高亮边框
- **非当月日期**（前月尾部 / 后月头部）：不显示，留空白

#### 容器

- Material 3：标准 `Card`，无额外装饰
- Retro Pixel：使用 `PixelBorderShape` 装饰容器外框

### 数据流

```
MoodCalendar
  │
  └─ ref.watch(monthlyLightsProvider((year, month)))
       │
       └─ 返回 AsyncValue<Map<int, Mood>>
            │
            ├─ key: 日期（1-31）
            └─ value: Mood 枚举值
```

#### monthlyLightsProvider 定义

```dart
/// 按月查询 DailyLight 记录，返回 {day: mood} 的 Map，用于 O(1) 查找
final monthlyLightsProvider = FutureProvider.family<Map<int, Mood>, (int, int)>(
  (ref, params) async {
    final (year, month) = params;
    final repository = ref.watch(awarenessRepositoryProvider);
    final uid = ref.watch(currentUidProvider);

    // 计算月份起止日期
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // 该月最后一天

    // 查询该月所有 DailyLight 记录
    final lights = await repository.getLightsByDateRange(
      uid,
      startDate.toIso8601String().substring(0, 10),
      endDate.toIso8601String().substring(0, 10),
    );

    // 构建 {day: mood} 查找表
    return {
      for (final light in lights) light.date.day: light.mood,
    };
  },
);
```

### 交互行为

| 操作 | 响应 |
|------|------|
| 点击有记录的日期 | 调用 `onDayTapped(date)` → 父级导航到 DailyDetailScreen |
| 点击无记录的日期 | 调用 `onDayTapped(date)` → 父级可选择导航到 DailyLightScreen（预填日期） |
| 点击左箭头 | 切换到上一个月，调用 `onMonthChanged` |
| 点击右箭头 | 切换到下一个月（不超过当前月） |
| 滑动手势 | 暂不支持（MVP 仅按钮翻月，避免与 CustomScrollView 滚动冲突） |

---

## 3. AwarenessHistoryScreen

### 文件路径

`lib/screens/awareness/awareness_history_screen.dart`

### 路由

- 路由路径：`/awareness-history`
- 同时作为 AwarenessScreen 「回顾」子 Tab（Tab 2）的渲染内容
- 轨道二中 AwarenessScreen 已为「回顾」Tab 预留了占位，本轨道替换为真实实现

### Widget 类型

`ConsumerStatefulWidget`（需要管理当前显示的年月状态）

### 状态定义

```dart
class _AwarenessHistoryScreenState extends ConsumerState<AwarenessHistoryScreen> {
  late int _displayYear;
  late int _displayMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayYear = now.year;
    _displayMonth = now.month;
  }
}
```

### 布局结构

使用 `CustomScrollView` 实现整体可滚动布局：

```
CustomScrollView
├── SliverToBoxAdapter
│   └── MoodCalendar(
│         year: _displayYear,
│         month: _displayMonth,
│         onDayTapped: _handleDayTap,
│         onMonthChanged: _handleMonthChange,
│       )
│
├── SliverToBoxAdapter
│   └── Padding(16dp top)
│       └── Text("周回顾", style: titleMedium)  // l10n: historyWeeklyReviews
│
├── 条件渲染：weeklyReviewsForMonthProvider 结果
│   │
│   ├── 有数据 → SliverList
│   │   └── 每一项: _WeeklyReviewFoldCard
│   │
│   └── 无数据 → SliverFillRemaining
│       └── AwarenessEmptyState(type: EmptyStateType.history)
│
└── SliverPadding(bottom: 80dp)  // 底部安全距离
```

### 周回顾折叠卡片（_WeeklyReviewFoldCard）

每张卡片代表一个 ISO 周的回顾记录，使用 `ExpansionTile` 或自定义折叠实现。

#### 折叠状态（默认）

```
┌──────────────────────────────────────┐
│  📅 3月10日 - 3月16日    ✨ 3个幸福时刻  │
└──────────────────────────────────────┘
```

- 左侧：周范围标签，格式 `M月D日 - M月D日`（使用 l10n 格式化）
- 右侧：幸福时刻计数徽章（`Badge` 或 `Chip`），显示非空幸福时刻数量（0-3）
- Material 3：标准 `Card` + `ExpansionTile`
- Retro Pixel：像素边框卡片 + 自定义展开指示器（像素箭头）

#### 展开状态

```
┌──────────────────────────────────────┐
│  📅 3月10日 - 3月16日    ✨ 3个幸福时刻  │
├──────────────────────────────────────┤
│  幸福时刻                            │
│  1. 和家人一起吃了火锅 #家人          │
│  2. 学会了新的 Flutter 技巧 #学习     │
│  3. 在公园散步看到了樱花 #户外        │
│                                      │
│  感恩                                │
│  感谢同事帮忙解决了一个难题            │
│                                      │
│  学到了什么                           │
│  耐心比速度更重要                     │
│                                      │
│  🐱 猫咪周总结                       │
│  "铲屎官这周又和家人吃了火锅，        │
│   本猫也想吃！下周继续加油喵~"        │
└──────────────────────────────────────┘
```

- 幸福时刻：带序号列表，每条后显示标签（如有）
- 感恩 / 学到了什么：单行文本显示
- 猫咪周总结：引用样式（`blockquote` 视觉），猫咪 emoji 前缀
- 任何字段为空时不显示该区块

### weeklyReviewsForMonthProvider 定义

```dart
/// 查询某月内所有 ISO 周的 WeeklyReview 记录
final weeklyReviewsForMonthProvider = FutureProvider.family<List<WeeklyReview>, (int, int)>(
  (ref, params) async {
    final (year, month) = params;
    final repository = ref.watch(awarenessRepositoryProvider);
    final uid = ref.watch(currentUidProvider);

    // 计算该月覆盖的所有 ISO 周
    // 月初所在的 ISO 周 ~ 月末所在的 ISO 周
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    final startWeekId = _isoWeekId(firstDay);  // 例如 '2026-W11'
    final endWeekId = _isoWeekId(lastDay);      // 例如 '2026-W14'

    // 查询范围内的所有 WeeklyReview
    return repository.getReviewsByWeekRange(uid, startWeekId, endWeekId);
  },
);
```

#### ISO 周 ID 计算辅助函数

```dart
/// ISO 8601 周 ID 计算。
/// 注意：建议使用项目已有的 AppDateUtils.isoWeekId()
/// （定义于 plan_02 第 12 节），确保全项目周 ID 计算一致。
String _isoWeekId(DateTime date) {
  // 使用 plan_02 中定义的 AppDateUtils
  return AppDateUtils.isoWeekId(date);
}
```

### 交互行为

| 操作 | 响应 |
|------|------|
| 点击日历中有记录的日期 | 导航到 `/daily-detail?date=YYYY-MM-DD` |
| 点击日历中无记录的日期 | 导航到 DailyLightScreen（预填 date 参数，允许补录） |
| 翻月 | 更新 `_displayYear` / `_displayMonth`，日历和周回顾列表同步刷新 |
| 点击周回顾卡片 | 展开/折叠该卡片 |
| 月份无任何数据 | 日历显示全空心圆，下方显示空状态组件 |

---

## 4. DailyDetailScreen

### 文件路径

`lib/screens/awareness/daily_detail_screen.dart`

### 路由

- 路由路径：`/daily-detail`
- 参数：`String date`（格式 `YYYY-MM-DD`）
- 路由注册示例：

```dart
GoRoute(
  path: '/daily-detail',
  builder: (context, state) {
    final date = state.uri.queryParameters['date']!;
    return DailyDetailScreen(date: date);
  },
),
```

### Widget 类型

`ConsumerWidget`（只读视图，无状态管理需求）

### 布局结构

```
Scaffold
└── AppScaffold
    └── ContentWidthConstraint
        └── SingleChildScrollView
            └── Column(crossAxisAlignment: start)
                │
                ├── 1. 日期标题区
                │   └── Text("2026年3月15日 星期六")
                │       style: headlineSmall
                │       格式使用 l10n DateFormat
                │
                ├── SizedBox(height: 24)
                │
                ├── 2. 心情展示区
                │   └── Row(mainAxisAlignment: center)
                │       ├── 大号 emoji（48dp 字号）
                │       └── SizedBox(width: 12)
                │       └── Text(moodLabel)  // "很开心" / "平静" 等
                │           style: titleLarge
                │
                ├── SizedBox(height: 24)
                │
                ├── 3. 一点光文本区（仅 lightText 非空时显示）
                │   └── Card
                │       └── Padding(16dp)
                │           ├── Text("今日一点光", style: labelLarge)  // l10n
                │           └── SizedBox(height: 8)
                │           └── Text(light.lightText)
                │               style: bodyLarge
                │
                ├── SizedBox(height: 16)
                │
                ├── 4. 标签区（仅 tags 非空时显示）
                │   └── Wrap(spacing: 8, runSpacing: 4)
                │       └── [for tag in tags] Chip(label: Text("#$tag"))
                │
                ├── SizedBox(height: 16)
                │
                ├── 5. 时间轴事件区（仅 timelineEvents 非空时显示）
                │   └── Card
                │       └── Padding(16dp)
                │           ├── Text("今日时间轴", style: labelLarge)  // l10n
                │           └── SizedBox(height: 8)
                │           └── Column
                │               └── [for event in events]
                │                   _TimelineEventRow(text: event, index: i)
                │
                ├── SizedBox(height: 32)
                │
                └── 6. 编辑按钮
                    └── Center
                        └── FilledButton.tonal(
                              onPressed: → 导航到 DailyLightScreen(date: date, prefill: light),
                              child: Text("编辑记录"),  // l10n: dailyDetailEdit
                            )
```

### 数据获取

```dart
/// 查询指定日期的 DailyLight 记录
final dailyLightByDateProvider = FutureProvider.family<DailyLight?, String>(
  (ref, date) async {
    final repository = ref.watch(awarenessRepositoryProvider);
    final uid = ref.watch(currentUidProvider);
    return repository.getLightByDate(uid, date);
  },
);
```

### 异常处理

- Provider 返回 `null`（该日期无记录）：显示空状态提示 + 「去记录」按钮
- Provider 返回 `AsyncError`：显示通用错误提示 + 重试按钮

### 双主题适配

- Material 3：标准 `Card`、`Chip`、`FilledButton.tonal` 组件
- Retro Pixel：Card 使用 `PixelBorderShape`，Chip 使用像素边框，按钮使用像素风格

---

## 5. AwarenessStatsCard

### 文件路径

`lib/widgets/awareness/awareness_stats_card.dart`

### 接口定义

```dart
/// 觉知统计卡片，嵌入 ProfileScreen "我的" Tab
class AwarenessStatsCard extends ConsumerWidget {
  const AwarenessStatsCard({super.key});
}
```

### 嵌入位置

ProfileScreen（Tab 3 「我的」）的 `CustomScrollView` 中，位于成就区块之后、设置入口之前。

### 视觉规格

```
┌──────────────────────────────────────┐
│  ✨ 觉知统计                // l10n   │
├──────────────────────────────────────┤
│                                      │
│  心情分布                            │
│  😄 ████████████  45%  (18次)        │
│  🙂 ████████     30%  (12次)        │
│  😌 ████         15%  (6次)         │
│  😔 ██            8%  (3次)         │
│  😢 █             2%  (1次)         │
│                                      │
├──────────────────────────────────────┤
│                                      │
│  📊 关键指标                         │
│  ┌────────┐  ┌────────┐  ┌────────┐ │
│  │  40    │  │   8    │  │  75%   │ │
│  │ 光之日  │  │ 周回顾  │  │ 解忧率  │ │
│  └────────┘  └────────┘  └────────┘ │
│                                      │
├──────────────────────────────────────┤
│                                      │
│  🏷️ 高频标签（仅数据充足时显示）       │
│  #户外 (12次)  #家人 (9次)  #学习 (7次)│
│                                      │
├──────────────────────────────────────┤
│                                      │
│  🎯 本月挑战（仅有活跃挑战时显示）     │
│  早起习惯  15/20 天                   │
│  ████████████░░░░░  75%              │
│                                      │
└──────────────────────────────────────┘
```

### 数据区块详细说明

#### 区块一：心情分布

- 水平柱状图，每行一个 Mood
- 柱体颜色：根据 Mood 映射
  - 😄 veryHappy → `Colors.amber.shade400`
  - 🙂 happy → `Colors.lightGreen.shade400`
  - 😌 neutral → `Colors.blue.shade300`
  - 😔 down → `Colors.blueGrey.shade300`
  - 😢 veryDown → `Colors.grey.shade400`
- 柱体宽度：按比例计算，最大宽度为容器宽度的 60%
- 右侧显示百分比和次数
- Retro Pixel 主题：柱体使用像素风方块填充

#### 区块二：关键指标

- 三列网格布局（`Row` + `Expanded`）
- 每个指标卡片：
  - 上方：大号数字，`headlineMedium` 字体
  - 下方：标签文字，`labelSmall` 字体，`onSurfaceVariant` 颜色
- 指标定义：
  - **光之日**：`totalLightDays`（累计记录天数）
  - **周回顾**：`totalWeeklyReviews`（累计完成次数）
  - **解忧率**：`resolved / (resolved + disappeared + ongoing) * 100`，显示为百分比

#### 区块三：高频标签（条件显示）

- 仅当累计带标签记录 >= 30 条时显示（由 tagFrequencyProvider 自动控制）
- 显示频率最高的前 3 个标签
- 每个标签：`Chip` 样式，显示标签名 + 次数
- 数据不足时整个区块隐藏

#### 区块四：本月挑战进度（条件显示）

- 仅当存在活跃的月度挑战时显示
- 显示习惯名称 + 完成天数/目标天数
- 线性进度条（`LinearProgressIndicator`）
- 无活跃挑战时整个区块隐藏

### 数据来源

```dart
/// 觉知综合统计数据
final awarenessStatsProvider = FutureProvider<AwarenessStats>((ref) async {
  final repository = ref.watch(awarenessRepositoryProvider);
  final uid = ref.watch(currentUidProvider);

  return AwarenessStats(
    totalLightDays: await repository.countLightDays(uid),
    totalWeeklyReviews: await repository.countWeeklyReviews(uid),
    totalWorriesResolved: await repository.countResolvedWorries(uid),
    totalWorriesAll: await repository.countAllWorries(uid),
  );
});

/// 心情分布统计
final moodDistributionProvider = FutureProvider<Map<Mood, int>>((ref) async {
  final repository = ref.watch(awarenessRepositoryProvider);
  final uid = ref.watch(currentUidProvider);

  // 查询所有 DailyLight 记录，按 Mood 聚合计数
  final lights = await repository.getAllLights(uid);
  final distribution = <Mood, int>{};
  for (final light in lights) {
    distribution[light.mood] = (distribution[light.mood] ?? 0) + 1;
  }
  return distribution;
});

/// 标签频率统计（前 N 名）
final tagFrequencyProvider = FutureProvider.family<List<(String, int)>, int>(
  (ref, topN) async {
    final repository = ref.watch(awarenessRepositoryProvider);
    final uid = ref.watch(currentUidProvider);

    final lights = await repository.getAllLights(uid);
    final tagCounts = <String, int>{};
    for (final light in lights) {
      for (final tag in light.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    final sorted = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(topN).map((e) => (e.key, e.value)).toList();
  },
);
```

### AwarenessStats 数据类

```dart
class AwarenessStats {
  final int totalLightDays;
  final int totalWeeklyReviews;
  final int totalWorriesResolved;
  final int totalWorriesAll;

  const AwarenessStats({
    required this.totalLightDays,
    required this.totalWeeklyReviews,
    required this.totalWorriesResolved,
    required this.totalWorriesAll,
  });

  /// 解忧率（百分比），分母为 0 时返回 0
  double get worryResolutionRate {
    if (totalWorriesAll == 0) return 0;
    return totalWorriesResolved / totalWorriesAll * 100;
  }
}
```

### 加载与错误状态

- 加载中：显示 `Shimmer` 骨架屏（3 行占位块）
- 加载失败：显示简化的错误卡片，含重试按钮
- 数据为空（用户从未使用觉知功能）：显示引导卡片「开始记录你的第一点光」+ 跳转按钮

---

## 6. TimelineEditor Widget（可选）

### 文件路径

`lib/widgets/awareness/timeline_editor.dart`

### 优先级说明

TimelineEditor 为 **低优先级可选增强**。核心历史视图和统计功能稳定后再实现。可在 DailyLightScreen 的输入表单中作为可选区块嵌入。

### 接口定义

```dart
/// 垂直时间轴编辑器，允许用户记录当天的关键事件（最多 5 条）
class TimelineEditor extends StatefulWidget {
  /// 初始事件列表（编辑已有记录时传入）
  final List<String>? initialEvents;

  /// 事件列表变更回调
  final ValueChanged<List<String>> onEventsChanged;

  const TimelineEditor({
    super.key,
    this.initialEvents,
    required this.onEventsChanged,
  });
}
```

### 视觉规格

#### 整体布局

垂直时间轴，左侧为连接线 + 节点，右侧为文本输入区域。

```
  ●─── [ 早上跑了 3 公里           ] [✕]
  │
  ＋ ← 点击添加新事件
  │
  ●─── [ 和同事一起吃了午餐        ] [✕]
  │
  ＋
  │
  ●─── [ 看完了一本书的最后两章     ] [✕]
  │
  ＋  ← 最多 5 条，达到上限后隐藏
```

#### 节点样式

- **Material 3 主题**：
  - 连接线：`colorScheme.outlineVariant`，宽度 2dp
  - 节点圆点：`colorScheme.primary`，直径 12dp，实心圆
  - 添加按钮圆点：`colorScheme.outline`，直径 12dp，`Icons.add` 图标
- **Retro Pixel 主题**：
  - 连接线：像素风点状虚线（用 `CustomPainter` 绘制方块间断线）
  - 节点圆点：像素风小方块，4x4 像素
  - 添加按钮：像素风「+」号

#### 文本输入

- 每条事件为一个 `TextField`，单行输入，最大 100 字符
- 右侧：删除按钮（`Icons.close`，尺寸 18dp）
- 点击删除 → 移除该条，触发 `onEventsChanged`
- Hint 文本：`timelineEventHint`（l10n：「发生了什么？」）

#### 约束

- 最多 5 条事件
- 达到 5 条后隐藏所有「+」按钮
- 至少 0 条（全部删除后仅显示一个「+」按钮）

### 状态管理

```dart
class _TimelineEditorState extends State<TimelineEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = (widget.initialEvents ?? [])
        .map((e) => TextEditingController(text: e))
        .toList();
  }

  void _addEvent(int insertIndex) {
    if (_controllers.length >= 5) return;
    setState(() {
      _controllers.insert(insertIndex, TextEditingController());
    });
    _notifyChange();
  }

  void _removeEvent(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChange();
  }

  void _notifyChange() {
    widget.onEventsChanged(
      _controllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
    );
  }
}
```

---

## 7. ProfileScreen 改动

### 文件路径

`lib/screens/profile/profile_screen.dart`

### 改动范围

在现有 `CustomScrollView` 的 `slivers` 列表中插入 `AwarenessStatsCard`。

### 改动后 ProfileScreen 区块顺序

```
CustomScrollView slivers:
├── SliverAppBar (用户信息 + 头像)          ← 现有
├── SliverToBoxAdapter: 用户统计摘要        ← 现有
├── SliverToBoxAdapter: 成就展示区          ← 现有
├── SliverToBoxAdapter: AwarenessStatsCard  ← 新增
├── SliverToBoxAdapter: 签到日历入口        ← 现有
├── SliverToBoxAdapter: 设置入口            ← 现有
└── SliverPadding(bottom)                  ← 现有
```

### 具体改动

1. 在 `profile_screen.dart` 顶部添加 import：
   ```dart
   import 'package:hachimi_app/widgets/awareness/awareness_stats_card.dart';
   ```

2. 在成就区块之后插入：
   ```dart
   SliverToBoxAdapter(
     child: Padding(
       padding: EdgeInsets.symmetric(
         horizontal: AppSpacing.screenPadding,
         vertical: AppSpacing.md,
       ),
       child: const AwarenessStatsCard(),
     ),
   ),
   ```

### 注意事项

- AwarenessStatsCard 自行管理数据获取（通过 `ref.watch` 订阅 providers），不需要 ProfileScreen 传递参数
- 当用户从未使用觉知功能时，卡片显示引导内容而非空白
- 双主题兼容：AwarenessStatsCard 内部通过 `Theme.of(context)` 适配，ProfileScreen 无需额外处理

---

## 8. L10n Key 清单

### 新增 Key 列表（约 22 个）

| Key | EN | ZH-CN | 使用位置 |
|-----|-----|-------|---------|
| `calendarMon` | Mon | 一 | MoodCalendar 星期表头 |
| `calendarTue` | Tue | 二 | MoodCalendar 星期表头 |
| `calendarWed` | Wed | 三 | MoodCalendar 星期表头 |
| `calendarThu` | Thu | 四 | MoodCalendar 星期表头 |
| `calendarFri` | Fri | 五 | MoodCalendar 星期表头 |
| `calendarSat` | Sat | 六 | MoodCalendar 星期表头 |
| `calendarSun` | Sun | 日 | MoodCalendar 星期表头 |
| `historyWeeklyReviews` | Weekly Reviews | 周回顾 | AwarenessHistoryScreen 标题 |
| `historyHappyMoments` | {count} happy moments | {count}个幸福时刻 | 周回顾折叠卡片徽章 |
| `historyWeekRange` | {startDate} - {endDate} | {startDate} - {endDate} | 周回顾卡片周范围 |
| `dailyDetailEdit` | Edit Record | 编辑记录 | DailyDetailScreen 编辑按钮 |
| `dailyDetailTimeline` | Today's Timeline | 今日时间轴 | DailyDetailScreen 时间轴标题 |
| `dailyDetailLight` | Today's Light | 今日一点光 | DailyDetailScreen 光文本标题 |
| `statsTitle` | Awareness Stats | 觉知统计 | AwarenessStatsCard 标题 |
| `statsMoodDistribution` | Mood Distribution | 心情分布 | AwarenessStatsCard 区块标题 |
| `statsLightDays` | Light Days | 光之日 | AwarenessStatsCard 指标标签 |
| `statsWeeklyReviews` | Reviews | 周回顾 | AwarenessStatsCard 指标标签 |
| `statsResolutionRate` | Resolution Rate | 解忧率 | AwarenessStatsCard 指标标签 |
| `statsTopTags` | Top Tags | 高频标签 | AwarenessStatsCard 区块标题 |
| `statsMonthlyChallenge` | Monthly Challenge | 本月挑战 | AwarenessStatsCard 区块标题 |
| `statsStartRecording` | Start recording your first light | 开始记录你的第一点光 | AwarenessStatsCard 空状态 |
| `timelineEventHint` | What happened? | 发生了什么？ | TimelineEditor 输入提示 |

### ARB 文件改动

- `lib/l10n/app_en.arb`：新增以上 22 个 key
- `lib/l10n/app_zh.arb`：新增以上 22 个 key（中文值）
- 其余语言 ARB 文件：不新增，自动 fallback 到英文

---

## 9. 文件操作清单

### 需要创建的文件（6 个）

| 文件路径 | 类型 | 说明 |
|---------|------|------|
| `lib/widgets/awareness/mood_calendar.dart` | Widget | 月历心情日历组件 |
| `lib/widgets/awareness/awareness_stats_card.dart` | Widget | 觉知统计卡片 |
| `lib/widgets/awareness/timeline_editor.dart` | Widget | 时间轴编辑器（可选，低优先级） |
| `lib/screens/awareness/awareness_history_screen.dart` | Screen | 历史视图主屏幕 |
| `lib/screens/awareness/daily_detail_screen.dart` | Screen | 每日详情屏幕 |
| `lib/models/awareness_stats.dart` | Model | AwarenessStats 数据类 |

### 需要修改的文件（6 个）

| 文件路径 | 改动说明 |
|---------|---------|
| `lib/screens/awareness/awareness_screen.dart` | 将「回顾」子 Tab 占位替换为 AwarenessHistoryScreen |
| `lib/screens/profile/profile_screen.dart` | 插入 AwarenessStatsCard 区块 |
| `lib/providers/awareness_providers.dart` | 新增 `monthlyLightsProvider`、`weeklyReviewsForMonthProvider`、`dailyLightByDateProvider`、`awarenessStatsProvider`、`moodDistributionProvider`、`tagFrequencyProvider` |
| `lib/core/router/app_router.dart` | 新增 `/awareness-history` 和 `/daily-detail` 路由 |
| `lib/l10n/app_en.arb` | 新增约 22 个 l10n key |
| `lib/l10n/app_zh.arb` | 新增约 22 个 l10n key（中文） |

### 需要读取的文件（仅参考，不改动）

| 文件路径 | 参考目的 |
|---------|---------|
| `lib/models/daily_light.dart` | DailyLight 模型结构（轨道一产出） |
| `lib/models/weekly_review.dart` | WeeklyReview 模型结构（轨道一产出） |
| `lib/services/awareness_service.dart` | Repository 接口方法签名 |
| `lib/core/theme/app_theme.dart` | 主题色值引用 |
| `lib/widgets/awareness/awareness_empty_state.dart` | 空状态组件复用 |

---

## 10. 完成标志

### 功能验收

- [ ] MoodCalendar 可翻月查看，每日格正确显示心情 emoji 或空心圆
- [ ] 当天日期有环形高亮，未来月份不可导航
- [ ] 点击有记录的日期可跳转到 DailyDetailScreen，显示完整记录
- [ ] 点击无记录的日期可跳转到 DailyLightScreen 补录
- [ ] AwarenessHistoryScreen 的周回顾折叠卡片可正确展开/折叠
- [ ] 周回顾卡片正确显示幸福时刻、感恩、学习、猫咪周总结
- [ ] AwarenessStatsCard 在 ProfileScreen 正确显示心情分布和关键指标
- [ ] 数据为空时显示引导内容而非空白
- [ ] 所有新增 l10n key 在 EN 和 ZH-CN 下正确显示

### 双主题验收

- [ ] Material 3 主题下所有新屏幕和组件正确渲染
- [ ] Retro Pixel 主题下 MoodCalendar 使用 PixelBorderShape
- [ ] Retro Pixel 主题下 AwarenessStatsCard 使用像素风柱状图
- [ ] Retro Pixel 主题下 TimelineEditor 使用像素点状连接线

### 代码质量

- [ ] `dart analyze lib/` 零 warning / error
- [ ] `dart format lib/ test/ --set-exit-if-changed` 零格式问题
- [ ] 所有新文件行数 ≤ 800 行
- [ ] 所有新函数行数 ≤ 30 行
- [ ] 无硬编码颜色值，全部通过 `Theme.of(context)` 获取

### 触发下一步

完成以上所有验收项 → 触发 v2.36.0 版本发布流程（参见 `12-workflow-release.md`）

---

## 依赖关系

### 前置条件

- **轨道一（plan_02）**：数据模型、SQLite migration、Repository 层必须就绪
- **轨道二（plan_03）**：AwarenessScreen 三子 Tab 骨架、AwarenessEmptyState 组件必须就绪
- **轨道三（plan_04）**：导航重组完成、ProfileScreen 结构稳定

### 后续影响

- 轨道五（plan_06）的模式发现功能可复用 `moodDistributionProvider` 和 `tagFrequencyProvider`
- AwarenessStatsCard 的标签频率数据为后续 AI 欢乐地图提供基础

### 外部依赖

- 无新增外部 package 依赖
- 所有图表使用原生 Flutter Widget 实现（无需引入 `fl_chart` 等库）

---

## 风险与挑战

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| MoodCalendar 性能（大量日期渲染） | 翻月卡顿 | 使用 `const` Widget + `monthlyLightsProvider` 缓存 |
| ISO 周跨月边界计算 | 周回顾归属月份不正确 | 使用标准 ISO 8601 算法，编写单元测试覆盖边界场景 |
| 统计数据量增长后查询变慢 | AwarenessStatsCard 加载缓慢 | 利用 `local_awareness_stats` 表的预聚合数据，避免全表扫描 |
| 双主题适配遗漏 | Retro Pixel 下视觉不一致 | 每个新组件在两种主题下分别手动验证 |
