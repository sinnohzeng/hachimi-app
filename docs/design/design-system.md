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

**Do not hardcode colors.** Always access via `Theme.of(context).colorScheme`:

| Role | Token | Typical Use |
|------|-------|-------------|
| `primary` | Main accent | Buttons, active icons, progress rings |
| `onPrimary` | Text on primary | Button labels on filled buttons |
| `primaryContainer` | Muted primary | Selected chip backgrounds, cat XP bar fill |
| `onPrimaryContainer` | Text on primary container | Text in chip/container on primary |
| `secondary` | Supporting accent | Secondary buttons, streak badges |
| `tertiary` | Accent 3 | Rare cat indicators, celebration glow |
| `surface` | Background surface | Cards, sheets, dialogs |
| `surfaceContainerHighest` | Elevated surface | Heatmap empty cells, disabled states |
| `onSurface` | Text on surface | Body text, icons |
| `outline` | Borders | TextField outlines, dividers |
| `error` | Error state | Invalid input, error snackbars |

### Cat Breed Tinting

Cat sprites are tinted using `ColorFiltered` with the breed's `baseColor`. The blend mode is `BlendMode.srcATop`. This is handled by `lib/widgets/cat_sprite.dart` — do not replicate this pattern elsewhere.

Breed colors are defined in `lib/core/constants/cat_constants.dart`. See [Cat System](../architecture/cat-system.md) for the full color table.

---

## Typography

**Font family:** Google Fonts — Noto Sans (loaded via `google_fonts` package for cross-platform consistency).

Always access text styles via `Theme.of(context).textTheme`. Never hardcode `TextStyle` with raw `fontSize` or `fontWeight` values.

| Token | Use Case |
|-------|----------|
| `displayLarge` | Timer countdown display (large numerals) |
| `displayMedium` | XP number in Focus Complete screen |
| `headlineLarge` | Screen hero titles (e.g., Cat Room "Your Cats") |
| `headlineMedium` | Section headers |
| `titleLarge` | Card titles, cat name in detail screen |
| `titleMedium` | Habit names in list rows |
| `bodyLarge` | Primary body copy |
| `bodyMedium` | Secondary body copy, speech bubbles |
| `labelLarge` | Button labels |
| `labelSmall` | Rarity badges, personality chips |

---

## Components

| M3 Component | Usage in Hachimi |
|-------------|-----------------|
| `NavigationBar` | 4-tab bottom navigation (Today, Cat Room, Stats, Profile) |
| `Card` | Habit cards, stats cards, cat detail sections |
| `FilledButton` | Primary CTA: "Start Focus", "Adopt", "Login" |
| `FilledButton.tonal` | Secondary CTA: timer controls, mode toggle active state |
| `OutlinedButton` | Cancel, secondary navigation |
| `TextButton` | Tertiary actions: "Switch to Register", "View Details" |
| `FilterChip` | Duration selector chips (15/25/40/60 min) |
| `InputChip` | Selected chip state in duration selector |
| `SegmentedButton` | Timer mode toggle (Countdown / Stopwatch) |
| `LinearProgressIndicator` | XP progress bar, habit daily progress |
| `CircularProgressIndicator` | Loading states, progress ring (custom via `CustomPainter`) |
| `TextField` / `TextFormField` | Habit name, cat name, login form fields |
| `IconButton` | Toolbar actions (close, back, settings) |
| `SnackBar` | Success/error feedback (session saved, error) |
| `AlertDialog` | Confirm destructive actions (delete habit, give up) |
| `BottomSheet` | Cat quick actions in Cat Room |
| `ModalBottomSheet` | Cat Album full view |

---

## Spacing

Use multiples of 8dp (M3 baseline grid). Inline `EdgeInsets` constants are acceptable since spacing is not shared state.

| Value | Use |
|-------|-----|
| `4` | Tight / micro spacing (between icon and label) |
| `8` | Compact spacing (between chips, within rows) |
| `12` | Half-section spacing |
| `16` | Standard padding (card content, screen edges) |
| `24` | Section separation |
| `32` | Large separation (between screen sections) |
| `48` | Hero areas (cat sprite margin) |

---

## Shape

M3 uses a rounded corner shape system. Use the theme defaults — do not hardcode `BorderRadius`.

| Level | Approx radius | Use |
|-------|-------------|-----|
| Extra small | 4dp | Text chips |
| Small | 8dp | Buttons, input fields |
| Medium | 12dp | Cards |
| Large | 16dp | Bottom sheets, dialogs |
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
5. **Animations**: Use Material motion specs (Standard, Emphasized, Decelerate, Accelerate) — match via `Curves.easeInOut`, `Curves.easeOutCubic`
6. **Cat tinting**: Only in `CatSprite` widget — never use `ColorFiltered` elsewhere for arbitrary tinting
