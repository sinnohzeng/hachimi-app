# Hachimi App — Gotchas

## Account Lifecycle
- Guest local uid format is `guest_*`; this path must not call Firestore deletion APIs.
- Offline delete is local-first; cloud/Auth hard-delete may be queued.
- Pending deletion relies on authenticated context when retrying callable functions.

## Observability
- Never log plaintext UID/email/phone; use `uid_hash` only.
- Keep `correlation_id` stable across client error, callable payload, and function logs.
- Do not emit non-allowlisted custom keys in crash/log telemetry.

## Alerting
- Google Chat channel can be Preview; Email fallback must remain enabled.
- Never run single-channel incident alerts in production.

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
