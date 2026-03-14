# State Management

> SSOT for Riverpod provider topology.

## Provider Layers
### Infrastructure providers
- `sharedPreferencesProvider`
- `localDatabaseServiceProvider`
- `ledgerServiceProvider`
- `syncEngineProvider`
- Runtime observability context (global singleton): `ObservabilityRuntime`
- AI provider selection is constrained to `firebase_gemini` (`AiProviderId` wire value).

### Backend providers
- `backendRegistryProvider` (single Firebase path)
- `authBackendProvider`
- `syncBackendProvider`
- `userProfileBackendProvider`
- `accountLifecycleBackendProvider`

### Account lifecycle providers
- `identityTransitionResolverProvider`
- `accountSnapshotServiceProvider`
- `accountMergeServiceProvider`
- `guestUpgradeCoordinatorProvider`
- `accountDeletionServiceProvider`
- `accountDeletionOrchestratorProvider`

### Auth and identity providers
- `authStateProvider` — Firebase Auth stream (SSOT)
- `appAuthStateProvider` — sealed class combining auth stream + local guest UID → `AuthenticatedState | GuestState`
- `currentUidProvider` — derived from `appAuthStateProvider` (backward-compat, 26+ files)
- `isGuestProvider` — derived from `appAuthStateProvider` (backward-compat, 5 files)
- `onboardingCompleteProvider`

## Runtime State Model
- UI reads from providers only.
- Services write to local ledger/materialized state first.
- Sync engine asynchronously reconciles with Firestore.

### LedgerChange Global Refresh Pattern
`LedgerChange.isGlobalRefresh` is a semantic property (currently `type == 'hydrate'`) that signals all StreamProviders to re-read local data. This eliminates shotgun surgery — instead of 8+ providers each checking `change.type == 'hydrate'`, each provider uses `change.isGlobalRefresh || <domain-specific filter>`. Adding a new global event (e.g., `full_restore`) only requires updating the `isGlobalRefresh` getter.

Affected providers: `habitsProvider`, `catsProvider`, `allCatsProvider`, `coinBalanceProvider`, `hasCheckedInTodayProvider`, `monthlyCheckInProvider`, `inventoryProvider`, `unlockedAchievementsProvider`, `avatarIdProvider`, `currentTitleProvider`, `unlockedTitlesProvider`.

## AppAuthState — Sealed Class Identity Model

`AppAuthState` (in `lib/models/app_auth_state.dart`) replaces the previous boolean `isGuest` approach with a sealed class that makes identity states exhaustive and pattern-matchable:

```
sealed class AppAuthState
├── AuthenticatedState(uid, email?, displayName?)
└── GuestState(uid)  // uid may be empty (pre-onboarding)
```

`appAuthStateProvider` is the single SSOT combining Firebase Auth stream + local guest UID. All downstream consumers (`currentUidProvider`, `isGuestProvider`, drawer, AuthGate) derive from this single source via `ref.watch(appAuthStateProvider)`.

## AuthGate Behavior
1. If onboarding incomplete:
   - If `hasOnboardedBefore == false` → first-time user → show OnboardingScreen.
   - If `hasOnboardedBefore == true` → returning user after logout → auto-skip tutorial, create guest UID, restore onboarding state.
2. If deletion tombstone/pending job exists → pending deletion screen + retry loop.
3. `switch (appAuthStateProvider)`:
   - `AuthenticatedState` → boot app with auth UID.
   - `GuestState` (uid non-empty) → local guest boot.
   - `GuestState` (uid empty) → loading spinner (pre-onboarding).

`hasOnboardedBefore` is a persistent SharedPreferences flag set on first onboarding completion. It survives logout but is cleared on account deletion (fresh start).

### Logout — 3-Step Provider Cascade
Logout is centralized in `UserProfileNotifier.logout()` — the only logout entry point. The flow is 3 steps:
1. Stop sync engine (before identity switch).
2. Delete old user data + Firebase sign out.
3. Create fresh guest UID → triggers `appAuthStateProvider` to emit `GuestState(newUid)` → all downstream providers auto-invalidate.

Non-critical cleanup (notification cancellation, Crashlytics user reset) runs as fire-and-forget after step 3. No manual SharedPreferences sweep — provider cascade replaces the old 10-key cleanup.

`ref.listenManual(onboardingCompleteProvider)` in AuthGate detects `true → false` and calls `popUntil(isFirst)` to dismiss any open dialogs or pushed routes.

