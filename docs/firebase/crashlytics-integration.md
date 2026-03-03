# Crashlytics Integration

## Current Error Pipeline
- Use `ErrorHandler.record(...)` for non-fatal errors.
- Flutter framework errors are routed through `FirebaseCrashlytics.instance.recordFlutterFatalError`.
- Platform async errors are captured in `PlatformDispatcher.instance.onError`.

## Where to Record
- Service-layer failures (sync, auth orchestration, deletion orchestration).
- Catch blocks where user flow continues after fallback.
- Permanent sync failures and deletion retry failures.

## What Was Removed
- `OfflineWriteGuard` is removed from runtime architecture.
- Local-first resilience now relies on SQLite ledger + deletion pending queue orchestrator.

## Verification
```bash
# Trigger a test crash in debug build
FirebaseCrashlytics.instance.crash();
```
Check Firebase Console -> Crashlytics.

## Operational Note
For account deletion failures, prefer recording in `AccountDeletionOrchestrator` with context:
- operation name
- retry count
- error code/type
