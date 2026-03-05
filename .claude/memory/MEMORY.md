# Hachimi App — Claude Memory

## Current Baseline (2026-03-05)
- Flutter 3.41.x + Dart 3.11.x + Firebase.
- Firebase billing plan is Blaze (Pay-As-You-Go).
- Riverpod 3.x (`Notifier` + `NotifierProvider` preferred).
- Runtime is offline-first: SQLite + ledger/materialized state are SSOT.
- Account lifecycle uses Cloud Functions hard-delete APIs with typed operation context.

## Architecture Facts
- Single backend runtime path: Firebase only.
- Observability contract is typed (`ErrorContext`, `OperationContext`).
- Crash identity is hashed only (`uid_hash`), never plaintext UID.
- Functions use structured logging with correlation id and telemetry fields.
- AI triage runs on a 15-minute schedule and writes `obs.ai_debug_reports_v1`.
- Alerting standard is Google Chat (primary) + Email (fallback).

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