### FirstHabitGate Hydration Guard
`_FirstHabitGate` checks whether the user has any habits to decide new-user routing. For non-guest users, this check is deferred until `dataHydrated == true` (set by SyncEngine after Firestore hydration), preventing a race condition where empty pre-hydration data triggers the adoption flow incorrectly.

## Guest Upgrade Flow
- Triggered in login screens after auth success.
- Migration source UID is resolved before auth mutation:
  - prefer `local_guest_uid`
  - fallback to pre-auth `currentUid`
- `GuestUpgradeCoordinator` decides merge path using snapshots.
- `GuestUpgradeCoordinator.resolve(...)` requires `migrationSourceUid` and aborts on source mismatch to avoid dangerous merges.
- Merge always goes through explicit service orchestration; no implicit UID migration in `AuthGate`.

## Deletion Flow
- UI flow is three-step confirmation only.
- `AccountDeletionOrchestrator` owns local cleanup + remote hard-delete retry queue.
- Guest local uid (`guest_*`) never calls Firestore delete APIs.
- Orchestrator returns typed `AccountDeletionResult` (`localDeleted`, `remoteDeleted`, `queued`, `errorCode`).
- Remote deletion retries only for retryable callable errors; non-retryable errors clear pending markers immediately.
- Sign-out and Crashlytics user reset happen only on remote hard-delete success.
- Firebase backend implementation calls `deleteAccountV2` / `wipeUserDataV2` with limited-use App Check token.

## AI Runtime

### Availability Model

`AiAvailability` is a 2-state enum: `ready` | `error`.

- AI is always-on for authenticated users — there is no user-facing toggle.
- `AiFeatureNotifier` and `aiFeatureEnabledProvider` have been deleted.
- On startup, availability is optimistically set to `ready`. An async validation probe runs on first AI access (lazy validation).

### Circuit Breaker

`AiAvailabilityNotifier` tracks consecutive failures:
- 3 consecutive failures trigger a 5-minute backoff (availability switches to `error`).
- After backoff expires, the next AI access retries automatically.

### Network Timeout Protection

| Operation | Timeout |
|-----------|---------|
| Chat | 15s |
| Diary | 20s |
| Validation probe | 5s |
| Streaming idle | 10s |

### Chat Daily Limit

Each cat is limited to **5 chat messages per day**, enforced via `getRemainingMessages()`.
- Defense-in-depth: service-layer guard rejects messages at limit + UI disables the send button.
- The limit is configurable via RemoteConfig (`chat_daily_limit`, default: 5).

## Theme State — Dual UI Style

### ThemeSettings

`ThemeSettings` (in `theme_provider.dart`) holds all theme-related state:

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `mode` | `ThemeMode` | `system` | Light/dark/system |
| `seedColor` | `Color` | `#4285F4` | M3 seed color |
| `useDynamicColor` | `bool` | `true` | Material You wallpaper color |
| `enableBackgroundAnimation` | `bool` | `true` | Mesh gradient + particles |
| `uiStyle` | `AppUiStyle` | `retroPixel` | `material` or `retroPixel` |

`effectiveDynamicColor` forces `false` when `uiStyle == retroPixel` — the retro palette IS the brand identity.

### ThemeSkin Strategy Pattern

`AppTheme._assemble()` delegates all component theming to a `ThemeSkin` implementation:

```
ThemeSettings.uiStyle → _skinFor(style) → MaterialSkin | RetroPixelSkin
                                              ↓
                                    _assemble(colorScheme, textTheme, skin)
                                              ↓
                                    ThemeData (zero branching)
```

- `MaterialSkin` — extracted from original `_buildTheme()`, zero behavioral change.
- `RetroPixelSkin` — maps retro colors onto `ColorScheme` slots, applies `PixelBorderShape` to all component themes, Silkscreen font for display text, stepped page transitions.

Key files: `lib/core/theme/skins/{theme_skin,material_skin,retro_pixel_skin}.dart`

### AppScaffold

`AppScaffold` (in `lib/widgets/app_scaffold.dart`) wraps `Scaffold` and conditionally overlays `RetroTiledBackground` in retro mode. All screens use `AppScaffold` instead of `Scaffold` — single integration point for 23+ screens.

## Rules
- Screens must not call Firebase SDK directly.
- Navigation side-effects must be handled by listeners/effects, not inside `build()`.
- Providers must not reintroduce legacy compatibility branches.
- New persistent keys must be added only via `AppPrefsKeys`.
- Account lifecycle callables must always pass `OperationContext`.
- Screens must never inject static AI API keys; AI runtime is Firebase AI Logic only.
