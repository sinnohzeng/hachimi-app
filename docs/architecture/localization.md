# Localization (i18n) — SSOT

> **SSOT**: This document is the single source of truth for the internationalization approach. All localized string management must follow this specification.

---

## Overview

Hachimi uses Flutter's built-in localization system powered by **`flutter_localizations`** and **`gen-l10n`** (compile-time code generation from ARB files). This approach provides:

1. **Type-safe string access** — generated `AppLocalizations` class with compile-time checked keys
2. **No runtime lookup failures** — missing keys are caught at build time, not at runtime
3. **ARB format** — industry-standard Application Resource Bundle format, compatible with translation tools
4. **Minimal boilerplate** — `gen-l10n` generates all Dart code automatically

---

## Supported Locales

| Locale | Language | ARB File | Status |
|--------|----------|----------|--------|
| `en` | English | `lib/l10n/app_en.arb` | Primary (source of truth) |
| `zh` | Chinese (Simplified) | `lib/l10n/app_zh.arb` | Translation |

English is the **template locale** — all new keys must be added to `app_en.arb` first, then translated to `app_zh.arb`.

---

## Configuration

### `l10n.yaml` (project root)

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: true
nullable-getter: false
```

### `pubspec.yaml` dependencies

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

### `MaterialApp` integration

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

---

## ARB File Format

ARB files are JSON with metadata annotations. Each user-facing string is a key-value pair, optionally followed by an `@key` metadata entry.

### Example: `app_en.arb`

```json
{
  "@@locale": "en",
  "homeTabToday": "Today",
  "@homeTabToday": {
    "description": "Label for the Today tab on the home screen"
  },
  "homeTabCats": "Cats",
  "@homeTabCats": {
    "description": "Label for the Cats tab on the home screen"
  },
  "adoptionConfirmButton": "Adopt {catName}",
  "@adoptionConfirmButton": {
    "description": "Button label to confirm cat adoption",
    "placeholders": {
      "catName": {
        "type": "String",
        "example": "Mochi"
      }
    }
  },
  "timerMinutesRemaining": "{minutes, plural, =1{1 minute remaining} other{{minutes} minutes remaining}}",
  "@timerMinutesRemaining": {
    "description": "Timer countdown display",
    "placeholders": {
      "minutes": {
        "type": "int"
      }
    }
  }
}
```

---

## Key Naming Convention

Keys follow the pattern: **`screenName` + `purpose`** in camelCase.

| Prefix | Screen / Context | Example Keys |
|--------|-----------------|--------------|
| `home` | HomeScreen | `homeTabToday`, `homeTabCats`, `homeTabStats`, `homeTabProfile` |
| `adoption` | AdoptionFlowScreen | `adoptionStepName`, `adoptionConfirmButton`, `adoptionRefresh` |
| `timer` | TimerScreen | `timerStart`, `timerPause`, `timerMinutesRemaining` |
| `catDetail` | CatDetailScreen | `catDetailStageLabel`, `catDetailMoodHappy` |
| `catRoom` | CatRoomScreen | `catRoomTitle`, `catRoomEmpty` |
| `profile` | ProfileScreen | `profileLogout`, `profileCatAlbum` |
| `stats` | StatsScreen | `statsTotalHours`, `statsBestStreak` |
| `login` | LoginScreen | `loginEmailLabel`, `loginGoogleButton` |
| `onboarding` | OnboardingScreen | `onboardingWelcome`, `onboardingGetStarted` |
| `common` | Shared across screens | `commonCancel`, `commonSave`, `commonDelete`, `commonError` |
| `checkIn` | CheckInBanner | `checkInBonusEarned`, `checkInPrompt` |
| `accessory` | AccessoryShopSection | `accessoryBuyButton`, `accessoryInsufficientCoins` |

**Rules:**
- Always use camelCase
- Prefix with the screen or component context
- Use descriptive suffixes (`Button`, `Label`, `Title`, `Message`, `Error`)
- Plurals use ICU MessageFormat syntax in the ARB value

---

## Adding a New String

Follow this workflow when adding any new user-facing text:

1. **Add the key to `app_en.arb`** with the English string value and an `@key` metadata entry containing a `description`.

2. **Add the translation to `app_zh.arb`** with the same key and the Chinese translation.

3. **Run code generation**:
   ```bash
   flutter gen-l10n
   ```
   This regenerates `AppLocalizations` with the new key. (This also runs automatically on `flutter build` and `flutter run`.)

4. **Use in code**:
   ```dart
   // In any widget with BuildContext:
   final l10n = AppLocalizations.of(context);
   Text(l10n.homeTabToday)

   // With placeholders:
   Text(l10n.adoptionConfirmButton(catName))
   ```

5. **Never hard-code user-facing strings** in screen or widget files. Constants like route names, Firestore field names, and analytics event keys are not user-facing and do not need localization.

---

## Generated Output

The `gen-l10n` tool produces:

```
.dart_tool/flutter_gen/gen_l10n/
├── app_localizations.dart          # Abstract AppLocalizations class
├── app_localizations_en.dart       # English implementation
└── app_localizations_zh.dart       # Chinese implementation
```

These files are generated at compile time and should **not** be checked into version control. They are listed in `.gitignore` via the `.dart_tool/` pattern.

---

## What to Localize

| Category | Localize? | Examples |
|----------|-----------|---------|
| Screen titles and labels | Yes | "Today", "Cats", "Profile" |
| Button text | Yes | "Start", "Cancel", "Adopt Mochi" |
| Error messages | Yes | "Network error. Please try again." |
| Cat speech bubble messages | Yes | "Purrrfect day for a nap..." |
| Personality display names | Yes | "Lazy", "Curious", "Playful" |
| Stage display names | Yes | "Kitten", "Adolescent", "Adult", "Senior" |
| Mood display names | Yes | "Happy", "Neutral", "Lonely", "Missing" |
| Firestore field names | No | `"boundHabitId"`, `"totalMinutes"` |
| Analytics event names | No | `"focus_session_complete"` |
| Route paths | No | `"/cat-detail"`, `"/timer"` |
| Log messages (debug) | No | `"Firestore batch committed"` |

---

## Testing

To verify localization completeness:

1. **Compile check**: `flutter gen-l10n` will fail if `app_zh.arb` is missing any key that exists in `app_en.arb`.
2. **Visual check**: Run the app with `--locale zh` to verify Chinese strings render correctly.
3. **Placeholder check**: Ensure all placeholders (`{catName}`, `{minutes}`) are present in both ARB files.
