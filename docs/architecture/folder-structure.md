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
- `models/awareness_stats.dart`: AwarenessStats data class (mood distribution, tag frequency, streaks)
- `models/daily_light.dart`: DailyLight model
- `models/weekly_review.dart`: WeeklyReview model
- `models/worry.dart`: Worry model + WorryStatus enum
- `core/constants/awareness_constants.dart`: preset tags + cat reaction seed copy
- `providers/awareness_providers.dart`: 7 awareness providers
- `services/awareness_repository.dart`: DailyLight + WeeklyReview CRUD
- `services/worry_repository.dart`: Worry CRUD
- `screens/awareness/`: awareness feature screens (7 files)
- `screens/awareness/awareness_screen.dart`: awareness main screen (3 sub-tabs)
- `screens/awareness/daily_light_screen.dart`: daily light entry
- `screens/awareness/weekly_review_screen.dart`: weekly review form
- `screens/awareness/worry_processor_screen.dart`: worry list management
- `screens/awareness/worry_edit_screen.dart`: worry create/edit
- `screens/awareness/awareness_history_screen.dart`: awareness history (mood calendar + weekly review list)
- `screens/awareness/daily_detail_screen.dart`: read-only daily detail (mood + text + tags + timeline)
- `widgets/awareness/`: awareness reusable widgets (10 files)
- `widgets/awareness/mood_selector.dart`: mood picker
- `widgets/awareness/light_input_card.dart`: daily light input card
- `widgets/awareness/tag_selector.dart`: tag picker
- `widgets/awareness/happy_moment_card.dart`: happy moment card
- `widgets/awareness/worry_item_card.dart`: worry item card
- `widgets/awareness/cat_bedtime_animation.dart`: cat mood-sensing animation
- `widgets/awareness/awareness_empty_state.dart`: awareness empty state
- `widgets/awareness/mood_calendar.dart`: monthly mood calendar grid
- `widgets/awareness/awareness_stats_card.dart`: awareness stats card (mood distribution, tag frequency)
- `widgets/awareness/timeline_editor.dart`: timeline editor for daily light entries

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

## B5 File Moves
Files moved from `core/utils/` to `services/` (they contain business logic, not pure utilities):
- `core/utils/deferred_init.dart` → `services/deferred_init.dart`
- `core/utils/performance_traces.dart` → `services/performance_traces.dart`
- `core/utils/auth_error_mapper.dart` → `services/auth_error_mapper.dart`

## Removed Legacy Files
- `lib/services/migration_service.dart`
- `lib/services/remote_config_service.dart`
- `lib/core/utils/offline_write_guard.dart`

## V3 LUMI New Directories and Files

### `lib/screens/today/` — 今天 Tab（新建）
- `today_screen.dart`: 今天 Tab 主屏幕（QuickLightCard + HabitSnapshot + InspirationCard）

### `lib/screens/journey/` — 旅程 Tab（新建）
- `journey_screen.dart`: 旅程 Tab 主屏幕（SegmentedButton: 本周/本月/年度/探索）
- `weekly_view.dart`: 本周视图（WeeklyPlan + WeeklyReview + WorryJar）
- `monthly_view.dart`: 本月视图（Calendar + Goals + SmallWin + Habits + MoodTracker + Memory）
- `yearly_view.dart`: 年度视图（Messages + GrowthPlan + Calendar + Lists + SmallWin100 + Highlights）
- `explore_view.dart`: 探索视图（6 主题月度活动入口）
- `activities/`: 月度活动子目录
  - `habit_pact_screen.dart`: 习惯约定（四法则）
  - `worry_unload_screen.dart`: 烦恼减负日
  - `self_praise_screen.dart`: 夸夸群
  - `support_map_screen.dart`: 身边的人
  - `future_self_screen.dart`: 未来照见我
  - `ideal_vs_real_screen.dart`: 理想 vs 现在
- `lists/`: 清单子目录
  - `list_screen.dart`: 清单详情页（书单/影单/自定义）
  - `year_pick_screen.dart`: 年度精选页
- `highlight_moments_screen.dart`: 幸福/高光时刻
- `small_win_100_screen.dart`: 100 天挑战

### `lib/screens/onboarding/` — Onboarding（更新）
- `onboarding_screen.dart`: 更新为 LUMI 4 页引导（替换旧猫咪 3 页）

### `lib/screens/profile/` — 我的 Tab（更新）
- `profile_screen.dart`: 更新——新增 LumiStatsCard + CatCompanionCard（二级入口）+ GrowthReview 入口
- `growth_review_screen.dart`: 成长回望（新建）

### `lib/widgets/lumi/` — LUMI 可复用组件（新建）
- `grid_tracker.dart`: 通用网格打卡组件（31 天 / 100 天）
- `mood_tracker_matrix.dart`: 5 周 x 7 天心情矩阵
- `monthly_goals_card.dart`: 月目标卡片（5 条）
- `small_win_challenge.dart`: 小赢挑战卡片（31 天打卡 + 四法则 + 奖励）
- `yearly_messages_page.dart`: 年度寄语 7 问
- `growth_plan_card.dart`: 成长计划 8 维度卡片
- `annual_calendar_grid.dart`: 年历点阵（12 月 x 31 天）
- `inspiration_card.dart`: 灵感卡片
- `moment_card.dart`: 幸福/高光时刻卡片
- `list_item_card.dart`: 清单条目卡片
- `year_pick_section.dart`: 年度精选组件
- `worry_jar_animation.dart`: 烦恼罐分类动画
- `eisenhower_matrix.dart`: 艾森豪威尔四象限
- `star_counter.dart`: 星星累积动画

### `lib/models/` — 新增模型
- `yearly_plan.dart`: YearlyPlan 模型
- `monthly_plan.dart`: MonthlyPlan 模型
- `weekly_plan.dart`: WeeklyPlan 模型
- `user_list.dart`: UserList 模型（书单/影单/自定义清单）
- `highlight_entry.dart`: HighlightEntry 模型（幸福/高光时刻）
- `feature_gate.dart`: FeatureGate 数据类

### `lib/providers/` — 新增 Providers
- `journey_providers.dart`: yearlyPlan / monthlyPlan / weeklyPlan providers
- `feature_gate_provider.dart`: 渐进解锁 FeatureGateProvider
- `inspiration_provider.dart`: 每日灵感轮换 Provider

### `lib/services/` — 新增 Repositories
- `journey_repository.dart`: YearlyPlan / MonthlyPlan / WeeklyPlan CRUD

### `lib/core/constants/` — 新增常量
- `lumi_constants.dart`: LUMI 灵感清单常量（9 习惯模板 + ~50 爱自己活动 + 8 维度成长灵感）

## Rules
- Generated localization files under `lib/l10n/app_localizations*.dart` are excluded from quality gate.
- Business logic must not depend on archived docs.
- New architecture changes must update both `docs/` and `docs/zh-CN/` mirrors.
