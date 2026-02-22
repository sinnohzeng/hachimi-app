# Hachimi App — Patterns & Conventions

## Riverpod Notifier Pattern

The project uses Riverpod 2.x. The available Notifier base class is `Notifier<T>` (NOT `AutoDisposeNotifier`).

```dart
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() { ... }
}

final myProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);
```

For auto-dispose behavior, use `StateNotifierProvider.autoDispose` or other standard auto-dispose variants.

## Provider Graph (SSOT: docs/architecture/state-management.md)

- Service providers: `firestoreServiceProvider`, `analyticsServiceProvider` (in `service_providers.dart`)
- `auth_provider.dart` re-exports `service_providers.dart` — importing auth_provider gives access to all service providers
- `currentUidProvider` is in `auth_provider.dart`

## Firestore Cross-Collection Queries

Firestore doesn't support joins. For cross-habit queries (sessions live under `habits/{habitId}/sessions`):
- Launch parallel per-habit queries
- Merge results client-side
- Sort by timestamp
- Use `_mergeStreams()` helper for streaming queries

## Analytics in Widgets

- For `ConsumerWidget` (stateless): cannot use `initState`. Convert to `ConsumerStatefulWidget` if one-time analytics logging is needed.
- For `ConsumerStatefulWidget`: log analytics in `initState` via `WidgetsBinding.instance.addPostFrameCallback`.
- NEVER log analytics in `build()` — it fires on every rebuild.

## L10N Workflow

1. Add keys to `app_en.arb` (template) + all other `.arb` files
2. Run `flutter gen-l10n` (auto-triggered by l10n.yaml config)
3. Generated files: `app_localizations.dart`, `app_localizations_en.dart`, etc.
4. Access via `context.l10n` (extension in `l10n_ext.dart`)
5. L10N class name is `S`

## CI Pipeline

- Trigger: only on `v*` tag push (not on regular commits)
- Steps: format check → static analysis → tests → build release APK → create GitHub Release
- `dart format --set-exit-if-changed lib/ test/` is enforced — always run `dart format lib/ test/` before tagging
- To retrigger CI after a fix: delete tag (local + remote), recreate on new commit, push again

## Dark Mode Pattern

Use brightness-aware alpha values via `color_utils.dart`:

```dart
final brightness = Theme.of(context).brightness;
color.withValues(alpha: brightness == Brightness.dark ? 0.8 : 0.5)
```

For semantic status colors: `StatusColors.onSuccess(brightness)`, `StatusColors.successContainer(brightness)`.

## FocusSession Model (v2.8.0+)

Key fields: `status` (string, not bool), `targetDurationMinutes`, `pausedSeconds`, `completionRatio`, `checksum`, `clientVersion`.
Convenience getters: `isCompleted`, `isAbandoned`.
Sessions are immutable in Firestore (cannot update/delete).

## AsyncValue Access

- Use `.value` (nullable) to read async provider values
- `.valueOrNull` does NOT exist on `AsyncValue<T>` in this Flutter/Riverpod version
