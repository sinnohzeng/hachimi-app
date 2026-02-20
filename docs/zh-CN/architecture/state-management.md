# 状态管理 — Riverpod（响应式状态容器）SSOT

> **SSOT**：本文档是 Riverpod Provider 图谱的权威参考。每个 Provider 都是其所在领域的单一真值来源。`lib/providers/` 的实现必须与本规范一致。

---

## Provider 图谱

```
Firebase Auth 流 ──────────────► authStateProvider (StreamProvider<User?>)
                                          │
                                          ▼
                                 currentUidProvider (Provider<String?>)
                                          │
                     ┌────────────────────┼────────────────────┐
                     ▼                   ▼                    ▼
          habitsProvider           catsProvider         allCatsProvider
     (StreamProvider<List<Habit>>) (StreamProvider<List<Cat>>) (StreamProvider<List<Cat>>)
                     │                   │
          ┌──────────┴──────────┐ ┌──────┴────────────┐
          ▼                    ▼ ▼                   ▼
  todayCheckInsProvider  statsProvider  catByIdProvider  catByHabitProvider
  (StreamProvider<...>)  (Provider<...>)  （family）      （family）
                     │
                     ▼
         todayMinutesPerHabitProvider
         (Provider<Map<String, int>>)


像素猫渲染（单例 + 按猫缓存）：

         pixelCatRendererProvider (Provider<PixelCatRenderer>)
                        │
                        ▼
         catSpriteImageProvider (FutureProvider.family<ui.Image, String>)


金币经济：

  coinServiceProvider ──► coinBalanceProvider (StreamProvider<int>)
                          hasCheckedInTodayProvider (FutureProvider<bool>)
                          monthlyCheckInProvider (StreamProvider<MonthlyCheckIn?>)


计时器状态（本地状态，非 Firestore —— 通过 SharedPreferences 持久化以支持崩溃恢复）：

  focusTimerProvider (StateNotifierProvider<FocusTimerNotifier, FocusTimerState>)


主题与语言（通过 SharedPreferences 持久化）：

  themeProvider (StateNotifierProvider<ThemeNotifier, ThemeSettings>)
  localeProvider (StateNotifierProvider<LocaleNotifier, Locale?>)


设备网络连接（独立于认证状态）：

  connectivity_plus 流 ──► connectivityProvider (StreamProvider<bool>)
                                     │
                                     ▼
                            isOfflineProvider (Provider<bool>)
```

---

## Provider 定义

### `authStateProvider`

- **类型**：`StreamProvider<User?>`
- **文件**：`lib/providers/auth_provider.dart`
- **数据源**：`FirebaseAuth.instance.authStateChanges()`
- **消费者**：`AuthGate`（`lib/app.dart`）—— 重定向至 `LoginScreen` 或 `_FirstHabitGate`
- **SSOT**：用户是否已认证，以及 Firebase 的 `User` 对象

### `currentUidProvider`

- **类型**：`Provider<String?>`
- **文件**：`lib/providers/auth_provider.dart`
- **数据源**：派生自 `authStateProvider` —— `ref.watch(authStateProvider).value?.uid`
- **消费者**：所有基于 Firestore 的 Provider（它们依赖 uid 才能工作）
- **SSOT**：当前用户的 Firebase UID（用户唯一标识符）

---

### `habitsProvider`

- **类型**：`StreamProvider<List<Habit>>`
- **文件**：`lib/providers/habits_provider.dart`
- **数据源**：`FirestoreService.watchHabits(uid)` —— 实时 Firestore 流
- **消费者**：`HomeScreen`（习惯列表）、`StatsScreen`、`_FirstHabitGate`、`statsProvider`
- **SSOT**：用户的完整习惯列表，始终与 Firestore 保持同步

### `todayCheckInsProvider`

- **类型**：`StreamProvider<List<CheckInEntry>>`
- **文件**：`lib/providers/habits_provider.dart`
- **数据源**：`FirestoreService.watchTodayCheckIns(uid)` —— 今日打卡条目
- **消费者**：`HomeScreen`（今日各习惯进度）
- **SSOT**：今日所有打卡条目

