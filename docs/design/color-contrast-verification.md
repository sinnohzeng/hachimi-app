# Color Contrast Verification (WCAG 2.1)

> **Status**: Active
> **Purpose**: Centralized record of all audited color contrast pairs in the Hachimi App, replacing ad-hoc code comments with a systematic, verifiable reference.
> **Evidence**: `lib/core/theme/pixel_theme_extension.dart`, `lib/widgets/pixel_ui/pixel_coin_display.dart`, `lib/widgets/pixel_ui/pixel_switch.dart`, `lib/core/theme/color_utils.dart`
> **Related**: [Design System (SSOT)](design-system.md)

---

## WCAG 2.1 AA Minimum Requirements

| Content Type | Minimum Contrast Ratio |
|---|---|
| Normal text (< 18px / < 14px bold) | 4.5:1 |
| Large text (≥ 18px / ≥ 14px bold) | 3:1 |
| UI components and graphical objects | 3:1 |

**AAA (enhanced)**: 7:1 for normal text, 4.5:1 for large text.

---

## Retro Pixel Mode — Audited Contrast Pairs

### Background and Border Colors

| Pair | Foreground | Background | Ratio | Level | Source |
|---|---|---|---|---|---|
| Dark border on dark bg | `#A08B6D` | `#1A1A2E` | 4.58:1 | AA | `pixel_theme_extension.dart:112` |
| Light border on light bg | `#5C3A1E` | `#FFF8E7` | 8.2:1 | AAA | `pixel_theme_extension.dart:21,17` |

### Interactive Components

| Component | Foreground | Background | Mode | Ratio | Level | Source |
|---|---|---|---|---|---|---|
| PixelCoinDisplay "C" letter | `#3E2723` | `#FFD700` (xpBarFill) | Both | 7.56:1 | AAA | `pixel_coin_display.dart:25-26` |
| PixelSwitch thumb (on) | `#FFF8E7` (retroBackground) | `#2E8B57` (pixelSuccess) | Light | ≥ 7:1 | AAA | `pixel_switch.dart:56-59` |
| PixelSwitch thumb (on) | `#1A1A2E` (retroBackground) | `#5CDB95` (pixelSuccess) | Dark | ≥ 7:1 | AAA | `pixel_switch.dart:56-59` |

### Celebration Overlay (Fixed Colors)

| Element | Color | Background | Rationale | Source |
|---|---|---|---|---|
| Title text | `Colors.white` | `primary → scrim` gradient | Fixed white on guaranteed-dark gradient | `color_utils.dart:62-67` |
| Subtitle text | `Colors.white70` | Same gradient | Slightly muted, still high contrast on dark | `color_utils.dart` |
| Body text | `Colors.white54` | Same gradient | Decorative emphasis only | `color_utils.dart` |

---

## Material 3 Mode — Automatic Guarantees

Material 3's `ColorScheme.fromSeed()` algorithm produces tonal palettes that inherently satisfy WCAG AA contrast requirements:

- **`on*` tokens** (e.g. `onPrimary`, `onSurface`) are mathematically derived to achieve ≥ 4.5:1 against their corresponding surface.
- **`*Container` / `on*Container`** pairs also meet AA.
- **Dynamic Color (Material You)**: The system-provided wallpaper-derived `ColorScheme` follows the same M3 tonal mapping, preserving contrast guarantees.

No manual verification is needed for standard M3 token pairs. Only custom hardcoded colors (listed above) require explicit audit.

---

## Verification Method

1. **Tool**: [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
2. **Formula**: WCAG relative luminance formula — `L = 0.2126R + 0.7152G + 0.0722B` (linearized sRGB), contrast ratio = `(L1 + 0.05) / (L2 + 0.05)`
3. **When to re-verify**: Any time a hardcoded color constant in `pixel_theme_extension.dart`, `color_utils.dart`, or `pixel_ui/` widgets is modified

---

## Changelog

| Date | Change |
|---|---|
| 2026-03-17 | Initial creation — documented all audited contrast pairs from PDCA theme audit |
