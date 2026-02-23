# Architecture Overview

> **SSOT**: This document is the authoritative reference for system architecture. All implementation decisions must align with the principles described here.

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| UI Framework | Flutter | 3.41.x stable | Cross-platform mobile (iOS + Android) |
| Language | Dart | 3.11.x | Type-safe, null-safe development |
| Design System | Material Design 3 | — | Google-aligned UI components and theming |
| State Management | Riverpod | 2.6.x | Reactive, compile-safe dependency injection |
| Auth | Firebase Auth | 5.x | Google OAuth + email/password |
| Database | Cloud Firestore | 5.x | Real-time NoSQL, offline-capable |
| Analytics | Firebase Analytics (GA4) | 11.x | Event-based behavioral analytics |
| Push | Firebase Cloud Messaging | 15.x | Server-triggered push notifications |
| Local Notifications | flutter_local_notifications | 18.x | Scheduled daily habit reminders |
| Background Timer | flutter_foreground_task | 8.x | Android foreground service for focus timer |
| A/B Testing | Firebase Remote Config | 5.x | Dynamic config, feature flags |
| Crash Reporting | Firebase Crashlytics | 4.x | Production error monitoring |
| Connectivity | connectivity_plus | 6.x | Device network status monitoring |
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
│  ├── HomeScreen (4-tab shell)  ├── FocusSetupScreen             │
│  ├── AdoptionFlowScreen        ├── TimerScreen                  │
│  ├── StatsScreen               ├── FocusCompleteScreen          │
│  └── ProfileScreen                                              │
├─────────────────────────────────────────────────────────────────┤
│  Providers  (State Layer — Riverpod, reactive SSOT)            │
│  ├── authStateProvider         ├── focusTimerProvider           │
│  ├── currentUidProvider        ├── statsProvider                │
│  ├── habitsProvider            ├── todayMinutesPerHabitProvider │
│  ├── todayCheckInsProvider     ├── catsProvider                 │
│  ├── catByIdProvider (family)  ├── pixelCatRendererProvider     │
│  ├── catByHabitProvider (fam.) ├── catSpriteImageProvider (fam.)│
│  ├── connectivityProvider      ├── coinBalanceProvider          │
│  ├── isOfflineProvider         └── hasCheckedInTodayProvider    │
├─────────────────────────────────────────────────────────────────┤
│  Services  (Data Layer — Firebase SDK isolation)               │
│  ├── AuthService               ├── XpService (pure Dart)        │
│  ├── FirestoreService          ├── NotificationService          │
│  ├── CatFirestoreService       ├── RemoteConfigService          │
│  ├── PixelCatRenderer          ├── FocusTimerService            │
│  ├── PixelCatGenerationService ├── MigrationService             │
│  ├── CoinService               └── AnalyticsService             │
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
| Business data | Firestore |
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
Screens  ->  Providers  ->  Services  ->  Firebase SDK
```

**Rules:**
- Screens only read from Providers (via `ref.watch` / `ref.read`) — never import Services directly
- Providers orchestrate Services and expose reactive state — never access Firebase SDK directly
- Services encapsulate all Firebase SDK interactions — no UI code, no BuildContext
- Pure computation (XP, cat generation) lives in Services with no Firebase dependency

### 4. Reactive over Imperative

Prefer `StreamProvider` and `ref.watch()` over one-shot `Future` fetches. State flows down automatically — screens rebuild when upstream data changes without manual `setState` calls.

### 5. Atomic Firestore Operations

Operations that span multiple documents (e.g., creating a habit + cat, logging a focus session) use Firestore **batch writes** to guarantee consistency. If any write fails, all writes roll back.

### 6. Internationalization (i18n)

All user-facing strings are externalized into ARB files (`lib/l10n/app_en.arb`, `lib/l10n/app_zh.arb`) and compiled to Dart via `flutter gen-l10n`. Hard-coded user-facing strings are not permitted in screens or widgets. See [localization.md](localization.md) for the full workflow.

---

## Navigation

The app uses Flutter's `Navigator 1.0` with named routes managed by `AppRouter`:

```
/login              -> LoginScreen
/home               -> HomeScreen (4-tab NavigationBar shell)
/adoption           -> AdoptionFlowScreen  (args: isFirstHabit: bool)
/focus-setup        -> FocusSetupScreen    (args: habitId: String)
/timer              -> TimerScreen         (args: habitId: String)
/focus-complete     -> FocusCompleteScreen (args: Map<String, dynamic>)
/habit-detail       -> HabitDetailScreen   (args: habitId: String)
/cat-detail         -> CatDetailScreen     (args: catId: String)
/profile            -> ProfileScreen
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
            ├── user == null -> LoginScreen
            └── user != null -> _FirstHabitGate
                    ├── habits.isEmpty -> AdoptionFlow (isFirstHabit: true)
                    └── habits.any -> HomeScreen
```

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
