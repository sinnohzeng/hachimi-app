# Hachimi App — Claude Code Project Rules

## Core Development Principles

### Document-Driven Development (DDD)

All interfaces, data models, and architectural decisions are specified in `docs/` **before** implementation. Documents are the contract; code is the implementation.

**Mandatory workflow for every code change:**

1. **Read relevant docs first** — before modifying any code, read the SSOT document for that domain
2. **Update docs before code** — if the change introduces new interfaces, providers, models, routes, or services, update the corresponding `docs/` specification first
3. **Bilingual documentation** — all doc changes must be mirrored in both `docs/` (English) and `docs/zh-CN/` (Chinese)
4. **When docs and code conflict** — the document is correct. Fix the code, only update the document with deliberate intent

### Single Source of Truth (SSOT)

Every concern in the system has exactly one authoritative source. Never duplicate definitions.

| Concern | SSOT Location |
|---------|--------------|
| System architecture | `docs/architecture/overview.md` |
| Data model / Firestore schema | `docs/architecture/data-model.md` |
| Provider graph | `docs/architecture/state-management.md` |
| Cat game mechanics | `docs/architecture/cat-system.md` |
| Folder structure | `docs/architecture/folder-structure.md` |
| UI theme | `lib/core/theme/app_theme.dart` |
| Analytics event names | `lib/core/constants/analytics_events.dart` |
| Cat game metadata | `lib/core/constants/cat_constants.dart` |
| AI config / prompts | `lib/core/constants/ai_constants.dart` |
| AI provider interface | `lib/core/ai/ai_provider.dart` |
| Named routes | `lib/core/router/app_router.dart` |
| Firestore security rules | `firestore.rules` |
| Website deployment & maintenance | `docs/website/deployment.md` |
| App release process | `docs/release/process.md` |
| Google Play CI/CD setup | `docs/release/google-play-setup.md` |
| License | `LICENSE` |

**When adding a new provider, service, model, route, or widget:**
1. Add it to the relevant `docs/architecture/` spec (EN + zh-CN)
2. Then implement in code

### Strict Dependency Flow

```
Screens → Providers → Services → Firebase SDK
```

- Screens only read from Providers (via `ref.watch` / `ref.read`) — never import Services
- Providers orchestrate Services and expose reactive state — never access Firebase SDK directly
- Services encapsulate all Firebase SDK interactions — no UI code, no BuildContext

## Architecture Overview

State management: **Riverpod 3.x** (`StreamProvider`, `FutureProvider`, `StateNotifierProvider`)

```
lib/
├── main.dart / app.dart          # Entry point & app root
├── core/                         # Infrastructure layer
│   ├── ai/                       # AI provider interface & config
│   ├── backend/                  # Backend abstraction layer (8 interfaces)
│   ├── constants/                # App-wide constants & metadata
│   ├── observability/            # Logging, correlation IDs, error context
│   ├── router/                   # GoRouter route definitions
│   ├── theme/                    # Material 3 design tokens
│   └── utils/                    # Shared utilities
├── models/                       # Data models (13 files)
├── providers/                    # Riverpod providers (22 files)
├── services/                     # Business logic & Firebase SDK (29 files)
│   ├── firebase/                 # Firebase backend implementations
│   └── ai/                       # AI provider implementations
├── screens/                      # Feature screens (14 modules)
├── widgets/                      # Reusable components (36 files)
└── l10n/                         # ARB localization files
```

## Environment

- Flutter: 3.41.x stable, Dart: 3.11.x
- JDK: OpenJDK 17 (`brew install openjdk@17`). JDK 25 is incompatible with Gradle 8.x
- AGP: 8.x only. AGP 9 breaks Flutter 3.41 plugins (flutter/flutter#181383)
- Android SDK: `/opt/homebrew/share/android-commandlinetools`
- Firebase project: `hachimi-ai`
- Test device: vivo V2405A (Android 16, API 36)

## Commands

- Resolve deps: `flutter pub get`
- Analyze: `dart analyze lib/`
- Auto-fix lint: `dart fix --apply`
- Format code: `dart format lib/ test/`
- Run tests: `flutter test`
- Update goldens: `flutter test --update-goldens`
- Build debug APK: `flutter build apk --debug`
- Build release APK: `flutter build apk --release`
- Clean build cache: `rm -rf build && flutter clean && flutter pub get`
- Install on vivo (debug): `adb shell settings put global package_verifier_enable 0 && adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk`
- Install on vivo (release): `adb shell settings put global package_verifier_enable 0 && adb install -r -t -d build/app/outputs/flutter-apk/app-release.apk`
- Deploy Firestore rules: `firebase deploy --only firestore:rules --project hachimi-ai`
- Deploy indexes: `firebase deploy --only firestore:indexes --project hachimi-ai`
- Build release AAB: `flutter build appbundle --release --dart-define=MINIMAX_API_KEY=xxx --dart-define=GEMINI_API_KEY=xxx`
- Build with AI (env file): `flutter run --dart-define-from-file=.env`
- Build with AI (manual): `flutter build apk --release --dart-define=MINIMAX_API_KEY=xxx --dart-define=GEMINI_API_KEY=xxx`
- Tag release: `git tag -a v<VERSION> -m "v<VERSION>: <description>" && git push origin main --tags`
- Check device status: `scripts/adb-debug.sh status`
- Read device logs: `scripts/adb-debug.sh logs [--lines N] [--level W|E] [--tag TAG]`
- Read errors only: `scripts/adb-debug.sh errors`
- Read crash trace: `scripts/adb-debug.sh crash`
- Clear device logs: `scripts/adb-debug.sh clear`
- Start log collector: `scripts/adb-debug.sh start-bg`
- Stop log collector: `scripts/adb-debug.sh stop-bg`
- Install debug APK: `scripts/adb-debug.sh install`
- Device screenshot: `scripts/adb-debug.sh screenshot`

## Key Gotchas

- `google_fonts` 6.x breaks with Flutter 3.41 (FontWeight const) → use 8.x+
- `CardTheme` → `CardThemeData` in Flutter 3.41+
- Kotlin 2.x: use `kotlin { compilerOptions { jvmTarget = ... } }` not deprecated `kotlinOptions`
- vivo USB install: use `adb install -r -t -d` when `flutter run` fails with `INSTALL_FAILED_ABORTED`
- `StateNotifierProvider.autoDispose` auto-disposes the notifier — do NOT add manual `ref.onDispose(() => notifier.dispose())`
- Firestore security rules must be deployed before the app can read/write data
- Pre-commit version check: `scripts/pre-commit-version-check.sh` warns if pubspec version matches latest tag (forgot to bump)

## Testing

- Tests mirror `lib/` structure: `test/{core,models,providers,screens,services,widgets}/`
- Golden files: `test/widgets/goldens/` — tagged `['golden']`, update with `flutter test --update-goldens`
- Provider tests use `ProviderContainer(overrides: [...])` — no mockito
- Firebase mocking: `setupFirebaseCoreMocks()` from `firebase_core_platform_interface`
