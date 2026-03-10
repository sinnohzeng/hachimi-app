# 状态管理

> Riverpod Provider 拓扑 SSOT。

## Provider 分层
### 基础设施 Provider
- `sharedPreferencesProvider`
- `localDatabaseServiceProvider`
- `ledgerServiceProvider`
- `syncEngineProvider`
- 运行时可观测上下文（全局单例）：`ObservabilityRuntime`
- AI provider 选择收敛为 `firebase_gemini`（`AiProviderId` 的 wire value）。

### 后端 Provider
- `backendRegistryProvider`（单 Firebase 路径）
- `authBackendProvider`
- `syncBackendProvider`
- `userProfileBackendProvider`
- `accountLifecycleBackendProvider`

### 账户生命周期 Provider
- `identityTransitionResolverProvider`
- `accountSnapshotServiceProvider`
- `accountMergeServiceProvider`
- `guestUpgradeCoordinatorProvider`
- `accountDeletionServiceProvider`
- `accountDeletionOrchestratorProvider`

### 认证与身份 Provider
- `authStateProvider`
- `currentUidProvider`
- `isGuestProvider`
- `onboardingCompleteProvider`

## 运行时状态模型
- UI 只读取 Provider。
- 业务写入先落本地台账/物化状态。
- `SyncEngine` 异步回推 Firestore。

### LedgerChange 全局刷新模式
`LedgerChange.isGlobalRefresh` 是语义属性（当前 `type == 'hydrate'`），通知所有 StreamProvider 重新读取本地数据。此设计消除了 shotgun surgery — 不再由 8 个以上 Provider 各自检查 `change.type == 'hydrate'`，而是统一使用 `change.isGlobalRefresh || <领域过滤器>`。新增全局事件（如 `full_restore`）只需修改 `isGlobalRefresh` getter。

受影响 Provider：`habitsProvider`、`catsProvider`、`allCatsProvider`、`coinBalanceProvider`、`hasCheckedInTodayProvider`、`monthlyCheckInProvider`、`inventoryProvider`、`unlockedAchievementsProvider`、`avatarIdProvider`、`currentTitleProvider`、`unlockedTitlesProvider`。

## AuthGate 行为
1. onboarding 未完成 -> onboarding 流程。
2. 存在删号 tombstone/pending -> 待删除页面 + 重试。
3. 已认证 -> 用 auth uid 启动业务。
4. 未认证但有 cached uid -> 本地访客启动 + 匿名登录后台补齐。

登出导航已集中化：AuthGate 中 `ref.listenManual(onboardingCompleteProvider)` 监听 `true → false` 变化后调用 `popUntil(isFirst)`。各页面统一调用 `UserProfileNotifier.logout()` — 唯一登出入口。

### FirstHabitGate 水化守卫
`_FirstHabitGate` 通过检查用户是否有习惯来决定新用户路由。非访客用户的检查延迟到 `dataHydrated == true`（SyncEngine 完成 Firestore 水化后设置），防止水化前空数据导致误入领养引导的竞态条件。

## 访客升级
- 在登录页认证成功后触发。
- 认证动作前先确定迁移源 UID：
  - 优先 `local_guest_uid`
  - 缺失时回退认证前 `currentUid`
- `GuestUpgradeCoordinator` 基于快照判定合并路径。
- `GuestUpgradeCoordinator.resolve(...)` 必须接收 `migrationSourceUid`，若与本地访客 UID 不一致则中止危险迁移。
- 不再在 `AuthGate` 中做隐式 UID 迁移。

## 删号流程
- UI 仅保留三段式确认。
- 本地清理 + 云端硬删排队完全由 `AccountDeletionOrchestrator` 编排。
- `guest_*` 本地 UID 禁止触发 Firestore 删除调用。
- Orchestrator 返回类型化结果 `AccountDeletionResult`（`localDeleted`、`remoteDeleted`、`queued`、`errorCode`）。
- 远端 callable 错误仅对可重试类型保留队列；不可重试错误立即清空 pending。
- 仅在远端硬删成功后执行 signOut 与 Crashlytics 用户标识清理。
- Firebase 后端实现统一调用 `deleteAccountV2` / `wipeUserDataV2`，并携带 limited-use App Check token。

## AI 运行时

### 可用性模型

`AiAvailability` 是 2 态枚举：`ready` | `error`。

- AI 对已认证用户始终开启——没有用户侧开关。
- `AiFeatureNotifier` 和 `aiFeatureEnabledProvider` 已删除。
- 启动时乐观地设为 `ready`。首次 AI 访问时执行异步验证探测（惰性验证）。

### 断路器

`AiAvailabilityNotifier` 追踪连续失败次数：
- 连续 3 次失败触发 5 分钟退避（可用性切换为 `error`）。
- 退避到期后，下次 AI 访问自动重试。

### 网络超时保护

| 操作 | 超时 |
|------|------|
| 聊天 | 15s |
| 日记 | 20s |
| 验证探测 | 5s |
| 流式空闲 | 10s |

### 聊天每日限额

每只猫每天最多 **5 条聊天消息**，通过 `getRemainingMessages()` 检查。
- 纵深防御：服务层在达到限额时拒绝消息 + UI 禁用发送按钮。
- 限额通过 RemoteConfig 可配置（`chat_daily_limit`，默认值：5）。

## 约束
- Screen 层禁止直接调用 Firebase SDK。
- 导航副作用必须放在监听器/effect，不要写在 `build()` 中。
- Provider 层禁止重新引入 legacy 兼容分支。
- 新增持久化键必须统一进入 `AppPrefsKeys`。
- 账户生命周期 callable 必须始终传递 `OperationContext`。
- UI/Provider 层禁止注入静态 AI API key，AI 运行路径统一为 Firebase AI Logic。
