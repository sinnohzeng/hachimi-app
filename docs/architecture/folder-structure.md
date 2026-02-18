# Project Folder Structure (SSOT)

> This document defines the authoritative directory layout and naming conventions for the Hachimi codebase. New files must follow these conventions exactly.

---

## Full Directory Tree

```
hachimi-app/
│
├── docs/                                   # DDD: All specification documents
│   ├── README.md                           # Documentation index
│   ├── CONTRIBUTING.md                     # Development workflow + conventions
│   ├── architecture/
│   │   ├── overview.md                     # System design + dependency flow
│   │   ├── data-model.md                   # Firestore schema (SSOT)
│   │   ├── cat-system.md                   # Cat game design (SSOT)
│   │   ├── state-management.md             # Riverpod provider graph (SSOT)
│   │   └── folder-structure.md             # This file
│   ├── product/
│   │   ├── prd.md                          # PRD v3.0 (SSOT)
│   │   └── user-stories.md                 # User stories + acceptance criteria
│   ├── firebase/
│   │   ├── setup-guide.md                  # Step-by-step Firebase setup
│   │   ├── analytics-events.md             # GA4 event definitions (SSOT)
│   │   ├── security-rules.md               # Firestore security rules spec
│   │   └── remote-config.md                # Remote Config parameter definitions
│   ├── design/
│   │   ├── design-system.md                # Material 3 theme spec (SSOT)
│   │   └── screens.md                      # Screen-by-screen UI specifications
│   └── zh-CN/                              # Chinese documentation mirror
│       ├── README.md
│       ├── CONTRIBUTING.md
│       ├── architecture/ ...
│       ├── product/ ...
│       ├── firebase/ ...
│       └── design/ ...
│
├── lib/                                    # Application source code
│   ├── main.dart                           # Entry point: Firebase + foreground task init
│   ├── app.dart                            # Root widget: AuthGate + _FirstHabitGate + MaterialApp
│   │
│   ├── core/                               # Shared cross-cutting concerns
│   │   ├── constants/
│   │   │   ├── analytics_events.dart       # SSOT: all GA4 event names + params
│   │   │   └── cat_constants.dart          # SSOT: breeds, stages, moods, room slots
│   │   ├── router/
│   │   │   └── app_router.dart             # Named route registry + route constants
│   │   └── theme/
│   │       └── app_theme.dart              # SSOT: Material 3 theme (seed color, typography)
│   │
│   ├── models/                             # Data models (Dart classes, no Flutter dependency)
│   │   ├── cat.dart                        # Cat — Firestore model + computed getters (stage, mood)
│   │   ├── habit.dart                      # Habit — Firestore model
│   │   ├── focus_session.dart              # FocusSession — session history record
│   │   └── check_in.dart                   # CheckInEntry — daily check-in entry (legacy compat)
│   │
│   ├── services/                           # Firebase SDK isolation layer (no UI, no BuildContext)
│   │   ├── analytics_service.dart          # Firebase Analytics wrapper — log events
│   │   ├── auth_service.dart               # Firebase Auth wrapper — sign in/out/up
│   │   ├── cat_generation_service.dart     # Draft algorithm — weighted breed selection
│   │   ├── firestore_service.dart          # Firestore CRUD + atomic batch operations
│   │   ├── focus_timer_service.dart        # Android foreground service wrapper
│   │   ├── notification_service.dart       # FCM + flutter_local_notifications
│   │   ├── remote_config_service.dart      # Remote Config — typed getters + defaults
│   │   └── xp_service.dart                 # XP calculation (pure Dart, no Firebase)
│   │
│   ├── providers/                          # Riverpod providers — reactive SSOT for each domain
│   │   ├── auth_provider.dart              # authStateProvider, currentUidProvider
│   │   ├── cat_provider.dart               # catsProvider, allCatsProvider, catByIdProvider (family)
│   │   ├── focus_timer_provider.dart       # focusTimerProvider (FSM state machine)
│   │   ├── connectivity_provider.dart      # connectivityProvider, isOfflineProvider
│   │   ├── habits_provider.dart            # habitsProvider, todayCheckInsProvider
│   │   └── stats_provider.dart             # statsProvider (computed HabitStats)
│   │
│   ├── screens/                            # Full-page widgets (consume providers, no business logic)
│   │   ├── auth/
│   │   │   └── login_screen.dart           # Login + Register (email/password + Google)
│   │   ├── cat_detail/
│   │   │   └── cat_detail_screen.dart      # Cat info, XP bar, heatmap, milestones
│   │   ├── cat_room/
│   │   │   └── cat_room_screen.dart        # Illustrated room scene with positioned cats
│   │   ├── habits/
│   │   │   └── adoption_flow_screen.dart   # 3-step habit creation + cat adoption
│   │   ├── home/
│   │   │   └── home_screen.dart            # 4-tab NavigationBar shell + Today tab
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart      # 3-page intro carousel
│   │   ├── profile/
│   │   │   └── profile_screen.dart         # Stats, cat album, settings
│   │   ├── stats/
│   │   │   └── stats_screen.dart           # Activity heatmap + per-habit progress
│   │   └── timer/
│   │       ├── focus_setup_screen.dart     # Duration + mode selector before starting
│   │       ├── focus_complete_screen.dart  # XP animation + session summary
│   │       └── timer_screen.dart           # Active timer with foreground service
│   │
│   └── widgets/                            # Reusable UI components (stateless preferred)
│       ├── cat_preview_card.dart           # Cat candidate card in adoption Step 2
│       ├── cat_sprite.dart                 # Cat display: breed tinting + stage/mood selection
│       ├── emoji_picker.dart               # Curated ~30-emoji grid for habit icon selection
│       ├── offline_banner.dart            # Offline indicator: cloud_off + sync message
│       ├── progress_ring.dart              # Circular progress indicator (timer ring)
│       ├── streak_heatmap.dart             # 91-day GitHub-style activity heatmap
│       └── streak_indicator.dart           # Fire badge showing current streak count
│
├── assets/
│   ├── sprites/                            # Cat sprite PNGs: cat_{stage}_{mood}.png
│   │   ├── cat_kitten_happy.png
│   │   ├── cat_kitten_neutral.png
│   │   ├── cat_kitten_sad.png
│   │   ├── cat_young_happy.png
│   │   ├── cat_young_neutral.png
│   │   ├── cat_young_sad.png
│   │   ├── cat_adult_happy.png
│   │   ├── cat_adult_neutral.png
│   │   ├── cat_adult_sad.png
│   │   ├── cat_shiny_happy.png
│   │   ├── cat_shiny_neutral.png
│   │   └── cat_shiny_sad.png
│   └── room/
│       ├── room_day.png                    # Daytime room background
│       └── room_night.png                  # Nighttime room background
│
├── android/                                # Android platform project
│   ├── app/
│   │   ├── google-services.json            # Firebase config (gitignored)
│   │   └── src/main/
│   │       └── AndroidManifest.xml         # Permissions + service declarations
│   └── ...
│
├── firestore.rules                         # Deployed Firestore security rules
├── firebase.json                           # Firebase project configuration
├── pubspec.yaml                            # Flutter dependencies
├── pubspec.lock                            # Locked dependency versions
├── README.md                               # English project overview (root)
└── README.zh-CN.md                         # Chinese project overview (root)
```

