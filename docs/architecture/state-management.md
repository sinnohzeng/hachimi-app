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


Pixel cat rendering (singleton + per-cat cache):

         pixelCatRendererProvider (Provider<PixelCatRenderer>)
                        │
                        ▼
         catSpriteImageProvider (FutureProvider.family<ui.Image, String>)


Coin economy:

  coinServiceProvider ──► coinBalanceProvider (StreamProvider<int>)
                          hasCheckedInTodayProvider (FutureProvider<bool>)
                          monthlyCheckInProvider (StreamProvider<MonthlyCheckIn?>)


Timer state (local, not Firestore — persisted to SharedPreferences for crash recovery):

         focusTimerProvider (StateNotifierProvider<FocusTimerNotifier, FocusTimerState>)


Theme & locale (persisted to SharedPreferences):

         themeProvider (StateNotifierProvider<ThemeNotifier, ThemeSettings>)
         localeProvider (StateNotifierProvider<LocaleNotifier, Locale?>)


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
- **Source**: `CatFirestoreService.watchCats(uid)` — streams only `state == "active"` cats
- **Consumers**: `CatRoomScreen` (CatHouse grid), `HomeScreen` (cat avatars in habit list), `ProfileScreen`
- **SSOT for**: The user's active cats, always current

### `allCatsProvider`

