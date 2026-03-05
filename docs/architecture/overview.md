# Architecture Overview

> SSOT: this document describes the current runtime architecture after the 2026-03 account lifecycle refactor.

## Core Principles
- Offline-first: local SQLite + ledger is runtime SSOT.
- Deterministic sync: `SyncEngine` pushes unsynced actions to Firestore.
- No legacy compatibility: removed migration/version gates and pre-release fallback branches.
- Single cloud path: Firebase only (no region split branch).

## Stack
| Layer | Technology |
|---|---|
| App | Flutter 3.41.x + Dart 3.11.x |
| State | Riverpod 3.x |
| Local storage | sqflite + SharedPreferences |
| Auth/Data | Firebase Auth + Firestore |
| Server-side account ops | Firebase Cloud Functions (callable) |
| Observability | Crashlytics + Cloud Logging + BigQuery + Google Chat/Email alerts |

## Layered Design
```
Screens -> Providers -> Services -> Backend abstractions -> Firebase SDK / Cloud Functions
```

## Account Lifecycle (New)
### Guest upgrade conflict
1. Auth succeeds (Google or Email).
2. Build local snapshot + cloud snapshot.
3. Resolve by matrix:
- local empty + cloud non-empty: keep cloud
- cloud empty + local non-empty: keep local
- both non-empty: explicit user choice dialog
4. Execute merge via `AccountMergeService`.

### Account deletion (offline-first)
1. Confirm summary.
2. User types `DELETE`.
3. `AccountDeletionOrchestrator`:
- delete local data immediately
- online: call `deleteAccountV1` now
- offline: store pending deletion job + tombstone and retry later

## Cloud Functions Contract
- `deleteAccountV1`: recursive delete `users/{uid}` + delete Auth user (idempotent)
- `wipeUserDataV1`: recursive delete `users/{uid}` only (idempotent)
- Both callables require `OperationContext` payload:
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

## Observability Contract (New)
- Client errors are reported through `ErrorHandler.record(...)` with `ErrorContext`.
- Crash reporting uses hashed identity (`uid_hash`) only.
- Functions logs are structured and include:
  - `correlation_id`
  - `uid_hash`
  - `function_name`
  - `latency_ms`
  - `result`
  - `error_code`
- AI triage function `runAiDebugTriageV1` runs every 15 minutes and writes reports to `obs.ai_debug_reports_v1`.

## SSOT Snapshot
| Concern | SSOT |
|---|---|
| Business runtime state | SQLite (`local_*`, `materialized_state`) |
| Write log | `action_ledger` |
| Cloud persistence | Firestore `users/{uid}` subtree |
| Auth state | `authStateProvider` |
| Pending account deletion | SharedPreferences queue keys |
| Event names | `lib/core/constants/analytics_events.dart` |

## Removed Legacy Paths
- `MigrationService` and `_VersionGate`
- legacy Firestore `checkIns` compatibility path
- `RemoteConfigService` runtime dependency
- `OfflineWriteGuard`
- multi-region `BackendRegion.china` branch
