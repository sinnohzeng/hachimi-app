# Local Development Feedback Loop

> **Purpose:** Guide for setting up a fast, local development feedback loop — from environment selection to debugging strategy, designed to catch issues in seconds rather than waiting for CI.
> **Scope:** Any developer working on Hachimi, regardless of platform (macOS / Windows / Linux).
> **Status:** Active
> **Evidence:** Flutter CLI, `CLAUDE.md` commands, `development-workflow.md`, `dev-debug-setup.md`
> **Related:** [development-workflow.md](development-workflow.md) · [dev-debug-setup.md](dev-debug-setup.md) · [release/process.md](../release/process.md)
> **Changelog:** 2026-03-10 — Initial version; documents feedback tier model, environment requirements, and Riverpod debugging

---

## The Problem: CI-Only Feedback Loop

If your only way to test changes is pushing to CI, waiting for a build, downloading the APK, and manually installing — every iteration takes 15–25 minutes. Most issues (compile errors, runtime bugs, state management mistakes) can be caught locally in **seconds**.

---

## Feedback Tier Model

Effective Flutter development uses a layered approach. Each tier is faster than the next and catches different categories of issues.

```
┌──────────────────────────────────────────────────────────┐
│  Tier 1: Static Analysis (instant, 0 s)                  │
│    IDE red underlines + dart analyze                     │
│    Catches: type errors, unused imports, lint violations  │
├──────────────────────────────────────────────────────────┤
│  Tier 2: Hot Reload (1–2 s)                              │
│    Edit UI / state → Ctrl+S → device updates             │
│    Catches: layout bugs, styling, widget logic            │
├──────────────────────────────────────────────────────────┤
│  Tier 3: Hot Restart (3–5 s)                             │
│    Structural changes → full Dart restart, keep install   │
│    Catches: initialization bugs, route changes            │
├──────────────────────────────────────────────────────────┤
│  Tier 4: Debug & Breakpoints (real-time)                 │
│    Step through code, inspect variables, watch providers  │
│    Catches: logic errors, race conditions, state bugs     │
├──────────────────────────────────────────────────────────┤
│  Tier 5: Automated Tests (10–30 s)                       │
│    flutter test → unit + widget tests                    │
│    Catches: regressions, edge cases, contract violations  │
├──────────────────────────────────────────────────────────┤
│  Tier 6: CI (8–10 min, last resort)                      │
│    Push → GitHub Actions → final validation              │
│    Catches: environment-specific issues, release signing  │
└──────────────────────────────────────────────────────────┘
```

**Key insight:** If you only have Tier 1 and Tier 6, you are missing the most productive tiers (2–5). A local machine with a connected device unlocks all six.

---

## Environment Requirements

### Minimum for Effective Development

| Requirement | Why |
|---|---|
| **Local machine** (not a headless cloud server) | GUI needed for emulator, DevTools, IDE debugging |
| **8+ GB RAM** (16 GB recommended) | Android emulator + IDE + Gradle daemon run concurrently |
| **4+ CPU cores** | Parallel Gradle tasks, background analysis |
| **KVM / Hypervisor support** | Android emulator hardware acceleration (Intel VT-x / AMD-V / Apple Silicon) |
| **USB port or WiFi ADB** | Physical device connection for Tier 2–4 |

### Platform Comparison

| | macOS (recommended) | Windows | Linux | Cloud Server |
|---|---|---|---|---|
| Android development | Full | Full | Full | Static analysis only |
| iOS development | Full | Not possible | Not possible | Not possible |
| Emulator performance | Native ARM on Apple Silicon | Good with HAXM/WHPX | Good with KVM | No KVM = no emulator |
| Hot Reload | Supported | Supported | Supported | No device to connect |
| Debug breakpoints | Supported | Supported | Supported | Not possible |
| DevTools | Full GUI | Full GUI | Full GUI | No GUI |

### When a Cloud Server is Still Useful

- Running Claude Code for AI-assisted development
- Running `dart analyze` and `dart format` as a pre-push check
- Git operations and CI monitoring (`gh run watch`)
- Code review and documentation work

