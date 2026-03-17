---
level: 2
file_id: plan_03
parent: plan_01
status: pending
created: 2026-03-17 23:30
children: []
estimated_time: 720分钟
prerequisites: [plan_02]
---

# 轨道二：觉知核心 UI

## 1. 模块概述

### 1.1 交付目标

轨道二是 V3 觉知伴侣的 **UI 实现层**，负责构建用户与觉知功能交互的全部界面。交付完成后，用户可以：

- 在觉知 Tab 的「今天」「本周」「回顾」三个子 Tab 间切换
- 完整完成「每日一点光」记录流程（选心情 → 写文字 → 选标签 → 保存 → 看猫咪反应）
- 完整完成「周回顾」流程（三个幸福时刻 + 感恩 + 学习 + 烦恼更新 → 保存 → 看猫咪模板周总结）
- 使用「烦恼处理器」进行烦恼的 CRUD 和状态管理
- 在快速模式下（从专注完成页触发），30 秒完成一点光记录

### 1.2 前置依赖

本轨道 **严格依赖轨道一（plan_02）** 提供的以下产物：

| 依赖项 | 来源 | 用途 |
|--------|------|------|
| `Mood` 枚举 | `lib/models/mood.dart` | MoodSelector 渲染 5 种心情 |
| `DailyLight` 模型 | `lib/models/daily_light.dart` | DailyLightScreen 读写 |
| `WeeklyReview` 模型 | `lib/models/weekly_review.dart` | WeeklyReviewScreen 读写 |
| `Worry` 模型 + `WorryStatus` 枚举 | `lib/models/worry.dart` | WorryItemCard、WorryEditScreen |
| `awarenessRepositoryProvider` | `lib/providers/service_providers.dart` | 所有觉知数据操作 |
| `worryRepositoryProvider` | `lib/providers/service_providers.dart` | 烦恼数据操作 |
| `todayLightProvider` | `lib/providers/awareness_providers.dart` | 今日一点光状态 |
| `currentWeekReviewProvider` | `lib/providers/awareness_providers.dart` | 本周回顾状态 |
| `activeWorriesProvider` | `lib/providers/awareness_providers.dart` | 活跃烦恼列表 |

### 1.3 与其他轨道的关系

```
轨道一（数据基础）
    │
    ▼
【轨道二（觉知核心 UI）】  ← 本文档
    │
    ├──▶ 轨道三（飞轮桥接 + 导航）
    │       - HomeScreen Tab 重组时把 AwarenessScreen 接入 Tab 0
    │       - FocusCompleteScreen 桥接 Banner 调用 DailyLightScreen(quickMode: true)
    │       - MonthlyRitualCard 嵌入 AwarenessScreen 今日 Tab
    │
    └──▶ 轨道四（历史视图 + 统计）
            - 回顾子 Tab 内容在轨道四实现
```

### 1.4 主题兼容策略

所有新增 Widget 必须在 **Material 3** 和 **Retro Pixel** 两种主题下正确渲染：

- **颜色**：统一使用 `Theme.of(context).colorScheme.*`，**绝对禁止** 硬编码颜色值
- **形状**：使用 `Theme.of(context).cardTheme.shape` 等主题属性，Retro Pixel 模式通过 `ThemeSkin` 自动注入 `PixelBorderShape`
- **文字**：使用 `Theme.of(context).textTheme.*`，Retro Pixel 模式自动替换为像素字体
- **间距**：使用 `AppSpacing` 常量，双主题共用
- **背景**：Screen 级别使用 `AppScaffold`（自动叠加 `RetroTiledBackground`），Widget 级别不需要处理

---

## 2. Widget 规格

### 2.1 MoodSelector

**文件路径**：`lib/widgets/awareness/mood_selector.dart`

**类定义**：

```dart
/// 心情选择器 — 水平排列 5 个心情按钮。
///
/// 两种尺寸：
/// - `compact: false`（默认）：完整页面模式，用于 DailyLightScreen
/// - `compact: true`：迷你模式，用于飞轮桥接 Banner
class MoodSelector extends StatelessWidget {
  /// 当前选中的心情（null = 未选择）。
  final Mood? selectedMood;

  /// 心情选中回调。
  final ValueChanged<Mood> onMoodSelected;

  /// 迷你模式：缩小尺寸，适配 BottomSheet / Banner。
  final bool compact;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    this.compact = false,
  });
}
```

**视觉布局**：

```
┌─────────────────────────────────────────────┐
│  Row(mainAxisAlignment: spaceEvenly)        │
│                                             │
│  [😄]   [🙂]   [😌]   [😔]   [😢]        │
│                                             │
│  文字    文字    文字    文字    文字         │
│  (仅非 compact 模式显示)                     │
└─────────────────────────────────────────────┘
```

- **完整模式**（`compact: false`）：每个心情按钮 56x56，下方有 `bodySmall` 文字标签（来自 L10n）
- **迷你模式**（`compact: true`）：每个心情按钮 40x40，无文字标签

**心情按钮构成**：

每个心情按钮为 `InkWell` 包裹的 `AnimatedContainer`：
- **未选中**：`Container` 背景为 `colorScheme.surfaceContainerHigh`，内部为 `Text`（emoji 文字）
- **选中**：`Container` 背景为心情对应颜色的 `withValues(alpha: 0.2)`，外围 2px `Border` 使用心情颜色

**心情颜色映射**（使用 `colorScheme` 语义色）：

| Mood | emoji | 选中环颜色 | 语义 |
|------|-------|-----------|------|
| `veryHappy` | 😄 | `colorScheme.tertiary`（gold 色调） | 非常开心 |
| `happy` | 🙂 | `Color(0xFF4CAF50)` — 但应从 `colorScheme.primary` 派生 | 开心 |
| `calm` | 😌 | `colorScheme.primary` | 平静 |
| `down` | 😔 | `colorScheme.error.withValues(alpha: 0.7)` | 低落 |
| `veryDown` | 😢 | `colorScheme.error` | 很低落 |

> **注意**：为避免硬编码，使用 `colorScheme` 的语义槽配合 `HSLColor` 明度调整。具体实现可提取一个 `_moodColor(Mood mood, ColorScheme scheme)` 私有方法。

**动画**：选中时 `ScaleTransition`，`duration: 100ms`，`curve: Curves.easeOut`，缩放比 `1.0 → 1.15 → 1.0`。使用 `AnimatedScale` 简化实现（无需手动 `AnimationController`）。

**交互行为**：

1. 点击任意心情按钮 → 调用 `onMoodSelected(mood)`
2. 已选中状态下再次点击同一按钮 → 不做任何操作（心情为必选项，不可取消）
3. 切换选中项时，旧按钮缩回、新按钮放大

**主题兼容**：

- Material 3：`CircleAvatar` 风格圆形按钮，`colorScheme.primaryContainer` 背景
- Retro Pixel：容器自动获取 `PixelBorderShape`（来自 `chipTheme`），无需额外代码

---

### 2.2 LightInputCard

**文件路径**：`lib/widgets/awareness/light_input_card.dart`

**类定义**：

```dart
/// 一点光文字输入卡片 — 带字数计数器的 TextField。
class LightInputCard extends StatefulWidget {
  /// 初始文字（编辑模式）。
  final String? initialText;

  /// 文字变更回调。
  final ValueChanged<String> onTextChanged;

  /// 最大字数限制。
  final int maxLength;

  const LightInputCard({
    super.key,
    this.initialText,
    required this.onTextChanged,
    this.maxLength = 500,
  });
}
```

**状态管理**：`_LightInputCardState` 持有 `TextEditingController`，在 `initState` 中从 `initialText` 初始化，在 `dispose` 中释放。

