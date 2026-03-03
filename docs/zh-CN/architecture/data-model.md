# 数据模型

> 2026-03 重构后账户生命周期相关数据 SSOT。

## Firestore 结构
```
users/{uid}
├── habits/{habitId}
│   └── sessions/{sessionId}
├── cats/{catId}
├── achievements/{achievementId}
└── monthlyCheckIns/{yyyy-MM}
```

## 用户文档（`users/{uid}`）
核心字段：
- `email`（string）
- `displayName`（string）
- `coins`（int）
- `inventory`（array<string>）
- `createdAt`（timestamp）

可选字段：
- `avatarId`
- `currentTitle`
- `lastCheckInDate`

`ensureProfile(...)` 必须幂等，禁止覆盖已有用户文档。

## 本地 SQLite（运行时 SSOT）
- `action_ledger`：不可变行为台账
- `materialized_state`：聚合缓存（金币、资料等）
- `local_habits`
- `local_cats`
- `local_sessions`
- `local_monthly_checkins`
- `local_achievements`

## SharedPreferences 键
### 身份
- `cached_uid`
- `local_guest_uid`

### 同步
- `local_data_hydrated_v1`

### 删号队列
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Cloud Functions
### `deleteAccountV1`
- 需要登录态。
- 递归删除 `users/{uid}` 全量业务数据。
- 删除 Firebase Auth 用户。
- 对缺失文档/缺失用户幂等成功。

### `wipeUserDataV1`
- 需要登录态。
- 仅递归删除 `users/{uid}` 业务数据。
- 保留 Firebase Auth 用户。
- 用于访客升级 `keepLocal` 路径。

## 合并语义
- 保留云端：删除旧访客本地数据，云端 hydrate 覆盖本地。
- 保留本地：先清空云端，再迁移本地 UID 并回推。

## 删号语义
- 本地先删不可恢复。
- 云端/Auth 在线立即硬删，离线则排队补删。
- 启动期与轮询重试自动推进 pending job。
