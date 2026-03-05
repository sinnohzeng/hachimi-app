# Observability Architecture

> SSOT for telemetry contract, data pipeline, and AI debug closed loop.

## Purpose
Define one end-to-end contract from app runtime errors to AI triage reports and incident alerts.

## Core Contracts
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

### Callable telemetry response
- `ok`
- `correlation_id`
- `function_name`
- `latency_ms`
- `result`
- `error_code?`

## Client Pipeline
1. Catch exception.
2. Build typed `ErrorContext`.
3. `ErrorHandler.record(...)` filters tags by allowlist.
4. Crashlytics custom keys + error event recorded.
5. Analytics `app_error` emitted with correlation metadata.

## Callable Pipeline
Sensitive operations:
- `deleteAccountV2`
- `wipeUserDataV2`

Execution rules:
1. Validate auth and `OperationContext`.
2. Enforce App Check and consume token.
3. Emit structured start/success/failure logs.
4. Return telemetry envelope or typed `HttpsError`.

## Data Plane
- Crashlytics export -> BigQuery + Cloud Logging.
- Analytics export -> BigQuery.
- Functions logs -> Cloud Logging -> BigQuery sink.
- BigQuery `obs` dataset stores:
  - `issue_daily_v1`
  - `issue_velocity_v1`
  - `issue_user_impact_v1`
  - `flow_error_funnel_v1`
  - `release_stability_v1`
  - `ai_debug_tasks_v1`
  - `ai_debug_reports_v1`

## AI Debug Loop
1. Scheduled query refreshes `ai_debug_tasks_v1` every 15 minutes.
2. `runAiDebugTriageV2` reads tasks and invokes Vertex AI with IAM/ADC.
3. Fallback heuristic is used if AI call fails.
4. Output writes to `ai_debug_reports_v1`.
5. Draft GitHub issue is created with GitHub App installation token.

## Alerting
Allowed channels:
- Google Chat (primary)
- Email (fallback)

Required policy names:
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`
- `budget_threshold`

## Privacy and Compliance
- Never log plaintext UID/email/phone.
- `uid_hash` only for identity correlation.
- Non-allowlisted custom keys are dropped.
- Keep audit fields for AI reports: `model_name`, `prompt_version`, `decision_trace_id`.

## Source Files
- `lib/core/observability/*`
- `lib/core/utils/error_handler.dart`
- `lib/services/firebase/firebase_account_lifecycle_backend.dart`
- `functions/src/index.ts`
- `infra/terraform/modules/observability/*`
