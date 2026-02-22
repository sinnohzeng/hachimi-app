# Hachimi App — Claude Code Memory

## Project Quick Reference

- **Flutter 3.41.x + Dart 3.11.x + Firebase**
- **Riverpod 2.x** for state management
  - Notifiers use `Notifier<T>` + `NotifierProvider` (NOT `AutoDisposeNotifier`)
  - `StateNotifier` also in use for older providers (llm_provider)
- **L10N class**: `S` (defined in `l10n.yaml`, extension via `context.l10n`)
- **CI**: tag-only trigger (`v*` on push), workflow at `.github/workflows/release.yml`
- Current version: `2.8.3+28`, tag: `v2.8.3`

## Key Patterns & Conventions

- See [patterns.md](patterns.md) for detailed patterns
- See [gotchas.md](gotchas.md) for known pitfalls

## Architecture Decisions Log

- v2.8.0: Removed legacy `checkIns/{date}/entries` collection; sessions are now SSOT for focus data
- v2.8.0: FocusSession `completed` bool replaced by `status` string ('completed'/'abandoned'/'interrupted')
- v2.8.0: Sessions are immutable in Firestore (update/delete: if false)
- v2.8.0: HMAC-SHA256 signing via `--dart-define=SESSION_HMAC_KEY=xxx`