### `todayMinutesPerHabitProvider`

- **类型**：`Provider<Map<String, int>>`
- **文件**：`lib/providers/habits_provider.dart`
- **数据源**：派生自 `todayCheckInsProvider` —— 按 `habitId` 汇总分钟数
- **消费者**：`HomeScreen` 习惯列表行（今日进度条）
- **SSOT**：今日按习惯 ID 分组的记录分钟数

### `statsProvider`

- **类型**：`Provider<HabitStats>`
- **文件**：`lib/providers/stats_provider.dart`
- **数据源**：派生自 `habitsProvider` + `todayCheckInsProvider`
- **消费者**：`StatsScreen`、`ProfileScreen`
- **SSOT**：汇总统计数据（总专注时长、最长连续记录、活跃习惯数量）

---

### `catsProvider`

- **类型**：`StreamProvider<List<Cat>>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：`CatFirestoreService.watchCats(uid)` —— 仅流式传输 `state == "active"` 的猫咪
- **消费者**：`CatRoomScreen`（CatHouse 网格）、`HomeScreen`（习惯列表中的猫咪头像）、`ProfileScreen`
- **SSOT**：用户的活跃猫咪，始终保持最新

### `allCatsProvider`

- **类型**：`StreamProvider<List<Cat>>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：`CatFirestoreService.watchAllCats(uid)` —— 流式传输所有状态的猫咪
- **消费者**：猫咪相册（Profile 界面）
- **SSOT**：完整的猫咪历史，包括休眠和已毕业猫咪

### `catByIdProvider`

- **类型**：`Provider.family<AsyncValue<Cat?>, String>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：派生自 `allCatsProvider` —— 按 ID 查找
- **消费者**：`CatDetailScreen`
- **用法**：`ref.watch(catByIdProvider(catId))`

### `catByHabitProvider`

- **类型**：`Provider.family<AsyncValue<Cat?>, String>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：派生自 `catsProvider` —— 按 `boundHabitId` 查找
- **消费者**：`HomeScreen` 习惯行（小型猫咪头像）、`FocusSetupScreen`
- **用法**：`ref.watch(catByHabitProvider(habitId))`

### `catFirestoreServiceProvider`

- **类型**：`Provider<CatFirestoreService>`
- **文件**：`lib/providers/auth_provider.dart`
- **数据源**：使用 Firestore 实例初始化 `CatFirestoreService`
- **消费者**：`catsProvider`、`allCatsProvider` 及任何需要读写猫咪文档的 Provider
- **SSOT**：所有猫咪相关 Firestore 操作的单例服务实例

---

### `pixelCatRendererProvider`

- **类型**：`Provider<PixelCatRenderer>`（单例）
- **文件**：`lib/providers/cat_sprite_provider.dart`
- **数据源**：初始化一个管理资源加载和精灵图合成的单例 `PixelCatRenderer`
- **消费者**：`catSpriteImageProvider`
- **SSOT**：pixel-cat-maker 渲染引擎实例。单例模式确保所有精灵图共享已加载的资源。

### `catSpriteImageProvider`

- **类型**：`FutureProvider.family<ui.Image, String>`（按 catId 索引）
- **文件**：`lib/providers/cat_sprite_provider.dart`
- **数据源**：调用 `ref.watch(pixelCatRendererProvider).renderCat(catAppearance)` —— 根据给定猫咪的外观参数合成 13 层精灵图
- **消费者**：`PixelCatSprite` 组件、`CatHouseCard` 组件
- **SSOT**：特定猫咪的合成像素风图像
- **用法**：`ref.watch(catSpriteImageProvider(catId))`

### `pixelCatGenerationServiceProvider`

