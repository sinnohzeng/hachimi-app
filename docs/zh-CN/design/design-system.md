# 设计系统 — Material Design 3 SSOT

> **SSOT**：`lib/core/theme/app_theme.dart` 中定义的主题是所有 UI 样式的单一权威来源。界面和组件代码中不得出现硬编码的颜色、字体或间距值。

---

## 色彩系统

### 种子色（Seed Color）

```dart
// lib/core/theme/app_theme.dart
static const Color seedColor = Color(0xFF4285F4); // Google 蓝
```

**生成方式：** `ColorScheme.fromSeed(seedColor: seedColor)` —— Material 3 会从种子色自动推导完整的色调调色板，亮色和深色主题均从同一种子色生成。

### 动态取色（Material You）

在 Android 12+ 设备上，应用可通过 `dynamic_color` 包使用系统壁纸推导的 `ColorScheme`。此功能由 `ThemeSettings` 中的 `useDynamicColor` 设置控制（默认：`true`）。

```dart
// lib/app.dart
DynamicColorBuilder(
  builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    final useDynamic = themeSettings.useDynamicColor && lightDynamic != null;
    // 可用时使用 lightDynamic / darkDynamic，否则回退到种子色
  },
)
```

动态取色激活时，种子色设置将被忽略，直接使用系统提供的 `ColorScheme`。用户可通过 **设置 > 外观 > Material You** 切换。

### 色彩角色

**不得硬编码颜色**。始终通过 `Theme.of(context).colorScheme` 访问：

| 角色 | Token | 典型用途 |
|------|-------|---------|
| `primary` | 主强调色 | 按钮、活跃图标、进度环 |
| `onPrimary` | 主色上的文字 | 填充按钮标签、主色渐变屏幕（登录、引导页）上的文字 |
| `primaryContainer` | 柔和主色 | 选中的片段背景、猫咪 XP 进度条、今日概览卡片 |
| `onPrimaryContainer` | 主色容器上的文字 | 片段/容器内的文字 |
| `secondary` | 辅助强调色 | 次要按钮、连续记录徽章 |
| `tertiary` | 第三强调色 | 金币余额图标、稀有猫咪指示器、庆祝光效 |
| `surface` | 背景表面 | 卡片、底部弹窗、对话框 |
| `surfaceContainerHighest` | 高度提升的表面 | 热力图空白格、禁用状态、骨架屏基色 |
| `surfaceContainerLow` | 较低的表面 | 骨架屏微光高亮色 |
| `onSurface` | 表面上的文字 | 正文文字、图标 |
| `onSurfaceVariant` | 表面上的弱化文字 | 次要标签、副标题 |
| `outline` | 边框 | 文本框边框、分割线 |
| `error` | 错误状态 | 无效输入、错误 SnackBar、归档操作 |

### 猫咪品种着色

猫咪精灵使用 `ColorFiltered` 配合品种的 `baseColor` 进行着色，混合模式为 `BlendMode.srcATop`。此功能在 `lib/widgets/pixel_cat_sprite.dart` 中处理 —— 不得在其他地方复用这一模式。

品种颜色定义于 `lib/core/constants/cat_constants.dart`，完整颜色表详见 [猫咪系统](../architecture/cat-system.md)。

---

## 排版

**字体族：** Google Fonts —— Roboto（通过 `GoogleFonts.robotoTextTheme()` 加载，确保跨平台一致性）。

始终通过 `Theme.of(context).textTheme` 访问文字样式，不得使用含原始 `fontSize` 或 `fontWeight` 的硬编码 `TextStyle`。

| Token | 使用场景 |
|-------|---------|
| `displaySmall` | 登录页应用名称 |
| `headlineLarge` | 引导页标题 |
| `headlineMedium` | 邮箱认证页标题 |
| `titleLarge` | 统计卡片数值、猫咪详情页名字 |
| `titleMedium` | 区块标题、习惯名称、精选猫咪名字 |
| `titleSmall` | 网格卡片中的猫咪名字、习惯行标题 |
| `bodyLarge` | 主要正文内容、引导页正文 |
| `bodyMedium` | 次要正文、登录链接文字 |
| `bodySmall` | 副标题、习惯目标文字、时间标签 |
| `labelLarge` | 金币余额、按钮标签 |
| `labelSmall` | 阶段标签、稀有度徽章、进度环文字 |

---

## 组件

