# 架构概览

> **SSOT**（Single Source of Truth，单一真值来源）：本文档是系统架构的权威参考。所有实现决策必须与此处描述的原则保持一致。

---

## 技术栈

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| UI 框架 | Flutter | 3.41.x stable | 跨平台移动端（iOS + Android） |
| 语言 | Dart | 3.11.x | 类型安全、空安全开发 |
| 设计系统 | Material Design 3 | — | Google 对齐 UI 组件与主题 |
| 状态管理 | Riverpod | 3.x | 响应式、编译期安全依赖注入 |
| 认证 | Firebase Auth | 5.x | Google OAuth + 邮箱/密码 |
| 数据库 | Cloud Firestore | 5.x | 实时 NoSQL，支持离线 |
| 分析 | Firebase Analytics (GA4) | 11.x | 基于事件的行为分析 |
| 推送 | Firebase Cloud Messaging | 15.x | 服务端触发推送通知 |
| 本地通知 | flutter_local_notifications | 18.x | 定时每日习惯提醒 |
| 后台计时 | flutter_foreground_task | 8.x | Android 前台服务保持计时器运行 |
| A/B 测试 | Firebase Remote Config | 5.x | 动态配置、功能开关 |
| 崩溃报告 | Firebase Crashlytics | 4.x | 生产环境错误监控 |
| 网络连接 | connectivity_plus | 7.x | 设备网络状态监测 |
| 本地数据库 | sqflite | 2.4.x | 本地优先 SQLite 存储（行为台账、物化状态） |
| UUID | uuid | 4.5.x | 本地实体的确定性唯一 ID |
| 国际化 | flutter_localizations + gen-l10n | — | 通过 ARB 文件进行编译期本地化 |
| AI 提供商 | MiniMax M2.5 / Gemini 3 Flash | — | 云端大语言模型推理（策略模式，用户可切换，HTTP SSE 流式输出） |
| 动态背景 | mesh_gradient | 1.3.x | GPU 加速流体 mesh 渐变（fragment shader） |
| 粒子特效 | atmospheric_particles | 0.3.x | 轻量浮动粒子覆盖层（Isolate 架构） |

---

## 层级架构

