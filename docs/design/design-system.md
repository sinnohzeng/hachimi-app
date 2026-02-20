# Design System — Material Design 3 (SSOT)

> **SSOT**: The theme defined in `lib/core/theme/app_theme.dart` is the single source of truth for all UI styling. No hardcoded colors, fonts, or spacing values in screen or widget code.

---

## Color System

### Seed Color
```dart
// lib/core/theme/app_theme.dart
static const Color seedColor = Color(0xFF4285F4); // Google Blue
```

**Generation:** `ColorScheme.fromSeed(seedColor: seedColor)` — Material 3 automatically derives a full tonal palette from the seed color. Both light and dark themes are generated from the same seed.

### Dynamic Color (Material You)

On Android 12+ devices, the app can use the wallpaper-derived `ColorScheme` provided by the system via the `dynamic_color` package. This is controlled by the `useDynamicColor` setting in `ThemeSettings` (default: `true`).

```dart
// lib/app.dart
DynamicColorBuilder(
  builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    final useDynamic = themeSettings.useDynamicColor && lightDynamic != null;
    // Use lightDynamic / darkDynamic when available, else fall back to seed color
  },
)
```

When dynamic color is active, the seed color setting is ignored and the system-provided `ColorScheme` is used directly. Users can toggle this via **Settings > Appearance > Material You**.

### Color Tokens

**Do not hardcode colors.** Always access via `Theme.of(context).colorScheme`:

| Role | Token | Typical Use |
|------|-------|-------------|
| `primary` | Main accent | Buttons, active icons, progress rings |
| `onPrimary` | Text on primary | Button labels on filled buttons, text on primary-gradient screens (login, onboarding) |
| `primaryContainer` | Muted primary | Selected chip backgrounds, cat XP bar fill, today summary card |
| `onPrimaryContainer` | Text on primary container | Text in chip/container on primary |
| `secondary` | Supporting accent | Secondary buttons, streak badges |
| `tertiary` | Accent 3 | Coin balance icon, rare cat indicators, celebration glow |
| `surface` | Background surface | Cards, sheets, dialogs |
| `surfaceContainerHighest` | Elevated surface | Heatmap empty cells, disabled states, skeleton base |
| `surfaceContainerLow` | Lower surface | Skeleton shimmer highlight |
| `onSurface` | Text on surface | Body text, icons |
| `onSurfaceVariant` | Muted text on surface | Secondary labels, subtitles |
| `outline` | Borders | TextField outlines, dividers |
| `error` | Error state | Invalid input, error snackbars, archive actions |

### Cat Breed Tinting

Cat sprites are tinted using `ColorFiltered` with the breed's `baseColor`. The blend mode is `BlendMode.srcATop`. This is handled by `lib/widgets/pixel_cat_sprite.dart` — do not replicate this pattern elsewhere.

Breed colors are defined in `lib/core/constants/cat_constants.dart`. See [Cat System](../architecture/cat-system.md) for the full color table.

---

## Typography

**Font family:** Google Fonts — Roboto (loaded via `GoogleFonts.robotoTextTheme()` for cross-platform consistency).

Always access text styles via `Theme.of(context).textTheme`. Never hardcode `TextStyle` with raw `fontSize` or `fontWeight` values.

| Token | Use Case |
|-------|----------|
| `displaySmall` | App name on login screen |
| `headlineLarge` | Onboarding page titles |
| `headlineMedium` | Email auth screen title |
| `titleLarge` | Stat card values, cat name in detail screen |
| `titleMedium` | Section headers, habit names, featured cat name |
| `titleSmall` | Cat name in grid card, habit row title |
| `bodyLarge` | Primary body copy, onboarding body text |
| `bodyMedium` | Secondary body copy, login links |
| `bodySmall` | Subtitle text, habit goal text, time labels |
| `labelLarge` | Coin balance, button labels |
| `labelSmall` | Stage label, rarity badges, progress ring text |

---

## Components