| M3 组件 | 在 Hachimi 中的用途 |
|---------|------------------|
| `NavigationBar` | 底部 4 标签导航（今日、猫舍、统计、我的） |
| `Card` | 习惯卡片、统计卡片、猫咪详情板块、精选猫咪 |
| `FilledButton` | 主要 CTA：「开始专注」「领养」「登录」「重命名」 |
| `FilledButton.tonal` | 错误重试按钮（`ErrorState`）、空状态 CTA |
| `OutlinedButton` | 取消、次要导航 |
| `TextButton` | 第三级操作：「跳过」、对话框中的「取消」 |
| `ChoiceChip` | 专注设置中的时长选择片段（15/25/40/60 分钟） |
| `SegmentedButton` | 专注设置中的计时器模式切换（倒计时 / 正计时） |
| `LinearProgressIndicator` | XP 进度条、习惯每日进度、总体统计进度 |
| `TextField` / `TextFormField` | 习惯名称、猫咪名称、登录/注册表单字段 |
| `IconButton` | 工具栏操作（背包、商店、关闭、设置） |
| `SnackBar` | 成功/错误反馈（会话已保存、任务完成） |
| `AlertDialog` | 确认破坏性操作（删除任务、归档猫咪、重命名） |
| `ModalBottomSheet` | 猫舍快速操作（重命名、编辑任务、归档） |
| `SwitchListTile` | 设置页开关（Material You、深色模式、通知） |
| `Chip` | 每任务统计中的连续记录徽章 |

---

## 间距

### 常量（`lib/core/theme/app_spacing.dart`）

间距集中在 `AppSpacing` 中管理，确保一致性。使用这些常量代替内联数字字面量。

| 常量 | 数值 | 用途 |
|------|------|------|
| `AppSpacing.xs` | `4` | 紧凑 / 微间距（图标与标签之间） |
| `AppSpacing.sm` | `8` | 紧凑间距（片段之间、行内元素） |
| `AppSpacing.md` | `12` | 半区块间距、网格间距 |
| `AppSpacing.base` | `16` | 标准内边距（卡片内容、界面边缘） |
| `AppSpacing.lg` | `24` | 区块间隔 |
| `AppSpacing.xl` | `32` | 大间隔（界面区块之间） |
| `AppSpacing.xxl` | `48` | 主区域（猫咪精灵外边距） |

`AppSpacing` 还提供预构建的 `EdgeInsets` 辅助值：`paddingBase`、`paddingHBase`、`paddingCard` 等。

---

## 动效

### 时长 Token（`lib/core/theme/app_motion.dart`）

| 常量 | 数值 | 用途 |
|------|------|------|
| `AppMotion.durationShort1` | 50ms | 微交互（图标切换） |
| `AppMotion.durationShort2` | 100ms | 小状态变化 |
| `AppMotion.durationShort3` | 150ms | 片段/复选框切换 |
| `AppMotion.durationShort4` | 200ms | 组件展开/折叠 |
| `AppMotion.durationMedium1` | 250ms | 卡片揭示 |
| `AppMotion.durationMedium2` | 300ms | 页面转场、标签切换 |
| `AppMotion.durationMedium4` | 400ms | 交错入场延迟 |
| `AppMotion.durationLong2` | 500ms | 庆祝动画 |

### 缓动 Token

| 常量 | 曲线 | 用途 |
|------|------|------|
| `AppMotion.emphasized` | `easeInOutCubicEmphasized` | 大多数转场的默认曲线 |
| `AppMotion.standard` | `easeInOut` | 标准动效 |
| `AppMotion.decelerate` | `decelerateEasing` | 入场动效 |
| `AppMotion.accelerate` | `accelerateEasing` | 退场动效 |
| `AppMotion.linear` | `linear` | 进度指示器、微光效果 |

### 动效模式

| 模式 | 实现 | 位置 |
|------|------|------|
| **FadeThrough** | `HomeScreen` 中的标签切换 | `lib/screens/home/home_screen.dart` |
| **Hero** | 猫咪精灵共享元素（猫舍 → 详情、精选 → 详情） | `TappableCatSprite` 包裹在 `Hero(tag: 'cat-${cat.id}')` 中 |
| **交错入场** | 专注完成庆祝（emoji → 内容 → 统计） | `lib/screens/timer/focus_complete_screen.dart` |
| **Zoom** | 页面间导航（Android 默认通过 `ZoomPageTransitionsBuilder`） | `lib/core/theme/app_theme.dart` |

---

## 加载、空状态与错误状态

所有异步数据加载遵循一致的三态模式，使用可复用组件。

### 骨架屏加载器（`lib/widgets/skeleton_loader.dart`）

