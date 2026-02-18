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


计时器状态（本地状态，非 Firestore）：

  focusTimerProvider (StateNotifierProvider<FocusTimerNotifier, FocusTimerState>)
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
- **数据源**：`FirestoreService.watchCats(uid)` —— 仅流式传输 `state == "active"` 的猫咪
- **消费者**：`CatRoomScreen`、`HomeScreen`（习惯列表中的猫咪头像）、`ProfileScreen`（稀有度分布）
- **SSOT**：用户的活跃猫咪，始终保持最新

### `allCatsProvider`

- **类型**：`StreamProvider<List<Cat>>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：`FirestoreService.watchAllCats(uid)` —— 流式传输所有状态的猫咪
- **消费者**：猫咪相册（Profile 界面）、`ownedBreedsProvider`
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

### `ownedBreedsProvider`

- **类型**：`Provider<Set<String>>`
- **文件**：`lib/providers/cat_provider.dart`
- **数据源**：派生自 `allCatsProvider` —— 收集所有曾拥有的品种 ID
- **消费者**：`CatGenerationService`（保证每次抽卡至少含 1 种新品种）
- **SSOT**：用户曾领养过的品种 ID 集合

---

### `focusTimerProvider`

- **类型**：`StateNotifierProvider<FocusTimerNotifier, FocusTimerState>`
- **文件**：`lib/providers/focus_timer_provider.dart`
- **数据源**：本地状态（Provider 本身无 Firebase 依赖）
- **消费者**：`TimerScreen`、`FocusCompleteScreen`
- **SSOT**：活跃专注计时器的有限状态机（FSM，Finite State Machine）

**`FocusTimerState` 字段：**

| 字段 | 类型 | 说明 |
|------|------|------|
| `habitId` | String? | 当前活跃习惯 |
| `catId` | String? | 正在获得 XP 的猫咪 |
| `totalSeconds` | int | 目标时长（倒计时模式）或 0（正计时模式） |
| `remainingSeconds` | int | 剩余秒数（倒计时模式） |
| `elapsedSeconds` | int | 已用秒数（两种模式均记录） |
| `status` | 枚举 | `idle`、`running`、`paused`、`completed`、`abandoned` |
| `mode` | 枚举 | `countdown`（倒计时）、`stopwatch`（正计时） |
| `startedAt` | DateTime? | 会话开始时间戳 |

**`FocusTimerNotifier` 方法：**

| 方法 | 说明 |
|------|------|
| `start(habitId, catId, seconds, mode)` | 初始化并启动计时器 |
| `pause()` | 暂停计时器（记录 `pausedAt`） |
| `resume()` | 从暂停状态恢复 |
| `complete()` | 标记为已完成，触发会话保存 |
| `abandon()` | 标记为已放弃（≥ 5 分钟获得部分 XP） |
| `onAppBackgrounded()` | 记录应用进入后台的时间戳 |
| `onAppResumed(away)` | 处理返回：< 15s 继续，> 5min 自动结束 |
| `reset()` | 返回 `idle` 状态 |

**计时器心跳**：`Timer.periodic(const Duration(seconds: 1), _onTick)` —— 通过 `ref.onDispose()` 进行清理。

---

## 核心模式

| 模式 | 使用场景 | 示例 |
|------|---------|------|
| `StreamProvider` | Firestore 实时数据 | `habitsProvider`、`catsProvider` |
| `StateNotifierProvider` | 有方法的可变本地状态 | `focusTimerProvider` |
| `Provider` | 计算/派生值（其他 Provider 的纯函数） | `statsProvider`、`todayMinutesPerHabitProvider` |
| `Provider.family` | 参数化查询 | `catByIdProvider(catId)` |
| `ref.watch()` | 在 `build()` 中的响应式订阅，状态变化时重建组件 | 所有 `ConsumerWidget.build()` 方法 |
| `ref.read()` | 事件处理中的一次性读取，不订阅变化 | 按钮的 `onPressed` 回调 |
| `ref.listen()` | 状态变化的副作用（导航、弹窗） | 监听计时器 `completed` 状态 |

---

## 规则

1. **界面只从 Provider 读取数据** —— 通过 `ref.watch()` 或 `ref.read()`，不直接向 Screen 导入 Service。
2. **数据变更通过 Service 方法完成** —— 调用 `ref.read(someProvider.notifier).method()` 或通过注入 Notifier 的 `FirestoreService` 直接操作。
3. **Firestore 数据无本地状态** —— 若数据在 Firestore 中，使用 `StreamProvider` 流式传输，不在 `StatefulWidget` 中缓存。
4. **UI 专属状态**（计时器运行、弹窗打开、动画播放）属于 `StateNotifierProvider` 或 `StateProvider`，不存入 Firestore。
5. **Family Provider 在无消费者时自动释放** —— 这是正确行为，除非有特殊理由，不要覆写 `keepAlive()`。
6. **`AsyncValue` 模式** —— 所有 `StreamProvider` 和 `FutureProvider` 值均为 `AsyncValue<T>`，UI 中始终通过 `.when(data:, loading:, error:)` 处理。
7. **`ref.watch()` 只在 build 方法中使用** —— 不在回调、`initState` 或 `didChangeDependencies` 中调用 `ref.watch()`。
