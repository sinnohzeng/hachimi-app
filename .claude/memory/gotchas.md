# Hachimi App — Gotchas

## Account Lifecycle
- Guest local uid format is `guest_*`; this path must not call Firestore deletion APIs.
- Never derive guest merge source from post-auth state; capture deterministic source before auth mutation.
- Offline delete is local-first; cloud/Auth hard-delete may be queued.
- Pending deletion relies on authenticated context when retrying callable functions.
- Do not force sign-out when deletion is queued for retry; this breaks the retry loop.
- Non-retryable callable errors (`unimplemented`, `not-found`, `permission-denied`, etc.) should clear pending markers immediately.

## Navigation
- Do not perform navigation side effects directly inside widget `build()`.
- Use provider/listener effects for auth/onboarding route stack normalization.

## App Check
- `deleteAccountV2` / `wipeUserDataV2` require valid App Check token.
- Replay tokens are rejected when `consumeAppCheckToken` marks token already consumed.

## Observability
- Never log plaintext UID/email/phone; use `uid_hash` only.
- Keep `correlation_id` stable across client error, callable payload, and function logs.
- Do not emit non-allowlisted custom keys in crash/log telemetry.

## Alerting
- Google Chat channel can be Preview; Email fallback must remain enabled.
- Never run single-channel incident alerts in production.
- Billing Budget API does not accept Google Chat notification channels in this setup; use Email channel for budget notifications.

## Credentials
- Do not reintroduce long-lived PAT for GitHub issue automation.
- Do not reintroduce client static AI API key release path.
- GitHub App private key must stay in Secret Manager with least-privilege access.
- Keep ADC quota project set to `hachimi-ai` for Terraform budget operations.

## Quality Gate
- Quality gate applies to hand-written `lib/` files only.
- Generated localization files (`lib/l10n/app_localizations*.dart`) are excluded.

## CI
- Main release workflow is tag-triggered only (`v*`).
- Always run locally before push:
  - `dart analyze lib test`
  - `flutter test --exclude-tags golden`
  - `dart run tool/quality_gate.dart`
  - `cd functions && npm test`