| M3 Component | Usage in Hachimi |
|-------------|-----------------|
| `NavigationBar` | 4-tab bottom navigation (Today, CatHouse, Stats, Profile) |
| `Card` | Habit cards, stats cards, cat detail sections, featured cat |
| `FilledButton` | Primary CTA: "Start Focus", "Adopt", "Login", "Rename" |
| `FilledButton.tonal` | Error retry button (`ErrorState`), empty state CTA |
| `OutlinedButton` | Cancel, secondary navigation |
| `TextButton` | Tertiary actions: "Skip", "Cancel" in dialogs |
| `ChoiceChip` | Duration selector chips (15/25/40/60 min) in focus setup |
| `SegmentedButton` | Timer mode toggle (Countdown / Stopwatch) in focus setup |
| `LinearProgressIndicator` | XP progress bar, habit daily progress, overall stats progress |
| `TextField` / `TextFormField` | Habit name, cat name, login/register form fields |
| `IconButton` | Toolbar actions (inventory, shop, close, settings) |
| `SnackBar` | Success/error feedback (session saved, quest completed) |
| `AlertDialog` | Confirm destructive actions (delete quest, archive cat, rename) |
| `ModalBottomSheet` | Cat quick actions in CatHouse (rename, edit quest, archive) |
| `SwitchListTile` | Settings toggles (Material You, dark mode, notifications) |
| `Chip` | Streak badge in per-quest stats |

---

## Spacing

### Constants (`lib/core/theme/app_spacing.dart`)

Spacing is centralized in `AppSpacing` for consistency. Use these constants instead of inline numeric literals.

| Constant | Value | Use |
|----------|-------|-----|
| `AppSpacing.xs` | `4` | Tight / micro spacing (between icon and label) |
| `AppSpacing.sm` | `8` | Compact spacing (between chips, within rows) |
| `AppSpacing.md` | `12` | Half-section spacing, grid spacing |
| `AppSpacing.base` | `16` | Standard padding (card content, screen edges) |
| `AppSpacing.lg` | `24` | Section separation |
| `AppSpacing.xl` | `32` | Large separation (between screen sections) |
| `AppSpacing.xxl` | `48` | Hero areas (cat sprite margin) |

`AppSpacing` also provides pre-built `EdgeInsets` helpers: `paddingBase`, `paddingHBase`, `paddingCard`, etc.

---

## Motion

### Duration Tokens (`lib/core/theme/app_motion.dart`)

| Constant | Value | Use |
|----------|-------|-----|
| `AppMotion.durationShort1` | 50ms | Micro-interactions (icon swap) |
| `AppMotion.durationShort2` | 100ms | Small state changes |
| `AppMotion.durationShort3` | 150ms | Chip/checkbox toggle |
| `AppMotion.durationShort4` | 200ms | Component expand/collapse |
| `AppMotion.durationMedium1` | 250ms | Card reveal |
| `AppMotion.durationMedium2` | 300ms | Page transitions, tab switch |
| `AppMotion.durationMedium4` | 400ms | Staggered entrance delays |
| `AppMotion.durationLong2` | 500ms | Celebration animations |

### Easing Tokens

| Constant | Curve | Use |
|----------|-------|-----|
| `AppMotion.emphasized` | `easeInOutCubicEmphasized` | Default for most transitions |
| `AppMotion.standard` | `easeInOut` | Standard motion |
| `AppMotion.decelerate` | `decelerateEasing` | Entrance motion |
| `AppMotion.accelerate` | `accelerateEasing` | Exit motion |
| `AppMotion.linear` | `linear` | Progress indicators, shimmer |

### Motion Patterns

| Pattern | Implementation | Location |
|---------|---------------|----------|
| **FadeThrough** | Tab switching in `HomeScreen` | `lib/screens/home/home_screen.dart` |
| **Hero** | Cat sprite shared element (CatHouse → Detail, Featured → Detail) | `TappableCatSprite` wrapped in `Hero(tag: 'cat-${cat.id}')` |
| **Staggered entrance** | Focus complete celebration (emoji → content → stats) | `lib/screens/timer/focus_complete_screen.dart` |
| **Zoom** | Page-to-page navigation (Android default via `ZoomPageTransitionsBuilder`) | `lib/core/theme/app_theme.dart` |

---

## Loading, Empty & Error States

All async data loading follows a consistent tri-state pattern using reusable widgets.

