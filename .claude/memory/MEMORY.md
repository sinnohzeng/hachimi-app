# Hachimi App — Claude Memory

## Current Baseline (2026-03-04)
- Flutter 3.41.x + Dart 3.11.x + Firebase.
- Riverpod 3.x (`Notifier` + `NotifierProvider` preferred).
- Runtime is offline-first: SQLite + ledger/materialized state are SSOT.
- Account lifecycle uses Cloud Functions hard-delete APIs.
- Release workflow is tag-triggered (`v*`), now includes `tool/quality_gate.dart` before analysis.

## Architecture Facts
- Single backend runtime path: Firebase only.
- `UserProfileBackend` uses idempotent `ensureProfile(...)`.
- Guest upgrade conflict is coordinated by `GuestUpgradeCoordinator`.
- Account deletion is orchestrated by `AccountDeletionOrchestrator`.

## Persistent Keys
- `cached_uid`
- `local_guest_uid`
- `local_data_hydrated_v1`
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Removed Legacy Paths
- `MigrationService` and `_VersionGate`
- `RemoteConfigService` (runtime)
- `OfflineWriteGuard`
- legacy Firestore `checkIns` subtree
- `BackendRegion.china` branch