**视觉布局**：

```
┌─────────────────────────────────────┐
│  Card                               │
│  ┌─────────────────────────────────┐│
│  │ TextField                       ││
│  │ placeholder: l10n 文案          ││
│  │ minLines: 3                     ││
│  │ maxLines: 6                     ││
│  │ maxLength: 500                  ││
│  │                                 ││
│  │                        42/500   ││
│  └─────────────────────────────────┘│
│  padding: AppSpacing.paddingMd      │
└─────────────────────────────────────┘
```

**TextField 配置**：

```dart
TextField(
  controller: _controller,
  decoration: InputDecoration(
    hintText: context.l10n.awarenessLightPlaceholder,
    border: InputBorder.none,
    counterText: '${_controller.text.length}/$maxLength',
  ),
  minLines: 3,
  maxLines: 6,
  maxLength: maxLength,
  maxLengthEnforcement: MaxLengthEnforcement.enforced,
  onChanged: onTextChanged,
  textCapitalization: TextCapitalization.sentences,
)
```

**注意事项**：

- `counterText` 自定义格式（`42/500`），不使用 Flutter 默认的 `counterText` 样式位置
- 自行在 `Card` 右下角通过 `Align` 放置计数器文字，使用 `textTheme.labelSmall` + `colorScheme.onSurfaceVariant`
- `Card` 使用 `Theme.of(context).cardTheme` 样式，自动适配双主题

**主题兼容**：

- Material 3：标准 `Card` + `InputDecoration`，圆角来自 `cardTheme`
- Retro Pixel：`Card` 自动获取 `PixelBorderShape`，`InputDecoration` 通过 `inputDecorationTheme` 自动适配

---

### 2.3 TagSelector

**文件路径**：`lib/widgets/awareness/tag_selector.dart`

**类定义**：

```dart
/// 标签选择器 — 预设标签 + 可选自定义标签。
///
/// 复用 [ChipSelectorRow] 的 Wrap + FilterChip 模式，
/// 但输入输出为 `List<String>` 而非 `int`。
class TagSelector extends StatelessWidget {
  /// 预设标签列表。
  final List<String> presetTags;

  /// 当前选中的标签列表（支持多选）。
  final List<String> selectedTags;

  /// 标签变更回调。
  final ValueChanged<List<String>> onTagsChanged;

  /// 是否允许自定义标签。
  final bool allowCustom;

  const TagSelector({
    super.key,
    required this.presetTags,
    required this.selectedTags,
    required this.onTagsChanged,
    this.allowCustom = true,
  });
}
```

**预设标签常量**（定义在 `lib/core/constants/awareness_constants.dart`）：

```dart
class AwarenessConstants {
  AwarenessConstants._();

  static const List<String> presetTags = [
    '家人',  // family
    '朋友',  // friends
    '学习',  // study
    '户外',  // outdoor
    '工作',  // work
  ];
}
```

> **注意**：预设标签使用中文硬编码。因为标签是用户数据的一部分（保存到数据库），L10n 翻译在此不适用——中文用户写的标签永远是中文。如果未来做国际化，标签改为 L10n key 映射需要数据迁移。MVP 阶段不处理此问题。

**视觉布局**：

```
┌──────────────────────────────────────────────┐
│  Wrap(spacing: 8, runSpacing: 4)             │
│                                              │
│  [家人] [朋友] [学习] [户外] [工作] [+自定义] │
│                                              │
└──────────────────────────────────────────────┘
```

- 每个预设标签为 `FilterChip`，`selected` 状态由 `selectedTags.contains(tag)` 控制
- 点击已选中标签 → 从 `selectedTags` 移除；点击未选中标签 → 添加到 `selectedTags`
- 最后一个元素为 `ActionChip`，图标 `Icons.add`，文案 `+自定义`

**自定义标签行为**：

1. 点击「+自定义」→ `ActionChip` 替换为内联 `TextField`（`SizedBox(width: 120)`）
2. 用户输入完成（按回车或失焦）→ 非空文本添加到 `selectedTags`，`TextField` 消失
3. 自定义标签添加后与预设标签外观一致（`FilterChip`，`selected: true`），点击可取消
4. 空输入自动取消

**主题兼容**：

- `FilterChip` 和 `ActionChip` 通过 `chipTheme` 自动适配双主题
- Retro Pixel 下 Chip 自动获取像素边框，无需额外代码

---

### 2.4 HappyMomentCard

**文件路径**：`lib/widgets/awareness/happy_moment_card.dart`

**类定义**：

```dart
/// 幸福时刻卡片 — 周回顾中使用，包含编号、文本输入和标签选择。
class HappyMomentCard extends StatelessWidget {
  /// 幸福时刻编号（1、2 或 3）。
  final int momentNumber;

  /// 当前文本内容。
  final String? text;

  /// 当前选中的标签。
  final List<String> tags;

  /// 文本变更回调。
  final ValueChanged<String?> onTextChanged;

  /// 标签变更回调。
  final ValueChanged<List<String>> onTagsChanged;

  const HappyMomentCard({
    super.key,
    required this.momentNumber,
    this.text,
    this.tags = const [],
    required this.onTextChanged,
    required this.onTagsChanged,
  });
}
```

**视觉布局**：

```
┌──────────────────────────────────────┐
│  Card                                │
│  ┌──────────────────────────────────┐│
│  │ Row                              ││
│  │  [✨ emoji]  "幸福时刻 #1"       ││
│  │               titleSmall          ││
│  └──────────────────────────────────┘│
│  ┌──────────────────────────────────┐│
│  │ TextField                        ││
│  │ hintText: "这周有什么让你开心的？"││
│  │ minLines: 2, maxLines: 4         ││
│  └──────────────────────────────────┘│
│  ┌──────────────────────────────────┐│
│  │ TagSelector(compact)             ││
│  │ presetTags + allowCustom         ││
│  └──────────────────────────────────┘│
│  padding: AppSpacing.paddingMd       │
└──────────────────────────────────────┘
```

- 卡片头部使用 `textTheme.titleSmall`，带 `✨` emoji 前缀
- `TextField` 使用 `InputBorder.none`，保持卡片内干净
- `TagSelector` 复用 2.3 中定义的组件，传入相同的 `presetTags`

**主题兼容**：`Card` + `TextField` + `TagSelector` 均通过 `Theme` 自动适配。

---

### 2.5 WorryItemCard

**文件路径**：`lib/widgets/awareness/worry_item_card.dart`

**类定义**：

```dart
/// 烦恼条目卡片 — 显示烦恼描述、解法预览和状态切换。
class WorryItemCard extends StatelessWidget {
  /// 烦恼数据。
  final Worry worry;

  /// 状态变更回调。
  final ValueChanged<WorryStatus> onStatusChanged;

  /// 点击卡片回调（进入编辑页）。
  final VoidCallback onTap;

  const WorryItemCard({
    super.key,
    required this.worry,
    required this.onStatusChanged,
    required this.onTap,
  });
}
```

**视觉布局**：

```
┌──────────────────────────────────────────────┐
│  Card (InkWell onTap)                         │
│  ┌──────────────────────────────────────────┐│
│  │ Column                                   ││
│  │                                          ││
│  │ Text: worry.description                  ││
│  │   bodyMedium, maxLines: 2, overflow      ││
│  │                                          ││
│  │ if (worry.solution != null)              ││
│  │   Text: "💡 " + worry.solution           ││
│  │     bodySmall, onSurfaceVariant          ││
│  │     maxLines: 1, overflow                ││
│  │                                          ││
│  │ SizedBox(height: sm)                     ││
│  │                                          ││
│  │ SegmentedButton<WorryStatus>             ││
│  │   [还在] [搞定了] [消失了]               ││
│  │                                          ││
│  └──────────────────────────────────────────┘│
│  padding: AppSpacing.paddingMd               │
└──────────────────────────────────────────────┘
```

