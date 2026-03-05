# 2026-03-05 Observability & AI Debug Closed-Loop Plan

## Scope
- Android client + Firebase/GCP backend only.
- Single delivery: no phased rollout, no placeholder code, no TODO items.
- Alert routing standard: Google Chat (primary) + Email (fallback).
- Firebase billing baseline: Blaze (Pay-As-You-Go).

## Deliverables
1. Typed observability contract in Flutter:
- `ErrorContext`
- `OperationContext`
- `ObservabilityTags`
- `UidHasher`
- `CorrelationIdFactory`
2. Structured error pipeline on client:
- `ErrorHandler.record(...)` with typed context
- Crashlytics + Analytics `app_error` with correlation fields
- PII redaction and allowlist filtering
3. Callable contract upgrade:
- `deleteAccountV1`
- `wipeUserDataV1`
- required callable payload: `correlation_id`, `uid_hash`, `operation_stage`, `retry_count`
- telemetry response payload: `ok`, `correlation_id`, `function_name`, `latency_ms`, `result`, `error_code?`
4. Functions structured logging:
- `firebase-functions/logger`
- mandatory log fields: `correlation_id`, `uid_hash`, `function_name`, `latency_ms`, `result`, `error_code`
5. AI triage automation:
- scheduled function `runAiDebugTriageV1` (every 15 minutes)
- load tasks from `obs.ai_debug_tasks_v1`
- generate report and write `obs.ai_debug_reports_v1`
- create GitHub issue draft (`[DRAFT][AI-DEBUG]`)
6. BigQuery artifacts:
- `functions/sql/observability/obs_schema.sql`
- `functions/sql/observability/refresh_ai_debug_tasks.sql`
- setup script `scripts/gcp/setup_observability.sh` (`ANALYTICS_DATASET` supported for explicit dataset binding)
7. CI quality gate:
- `.github/workflows/ci.yml`
- checks: analyze, tests, quality gate, no TODO/FIXME/TBD placeholders

## Public Interfaces / Types
- `ErrorHandler.record(Object error, {required ErrorContext context, StackTrace? stackTrace, bool fatal = false})`
- `ErrorHandler.recordOperation(...)` convenience wrapper
- `AccountLifecycleBackend.deleteAccountHard({required OperationContext context})`
- `AccountLifecycleBackend.wipeUserData({required OperationContext context})`

## Operational Standards
- Never upload plaintext UID/email/phone in logs, crash keys, or analytics.
- Use `uid_hash` only.
- Keep Email fallback enabled while Google Chat channel is Preview.
- Budget and retention guardrails are mandatory for `obs` dataset.

## Verification Gates
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`
- `rg -n "TODO|FIXME|TBD|占位" lib test functions/src functions/test .claude/memory`

## Acceptance Criteria
1. Synthetic non-fatal error appears in Crashlytics within 5 minutes.
2. Same issue is queryable from BigQuery within 60 minutes.
3. Deletion failure is traceable end-to-end by `correlation_id`.
4. Callable logs always include `latency_ms` and `result`.
5. Google Chat and Email both receive test alerts.
6. No TODO/FIXME/TBD placeholders remain in active docs and changed code.