**But do not use it as your primary development environment for a Flutter app.**

---

## Device Setup

### Option A: Physical Device (Recommended)

A real device gives the most accurate feedback — real performance, real gestures, real sensors.

```bash
# USB connection
adb devices                  # Verify device is listed

# WiFi debugging (Android 11+, useful when USB is inconvenient)
adb pair <ip>:<port>         # One-time pairing
adb connect <ip>:<port>      # Connect

# Vivo-specific workaround (if flutter run install fails)
adb shell settings put global package_verifier_enable 0
```

### Option B: Android Emulator

Useful as a secondary device or when no physical device is available.

```bash
# Create (via Android Studio Device Manager, or CLI)
avdmanager create avd -n pixel7 -k "system-images;android-34;google_apis;arm64-v8a"

# Launch
emulator -avd pixel7

# Verify
flutter devices              # Should list both emulator and any physical device
```

---

## Debugging Strategy

### Riverpod Provider Observer

Add a provider observer in debug mode to trace all state changes. Especially useful for diagnosing "data not refreshing" issues.

```dart
// In main.dart
ProviderScope(
  observers: [if (kDebugMode) _ProviderLogger()],
  child: const HachimiApp(),
)

class _ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '[RIVERPOD] ${provider.name ?? provider.runtimeType}: '
      '$previousValue → $newValue',
    );
  }
}
```

After login, this immediately shows which providers refreshed and which did not — no guesswork.

### Targeted debugPrint for Auth Lifecycle

```dart
// Key observation points for auth-related issues:
debugPrint('[AUTH] finalizeSetup: linkMode=$linkMode, mounted=$mounted');
debugPrint('[SYNC] hydrate complete, emitting LedgerChange(hydrate)');
debugPrint('[GATE] checkedFirstHabit=$_checkedFirstHabit, isHydrated=$isHydrated');
debugPrint('[PROVIDER] habitsProvider received change: ${change.type}');
```

### Breakpoint Debugging (VS Code)

1. Click left of a line number to set a breakpoint
2. Press F5 to launch in debug mode
3. When the breakpoint hits, inspect:
   - Local variables in the **Variables** panel
   - Call stack in the **Call Stack** panel
   - Evaluate expressions in the **Debug Console**

This is the fastest way to diagnose logic errors like race conditions or incorrect branching.

### Flutter DevTools

```bash
flutter run    # Prints DevTools URL on startup
# Open http://127.0.0.1:9100 in browser
```

| Tool | Best for |
|---|---|
| Widget Inspector | Layout debugging, overflow, constraints |
| Performance | Frame timing, jank detection |
| Memory | Leak detection, allocation tracking |
| Network | HTTP / Firestore request inspection |
| Logging | Structured log viewing with filtering |

---

## Pre-Push Checklist

Before pushing to CI, run these locally to avoid wasted CI cycles:

```bash
# 1. Static analysis (catches type errors, lint issues)
dart analyze lib/

# 2. Format check (CI enforces --set-exit-if-changed)
dart format lib/ test/

# 3. Tests (catches regressions)
flutter test

# 4. Verify version consistency (if releasing)
# pubspec.yaml version must match the tag you plan to create
```

If all four pass locally, CI should pass too. The only CI-specific steps are release signing, AAB building, and Play Store upload.

---

## Recommended Daily Workflow

```
1. Open VS Code + connect device (USB or emulator)
2. F5 or `flutter run --dart-define-from-file=.env`
3. Edit code → Ctrl+S → Hot Reload (1 s)
4. Hit a bug → set breakpoint → F5 debug → inspect variables
5. Fix confirmed → `flutter test` (30 s)
6. `dart analyze lib/ && dart format lib/ test/`
7. git commit → git push → CI validates (last resort)
```

Total feedback time per iteration: **1–30 seconds** (vs 15–25 minutes with CI-only).

---

## Changelog

| Date | Change |
|---|---|
| 2026-03-10 | Initial version — feedback tier model, environment requirements, Riverpod debugging, pre-push checklist |
