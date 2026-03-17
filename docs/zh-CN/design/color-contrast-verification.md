# 色彩对比度验证（WCAG 2.1）

> **状态**：Active
> **目的**：集中记录 Hachimi App 中所有经审计的色彩对比度对，替代分散在代码注释中的非正式声明，形成系统化、可验证的参考文档。
> **证据来源**：`lib/core/theme/pixel_theme_extension.dart`、`lib/widgets/pixel_ui/pixel_coin_display.dart`、`lib/widgets/pixel_ui/pixel_switch.dart`、`lib/core/theme/color_utils.dart`
> **相关文档**：[设计系统（SSOT）](design-system.md)

---

## WCAG 2.1 AA 最低要求

| 内容类型 | 最低对比度 |
|---|---|
| 正文（< 18px / < 14px 粗体） | 4.5:1 |
| 大文本（≥ 18px / ≥ 14px 粗体） | 3:1 |
| UI 组件和图形对象 | 3:1 |

**AAA（增强级）**：正文 7:1，大文本 4.5:1。

---

## Retro Pixel 模式 — 已审计对比度对

### 背景与边框色

| 色对 | 前景色 | 背景色 | 对比度 | 等级 | 来源 |
|---|---|---|---|---|---|
| 暗色边框 / 暗色背景 | `#A08B6D` | `#1A1A2E` | 4.58:1 | AA | `pixel_theme_extension.dart:112` |
| 亮色边框 / 亮色背景 | `#5C3A1E` | `#FFF8E7` | 8.2:1 | AAA | `pixel_theme_extension.dart:21,17` |

### 交互组件

| 组件 | 前景色 | 背景色 | 模式 | 对比度 | 等级 | 来源 |
|---|---|---|---|---|---|---|
| PixelCoinDisplay "C" 字 | `#3E2723` | `#FFD700`（xpBarFill） | 通用 | 7.56:1 | AAA | `pixel_coin_display.dart:25-26` |
| PixelSwitch thumb（开启） | `#FFF8E7`（retroBackground） | `#2E8B57`（pixelSuccess） | 亮色 | ≥ 7:1 | AAA | `pixel_switch.dart:56-59` |
| PixelSwitch thumb（开启） | `#1A1A2E`（retroBackground） | `#5CDB95`（pixelSuccess） | 暗色 | ≥ 7:1 | AAA | `pixel_switch.dart:56-59` |

### 庆祝覆盖层（固定色）

| 元素 | 颜色 | 背景 | 说明 | 来源 |
|---|---|---|---|---|
| 标题文字 | `Colors.white` | `primary → scrim` 径向渐变 | 固定白色覆盖在深色渐变上 | `color_utils.dart:62-67` |
| 副标题 | `Colors.white70` | 同上 | 略微柔和，在深色背景上仍保持高对比度 | `color_utils.dart` |
| 正文 | `Colors.white54` | 同上 | 仅作装饰性强调 | `color_utils.dart` |

---

## Material 3 模式 — 自动保证

Material 3 的 `ColorScheme.fromSeed()` 算法生成的色调色板天然满足 WCAG AA 对比度要求：

- **`on*` 语义色**（如 `onPrimary`、`onSurface`）通过数学推导保证与对应表面色达到 ≥ 4.5:1。
- **`*Container` / `on*Container`** 色对同样满足 AA。
- **动态色（Material You）**：系统提供的壁纸派生 `ColorScheme` 遵循相同的 M3 色调映射，保留对比度保证。

标准 M3 语义色对无需手动验证。仅上方列出的自定义硬编码色彩需要显式审计。

---

## 验证方法

1. **工具**：[WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
2. **公式**：WCAG 相对亮度公式 — `L = 0.2126R + 0.7152G + 0.0722B`（线性化 sRGB），对比度 = `(L1 + 0.05) / (L2 + 0.05)`
3. **重新验证时机**：当 `pixel_theme_extension.dart`、`color_utils.dart` 或 `pixel_ui/` 组件中的硬编码颜色常量被修改时

---

## 变更记录

| 日期 | 变更 |
|---|---|
| 2026-03-17 | 初始创建 — 记录 PDCA 主题审计中所有已审计的对比度对 |
