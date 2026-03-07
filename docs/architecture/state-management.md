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

## Rules
- Screens must not call Firebase SDK directly.
- Navigation side-effects must be handled by listeners/effects, not inside `build()`.
- Providers must not reintroduce legacy compatibility branches.
- New persistent keys must be added only via `AppPrefsKeys`.
- Account lifecycle callables must always pass `OperationContext`.
- Screens must never inject static AI API keys; AI runtime is Firebase AI Logic only.