- **Type**: `StreamProvider<List<Cat>>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: `CatFirestoreService.watchAllCats(uid)` — streams all cats regardless of state
- **Consumers**: Cat Album (Profile screen)
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

### `catFirestoreServiceProvider`

- **Type**: `Provider<CatFirestoreService>`
- **File**: `lib/providers/auth_provider.dart`
- **Source**: Instantiates `CatFirestoreService` with Firestore instance
- **Consumers**: `catsProvider`, `allCatsProvider`, and any provider that needs to read/write cat documents
- **SSOT for**: The singleton service instance for all cat-related Firestore operations

---

### `pixelCatRendererProvider`

- **Type**: `Provider<PixelCatRenderer>` (singleton)
- **File**: `lib/providers/cat_sprite_provider.dart`
- **Source**: Instantiates a single `PixelCatRenderer` that manages asset loading and sprite composition
- **Consumers**: `catSpriteImageProvider`
- **SSOT for**: The pixel-cat-maker rendering engine instance. Singleton to share loaded assets across all sprites.

### `catSpriteImageProvider`

- **Type**: `FutureProvider.family<ui.Image, String>` (keyed by catId)
- **File**: `lib/providers/cat_sprite_provider.dart`
- **Source**: Calls `ref.watch(pixelCatRendererProvider).renderCat(catAppearance)` — composites the 13-layer sprite for a given cat's appearance parameters
- **Consumers**: `PixelCatSprite` widget, `CatHouseCard` widget
- **SSOT for**: The composited pixel-art image for a specific cat
- **Usage**: `ref.watch(catSpriteImageProvider(catId))`

### `pixelCatGenerationServiceProvider`

- **Type**: `Provider<PixelCatGenerationService>`
- **File**: `lib/providers/cat_provider.dart`
- **Source**: Instantiates `PixelCatGenerationService`
- **Consumers**: `AdoptionFlowScreen` (to generate random cats for adoption)
- **SSOT for**: The service that produces randomized cat appearance and personality

---

### `coinServiceProvider`

- **Type**: `Provider<CoinService>`
- **File**: `lib/providers/coin_provider.dart`
- **Source**: Instantiates `CoinService` with Firestore instance
- **Consumers**: Screens that handle accessory purchases and check-in bonus display
- **SSOT for**: The singleton service instance for coin-related operations

### `coinBalanceProvider`

- **Type**: `StreamProvider<int>`
- **File**: `lib/providers/coin_provider.dart`
- **Source**: `CoinService.watchBalance(uid)` — real-time stream of the user's `coins` field
- **Consumers**: `CatDetailScreen` (accessory shop balance), `CheckInBanner`, `ProfileScreen`
- **SSOT for**: The user's current coin balance, always current with Firestore

### `hasCheckedInTodayProvider`

- **Type**: `FutureProvider<bool>`
- **File**: `lib/providers/coin_provider.dart`
- **Source**: `CoinService.hasCheckedInToday(uid)` — compares `lastCheckInDate` with today's date string
- **Consumers**: `CheckInBanner` widget (to determine checked-in vs. not-checked-in state)
- **SSOT for**: Whether the user has already claimed today's daily check-in coin bonus

### `monthlyCheckInProvider`

- **Type**: `StreamProvider<MonthlyCheckIn?>`
- **File**: `lib/providers/coin_provider.dart`
- **Source**: `CoinService.watchMonthlyCheckIn(uid)` — real-time stream of the current month's check-in document
- **Consumers**: `CheckInBanner` (progress summary), `CheckInScreen` (full monthly details)
- **SSOT for**: The current month's check-in progress, including checked days, earned coins, and claimed milestones

---

### `AccessoryInfo`

- **Type**: Data class (not a Provider)
- **File**: `lib/providers/accessory_provider.dart`
- **Purpose**: Lightweight value object combining accessory ID, display name, price, category, owned/equipped status
- **Consumers**: `AccessoryShopScreen`, `AccessoryCard` widget
- **Fields**: `id`, `displayName`, `price`, `category` ('plant'/'wild'/'collar'), `isOwned`, `isEquipped`

### `inventoryProvider`

- **Type**: `StreamProvider<List<String>>`
- **File**: `lib/providers/inventory_provider.dart`
- **Source**: `InventoryService.watchInventory(uid)` — real-time stream of user's `inventory` field
- **Consumers**: `InventoryScreen`, `AccessoryShopScreen`, `_AccessoriesCard`
- **SSOT for**: The user's unequipped accessory inventory

### `inventoryServiceProvider`

- **Type**: `Provider<InventoryService>`
- **File**: `lib/providers/auth_provider.dart`
- **Source**: Instantiates `InventoryService`
- **Consumers**: `InventoryScreen`, `_AccessoriesCard`
- **SSOT for**: The singleton service for inventory equip/unequip operations

---

### `focusTimerProvider`

- **Type**: `StateNotifierProvider<FocusTimerNotifier, FocusTimerState>` (NOT autoDispose — global singleton)
- **File**: `lib/providers/focus_timer_provider.dart`
- **Source**: Local state, persisted to SharedPreferences for crash recovery
- **Consumers**: `TimerScreen`, `FocusCompleteScreen`, `_FirstHabitGate` (session recovery)
- **SSOT for**: The active focus timer state machine

**`FocusTimerState` fields:**

| Field | Type | Description |
|-------|------|-------------|
| `habitId` | String | Active habit |
| `catId` | String | Cat earning XP |
| `habitName` | String | Habit display name (for notification + recovery dialog) |
| `totalSeconds` | int | Target duration (countdown) or 0 (stopwatch) |
| `remainingSeconds` | int | Seconds left (countdown mode, computed) |
| `elapsedSeconds` | int | Seconds elapsed (both modes) |
| `status` | enum | `idle`, `running`, `paused`, `completed`, `abandoned` |
| `mode` | enum | `countdown`, `stopwatch` |
| `startedAt` | DateTime? | Session start timestamp |

**`FocusTimerNotifier` methods:**

| Method | Description |
|--------|-------------|
| `configure(habitId, catId, habitName, seconds, mode)` | Initialize timer parameters |
| `start()` | Start the timer tick |
| `pause()` | Pause the timer (record `pausedAt`) |
| `resume()` | Resume from paused state |
| `complete()` | Mark as completed, clear saved state |
| `abandon()` | Mark as abandoned (partial XP if >= 5 min), clear saved state |
| `onAppBackgrounded()` | Record backgrounding timestamp |
| `onAppResumed()` | Handle return: auto-pause under 15s, auto-end over 5min |
| `reset()` | Return to `idle` state, clear saved state |
| `restoreSession()` | Restore interrupted session from SharedPreferences |
| `static hasInterruptedSession()` | Check if there's a saved session to recover |
| `static clearSavedState()` | Clear persisted session data |

**Persistence:** Every 5 seconds + on state changes, the timer state is saved to SharedPreferences (keys prefixed `focus_timer_`). On `complete()`, `abandon()`, and `reset()`, saved state is cleared.

**Notification updates:** `_onTick()` directly calls `FocusTimerService.updateNotification()` so the foreground notification stays current even when the app is in the background.

**Timer tick:** `Timer.periodic(const Duration(seconds: 1), _onTick)` — cancelled in `dispose()`.

---

### `themeProvider`

- **Type**: `StateNotifierProvider<ThemeNotifier, ThemeSettings>`
- **File**: `lib/providers/theme_provider.dart`
- **Source**: Local state, persisted to SharedPreferences
- **Consumers**: `HachimiApp` (MaterialApp theme/darkTheme/themeMode), `SettingsScreen`
- **SSOT for**: App theme mode (system/light/dark) and seed color

**`ThemeSettings` fields:**

| Field | Type | Description |
|-------|------|-------------|
| `mode` | ThemeMode | `system`, `light`, `dark` |
| `seedColor` | Color | Material Design 3 seed color (default: Google Blue `0xFF4285F4`) |

**`ThemeNotifier` methods:**

| Method | Description |
|--------|-------------|
| `setMode(ThemeMode)` | Switch theme mode |
| `setSeedColor(Color)` | Set seed color from 8-color preset palette |

---

### `localeProvider`

- **Type**: `StateNotifierProvider<LocaleNotifier, Locale?>`
- **File**: `lib/providers/locale_provider.dart`
- **Source**: Local state, persisted to SharedPreferences
- **Consumers**: `HachimiApp` (MaterialApp locale), `SettingsScreen`
- **SSOT for**: App language override (`null` = follow system, `Locale('en')` or `Locale('zh')` = user override)

**`LocaleNotifier` methods:**

| Method | Description |
|--------|-------------|
| `setLocale(Locale?)` | Set locale; null to follow system |

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
| `StreamProvider` | Firestore real-time data | `habitsProvider`, `catsProvider`, `coinBalanceProvider` |
| `FutureProvider.family` | Async per-key computation | `catSpriteImageProvider(catId)` |
| `StateNotifierProvider` | Mutable local state with methods | `focusTimerProvider` |
| `Provider` | Computed/derived values (pure function of other providers) | `statsProvider`, `todayMinutesPerHabitProvider`, `hasCheckedInTodayProvider` |
| `Provider.family` | Parameterized lookups | `catByIdProvider(catId)` |
| `ref.watch()` | Reactive subscription in `build()` — rebuilds widget on change | All `ConsumerWidget.build()` methods |
| `ref.read()` | One-shot read in event handlers — does NOT subscribe | Button `onPressed` callbacks |
| `ref.listen()` | Side effects on state change (navigation, dialogs) | Listening for timer `completed` status |

---

## Rules

1. **Screens only read from Providers** via `ref.watch()` or `ref.read()` — never import Services directly into screens.
2. **Mutations go through Service methods** — called via `ref.read(someProvider.notifier).method()` or directly via a Service injected into a Notifier.
3. **No local state for Firestore data** — if it's in Firestore, use a `StreamProvider` to stream it. Don't cache it in `StatefulWidget`.
4. **UI-only state** (timer running, dialog open, animation playing) belongs in `StateNotifierProvider` or `StateProvider`, never in Firestore.
5. **Family providers are auto-disposed** when no consumer is watching — this is correct; do not override with `keepAlive()` unless there's a specific reason.
6. **`AsyncValue` pattern** — all `StreamProvider` and `FutureProvider` values are `AsyncValue<T>`. Always handle `.when(data:, loading:, error:)` in the UI.
7. **`ref.watch()` only in build** — never call `ref.watch()` inside callbacks, `initState`, or `didChangeDependencies`.
