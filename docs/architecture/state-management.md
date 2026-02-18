# State Management — Riverpod (SSOT)

> **SSOT**: This document is the authoritative reference for the Riverpod provider graph. Every provider is the single source of truth for its domain. Implementation in `lib/providers/` must match this specification.

---

## Provider Graph

```
Firebase Auth stream ─────────────────────────► authStateProvider (StreamProvider<User?>)
                                                       │
                                                       ▼
                                              currentUidProvider (Provider<String?>)
                                                       │
                              ┌────────────────────────┼────────────────────────┐
                              ▼                        ▼                        ▼
                   habitsProvider              catsProvider            allCatsProvider
              (StreamProvider<List<Habit>>)   (StreamProvider<List<Cat>>) (StreamProvider<List<Cat>>)
                              │                        │
                   ┌──────────┴───────────┐   ┌───────┴──────────┐
                   ▼                     ▼   ▼                  ▼
        todayCheckInsProvider    statsProvider  catByIdProvider    catByHabitProvider
        (StreamProvider<...>)    (Provider<...>)   (family)          (family)
                              │
                              ▼
                   todayMinutesPerHabitProvider
                   (Provider<Map<String, int>>)


Timer state (local, not Firestore):

         focusTimerProvider (StateNotifierProvider<FocusTimerNotifier, FocusTimerState>)


Device connectivity (independent of auth):

  connectivity_plus stream ──► connectivityProvider (StreamProvider<bool>)
                                        │
                                        ▼
                               isOfflineProvider (Provider<bool>)
```

---

## Provider Definitions

### `authStateProvider`

- **Type**: `StreamProvider<User?>`
- **File**: `lib/providers/auth_provider.dart`
- **Source**: `FirebaseAuth.instance.authStateChanges()`
- **Consumers**: `AuthGate` (in `lib/app.dart`) — redirects to `LoginScreen` or `_FirstHabitGate`
- **SSOT for**: Whether a user is authenticated, and the Firebase `User` object

### `currentUidProvider`

- **Type**: `Provider<String?>`
- **File**: `lib/providers/auth_provider.dart`
- **Source**: Derived from `authStateProvider` — `ref.watch(authStateProvider).value?.uid`
- **Consumers**: All Firestore-backed providers (they depend on knowing the uid)
- **SSOT for**: The current user's Firebase UID

---

### `habitsProvider`

- **Type**: `StreamProvider<List<Habit>>`
- **File**: `lib/providers/habits_provider.dart`
- **Source**: `FirestoreService.watchHabits(uid)` — real-time Firestore stream
- **Consumers**: `HomeScreen` (habit list), `StatsScreen`, `_FirstHabitGate`, `statsProvider`
- **SSOT for**: The user's full habit list, always current with Firestore

### `todayCheckInsProvider`

