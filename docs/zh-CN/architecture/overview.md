# 架构概览

> **SSOT**（Single Source of Truth，单一真值来源） ：本文档是系统架构的权威参考。所有实现决策必须与此处描述的原则保持一致。

---

## 技术栈

| 层级 | 技术 | 版本 | 用途 |
|------|------|------|------|
| UI 框架 | Flutter | 3.41.x stable | 跨平台移动端（iOS + Android） |
| 语言 | Dart | 3.11.x | 类型安全、空安全开发 |
| 设计系统 | Material Design 3 | — | Google 对齐 UI 组件与主题 |
| 状态管理 | Riverpod | 2.6.x | 响应式、编译期安全依赖注入 |
| 认证 | Firebase Auth | 5.x | Google OAuth + 邮箱/密码 |
| 数据库 | Cloud Firestore | 5.x | 实时 NoSQL，支持离线 |
| 分析 | Firebase Analytics (GA4) | 11.x | 基于事件的行为分析 |
| 推送 | Firebase Cloud Messaging | 15.x | 服务端触发推送通知 |
| 本地通知 | flutter_local_notifications | 18.x | 定时每日习惯提醒 |
| 后台计时 | flutter_foreground_task | 8.x | Android 前台服务保持计时器运行 |
| A/B 测试 | Firebase Remote Config | 5.x | 动态配置、功能开关 |
| 崩溃报告 | Firebase Crashlytics | 4.x | 生产环境错误监控 |

---

## 层级架构

```
┌─────────────────────────────────────────────────────────────────┐
│                          Flutter 应用                            │
├─────────────────────────────────────────────────────────────────┤
│  Screens（UI 层——无业务逻辑）                                    │
│  ├── OnboardingScreen          ├── CatRoomScreen                │
│  ├── LoginScreen               ├── CatDetailScreen              │
│  ├── HomeScreen（4 标签外壳）  ├── FocusSetupScreen             │
│  ├── AdoptionFlowScreen        ├── TimerScreen                  │
│  ├── StatsScreen               ├── FocusCompleteScreen          │
│  └── ProfileScreen                                              │
├─────────────────────────────────────────────────────────────────┤
│  Providers（状态层——Riverpod，响应式 SSOT）                      │
│  ├── authStateProvider         ├── focusTimerProvider           │
│  ├── currentUidProvider        ├── statsProvider                │
│  ├── habitsProvider            ├── todayMinutesPerHabitProvider │
│  ├── todayCheckInsProvider     ├── catsProvider                 │
│  ├── catByIdProvider（family） └── ownedBreedsProvider          │
│  └── catByHabitProvider（family）                               │
├─────────────────────────────────────────────────────────────────┤
│  Services（数据层——Firebase SDK 封装）                           │
│  ├── AuthService               ├── XpService（纯 Dart）         │
│  ├── FirestoreService          ├── NotificationService          │
│  ├── AnalyticsService          ├── RemoteConfigService          │
│  ├── CatGenerationService      └── FocusTimerService            │
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
| 业务数据 | Firestore |
| 认证状态 | `authStateProvider`（`providers/auth_provider.dart`） |
| 猫咪列表 | `catsProvider`（`providers/cat_provider.dart`） |
| 计时器状态 | `focusTimerProvider`（`providers/focus_timer_provider.dart`） |
| 计算统计 | `statsProvider`（`providers/stats_provider.dart`） |
| UI 主题 | `lib/core/theme/app_theme.dart` |
| 分析事件名 | `lib/core/constants/analytics_events.dart` |
| 猫咪游戏元数据 | `lib/core/constants/cat_constants.dart` |
| 命名路由 | `lib/core/router/app_router.dart` |
| 动态配置 | Firebase Remote Config |

### 3. 严格依赖方向

```
Screens → Providers → Services → Firebase SDK
```

**规则：**
- Screens 只通过 `ref.watch` / `ref.read` 从 Providers 读取数据——不直接导入 Services
- Providers 编排 Services 并暴露响应式状态——不直接访问 Firebase SDK
- Services 封装所有 Firebase SDK 交互——不包含 UI 代码，不使用 BuildContext
- 纯计算（XP、品种生成）放在无 Firebase 依赖的 Services 中

### 4. 响应式优于命令式

优先使用 `StreamProvider` 和 `ref.watch()`，而非一次性 `Future` 获取。状态自动向下流动——无需手动 `setState` 调用，数据变化时界面自动重建。

### 5. 原子 Firestore 操作

跨多个文档的操作（如创建习惯 + 猫咪、记录专注会话）使用 Firestore **批量写入** 保证一致性。任意写入失败则全部回滚。

---

## 导航

应用使用 Flutter 的 `Navigator 1.0`，命名路由由 `AppRouter` 管理：

| 路由 | 界面 | 参数 |
|------|------|------|
| `/login` | LoginScreen | — |
| `/home` | HomeScreen（4 标签 NavigationBar 外壳） | — |
| `/adoption` | AdoptionFlowScreen | `isFirstHabit: bool` |
| `/focus-setup` | FocusSetupScreen | `habitId: String` |
| `/timer` | TimerScreen | `habitId: String` |
| `/focus-complete` | FocusCompleteScreen | `Map<String, dynamic>` |
| `/cat-detail` | CatDetailScreen | `catId: String` |
| `/profile` | ProfileScreen | — |

**根路由** 由 `AuthGate` → `_FirstHabitGate` 管理：
1. `AuthGate` 检查引导完成状态（SharedPreferences）和 Firebase Auth 状态
2. `_FirstHabitGate` 检测首次用户（零个习惯）并自动导航到领养流程

---

## 认证流程

```
应用启动
    │
    ▼
AuthGate
    ├── 引导未完成 → OnboardingScreen
    │       └── 完成 → AuthGate（循环）
    │
    └── 引导已完成
            │
            ▼
        Firebase Auth 流
            ├── user == null → LoginScreen
            └── user != null → _FirstHabitGate
                    ├── habits.isEmpty → AdoptionFlow（isFirstHabit: true）
                    └── habits.any → HomeScreen
```

---

## 后台计时器架构

专注计时器是一个 **双 Isolate 系统** ：

1. **主 Isolate** — `FocusTimerNotifier`（Riverpod）持有权威计时器状态。使用 `Timer.periodic(1s)` 并将完整的 `FocusTimerState` 暴露给 UI。

2. **后台 Isolate** — `flutter_foreground_task` 在独立 Isolate 中运行最小化的 `_TimerTaskHandler`。其唯一职责是保持 Android 前台服务存活并显示持久通知。主 Isolate 通过 `FocusTimerService.updateNotification()` 在每个计时周期更新通知文本。

`AppLifecycleState` 变化通过 `WidgetsBindingObserver` 监听：
- `paused` / `hidden` → 记录时间戳（`onAppBackgrounded`）
- `resumed` → 计算离开时长；>15s 自动暂停，>5min 自动结束（`onAppResumed`）
