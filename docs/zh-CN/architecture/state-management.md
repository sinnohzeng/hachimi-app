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
- `authStateProvider` — Firebase Auth 流（SSOT）
- `appAuthStateProvider` — sealed class 组合认证流 + 本地访客 UID → `AuthenticatedState | GuestState`
- `currentUidProvider` — 从 `appAuthStateProvider` 派生（向后兼容，26+ 文件引用）
- `isGuestProvider` — 从 `appAuthStateProvider` 派生（向后兼容，5 文件引用）
- `onboardingCompleteProvider`

## 运行时状态模型
- UI 只读取 Provider。
- 业务写入先落本地台账/物化状态。
- `SyncEngine` 异步回推 Firestore。

### LedgerChange 全局刷新模式
`LedgerChange.isGlobalRefresh` 是语义属性（当前 `type == 'hydrate'`），通知所有 StreamProvider 重新读取本地数据。此设计消除了 shotgun surgery — 不再由 8 个以上 Provider 各自检查 `change.type == 'hydrate'`，而是统一使用 `change.isGlobalRefresh || <领域过滤器>`。新增全局事件（如 `full_restore`）只需修改 `isGlobalRefresh` getter。

受影响 Provider：`habitsProvider`、`catsProvider`、`allCatsProvider`、`coinBalanceProvider`、`hasCheckedInTodayProvider`、`monthlyCheckInProvider`、`inventoryProvider`、`unlockedAchievementsProvider`、`avatarIdProvider`、`currentTitleProvider`、`unlockedTitlesProvider`。

## AppAuthState — Sealed Class 身份模型

`AppAuthState`（位于 `lib/models/app_auth_state.dart`）用 sealed class 替代之前的 boolean `isGuest` 方案，使身份状态穷举且可模式匹配：

```
sealed class AppAuthState
├── AuthenticatedState(uid, email?, displayName?)
└── GuestState(uid)  // uid 可为空（引导前）
```

`appAuthStateProvider` 是组合 Firebase Auth 流 + 本地访客 UID 的单一 SSOT。所有下游消费者（`currentUidProvider`、`isGuestProvider`、侧边栏、AuthGate）均从该单一来源通过 `ref.watch(appAuthStateProvider)` 派生。

## AuthGate 行为
1. onboarding 未完成：
   - `hasOnboardedBefore == false` → 首次用户 → 显示 OnboardingScreen。
   - `hasOnboardedBefore == true` → 登出后的返回用户 → 自动跳过教程，创建访客 UID，恢复 onboarding 状态。
2. 存在删号 tombstone/pending → 待删除页面 + 重试。
3. `switch (appAuthStateProvider)`：
   - `AuthenticatedState` → 用 auth UID 启动业务。
   - `GuestState`（uid 非空）→ 本地访客启动。
   - `GuestState`（uid 空）→ 加载动画（引导前）。

`hasOnboardedBefore` 是在首次完成引导时设置的持久化 SharedPreferences 标记。登出后保留，删号时清除（全新开始）。

### 登出 — 3 步 Provider 级联
登出统一由 `UserProfileNotifier.logout()` 编排 — 唯一登出入口。流程为 3 步：
1. 停止同步引擎（身份切换前）。
2. Firebase 签出 — 本地数据保留，不删除。SQLite UID 列天然隔离多用户数据（每张表都有 `uid` 列），`deleteUidData` 仅保留给账号删除流程（`AccountDeletionOrchestrator`）专用。
3. 创建新访客 UID → 触发 `appAuthStateProvider` 发出 `GuestState(newUid)` → 所有下游 Provider 自动失效。

非关键清理（通知取消、Crashlytics 用户标识清理）在第 3 步后以 fire-and-forget 方式执行。不再需要手动清理 10 个 SharedPreferences key — Provider 级联替代了旧的手动清扫。

AuthGate 中 `ref.listenManual(onboardingCompleteProvider)` 监听 `true → false` 变化后调用 `popUntil(isFirst)`，关闭所有已打开的对话框或已推入的路由。

### FirstHabitGate 水化守卫
`_FirstHabitGate` 通过检查用户是否有习惯来决定新用户路由。非访客用户的检查延迟到 `dataHydrated == true`（SyncEngine 完成 Firestore 水化后设置），防止水化前空数据导致误入领养引导的竞态条件。

## 访客升级
- 在登录页认证成功后触发。
- 认证动作前先确定迁移源 UID：
  - 优先 `local_guest_uid`
  - 缺失时回退认证前 `currentUid`
