# Hachimi App — Patterns

## Profile Initialization
- Always call `ensureProfile(...)` after auth success.
- Never overwrite existing cloud profile documents.

## Guest Upgrade Pattern
1. Authenticate.
2. Build local + cloud snapshots.
3. Resolve (`keepLocal` / `keepCloud`).
4. Execute via `AccountMergeService`.

## Account Deletion Pattern
1. UI: summary -> type `DELETE`.
2. Orchestrator: local wipe first.
3. Online: call `deleteAccountV2` immediately.
4. Offline: queue and retry with tombstone.
5. All callable operations pass `OperationContext` (`correlation_id`, `uid_hash`, `operation_stage`, `retry_count`).
6. Sensitive callable requests use limited-use App Check token.

## Error Reporting Pattern
1. Build `ErrorContext` through `ErrorHandler.recordOperation(...)`.
2. Require deterministic `error_code` + `operation_stage`.
3. Keep `uid_hash` and `correlation_id` in every key flow.
4. Reject non-allowlisted extras via `ObservabilityTags`.

## AI Integration Pattern
1. Client AI provider is `firebase_gemini` only.
2. No static client AI API keys in release workflow.
3. Server triage uses Vertex IAM/ADC + heuristic fallback.
4. GitHub draft issue creation uses GitHub App installation token.

## Terraform Rollout Pattern
1. Bootstrap prod core resources first.
2. Keep `enable_export_dependent_resources=false` until Crashlytics/Analytics exports are producing BigQuery tables.
3. Set real `analytics_dataset` and flip `enable_export_dependent_resources=true`.
4. Re-apply to provision export-dependent views/jobs.

## Provider Wiring
- Service singletons are defined in `lib/providers/service_providers.dart`.
- Screens must consume providers; do not import Firebase SDK directly in UI.

## Sync Pattern
- Writes first hit local ledger/materialized state.
- `SyncEngine` is responsible for cloud reconciliation and retry policy.
