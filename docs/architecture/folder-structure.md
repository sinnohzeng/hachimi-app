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
- `core/theme/skins/`: ThemeSkin strategy implementations (`theme_skin.dart`, `material_skin.dart`, `retro_pixel_skin.dart`)
- `core/constants/`: constants SSOT
- `core/observability/`: telemetry contracts (`ErrorContext`, `OperationContext`, hashing/correlation helpers)
- `providers/`: Riverpod providers and service wiring
- `services/`: orchestration/business logic
- `services/firebase/`: Firebase backend implementations
- `screens/`: UI pages
- `screens/timer/components/`: timer screen extracted widgets (`stat_row.dart`, `timer_controls.dart`, `focus_cat_display.dart`, `focus_session_stats_card.dart`)
- `screens/cat_detail/components/`: cat detail extracted cards (7 card widgets)
- `widgets/`: reusable UI components
- `widgets/pixel_ui/`: pixel-art UI components for Retro Pixel mode (16 files: `pixel_border.dart`, `pixel_badge.dart`, `pixel_button.dart`, `pixel_card.dart`, `pixel_chat_bubble.dart`, `pixel_coin_display.dart`, `pixel_diary_entry.dart`, `pixel_loading_indicator.dart`, `pixel_milestone.dart`, `pixel_progress_bar.dart`, `pixel_progress_ring.dart`, `pixel_section_header.dart`, `pixel_skeleton_loader.dart`, `pixel_stat_row.dart`, `pixel_switch.dart`, `retro_tiled_background.dart`)
- `widgets/celebration/`: achievement celebration overlay system (6 files: `achievement_celebration_layer.dart`, `celebration_confetti_painter.dart`, `celebration_glow_icon.dart`, `celebration_overlay.dart`, `celebration_reward_badges.dart`, `celebration_tier.dart`)
- `models/`: domain models
- `models/mood.dart`: 5-level mood enum for awareness
- `models/daily_light.dart`: DailyLight model
- `models/weekly_review.dart`: WeeklyReview model
- `models/worry.dart`: Worry model + WorryStatus enum
- `core/constants/awareness_constants.dart`: preset tags + cat reaction seed copy
- `providers/awareness_providers.dart`: 7 awareness providers
- `services/awareness_repository.dart`: DailyLight + WeeklyReview CRUD
- `services/worry_repository.dart`: Worry CRUD
- `screens/awareness/`: awareness feature screens (5 files)
- `screens/awareness/awareness_screen.dart`: awareness main screen (3 sub-tabs)
- `screens/awareness/daily_light_screen.dart`: daily light entry
- `screens/awareness/weekly_review_screen.dart`: weekly review form
- `screens/awareness/worry_processor_screen.dart`: worry list management
- `screens/awareness/worry_edit_screen.dart`: worry create/edit
- `widgets/awareness/`: awareness reusable widgets (7 files)
- `widgets/awareness/mood_selector.dart`: mood picker
- `widgets/awareness/light_input_card.dart`: daily light input card
- `widgets/awareness/tag_selector.dart`: tag picker
- `widgets/awareness/happy_moment_card.dart`: happy moment card
- `widgets/awareness/worry_item_card.dart`: worry item card
- `widgets/awareness/cat_bedtime_animation.dart`: cat mood-sensing animation
- `widgets/awareness/awareness_empty_state.dart`: awareness empty state

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
