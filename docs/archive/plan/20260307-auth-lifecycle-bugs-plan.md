# 2026-03-07 账号生命周期缺陷修复与重构计划（v2）

## 范围
- 修复引导后登录导致的数据丢失。
- 修复 Settings / Drawer / Profile 三入口退出登录无响应。
- 修复删号流程状态错乱。
- 按 DDD + SSOT 同步文档与实现。

## 根因
1. **迁移源 UID 不确定**
- 登录流程直接读取 `currentUidProvider`，在匿名态与正式账号切换过程中可能漂移。
- 导致迁移命中错误源 UID，出现“看起来像丢档”。

2. **`_FirstHabitGate` 的 UID 变更生命周期缺口**
- UID 变化时复用同一 `State`，后台引擎链路没有显式串行重启。
- 异步水化/启动存在旧链路残留竞争。

3. **退出登录逻辑三处重复**
- Settings、Drawer、Profile 各有一套确认与退出实现。
- `onboardingComplete=false` 后缺少统一路由栈收敛。

4. **删号状态机不显式**
- UI 无法区分“远端成功 / 已排队 / 非重试失败”。
- 错误路径依赖异常类型名，且存在删库后不应重启的分支。

## 架构决策
1. **迁移源 UID 显式化**
- 新增 `IdentityTransitionResolver`。
- 规则固定：优先 `local_guest_uid`，缺失才回退认证前抓取的 `currentUid`。
- `GuestUpgradeCoordinator.resolve(...)` 必须传 `migrationSourceUid`。

2. **副作用移出 `build()`**
- `AuthGate` 使用 `ref.listenManual(onboardingCompleteProvider, ...)`。
- 监听 `true -> false`，统一执行 `Navigator.popUntil(isFirst)`。

3. **UID 切换引擎串行化**
- `_FirstHabitGateState` 新增 `didUpdateWidget`。
- 用 run-id 取消旧异步链路，顺序固定为：停旧 -> 恢复访客孤儿数据 -> 水化/启动新 UID -> 重建成就评估器。

4. **删号结果类型化**
- `AccountDeletionOrchestrator.deleteAccount(...)` 返回 `AccountDeletionResult`。
- 结果字段：`localDeleted`、`remoteDeleted`、`queued`、`errorCode`。
- 远端错误按 `retryable/non-retryable` 分类：
  - `retryable`：保留 pending 并递增重试
  - `non-retryable`：立即清 pending
- 仅 `remoteDeleted=true` 执行远端成功路径（含 signOut）。

## 已实施改动
- `lib/services/identity_transition_resolver.dart`（新增）
- `lib/providers/service_providers.dart`
- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/components/email_auth_screen.dart`
- `lib/services/guest_upgrade_coordinator.dart`
- `lib/app.dart`
- `lib/widgets/logout_confirmation.dart`（新增）
- `lib/screens/settings/settings_screen.dart`
- `lib/widgets/app_drawer.dart`
- `lib/screens/profile/profile_screen.dart`
- `lib/models/account_deletion_result.dart`（新增）
- `lib/services/account_deletion_orchestrator.dart`
- `lib/screens/settings/components/delete_account_flow.dart`
- `scripts/check-account-lifecycle-functions.sh`（新增）
- `test/services/account_deletion_orchestrator_test.dart`
- `test/services/identity_transition_resolver_test.dart`（新增）

## 接口变更
- `AccountDeletionOrchestrator.deleteAccount({required String uid})`
  - `Future<void>` -> `Future<AccountDeletionResult>`
- `GuestUpgradeCoordinator.resolve(...)`
  - 移除 `oldUid` 入参，改为必传 `migrationSourceUid`

## 验证（2026-03-07）
- `dart analyze lib test` -> clean
- `flutter test` -> pass
- 新增回归覆盖：
  - `functions/unimplemented` 非重试删号分支
  - 删号结果态（`queued`、`remoteDeleted`）
  - 迁移源 UID 解析优先级

## 发布门禁
- 发版前确保 `hachimi-ai` 已部署 `deleteAccountV2`、`wipeUserDataV2`。
- CI/发版前执行：`scripts/check-account-lifecycle-functions.sh hachimi-ai`。
