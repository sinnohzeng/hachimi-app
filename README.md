# Hachimi 🐱

<p align="center">
  <strong>Raise cats. Build habits. One focus session at a time.</strong>
</p>

<p align="center">
  <a href="README.zh-CN.md">🇨🇳 中文文档</a>
  &nbsp;·&nbsp;
  <a href="docs/README.md">Documentation Index</a>
  &nbsp;·&nbsp;
  <a href="docs/CONTRIBUTING.md">Contributing</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41.1-blue?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11.0-blue?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-backend-orange?logo=firebase" alt="Firebase" />
  <img src="https://img.shields.io/badge/Material_Design-3-purple?logo=materialdesign" alt="MD3" />
  <img src="https://img.shields.io/badge/license-All%20Rights%20Reserved-red" alt="License" />
</p>

---

## What is Hachimi?

Hachimi is a **cat-parenting habit app** where every habit you create comes with a virtual kitten to raise. Focus on your habit → earn XP → watch your cat evolve from a tiny kitten into a glowing shiny adult. The cozy Cat Room fills up as you build more habits, creating a living visual record of your growth.

The core loop:

> **Create habit → Adopt kitten → Start focus timer → Earn XP & coins → Cat evolves**

---

## Features

### Core Loop
**Cat Adoption** · **Focus Timer** · **XP & Evolution**
- Each habit adopts a unique kitten from a draft of 3 randomly generated candidates
- 15 pelt patterns × 19 colors × 21 eye colors × 6 personalities
- Countdown / stopwatch modes, Android foreground service for persistent timing
- XP formula: base value + streak bonus + milestone bonus + full-house bonus
- 4 growth stages: Kitten → Adolescent → Adult → Senior

### Cat World
**Cat Room** · **Accessory Shop** · **Inventory**
- Day/night ambience illustrated room, personality-based slot placement
- 100+ accessories across 5 price tiers (50–350 coins)
- Coin sources: focus sessions (10 coins/min) + daily check-in rewards

### AI Companion
**Cat Chat** · **AI Diary**
- Local LLM (Qwen3-1.7B via llama_cpp_dart), no cloud dependency
- Cats reply in personality-flavored tone, fully private on-device
- Daily auto-generated diary blending mood, growth, and focus data

### Progress & Rewards
**Stats Dashboard** · **Daily Check-In** · **Notifications**
- Weekly trend bar chart (fl_chart) + 91-day heatmap + paginated session history
- Monthly calendar UI, weekday 10 / weekend 15 coins, streak milestones at 7/14/21/full month
- Daily reminders + streak-at-risk alerts + level-up celebrations

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| UI Framework | Flutter | 3.41.1 | Cross-platform mobile |
| Language | Dart | 3.11.0 | Type-safe, null-safe |
| Design System | Material Design 3 | — | Consistent UI theming |
| State Management | Riverpod | 3.2.1 | Reactive SSOT providers |
| Auth | Firebase Auth | 6.x | Google + email sign-in |
| Database | Cloud Firestore | 6.x | Real-time data sync |
| Local Database | sqflite | 2.4.x | LLM chat history + diary cache |
| Analytics | Firebase Analytics | 12.x | GA4 event tracking |
| Performance | Firebase Performance | 0.11.x | Custom traces + monitoring |
| Push Notifications | Firebase Messaging | 16.x | Server-triggered FCM |
| Local Notifications | flutter_local_notifications | 20.x | Scheduled daily reminders |
| Background Timer | flutter_foreground_task | 9.x | Android foreground service |
| A/B Testing | Firebase Remote Config | 6.x | Dynamic configuration |
| Crash Reporting | Firebase Crashlytics | 5.x | Non-fatal + fatal error tracking |
| Charts | fl_chart | 0.70.x | Weekly trend + stats visualization |
| Dynamic Color | dynamic_color | 1.8.x | Material You color extraction |
| Local LLM | llama_cpp_dart | vendored | On-device Qwen3-1.7B inference |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # SSOT: analytics, cats, LLM, pixel cats (4 files)
│   ├── router/          # Named route registry
│   ├── theme/           # Material 3 seed + color utils
│   └── utils/           # Error handling, checksums, date utils (9 files)
├── models/              # 7 Firestore/local data models
├── providers/           # 19 Riverpod state providers
├── services/            # 19 Firebase + local service wrappers
├── screens/             # 11 feature screen directories
└── widgets/             # 17 reusable UI components
```

Full file listing → [Folder Structure](docs/architecture/folder-structure.md)

---

## Getting Started

### Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| Flutter | 3.41.x stable | `flutter --version` |
| Dart | 3.11.x | Bundled with Flutter |
| JDK | 17 | `brew install openjdk@17` (macOS) |
| Android Studio | Latest | For AVD / device management |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| FlutterFire CLI | Latest | `dart pub global activate flutterfire_cli` |

> **Android SDK path (macOS/Homebrew):** `/opt/homebrew/share/android-commandlinetools`

### 1. Clone and install

```bash
git clone https://github.com/sinnohzeng/hachimi-app.git
cd hachimi-app
flutter pub get
```

### 2. Configure Firebase

```bash
firebase login
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This generates `lib/firebase_options.dart` and `android/app/google-services.json` (both gitignored — never commit these files).

