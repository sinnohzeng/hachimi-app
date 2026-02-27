# Architecture Overview

> **SSOT**: This document is the authoritative reference for system architecture. All implementation decisions must align with the principles described here.

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| UI Framework | Flutter | 3.41.x stable | Cross-platform mobile (iOS + Android) |
| Language | Dart | 3.11.x | Type-safe, null-safe development |
| Design System | Material Design 3 | — | Google-aligned UI components and theming |
| State Management | Riverpod | 3.x | Reactive, compile-safe dependency injection |
| Auth | Firebase Auth | 5.x | Google OAuth + email/password |
| Database | Cloud Firestore | 5.x | Real-time NoSQL, offline-capable |
| Analytics | Firebase Analytics (GA4) | 11.x | Event-based behavioral analytics |
| Push | Firebase Cloud Messaging | 15.x | Server-triggered push notifications |
| Local Notifications | flutter_local_notifications | 18.x | Scheduled daily habit reminders |
| Background Timer | flutter_foreground_task | 8.x | Android foreground service for focus timer |
| A/B Testing | Firebase Remote Config | 5.x | Dynamic config, feature flags |
| Crash Reporting | Firebase Crashlytics | 4.x | Production error monitoring |
| Connectivity | connectivity_plus | 7.x | Device network status monitoring |
| Local Database | sqflite | 2.4.x | Local-first SQLite storage (action ledger, materialized state) |
| UUID | uuid | 4.5.x | Deterministic unique IDs for local entities |
| i18n | flutter_localizations + gen-l10n | — | Compile-time localization via ARB files |
| Cloud AI | MiniMax M2.5 / Gemini 3 Flash | — | Cloud LLM via AiProvider strategy pattern (dart:io HttpClient, user-selectable) |
| Dynamic Background | mesh_gradient | 1.3.x | GPU-accelerated fluid mesh gradient via fragment shader |
| Particle Effects | atmospheric_particles | 0.3.x | Lightweight floating particle overlay (Isolate-based) |

---

