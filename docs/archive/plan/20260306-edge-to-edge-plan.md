# Edge-to-Edge 合规整改计划

> 解决 Google Play Console 针对 SDK 35 edge-to-edge 强制执行的警告。

## 问题

Google Play Console 对 Hachimi v2.24.0（targetSdk 35）报告了 2 项推荐操作：

1. **Edge-to-edge 可能无法正确显示** -- 应用需在 Android 15+ 上正确处理 insets。
2. **使用了已弃用 API** -- `Window.setStatusBarColor`、`setNavigationBarColor`、`setNavigationBarDividerColor`，调用来源：
   - `com.google.android.material.datepicker.n.onStart`（Material Components 1.7.0）
   - `io.flutter.plugin.platform.PlatformPlugin.setSystemChromeSystemUIOverlayStyle`（Flutter 引擎）

## 根因

- Android 主题使用遗留的 `Theme.Light.NoTitleBar` / `Theme.Black.NoTitleBar`。
- MainActivity 未调用 `enableEdgeToEdge()`。
- Flutter 层未设置 `SystemUiMode.edgeToEdge` 和透明系统栏。
- Material Components 1.7.0 和 activity 1.8.1 版本过低。

## 方案架构（三层 SSOT）

```
层                     生命周期                    职责
Android XML 主题       进程启动 -> onCreate        闪屏期间窗口背景色与主题基类
enableEdgeToEdge()     onCreate() 一次性调用       原生窗口 edge-to-edge（API 感知）
Flutter 初始化          main() -> 首帧              SystemUiMode + 透明栏引导
AppBarTheme            Widget 生命周期             状态栏/导航栏图标亮度随主题切换
```

## 变更清单

| # | 文件 | 变更 |
|---|------|------|
| 1 | `values/styles.xml` | `Theme.Light.NoTitleBar` -> `Theme.Material3.Light.NoActionBar` |
| 2 | `values-night/styles.xml` | `Theme.Black.NoTitleBar` -> `Theme.Material3.Dark.NoActionBar` |
| 3 | `MainActivity.kt` | `FlutterActivity` -> `FlutterFragmentActivity` + `enableEdgeToEdge()` |
| 4 | `build.gradle` | 添加 `activity-ktx:1.10.1` + `material:1.12.0` |
| 5 | `main.dart` | `SystemUiMode.edgeToEdge` + 透明系统栏覆盖 |
| 6 | `app_theme.dart` | `AppBarTheme.systemOverlayStyle` 透明栏 + 自适应图标亮度 |
| 7 | `cat_detail_screen.dart` | 显式透明 `SystemUiOverlayStyle` 替代预设常量 |

## 上游限制

- Flutter 引擎 `PlatformPlugin` 内部仍调用已弃用的 `Window.setStatusBarColor()` -- 通过透明色参数缓解。
- Material datepicker 的弃用调用在 Material Components >= 1.12.0 中已修复。
- 两项均为 Play Console 推荐操作（非阻塞）。

## 状态：已完成
