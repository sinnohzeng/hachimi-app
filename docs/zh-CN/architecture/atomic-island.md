# 原子岛 — vivo 灵动岛适配（SSOT）

> **SSOT**：本文档是 vivo 原子岛（灵动岛）集成的权威规格说明。通知元数据策略和平台通道接口必须与本规范一致。

---

## 概述

当专注计时器运行时，Hachimi 会显示一条增强型前台通知，vivo OriginOS 可自动将其提升至状态栏的 **原子岛** 胶囊中。在 Android 16+ 设备上，通知还会通过 `ProgressStyle` 以富媒体形式渲染在锁屏界面。

**关键约束**：vivo 没有公开的第三方原子岛 SDK。本方案依赖标准 Android 通知元数据（`CATEGORY_STOPWATCH` + `setUsesChronometer(true)` + `FLAG_ONGOING`），OriginOS 识别这些属性后自动将通知提升至岛上。

---

## 显示设计

### 原子岛胶囊（系统渲染）

```
+------------------------------+
|  [图标]  24:35 <             |   <- App 图标 + 系统 chronometer 倒计时
+------------------------------+
```

### 通知栏展开

```
+-- Hachimi ----------- 24:35 --+
| +----------------------------+ |
| | [猫头像]  小橘 专注中...    | |   <- 大图标：app_icon
| |           Morning Reading  | |   <- 内容文本：习惯名称
| +----------------------------+ |
+--------------------------------+
```

### 锁屏（Android 16+ ProgressStyle）

```
+-- Hachimi --- [=====>    ] 24:35 --+
|  小橘 专注中... · Morning Reading    |
+--------------------------------------+
```

---

## 架构

### 策略：通知覆盖

`flutter_foreground_task` 管理前台服务生命周期，但不支持 `setCategory()`、`setUsesChronometer()` 和 `setWhen()`。我们不 fork 插件，而是：

1. 继续使用 `flutter_foreground_task` 保持服务存活（其核心职责）
2. 通过自定义 **Kotlin MethodChannel** 构建富通知，覆盖插件自带的通知（相同 notification ID = 1000，后调用的 `notify()` 生效）

### 通知渠道迁移

| 属性 | 旧版（v1） | 新版（v2） |
|------|-----------|-----------|
| Channel ID | `hachimi_focus_timer` | `hachimi_focus_timer_v2` |
| 重要性 | `DEFAULT` | `HIGH` |
| 声音 | 默认 | `null`（静音，`onlyAlertOnce`） |

旧渠道在升级后首次启动时由程序化删除。

---

## 平台通道接口

**通道名称**：`com.hachimi.notification`

### `updateTimerNotification`

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `title` | String | 是 | 例："小橘 专注中..." |
| `text` | String | 是 | 例："Morning Reading" |
| `subText` | String | 否 | 默认："Hachimi" |
| `endTimeMs` | long | 条件必填 | 倒计时模式：计时器结束时刻的 epoch 毫秒 |
| `startTimeMs` | long | 条件必填 | 正计时模式：计时器开始时刻的 epoch 毫秒 |
| `isCountdown` | bool | 是 | `true` 为倒计时，`false` 为正计时 |
| `isPaused` | bool | 是 | 暂停时 chronometer 停止，显示静态文本 |

### `cancelTimerNotification`

无参数。通过 ID 1000 取消通知。

---

## Kotlin 实现

### 文件

| 文件 | 职责 |
|------|------|
| `android/app/src/main/kotlin/.../FocusNotificationHelper.kt` | 通知构建器 — 渠道创建、`updateNotification()`、`cancel()` |
| `android/app/src/main/kotlin/.../MainActivity.kt` | MethodChannel 注册 |

### 通知构建器关键属性

```
setCategory(CATEGORY_STOPWATCH)     -> vivo 岛识别
setUsesChronometer(true)            -> 系统渲染的倒计时/正计时
setChronometerCountDown(isCountdown) -> 倒计时 vs. 正计时方向
setWhen(endTimeMs or startTimeMs)   -> chronometer 锚点时间
setOngoing(true)                    -> 防止滑动关闭
setVisibility(VISIBILITY_PUBLIC)    -> 锁屏显示
setOnlyAlertOnce(true)              -> 不重复声音/振动
```

### Android 16+ ProgressStyle

当 `Build.VERSION.SDK_INT >= 36` 时，通知使用 `Notification.ProgressStyle`，进度点从开始/结束时间推算。需要 `POST_PROMOTED_NOTIFICATIONS` 权限。

---

## Dart 集成

### 文件

| 文件 | 职责 |
|------|------|
| `lib/services/atomic_island_service.dart` | 平台通道封装 — `updateNotification()`、`cancel()` |
| `lib/providers/focus_timer_provider.dart` | 在 `_updateNotification()` 中调用 `AtomicIslandService` |
| `lib/screens/timer/focus_setup_screen.dart` | 将 `catName` 传入 `configure()` |

### 状态变更：`catName` 字段

`FocusTimerState` 新增 `catName` 字段（String，默认 `''`）。该字段：
- 通过 `configure(catName: ...)` 从 `FocusSetupScreen` 设置
- 持久化到 SharedPreferences（`focus_timer_catName`）
- 用于通知标题："$catName 专注中..."

---

## 降级行为

如果 MethodChannel 调用失败（例如 App 被杀、通道不可用），`flutter_foreground_task` 的基础通知仍然可见。富通知是增强功能，而非前台服务的替代。

---

## 权限

| 权限 | 用途 |
|------|------|
| `POST_NOTIFICATIONS` | 已声明 — 标准通知权限 |
| `POST_PROMOTED_NOTIFICATIONS` | 新增 — Android 16 实时更新 / ProgressStyle |

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-02-19 | 初始规格说明 — 通过通知元数据实现 vivo 原子岛适配 |