## Layer Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                          Flutter App                             │
├─────────────────────────────────────────────────────────────────┤
│  Screens  (UI Layer — no business logic)                        │
│  ├── OnboardingScreen          ├── CatRoomScreen                │
│  ├── LoginScreen               ├── CatDetailScreen              │
│  ├── HomeScreen (3-tab + Drawer) ├── FocusSetupScreen            │
│  ├── AdoptionFlowScreen        ├── TimerScreen                  │
│  ├── StatsScreen               ├── FocusCompleteScreen          │
├─────────────────────────────────────────────────────────────────┤
│  Providers  (State Layer — Riverpod, reactive SSOT)            │
│  ├── authStateProvider         ├── focusTimerProvider           │
│  ├── currentUidProvider        ├── statsProvider                │
│  ├── habitsProvider            ├── todayMinutesPerHabitProvider │
│  ├── todayCheckInsProvider     ├── catsProvider                 │
│  ├── catByIdProvider (family)  ├── pixelCatRendererProvider     │
│  ├── catByHabitProvider (fam.) ├── catSpriteImageProvider (fam.)│
│  ├── connectivityProvider      ├── coinBalanceProvider          │
│  ├── isOfflineProvider         ├── hasCheckedInTodayProvider    │
│  ├── isAnonymousProvider       ├── ledgerServiceProvider        │
│  ├── syncEngineProvider        ├── newlyUnlockedProvider        │
│  ├── userProfileNotifierProv. └── avatarIdProvider              │
├─────────────────────────────────────────────────────────────────┤
│  Services  (Data Layer — business logic, no UI)                │
│  ├── AuthService               ├── XpService (pure Dart)        │
│  ├── UserProfileService        ├── NotificationService          │
│  ├── PixelCatRenderer          ├── RemoteConfigService          │
│  ├── PixelCatGenerationService ├── FocusTimerService            │
│  ├── CoinService               ├── MigrationService             │
│  ├── LedgerService             ├── AnalyticsService             │
│  ├── AchievementEvaluator      ├── SyncEngine                   │
│  ├── LocalHabitRepository      ├── LocalCatRepository           │
│  └── LocalSessionRepository                                     │
├─────────────────────────────────────────────────────────────────┤
│  Backend Abstraction (core/backend/ — Strategy Pattern)         │
│  ├── AuthBackend               ├── AnalyticsBackend             │
│  ├── SyncBackend               ├── CrashBackend                 │
│  ├── UserProfileBackend        ├── RemoteConfigBackend          │
│  └── BackendRegistry (region → global / china)                  │
├─────────────────────────────────────────────────────────────────┤
│  Firebase Implementations (services/firebase/)                  │
│  ├── FirebaseAuthBackend       ├── FirebaseAnalyticsBackend     │
│  ├── FirebaseSyncBackend       ├── FirebaseCrashBackend         │
│  ├── FirebaseUserProfileBackend├── FirebaseRemoteConfigBackend  │
├─────────────────────────────────────────────────────────────────┤
│  Firebase SDK                                                   │
│  ├── firebase_auth             ├── firebase_remote_config        │
│  ├── cloud_firestore           ├── firebase_crashlytics         │
│  ├── firebase_analytics        ├── flutter_local_notifications   │
│  ├── firebase_messaging        └── flutter_foreground_task      │
└─────────────────────────────────────────────────────────────────┘
```

---

## Design Principles

### 1. Document-Driven Development (DDD)

All interfaces and behaviors are specified in `docs/` **before** implementation. Documents are the contract; code is the implementation. When a document and code conflict, the document takes precedence (fix the code, update the document only with deliberate intent).

### 2. Single Source of Truth (SSOT)

Every concern in the system has exactly one authoritative source:

| Concern | SSOT Location |
|---------|--------------|
| Business data (SSOT) | SQLite local tables (synced to Firestore via SyncEngine) |
| Action ledger | `action_ledger` table in `local_database_service.dart` |
| Materialized state (coins, etc.) | `materialized_state` table in `local_database_service.dart` |
| Achievement records | `local_achievements` table in `local_database_service.dart` |
| Authentication state | `authStateProvider` in `providers/auth_provider.dart` |
| Cats list | `catsProvider` in `providers/cat_provider.dart` |
| Cat sprites | `catSpriteImageProvider` in `providers/cat_sprite_provider.dart` |
| Coin balance | `coinBalanceProvider` in `providers/coin_provider.dart` |
| Timer state | `focusTimerProvider` in `providers/focus_timer_provider.dart` |
| Computed stats | `statsProvider` in `providers/stats_provider.dart` |
| UI theme | `lib/core/theme/app_theme.dart` |
| Analytics event names | `lib/core/constants/analytics_events.dart` |
| Cat game metadata | `lib/core/constants/cat_constants.dart` |
| Pixel cat appearance params | `lib/core/constants/pixel_cat_constants.dart` |
| Named routes | `lib/core/router/app_router.dart` |
| Dynamic configuration | Firebase Remote Config (keys in `remote_config_service.dart`) |
| Device connectivity | `connectivityProvider` in `providers/connectivity_provider.dart` |
| Localized strings | `lib/l10n/app_en.arb` (source) + generated `AppLocalizations` |

### 3. Strict Dependency Flow

```
Screens  ->  Providers  ->  Services  ->  Backend Abstractions  ->  Firebase/CloudBase SDK
```

**Rules:**
- Screens only read from Providers (via `ref.watch` / `ref.read`) — never import Services directly
- Providers orchestrate Services and expose reactive state — never access Firebase SDK directly
- Services depend on backend abstractions (`core/backend/`), not Firebase SDK classes directly
- Firebase-specific implementations live in `services/firebase/` — the only directory that imports Firebase SDK
- Pure computation (XP, cat generation) lives in Services with no backend dependency

### 4. Reactive over Imperative

Prefer `StreamProvider` and `ref.watch()` over one-shot `Future` fetches. State flows down automatically — screens rebuild when upstream data changes without manual `setState` calls.

### 5. Atomic Firestore Operations

Operations that span multiple documents (e.g., creating a habit + cat, logging a focus session) use Firestore **batch writes** to guarantee consistency. If any write fails, all writes roll back.

### 6. Local-First Architecture

Since v2.18.0, business data flows through a **local-first** pipeline:

1. **Action Ledger** — Every data-mutating operation (focus complete, check-in, purchase, equip, habit CRUD) is recorded as an immutable `LedgerAction` in the `action_ledger` SQLite table. The ledger is the write-ahead log.

2. **Materialized State** — Derived aggregates (coin balance, check-in status) are cached in the `materialized_state` key-value table, updated atomically within the same SQLite transaction as the ledger write.

3. **Local Tables** — `local_habits`, `local_cats`, `local_sessions`, `local_monthly_checkins`, `local_achievements` mirror the Firestore schema but are the runtime SSOT. Providers read from these tables, not Firestore.

4. **Sync Engine** — `SyncEngine` runs in the background, uploading unsynced ledger actions to Firestore in batches. Triggered on: auth complete, offline->online transition, new ledger write (debounced 2s). Uses exponential backoff retry. 90-day ledger cleanup.

5. **Achievement Evaluator** — `AchievementEvaluator` listens to the ledger change stream and automatically evaluates achievement criteria, replacing manual trigger calls.

### 7. Multi-Backend Abstraction

Since v2.20.0, all cloud SDK interactions are isolated behind abstract backend interfaces in `lib/core/backend/`. This enables:

- **Region switching** — Global (Firebase) and China (Tencent CloudBase) deployments from a single codebase
- **Testability** — Services depend on abstractions, not Firebase SDK classes
- **Future-proofing** — Adding a new backend requires implementing the interfaces without touching business logic

The pattern follows the existing `AiProvider` Strategy Pattern (`lib/core/ai/ai_provider.dart`). A `BackendRegistry` holds all backend instances for the current region, injected via `backendRegistryProvider`. Individual backend providers (`authBackendProvider`, `syncBackendProvider`, etc.) provide convenient access.

```
BackendRegistry (backendRegionProvider → global | china)
  ├── AuthBackend        ← signIn/signUp/link/delete
  ├── SyncBackend        ← batch write/hydrate (SyncOperation abstraction)
  ├── UserProfileBackend ← create/sync profile
  ├── AnalyticsBackend   ← logEvent/setUserProperty
  ├── CrashBackend       ← recordError/log
  └── RemoteConfigBackend← getString/getBool/fetchAndActivate