```
┌─────────────────────────────────────────────────────────────────┐
│                          Flutter 应用                            │
├─────────────────────────────────────────────────────────────────┤
│  Screens（UI 层——无业务逻辑）                                    │
│  ├── OnboardingScreen          ├── CatRoomScreen                │
│  ├── LoginScreen               ├── CatDetailScreen              │
│  ├── HomeScreen（3 标签 + Drawer） ├── FocusSetupScreen            │
│  ├── AdoptionFlowScreen        ├── TimerScreen                  │
│  ├── StatsScreen               ├── FocusCompleteScreen          │
├─────────────────────────────────────────────────────────────────┤
│  Providers（状态层——Riverpod，响应式 SSOT）                      │
│  ├── authStateProvider         ├── focusTimerProvider           │
│  ├── currentUidProvider        ├── statsProvider                │
│  ├── habitsProvider            ├── todayMinutesPerHabitProvider │
│  ├── todayCheckInsProvider     ├── catsProvider                 │
│  ├── catByIdProvider（family） ├── pixelCatRendererProvider     │
│  ├── catByHabitProvider（fam.）├── catSpriteImageProvider（fam.）│
│  ├── connectivityProvider      ├── coinBalanceProvider          │
│  ├── isOfflineProvider         ├── hasCheckedInTodayProvider    │
│  ├── isAnonymousProvider       ├── ledgerServiceProvider        │
│  ├── syncEngineProvider        ├── newlyUnlockedProvider        │
│  ├── userProfileNotifierProv. └── avatarIdProvider              │
├─────────────────────────────────────────────────────────────────┤
│  Services（数据层——业务逻辑，无 UI）                              │
│  ├── AuthService               ├── XpService（纯 Dart）         │
│  ├── UserProfileService        ├── NotificationService          │
│  ├── PixelCatRenderer          ├── RemoteConfigService          │
│  ├── PixelCatGenerationService ├── FocusTimerService            │
│  ├── CoinService               ├── MigrationService             │
│  ├── LedgerService             ├── AnalyticsService             │
│  ├── AchievementEvaluator      ├── SyncEngine                   │
│  ├── LocalHabitRepository      ├── LocalCatRepository           │
│  └── LocalSessionRepository                                     │
├─────────────────────────────────────────────────────────────────┤
│  后端抽象层（core/backend/ — 策略模式）                           │
│  ├── AuthBackend               ├── AnalyticsBackend             │
│  ├── SyncBackend               ├── CrashBackend                 │
│  ├── UserProfileBackend        ├── RemoteConfigBackend          │
│  └── BackendRegistry（region → global / china）                  │
├─────────────────────────────────────────────────────────────────┤
│  Firebase 实现（services/firebase/）                              │
│  ├── FirebaseAuthBackend       ├── FirebaseAnalyticsBackend     │
│  ├── FirebaseSyncBackend       ├── FirebaseCrashBackend         │
│  ├── FirebaseUserProfileBackend├── FirebaseRemoteConfigBackend  │
├─────────────────────────────────────────────────────────────────┤
│  Firebase SDK                                                   │
│  ├── firebase_auth             ├── firebase_remote_config        │
│  ├── cloud_firestore           ├── firebase_crashlytics         │
│  ├── firebase_analytics        ├── flutter_local_notifications   │
│  ├── firebase_messaging        └── flutter_foreground_task      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 设计原则

### 1. 文档驱动开发（DDD）

所有接口和行为在实现前均在 `docs/` 中规范化。文档是契约；代码是实现。当文档与代码冲突时，文档优先（修改代码，仅在有意变更时才更新文档）。

### 2. 统一真值（SSOT）

系统中每个关注点只有一个权威来源：

| 关注点 | SSOT 位置 |
|--------|----------|
| 业务数据（SSOT） | SQLite 本地表（通过 SyncEngine 同步至 Firestore） |
| 行为台账 | `action_ledger` 表（`local_database_service.dart`） |
| 物化状态（金币等） | `materialized_state` 表（`local_database_service.dart`） |
| 成就记录 | `local_achievements` 表（`local_database_service.dart`） |
| 认证状态 | `authStateProvider`（`providers/auth_provider.dart`） |
| 猫咪列表 | `catsProvider`（`providers/cat_provider.dart`） |
| 猫咪精灵图 | `catSpriteImageProvider`（`providers/cat_sprite_provider.dart`） |
| 金币余额 | `coinBalanceProvider`（`providers/coin_provider.dart`） |
| 计时器状态 | `focusTimerProvider`（`providers/focus_timer_provider.dart`） |
| 计算统计 | `statsProvider`（`providers/stats_provider.dart`） |
| UI 主题 | `lib/core/theme/app_theme.dart` |
| 分析事件名 | `lib/core/constants/analytics_events.dart` |
| 猫咪游戏元数据 | `lib/core/constants/cat_constants.dart` |
| 像素猫外观参数 | `lib/core/constants/pixel_cat_constants.dart` |
| 命名路由 | `lib/core/router/app_router.dart` |
| 动态配置 | Firebase Remote Config |
| 设备网络连接 | `connectivityProvider`（`providers/connectivity_provider.dart`） |
| 本地化字符串 | `lib/l10n/app_en.arb`（源）+ 生成的 `AppLocalizations` |

### 3. 严格依赖方向

```
Screens -> Providers -> Services -> 后端抽象 -> Firebase/CloudBase SDK
```

**规则：**
- Screens 只通过 `ref.watch` / `ref.read` 从 Providers 读取数据——不直接导入 Services
- Providers 编排 Services 并暴露响应式状态——不直接访问 Firebase SDK
- Services 依赖后端抽象（`core/backend/`），不直接依赖 Firebase SDK 类
- Firebase 具体实现放在 `services/firebase/` 目录——唯一允许导入 Firebase SDK 的位置
- 纯计算（XP、猫咪生成）放在无后端依赖的 Services 中

### 4. 响应式优于命令式

优先使用 `StreamProvider` 和 `ref.watch()`，而非一次性 `Future` 获取。状态自动向下流动——无需手动 `setState` 调用，数据变化时界面自动重建。

### 5. 原子 Firestore 操作

跨多个文档的操作（如创建习惯 + 猫咪、记录专注会话）使用 Firestore **批量写入** 保证一致性。任意写入失败则全部回滚。

### 6. 本地优先架构

自 v2.18.0 起，业务数据流经 **本地优先** 管道：

1. **行为台账** — 每个数据变更操作（专注完成、签到、购买、装备、习惯 CRUD）记录为 `action_ledger` SQLite 表中的不可变 `LedgerAction`。台账是预写日志。

2. **物化状态** — 派生聚合值（金币余额、签到状态）缓存在 `materialized_state` 键值表中，与台账写入在同一 SQLite 事务中原子更新。

3. **本地表** — `local_habits`、`local_cats`、`local_sessions`、`local_monthly_checkins`、`local_achievements` 镜像 Firestore 模式，但作为运行时 SSOT。Provider 从这些表读取，而非 Firestore。

4. **同步引擎** — `SyncEngine` 在后台运行，将未同步的台账操作批量上传至 Firestore。触发条件：认证完成后 / 离线→在线 / 新台账写入（2 秒防抖）。使用指数退避重试。90 天台账清理。

5. **成就评估器** — `AchievementEvaluator` 监听台账变更流并自动评估成就条件，替代手动触发调用。

### 7. 多后端抽象

自 v2.20.0 起，所有云 SDK 交互均通过 `lib/core/backend/` 中的抽象后端接口隔离。这实现了：

- **区域切换** — 全球版（Firebase）和中国版（腾讯 CloudBase）共用一套代码
- **可测试性** — Service 依赖抽象接口，而非 Firebase SDK 类
- **可扩展性** — 新增后端只需实现接口，无需修改业务逻辑

该模式参照已验证的 `AiProvider` 策略模式（`lib/core/ai/ai_provider.dart`）。`BackendRegistry` 持有当前区域的所有后端实例，通过 `backendRegistryProvider` 注入。各后端独立 Provider（`authBackendProvider`、`syncBackendProvider` 等）提供便捷访问。

```
BackendRegistry（backendRegionProvider → global | china）
  ├── AuthBackend        ← 登录/注册/关联/删除
  ├── SyncBackend        ← 批量写入/水化（SyncOperation 抽象）
  ├── UserProfileBackend ← 创建/同步用户资料
  ├── AnalyticsBackend   ← 记录事件/设置用户属性
  ├── CrashBackend       ← 记录错误/日志
  └── RemoteConfigBackend← 获取配置/激活
