# Architecture Overview

> SSOT for the runtime architecture after 2026-03 security and observability modernization.

## Core Principles
- Offline-first runtime state: local SQLite + ledger are runtime SSOT.
- Deterministic sync: `SyncEngine` reconciles local actions to Firestore.
- Google-first security: App Check + IAM/ADC + Secret Manager.
- No client-side static AI API keys in release path.

## Stack
| Layer | Technology |
|---|---|
| App | Flutter 3.41.x + Dart 3.11.x |
| State | Riverpod 3.x |
| Local storage | sqflite + SharedPreferences |
| Auth/Data | Firebase Auth + Firestore |
| Server account ops | Firebase Functions callable V2 |
| AI | Firebase AI Logic + Vertex AI |
| Observability | Crashlytics + Cloud Logging + BigQuery + Google Chat/Email |
| Infra control plane | Terraform |

## Layered Design
```text
Screens -> Providers -> Services -> Backend abstractions -> Firebase SDK / Cloud Functions
```

## Account Lifecycle
### Guest upgrade conflict
1. Auth succeeds.
2. Build local snapshot + cloud snapshot.
3. Resolve conflict matrix (`keepLocal` / `keepCloud` / explicit choice).
4. Execute merge via `AccountMergeService`.

### Account deletion (offline-first)
1. Confirm summary + `DELETE` confirmation.
2. `AccountDeletionOrchestrator` cleans local data first.
3. Online path calls `deleteAccountV2`.
4. Offline path queues pending deletion and retries.
5. UI `_executeDelete` uses a `finally` invariant: if `localDataDestroyed && !navigatedAway`, onboarding is unconditionally reset — no error path can leave the app in a half-destroyed state.

## Cloud Functions Contract
Primary callable contract:
- `deleteAccountV2`
- `wipeUserDataV2`

Contract requirements:
- Authenticated user context
- App Check enforced (and token consume for replay protection)
- `OperationContext` payload:
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

Compatibility aliases (`V1`) still exist for safe migration.

## AI and Security Contract
- Client AI provider is `firebase_gemini` only.
- Server triage function is `runAiDebugTriageV2`.
- GitHub issue draft creation uses GitHub App installation token flow.
- GitHub App private key is stored in Secret Manager.

## Observability Contract
- Client errors go through typed `ErrorContext` + `ErrorHandler.record(...)`.
- PII redline: no plaintext UID/email/phone in telemetry.
- Functions structured logs must include:
  - `correlation_id`
  - `uid_hash`
  - `function_name`
  - `latency_ms`
  - `result`
  - `error_code`
- Alert channels are fixed to Google Chat + Email.

## Android Platform Configuration
- **Edge-to-edge**: `enableEdgeToEdge()` in `MainActivity.onCreate()` (SSOT for native window config).
- **Base activity**: `FlutterFragmentActivity` (provides `ComponentActivity` for AndroidX edge-to-edge API).
- **Themes**: `Theme.Material3.Light.NoActionBar` / `Theme.Material3.Dark.NoActionBar`.
- **System bar styling**: `AppBarTheme.systemOverlayStyle` in `app_theme.dart` (SSOT for Flutter-side system UI).
- **Dependencies**: `activity-ktx:1.10.1`, `material:1.12.0` (explicit in `build.gradle`).
- **Predictive back**: `android:enableOnBackInvokedCallback="true"` in AndroidManifest.

## Dual UI Style Architecture

The app supports two visual modes switchable in Settings:

- **Material 3** — standard M3 rounded components, dynamic color support.
- **Retro Pixel** — Stardew Valley-inspired warm pixel-art aesthetic with `PixelBorderShape` stepped corners on all Material components.

Architecture:
- `ThemeSkin` strategy pattern (`MaterialSkin` / `RetroPixelSkin`) eliminates conditional branching in theme construction.
- `PixelBorderShape extends OutlinedBorder` — injected into `cardTheme.shape`, `dialogTheme.shape`, etc. via theme cascade. One `ShapeBorder` replaces 7+ wrapper components.
- Retro colors map onto `ColorScheme` slots (e.g., `surface` → retro background, `outline` → pixel border) so all existing Material widgets auto-adapt with zero code changes.
- `AppScaffold` wraps `Scaffold` and conditionally overlays `RetroTiledBackground` in retro mode — single integration point for 23+ screens.
- `PixelThemeExtension` carries pixel-only tokens (XP bar, success/warning colors, Silkscreen text styles).

## SSOT Snapshot
| Concern | SSOT |
|---|---|
| Runtime business state | SQLite (`local_*`, `materialized_state`) |
| Write log | `action_ledger` |
| Cloud persistence | Firestore `users/{uid}` subtree |
| Auth state | `authStateProvider` |
| Observability schema | `docs/architecture/observability.md` |
| Infra state | `infra/terraform/*` |
