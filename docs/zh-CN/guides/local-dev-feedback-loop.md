# 本地开发反馈闭环

> **目的：** 指导如何搭建快速的本地开发反馈闭环 — 从环境选择到调试策略，让问题在秒级被发现，而不是等待 CI。
> **范围：** 所有参与 Hachimi 开发的开发者，无论平台（macOS / Windows / Linux）。
> **状态：** 活跃
> **证据：** Flutter CLI、`CLAUDE.md` 命令章节、`development-workflow.md`、`dev-debug-setup.md`
> **关联：** [development-workflow.md](development-workflow.md) · [dev-debug-setup.md](dev-debug-setup.md) · [release/process.md](../release/process.md)
> **变更日志：** 2026-03-10 — 初始版本；文档化反馈层级模型、环境要求、Riverpod 调试

---

## 问题：仅依赖 CI 的反馈环路

如果你测试变更的唯一方式是推送到 CI、等待构建、下载 APK、手动安装 — 每轮迭代需要 15–25 分钟。大多数问题（编译错误、运行时 Bug、状态管理失误）可以在本地 **秒级** 发现。

---

## 反馈层级模型

高效的 Flutter 开发采用分层策略。每层比下一层更快，且捕获不同类别的问题。

```
┌──────────────────────────────────────────────────────────┐
│  第 1 层：静态分析（即时，0 秒）                           │
│    IDE 红线 + dart analyze                               │
│    捕获：类型错误、未使用导入、Lint 违规                    │
├──────────────────────────────────────────────────────────┤
│  第 2 层：Hot Reload（1–2 秒）                            │
│    修改 UI / 状态 → Ctrl+S → 设备即时刷新                 │
│    捕获：布局 Bug、样式问题、Widget 逻辑                   │
├──────────────────────────────────────────────────────────┤
│  第 3 层：Hot Restart（3–5 秒）                           │
│    结构性变更 → 完整 Dart 重启，保留安装                   │
│    捕获：初始化 Bug、路由变更                              │
├──────────────────────────────────────────────────────────┤
│  第 4 层：Debug 断点调试（实时）                           │
│    单步执行、变量检查、Provider 监控                       │
│    捕获：逻辑错误、竞态条件、状态 Bug                      │
├──────────────────────────────────────────────────────────┤
│  第 5 层：自动化测试（10–30 秒）                          │
│    flutter test → 单元 + Widget 测试                     │
│    捕获：回归、边界情况、契约违规                          │
├──────────────────────────────────────────────────────────┤
│  第 6 层：CI（8–10 分钟，最后防线）                        │
│    推送 → GitHub Actions → 最终验证                      │
│    捕获：环境特定问题、发布签名                            │
└──────────────────────────────────────────────────────────┘
```

**关键洞察：** 如果你只有第 1 层和第 6 层，你就错过了最高效的第 2–5 层。一台本地电脑加一个连接的设备就能解锁全部六层。

---

## 环境要求

### 高效开发的最低配置

| 要求 | 原因 |
|---|---|
| **本地电脑**（非无头云服务器） | 模拟器、DevTools、IDE 调试都需要 GUI |
| **8+ GB 内存**（建议 16 GB） | Android 模拟器 + IDE + Gradle 守护进程同时运行 |
| **4+ CPU 核心** | Gradle 并行任务、后台分析 |
| **KVM / 虚拟化支持** | Android 模拟器硬件加速（Intel VT-x / AMD-V / Apple Silicon） |
| **USB 接口或 WiFi ADB** | 物理设备连接，支持第 2–4 层 |

### 平台对比

| | macOS（推荐） | Windows | Linux | 云服务器 |
|---|---|---|---|---|
| Android 开发 | 完整 | 完整 | 完整 | 仅静态分析 |
| iOS 开发 | 完整 | 不可能 | 不可能 | 不可能 |
| 模拟器性能 | Apple Silicon 原生 ARM | 较好（HAXM/WHPX） | 较好（KVM） | 无 KVM = 无模拟器 |
| Hot Reload | 支持 | 支持 | 支持 | 无法连接设备 |
| 断点调试 | 支持 | 支持 | 支持 | 不可能 |
| DevTools | 完整 GUI | 完整 GUI | 完整 GUI | 无 GUI |