```

### 8. 国际化（i18n）

所有用户可见的字符串均外部化到 ARB 文件（`lib/l10n/app_en.arb`、`lib/l10n/app_zh.arb`）中，并通过 `flutter gen-l10n` 编译为 Dart 代码。Screen 和 Widget 中不允许硬编码用户可见的字符串。详见 [localization.md](localization.md) 完整工作流。

---

## 导航

应用使用 Flutter 的 `Navigator 1.0`，命名路由由 `AppRouter` 管理：

| 路由 | 界面 | 参数 |
|------|------|------|
| `/login` | LoginScreen | — |
| `/home` | HomeScreen（3 标签 NavigationBar + Drawer） | — |
| `/adoption` | AdoptionFlowScreen | `isFirstHabit: bool` |
| `/focus-setup` | FocusSetupScreen | `habitId: String` |
| `/timer` | TimerScreen | `habitId: String` |
| `/focus-complete` | FocusCompleteScreen | `Map<String, dynamic>` |
| `/cat-detail` | CatDetailScreen | `catId: String` |
| `/ai-settings` | AiSettingsPage | — |

**根路由** 由 `AuthGate` -> `_FirstHabitGate` 管理：
1. `AuthGate` 检查引导完成状态（SharedPreferences）和 Firebase Auth 状态
2. `_FirstHabitGate` 检测首次用户（零个习惯）并自动导航到领养流程

---

## 认证流程

```
应用启动
    │
    ▼
AuthGate
    ├── 引导未完成 -> OnboardingScreen
    │       └── 完成 -> AuthGate（循环）
    │
    └── 引导已完成
            │
            ▼
        Firebase Auth 流
            ├── user == null -> 自动 signInAnonymously()（访客模式）
            │       └── success -> _FirstHabitGate
            └── user != null -> _FirstHabitGate
                    ├── habits.isEmpty -> AdoptionFlow（isFirstHabit: true）
                    └── habits.any -> HomeScreen