**SegmentedButton 样式**：

| WorryStatus | 文案 | 选中时颜色 |
|-------------|------|-----------|
| `ongoing` | L10n: `worryStatusOngoing` | `colorScheme.tertiary`（amber 色调） |
| `resolved` | L10n: `worryStatusResolved` | `Color(0xFF4CAF50)` 派生自 `colorScheme` |
| `disappeared` | L10n: `worryStatusDisappeared` | `colorScheme.outline`（grey 色调） |

**交互行为**：

1. 点击卡片整体 → `onTap()`（导航到 WorryEditScreen 编辑）
2. 点击 `SegmentedButton` 某段 → `onStatusChanged(newStatus)`
3. `SegmentedButton` 的 `onSelectionChanged` 需要 `stopPropagation` 避免触发卡片 `onTap`

**主题兼容**：

- `SegmentedButton` 通过 `Theme` 自动适配
- `Card` 通过 `cardTheme` 自动适配

---

### 2.6 CatBedtimeAnimation

**文件路径**：`lib/widgets/awareness/cat_bedtime_animation.dart`

**类定义**：

```dart
/// 猫咪睡前反应动画 — 一点光保存后弹出。
///
/// 使用现有 [PixelCatSprite] 显示 featured cat，
/// 根据用户心情播放不同动画 + 显示模板文案。
class CatBedtimeAnimation extends ConsumerStatefulWidget {
  /// 用户选择的心情。
  final Mood mood;

  const CatBedtimeAnimation({
    super.key,
    required this.mood,
  });

  @override
  ConsumerState<CatBedtimeAnimation> createState() =>
      _CatBedtimeAnimationState();
}
```

> **注意**：此 Widget 需要 `ConsumerStatefulWidget` 而非 `ConsumerWidget`，因为它使用 `AnimationController` 控制动画。

**状态管理**：

`_CatBedtimeAnimationState` 混入 `TickerProviderStateMixin`，持有：
- `_spriteController`：控制猫咪 sprite 动画（scale/translate）
- `_textController`：控制文案淡入
- `_textOpacity`：`CurvedAnimation` 用于文案 `FadeTransition`

**视觉布局**：

```
┌─────────────────────────────────────┐
│  Column(mainAxisSize: min)          │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ PixelCatSprite.fromCat(         ││
│  │   cat: featuredCat,             ││
│  │   size: 120,                    ││
│  │ )                               ││
│  │ 外层包裹 AnimatedBuilder        ││
│  │ 应用 Transform (scale/translate)││
│  └─────────────────────────────────┘│
│                                     │
│  SizedBox(height: AppSpacing.base)  │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ FadeTransition                  ││
│  │   Text: 模板文案                ││
│  │   bodyMedium, textAlign: center ││
│  │   maxLines: 3                   ││
│  └─────────────────────────────────┘│
│                                     │
│  padding: AppSpacing.paddingLg      │
└─────────────────────────────────────┘
```

**心情动画映射**：

| Mood | 动画类型 | Transform 参数 | 时长 | 循环 |
|------|---------|---------------|------|------|
| `veryHappy` | bounce | `scale`: `1.0 → 1.2 → 1.0`（`TweenSequence`） | 600ms | 重复 3 次 |
| `happy` | nudge | `translateX`: `0 → 8 → -8 → 0`（正弦摆动） | 400ms | 重复 2 次 |
| `calm` | breathe | `scale`: `1.0 → 1.05 → 1.0`（缓慢呼吸） | 2000ms | 重复 1 次 |
| `down` | lean-in | `translateX`: `0 → -12`（向左轻靠） | 500ms | 不循环，保持终点 |
| `veryDown` | curl-up | `scale`: `1.0 → 0.92` + `opacity`: `1.0 → 0.85 → 1.0` | 3000ms | 不循环 |

**文案显示时序**：

1. Dialog 打开 → 猫咪动画立即开始
2. 猫咪动画完成后 300ms → 文案 `FadeTransition` 开始（`duration: 300ms`）
3. 文案完全显示后 → 整个 Dialog 保持 3 秒 → 自动关闭
4. 用户随时可点击关闭（`GestureDetector` 包裹整个布局）

**Featured Cat 获取**：

```dart
final catsAsync = ref.watch(catsProvider);
// 复用 TodayTab 的 _findFeaturedCat 逻辑
// 如果没有猫（理论上不会），显示默认 placeholder
```

> **重构提示**：`_findFeaturedCat` 目前是 `TodayTab` 的私有方法，轨道二实现时应将其提取为 `catsProvider` 上的公共 computed provider（如 `featuredCatProvider`），避免代码重复。

**模板文案来源**：

文案从 `lib/core/constants/cat_response_templates.dart`（轨道五种子数据）获取。轨道二先硬编码 5 条种子文案（每心情 1 条），轨道五扩充为 100-150 条。

种子文案（用于轨道二开发/测试）：

| Mood | 种子文案 |
|------|---------|
| `veryHappy` | 「铲屎官今天好开心，本猫也开心！」 |
| `happy` | 「记录了今天的光，真棒 ✨」 |
| `calm` | 「平静的一天也很好呢 🍃」 |
| `down` | 「不开心的日子，本猫陪着你 💛」 |
| `veryDown` | 「没事的，本猫哪都不去 🫂」 |

**主题兼容**：

- `PixelCatSprite` 在双主题下已经过验证，无需额外处理
- 文案文字使用 `textTheme.bodyMedium`，颜色使用 `colorScheme.onSurface`

---

### 2.7 AwarenessEmptyState

**文件路径**：`lib/widgets/awareness/awareness_empty_state.dart`

**类定义**：

```dart
/// 觉知模块空状态 — 4 种类型，温暖关怀语气。
enum AwarenessEmptyType {
  todayLight,    // 今天还没记录一点光
  weeklyReview,  // 本周还没写周回顾
  history,       // 还没有历史记录
  worries,       // 没有活跃的烦恼
}

class AwarenessEmptyState extends StatelessWidget {
  /// 空状态类型。
  final AwarenessEmptyType type;

  /// 行动按钮回调（null = 不显示按钮）。
  final VoidCallback? onAction;

  const AwarenessEmptyState({
    super.key,
    required this.type,
    this.onAction,
  });
}
```

**4 种空状态配置**：

| type | 图标 | 标题（L10n key） | 副标题（L10n key） | 按钮文案（L10n key） |
|------|------|----------------|-------------------|---------------------|
| `todayLight` | `Icons.wb_sunny_outlined` | `awarenessEmptyLightTitle` | `awarenessEmptyLightSubtitle` | `awarenessEmptyLightAction` |
| `weeklyReview` | `Icons.auto_stories_outlined` | `awarenessEmptyReviewTitle` | `awarenessEmptyReviewSubtitle` | `awarenessEmptyReviewAction` |
| `history` | `Icons.history_outlined` | `awarenessEmptyHistoryTitle` | `awarenessEmptyHistorySubtitle` | — |
| `worries` | `Icons.sentiment_satisfied_outlined` | `awarenessEmptyWorriesTitle` | `awarenessEmptyWorriesSubtitle` | — |

**视觉布局**：

复用现有 `EmptyState` widget 的布局模式（`Center` + `Column` + icon + title + subtitle + optional button），但文案使用温暖关怀语气。

