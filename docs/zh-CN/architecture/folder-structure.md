# 目录结构

> 当前生效目录布局 SSOT。

## 顶层结构
```
hachimi-app/
├── lib/
├── test/
├── functions/                 # Firebase Cloud Functions（Node 20 + TypeScript）
├── tool/                      # quality_gate.dart
├── docs/
│   ├── archive/               # 归档文档
│   └── zh-CN/archive/
├── firestore.rules
├── firebase.json
└── .github/workflows/
```

## `lib/` 核心域
- `core/backend/`：后端抽象（运行时仅 Firebase）
- `core/theme/skins/`：ThemeSkin 策略实现（`theme_skin.dart`、`material_skin.dart`、`retro_pixel_skin.dart`）
- `core/constants/`：常量 SSOT
- `core/observability/`：遥测契约（`ErrorContext`、`OperationContext`、哈希与关联 ID 工具）
- `providers/`：Riverpod 接线与状态入口
- `services/`：业务编排
- `services/firebase/`：Firebase 实现
- `screens/`：页面层
- `screens/timer/components/`：计时器页面提取组件（`stat_row.dart`、`timer_controls.dart`、`focus_cat_display.dart`、`focus_session_stats_card.dart`）
- `screens/cat_detail/components/`：猫咪详情提取卡片（7 个卡片组件）
- `widgets/`：复用组件
- `widgets/pixel_ui/`：复古像素 UI 组件（16 个文件：`pixel_border.dart`、`pixel_badge.dart`、`pixel_button.dart`、`pixel_card.dart`、`pixel_chat_bubble.dart`、`pixel_coin_display.dart`、`pixel_diary_entry.dart`、`pixel_loading_indicator.dart`、`pixel_milestone.dart`、`pixel_progress_bar.dart`、`pixel_progress_ring.dart`、`pixel_section_header.dart`、`pixel_skeleton_loader.dart`、`pixel_stat_row.dart`、`pixel_switch.dart`、`retro_tiled_background.dart`）
- `widgets/celebration/`：成就庆祝弹层系统（6 个文件：`achievement_celebration_layer.dart`、`celebration_confetti_painter.dart`、`celebration_glow_icon.dart`、`celebration_overlay.dart`、`celebration_reward_badges.dart`、`celebration_tier.dart`）
- `models/`：领域模型
- `models/mood.dart`：5 级心情枚举
- `models/daily_light.dart`：每日一光模型
- `models/weekly_review.dart`：周回顾模型
- `models/worry.dart`：烦恼模型 + WorryStatus 枚举
- `core/constants/awareness_constants.dart`：预设标签 + 猫咪反应种子文案
- `providers/awareness_providers.dart`：7 个觉知 Provider
- `services/awareness_repository.dart`：DailyLight + WeeklyReview CRUD
- `services/worry_repository.dart`：Worry CRUD
- `screens/awareness/`：觉知功能页面（5 个文件）
- `screens/awareness/awareness_screen.dart`：觉知主屏（3 子 Tab）
- `screens/awareness/daily_light_screen.dart`：一点光录入
- `screens/awareness/weekly_review_screen.dart`：周回顾表单
- `screens/awareness/worry_processor_screen.dart`：烦恼列表管理
- `screens/awareness/worry_edit_screen.dart`：烦恼新建/编辑
- `widgets/awareness/`：觉知复用组件（7 个文件）
- `widgets/awareness/mood_selector.dart`：心情选择器
- `widgets/awareness/light_input_card.dart`：一点光输入卡片
- `widgets/awareness/tag_selector.dart`：标签选择器
- `widgets/awareness/happy_moment_card.dart`：幸福时刻卡片
- `widgets/awareness/worry_item_card.dart`：烦恼条目卡片
- `widgets/awareness/cat_bedtime_animation.dart`：猫咪心情感应动画
- `widgets/awareness/awareness_empty_state.dart`：觉知空状态

## 账户生命周期关键文件
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

## 已移除 legacy 文件
- `lib/services/migration_service.dart`
- `lib/services/remote_config_service.dart`
- `lib/core/utils/offline_write_guard.dart`

## 约束
- `lib/l10n/app_localizations*.dart` 属于生成文件，质量闸门豁免。
- 新架构变更需同步更新 `docs/` 与 `docs/zh-CN/`。
- 归档文档仅做追溯，不可作为实现依据。
