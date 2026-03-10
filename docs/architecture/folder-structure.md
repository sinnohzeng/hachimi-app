# Folder Structure

> SSOT for active folder layout.

## Top-Level
```
hachimi-app/
├── lib/
├── test/
├── functions/                 # Firebase Cloud Functions (Node 20 + TypeScript)
├── tool/                      # quality_gate.dart
├── docs/
│   ├── archive/               # archived docs only
│   └── zh-CN/archive/
├── firestore.rules
├── firebase.json
└── .github/workflows/
```

## `lib/` Key Domains
- `core/backend/`: backend abstractions (Firebase-only runtime path)
- `core/constants/`: constants SSOT
- `core/observability/`: telemetry contracts (`ErrorContext`, `OperationContext`, hashing/correlation helpers)
- `providers/`: Riverpod providers and service wiring
- `services/`: orchestration/business logic
- `services/firebase/`: Firebase backend implementations
- `screens/`: UI pages
- `widgets/`: reusable UI components
- `widgets/celebration/`: achievement celebration overlay system (6 files: `achievement_celebration_layer.dart`, `celebration_confetti_painter.dart`, `celebration_glow_icon.dart`, `celebration_overlay.dart`, `celebration_reward_badges.dart`, `celebration_tier.dart`)
- `models/`: domain models

## Account Lifecycle Files
- `lib/models/account_data_snapshot.dart`
- `lib/services/account_snapshot_service.dart`
- `lib/services/account_merge_service.dart`
- `lib/services/guest_upgrade_coordinator.dart`
- `lib/services/account_deletion_service.dart`
- `lib/services/account_deletion_orchestrator.dart`
- `lib/core/backend/account_lifecycle_backend.dart`
- `lib/services/firebase/firebase_account_lifecycle_backend.dart`
- `lib/widgets/archive_conflict_dialog.dart`
- `lib/widgets/logout_confirmation.dart`
- `lib/services/identity_transition_resolver.dart`
- `lib/models/account_deletion_result.dart`
- `lib/core/observability/error_context.dart`
- `lib/core/observability/operation_context.dart`

## Removed Legacy Files
- `lib/services/migration_service.dart`
- `lib/services/remote_config_service.dart`
- `lib/core/utils/offline_write_guard.dart`

## Rules
- Generated localization files under `lib/l10n/app_localizations*.dart` are excluded from quality gate.
- Business logic must not depend on archived docs.
- New architecture changes must update both `docs/` and `docs/zh-CN/` mirrors.