```dart
@override
Widget build(BuildContext context) {
  final config = _configFor(type, context);
  return EmptyState(
    icon: config.icon,
    title: config.title,
    subtitle: config.subtitle,
    actionLabel: config.actionLabel,
    onAction: onAction,
  );
}
```

**主题兼容**：完全继承 `EmptyState` 的主题适配，无需额外处理。

---

## 3. Screen 规格

### 3.1 AwarenessScreen

**文件路径**：`lib/screens/awareness/awareness_screen.dart`

**路由**：无独立命名路由 — 作为 `HomeScreen` 的 Tab 0 嵌入 `IndexedStack`。

> **注意**：Tab 重组在轨道三执行。轨道二仅构建 `AwarenessScreen` 本身，不修改 `HomeScreen`。开发期间可临时替换 `TodayTab` 进行测试。

**类定义**：

```dart
/// 觉知主屏幕 — 三个子 Tab：今天 / 本周 / 回顾。
class AwarenessScreen extends ConsumerStatefulWidget {
  const AwarenessScreen({super.key});

  @override
  ConsumerState<AwarenessScreen> createState() => _AwarenessScreenState();
}
```

**状态管理**：

`_AwarenessScreenState` 持有 `TabController`（length: 3），混入 `TickerProviderStateMixin`。

**视觉布局**：

```
┌─────────────────────────────────────────────┐
│  ContentWidthConstraint                     │
│  ┌─────────────────────────────────────────┐│
│  │ CustomScrollView                        ││
│  │                                         ││
│  │ SliverAppBar(floating: true)            ││
│  │   title: l10n.awarenessTitle            ││
│  │   bottom: TabBar                        ││
│  │     [今天] [本周] [回顾]                ││
│  │                                         ││
│  │ SliverFillRemaining                     ││
│  │   TabBarView                            ││
│  │     [TodaySubTab]                       ││
│  │     [ThisWeekSubTab]                    ││
│  │     [ReviewSubTab]                      ││
│  │                                         ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

> **实现注意**：`SliverAppBar` + `TabBarView` 嵌套 `CustomScrollView` 在 Flutter 中需要用 `NestedScrollView` 而非 `CustomScrollView` + `SliverFillRemaining`。推荐结构：

```dart
NestedScrollView(
  headerSliverBuilder: (context, innerBoxIsScrolled) => [
    SliverAppBar(
      floating: true,
      snap: true,
      title: Text(context.l10n.awarenessTitle),
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: context.l10n.awarenessTabToday),
          Tab(text: context.l10n.awarenessTabThisWeek),
          Tab(text: context.l10n.awarenessTabReview),
        ],
      ),
    ),
  ],
  body: TabBarView(
    controller: _tabController,
    children: const [
      _TodaySubTab(),
      _ThisWeekSubTab(),
      _ReviewSubTab(),
    ],
  ),
)
```

#### 3.1.1 今天子 Tab（`_TodaySubTab`）

**类型**：私有 `ConsumerWidget`，定义在 `awareness_screen.dart` 内部。

**内容（自上而下）**：

```
┌─────────────────────────────────────────────┐
│  ListView / SingleChildScrollView           │
│                                             │
│  1. 一点光状态卡                             │
│     ┌─────────────────────────────────────┐ │
│     │ 已记录：                             │ │
│     │   [😌] + "今天阳光很好" + [编辑]     │ │
│     │ 未记录：                             │ │
│     │   AwarenessEmptyState(todayLight)    │ │
│     │   onAction: → DailyLightScreen       │ │
│     └─────────────────────────────────────┘ │
│                                             │
│  2. 月度挑战卡（Track 3 提供 placeholder）   │
│     ┌─────────────────────────────────────┐ │
│     │ 占位: SizedBox.shrink()              │ │
│     │ (轨道三 MonthlyRitualCard 接入)      │ │
│     └─────────────────────────────────────┘ │
│                                             │
│  3. 习惯快速勾选                             │
│     ┌─────────────────────────────────────┐ │
│     │ Section header: "今日习惯"            │ │
│     │ habitsProvider.when(...)              │ │
│     │   loading: SkeletonCard              │ │
│     │   data: habit list with checkboxes   │ │
│     │   empty: "还没有习惯，去领养一只猫吧"  │ │
│     └─────────────────────────────────────┘ │
│                                             │
│  Bottom padding: 100 (FAB + NavBar)         │
└─────────────────────────────────────────────┘
```

**一点光状态卡实现细节**：

```dart
final todayLight = ref.watch(todayLightProvider);

// todayLight 为 AsyncValue<DailyLight?>
todayLight.when(
  loading: () => const SkeletonCard(),
  error: (_, _) => const SizedBox.shrink(),
  data: (light) {
    if (light == null) {
      return AwarenessEmptyState(
        type: AwarenessEmptyType.todayLight,
        onAction: () => Navigator.of(context).pushNamed(AppRouter.dailyLight),
      );
    }
    return _LightStatusCard(light: light); // 显示已记录状态
  },
);
```

`_LightStatusCard`：`Card` 内包含 `Row`（心情 emoji + 文字预览 1 行）+ 右侧 `IconButton`（`Icons.edit_outlined`），点击跳转 `DailyLightScreen` 编辑模式。

**习惯快速勾选**：

复用 `habitsProvider`，以简化列表形式展示今日习惯。每个条目为 `ListTile`：
- leading: `Checkbox`（今日是否已完成 30 分钟+）
- title: 习惯名称
- subtitle: 今日已完成分钟数
- onTap: 导航到 `AppRouter.focusSetup`

> **注意**：快速勾选是只读状态展示 + 快捷入口，不是真正的 checkbox 打卡操作。用户需通过专注计时来「完成」习惯。

#### 3.1.2 本周子 Tab（`_ThisWeekSubTab`）

**内容（自上而下）**：

```
┌─────────────────────────────────────────────┐
│  ListView                                   │
│                                             │
│  1. 周回顾状态卡                             │
│     ┌─────────────────────────────────────┐ │
│     │ 已完成：                             │ │
│     │   周回顾摘要（时刻数 + 感恩主题）     │ │
│     │   [查看详情] → WeeklyReviewScreen    │ │
│     │ 未完成：                             │ │
│     │   AwarenessEmptyState(weeklyReview)  │ │
│     │   onAction: → WeeklyReviewScreen     │ │
│     └─────────────────────────────────────┘ │
│                                             │
│  2. 烦恼处理器                               │
│     ┌─────────────────────────────────────┐ │
│     │ Section header: "烦恼处理器"          │ │
│     │                                     │ │
│     │ activeWorriesProvider.when(...)      │ │
│     │   data:                             │ │
│     │     empty → AwarenessEmptyState     │ │
│     │     non-empty → WorryItemCard list  │ │
│     │                                     │ │
│     │ TextButton: "管理全部烦恼"            │ │
│     │   → WorryProcessorScreen            │ │
│     └─────────────────────────────────────┘ │
│                                             │
│  3. "添加烦恼" OutlinedButton               │
│     → WorryEditScreen(worryId: null)        │
│                                             │
│  Bottom padding: 100                        │
└─────────────────────────────────────────────┘
```

**状态依赖**：
- `currentWeekReviewProvider`：`AsyncValue<WeeklyReview?>`
- `activeWorriesProvider`：`AsyncValue<List<Worry>>`

#### 3.1.3 回顾子 Tab（`_ReviewSubTab`）

**轨道二占位实现**：

```dart
class _ReviewSubTab extends StatelessWidget {
  const _ReviewSubTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.awarenessReviewComingSoon,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
```

轨道四（plan_05）替换为完整的历史视图。

---

### 3.2 DailyLightScreen

**文件路径**：`lib/screens/awareness/daily_light_screen.dart`

**路由**：`AppRouter.dailyLight = '/daily-light'`

**Arguments**：`Map<String, dynamic>` — `{ 'quickMode': bool }`（默认 `false`）

**类定义**：

```dart
/// 每日一点光记录页 — 支持完整模式和快速模式。
class DailyLightScreen extends ConsumerStatefulWidget {
  /// 快速模式：仅心情 + 一句话，无标签。
  final bool quickMode;

