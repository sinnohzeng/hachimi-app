# Firebase Crashlytics Integration

> **Purpose**: Documents the Crashlytics integration architecture, ErrorHandler API, breadcrumb strategy, and Firebase Performance traces.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   Flutter App Runtime                        │
│                                                             │
│  ┌──────────────────────────────────┐                       │
│  │     Uncaught Error Handlers      │                       │
│  │  FlutterError.onError            │──┐                    │
│  │  PlatformDispatcher.onError      │  │                    │
│  │  runZonedGuarded                 │  │                    │
│  └──────────────────────────────────┘  │                    │
│                                        ▼                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │               ErrorHandler.record()                   │   │
│  │                                                       │   │
│  │  1. debugPrint (always)                               │   │
│  │  2. Crashlytics.recordError (release only)            │   │
│  │  3. GA4 app_error event (analytics dashboard)         │   │
│  └──────────────────────────────────────────────────────┘   │
│            │                    │                            │
│            ▼                    ▼                            │
│  ┌─────────────────┐  ┌──────────────────┐                  │
│  │  Crashlytics     │  │  Firebase         │                 │
│  │  Console         │  │  Analytics (GA4)  │                 │
│  └─────────────────┘  └──────────────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

---

## ErrorHandler API

**Location**: `lib/core/utils/error_handler.dart`

### `ErrorHandler.record()`

Records a caught error to all three channels: debugPrint, Crashlytics, and GA4.

```dart
static Future<void> record(
  Object error, {
  StackTrace? stackTrace,
  required String source,     // e.g. 'CoinService'
  required String operation,  // e.g. 'checkIn'
  bool fatal = false,
  Map<String, String>? extras,
}) async
```

**Usage in service catch blocks:**

```dart
} catch (e, stack) {
  await ErrorHandler.record(e, stackTrace: stack, source: 'CoinService', operation: 'checkIn');
  rethrow;
}
```

**Custom keys set on Crashlytics:**
- `error_source` — class/module name
- `error_operation` — method name
- Any additional keys from `extras` map

### `ErrorHandler.breadcrumb()`

Appends a log message to Crashlytics for debugging context. Breadcrumbs appear in crash reports to help reconstruct user actions.

```dart
static void breadcrumb(String message)
```

---

## Crash Capture Layers

Configured in `lib/main.dart`:

| Layer | Captures | Code |
|-------|----------|------|
| `FlutterError.onError` | Widget build errors, layout overflows | `FirebaseCrashlytics.instance.recordFlutterFatalError` |
| `PlatformDispatcher.instance.onError` | Async errors not caught by Flutter framework | `ErrorHandler.record(error, fatal: true)` |
| `runZonedGuarded` | Zone-level unhandled errors | `ErrorHandler.record(error, fatal: true)` |

**Collection policy:** `setCrashlyticsCollectionEnabled(kReleaseMode)` — only collects in release builds to avoid noise during development.

**User identification:** After authentication, `FirebaseCrashlytics.instance.setUserIdentifier(user.uid)` links crashes to specific users.

---

## Service Integration

28 catch blocks across 12 service files now report to Crashlytics via `ErrorHandler.record()`:

| Service | Catch Blocks | Behavior |
|---------|-------------|----------|
| `firestore_service.dart` | 3 | Record + rethrow |
| `coin_service.dart` | 3 | Record + rethrow |
| `cat_firestore_service.dart` | 4 | Record + rethrow |
| `llm_service.dart` | 4 | Record + rethrow |
| `inventory_service.dart` | 2 | Record + rethrow |
| `migration_service.dart` | 2 | Record + rethrow |
| `focus_timer_service.dart` | 1 | Record + rethrow |
| `diary_service.dart` | 1 | Record + rethrow |
| `local_database_service.dart` | 1 | Record + rethrow |
| `pixel_cat_renderer.dart` | 2 | Record + rethrow |
| `atomic_island_service.dart` | 2 | Record + silent degrade |
| `analytics_service.dart` | 1 | Record + silent degrade |

---

## Breadcrumb Strategy

Breadcrumbs are lightweight log messages attached to Crashlytics reports. They help reconstruct the user's journey leading up to a crash.

| Location | Breadcrumb Message | Purpose |
|----------|-------------------|---------|
| `app.dart` (AuthGate) | `auth_state: <uid>` | Track auth transitions |
| `focus_setup_screen.dart` | `focus_started: <habit>, <min>min, <mode>` | Track session start |
| `timer_screen.dart` | `focus_completed: <habit>, <min>min, <coins>coins` | Track session completion |
| `adoption_flow_screen.dart` | `cat_adopted: <name>, <breed>` | Track adoption |
| `llm_provider.dart` | `llm_model_loaded: <path>` | Track LLM model loads |
| `check_in_banner.dart` | `daily_checkin_completed: +<coins> coins` | Track daily check-ins |

---

## Firebase Performance Traces

**Location**: `lib/core/utils/performance_traces.dart`

Custom traces measure execution time and success/failure of key operations.

```dart
class AppTraces {
  static Future<T> trace<T>(String name, Future<T> Function() fn) async
}
```

### Active Traces

| Trace Name | Operation | Location |
|-----------|-----------|----------|
| `log_focus_session` | Writing focus session data to Firestore | `firestore_service.dart` |
| `llm_load_model` | Loading the on-device LLM model | `llm_service.dart` |
| `llm_generate` | Generating text with the LLM | `llm_service.dart` |
| `diary_generate` | AI diary entry generation | `diary_service.dart` |
| `coin_check_in` | Daily check-in coin transaction | `coin_service.dart` |

Each trace automatically sets a `status` attribute (`"success"` or `"error"`).

---

## Offline Write Protection

**Location**: `lib/core/utils/offline_write_guard.dart`

A safety net for critical Firestore writes when Firestore's built-in offline persistence encounters edge cases (app crashes during writes).

```dart
await OfflineWriteGuard.guard(
  operationName: 'log_focus_session',
  payload: { 'habitId': id, 'minutes': 25 },
  writeFn: () => firestoreService.logFocusSession(...),
);
```

**Flow:**
1. Execute the Firestore write normally
2. On failure: save operation name + payload to SharedPreferences
3. On next app launch: `OfflineWriteGuard.retryPending(handlers)` replays failed writes

---

## Verification

### Crashlytics

```bash
# Force a test crash
FirebaseCrashlytics.instance.crash();

# Verify in Firebase Console → Crashlytics
```

### Performance Traces

```bash
# Complete a focus session → check Firebase Console → Performance → Custom traces
```

### DebugView (GA4 app_error events)

```bash
adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
# Trigger an error → verify app_error event in DebugView
```

---

## Changelog

- **2025-02**: Initial Crashlytics integration with ErrorHandler, breadcrumbs, Performance traces, and OfflineWriteGuard
