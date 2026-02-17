# Design System — Material Design 3

> The M3 Theme defined in `app_theme.dart` is the single source of truth for all UI styling.
> No hardcoded colors, fonts, or spacing values in screen/widget code.

## Color Scheme

- **Seed Color**: `Color(0xFF4285F4)` (Google Blue)
- **Generation**: `ColorScheme.fromSeed(seedColor: seedColor)`
- This automatically generates a full M3 color palette including:
  - primary, onPrimary, primaryContainer, onPrimaryContainer
  - secondary, tertiary, surface, error, etc.

## Typography

- **Font Family**: Google Fonts — Roboto (default M3 font)
- **Usage**: Always via `Theme.of(context).textTheme`
  - `displayLarge` — Large numbers (timer display)
  - `headlineMedium` — Screen titles
  - `titleLarge` — Card titles
  - `titleMedium` — Section headers
  - `bodyLarge` — Primary body text
  - `bodyMedium` — Secondary body text
  - `labelLarge` — Button text

## Components (M3)

| Component | Usage |
|-----------|-------|
| `NavigationBar` | Bottom navigation (Home / Stats) |
| `Card` | Habit cards on home screen |
| `FilledButton` | Primary actions (Login, Create Habit) |
| `OutlinedButton` | Secondary actions (Cancel) |
| `TextButton` | Tertiary actions (Switch to Register) |
| `FloatingActionButton` | Add new habit |
| `LinearProgressIndicator` | Habit progress bar |
| `CircularProgressIndicator` | Timer loading state |
| `TextField` / `OutlinedTextField` | Form inputs |
| `IconButton` | Action icons |
| `SnackBar` | Success/error feedback |
| `AlertDialog` | Confirm delete |

## Spacing

Use multiples of 8dp (M3 standard):
- `4` — tight spacing
- `8` — compact spacing
- `16` — standard spacing
- `24` — section spacing
- `32` — large spacing

Access via `const EdgeInsets.all(16)` etc. — these are simple enough to inline.

## Rules
1. **Colors**: `Theme.of(context).colorScheme.primary` — never `Colors.blue`
2. **Text**: `Theme.of(context).textTheme.titleLarge` — never `TextStyle(fontSize: 22)`
3. **Shape**: Use default M3 shapes from theme — never hardcode `BorderRadius`
4. **Elevation**: Use M3 elevation levels (0, 1, 2, 3) — never hardcode shadow values