### 云服务器的适用场景

- 运行 Claude Code 进行 AI 辅助开发
- 运行 `dart analyze` 和 `dart format` 作为推送前检查
- Git 操作和 CI 监控（`gh run watch`）
- 代码审查和文档工作

**但不要将其作为 Flutter 应用的主要开发环境。**

---

## 设备配置

### 方案 A：物理真机（推荐）

真机提供最准确的反馈 — 真实性能、真实手势、真实传感器。

```bash
# USB 连接
adb devices                  # 确认设备已列出

# WiFi 调试（Android 11+，USB 不方便时使用）
adb pair <ip>:<port>         # 一次性配对
adb connect <ip>:<port>      # 连接

# vivo 专用解决方案（flutter run 安装失败时）
adb shell settings put global package_verifier_enable 0
```

### 方案 B：Android 模拟器

作为辅助设备或无物理设备时使用。

```bash
# 创建（通过 Android Studio 设备管理器，或命令行）
avdmanager create avd -n pixel7 -k "system-images;android-34;google_apis;arm64-v8a"

# 启动
emulator -avd pixel7

# 验证
flutter devices              # 应列出模拟器和所有物理设备
```

---

## 调试策略

### Riverpod Provider 观察器

在调试模式添加 Provider 观察器，追踪所有状态变更。对诊断"数据不刷新"问题尤其有用。

```dart
// 在 main.dart 中
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

登录后可以立即看到哪些 Provider 刷新了、哪些没有 — 无需猜测。

### 认证生命周期的定向日志

```dart
// 认证相关问题的关键观测点：
debugPrint('[AUTH] finalizeSetup: linkMode=$linkMode, mounted=$mounted');
debugPrint('[SYNC] hydrate complete, emitting LedgerChange(hydrate)');
debugPrint('[GATE] checkedFirstHabit=$_checkedFirstHabit, isHydrated=$isHydrated');
debugPrint('[PROVIDER] habitsProvider received change: ${change.type}');
```

### 断点调试（VS Code）

1. 点击行号左侧设置断点
2. 按 F5 以调试模式启动
3. 断点命中时检查：
   - **变量** 面板中的局部变量
   - **调用堆栈** 面板中的调用链
   - **调试控制台** 中实时执行表达式

这是诊断竞态条件或分支逻辑错误的最快方式。

### Flutter DevTools

```bash
flutter run    # 启动时打印 DevTools 地址
# 浏览器打开 http://127.0.0.1:9100
```

| 工具 | 适用场景 |
|---|---|
| Widget Inspector | 布局调试、溢出、约束问题 |
| Performance | 帧耗时、卡顿检测 |
| Memory | 泄漏检测、内存分配追踪 |
| Network | HTTP / Firestore 请求检查 |
| Logging | 结构化日志查看与过滤 |

---

## 推送前检查清单

推送到 CI 之前，在本地运行以下命令，避免浪费 CI 资源：

```bash
# 1. 静态分析（捕获类型错误、Lint 问题）
dart analyze lib/

# 2. 格式检查（CI 强制 --set-exit-if-changed）
dart format lib/ test/

# 3. 测试（捕获回归）
flutter test

# 4. 版本一致性验证（发布时）
# pubspec.yaml 版本必须与计划创建的 tag 一致
```

如果本地全部通过，CI 也应该通过。CI 特有的步骤仅包括发布签名、AAB 构建和 Play Store 上传。

---

## 推荐的日常工作流

```
1. 打开 VS Code + 连接设备（USB 或模拟器）
2. F5 或 flutter run --dart-define-from-file=.env
3. 修改代码 → Ctrl+S → Hot Reload（1 秒）
4. 遇到 Bug → 设置断点 → F5 调试 → 检查变量
5. 修复确认 → flutter test（30 秒）
6. dart analyze lib/ && dart format lib/ test/
7. git commit → git push → CI 验证（最后防线）
```

每轮迭代总反馈时间：**1–30 秒**（对比仅用 CI 的 15–25 分钟）。

---

## 变更日志

| 日期 | 变更 |
|---|---|
| 2026-03-10 | 初始版本 — 反馈层级模型、环境要求、Riverpod 调试、推送前检查清单 |
