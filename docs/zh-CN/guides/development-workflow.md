# 开发工作流

> **目的：** 说明日常开发循环——构建模式、热重载、调试工具及各命令的适用场景。
> **适用范围：** 任意平台的本地开发。适用于物理设备和模拟器。
> **状态：** 有效
> **证据来源：** Flutter CLI（`flutter run --help`）、Gradle 配置（`android/gradle.properties`）、`CLAUDE.md` 命令章节
> **相关文档：** [dev-debug-setup.md](dev-debug-setup.md) · [release/process.md](../release/process.md) · [CONTRIBUTING.md](../CONTRIBUTING.md)
> **Changelog：** 2026-02-23 — 首次创建；整理热重载工作流与构建模式差异

---

## 构建模式

Flutter 有两种主要构建模式。理解它们的区别是高效开发的前提。

| | Debug（调试） | Release（发布） |
|---|---|---|
| **编译方式** | JIT（即时编译）——代码在设备上动态编译 | AOT（提前编译）——编译为原生 ARM 代码 |
| **热重载** | 支持 | 不支持 |
| **断言** | 生效（`assert()` 会执行） | 移除 |
| **DevTools** | 完整可用（Widget 检查器、性能面板、内存分析） | 不可用 |
| **运行性能** | 较慢——JIT 开销，无 Tree Shaking | 最优——原生代码，死代码消除 |
| **包体积** | 较大——包含 JIT 编译器和调试元数据 | 较小——已压缩优化 |
| **R8 混淆** | 关闭 | 开启（`minifyEnabled true` + `shrinkResources true`） |
| **典型构建耗时** | 30–90 秒（首次启动） | 10–17 分钟 |

**原则：** 日常开发全程使用 Debug 模式。Release 模式仅用于 CI/CD 发布或验证生产环境行为。

---

## 热重载与热重启

热重载（Hot Reload）和热重启（Hot Restart）是 Flutter 开发体验的核心。它们替代了传统的"编辑 → 构建 → 安装 → 启动"循环，提供近乎即时的反馈。

### 热重载（Hot Reload）

热重载将更新后的 Dart 源代码注入正在运行的 Dart VM，**无需重启 App**。App 保持当前状态——导航栈、表单输入、滚动位置、动画进度均不受影响。

**速度：** 从保存到看到变化 200–800 毫秒。

**触发方式：** 在 `flutter run` 终端中按 `r`。

**热重载可以处理的变更：**
- 修改 Widget 的 `build()` 方法（布局、样式、文案）
- 修改已有方法中的业务逻辑
- 在已有类中添加新方法或新字段
- 更新字符串字面量、颜色、间距、字体
- 修改默认参数值

### 热重启（Hot Restart）

热重启重新编译所有 Dart 代码，并从 `main()` 重新启动 App。App 状态会丢失，但不会重新编译原生代码。

**速度：** 2–5 秒。

**触发方式：** 在 `flutter run` 终端中按 `R`（大写）。

**需要热重启而非热重载的场景：**
- 添加、删除或重命名类
- 修改类继承关系
- 修改泛型类型参数
- 修改枚举值
- 修改 `static` 字段或初始化器
- 修改 `main()` 或顶层初始化代码
- 修改 `initState()` 中的代码（代码会更新，但 `initState` 不会重新执行）

### 完全重新构建

退出 `flutter run`（按 `q`）然后重新运行。仅在以下情况需要：

- 修改了原生代码（Gradle 配置、Kotlin/Java 文件、`AndroidManifest.xml`）
- 添加或升级了包含原生代码的插件
- 修改了 `--dart-define` 的值（如 `MINIMAX_API_KEY`、`GEMINI_API_KEY`）
- 修改了 `pubspec.yaml` 中的资产声明
- 修改了 minSdkVersion 或其他 Gradle 配置

---

## 日常开发循环

```
┌──────────────────────────────────────────────────────────┐
│  1. 启动开发会话（仅一次，约 30–90 秒）                     │
│     adb shell settings put global package_verifier_enable 0
│     flutter run --dart-define-from-file=.env              │
├──────────────────────────────────────────────────────────┤
│  2. 编写代码 → 保存 → 热重载（r）→ 0.5 秒看到效果          │
│     重复 N 次                                             │
├──────────────────────────────────────────────────────────┤
│  3. 结构性变更？→ 热重启（R）→ 2–5 秒                      │
├──────────────────────────────────────────────────────────┤
│  4. 改了原生代码？→ 退出（q）→ 重新 flutter run            │
├──────────────────────────────────────────────────────────┤
│  5. 准备发布？→ git push tag → CI 自动构建 Release          │
└──────────────────────────────────────────────────────────┘
```

