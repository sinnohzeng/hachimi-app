# Development Workflow

> **Purpose:** Explain the daily development cycle — build modes, hot reload, debugging tools, and when to use each command.
> **Scope:** Local development on any platform. Applies to both physical devices and emulators.
> **Status:** Active
> **Evidence:** Flutter CLI (`flutter run --help`), Gradle config (`android/gradle.properties`), `CLAUDE.md` commands section
> **Related:** [dev-debug-setup.md](dev-debug-setup.md) · [release/process.md](../release/process.md) · [CONTRIBUTING.md](../CONTRIBUTING.md)
> **Changelog:** 2026-02-23 — Initial version; documents hot reload workflow and build mode differences

---

## Build Modes

Flutter has two primary build modes. Understanding the difference is critical to an efficient development cycle.

| | Debug | Release |
|---|---|---|
| **Compilation** | JIT (Just-In-Time) — code compiled on-the-fly on device | AOT (Ahead-Of-Time) — compiled to native ARM code |
| **Hot reload** | Supported | Not supported |
| **Assertions** | Active (`assert()` executes) | Stripped |
| **DevTools** | Full access (widget inspector, performance overlay, memory profiler) | Not available |
| **Performance** | Slower — JIT overhead, no tree shaking | Maximum — native code, dead code elimination |
| **App size** | Larger — includes JIT compiler and debug metadata | Smaller — stripped and optimized |
| **R8 minification** | Off | On (`minifyEnabled true` + `shrinkResources true`) |
| **Typical build time** | 30–90 s (first launch) | 10–17 min |

**Rule of thumb:** Use debug mode for all development. Use release mode only for CI/CD deployment or production behavior verification.

---

## Hot Reload & Hot Restart

Hot reload and hot restart are the core of Flutter's development experience. They replace the traditional "edit → build → install → launch" cycle with near-instant feedback.

### Hot Reload

Hot reload injects updated Dart source code into the running Dart VM **without restarting the app**. The app keeps its current state — navigation stack, form inputs, scroll position, animation progress.

**Speed:** 200–800 ms from save to visible change.

**Trigger:** Press `r` in the `flutter run` terminal.

**What hot reload handles:**
- Changes to widget `build()` methods (layout, styling, text)
- Modifications to business logic in existing methods
- Adding new methods or fields to existing classes
- Updating string literals, colors, padding, margins, fonts
- Changing default parameter values

### Hot Restart

Hot restart recompiles all Dart code and restarts the app from `main()`. App state is lost, but native code is not recompiled.

**Speed:** 2–5 seconds.

**Trigger:** Press `R` (capital) in the `flutter run` terminal.

**When hot restart is needed instead of hot reload:**
- Adding, removing, or renaming a class
- Changing class inheritance hierarchy
- Changing generic type arguments
- Changing enum values
- Modifying `static` fields or initializers
- Changes to `main()` or top-level initialization
- Changes to code in `initState()` (the code updates, but `initState` does not re-run without restart)

### Full Rebuild

Stop `flutter run` (press `q`) and re-run it. Only needed when:

- Native code changes (Gradle config, Kotlin/Java files, `AndroidManifest.xml`)
- Adding or upgrading a plugin that includes native code
- Changing `--dart-define` values (e.g., `MINIMAX_API_KEY`, `GEMINI_API_KEY`)
- Modifying asset declarations in `pubspec.yaml`
- Changing minimum SDK version or other Gradle configuration

---

## Daily Development Cycle

```
┌──────────────────────────────────────────────────────────┐
│  1. Start session (once, ~30–90 s)                       │
│     adb shell settings put global package_verifier_enable 0
│     flutter run --dart-define-from-file=.env              │
├──────────────────────────────────────────────────────────┤
│  2. Edit code → save → hot reload (r) → 0.5 s            │
│     Repeat as needed                                      │
├──────────────────────────────────────────────────────────┤
│  3. Structural change? → hot restart (R) → 2–5 s         │
├──────────────────────────────────────────────────────────┤
│  4. Changed native code? → quit (q) → re-run flutter run │
├──────────────────────────────────────────────────────────┤
│  5. Ready to release? → git push tag → CI builds release  │
└──────────────────────────────────────────────────────────┘
```

### When to use each command

| Scenario | Command |
|----------|---------|
| Active development (90% of the time) | `flutter run --dart-define-from-file=.env` |
| Spot-check release behavior | `flutter run --release --dart-define-from-file=.env` |
| Generate debug APK for manual install | `flutter build apk --debug --dart-define-from-file=.env` |
| Generate release APK for deployment | `flutter build apk --release --dart-define-from-file=.env` |
| Generate AAB for Google Play | `flutter build appbundle --release --dart-define-from-file=.env` |

> **Do not** run `flutter build apk --release` during development. It takes 10–17 minutes and does not support hot reload. Reserve it for CI/CD and final verification.

---

## Logs & Debugging

### Terminal output during `flutter run`

When `flutter run` is active, all `print()` and `debugPrint()` output appears directly in the terminal. This is the primary way to read app logs during development.

### ADB logcat

For logs outside of `flutter run` (e.g., after a manual APK install), use ADB:

```bash
# Flutter-specific logs
adb logcat -s flutter

# Firebase-related logs
adb logcat -s FirebaseAuth,FirebaseFirestore,FirebaseMessaging

# All app logs with error filtering
adb logcat | grep -iE "hachimi|error|exception"

# Clear log buffer and start fresh
adb logcat -c && adb logcat -s flutter
```

### `flutter attach`

If the app was installed manually (not via `flutter run`), you can still connect to a running debug build:

```bash
flutter attach --dart-define-from-file=.env
```

This re-establishes the live connection to the Dart VM and enables hot reload, hot restart, and log output — the same as if `flutter run` had launched it.

### Flutter DevTools

When running in debug mode, `flutter run` prints a DevTools URL:

```
Flutter DevTools is available at: http://127.0.0.1:9100?uri=...
```

DevTools provides:

| Tool | Purpose |
|------|---------|
| Widget Inspector | Explore widget tree, see layout constraints, debug overflow |
| Performance Overlay | Frame rendering times, jank detection |
| Memory Profiler | Heap snapshots, allocation tracking, leak detection |
| Network Inspector | HTTP request/response inspection |
| CPU Profiler | Method-level performance analysis |

---

## Vivo Device Workaround

If `flutter run` fails to install on the vivo V2405A with `INSTALL_FAILED_ABORTED`, use the manual install + attach approach:

```bash
# Build debug APK
flutter build apk --debug --dart-define-from-file=.env

# Install manually
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk

# Connect for hot reload
flutter attach --dart-define-from-file=.env
```

See [dev-debug-setup.md — Troubleshooting: Install Failures](dev-debug-setup.md#troubleshooting-install-failures) for detailed diagnosis steps.

---

## Gradle Build Optimization

The project's `android/gradle.properties` follows Gradle best practices:

```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+UseParallelGC -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true
```

| Flag | Effect |
|------|--------|
| `-XX:+UseParallelGC` | Parallel garbage collection — 9–20% GC throughput improvement on JDK 17+ |
| `-Dfile.encoding=UTF-8` | Prevents build cache misses from encoding differences across environments |
| `org.gradle.parallel=true` | Executes independent subproject tasks in parallel |
| `org.gradle.caching=true` | Reuses task outputs from previous builds (incremental builds) |

These flags primarily benefit the initial `flutter run` launch and full release builds. Hot reload bypasses Gradle entirely.

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-23 | Initial version — hot reload workflow, build modes, debugging tools, Gradle optimization |
