# 2026-03-04 Account Lifecycle & Repository Governance Plan

## Scope
- Rebuild account lifecycle with **offline-first** semantics.
- Remove pre-release legacy compatibility paths.
- Enforce quality red lines in hand-written `lib/` code.
- Converge docs and memory under DDD + SSOT.

## Hard Constraints
- File length: `<= 800` lines
- Function length: `<= 30` lines
- Nesting depth: `<= 3`
- Branch count: `<= 3`

## Target Architecture
1. Guest upgrade conflict flow
- Introduce snapshot model: `AccountDataSnapshot`.
- Compute local and cloud snapshots after Google/Email auth success.
- Resolve with deterministic matrix:
  - local empty + cloud non-empty -> keep cloud
  - cloud empty + local non-empty -> keep local
  - both non-empty -> explicit user choice dialog

2. Merge execution
- `keepCloud`: clear old local guest data, hydrate cloud, restart sync.
- `keepLocal`: call `wipeUserDataV1`, migrate UID ledger, `ensureProfile`, push local via sync.

3. Deletion flow
- Replace re-auth delete with 3-step flow:
  - data summary
  - type `DELETE`
  - execute orchestrated deletion
- Local data is deleted immediately.
- Cloud/Auth hard delete runs immediately when online; otherwise queue with tombstone/retry.
- Pending job keys:
  - `pending_deletion_job`
  - `deletion_tombstone`
  - `deletion_retry_count`

4. Cloud Functions
- Add `functions/` (Node 20 + TypeScript).
- Callable:
  - `deleteAccountV1`: recursive delete `users/{uid}` + delete Auth user (idempotent)
  - `wipeUserDataV1`: recursive delete `users/{uid}` only (idempotent)

5. Legacy cleanup
- Remove migration gate and migration service.
- Remove `checkIns` legacy paths from rules and deletion logic.
- Remove unused `RemoteConfigService` and `OfflineWriteGuard`.
- Collapse backend strategy to single Firebase runtime path.

## Governance Work Items
- Add `tool/quality_gate.dart` and wire it in CI workflow.
- Sync root and docs architecture/Firebase guides with implemented code.
- Archive stale docs to `docs/archive/` and mark archive in index.
- Update `.claude/memory/*` to reflect current constraints.

## Verification Gates
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`

## Delivery Strategy
- Commit 1 (code): lifecycle refactor, cloud functions, tests, quality gate.
- Commit 2 (docs): docs SSOT governance, archive, README/CHANGELOG/memory updates.
- Push to `origin/main` without tag/release.
