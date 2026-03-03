# State Management

> SSOT for Riverpod provider topology.

## Provider Layers
### Infrastructure providers
- `sharedPreferencesProvider`
- `localDatabaseServiceProvider`
- `ledgerServiceProvider`
- `syncEngineProvider`

### Backend providers
- `backendRegistryProvider` (single Firebase path)
- `authBackendProvider`
- `syncBackendProvider`
- `userProfileBackendProvider`
- `accountLifecycleBackendProvider`

### Account lifecycle providers
- `accountSnapshotServiceProvider`
- `accountMergeServiceProvider`
- `guestUpgradeCoordinatorProvider`
- `accountDeletionServiceProvider`
- `accountDeletionOrchestratorProvider`

### Auth and identity providers
- `authStateProvider`
- `currentUidProvider`
- `isGuestProvider`
- `onboardingCompleteProvider`

## Runtime State Model
- UI reads from providers only.
- Services write to local ledger/materialized state first.
- Sync engine asynchronously reconciles with Firestore.

## AuthGate Behavior
1. If onboarding incomplete -> onboarding flow.
2. If deletion tombstone/pending job exists -> pending deletion screen + retry loop.
3. If authenticated -> boot app with auth uid.
4. If unauthenticated but cached uid exists -> local guest boot + background anonymous sign-in.

## Guest Upgrade Flow
- Triggered in login screens after auth success.
- `GuestUpgradeCoordinator` decides merge path using snapshots.
- Merge always goes through explicit service orchestration; no implicit UID migration in `AuthGate`.

## Deletion Flow
- UI flow is three-step confirmation only.
- `AccountDeletionOrchestrator` owns local cleanup + remote hard-delete retry queue.
- Guest local uid (`guest_*`) never calls Firestore delete APIs.

## Rules
- Screens must not call Firebase SDK directly.
- Providers must not reintroduce legacy compatibility branches.
- New persistent keys must be added only via `AppPrefsKeys`.
