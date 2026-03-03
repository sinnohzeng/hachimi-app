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

## Provider Wiring
- Service singletons are defined in `lib/providers/service_providers.dart`.
- Screens must consume providers; do not import Firebase SDK directly in UI.

## Sync Pattern
- Writes first hit local ledger/materialized state.
- `SyncEngine` is responsible for cloud reconciliation and retry policy.
