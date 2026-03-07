# 2026-03-07 Auth Lifecycle Bugfix & Refactor Plan (v2)

## Scope
- Fix post-onboarding login data loss.
- Fix logout non-response from Settings / Drawer / Profile.
- Fix delete-account broken state transitions.
- Align account lifecycle behavior with DDD + SSOT docs.

## Root Causes
1. **Migration source UID ambiguity**
- Login flow captured `currentUidProvider` directly.
- During anonymous/credential transition, source UID could drift from `local_guest_uid`, causing migrations to run against the wrong source.

2. **UID change lifecycle gap in `_FirstHabitGate`**
- UID changes reused the same `State`, but background engine startup logic was only bound to initial lifecycle.
- Existing startup path was not serialized, allowing stale async work to race.

3. **Logout UX split across 3 duplicated implementations**
- Dialog + action logic was duplicated in Settings, Drawer, Profile.
- Route stack was not normalized centrally when `onboardingComplete` flipped to `false`.

4. **Delete-account state machine too implicit**
- UI could not distinguish remote success vs queued retry vs non-retryable remote failure.
- Error branches relied on exception type names and contained invalid post-wipe recovery behavior.

## Architecture Decisions
1. **Deterministic migration source**
- Introduce `IdentityTransitionResolver`.
- Resolution order is fixed: `local_guest_uid` first, fallback to captured pre-auth `currentUid`.
- `GuestUpgradeCoordinator.resolve(...)` now requires `migrationSourceUid`.

2. **Side-effects out of `build()`**
- `AuthGate` now listens to `onboardingCompleteProvider` via `ref.listenManual`.
- Transition `true -> false` triggers centralized `Navigator.popUntil(isFirst)`.

3. **Serialized engine restart on UID changes**
- `_FirstHabitGateState` now handles `didUpdateWidget`.
- Engine startup uses run-id serialization to cancel stale async chains.
- Sequence is explicit: stop old sync -> recover orphaned guest data -> hydrate/start new UID -> restart evaluator.

4. **Explicit account deletion result contract**
- `AccountDeletionOrchestrator.deleteAccount(...)` returns `AccountDeletionResult`.
- Result carries `localDeleted`, `remoteDeleted`, `queued`, `errorCode`.
- Remote errors are classified as retryable/non-retryable:
  - retryable: keep pending markers, increment retry
  - non-retryable: clear pending markers immediately
- Sign-out is only performed on remote hard-delete success.

## Implemented Changes
- `lib/services/identity_transition_resolver.dart` (new)
- `lib/providers/service_providers.dart`
- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/components/email_auth_screen.dart`
- `lib/services/guest_upgrade_coordinator.dart`
- `lib/app.dart`
- `lib/widgets/logout_confirmation.dart` (new)
- `lib/screens/settings/settings_screen.dart`
- `lib/widgets/app_drawer.dart`
- `lib/screens/profile/profile_screen.dart`
- `lib/models/account_deletion_result.dart` (new)
- `lib/services/account_deletion_orchestrator.dart`
- `lib/screens/settings/components/delete_account_flow.dart`
- `scripts/check-account-lifecycle-functions.sh` (new)
- `test/services/account_deletion_orchestrator_test.dart`
- `test/services/identity_transition_resolver_test.dart` (new)

## API Changes
- `AccountDeletionOrchestrator.deleteAccount({required String uid})`
  - `Future<void>` -> `Future<AccountDeletionResult>`
- `GuestUpgradeCoordinator.resolve(...)`
  - replaces `oldUid` input with required `migrationSourceUid`

## Verification (2026-03-07)
- `dart analyze lib test` -> clean
- `flutter test` -> pass
- Added regression tests for:
  - non-retryable remote deletion path (`functions/unimplemented`)
  - delete-account result states (`queued`, `remoteDeleted`)
  - migration-source resolver priority logic

## Release Gate
- Deploy `deleteAccountV2` and `wipeUserDataV2` to `hachimi-ai` before release.
- Run `scripts/check-account-lifecycle-functions.sh hachimi-ai` in CI/pre-release checks.