```

### 8. Internationalization (i18n)

All user-facing strings are externalized into ARB files (`lib/l10n/app_en.arb`, `lib/l10n/app_zh.arb`) and compiled to Dart via `flutter gen-l10n`. Hard-coded user-facing strings are not permitted in screens or widgets. See [localization.md](localization.md) for the full workflow.

---

## Navigation

The app uses Flutter's `Navigator 1.0` with named routes managed by `AppRouter`:

```
/login              -> LoginScreen         (args: linkMode: bool)
/home               -> HomeScreen (3-tab NavigationBar + Drawer)
                       Tabs: Today, CatRoom, Achievement
                       Profile is in the Drawer (via AppDrawer widget)
/adoption           -> AdoptionFlowScreen  (args: isFirstHabit: bool)
/focus-setup        -> FocusSetupScreen    (args: habitId: String)
/timer              -> TimerScreen         (args: habitId: String)
/focus-complete     -> FocusCompleteScreen (args: Map<String, dynamic>)
/habit-detail       -> HabitDetailScreen   (args: habitId: String)
/cat-detail         -> CatDetailScreen     (args: catId: String)
/ai-settings        -> AiSettingsPage
```

**Root routing** is managed by `AuthGate` -> `_FirstHabitGate`:
1. `AuthGate` checks onboarding completion (SharedPreferences) and Firebase Auth state
2. `_FirstHabitGate` detects first-time users (zero habits) and auto-navigates to adoption flow

---

## Authentication Flow

```
App Launch
    │
    ▼
AuthGate
    ├── onboarding not complete -> OnboardingScreen
    │       └── complete -> AuthGate (loop)
    │
    └── onboarding complete
            │
            ▼
        Firebase Auth stream
            ├── user == null -> auto signInAnonymously() (guest mode)
            │       └── success -> _FirstHabitGate
            └── user != null -> _FirstHabitGate
                    ├── habits.isEmpty -> AdoptionFlow (isFirstHabit: true)
                    └── habits.any -> HomeScreen
