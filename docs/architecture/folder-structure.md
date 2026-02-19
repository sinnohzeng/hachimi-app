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
│   │   ├── folder-structure.md             # This file
│   │   └── localization.md                 # i18n approach + ARB workflow
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
│   │   │   ├── cat_constants.dart          # SSOT: stages, moods, personalities
│   │   │   └── pixel_cat_constants.dart    # SSOT: appearance parameter value sets for pixel-cat-maker
│   │   ├── router/
│   │   │   └── app_router.dart             # Named route registry + route constants
│   │   └── theme/
│   │       └── app_theme.dart              # SSOT: Material 3 theme (seed color, typography)
│   │
│   ├── l10n/                               # Localization ARB source files
│   │   ├── app_en.arb                      # English strings (primary)
│   │   └── app_zh.arb                      # Chinese strings
│   │
│   ├── models/                             # Data models (Dart classes, no Flutter dependency)
│   │   ├── cat.dart                        # Cat — Firestore model + computed getters (stage, mood)
│   │   ├── cat_appearance.dart             # CatAppearance — pixel-cat-maker parameter value object
│   │   ├── habit.dart                      # Habit — Firestore model
│   │   ├── focus_session.dart              # FocusSession — session history record
│   │   └── check_in.dart                   # CheckInEntry — daily check-in entry (legacy compat)
│   │
│   ├── services/                           # Firebase SDK isolation layer (no UI, no BuildContext)
│   │   ├── analytics_service.dart          # Firebase Analytics wrapper — log events
│   │   ├── auth_service.dart               # Firebase Auth wrapper — sign in/out/up
│   │   ├── cat_firestore_service.dart      # Cat-specific Firestore CRUD (watchCats, watchAllCats)
│   │   ├── coin_service.dart               # Coin balance + accessory purchase operations
│   │   ├── firestore_service.dart          # General Firestore CRUD + atomic batch operations
│   │   ├── focus_timer_service.dart        # Android foreground service wrapper
│   │   ├── migration_service.dart          # Data migration for schema evolution (e.g. breed -> appearance)
│   │   ├── notification_service.dart       # FCM + flutter_local_notifications
│   │   ├── pixel_cat_generation_service.dart # Random cat generation — appearance + personality
│   │   ├── pixel_cat_renderer.dart         # 13-layer sprite compositor (pixel-cat-maker engine)
│   │   ├── remote_config_service.dart      # Remote Config — typed getters + defaults
│   │   └── xp_service.dart                 # XP calculation (pure Dart, no Firebase)
│   │
│   ├── providers/                          # Riverpod providers — reactive SSOT for each domain
│   │   ├── auth_provider.dart              # authStateProvider, currentUidProvider
│   │   ├── cat_provider.dart               # catsProvider, allCatsProvider, catByIdProvider (family)
│   │   ├── cat_sprite_provider.dart        # pixelCatRendererProvider, catSpriteImageProvider (family)
│   │   ├── accessory_provider.dart          # AccessoryInfo data class for shop + equip UI
│   │   ├── coin_provider.dart              # coinServiceProvider, coinBalanceProvider, hasCheckedInTodayProvider
│   │   ├── connectivity_provider.dart      # connectivityProvider, isOfflineProvider
│   │   ├── focus_timer_provider.dart       # focusTimerProvider (FSM + SharedPreferences persistence)
│   │   ├── habits_provider.dart            # habitsProvider, todayCheckInsProvider
│   │   ├── locale_provider.dart            # localeProvider (app language override)
│   │   ├── stats_provider.dart             # statsProvider (computed HabitStats)
│   │   └── theme_provider.dart             # themeProvider (theme mode + seed color)
│   │
│   ├── screens/                            # Full-page widgets (consume providers, no business logic)
│   │   ├── auth/
│   │   │   └── login_screen.dart           # Login + Register (email/password + Google)
│   │   ├── cat_detail/
│   │   │   └── cat_detail_screen.dart      # Cat info, progress bar, heatmap, accessories
│   │   ├── cat_room/
│   │   │   ├── cat_room_screen.dart        # 2-column CatHouse grid with pixel-art cats
│   │   │   └── accessory_shop_screen.dart  # Accessory shop: 3-tab grid + purchase flow
│   │   ├── habits/
│   │   │   └── adoption_flow_screen.dart   # 3-step habit creation + 3-cat adoption choice
│   │   ├── home/
│   │   │   └── home_screen.dart            # 4-tab NavigationBar shell + Today tab
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart      # 3-page intro carousel
│   │   ├── profile/
│   │   │   └── profile_screen.dart         # Stats, cat album, settings entry
│   │   ├── settings/
│   │   │   └── settings_screen.dart        # Notifications, language, about, account actions
│   │   ├── stats/
│   │   │   └── stats_screen.dart           # Activity heatmap + per-habit progress
│   │   └── timer/
│   │       ├── focus_setup_screen.dart     # Duration + mode selector before starting
│   │       ├── focus_complete_screen.dart  # XP animation + session summary
│   │       └── timer_screen.dart           # Active timer with foreground service
│   │
│   └── widgets/                            # Reusable UI components (stateless preferred)
│       ├── accessory_card.dart             # Reusable accessory card (name, price badge, owned badge)
│       ├── accessory_shop_section.dart     # Accessory grid in CatDetailScreen + purchase flow
│       ├── cat_house_card.dart             # Single cat card in CatHouse 2-column grid
│       ├── check_in_banner.dart            # Daily check-in coin bonus banner on HomeScreen
│       ├── emoji_picker.dart               # Categorized emoji picker (~200 emojis in 7 tabs + quick pick)
│       ├── offline_banner.dart             # Offline indicator: cloud_off + sync message
│       ├── pixel_cat_sprite.dart           # Pixel-art cat display widget (renders ui.Image from provider)
│       ├── progress_ring.dart              # Circular progress indicator (timer ring)
│       ├── streak_heatmap.dart             # 91-day GitHub-style activity heatmap
│       └── streak_indicator.dart           # Fire badge showing current streak count
│
├── assets/
│   ├── pixel_cat/                          # Pixel-cat-maker sprite layers
│   │   ├── body/                           # Base body sprites by peltType + variant
│   │   ├── pelt/                           # Pelt color overlays
│   │   ├── white/                          # White patch patterns
│   │   ├── white_tint/                     # White patch tint overlays
│   │   ├── points/                         # Color-point patterns (Siamese etc.)
│   │   ├── vitiligo/                       # Vitiligo patch overlay
│   │   ├── tortie/                         # Tortoiseshell base layers
│   │   ├── tortie_pattern/                 # Tortoiseshell pattern variants
│   │   ├── tortie_color/                   # Tortoiseshell color overlays
│   │   ├── fur/                            # Fur length overlays (long/short)
│   │   ├── eyes/                           # Eye color sprites
│   │   ├── skin/                           # Skin (nose/ear) color sprites
│   │   ├── tint/                           # Overall tint overlays
│   │   └── accessories/                    # Accessory overlay sprites
│   └── room/
│       ├── room_day.png                    # Daytime room background
│       └── room_night.png                  # Nighttime room background
│
├── l10n.yaml                               # Flutter gen-l10n configuration
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
| Dart files | `snake_case.dart` | `pixel_cat_renderer.dart` |
| Classes | `PascalCase` | `PixelCatRenderer` |
| Constants | `camelCase` (variables), `kConstantName` (compile-time) | `catPersonalities`, `kMaxCoins` |
| Providers | `camelCase` + `Provider` suffix | `catsProvider`, `coinBalanceProvider` |
| Screens | `PascalCase` + `Screen` suffix | `CatRoomScreen` |
| Widgets | `PascalCase` descriptive noun | `PixelCatSprite`, `CatHouseCard` |
| Services | `PascalCase` + `Service` suffix | `CatFirestoreService`, `CoinService` |
| Models | `PascalCase` noun | `Cat`, `CatAppearance`, `Habit` |
| Assets | `snake_case` | `body_tabby_0.png`, `room_day.png` |
| Doc files | `kebab-case.md` | `data-model.md`, `cat-system.md` |
| ARB keys | `screenName` + purpose in camelCase | `homeTabToday`, `adoptionConfirmButton` |

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
| `l10n/` | (Generated) Dart core only | All others |

**Enforcement:** If a Screen needs to call a Service, it must do so through a Provider method, not by importing the Service directly. This keeps the dependency graph acyclic and testable.

---

## One Class Per File

Each Dart file contains exactly one public class (or one public top-level function for utilities). Small private helper classes (prefixed with `_`) may live in the same file as the public class they support.

**Good:** `cat_room_screen.dart` contains `CatRoomScreen` and private `_CatHouseGridDelegate`
**Bad:** `screens.dart` containing `CatRoomScreen`, `CatDetailScreen`, and `TimerScreen`
