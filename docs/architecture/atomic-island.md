# Atomic Island — vivo Dynamic Island Adaptation (SSOT)

> **SSOT**: This document is the authoritative specification for the vivo Atomic Island (Dynamic Island) integration. The notification metadata strategy and platform channel interface must match this spec.

---

## Overview

When a focus timer is running, Hachimi displays an enhanced foreground notification that vivo OriginOS can automatically promote to the **Atomic Island** capsule on the status bar. The notification also renders as a rich lock screen widget on Android 16+ via `ProgressStyle`.

**Key constraint**: vivo does not provide a public third-party SDK for Atomic Island. The approach relies on standard Android notification metadata (`CATEGORY_STOPWATCH` + `setUsesChronometer(true)` + `FLAG_ONGOING`) which OriginOS recognizes and promotes to the island.

---

## Display Design

### Atomic Island Capsule (System-rendered)

```
+------------------------------+
|  [icon]  24:35 <             |   <- App icon + system chronometer countdown
+------------------------------+
```

### Notification Shade (Expanded)

```
+-- Hachimi ----------- 24:35 --+
| +----------------------------+ |
| | [cat icon]  Kitty focusing | |   <- Large icon: app_icon
| |            Morning Reading | |   <- Content text: habit name
| +----------------------------+ |
+--------------------------------+
```

### Lock Screen (Android 16+ ProgressStyle)

```
+-- Hachimi --- [=====>    ] 24:35 --+
|  Kitty focusing... . Morning Reading |
+--------------------------------------+
```

---

## Architecture

### Strategy: Notification Overlay

`flutter_foreground_task` manages the foreground service lifecycle but lacks support for `setCategory()`, `setUsesChronometer()`, and `setWhen()`. Instead of forking the plugin, we:

1. Keep `flutter_foreground_task` for service keepalive (its core responsibility)
2. Use a custom **Kotlin MethodChannel** to build rich notifications that override the plugin's notification (same notification ID = 1000; later `notify()` wins)

### Notification Channel Migration

| Property | Old (v1) | New (v2) |
|----------|----------|----------|
| Channel ID | `hachimi_focus_timer` | `hachimi_focus_timer_v2` |
| Importance | `DEFAULT` | `HIGH` |
| Sound | Default | `null` (silent, `onlyAlertOnce`) |

The old channel is programmatically deleted on first launch after upgrade.

---

## Platform Channel Interface

**Channel name**: `com.hachimi.notification`

### `updateTimerNotification`

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `title` | String | Yes | e.g. "Kitty focusing..." |
| `text` | String | Yes | e.g. "Morning Reading" |
| `subText` | String | No | Default: "Hachimi" |
| `endTimeMs` | long | Conditional | Countdown mode: epoch ms when timer ends |
| `startTimeMs` | long | Conditional | Stopwatch mode: epoch ms when timer started |
| `isCountdown` | bool | Yes | `true` for countdown, `false` for stopwatch |
| `isPaused` | bool | Yes | When paused, chronometer stops; static text shown |

### `cancelTimerNotification`

No parameters. Cancels the notification by ID 1000.

---

## Kotlin Implementation

### Files

| File | Purpose |
|------|---------|
| `android/app/src/main/kotlin/.../FocusNotificationHelper.kt` | Notification builder — channel creation, `updateNotification()`, `cancel()` |
| `android/app/src/main/kotlin/.../MainActivity.kt` | MethodChannel registration |

### Notification Builder Key Properties

```
setCategory(CATEGORY_STOPWATCH)     -> vivo island recognition
setUsesChronometer(true)            -> system-rendered countdown/stopwatch
setChronometerCountDown(isCountdown) -> countdown vs. stopwatch direction
setWhen(endTimeMs or startTimeMs)   -> chronometer anchor point
setOngoing(true)                    -> prevents swipe-dismiss
setVisibility(VISIBILITY_PUBLIC)    -> lock screen display
setOnlyAlertOnce(true)              -> no repeated sound/vibration
```

### Android 16+ ProgressStyle

When `Build.VERSION.SDK_INT >= 36`, the notification uses `Notification.ProgressStyle` with progress points derived from start/end times. Requires `POST_PROMOTED_NOTIFICATIONS` permission.

---

## Dart Integration

### Files

| File | Purpose |
|------|---------|
| `lib/services/atomic_island_service.dart` | Platform channel wrapper — `updateNotification()`, `cancel()` |
| `lib/providers/focus_timer_provider.dart` | Calls `AtomicIslandService` from `_updateNotification()` |
| `lib/screens/timer/focus_setup_screen.dart` | Passes `catName` to `configure()` |

### State Change: `catName` Field

`FocusTimerState` gains a `catName` field (String, default `''`). This is:
- Set via `configure(catName: ...)` from `FocusSetupScreen`
- Persisted to SharedPreferences (`focus_timer_catName`)
- Used in notification title: `"$catName focusing..."`

---

## Fallback Behavior

If the MethodChannel call fails (e.g., app killed, channel not available), `flutter_foreground_task`'s basic notification remains visible. The rich notification is an enhancement, not a replacement for the foreground service.

---

## Permissions

| Permission | Purpose |
|------------|---------|
| `POST_NOTIFICATIONS` | Already declared — standard notification permission |
| `POST_PROMOTED_NOTIFICATIONS` | New — Android 16 live updates / ProgressStyle |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-19 | Initial specification — vivo Atomic Island via notification metadata |