```

**Guest Mode:** New users automatically receive an anonymous Firebase Auth account. They can upgrade to a full account (Google or email) at any time via the Drawer -> guest upgrade prompt. Account linking uses `linkWithCredential()` to preserve all data.

**AuthService** now supports: `signInAnonymously()`, `linkWithGoogle()`, `linkWithEmail()`, and an `isAnonymous` getter.

---

## State Management in Detail

See [state-management.md](state-management.md) for full provider graph.

**Key patterns used:**

| Pattern | Use Case | Example |
|---------|----------|---------|
| `StreamProvider` | Firestore real-time streams | `habitsProvider`, `catsProvider`, `coinBalanceProvider` |
| `FutureProvider.family` | Async per-key computation | `catSpriteImageProvider(catId)` |
| `StateNotifierProvider` | Mutable local state with methods | `focusTimerProvider` |
| `Provider` | Computed/derived values | `statsProvider`, `hasCheckedInTodayProvider` |
| `Provider.family` | Parameterized lookups | `catByIdProvider(catId)`, `catByHabitProvider(habitId)` |
| `ref.watch()` | Reactive subscription in `build()` | All screen `build` methods |
| `ref.read()` | One-shot read in event handlers | Button `onPressed` callbacks |

---

## Background Timer Architecture

The focus timer is a **two-isolate system**:

1. **Main isolate** — `FocusTimerNotifier` (Riverpod) owns the authoritative timer state. It uses `Timer.periodic(1s)` and exposes the full `FocusTimerState` to the UI.

2. **Background isolate** — `flutter_foreground_task` runs a minimal `_TimerTaskHandler` in a separate isolate. Its sole job is to keep the Android foreground service alive and display the persistent notification. The main isolate updates the notification text via `FocusTimerService.updateNotification()` each tick.

`AppLifecycleState` changes are observed via `WidgetsBindingObserver`:
- `paused` / `hidden` -> record timestamp (`onAppBackgrounded`)
- `resumed` -> calculate away duration; auto-pause if >15 s, auto-end if >5 min (`onAppResumed`). Also checks `FlutterForegroundTask.isRunningService` and restarts the foreground service if the OS killed it while backgrounded.

---

## Notification Architecture

The focus timer uses a **three-layer notification system**, each serving a distinct purpose:

| Layer | Plugin | Channel ID | Purpose | When Active |
|-------|--------|------------|---------|-------------|
| Foreground Service | `flutter_foreground_task` | `hachimi_focus` | Persistent timer notification (keeps process alive) | While timer is running |
| Atomic Island | Native MethodChannel | `hachimi_focus_timer_v2` | vivo Atomic Island + Android 16 lockscreen rich notification | While timer is running (vivo only) |
| Completion | `flutter_local_notifications` | `hachimi_focus_complete` | One-shot completion alert with XP summary | When countdown finishes |

**Foreground Service notification** includes Pause/End action buttons that communicate with the main isolate via `FlutterForegroundTask.sendDataToMain()` / `addTaskDataCallback()`. The main isolate updates the notification text each tick via `FocusTimerService.updateNotification()`.

**Atomic Island** provides a rich, platform-native timer display on supported devices (vivo OriginOS). See `docs/architecture/atomic-island.md`.

**Completion notification** fires from `_onTick()` when a countdown reaches zero — this works even when the app is backgrounded since the notification is sent from the main isolate. Uses a fixed notification ID (`300000`) so duplicate sends (from both `_onTick()` and `_saveSession()`) simply overwrite rather than stack.

**L10N for notification text**: Since providers have no `BuildContext`, localized labels (`labelRemaining`, `labelElapsed`, `labelFocusing`, `labelDefaultCat`, `labelInProgress`) are passed to `FocusTimerNotifier.configure()` at setup time from `FocusSetupScreen`, which has access to `context.l10n`. English fallbacks are used when labels are empty.
