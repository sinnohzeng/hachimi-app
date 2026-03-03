# Hachimi App — Gotchas

## Account Lifecycle
- Guest local uid format is `guest_*`; this path must not call Firestore deletion APIs.
- Offline delete is local-first; cloud/Auth hard-delete may be queued.
- Pending deletion relies on authenticated context when retrying callable functions.

## Auth Linking
- `credential-already-in-use` / `email-already-in-use` in link flows should degrade to sign-in, not fail fast.
- Guest upgrade conflict decision is mandatory when both local and cloud snapshots are non-empty.

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
