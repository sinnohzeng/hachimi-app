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
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License" />
</p>

---

## What is Hachimi?

Hachimi is a **cat-parenting habit app** where every habit you create comes with a virtual kitten to raise. Focus on your habit → earn XP → watch your cat evolve from a tiny kitten into a glowing shiny adult. The cozy Cat Room fills up as you build more habits, creating a living visual record of your growth.

The core loop:

> **Create habit → Adopt kitten → Start focus timer → Earn XP → Cat evolves**

---

## Features

### 🐱 Cat Adoption System
- Each habit adopts a unique kitten from a draft of 3 randomly generated candidates
- 10 breeds × 6 personalities × 4 rarity tiers (common / uncommon / rare)
- Cats evolve through 4 growth stages: **Kitten → Young → Adult → Shiny**
- Cat mood reacts to your consistency: Happy → Neutral → Lonely → Missing

### ⏱️ Focus Timer
- Countdown mode (set a target) and Stopwatch mode (open-ended)
- Persistent Android foreground service — timer survives app minimization
- Auto-pause after 15 s away; auto-end after 5 min away
- XP formula: base (1 XP/min) + streak bonus + milestone bonus + full-house bonus

### 🏠 Cat Room
- Cozy illustrated room scene with all active cats
- Day/night ambience based on system time
- Tap a cat → speech bubble + quick-action sheet (Start Focus / View Details)
- Personality-based slot placement (lazy cats prefer the sofa, curious cats claim the windowsill)

### 📊 Stats & Cat Album
- GitHub-style 91-day activity heatmap per habit
- Today's summary (minutes, total hours, cat count)
- Full cat album with rarity breakdown (active, dormant, graduated cats)

### 🔔 Notifications
- Daily reminders at your chosen time (per habit)
- Streak-at-risk alert at 20:00 if no session that day and streak ≥ 3
- Level-up celebration notification

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| UI Framework | Flutter | 3.41.1 | Cross-platform mobile |
| Language | Dart | 3.11.0 | Type-safe, null-safe |
| Design System | Material Design 3 | — | Consistent UI theming |
| State Management | Riverpod | 2.6.1 | Reactive SSOT providers |
| Auth | Firebase Auth | 5.x | Google + email sign-in |
| Database | Cloud Firestore | 5.x | Real-time data sync |
| Analytics | Firebase Analytics | 11.x | GA4 event tracking |
| Push Notifications | Firebase Messaging | 15.x | Server-triggered FCM |
| Local Notifications | flutter_local_notifications | 18.x | Scheduled daily reminders |
| Background Timer | flutter_foreground_task | 8.x | Android foreground service |
| A/B Testing | Firebase Remote Config | 5.x | Dynamic configuration |
| Crash Reporting | Firebase Crashlytics | 4.x | Production error tracking |

---

## Project Structure

```
lib/
├── app.dart                    # Root widget + AuthGate + _FirstHabitGate
├── main.dart                   # Entry point, Firebase + foreground task init
├── core/
│   ├── constants/
│   │   ├── analytics_events.dart    # SSOT: all GA4 event names & params
│   │   └── cat_constants.dart       # SSOT: breeds, stages, moods, room slots
│   ├── router/
│   │   └── app_router.dart          # Named route registry
│   └── theme/
│       └── app_theme.dart           # SSOT: Material 3 theme (seed color)
├── models/
│   ├── cat.dart                     # Cat — Firestore model + computed getters
│   ├── habit.dart                   # Habit — Firestore model
│   ├── focus_session.dart           # FocusSession — session history
│   └── check_in.dart                # CheckInEntry — daily check-in entries
├── providers/
│   ├── auth_provider.dart           # SSOT: auth state (currentUser, uid)
│   ├── cat_provider.dart            # SSOT: cats stream + family providers
│   ├── focus_timer_provider.dart    # SSOT: timer state machine (FSM)
│   ├── habits_provider.dart         # SSOT: habits stream + today minutes
│   └── stats_provider.dart          # SSOT: computed stats (HabitStats)
├── services/
│   ├── analytics_service.dart       # Firebase Analytics wrapper
│   ├── auth_service.dart            # Firebase Auth wrapper
│   ├── cat_generation_service.dart  # Draft algorithm (weighted breed selection)
│   ├── firestore_service.dart       # Firestore CRUD + atomic batch ops
│   ├── focus_timer_service.dart     # Android foreground task wrapper
│   ├── notification_service.dart    # FCM + flutter_local_notifications
│   ├── remote_config_service.dart   # Remote Config keys + typed getters
│   └── xp_service.dart             # XP & level-up calculation (pure Dart)
├── screens/
│   ├── auth/login_screen.dart
│   ├── cat_detail/cat_detail_screen.dart
│   ├── cat_room/cat_room_screen.dart
│   ├── habits/adoption_flow_screen.dart
│   ├── home/home_screen.dart
│   ├── onboarding/onboarding_screen.dart
│   ├── profile/profile_screen.dart
│   ├── stats/stats_screen.dart
│   └── timer/
│       ├── focus_setup_screen.dart
│       ├── focus_complete_screen.dart
│       └── timer_screen.dart
└── widgets/
    ├── cat_preview_card.dart   # Adoption draft candidate card
    ├── cat_sprite.dart         # Cat display with breed color tinting
    ├── emoji_picker.dart       # Curated emoji grid for habit icons
    ├── progress_ring.dart      # Circular progress indicator for timer
    ├── streak_heatmap.dart     # 91-day GitHub-style activity heatmap
    └── streak_indicator.dart   # Fire badge for current streak
```

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
git clone https://github.com/your-username/hachimi-app.git
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

Deploy security rules:
```bash
firebase deploy --only firestore:rules
```

### 4. Run the app

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
| UI theme | `lib/core/theme/app_theme.dart` |
| Analytics events | `lib/core/constants/analytics_events.dart` |
| Cat game data | `lib/core/constants/cat_constants.dart` |
| Dynamic config | Firebase Remote Config |

---

## Firestore Schema (Summary)

```
users/{uid}
├── habits/{habitId}            Habit metadata + streak tracking
│   └── sessions/{sessionId}   Focus session history (XP, duration, mode)
├── cats/{catId}                Cat state (XP, stage, mood, room slot)
└── checkIns/{date}
    └── entries/{entryId}       Daily minute logs (backward compat)
```

Full schema → [Data Model](docs/architecture/data-model.md)

---

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md).

## License

MIT © 2024 Hachimi