  const DailyLightScreen({
    super.key,
    this.quickMode = false,
  });

  @override
  ConsumerState<DailyLightScreen> createState() => _DailyLightScreenState();
}
```

**状态管理**：

```dart
class _DailyLightScreenState extends ConsumerState<DailyLightScreen> {
  Mood? _selectedMood;
  String _text = '';
  List<String> _selectedTags = [];
  bool _isSaving = false;

  // 编辑模式：加载已有记录
  @override
  void initState() {
    super.initState();
    // 如果今天已有记录，填充表单
    // 使用 ref.read(todayLightProvider) 获取
  }
}
```

#### 3.2.1 完整模式布局

```
┌─────────────────────────────────────────────┐
│  AppScaffold                                │
│  appBar: AppBar(title: "今日一点光")          │
│                                             │
│  SingleChildScrollView                      │
│  padding: AppSpacing.paddingScreenBody       │
│  ┌─────────────────────────────────────────┐│
│  │                                         ││
│  │ Text: "你今天心情如何？"                  ││
│  │   titleMedium                           ││
│  │                                         ││
│  │ SizedBox(height: lg)                    ││
│  │                                         ││
│  │ MoodSelector(                           ││
│  │   selectedMood: _selectedMood,          ││
│  │   onMoodSelected: (m) => setState(...), ││
│  │   compact: false,                       ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: xl)                    ││
│  │                                         ││
│  │ LightInputCard(                         ││
│  │   initialText: _text,                   ││
│  │   onTextChanged: (t) => _text = t,      ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: lg)                    ││
│  │                                         ││
│  │ Text: "标签（可选）"                      ││
│  │   labelLarge                            ││
│  │                                         ││
│  │ SizedBox(height: sm)                    ││
│  │                                         ││
│  │ TagSelector(                            ││
│  │   presetTags: AwarenessConstants.tags,  ││
│  │   selectedTags: _selectedTags,          ││
│  │   onTagsChanged: (t) => setState(...), ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: 100) // FAB space      ││
│  └─────────────────────────────────────────┘│
│                                             │
│  FAB: FloatingActionButton.extended(        │
│    label: "保存",                            │
│    icon: Icons.check,                       │
│    onPressed: _selectedMood != null         │
│               ? _save : null,               │
│  )                                          │
└─────────────────────────────────────────────┘
```

#### 3.2.2 快速模式布局

快速模式设计为 `BottomSheet`（从 FocusCompleteScreen 调出），不使用独立页面路由：

```
┌─────────────────────────────────────────────┐
│  BottomSheet                                │
│  padding: AppSpacing.paddingDialog           │
│  ┌─────────────────────────────────────────┐│
│  │                                         ││
│  │ Text: "今天有什么让你微笑的事？"          ││
│  │   titleSmall                            ││
│  │                                         ││
│  │ SizedBox(height: base)                  ││
│  │                                         ││
│  │ MoodSelector(                           ││
│  │   selectedMood: _selectedMood,          ││
│  │   onMoodSelected: ...,                  ││
│  │   compact: true,                        ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: base)                  ││
│  │                                         ││
│  │ TextField(                              ││
│  │   maxLines: 2,                          ││
│  │   hintText: l10n.awarenessLightPlaceholder ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: base)                  ││
│  │                                         ││
│  │ Row(mainAxisAlignment: end)             ││
│  │   TextButton("跳过") + FilledButton("记录")││
│  │                                         ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

> **设计变更**：快速模式使用 `showModalBottomSheet` 而非页面路由，保持用户停留在 FocusCompleteScreen 上下文中。仅包含 MoodSelector（compact）+ 简短 TextField + 保存/跳过按钮。**无标签选择**。

#### 3.2.3 保存流程

```
用户点击「保存」
    ↓
setState(() => _isSaving = true)
    ↓
await ref.read(awarenessRepositoryProvider).saveDailyLight(
  DailyLight(
    date: DateTime.now(),
    mood: _selectedMood!,
    lightText: _text.isEmpty ? null : _text,
    tags: _selectedTags,
  ),
)
    ↓
setState(() => _isSaving = false)
    ↓
显示 CatBedtimeAnimation（showDialog）
    ↓
动画完成 / 用户点击关闭
    ↓
完整模式: Navigator.of(context).pop()
快速模式: Navigator.of(context).pop() (关闭 BottomSheet)
    ↓
Analytics: ref.read(analyticsServiceProvider).logEvent('light_recorded')
```

**保存按钮状态**：
- `_selectedMood == null` → 按钮 disabled（灰色，不可点击）
- `_isSaving == true` → 按钮显示 `CircularProgressIndicator`
- 其他 → 正常可点击

**CatBedtimeAnimation 弹出方式**：

```dart
showDialog(
  context: context,
  barrierDismissible: true,
  builder: (_) => Dialog(
    backgroundColor: Colors.transparent,
    child: CatBedtimeAnimation(mood: _selectedMood!),
  ),
);

// 3 秒后自动关闭
Future.delayed(const Duration(seconds: 3), () {
  if (mounted && Navigator.of(context).canPop()) {
    Navigator.of(context).pop(); // 关闭 dialog
  }
});
```

---

### 3.3 WeeklyReviewScreen

**文件路径**：`lib/screens/awareness/weekly_review_screen.dart`

**路由**：`AppRouter.weeklyReview = '/weekly-review'`

**类定义**：

```dart
/// 周回顾页面 — 填写三个幸福时刻、感恩、学习、更新烦恼。
class WeeklyReviewScreen extends ConsumerStatefulWidget {
  const WeeklyReviewScreen({super.key});

  @override
  ConsumerState<WeeklyReviewScreen> createState() =>
      _WeeklyReviewScreenState();
}
```

**状态管理**：

```dart
class _WeeklyReviewScreenState extends ConsumerState<WeeklyReviewScreen> {
  // 三个幸福时刻
  String? _moment1Text;
  List<String> _moment1Tags = [];
  String? _moment2Text;
  List<String> _moment2Tags = [];
  String? _moment3Text;
  List<String> _moment3Tags = [];

  // 感恩 + 学习
  String _gratitude = '';
  String _learned = '';

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 加载已有的本周回顾（编辑模式）
    _loadExistingReview();
  }
}
```

**视觉布局**：

```
┌─────────────────────────────────────────────┐
│  AppScaffold                                │
│  appBar: AppBar(title: "周回顾")              │
│                                             │
│  SingleChildScrollView                      │
│  padding: AppSpacing.paddingScreenBody       │
│  ┌─────────────────────────────────────────┐│
│  │                                         ││
│  │ ── Section 1: 三个幸福时刻 ──            ││
│  │                                         ││
│  │ Text: "回忆本周的三个幸福时刻"            ││
│  │   titleMedium                           ││
│  │ Text: "大事小事都算数"                    ││
│  │   bodySmall, onSurfaceVariant           ││
│  │                                         ││
│  │ HappyMomentCard(momentNumber: 1, ...)   ││
│  │ SizedBox(height: md)                    ││
│  │ HappyMomentCard(momentNumber: 2, ...)   ││
│  │ SizedBox(height: md)                    ││
│  │ HappyMomentCard(momentNumber: 3, ...)   ││
│  │                                         ││
│  │ ── Divider ──                           ││
│  │                                         ││
│  │ ── Section 2: 感恩 ──                    ││
│  │                                         ││
│  │ Text: "这周我想感谢..."                   ││
│  │   titleSmall                            ││
│  │ TextField(                              ││
│  │   hintText: "一个人、一件事、或自己"      ││
│  │   minLines: 2, maxLines: 4              ││
│  │ )                                       ││
│  │                                         ││
│  │ ── Divider ──                           ││
│  │                                         ││
│  │ ── Section 3: 学到了什么 ──              ││
│  │                                         ││
│  │ Text: "这周我学到了..."                   ││
│  │   titleSmall                            ││
│  │ TextField(                              ││
│  │   hintText: "一个技能、一个道理、一个视角"  ││
│  │   minLines: 2, maxLines: 4              ││
│  │ )                                       ││
│  │                                         ││
│  │ ── Divider ──                           ││
│  │                                         ││
│  │ ── Section 4: 烦恼更新 ──               ││
│  │                                         ││
│  │ Text: "更新你的烦恼"                      ││
│  │   titleSmall                            ││
│  │ Text: "上周的烦恼，现在怎么样了？"         ││
│  │   bodySmall, onSurfaceVariant           ││
│  │                                         ││
│  │ activeWorriesProvider.when(...)          ││
│  │   data:                                 ││
│  │     empty → "没有进行中的烦恼，太好了！"   ││
│  │     non-empty → WorryItemCard list      ││
│  │                                         ││
│  │ OutlinedButton("+ 新增烦恼")              ││
│  │   onPressed → _addWorryInline()         ││
│  │                                         ││
│  │ ── Divider ──                           ││
│  │                                         ││
│  │ SizedBox(height: xl)                    ││
│  │                                         ││
│  │ FilledButton.icon(                      ││
│  │   icon: Icons.check,                   ││
│  │   label: "保存周回顾",                   ││
│  │   onPressed: _save,                     ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: 100) // safe area      ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

**新增烦恼内联行为**：

点击「+ 新增烦恼」按钮：
1. 在按钮上方插入一个简化的内联表单（`TextField` for description + `TextField` for solution）
2. 用户填写后点击 「添加」→ 调用 `worryRepositoryProvider.create(uid, description)`
3. 内联表单消失，新烦恼出现在 `WorryItemCard` 列表中
4. 或者：导航到 `WorryEditScreen(worryId: null)` 再返回

> **实现建议**：为简化轨道二，使用导航到 `WorryEditScreen` 方案。内联表单可在后续迭代中优化。

**保存流程**：

```
用户点击「保存周回顾」
    ↓
setState(() => _isSaving = true)
    ↓
await ref.read(awarenessRepositoryProvider).saveWeeklyReview(
  WeeklyReview(
    weekStart: _currentWeekStart(), // ISO 周一
    moment1: _moment1Text,
    moment1Tags: _moment1Tags,
    moment2: _moment2Text,
    moment2Tags: _moment2Tags,
    moment3: _moment3Text,
    moment3Tags: _moment3Tags,
    gratitude: _gratitude.isEmpty ? null : _gratitude,
    learning: _learned.isEmpty ? null : _learned,
  ),
)
    ↓
setState(() => _isSaving = false)
    ↓
Analytics: logEvent('weekly_review_completed')
    ↓
显示猫咪模板周总结卡（SnackBar 或 Dialog）
    ↓
Navigator.of(context).pop()
```

**猫咪模板周总结**：

保存成功后显示一个 `Dialog`（非 `SnackBar`，因为内容较多）：

```
┌─────────────────────────────────────┐
│  Dialog                             │
│  ┌─────────────────────────────────┐│
│  │ PixelCatSprite (size: 80)       ││
│  │                                 ││
│  │ Text: 模板周总结文案             ││
│  │   bodyMedium, textAlign: center ││
│  │                                 ││
│  │ FilledButton.tonal("好的！")     ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

模板周总结从 `cat_response_templates.dart` 获取，使用占位符替换：
- `{momentCount}`: 填写了几个幸福时刻（1-3）
- `{topTag}`: 最常出现的标签（如果有）

种子模板示例：「铲屎官这周记录了 {momentCount} 个幸福时刻呢，本猫都看到了 ✨」

---

### 3.4 WorryProcessorScreen

**文件路径**：`lib/screens/awareness/worry_processor_screen.dart`

**路由**：`AppRouter.worryProcessor = '/worry-processor'`

**类定义**：

```dart
/// 烦恼处理器 — 管理所有烦恼的列表页。
class WorryProcessorScreen extends ConsumerWidget {
  const WorryProcessorScreen({super.key});
}
```

**视觉布局**：

```
┌─────────────────────────────────────────────┐
│  AppScaffold                                │
│  appBar: AppBar(title: "烦恼处理器")          │
│                                             │
│  CustomScrollView                           │
│  ┌─────────────────────────────────────────┐│
│  │ SliverAppBar(pinned: false)             ││
│  │                                         ││
│  │ ── 活跃烦恼 ──                          ││
│  │                                         ││
│  │ activeWorriesProvider.when(...)          ││
│  │   loading: SkeletonCard x 2             ││
│  │   empty: AwarenessEmptyState(worries)   ││
│  │   data:                                 ││
│  │     SliverList of WorryItemCard         ││
│  │                                         ││
│  │ ── 已解决的烦恼（折叠） ──               ││
│  │                                         ││
│  │ ExpansionTile("已解决/消失")             ││
│  │   resolvedWorriesProvider.when(...)      ││
│  │     data: WorryItemCard list (readonly)  ││
│  │                                         ││
│  │ SizedBox(height: 100)                   ││
│  └─────────────────────────────────────────┘│
│                                             │
│  FAB: FloatingActionButton(                 │
│    child: Icon(Icons.add),                  │
│    tooltip: "添加烦恼",                      │
│    onPressed: → WorryEditScreen(null),       │
│  )                                          │
└─────────────────────────────────────────────┘
```

**状态依赖**：
- `activeWorriesProvider`：`AsyncValue<List<Worry>>` — 状态为 `ongoing` 的烦恼
- `resolvedWorriesProvider`：`AsyncValue<List<Worry>>` — 状态为 `resolved` 或 `disappeared` 的烦恼

> **Provider 补充**：`resolvedWorriesProvider` 已在轨道一（plan_02）中定义。参考定义方式：

```dart
final resolvedWorriesProvider = StreamProvider<List<Worry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(worryRepositoryProvider).watchResolved(uid);
});
```

**烦恼状态变更行为**：

在 `WorryItemCard` 中点击 `SegmentedButton` 切换状态 → 调用 `worryRepositoryProvider.updateStatus(worryId, newStatus)` → Provider 自动刷新列表，烦恼在活跃/已解决区间移动。

---

### 3.5 WorryEditScreen

**文件路径**：`lib/screens/awareness/worry_edit_screen.dart`

**路由**：`AppRouter.worryEdit = '/worry-edit'`

**Arguments**：`String?` — `worryId`（`null` = 新建，非空 = 编辑）

**类定义**：

```dart
/// 烦恼编辑页 — 新建或编辑一条烦恼。
class WorryEditScreen extends ConsumerStatefulWidget {
  /// 烦恼 ID（null = 新建）。
  final String? worryId;

  const WorryEditScreen({
    super.key,
    this.worryId,
  });

  @override
  ConsumerState<WorryEditScreen> createState() => _WorryEditScreenState();
}
```

**状态管理**：

```dart
class _WorryEditScreenState extends ConsumerState<WorryEditScreen> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _solutionController;
  bool _isSaving = false;

  bool get _isEditMode => widget.worryId != null;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _solutionController = TextEditingController();
    if (_isEditMode) {
      _loadExistingWorry();
    }
  }
}
```

**视觉布局**：

```
┌─────────────────────────────────────────────┐
│  AppScaffold                                │
│  appBar: AppBar(                            │
│    title: _isEditMode ? "编辑烦恼" : "新增烦恼"│
│  )                                          │
│                                             │
│  Padding(AppSpacing.paddingScreenBody)       │
│  ┌─────────────────────────────────────────┐│
│  │                                         ││
│  │ Text: "什么事让你烦恼？"                  ││
│  │   titleSmall                            ││
│  │                                         ││
│  │ SizedBox(height: sm)                    ││
│  │                                         ││
│  │ TextField(                              ││
│  │   controller: _descriptionController,   ││
│  │   hintText: "写下来，把它从脑袋里搬出来"  ││
│  │   minLines: 3, maxLines: 6              ││
│  │   maxLength: 500                        ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: lg)                    ││
│  │                                         ││
│  │ Text: "你能做些什么？（可选）"             ││
│  │   titleSmall                            ││
│  │                                         ││
│  │ SizedBox(height: sm)                    ││
│  │                                         ││
│  │ TextField(                              ││
│  │   controller: _solutionController,      ││
│  │   hintText: "哪怕是一小步也好"            ││
│  │   minLines: 2, maxLines: 4              ││
│  │   maxLength: 300                        ││
│  │ )                                       ││
│  │                                         ││
│  │ Spacer()                                ││
│  │                                         ││
│  │ FilledButton.icon(                      ││
│  │   icon: Icons.check,                   ││
│  │   label: _isEditMode ? "更新" : "添加",  ││
│  │   onPressed: _description.isNotEmpty    ││
│  │              ? _save : null,             ││
│  │ )                                       ││
│  │                                         ││
│  │ SizedBox(height: base) // safe area     ││
│  └─────────────────────────────────────────┘│
└─────────────────────────────────────────────┘
```

**保存流程**：

```
新建模式:
  await ref.read(worryRepositoryProvider).create(uid, description)

编辑模式:
  await ref.read(worryRepositoryProvider).update(uid, worry)

→ Navigator.of(context).pop()
→ Analytics: logEvent('worry_added' / 'worry_updated')
```

**表单验证**：`description` 为必填。保存按钮在 `description` 为空时 `disabled`。

---

## 4. 路由注册

在 `lib/core/router/app_router.dart` 中新增以下路由常量和 `case` 分支：

### 4.1 新增路由常量

```dart
// --- Awareness (Track 2) ---
static const String dailyLight = '/daily-light';
static const String weeklyReview = '/weekly-review';
static const String worryProcessor = '/worry-processor';
static const String worryEdit = '/worry-edit';

// --- Awareness (Track 4 placeholders, 注册但不实现) ---
// static const String awarenessHistory = '/awareness-history';
// static const String dailyDetail = '/daily-detail';
// static const String awarenessStats = '/awareness-stats';
```

### 4.2 新增 case 分支

```dart
case dailyLight:
  final args = settings.arguments as Map<String, dynamic>? ?? {};
  final quickMode = args['quickMode'] as bool? ?? false;
  return MaterialPageRoute(
    builder: (_) => DailyLightScreen(quickMode: quickMode),
  );

case weeklyReview:
  return MaterialPageRoute(
    builder: (_) => const WeeklyReviewScreen(),
  );

case worryProcessor:
  return MaterialPageRoute(
    builder: (_) => const WorryProcessorScreen(),
  );

case worryEdit:
  final worryId = settings.arguments as String?;
  return MaterialPageRoute(
    builder: (_) => WorryEditScreen(worryId: worryId),
  );
```

### 4.3 新增 import

```dart
import 'package:hachimi_app/screens/awareness/daily_light_screen.dart';
import 'package:hachimi_app/screens/awareness/weekly_review_screen.dart';
import 'package:hachimi_app/screens/awareness/worry_processor_screen.dart';
import 'package:hachimi_app/screens/awareness/worry_edit_screen.dart';
```

---

## 5. L10n Key 清单

### 5.1 Tab 标签与页面标题

| Key | EN | ZH-CN |
|-----|-----|-------|
| `awarenessTitle` | Awareness | 觉知 |
| `awarenessTabToday` | Today | 今天 |
| `awarenessTabThisWeek` | This Week | 本周 |
| `awarenessTabReview` | Review | 回顾 |
| `awarenessReviewComingSoon` | Coming soon | 即将推出 |

### 5.2 心情标签

| Key | EN | ZH-CN |
|-----|-----|-------|
| `moodVeryHappy` | Very Happy | 很开心 |
| `moodHappy` | Happy | 开心 |
| `moodCalm` | Calm | 平静 |
| `moodDown` | Down | 低落 |
| `moodVeryDown` | Very Down | 很低落 |

### 5.3 每日一点光

| Key | EN | ZH-CN |
|-----|-----|-------|
| `dailyLightTitle` | Daily Light | 今日一点光 |
| `dailyLightMoodPrompt` | How are you feeling today? | 你今天心情如何？ |
| `awarenessLightPlaceholder` | What made you smile today? | 今天有什么让你微笑的事？ |
| `dailyLightTagsLabel` | Tags (optional) | 标签（可选） |
| `dailyLightSave` | Save | 保存 |
| `dailyLightSaving` | Saving... | 保存中... |
| `dailyLightQuickPrompt` | What made you smile today? | 今天有什么让你微笑的事？ |
| `dailyLightQuickSkip` | Skip | 跳过 |
| `dailyLightQuickRecord` | Record | 记录 |
| `dailyLightEditButton` | Edit | 编辑 |

### 5.4 猫咪反应文案（种子）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `catReactVeryHappy` | You're so happy today, I'm happy too! | 铲屎官今天好开心，本猫也开心！ |
| `catReactHappy` | Another ray of light recorded! | 记录了今天的光，真棒 ✨ |
| `catReactCalm` | A calm day is a good day. | 平静的一天也很好呢 🍃 |
| `catReactDown` | On tough days, I'm right here with you. | 不开心的日子，本猫陪着你 💛 |
| `catReactVeryDown` | It's okay, I'm not going anywhere. | 没事的，本猫哪都不去 🫂 |

### 5.5 周回顾

| Key | EN | ZH-CN |
|-----|-----|-------|
| `weeklyReviewTitle` | Weekly Review | 周回顾 |
| `weeklyReviewMomentsTitle` | Three Happy Moments | 回忆本周的三个幸福时刻 |
| `weeklyReviewMomentsSubtitle` | Big or small, they all count | 大事小事都算数 |
| `weeklyReviewMomentHint` | What made you happy this week? | 这周有什么让你开心的？ |
| `weeklyReviewMomentNumber` | Happy Moment #{number} | 幸福时刻 #{number} |
| `weeklyReviewGratitudeTitle` | I'm grateful for... | 这周我想感谢... |
| `weeklyReviewGratitudeHint` | A person, an event, or yourself | 一个人、一件事、或自己 |
| `weeklyReviewLearnedTitle` | This week I learned... | 这周我学到了... |
| `weeklyReviewLearnedHint` | A skill, a lesson, or a new perspective | 一个技能、一个道理、一个视角 |
| `weeklyReviewWorryUpdateTitle` | Update your worries | 更新你的烦恼 |
| `weeklyReviewWorryUpdateSubtitle` | How are last week's worries doing? | 上周的烦恼，现在怎么样了？ |
| `weeklyReviewNoWorries` | No active worries. That's great! | 没有进行中的烦恼，太好了！ |
| `weeklyReviewAddWorry` | + New worry | + 新增烦恼 |
| `weeklyReviewSave` | Save weekly review | 保存周回顾 |
| `weeklyReviewSaved` | Weekly review saved! | 周回顾已保存！ |

### 5.6 猫咪周总结模板（种子）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `catWeeklySummary` | You recorded {momentCount} happy moments this week. I saw them all! | 铲屎官这周记录了 {momentCount} 个幸福时刻呢，本猫都看到了 ✨ |
| `catWeeklySummaryOk` | Got it! | 好的！ |

### 5.7 烦恼处理器

| Key | EN | ZH-CN |
|-----|-----|-------|
| `worryProcessorTitle` | Worry Processor | 烦恼处理器 |
| `worryEditTitleNew` | New Worry | 新增烦恼 |
| `worryEditTitleEdit` | Edit Worry | 编辑烦恼 |
| `worryDescriptionPrompt` | What's bothering you? | 什么事让你烦恼？ |
| `worryDescriptionHint` | Write it down, get it out of your head | 写下来，把它从脑袋里搬出来 |
| `worrySolutionPrompt` | What could you do? (optional) | 你能做些什么？（可选） |
| `worrySolutionHint` | Even a tiny step counts | 哪怕是一小步也好 |
| `worrySave` | Add | 添加 |
| `worryUpdate` | Update | 更新 |
| `worryStatusOngoing` | Ongoing | 还在 |
| `worryStatusResolved` | Resolved | 搞定了 |
| `worryStatusDisappeared` | Gone | 消失了 |
| `worryResolvedSection` | Resolved / Gone | 已解决/消失 |
| `worryAddTooltip` | Add worry | 添加烦恼 |
| `worryManageAll` | Manage all worries | 管理全部烦恼 |

### 5.8 空状态

| Key | EN | ZH-CN |
|-----|-----|-------|
| `awarenessEmptyLightTitle` | No light recorded yet | 今天还没记录一点光 |
| `awarenessEmptyLightSubtitle` | You can come anytime | 什么时候都可以来 ✨ |
| `awarenessEmptyLightAction` | Record now | 去记录 |
| `awarenessEmptyReviewTitle` | No weekly review yet | 本周还没写周回顾 |
| `awarenessEmptyReviewSubtitle` | Take a few minutes to reflect | 花几分钟回顾一下这周吧 |
| `awarenessEmptyReviewAction` | Start review | 开始回顾 |
| `awarenessEmptyHistoryTitle` | No records yet | 还没有记录 |
| `awarenessEmptyHistorySubtitle` | Your journey starts with the first light | 从第一束光开始你的旅程 |
| `awarenessEmptyWorriesTitle` | No worries right now | 现在没有烦恼 |
| `awarenessEmptyWorriesSubtitle` | That's wonderful! | 真好！ |

### 5.9 通用

| Key | EN | ZH-CN |
|-----|-----|-------|
| `awarenessHabitSectionTitle` | Today's habits | 今日习惯 |
| `awarenessNoHabits` | No habits yet. Adopt a cat to start! | 还没有习惯，去领养一只猫吧 |
| `tagCustom` | + Custom | +自定义 |

**合计**：约 55 个新 L10n key。

---

## 6. 文件操作清单

### 6.1 新建文件

| 文件路径 | 说明 |
|---------|------|
| `lib/widgets/awareness/mood_selector.dart` | 心情选择器 Widget |
| `lib/widgets/awareness/light_input_card.dart` | 一点光文字输入卡片 |
| `lib/widgets/awareness/tag_selector.dart` | 标签选择器 Widget |
| `lib/widgets/awareness/happy_moment_card.dart` | 幸福时刻卡片 |
| `lib/widgets/awareness/worry_item_card.dart` | 烦恼条目卡片 |
| `lib/widgets/awareness/cat_bedtime_animation.dart` | 猫咪睡前反应动画 |
| `lib/widgets/awareness/awareness_empty_state.dart` | 觉知模块空状态 |
| `lib/screens/awareness/awareness_screen.dart` | 觉知主屏幕（3 子 Tab） |
| `lib/screens/awareness/daily_light_screen.dart` | 每日一点光记录页 |
| `lib/screens/awareness/weekly_review_screen.dart` | 周回顾页面 |
| `lib/screens/awareness/worry_processor_screen.dart` | 烦恼处理器列表页 |
| `lib/screens/awareness/worry_edit_screen.dart` | 烦恼编辑页 |
| `lib/core/constants/awareness_constants.dart` | 觉知模块常量（预设标签等） |

### 6.2 修改文件

| 文件路径 | 改动内容 |
|---------|---------|
| `lib/core/router/app_router.dart` | 新增 4 个路由常量 + 4 个 case 分支 + 4 个 import |
| `lib/l10n/app_en.arb` | 新增约 55 个英文 L10n key |
| `lib/l10n/app_zh.arb` | 新增约 55 个中文 L10n key |
| `lib/providers/awareness_providers.dart` | 新增 `resolvedWorriesProvider`（如轨道一未提供） |
| `lib/core/constants/cat_response_templates.dart` | 新建或追加 5 条种子模板（如轨道五未先创建） |

### 6.3 SSOT 文档更新（编码前必须先完成）

| 文件路径 | 改动内容 |
|---------|---------|
| `docs/architecture/folder-structure.md` | 新增 `screens/awareness/`（5 文件）+ `widgets/awareness/`（7 文件） |
| `docs/zh-CN/architecture/folder-structure.md` | 同步中文版 |

---

## 7. 完成标志

### 7.1 功能验证

- [ ] `DailyLightScreen` 完整模式：选心情 → 写文字 → 选标签 → 保存 → CatBedtimeAnimation 弹出 → 自动关闭 → 返回
- [ ] `DailyLightScreen` 快速模式：BottomSheet 弹出 → 选心情 → 写文字 → 保存 → 动画 → 关闭
- [ ] `WeeklyReviewScreen`：填写 3 个幸福时刻 + 感恩 + 学习 + 烦恼更新 → 保存 → 猫咪周总结 Dialog
- [ ] `WorryProcessorScreen`：查看活跃/已解决烦恼列表 → FAB 添加 → 状态切换
- [ ] `WorryEditScreen`：新建烦恼 → 保存；编辑烦恼 → 更新
- [ ] `AwarenessScreen` 三个子 Tab 切换正常
- [ ] 今天 Tab：未记录 → 空状态 + 快捷入口；已记录 → 状态卡 + 编辑入口
- [ ] 本周 Tab：周回顾状态 + 烦恼列表 + 添加入口
- [ ] 回顾 Tab：显示占位文案

### 7.2 主题验证

- [ ] Material 3 主题下所有新屏幕正确渲染
- [ ] Retro Pixel 主题下所有新屏幕正确渲染（像素边框、像素字体、背景图案）
- [ ] 两种主题切换后无崩溃

### 7.3 代码质量

- [ ] `dart analyze lib/` 零 warning / error
- [ ] `dart format lib/ test/ --set-exit-if-changed` 零格式问题
- [ ] 所有新文件 ≤ 800 行
- [ ] 所有新函数 ≤ 30 行
- [ ] 所有 Widget 使用 `const` 构造函数
- [ ] 无硬编码颜色值

### 7.4 L10n 验证

- [ ] `app_en.arb` 和 `app_zh.arb` 各新增约 55 个 key
- [ ] 所有新增 key 在 EN 和 ZH-CN 下均有值
- [ ] `flutter gen-l10n` 无报错
