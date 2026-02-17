# State Management (Riverpod)

> Each Provider is the single source of truth (SSOT) for its domain.

## Provider Architecture

```
authStateProvider (StreamProvider)
  └── watches Firebase Auth state changes
  └── SSOT for: current user authentication status

habitsProvider (StreamProvider)
  └── watches Firestore habits subcollection
  └── SSOT for: user's habit list with real-time updates

todayCheckInsProvider (StreamProvider)
  └── watches today's check-in entries
  └── SSOT for: today's completed check-ins

statsProvider (Provider)
  └── derives from habitsProvider + todayCheckInsProvider
  └── SSOT for: computed statistics (total hours, streaks, etc.)
```

## Provider Definitions

### authStateProvider
- **Type**: `StreamProvider<User?>`
- **Source**: `FirebaseAuth.instance.authStateChanges()`
- **Consumers**: App router (redirect to login), all authenticated screens

### habitsProvider
- **Type**: `StreamProvider<List<Habit>>`
- **Source**: `FirestoreService.watchHabits(uid)`
- **Consumers**: HomeScreen habit list, StatsScreen

### todayCheckInsProvider
- **Type**: `StreamProvider<List<CheckInEntry>>`
- **Source**: `FirestoreService.watchTodayCheckIns(uid)`
- **Consumers**: HomeScreen (check-in status per habit)

### statsProvider
- **Type**: `Provider<HabitStats>`
- **Source**: Derived from habitsProvider
- **Consumers**: StatsScreen

## Rules
1. Screens **only** read from Providers via `ref.watch()` or `ref.read()`
2. Mutations go through Service methods, called via `ref.read(serviceProvider)`
3. No local state for data that exists in Firestore — Firestore streams are the truth
4. UI-only state (e.g., timer running state) uses `StateProvider` or `StateNotifierProvider`