```

**访客模式：** 新用户自动获取匿名 Firebase Auth 账户。可随时通过 Drawer → 账户升级提示升级为完整账户（Google 或邮箱）。账户关联使用 `linkWithCredential()` 保留所有数据。

**AuthService** 现支持：`signInAnonymously()`、`linkWithGoogle()`、`linkWithEmail()`，以及 `isAnonymous` getter。

---

## 状态管理详情

详见 [state-management.md](state-management.md) 完整 Provider 图谱。

**使用的核心模式：**

| 模式 | 使用场景 | 示例 |
|------|---------|------|
| `StreamProvider` | Firestore 实时流 | `habitsProvider`、`catsProvider`、`coinBalanceProvider` |
| `FutureProvider.family` | 异步按键计算 | `catSpriteImageProvider(catId)` |
| `StateNotifierProvider` | 有方法的可变本地状态 | `focusTimerProvider` |
| `Provider` | 计算/派生值 | `statsProvider`、`hasCheckedInTodayProvider` |
| `Provider.family` | 参数化查询 | `catByIdProvider(catId)`、`catByHabitProvider(habitId)` |
| `ref.watch()` | 在 `build()` 中的响应式订阅 | 所有 Screen 的 `build` 方法 |
| `ref.read()` | 事件处理中的一次性读取 | 按钮 `onPressed` 回调 |

---

## 后台计时器架构

专注计时器是一个 **双 Isolate 系统**：

1. **主 Isolate** — `FocusTimerNotifier`（Riverpod）持有权威计时器状态。使用 `Timer.periodic(1s)` 并将完整的 `FocusTimerState` 暴露给 UI。

2. **后台 Isolate** — `flutter_foreground_task` 在独立 Isolate 中运行最小化的 `_TimerTaskHandler`。其唯一职责是保持 Android 前台服务存活并显示持久通知。主 Isolate 通过 `FocusTimerService.updateNotification()` 在每个计时周期更新通知文本。

`AppLifecycleState` 变化通过 `WidgetsBindingObserver` 监听：
- `paused` / `hidden` -> 记录时间戳（`onAppBackgrounded`）
- `resumed` -> 计算离开时长；>15s 自动暂停，>5min 自动结束（`onAppResumed`）。同时检查 `FlutterForegroundTask.isRunningService`，若 OS 在后台期间终止了前台服务则重启。

---

## 通知架构

专注计时器使用 **三层通知系统**，各层职责独立：

| 层级 | 插件 | 渠道 ID | 用途 | 活跃时机 |
|------|------|---------|------|----------|
| 前台服务 | `flutter_foreground_task` | `hachimi_focus` | 持久化计时器通知（保持进程存活） | 计时器运行期间 |
| 原子岛 | Native MethodChannel | `hachimi_focus_timer_v2` | vivo 原子岛 + Android 16 锁屏富通知 | 计时器运行期间（仅 vivo） |
| 完成通知 | `flutter_local_notifications` | `hachimi_focus_complete` | 一次性完成提醒，包含 XP 摘要 | 倒计时结束时 |

**前台服务通知** 包含暂停/结束操作按钮，通过 `FlutterForegroundTask.sendDataToMain()` / `addTaskDataCallback()` 与主 Isolate 通信。主 Isolate 在每个心跳通过 `FocusTimerService.updateNotification()` 更新通知文本。

**原子岛** 在支持的设备（vivo OriginOS）上提供富平台原生计时器展示。详见 `docs/zh-CN/architecture/atomic-island.md`。

**完成通知** 在倒计时归零时从 `_onTick()` 触发——即使应用在后台也能工作，因为通知从主 Isolate 发送。使用固定通知 ID（`300000`），因此重复发送（来自 `_onTick()` 和 `_saveSession()`）只会覆盖而非堆叠。

**通知文本 L10N**：由于 Provider 无 `BuildContext`，本地化标签（`labelRemaining`、`labelElapsed`、`labelFocusing`、`labelDefaultCat`、`labelInProgress`）在设置时从 `FocusSetupScreen`（有 `context.l10n` 访问权限）传入 `FocusTimerNotifier.configure()`。标签为空时使用英文兜底。