### 各命令适用场景

| 场景 | 命令 |
|------|------|
| 日常开发（90% 的时间） | `flutter run --dart-define-from-file=.env` |
| 验证 Release 行为 | `flutter run --release --dart-define-from-file=.env` |
| 生成 Debug APK 手动安装 | `flutter build apk --debug --dart-define-from-file=.env` |
| 生成 Release APK 用于部署 | `flutter build apk --release --dart-define-from-file=.env` |
| 生成 AAB 上传 Google Play | `flutter build appbundle --release --dart-define-from-file=.env` |

> **不要** 在开发过程中运行 `flutter build apk --release`。它耗时 10–17 分钟且不支持热重载。此命令仅用于 CI/CD 和最终验证。

---

## 日志与调试

### `flutter run` 终端输出

当 `flutter run` 运行时，所有 `print()` 和 `debugPrint()` 的输出直接显示在终端中。这是开发过程中查看 App 日志的主要方式。

### ADB logcat

在 `flutter run` 之外查看日志（例如手动安装 APK 后），使用 ADB：

```bash
# Flutter 相关日志
adb logcat -s flutter

# Firebase 相关日志
adb logcat -s FirebaseAuth,FirebaseFirestore,FirebaseMessaging

# 过滤 App 日志和错误
adb logcat | grep -iE "hachimi|error|exception"

# 清除日志缓冲区后重新开始
adb logcat -c && adb logcat -s flutter
```

### `flutter attach`

如果 App 是手动安装的（不是通过 `flutter run` 启动），仍然可以连接到正在运行的 Debug 构建：

```bash
flutter attach --dart-define-from-file=.env
```

这会重新建立与 Dart VM 的实时连接，启用热重载、热重启和日志输出——效果与 `flutter run` 启动的完全一致。

### Flutter DevTools

在 Debug 模式下运行时，`flutter run` 会打印 DevTools 的访问地址：

```
Flutter DevTools is available at: http://127.0.0.1:9100?uri=...
```

DevTools 提供以下工具：

| 工具 | 用途 |
|------|------|
| Widget 检查器 | 查看 Widget 树、布局约束、溢出调试 |
| 性能面板 | 帧渲染时间、卡顿检测 |
| 内存分析器 | 堆快照、内存分配追踪、泄漏检测 |
| 网络检查器 | HTTP 请求/响应查看 |
| CPU 分析器 | 方法级性能分析 |

---

## vivo 设备适配方案

如果在 vivo V2405A 上 `flutter run` 安装失败（`INSTALL_FAILED_ABORTED`），使用手动安装 + attach 的方式：

```bash
# 构建 Debug APK
flutter build apk --debug --dart-define-from-file=.env

# 手动安装
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk

# 连接热重载
flutter attach --dart-define-from-file=.env
```

详细诊断步骤见 [dev-debug-setup.md — 故障排查：安装失败](dev-debug-setup.md#故障排查安装失败)。

---

## Gradle 构建优化

项目的 `android/gradle.properties` 遵循 Gradle 最佳实践：

```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+UseParallelGC -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.caching=true
```

| 标志 | 作用 |
|------|------|
| `-XX:+UseParallelGC` | 并行垃圾回收——JDK 17+ 上 GC 吞吐量提升 9–20% |
| `-Dfile.encoding=UTF-8` | 防止不同环境间因编码差异导致构建缓存未命中 |
| `org.gradle.parallel=true` | 并行执行独立的子项目任务 |
| `org.gradle.caching=true` | 复用之前构建的任务输出（增量构建） |

这些标志主要受益于 `flutter run` 首次启动和 Release 全量构建。热重载完全绕过 Gradle，不受影响。

---

## Changelog

| 日期 | 变更内容 |
|------|---------|
| 2026-02-23 | 首次创建——热重载工作流、构建模式、调试工具、Gradle 优化 |
