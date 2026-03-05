# Observability Architecture

> SSOT for application error telemetry, callable tracing, and AI triage automation.

## Purpose
Define the runtime contract that links mobile errors, Cloud Functions logs, BigQuery analytics, alerting, and AI triage.

## Core Contract
### ErrorContext (client)
Mandatory fields:
- `feature`
- `operation`
- `operation_stage`
- `correlation_id`
- `uid_hash`
- `app_version`
- `build_number`
- `network_state`
- `retry_count`
- `error_code`

### OperationContext (client -> callable)
Mandatory fields:
- `correlation_id`
- `uid_hash`
- `operation_stage`
- `retry_count`

## Client Pipeline
1. Catch runtime exception.
2. Build `ErrorContext`.
3. `ErrorHandler.record(...)` filters tags by allowlist.
4. Crashlytics custom keys + error event recorded.
5. Analytics `app_error` event emitted with correlation metadata.

## Callable Pipeline
1. Callable validates `OperationContext`.
2. Function logs start/success/failure with structured fields.
3. Function response returns telemetry envelope.
4. On error, function emits `error_code` and throws `HttpsError`.

## Data Plane
- Crashlytics export -> BigQuery + Cloud Logging.
- Analytics export -> BigQuery.
- Functions logs -> Cloud Logging (query/export to BigQuery).
- `obs` dataset stores issue views and AI triage tables.

## AI Debug Loop
1. Scheduled query refreshes `obs.ai_debug_tasks_v1` every 15 minutes.
2. `runAiDebugTriageV1` reads tasks and generates actionable report fields.
3. Reports persist to `obs.ai_debug_reports_v1`.
4. GitHub issue draft is created with `[DRAFT][AI-DEBUG]` prefix.

## Alerting
- Primary: Google Chat notification channel.
- Fallback: Email notification channel.
- Single-channel operation is forbidden.

## Privacy Guardrails
- Never log plaintext UID/email/phone.
- Use `uid_hash` only.
- Reject non-allowlisted custom keys in telemetry.

## Related
- `lib/core/observability/*`
- `lib/core/utils/error_handler.dart`
- `functions/src/index.ts`
- `functions/sql/observability/*`
- `scripts/gcp/setup_observability.sh`