- `GuestUpgradeCoordinator` 基于快照判定合并路径。
- `GuestUpgradeCoordinator.resolve(...)` 必须接收 `migrationSourceUid`，若与本地访客 UID 不一致则中止危险迁移。
- 空访客守卫内置于 `resolve()`：当 `AccountSnapshotService.readLocal(migrationSourceUid).isEmpty` 时，直接清理 `localGuestUid` 并返回 — 不弹合并对话框，不触发数据操作。此设计消除了登出循环后的虚假访客升级。
- 不再在 `AuthGate` 中做隐式 UID 迁移。

### FirstHabitGate 孤儿访客恢复
`_recoverOrphanedGuestData` 使用 `AccountSnapshotService.readLocal(guestUid).isEmpty`（与 `GuestUpgradeCoordinator` 判断标准一致）守卫迁移：
- 快照非空 → 执行 UID 迁移 + 设置 `dataHydrated=true`（保留离线数据）。
- 快照为空 → 仅清理 `localGuestUid`，不设 `dataHydrated`（让 Firestore 水化正常进行）。

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

## 主题状态 — 双 UI 风格

### ThemeSettings

`ThemeSettings`（位于 `theme_provider.dart`）持有所有主题相关状态：

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `mode` | `ThemeMode` | `system` | 亮色/暗色/跟随系统 |
| `seedColor` | `Color` | `#4285F4` | M3 种子色 |
| `useDynamicColor` | `bool` | `true` | Material You 壁纸取色 |
| `enableBackgroundAnimation` | `bool` | `true` | 网格渐变 + 粒子动画 |
| `uiStyle` | `AppUiStyle` | `retroPixel` | `material` 或 `retroPixel` |

`effectiveDynamicColor` 在 `uiStyle == retroPixel` 时强制返回 `false` — 复古调色板本身即品牌标识。

### ThemeSkin 策略模式

`AppTheme._assemble()` 将所有组件主题委托给 `ThemeSkin` 实现：

```
ThemeSettings.uiStyle → _skinFor(style) → MaterialSkin | RetroPixelSkin
                                              ↓
                                    _assemble(colorScheme, textTheme, skin)
                                              ↓
                                    ThemeData（零分支）
```

- `MaterialSkin` — 从原 `_buildTheme()` 提取，行为零变化。
- `RetroPixelSkin` — 将复古色映射到 `ColorScheme` 槽位，对所有组件主题应用 `PixelBorderShape`，显示文本使用 Silkscreen 字体，阶梯式页面过渡。

关键文件：`lib/core/theme/skins/{theme_skin,material_skin,retro_pixel_skin}.dart`

### AppScaffold

`AppScaffold`（位于 `lib/widgets/app_scaffold.dart`）包裹 `Scaffold`，在复古模式下条件性叠加 `RetroTiledBackground`。所有屏幕使用 `AppScaffold` 替代 `Scaffold` — 23+ 个屏幕的唯一集成点。

## V3 觉知 Provider

### 服务 Provider（位于 `service_providers.dart`）
- `awarenessRepositoryProvider` — `AwarenessRepository`（DailyLight + WeeklyReview CRUD）
- `worryRepositoryProvider` — `WorryRepository`（Worry CRUD）

### 状态 Provider（位于 `awareness_providers.dart`）

| Provider | 类型 | 说明 |
|----------|------|------|
| `todayLightProvider` | `StreamProvider<DailyLight?>` | 今日一点光，filter：`light_recorded` / `light_deleted` |
| `hasRecordedTodayLightProvider` | `Provider<bool>` | 派生自 `todayLightProvider` |
| `currentWeekReviewProvider` | `StreamProvider<WeeklyReview?>` | 本周回顾 |
| `activeWorriesProvider` | `StreamProvider<List<Worry>>` | 进行中烦恼 |
| `resolvedWorriesProvider` | `StreamProvider<List<Worry>>` | 已终结烦恼 |
| `awarenessStatsProvider` | `StreamProvider<Map<String, int>>` | 觉知统计 |
| `monthlyLightsProvider` | `FutureProvider.family<List<DailyLight>, String>` | 月度一点光 |

### 新增 ActionType 值

`lightRecorded`、`weeklyReviewCompleted`、`worryCreated`、`worryUpdated`、`worryResolved`、`monthlyRitualSet`

以上值用于觉知 StreamProvider 的 `LedgerChange` 领域过滤器。

受影响的 LedgerChange 刷新：觉知 Provider 响应 `isGlobalRefresh` 加上述领域特定 action type。

## 约束
- Screen 层禁止直接调用 Firebase SDK。
- 导航副作用必须放在监听器/effect，不要写在 `build()` 中。
- Provider 层禁止重新引入 legacy 兼容分支。
- 新增持久化键必须统一进入 `AppPrefsKeys`。
- 账户生命周期 callable 必须始终传递 `OperationContext`。
- UI/Provider 层禁止注入静态 AI API key，AI 运行路径统一为 Firebase AI Logic。
