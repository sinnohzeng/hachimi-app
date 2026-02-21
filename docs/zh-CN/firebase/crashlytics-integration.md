# Firebase Crashlytics 集成

> **目的**：记录 Crashlytics 集成架构、ErrorHandler API、面包屑策略和 Firebase Performance 自定义追踪。

---

## 架构概览

```
┌─────────────────────────────────────────────────────────────┐
│                   Flutter 应用运行时                          │
│                                                             │
│  ┌──────────────────────────────────┐                       │
│  │     未捕获错误处理器               │                       │
│  │  FlutterError.onError            │──┐                    │
│  │  PlatformDispatcher.onError      │  │                    │
│  │  runZonedGuarded                 │  │                    │
│  └──────────────────────────────────┘  │                    │
│                                        ▼                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │               ErrorHandler.record()                   │   │
│  │                                                       │   │
│  │  1. debugPrint（始终输出，用于本地开发）                  │   │
│  │  2. Crashlytics.recordError（仅 release 构建）          │   │
│  │  3. GA4 app_error 事件（用于分析仪表板）                 │   │
│  └──────────────────────────────────────────────────────┘   │
│            │                    │                            │
│            ▼                    ▼                            │
│  ┌─────────────────┐  ┌──────────────────┐                  │
│  │  Crashlytics     │  │  Firebase         │                 │
│  │  控制台           │  │  Analytics (GA4)  │                 │
│  └─────────────────┘  └──────────────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

---

## ErrorHandler API

**文件位置**：`lib/core/utils/error_handler.dart`

### `ErrorHandler.record()`

将捕获的错误同时发送到三个渠道：debugPrint、Crashlytics 和 GA4。

```dart
static Future<void> record(
  Object error, {
  StackTrace? stackTrace,
  required String source,     // 如 'CoinService'
  required String operation,  // 如 'checkIn'
  bool fatal = false,
  Map<String, String>? extras,
}) async
```

**Service catch 块中的用法：**

```dart
} catch (e, stack) {
  await ErrorHandler.record(e, stackTrace: stack, source: 'CoinService', operation: 'checkIn');
  rethrow;
}
```

**Crashlytics 自定义键：**
- `error_source` —— 类/模块名
- `error_operation` —— 方法名
- `extras` 中的额外键值对

### `ErrorHandler.breadcrumb()`

向 Crashlytics 添加日志消息，用于调试上下文。面包屑会出现在崩溃报告中，帮助还原用户操作路径。

```dart
static void breadcrumb(String message)
```

---

## 崩溃捕获层级

在 `lib/main.dart` 中配置：

| 层级 | 捕获范围 | 代码 |
|------|---------|------|
| `FlutterError.onError` | Widget 构建错误、布局溢出 | `FirebaseCrashlytics.instance.recordFlutterFatalError` |
| `PlatformDispatcher.instance.onError` | Flutter 框架未捕获的异步错误 | `ErrorHandler.record(error, fatal: true)` |
| `runZonedGuarded` | Zone 级别的未处理错误 | `ErrorHandler.record(error, fatal: true)` |

**采集策略**：`setCrashlyticsCollectionEnabled(kReleaseMode)` —— 仅在 release 构建中采集，避免开发阶段的噪音。

**用户标识**：认证完成后，`FirebaseCrashlytics.instance.setUserIdentifier(user.uid)` 将崩溃关联到特定用户。

---

## Service 集成

12 个 Service 文件中的 28 个 catch 块现在通过 `ErrorHandler.record()` 上报到 Crashlytics：

| Service | catch 块数 | 行为 |
|---------|-----------|------|
| `firestore_service.dart` | 3 | 记录 + rethrow |
| `coin_service.dart` | 3 | 记录 + rethrow |
| `cat_firestore_service.dart` | 4 | 记录 + rethrow |
| `llm_service.dart` | 4 | 记录 + rethrow |
| `inventory_service.dart` | 2 | 记录 + rethrow |
| `migration_service.dart` | 2 | 记录 + rethrow |
| `focus_timer_service.dart` | 1 | 记录 + rethrow |
| `diary_service.dart` | 1 | 记录 + rethrow |
| `local_database_service.dart` | 1 | 记录 + rethrow |
| `pixel_cat_renderer.dart` | 2 | 记录 + rethrow |
| `atomic_island_service.dart` | 2 | 记录 + 静默降级 |
| `analytics_service.dart` | 1 | 记录 + 静默降级 |

---

## 面包屑策略

面包屑是附加在 Crashlytics 报告中的轻量日志消息，帮助还原崩溃前的用户操作路径。

| 位置 | 面包屑消息 | 目的 |
|------|-----------|------|
| `app.dart`（AuthGate） | `auth_state: <uid>` | 追踪认证状态变化 |
| `focus_setup_screen.dart` | `focus_started: <habit>, <min>min, <mode>` | 追踪会话开始 |
| `timer_screen.dart` | `focus_completed: <habit>, <min>min, <coins>coins` | 追踪会话完成 |
| `adoption_flow_screen.dart` | `cat_adopted: <name>, <breed>` | 追踪猫咪领养 |
| `llm_provider.dart` | `llm_model_loaded: <path>` | 追踪 LLM 模型加载 |
| `check_in_banner.dart` | `daily_checkin_completed: +<coins> coins` | 追踪每日签到 |

---

## Firebase Performance 自定义追踪

**文件位置**：`lib/core/utils/performance_traces.dart`

自定义追踪测量关键操作的执行时间和成功/失败状态。

```dart
class AppTraces {
  static Future<T> trace<T>(String name, Future<T> Function() fn) async
}
```

### 已启用的追踪

| 追踪名称 | 操作 | 位置 |
|---------|------|------|
| `log_focus_session` | 写入专注会话数据到 Firestore | `firestore_service.dart` |
| `llm_load_model` | 加载设备端 LLM 模型 | `llm_service.dart` |
| `llm_generate` | 使用 LLM 生成文本 | `llm_service.dart` |
| `diary_generate` | AI 日记生成 | `diary_service.dart` |
| `coin_check_in` | 每日签到金币交易 | `coin_service.dart` |

每个追踪自动设置 `status` 属性（`"success"` 或 `"error"`）。

---

## 离线写入保护

**文件位置**：`lib/core/utils/offline_write_guard.dart`

当 Firestore 内置离线持久化遇到边界情况（如写入过程中应用崩溃）时的安全保障。

```dart
await OfflineWriteGuard.guard(
  operationName: 'log_focus_session',
  payload: { 'habitId': id, 'minutes': 25 },
  writeFn: () => firestoreService.logFocusSession(...),
);
```

**流程：**
1. 正常执行 Firestore 写入
2. 失败时：将操作名 + payload 保存到 SharedPreferences
3. 下次启动时：`OfflineWriteGuard.retryPending(handlers)` 重放失败的写入

---

## 验证方式

### Crashlytics

```bash
# 触发测试崩溃
FirebaseCrashlytics.instance.crash();
# 在 Firebase Console → Crashlytics 中验证
```

### Performance 追踪

```bash
# 完成一次专注会话 → 在 Firebase Console → Performance → Custom traces 中查看
```

### DebugView（GA4 app_error 事件）

```bash
adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
# 触发一个错误 → 在 DebugView 中验证 app_error 事件
```

---

## 变更日志

- **2025-02**：初始 Crashlytics 集成，包含 ErrorHandler、面包屑、Performance 追踪和 OfflineWriteGuard
