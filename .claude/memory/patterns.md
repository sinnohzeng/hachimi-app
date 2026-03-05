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
3. Online: call `deleteAccountV1` immediately.
4. Offline: queue and retry with tombstone.
5. All callable operations pass `OperationContext` (`correlation_id`, `uid_hash`, `operation_stage`, `retry_count`).

## Error Reporting Pattern
1. Build `ErrorContext` through `ErrorHandler.recordOperation(...)`.
2. Require deterministic `error_code` + `operation_stage`.
3. Keep `uid_hash` and `correlation_id` in every key flow.
4. Reject non-allowlisted extras via `ObservabilityTags`.

## Provider Wiring
- Service singletons are defined in `lib/providers/service_providers.dart`.
- Screens must consume providers; do not import Firebase SDK directly in UI.

## Sync Pattern
- Writes first hit local ledger/materialized state.
- `SyncEngine` is responsible for cloud reconciliation and retry policy.