### 3. Enable Firebase services

In the [Firebase Console](https://console.firebase.google.com):

1. **Authentication** → Enable **Email/Password** and **Google** sign-in providers
2. **Firestore** → Create database in **production mode**
3. **Analytics** → Enable Google Analytics
4. **Remote Config** → Publish default parameters (see [remote-config.md](docs/firebase/remote-config.md))
5. **Crashlytics** → Enable in the Crashlytics dashboard
6. **Performance** → Enable in the Performance dashboard

Deploy security rules:
```bash
firebase deploy --only firestore:rules
```

### 4. Set up local LLM (optional, for AI Chat)

```bash
bash scripts/setup_llm_vendor.sh
```

This downloads the Qwen3-1.7B model file required for on-device AI chat. The app works without it, but cat chat and AI diary features will be unavailable.

### 5. Run the app

```bash
flutter run                      # Standard run on connected device

# If USB install fails (INSTALL_FAILED_ABORTED on some devices):
flutter build apk
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture Overview](docs/architecture/overview.md) | System design, dependency flow, SSOT principles |
| [Data Model](docs/architecture/data-model.md) | Firestore schema, field definitions, indexes |
| [Cat System](docs/architecture/cat-system.md) | Game design SSOT — breeds, XP, moods, room slots |
| [State Management](docs/architecture/state-management.md) | Riverpod provider design and data flow |
| [Folder Structure](docs/architecture/folder-structure.md) | Directory layout and naming conventions |
| [PRD v3.0](docs/product/prd.md) | Full product requirements document |
| [User Stories](docs/product/user-stories.md) | Acceptance criteria per feature |
| [Firebase Setup](docs/firebase/setup-guide.md) | Step-by-step Firebase configuration guide |
| [Analytics Events](docs/firebase/analytics-events.md) | GA4 custom events reference (SSOT) |
| [Security Rules](docs/firebase/security-rules.md) | Firestore security rule specification |
| [Remote Config](docs/firebase/remote-config.md) | A/B test parameter definitions |
| [Design System](docs/design/design-system.md) | Material 3 theme spec, color roles, typography |
| [Screens](docs/design/screens.md) | Screen-by-screen UI specifications |
| [Website Deployment](docs/website/deployment.md) | hachimi.ai website deploy & maintenance |
| [Contributing](docs/CONTRIBUTING.md) | Development workflow, branch conventions |

---

## Architecture in Brief

**Dependency flow** (enforced — never skip layers):
```
Screens  →  Providers  →  Services  →  Firebase SDK
```

**SSOT map:**

| Concern | Source of Truth |
|---------|----------------|
| Business data | Firestore |
| Auth state | `authStateProvider` |
| Cats list | `catsProvider` |
| Timer state | `focusTimerProvider` |
| Coin balance | `coinBalanceProvider` |
| Inventory | `inventoryProvider` |
| Check-in state | `checkInProvider` |
| UI theme | `lib/core/theme/app_theme.dart` |
| Analytics events | `lib/core/constants/analytics_events.dart` |
| Cat game data | `lib/core/constants/cat_constants.dart` |
| LLM config | `lib/core/constants/llm_constants.dart` |
| Chat history | SQLite (via sqflite) |
| Dynamic config | Firebase Remote Config |

---

## Firestore Schema (Summary)

```
users/{uid}
├── habits/{habitId}              Habit metadata + streak tracking
│   └── sessions/{sessionId}     Focus session history (XP, duration, mode, coins, status)
├── cats/{catId}                  Cat state (XP, stage, mood, room slot, appearance)
└── monthlyCheckIns/{YYYY-MM}    Monthly check-in calendar (days map, streak, coins)
```

Full schema → [Data Model](docs/architecture/data-model.md)

---

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md).

## License

Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.

This source code is publicly available for portfolio and reference purposes only.
You may view and reference the code, but may not copy, modify, distribute, or use
it without explicit written permission. See [LICENSE](LICENSE) for full terms.
