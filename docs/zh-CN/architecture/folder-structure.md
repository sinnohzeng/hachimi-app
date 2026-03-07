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
- `core/constants/`：常量 SSOT
- `core/observability/`：遥测契约（`ErrorContext`、`OperationContext`、哈希与关联 ID 工具）
- `providers/`：Riverpod 接线与状态入口
- `services/`：业务编排
- `services/firebase/`：Firebase 实现
- `screens/`：页面层
- `widgets/`：复用组件
- `widgets/celebration/`：成就庆祝弹层系统（6 个文件：`achievement_celebration_layer.dart`、`celebration_confetti_painter.dart`、`celebration_glow_icon.dart`、`celebration_overlay.dart`、`celebration_reward_badges.dart`、`celebration_tier.dart`）
- `models/`：领域模型

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