- **Type**: `StreamProvider<List<CheckInEntry>>`
- **File**: `lib/providers/habits_provider.dart`
- **Source**: `FirestoreService.watchTodayCheckIns(uid)` — today's check-in entries
- **Consumers**: `HomeScreen` (today's progress per habit)
- **SSOT for**: All check-in entries for today

### `todayMinutesPerHabitProvider`

- **Type**: `Provider<Map<String, int>>`
- **File**: `lib/providers/habits_provider.dart`
- **Source**: Derived from `todayCheckInsProvider` — aggregates minutes by `habitId`
- **Consumers**: `HomeScreen` habit list rows (today's progress bar)
- **SSOT for**: Minutes logged today, grouped by habit ID

### `statsProvider`

- **Type**: `Provider<HabitStats>`
- **File**: `lib/providers/stats_provider.dart`
- **Source**: Derived from `habitsProvider` + `todayCheckInsProvider`
- **Consumers**: `StatsScreen`, `ProfileScreen`
- **SSOT for**: Aggregated statistics (total focus hours, best streak, active habit count)

---

### `catsProvider`

- **Type**: `StreamProvider<List<Cat>>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: `FirestoreService.watchCats(uid)` — streams only `state == "active"` cats
- **Consumers**: `CatRoomScreen`, `HomeScreen` (cat avatars in habit list), `ProfileScreen` (rarity breakdown)
- **SSOT for**: The user's active cats, always current

### `allCatsProvider`

- **Type**: `StreamProvider<List<Cat>>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: `FirestoreService.watchAllCats(uid)` — streams all cats regardless of state
- **Consumers**: Cat Album (Profile screen), `ownedBreedsProvider`
- **SSOT for**: Complete cat history including dormant and graduated cats

### `catByIdProvider`

- **Type**: `Provider.family<AsyncValue<Cat?>, String>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: Derived from `allCatsProvider` — finds by ID
- **Consumers**: `CatDetailScreen`
- **Usage**: `ref.watch(catByIdProvider(catId))`

### `catByHabitProvider`

- **Type**: `Provider.family<AsyncValue<Cat?>, String>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: Derived from `catsProvider` — finds by `boundHabitId`
- **Consumers**: `HomeScreen` habit rows (mini cat avatar), `FocusSetupScreen`
- **Usage**: `ref.watch(catByHabitProvider(habitId))`

### `ownedBreedsProvider`

- **Type**: `Provider<Set<String>>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: Derived from `allCatsProvider` — collects all breed IDs ever owned
- **Consumers**: `CatGenerationService` (to guarantee at least 1 new breed in each draft)
- **SSOT for**: Set of breed IDs the user has ever adopted

---

### `focusTimerProvider`

- **Type**: `StateNotifierProvider<FocusTimerNotifier, FocusTimerState>`
- **File**: `lib/providers/focus_timer_provider.dart`
- **Source**: Local state only (no Firebase dependency in the provider itself)
- **Consumers**: `TimerScreen`, `FocusCompleteScreen`
- **SSOT for**: The active focus timer state machine

**`FocusTimerState` fields:**

| Field | Type | Description |
|-------|------|-------------|
| `habitId` | String? | Active habit |
| `catId` | String? | Cat earning XP |
| `totalSeconds` | int | Target duration (countdown) or 0 (stopwatch) |
| `remainingSeconds` | int | Seconds left (countdown mode) |
| `elapsedSeconds` | int | Seconds elapsed (both modes) |
| `status` | enum | `idle`, `running`, `paused`, `completed`, `abandoned` |
| `mode` | enum | `countdown`, `stopwatch` |
| `startedAt` | DateTime? | Session start timestamp |

**`FocusTimerNotifier` methods:**

| Method | Description |
|--------|-------------|
| `start(habitId, catId, seconds, mode)` | Initialize and start the timer |
| `pause()` | Pause the timer (record `pausedAt`) |
| `resume()` | Resume from paused state |
| `complete()` | Mark as completed, trigger session save |
| `abandon()` | Mark as abandoned (partial XP if >= 5 min) |
| `onAppBackgrounded()` | Record backgrounding timestamp |
| `onAppResumed(away)` | Handle return: auto-pause under 15s, auto-end over 5min |
| `reset()` | Return to `idle` state |

**Timer tick:** `Timer.periodic(const Duration(seconds: 1), _onTick)` — disposed via `ref.onDispose()`.

---

### `connectivityProvider`

- **Type**: `StreamProvider<bool>`
- **File**: `lib/providers/connectivity_provider.dart`
- **Source**: `Connectivity().onConnectivityChanged` from `connectivity_plus` — maps `ConnectivityResult.none` to `false`, all others to `true`
- **Consumers**: `isOfflineProvider`
- **SSOT for**: Whether the device currently has a network interface active

### `isOfflineProvider`

- **Type**: `Provider<bool>`
- **File**: `lib/providers/connectivity_provider.dart`
- **Source**: Derived from `connectivityProvider` — returns `true` when disconnected, defaults `false` during loading
- **Consumers**: `OfflineBanner` widget
- **SSOT for**: Simple boolean flag for UI to show/hide the offline banner

---

## Key Patterns

| Pattern | When To Use | Example |
|---------|------------|---------|
| `StreamProvider` | Firestore real-time data | `habitsProvider`, `catsProvider` |
| `StateNotifierProvider` | Mutable local state with methods | `focusTimerProvider` |
| `Provider` | Computed/derived values (pure function of other providers) | `statsProvider`, `todayMinutesPerHabitProvider` |
| `Provider.family` | Parameterized lookups | `catByIdProvider(catId)` |
| `ref.watch()` | Reactive subscription in `build()` — rebuilds widget on change | All `ConsumerWidget.build()` methods |
| `ref.read()` | One-shot read in event handlers — does NOT subscribe | Button `onPressed` callbacks |
| `ref.listen()` | Side effects on state change (navigation, dialogs) | Listening for timer `completed` status |

---

## Rules

1. **Screens only read from Providers** via `ref.watch()` or `ref.read()` — never import Services directly into screens.
2. **Mutations go through Service methods** — called via `ref.read(someProvider.notifier).method()` or directly via `FirestoreService` injected into a Notifier.
3. **No local state for Firestore data** — if it's in Firestore, use a `StreamProvider` to stream it. Don't cache it in `StatefulWidget`.
4. **UI-only state** (timer running, dialog open, animation playing) belongs in `StateNotifierProvider` or `StateProvider`, never in Firestore.
5. **Family providers are auto-disposed** when no consumer is watching — this is correct; do not override with `keepAlive()` unless there's a specific reason.
6. **`AsyncValue` pattern** — all `StreamProvider` and `FutureProvider` values are `AsyncValue<T>`. Always handle `.when(data:, loading:, error:)` in the UI.
7. **`ref.watch()` only in build** — never call `ref.watch()` inside callbacks, `initState`, or `didChangeDependencies`.
