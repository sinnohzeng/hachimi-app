# Edge-to-Edge Compliance Plan

> Resolve Google Play Console warnings for SDK 35 edge-to-edge enforcement.

## Problem

Google Play Console reported 2 recommended actions for Hachimi v2.24.0 (targetSdk 35):

1. **Edge-to-edge may not display for all users** -- app must handle insets on Android 15+.
2. **Deprecated APIs** -- `Window.setStatusBarColor`, `setNavigationBarColor`, `setNavigationBarDividerColor` called from:
   - `com.google.android.material.datepicker.n.onStart` (Material Components 1.7.0)
   - `io.flutter.plugin.platform.PlatformPlugin.setSystemChromeSystemUIOverlayStyle` (Flutter engine)

## Root Cause

- Android themes used legacy `Theme.Light.NoTitleBar` / `Theme.Black.NoTitleBar`.
- No `enableEdgeToEdge()` call in MainActivity.
- Flutter layer had no `SystemUiMode.edgeToEdge` or transparent system bar configuration.
- Material Components 1.7.0 and activity 1.8.1 too old.

## Solution Architecture (3-Layer SSOT)

```
Layer                  Lifecycle                    Responsibility
Android XML Theme      Process start -> onCreate    Splash screen window background + theme base
enableEdgeToEdge()     onCreate() one-shot           Native window edge-to-edge (API-aware)
Flutter init           main() -> first frame         SystemUiMode + transparent bar bootstrap
AppBarTheme            Widget lifecycle              Status/nav bar icon brightness per theme
```

## Changes

| # | File | Change |
|---|------|--------|
| 1 | `values/styles.xml` | `Theme.Light.NoTitleBar` -> `Theme.Material3.Light.NoActionBar` |
| 2 | `values-night/styles.xml` | `Theme.Black.NoTitleBar` -> `Theme.Material3.Dark.NoActionBar` |
| 3 | `MainActivity.kt` | `FlutterActivity` -> `FlutterFragmentActivity` + `enableEdgeToEdge()` in `onCreate()` |
| 4 | `build.gradle` | Add `activity-ktx:1.10.1` + `material:1.12.0` |
| 5 | `main.dart` | `SystemUiMode.edgeToEdge` + transparent system bar overlay |
| 6 | `app_theme.dart` | `AppBarTheme.systemOverlayStyle` with transparent bars + adaptive icon brightness |
| 7 | `cat_detail_screen.dart` | Explicit transparent `SystemUiOverlayStyle` replacing preset constants |

## Upstream Limitations

- Flutter engine `PlatformPlugin` still calls deprecated `Window.setStatusBarColor()` internally -- mitigated by transparent color parameter.
- Material datepicker deprecated call fixed in Material Components >= 1.12.0.
- Both are Play Console "recommended actions" (non-blocking).

## Status: Completed
