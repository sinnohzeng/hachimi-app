# Hachimi App — Claude Memory

## Current Baseline (2026-03-05)
- Flutter 3.41.x + Dart 3.11.x + Firebase.
- Firebase billing plan is Blaze (Pay-As-You-Go).
- Firebase production project is `hachimi-ai` (single-environment setup).
- Riverpod 3.x (`Notifier` + `NotifierProvider` preferred).
- Runtime is offline-first: SQLite + ledger/materialized state are SSOT.
- Infra control plane for observability/security is Terraform (`infra/terraform/*`).

## Architecture Facts
- Single backend runtime path: Firebase only.
- Sensitive callables are `deleteAccountV2` / `wipeUserDataV2` with App Check enforced.
- Observability contract is typed (`ErrorContext`, `OperationContext`).
- Crash identity is hashed only (`uid_hash`), never plaintext UID.
- Functions use structured logging with correlation id + telemetry fields.
- AI triage job is `runAiDebugTriageV2` on 15-minute cadence.
- AI runtime is Google-first: Firebase AI Logic + Vertex AI.
- GitHub issue automation uses GitHub App installation token (no long-lived PAT).
- Alerting standard is Google Chat (primary) + Email (fallback).
- Terraform prod uses staged rollout for export-dependent resources (`enable_export_dependent_resources`), then full enable after Firebase BigQuery exports are ready.

## Persistent Keys
- `cached_uid`
- `local_guest_uid`
- `local_data_hydrated_v1`
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Removed Legacy Paths
- Client static AI key release path (`MINIMAX_API_KEY`, `GEMINI_API_KEY`)
- GitHub PAT-based triage auth path
- `MigrationService` and `_VersionGate`
- `RemoteConfigService` (runtime)
- `OfflineWriteGuard`
- legacy Firestore `checkIns` subtree
- `BackendRegion.china` branch