---

## Naming Conventions

| Category | Convention | Example |
|----------|-----------|---------|
| Dart files | `snake_case.dart` | `cat_generation_service.dart` |
| Classes | `PascalCase` | `CatGenerationService` |
| Constants | `camelCase` (variables), `kConstantName` (compile-time) | `catBreeds`, `kMaxRoomCats` |
| Providers | `camelCase` + `Provider` suffix | `catsProvider`, `focusTimerProvider` |
| Screens | `PascalCase` + `Screen` suffix | `CatRoomScreen` |
| Widgets | `PascalCase` descriptive noun | `CatSprite`, `StreakHeatmap` |
| Services | `PascalCase` + `Service` suffix | `FirestoreService` |
| Models | `PascalCase` noun | `Cat`, `Habit`, `FocusSession` |
| Assets | `snake_case` | `cat_kitten_happy.png`, `room_day.png` |
| Doc files | `kebab-case.md` | `data-model.md`, `cat-system.md` |

---

## Layer Rules

| Layer | Imports allowed | Imports forbidden |
|-------|----------------|------------------|
| `models/` | Only Dart core + `cloud_firestore` (for `Timestamp`) | Flutter, Services, Providers |
| `services/` | Models, Firebase SDK, Dart core | Flutter widgets, Providers, Screens |
| `providers/` | Services, Models, Riverpod | Flutter widgets, Screens |
| `screens/` | Providers, Widgets, Models (read-only), Router | Services (never import directly) |
| `widgets/` | Models (read-only), Theme | Services, Providers |
| `core/` | Dart core only | All others |

**Enforcement:** If a Screen needs to call a Service, it must do so through a Provider method, not by importing the Service directly. This keeps the dependency graph acyclic and testable.

---

## One Class Per File

Each Dart file contains exactly one public class (or one public top-level function for utilities). Small private helper classes (prefixed with `_`) may live in the same file as the public class they support.

**Good:** `cat_room_screen.dart` contains `CatRoomScreen` and private `_SpeechBubble`
**Bad:** `screens.dart` containing `CatRoomScreen`, `CatDetailScreen`, and `TimerScreen`
