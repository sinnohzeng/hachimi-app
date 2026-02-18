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

**不得硬编码颜色**。始终通过 `Theme.of(context).colorScheme` 访问：

| 角色 | Token | 典型用途 |
|------|-------|---------|
| `primary` | 主强调色 | 按钮、活跃图标、进度环 |
| `onPrimary` | 主色上的文字 | 填充按钮的标签文字 |
| `primaryContainer` | 柔和主色 | 选中的片段背景、猫咪 XP 进度条填充 |
| `secondary` | 辅助强调色 | 次要按钮、连续记录徽章 |
| `tertiary` | 第三强调色 | 稀有猫咪指示器、庆祝光效 |
| `surface` | 背景表面 | 卡片、底部弹窗、对话框 |
| `surfaceContainerHighest` | 高度提升的表面 | 热力图空白格、禁用状态 |
| `onSurface` | 表面上的文字 | 正文文字、图标 |
| `outline` | 边框 | 文本框边框、分割线 |
| `error` | 错误状态 | 无效输入、错误 SnackBar |

### 猫咪品种着色

猫咪精灵使用 `ColorFiltered` 配合品种的 `baseColor` 进行着色，混合模式为 `BlendMode.srcATop`。此功能在 `lib/widgets/cat_sprite.dart` 中处理 —— 不得在其他地方复用这一模式。

品种颜色定义于 `lib/core/constants/cat_constants.dart`，完整颜色表详见 [猫咪系统](../architecture/cat-system.md)。

---

## 排版

**字体族：** Google Fonts —— Noto Sans（通过 `google_fonts` 包加载，确保跨平台一致性）。

始终通过 `Theme.of(context).textTheme` 访问文字样式，不得使用含原始 `fontSize` 或 `fontWeight` 的硬编码 `TextStyle`。

| Token | 使用场景 |
|-------|---------|
| `displayLarge` | 计时器倒计时显示（大字号数字） |
| `displayMedium` | 专注完成界面的 XP 数字 |
| `headlineLarge` | 界面主标题 |
| `headlineMedium` | 区块标题 |
| `titleLarge` | 卡片标题、猫咪详情页猫咪名字 |
| `titleMedium` | 列表行中的习惯名称 |
| `bodyLarge` | 主要正文内容 |
| `bodyMedium` | 次要正文、对话气泡 |
| `labelLarge` | 按钮标签 |
| `labelSmall` | 稀有度徽章、性格片段 |

---

## 组件

| M3 组件 | 在 Hachimi 中的用途 |
|---------|------------------|
| `NavigationBar` | 底部 4 标签导航（今日、猫咪房间、统计、我的） |
| `Card` | 习惯卡片、统计卡片、猫咪详情各板块 |
| `FilledButton` | 主要 CTA（行动召唤）：「开始专注」「领养」「登录」 |
| `FilledButton.tonal` | 次要 CTA：计时器控制、模式切换激活状态 |
| `OutlinedButton` | 取消、次要导航 |
| `TextButton` | 第三级操作：「切换到注册」「查看详情」 |
| `FilterChip` | 时长选择片段（15/25/40/60 分钟） |
| `SegmentedButton` | 计时器模式切换（倒计时 / 正计时） |
| `LinearProgressIndicator` | XP 进度条、习惯每日进度 |
| `TextField` / `TextFormField` | 习惯名称、猫咪名称、登录表单字段 |
| `SnackBar` | 成功/错误反馈（会话已保存、错误信息） |
| `AlertDialog` | 确认破坏性操作（删除习惯、放弃专注） |
| `BottomSheet` | 猫咪房间快速操作 |
| `ModalBottomSheet` | 猫咪相册完整视图 |

---

## 间距

使用 8dp 的倍数（M3 基线网格）。内联 `EdgeInsets` 常量可直接使用，不需要提取为共享常量。

| 数值 | 用途 |
|------|------|
| `4` | 紧凑 / 微间距（图标与标签之间） |
| `8` | 紧凑间距（片段之间、行内元素） |
| `12` | 半区块间距 |
| `16` | 标准内边距（卡片内容、界面边缘） |
| `24` | 区块间隔 |
| `32` | 大间隔（界面区块之间） |
| `48` | 主区域（猫咪精灵外边距） |

---

## 形状

M3 使用圆角形状系统，使用主题默认值 —— 不得硬编码 `BorderRadius`。

| 等级 | 近似圆角半径 | 用途 |
|------|-----------|------|
| 极小 | 4dp | 文字片段 |
| 小 | 8dp | 按钮、输入框 |
| 中 | 12dp | 卡片 |
| 大 | 16dp | 底部弹窗、对话框 |
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
5. **动画**：遵循 Material 运动规范 —— 使用 `Curves.easeInOut`、`Curves.easeOutCubic` 等曲线
6. **猫咪着色**：仅在 `CatSprite` 组件中使用 —— 不在其他地方使用 `ColorFiltered` 进行任意着色
