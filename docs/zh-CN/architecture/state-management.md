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

## AuthGate 行为
1. onboarding 未完成 -> onboarding 流程。
2. 存在删号 tombstone/pending -> 待删除页面 + 重试。
3. 已认证 -> 用 auth uid 启动业务。
4. 未认证但有 cached uid -> 本地访客启动 + 匿名登录后台补齐。

## 访客升级
- 在登录页认证成功后触发。
- `GuestUpgradeCoordinator` 基于快照判定合并路径。
- 不再在 `AuthGate` 中做隐式 UID 迁移。

## 删号流程
- UI 仅保留三段式确认。
- 本地清理 + 云端硬删排队完全由 `AccountDeletionOrchestrator` 编排。
- `guest_*` 本地 UID 禁止触发 Firestore 删除调用。
- Firebase 后端实现统一调用 `deleteAccountV2` / `wipeUserDataV2`，并携带 limited-use App Check token。

## 约束
- Screen 层禁止直接调用 Firebase SDK。
- Provider 层禁止重新引入 legacy 兼容分支。
- 新增持久化键必须统一进入 `AppPrefsKeys`。
- 账户生命周期 callable 必须始终传递 `OperationContext`。
- UI/Provider 层禁止注入静态 AI API key，AI 运行路径统一为 Firebase AI Logic。