### Skeleton Loaders (`lib/widgets/skeleton_loader.dart`)

Replace `CircularProgressIndicator` with shimmer skeletons that match the shape of the content being loaded:

| Component | Use |
|-----------|-----|
| `SkeletonLoader` | Generic shimmer placeholder block (configurable width/height/borderRadius) |
| `SkeletonCard` | Mimics a HabitRow shape (circle avatar + 2 text lines + action) |
| `SkeletonGrid` | Mimics a 2-column cat card grid (default 4 items) |

### Empty State (`lib/widgets/empty_state.dart`)

Centered icon + title + optional subtitle + optional CTA button. Used when a data list is empty.

### Error State (`lib/widgets/error_state.dart`)

Centered error icon + message + optional retry button. Used for data loading failures.

| Screen | Loading | Empty | Error |
|--------|---------|-------|-------|
| Today (habits) | `SkeletonCard` × 3 | `EmptyState` + add_task icon | `ErrorState` + retry |
| CatHouse | `SkeletonGrid` | `EmptyState` + home icon | `ErrorState` + retry |
| Stats (quests) | `SkeletonCard` × 3 | `EmptyState` + bar_chart icon | `ErrorState` + retry |

---

## Accessibility

All custom widgets include `Semantics` labels for TalkBack / VoiceOver support.

| Widget | Semantics Label |
|--------|----------------|
| `PixelCatSprite` | `'${peltColor} ${peltType} cat'` (image) |
| `ProgressRing` | `'${progress}% progress'` (value) |
| `StreakIndicator` | `'$streak day streak'` |
| `TappableCatSprite` | `'${cat.name}, tap to interact'` (button) or `'${cat.name} cat'` (image) |
| `EmojiPicker` items | `emoji` (button, selected state) |
| `OfflineBanner` | `'Offline mode'` (liveRegion) |
| `StreakHeatmap` cells | `'$month/$day, $minutes minutes'` |
| `CheckInBanner` | `'Daily check-in'` |
| Timer display | `'Timer: $displayTime'` (liveRegion) |

---

## Shape

M3 uses a rounded corner shape system. Use the theme defaults — do not hardcode `BorderRadius`.

| Level | Approx radius | Use |
|-------|-------------|-----|
| Extra small | 4dp | Text chips, progress bar corners |
| Small | 8dp | Buttons, input fields |
| Medium | 12dp | Cards |
| Large | 16dp | Bottom sheets, dialogs, auth buttons |
| Extra large | 28dp | FAB |
| Full | 50% | Circular buttons, avatars |

Access via `Theme.of(context).shape` for container shapes, or rely on component defaults.

---

## Elevation & Tonal Surface

M3 uses **tonal elevation** (surface tint) instead of drop shadows. Higher elevation = more prominent surface color blended toward `primary`.

| Level | Use |
|-------|-----|
| Level 0 | Background |
| Level 1 | Cards (default) |
| Level 2 | Raised cards, navigation bar |
| Level 3 | Dialogs, FAB |

Do not set `elevation` on widgets unless intentionally overriding the component default.

---

## Rules

1. **Colors**: `Theme.of(context).colorScheme.primary` — never `Colors.blue`, `Color(0xFF...)` inline
2. **Text styles**: `Theme.of(context).textTheme.titleLarge` — never `TextStyle(fontSize: 22, fontWeight: FontWeight.bold)`
3. **Shape**: Rely on component defaults or `Theme.of(context).shape` — never hardcode `BorderRadius.circular(8)`
4. **Icons**: Always use `Icons.*` from the Material icon set — never import image icons for UI chrome
5. **Animations**: Use `AppMotion` duration and easing tokens — never hardcode `Duration(milliseconds: 300)` or `Curves.easeInOut` directly
6. **Cat tinting**: Only in `PixelCatSprite` widget — never use `ColorFiltered` elsewhere for arbitrary tinting
7. **Spacing**: Prefer `AppSpacing.*` constants for common values — avoid magic numbers
8. **Loading states**: Use `SkeletonLoader` / `SkeletonCard` / `SkeletonGrid` — never `CircularProgressIndicator` for content loading
9. **Accessibility**: All custom paint / gesture widgets must have `Semantics` labels
