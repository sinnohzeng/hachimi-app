# Crashlytics Integration

## Current Error Contract
- All caught exceptions must use `ErrorHandler.record(...)` with `ErrorContext`.
- `ErrorContext` mandatory fields:
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

## Identity and Privacy
- Crashlytics user identifier must be hashed (`uid_hash`).
- Never send plaintext UID, email, or phone into custom keys.
- Custom tags are filtered by `ObservabilityTags` allowlist.

## Runtime Entry Points
- Flutter framework fatal errors are routed through `ErrorHandler.recordOperation(..., fatal: true)`.
- Platform async fatal errors are routed through `ErrorHandler.recordOperation(..., fatal: true)`.
- Service/provider/domain non-fatal errors use `ErrorHandler.recordOperation(...)`.

## Correlation
For account lifecycle and retry flows:
- client side error events must include `correlation_id`
- callable requests must pass `OperationContext`
- function logs must keep same `correlation_id`

## Verification
```bash
# Trigger a synthetic non-fatal from app code path
# and verify Crashlytics dashboard + BigQuery export.
```

Validation targets:
1. Event visible in Crashlytics within 5 minutes.
2. Same issue visible in BigQuery within 60 minutes.
3. `correlation_id` matches function logs for callable-related failures.