- **类型**：`Provider<PixelCatGenerationService>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：初始化 `PixelCatGenerationService`
- **消费者**：`AdoptionFlowScreen`（用于生成随机猫咪进行领养）
- **SSOT**：生成随机猫咪外观和性格的服务

---

### `coinServiceProvider`

- **类型**：`Provider<CoinService>`
- **文件**：`lib/providers/coin_provider.dart`
- **数据源**：使用 Firestore 实例初始化 `CoinService`
- **消费者**：处理配饰购买和签到奖励展示的界面
- **SSOT**：金币相关操作的单例服务实例

### `coinBalanceProvider`

- **类型**：`StreamProvider<int>`
- **文件**：`lib/providers/coin_provider.dart`
- **数据源**：`CoinService.watchBalance(uid)` —— 用户 `coins` 字段的实时流
- **消费者**：`CatDetailScreen`（配饰商店余额）、`CheckInBanner`、`ProfileScreen`
- **SSOT**：用户当前金币余额，始终与 Firestore 保持同步

### `hasCheckedInTodayProvider`

- **类型**：`FutureProvider<bool>`
- **文件**：`lib/providers/coin_provider.dart`
- **数据源**：`CoinService.hasCheckedInToday(uid)` —— 将 `lastCheckInDate` 与今日日期字符串比较
- **消费者**：`CheckInBanner` 组件（判断已签到/未签到状态）
- **SSOT**：用户是否已领取今日每日签到金币奖励

### `monthlyCheckInProvider`

- **类型**：`StreamProvider<MonthlyCheckIn?>`
- **文件**：`lib/providers/coin_provider.dart`
- **数据源**：`CoinService.watchMonthlyCheckIn(uid)` —— 当月签到文档的实时流
- **消费者**：`CheckInBanner`（进度摘要）、`CheckInScreen`（完整月度详情）
- **SSOT**：当月签到进度，包括已签到天数、已获金币和已领取的里程碑

---

### `AccessoryInfo`

- **类型**：数据类（非 Provider）
- **文件**：`lib/providers/accessory_provider.dart`
- **用途**：轻量值对象，整合饰品 ID、显示名、价格、分类、拥有/装备状态
- **消费者**：`AccessoryShopScreen`、`AccessoryCard` 组件
- **字段**：`id`、`displayName`、`price`、`category`（'plant'/'wild'/'collar'）、`isOwned`、`isEquipped`

### `inventoryProvider`

- **类型**：`StreamProvider<List<String>>`
- **文件**：`lib/providers/inventory_provider.dart`
- **数据源**：`InventoryService.watchInventory(uid)` —— 用户 `inventory` 字段的实时流
- **消费者**：`InventoryScreen`、`AccessoryShopScreen`、`_AccessoriesCard`
- **SSOT**：用户未装备的配饰道具箱

### `inventoryServiceProvider`

- **类型**：`Provider<InventoryService>`
- **文件**：`lib/providers/auth_provider.dart`
- **数据源**：实例化 `InventoryService`
- **消费者**：`InventoryScreen`、`_AccessoriesCard`
- **SSOT**：道具箱装备/卸下操作的单例服务

### `notificationServiceProvider`

- **类型**：`Provider<NotificationService>`
- **文件**：`lib/providers/auth_provider.dart`
- **数据源**：实例化 `NotificationService`（单例）
- **消费者**：`CatDetailScreen`（提醒卡片）、`SettingsScreen`、`TimerScreen`（权限引导 Banner）、`AdoptionFlowScreen`（提醒调度）
- **SSOT**：调度/取消本地通知及 FCM 管理的单例服务
- **初始化**：`NotificationService().initializePlugins()` 在 `main.dart` 应用启动时调用，初始化插件并创建通知渠道，不请求权限。权限在用户设置提醒或启动专注计时时按需请求。

---

### `focusTimerProvider`

- **类型**：`StateNotifierProvider<FocusTimerNotifier, FocusTimerState>`（非 autoDispose —— 全局单例）
- **文件**：`lib/providers/focus_timer_provider.dart`
- **数据源**：本地状态，通过 SharedPreferences 持久化以支持崩溃恢复
- **消费者**：`TimerScreen`、`FocusCompleteScreen`、`_FirstHabitGate`（会话恢复）
- **SSOT**：活跃专注计时器的有限状态机（FSM，Finite State Machine）

**`FocusTimerState` 字段：**

| 字段 | 类型 | 说明 |
|------|------|------|
| `habitId` | String | 当前活跃习惯 |
| `catId` | String | 正在获得 XP 的猫咪 |
| `habitName` | String | 习惯显示名称（用于通知 + 恢复对话框） |
| `catName` | String | 猫咪显示名称（用于原子岛通知标题） |
| `totalSeconds` | int | 目标时长（倒计时模式）或 0（正计时模式） |
| `remainingSeconds` | int | 剩余秒数（倒计时模式，计算属性） |
| `elapsedSeconds` | int | 已用秒数（两种模式均记录） |
| `totalPausedSeconds` | int | 累计暂停秒数（用于墙钟时间计算） |
| `status` | 枚举 | `idle`、`running`、`paused`、`completed`、`abandoned` |
| `mode` | 枚举 | `countdown`（倒计时）、`stopwatch`（正计时） |
| `startedAt` | DateTime? | 会话开始时间戳 |
| `pausedAt` | DateTime? | 暂停或进入后台时的时间戳 |

**`FocusTimerNotifier` 方法：**

| 方法 | 说明 |
|------|------|
| `configure(habitId, catId, catName, habitName, seconds, mode)` | 初始化计时器参数 |
| `start()` | 启动计时器心跳 |
| `pause()` | 暂停计时器（记录 `pausedAt`） |
| `resume()` | 从暂停状态恢复（将暂停时长累加到 `totalPausedSeconds`） |
| `complete()` | 标记为已完成，清除持久化数据 |
| `abandon()` | 标记为已放弃（>= 5 分钟获得部分 XP），清除持久化数据 |
| `onAppBackgrounded()` | 记录 `pausedAt` 时间戳并保存状态；计时器通过墙钟继续运行 |
| `onAppResumed()` | 从墙钟重算已过时间；倒计时结束或离开 >30 分钟时自动完成 |
| `reset()` | 返回 `idle` 状态，清除持久化数据 |
| `restoreSession()` | 从 SharedPreferences 恢复中断的会话 |
| `static hasInterruptedSession()` | 检查是否有已保存的会话需要恢复 |
| `static clearSavedState()` | 清除持久化的会话数据 |

**墙钟锚定策略**：`_onTick()` 通过 `DateTime.now() - startedAt - totalPausedSeconds` 计算已过时间，而非每次心跳递增 1。这确保即使 App 进入后台、Dart isolate 被挂起，显示时间始终正确。恢复前台时，计时器自动追赶到真实时间。

**持久化**：每 5 秒 + 状态变更时，计时器状态（含 `totalPausedSeconds`）保存到 SharedPreferences（键前缀 `focus_timer_`）。`complete()`、`abandon()` 和 `reset()` 时清除。

**通知更新**：`_onTick()` 同时调用 `FocusTimerService.updateNotification()`（降级兜底）和 `AtomicIslandService.updateNotification()`（用于 vivo 原子岛 + Android 16 ProgressStyle 的富通知）。完整规格说明见 `docs/zh-CN/architecture/atomic-island.md`。

**计时器心跳**：`Timer.periodic(const Duration(seconds: 1), _onTick)` —— 在 `dispose()` 中取消。

---

### `themeProvider`

- **类型**：`StateNotifierProvider<ThemeNotifier, ThemeSettings>`
- **文件**：`lib/providers/theme_provider.dart`
- **数据源**：本地状态，通过 SharedPreferences 持久化
- **消费者**：`HachimiApp`（MaterialApp 的 theme/darkTheme/themeMode）、`SettingsScreen`
- **SSOT**：应用主题模式（跟随系统/浅色/深色）和种子色

**`ThemeSettings` 字段：**

| 字段 | 类型 | 说明 |
|------|------|------|
| `mode` | ThemeMode | `system`（跟随系统）、`light`（浅色）、`dark`（深色） |
| `seedColor` | Color | Material Design 3 种子色（默认：Google Blue `0xFF4285F4`） |
| `useDynamicColor` | bool | 是否在可用时使用系统动态色彩（Material You）（默认：`true`） |

**`ThemeNotifier` 方法：**

| 方法 | 说明 |
|------|------|
| `setMode(ThemeMode)` | 切换主题模式 |
| `setSeedColor(Color)` | 从 8 色预设色板选择种子色 |
| `setUseDynamicColor(bool)` | 切换 Material You 动态色彩 |

---

### `localeProvider`

- **类型**：`StateNotifierProvider<LocaleNotifier, Locale?>`
- **文件**：`lib/providers/locale_provider.dart`
- **数据源**：本地状态，通过 SharedPreferences 持久化
- **消费者**：`HachimiApp`（MaterialApp locale）、`SettingsScreen`
- **SSOT**：应用语言覆盖（`null` = 跟随系统，`Locale('en')` 或 `Locale('zh')` = 用户手动选择）

**`LocaleNotifier` 方法：**

| 方法 | 说明 |
|------|------|
| `setLocale(Locale?)` | 设置语言；null 表示跟随系统 |

**本地化系统（l10n）：**

- 通过 `flutter gen-l10n` 生成，配置 `output-class: S`、`nullable-getter: false`（见 `l10n.yaml`）
- ARB 文件：`lib/l10n/app_en.arb`（模板）、`lib/l10n/app_zh.arb`
- 生成输出：`lib/l10n/app_localizations.dart`（类名 `S`）
- 便捷扩展：`context.l10n` 返回 `S.of(context)`（定义在 `lib/l10n/l10n_ext.dart`）
- 代理通过 `S.localizationsDelegates` 和 `S.supportedLocales` 注册到 `MaterialApp`
- 所有 UI 字符串使用 `context.l10n.keyName` —— 界面中无硬编码字符串

---

### `connectivityProvider`

- **类型**：`StreamProvider<bool>`
- **文件**：`lib/providers/connectivity_provider.dart`
- **数据源**：`connectivity_plus` 的 `Connectivity().onConnectivityChanged` —— 将 `ConnectivityResult.none` 映射为 `false`，其余为 `true`
- **消费者**：`isOfflineProvider`
- **SSOT**：设备当前是否有活跃的网络接口

### `isOfflineProvider`

- **类型**：`Provider<bool>`
- **文件**：`lib/providers/connectivity_provider.dart`
- **数据源**：派生自 `connectivityProvider` —— 断网时返回 `true`，加载期间默认 `false`
- **消费者**：`OfflineBanner` 组件
- **SSOT**：供 UI 显示/隐藏离线横幅的简单布尔标志

---

### 本地 LLM Provider

```
模型管理 + LLM 引擎（独立于认证 — 仅本地）：

