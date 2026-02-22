# Hachimi App — Known Gotchas & Pitfalls

## Riverpod

- `AutoDisposeNotifier<T>` is NOT available in this Riverpod version. Use `Notifier<T>` + `NotifierProvider`.
- `AsyncValue<T>.valueOrNull` does NOT exist. Use `.value` (which is nullable).
- `StateNotifierProvider.autoDispose` auto-disposes the notifier — do NOT add manual `ref.onDispose(() => notifier.dispose())`.

## CI / Formatting

- CI only triggers on `v*` tag push, NOT on regular commit push.
- `dart format` is enforced in CI (`--set-exit-if-changed`). Always run `dart format lib/ test/` on the ENTIRE codebase before creating a tag — NOT just the files you think you changed.
  - **Pitfall (v2.8.2):** Adding a named parameter (e.g. `enableTap: false`) to an existing single-line constructor can push line length over 80 chars. `dart format` then reformats it to multi-line. If you only format the files you explicitly edited, you'll miss these cascading reformats.
- To fix a failed CI build: push fix commit to main, move tag to new commit (`git tag -d` + `git tag -a`), force-push tag (`git push origin vX.Y.Z --force`).
- Tag deletion sequence: `git tag -d vX.Y.Z && git push origin :refs/tags/vX.Y.Z` then recreate.

## Firestore

- `checkIns/{date}/entries` collection was REMOVED in v2.8.0. Do not reference it.
- `monthly_check_in.dart` (daily rewards/sign-in) is DIFFERENT from the removed `check_in.dart` (focus session logging). Do not confuse them.
- Sessions live under `habits/{habitId}/sessions/{sessionId}` — they are subcollections per habit, NOT a top-level collection.
- Cross-habit session queries require parallel per-habit queries merged client-side.

## Flutter

- `google_fonts` 6.x breaks with Flutter 3.41 (FontWeight const) — use 8.x+.
- `CardTheme` → `CardThemeData` in Flutter 3.41+.
- JDK 25 is incompatible with Gradle 8.x — use JDK 17.
- AGP 9 breaks Flutter 3.41 plugins — use AGP 8.x.
- vivo USB install: use `adb install -r -t -d` when `flutter run` fails.

## DDD (Document-Driven Development)

- Always update docs (EN + zh-CN) BEFORE or alongside code changes.
- Analytics events must be documented in `docs/firebase/analytics-events.md` (EN + zh-CN).
- The `docs/firebase/analytics-events.md` has a DebugView Verification Checklist at the bottom — add new events there too.