使用与待加载内容形状匹配的微光骨架屏替代 `CircularProgressIndicator`：

| 组件 | 用途 |
|------|------|
| `SkeletonLoader` | 通用微光占位块（可配置宽度/高度/圆角） |
| `SkeletonCard` | 模拟 HabitRow 形状（圆形头像 + 2 行文字 + 操作） |
| `SkeletonGrid` | 模拟 2 列猫咪卡片网格（默认 4 项） |

### 空状态（`lib/widgets/empty_state.dart`）

居中图标 + 标题 + 可选副标题 + 可选 CTA 按钮。在数据列表为空时使用。

### 错误状态（`lib/widgets/error_state.dart`）

居中错误图标 + 消息 + 可选重试按钮。在数据加载失败时使用。

| 界面 | 加载中 | 空状态 | 错误 |
|------|--------|--------|------|
| 今日（习惯） | `SkeletonCard` × 3 | `EmptyState` + add_task 图标 | `ErrorState` + 重试 |
| 猫舍 | `SkeletonGrid` | `EmptyState` + home 图标 | `ErrorState` + 重试 |
| 统计（任务） | `SkeletonCard` × 3 | `EmptyState` + bar_chart 图标 | `ErrorState` + 重试 |

---

## 无障碍

所有自定义组件均包含 `Semantics` 标签，支持 TalkBack / VoiceOver。

| 组件 | 语义标签 |
|------|---------|
| `PixelCatSprite` | `'${peltColor} ${peltType} cat'`（image） |
| `ProgressRing` | `'${progress}% progress'`（value） |
| `StreakIndicator` | `'$streak day streak'` |
| `TappableCatSprite` | `'${cat.name}, tap to interact'`（button）或 `'${cat.name} cat'`（image） |
| `EmojiPicker` 每项 | `emoji`（button、selected 状态） |
| `OfflineBanner` | `'Offline mode'`（liveRegion） |
| `StreakHeatmap` 每格 | `'$month/$day, $minutes minutes'` |
| `CheckInBanner` | `'Daily check-in'` |
| 计时器显示 | `'Timer: $displayTime'`（liveRegion） |

---

## 形状

M3 使用圆角形状系统，使用主题默认值 —— 不得硬编码 `BorderRadius`。

| 等级 | 近似圆角半径 | 用途 |
|------|-----------|------|
| 极小 | 4dp | 文字片段、进度条圆角 |
| 小 | 8dp | 按钮、输入框 |
| 中 | 12dp | 卡片 |
| 大 | 16dp | 底部弹窗、对话框、认证按钮 |
| 极大 | 28dp | FAB（悬浮操作按钮） |
| 圆形 | 50% | 圆形按钮、头像 |

通过 `Theme.of(context).shape` 访问容器形状，或直接使用组件默认值。

---

## 高度与色调表面

M3 使用 **色调高度**（表面叠加主色）代替投影。高度越高，表面色越向 `primary` 靠近。

| 等级 | 用途 |
|------|------|
| Level 0 | 背景 |
| Level 1 | 卡片（默认） |
| Level 2 | 提升卡片、导航栏 |
| Level 3 | 对话框、FAB |

除非有意覆盖组件默认值，不要在组件上显式设置 `elevation`。

---

## 规则

1. **颜色**：使用 `Theme.of(context).colorScheme.primary` —— 不使用 `Colors.blue` 或内联 `Color(0xFF...)`
2. **文字样式**：使用 `Theme.of(context).textTheme.titleLarge` —— 不使用 `TextStyle(fontSize: 22, fontWeight: FontWeight.bold)`
3. **形状**：依赖组件默认值或 `Theme.of(context).shape` —— 不硬编码 `BorderRadius.circular(8)`
4. **图标**：始终使用 Material 图标集中的 `Icons.*` —— 不导入图片图标用于 UI 装饰
5. **动画**：使用 `AppMotion` 时长和缓动 Token —— 不直接硬编码 `Duration(milliseconds: 300)` 或 `Curves.easeInOut`
6. **猫咪着色**：仅在 `PixelCatSprite` 组件中使用 —— 不在其他地方使用 `ColorFiltered` 进行任意着色
7. **间距**：优先使用 `AppSpacing.*` 常量 —— 避免魔法数字
8. **加载状态**：使用 `SkeletonLoader` / `SkeletonCard` / `SkeletonGrid` —— 不在内容加载时使用 `CircularProgressIndicator`
9. **无障碍**：所有自定义绘制 / 手势组件必须包含 `Semantics` 标签