modelManagerProvider (Provider<ModelManagerService>)
localDatabaseProvider (Provider<LocalDatabaseService>)
llmServiceInstanceProvider (Provider<LlmService>)

diaryServiceProvider (Provider<DiaryService>)
chatServiceProvider (Provider<ChatService>)

aiFeatureEnabledProvider (StateNotifierProvider<AiFeatureNotifier, bool>)
  来源：SharedPreferences 'ai_features_enabled'

llmAvailabilityProvider (StateNotifierProvider<LlmAvailabilityNotifier, LlmAvailability>)
  枚举：featureDisabled | modelNotDownloaded | modelLoading | ready | error
  依赖：aiFeatureEnabledProvider, modelManagerProvider

modelDownloadProvider (StateNotifierProvider<ModelDownloadNotifier, ModelDownloadState>)
  追踪下载进度、状态（idle/downloading/paused/completed/error）

diaryEntriesProvider(catId) — FutureProvider.family<List<DiaryEntry>, String>
todayDiaryProvider(catId) — FutureProvider.family<DiaryEntry?, String>

chatNotifierProvider(catId) — StateNotifierProvider.autoDispose.family<ChatNotifier, ChatState, String>
  ChatState：{ messages, status, partialResponse, error }
  ChatStatus：idle | loading | generating | error
```

### `aiFeatureEnabledProvider`

- **类型**：`StateNotifierProvider<AiFeatureNotifier, bool>`
- **文件**：`lib/providers/llm_provider.dart`
- **来源**：SharedPreferences `ai_features_enabled`
- **消费者**：`SettingsScreen`（AI 开关）、`llmAvailabilityProvider`
- **SSOT**：用户是否启用了 AI 功能

### `llmAvailabilityProvider`

- **类型**：`StateNotifierProvider<LlmAvailabilityNotifier, LlmAvailability>`
- **文件**：`lib/providers/llm_provider.dart`
- **来源**：组合 `aiFeatureEnabledProvider` + 模型下载状态
- **消费者**：`CatDetailScreen`（日记卡片、聊天按钮）、`FocusCompleteScreen`（日记触发）
- **SSOT**：LLM 引擎是否就绪可推理

### `chatNotifierProvider`

- **类型**：`StateNotifierProvider.autoDispose.family<ChatNotifier, ChatState, String>`
- **文件**：`lib/providers/chat_provider.dart`
- **来源**：`ChatService`（SQLite 历史 + LLM 流）
- **消费者**：`CatChatScreen`
- **SSOT**：特定猫咪的聊天状态 — 消息列表、生成状态、部分回复

---

### `appInfoProvider`

- **类型**：`FutureProvider<PackageInfo>`
- **文件**：`lib/providers/app_info_provider.dart`
- **数据源**：`PackageInfo.fromPlatform()`（来自 `package_info_plus`）
- **消费者**：`SettingsScreen`（版本显示 + 许可证页面）
- **SSOT**：运行时应用版本信息（version、buildNumber、packageName）—— 消除硬编码版本号

---

## 核心模式

| 模式 | 使用场景 | 示例 |
|------|---------|------|
| `StreamProvider` | Firestore 实时数据 | `habitsProvider`、`catsProvider`、`coinBalanceProvider` |
| `FutureProvider.family` | 异步按键计算 | `catSpriteImageProvider(catId)` |
| `StateNotifierProvider` | 有方法的可变本地状态 | `focusTimerProvider` |
| `Provider` | 计算/派生值（其他 Provider 的纯函数） | `statsProvider`、`todayMinutesPerHabitProvider`、`hasCheckedInTodayProvider` |
| `Provider.family` | 参数化查询 | `catByIdProvider(catId)` |
| `ref.watch()` | 在 `build()` 中的响应式订阅，状态变化时重建组件 | 所有 `ConsumerWidget.build()` 方法 |
| `ref.read()` | 事件处理中的一次性读取，不订阅变化 | 按钮的 `onPressed` 回调 |
| `ref.listen()` | 状态变化的副作用（导航、弹窗） | 监听计时器 `completed` 状态 |

---

## 规则

1. **界面只从 Provider 读取数据** —— 通过 `ref.watch()` 或 `ref.read()`，不直接向 Screen 导入 Service。
2. **数据变更通过 Service 方法完成** —— 调用 `ref.read(someProvider.notifier).method()` 或通过注入 Notifier 的 Service 直接操作。
3. **Firestore 数据无本地状态** —— 若数据在 Firestore 中，使用 `StreamProvider` 流式传输，不在 `StatefulWidget` 中缓存。
4. **UI 专属状态**（计时器运行、弹窗打开、动画播放）属于 `StateNotifierProvider` 或 `StateProvider`，不存入 Firestore。
5. **Family Provider 在无消费者时自动释放** —— 这是正确行为，除非有特殊理由，不要覆写 `keepAlive()`。
6. **`AsyncValue` 模式** —— 所有 `StreamProvider` 和 `FutureProvider` 值均为 `AsyncValue<T>`，UI 中始终通过 `.when(data:, loading:, error:)` 处理。
7. **`ref.watch()` 只在 build 方法中使用** —— 不在回调、`initState` 或 `didChangeDependencies` 中调用 `ref.watch()`。
