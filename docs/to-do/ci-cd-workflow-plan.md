# Flutter CI/CD 工作流优化计划

> **Status**: Draft
> **Created**: 2026-02-19
> **Purpose**: 规划远程开发服务器 + 真机测试 + 分层 CI/CD 的完整开发流程

---

## 一、背景与动机

### 当前痛点

1. 本地电脑配置不高，`flutter build apk` 等操作较慢
2. 大部分开发通过手机 SSH 连接服务器运行 Claude Code，不需要守在电脑前
3. 目前只有 tag-triggered 的 release workflow（`.github/workflows/release.yml`），没有开发阶段的快速迭代流程
4. 每次功能开发完如果都走 GitHub Actions 构建 APK，等待时间过长（10-15 分钟）

### 目标

- 将代码库迁移到开发服务器，在服务器上完成 **编码 + 分析 + 构建**
- 建立 **分层 CI/CD 策略**：日常开发在服务器快速迭代，GitHub Actions 只负责质量门禁和正式发布
- 让 Claude Code 在开发过程中能获取真机日志，形成完整的 debug 闭环

---

## 二、整体架构

```
┌─────────────────────────────────────────────────────────────┐
│  手机 SSH                                                    │
│   └─→ 远程开发服务器                                         │
│         ├─ Claude Code（代码开发）                            │
│         ├─ dart analyze lib/（静态分析，约 10 秒）             │
│         ├─ flutter test（单元测试，约 30 秒）                  │
│         └─ flutter build apk --debug（构建，约 2-4 分钟）      │
│              └─→ HTTP 下载 / SCP → 手机安装测试               │
│                                                             │
│  日志回传：ADB 远程 / 日志文件 / 应用内日志                    │
│   └─→ Claude Code 读取日志 → 继续修 bug / 迭代               │
└─────────────────────────────────────────────────────────────┘
                          ↓ 功能完成
┌─────────────────────────────────────────────────────────────┐
│  git push → GitHub Actions                                  │
│   ├─ Code Quality Check（push/PR 触发，2-3 分钟）             │
│   └─ Build & Release APK（tag 触发，10-15 分钟）              │
└─────────────────────────────────────────────────────────────┘
```

---

## 三、开发服务器环境搭建

### 3.1 必装组件

| 组件 | 版本 | 用途 |
|------|------|------|
| Flutter SDK | 3.41.x stable | Dart 分析、测试、构建 |
| Dart SDK | 3.11.x | 随 Flutter 安装 |
| OpenJDK | 17 | Android Gradle 构建（JDK 25 不兼容） |
| Android SDK | Command-line tools | 构建 APK（不需要模拟器镜像） |
| Android SDK Build-Tools | 最新稳定版 | APK 打包签名 |
| Android SDK Platform | API 36 | 目标平台编译 |
| Git | 最新 | 版本控制 |
| Claude Code | 最新 | AI 辅助开发 |
| Python 3 | 任意 | 临时 HTTP 服务器（分发 APK） |

### 3.2 安装步骤（Linux 服务器）

```bash
# 1. 安装 JDK 17
sudo apt install openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# 2. 安装 Flutter
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$HOME/flutter/bin:$PATH"
flutter doctor

# 3. 安装 Android SDK（无需 Android Studio）
mkdir -p ~/android-sdk/cmdline-tools
cd ~/android-sdk/cmdline-tools
# 下载 command-line tools 并解压
# https://developer.android.com/studio#command-line-tools-only
# 解压后重命名为 latest/
mv cmdline-tools latest

export ANDROID_HOME=$HOME/android-sdk
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# 4. 安装必要的 SDK 组件
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.0.0"
sdkmanager --licenses

# 5. 验证
flutter doctor -v
```

### 3.3 项目初始化

```bash
# 克隆代码库
git clone <repo-url> ~/projects/hachimi-app
cd ~/projects/hachimi-app

# 安装依赖
flutter pub get

# 设置 LLM vendor
bash scripts/setup_llm_vendor.sh

# 恢复 Firebase 配置文件（从安全存储中复制）
# - lib/firebase_options.dart
# - android/app/google-services.json

# 恢复签名配置（如果需要 release 构建）
# - android/key.properties
# - android/app/hachimi-release.jks

# 验证构建环境
dart analyze lib/
flutter test
flutter build apk --debug
```

### 3.4 注意事项

- **不需要安装模拟器**：服务器通常没有 KVM 虚拟化，也不需要 GUI
- **不需要 Android Studio**：只需要 command-line tools
- **Firebase 配置文件**是 gitignored 的，需要手动复制到服务器
- **JDK 版本必须是 17**：JDK 25 与 Gradle 8.x 不兼容（见 `CLAUDE.md`）

---

## 四、测试策略

### 4.1 模拟器 vs 真机

**结论：以真机测试为主。**

| 项目功能 | 模拟器 | 真机 | 推荐 |
|----------|--------|------|------|
| UI 布局验证 | 可用 | 可用 | 都行 |
| Firebase Auth / Firestore | 网络不稳定 | 正常 | 真机 |
| llama_cpp_dart 本地 LLM 推理 | 极慢，无 NPU | 正常 | 真机 |
| flutter_local_notifications | 行为不一致 | 正常 | 真机 |
| flutter_foreground_task | 部分不工作 | 正常 | 真机 |
| 像素猫动画渲染性能 | 不代表真实 | 真实 | 真机 |
| 传感器、相机等硬件功能 | 模拟 | 真实 | 真机 |

### 4.2 测试分层

```
┌─────────────────────────────────────────┐
│  第 1 层：静态分析（每次改动）             │
│  dart analyze lib/                      │
│  耗时：约 10 秒                          │
└─────────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│  第 2 层：单元测试（每次改动）             │
│  flutter test                           │
│  耗时：约 30 秒                          │
│  覆盖：models、services、utils           │
└─────────────────────────────────────────┘
               ↓
┌─────────────────────────────────────────┐
│  第 3 层：真机测试（需要验证 UI/功能时）   │
│  构建 debug APK → 安装到 vivo V2405A    │
│  耗时：构建 2-4 分钟 + 手动测试           │
│  覆盖：完整功能、性能、Firebase 交互       │
└─────────────────────────────────────────┘
```

---

## 五、日志获取方案

### 目标

让 Claude Code 在服务器上能读取真机运行时的日志，形成完整的 debug 闭环。

### 方案 A：ADB 远程连接（实时调试，推荐）

适用场景：电脑和真机在同一网络，且电脑可以 SSH 连接到服务器。

```bash
# 步骤 1：在电脑上，USB 连接真机后开启 TCP 模式
adb tcpip 5555
adb connect <手机 IP>:5555
# 验证连接
adb devices

# 步骤 2：从服务器通过 SSH 隧道转发 ADB 端口
# 在服务器上执行（将服务器的 5037 端口映射到电脑的 5037）
ssh -L 5037:localhost:5037 <电脑用户名>@<电脑 IP>

# 步骤 3：Claude Code 在服务器上直接使用 ADB
adb logcat -s flutter                    # Flutter 日志
adb logcat -s flutter,FirebaseAuth       # 过滤多个 tag
adb logcat --pid=$(adb shell pidof com.hachimi.hachimi_app)  # 只看本应用
adb install build/app/outputs/flutter-apk/app-debug.apk     # 直接装 APK
```

### 方案 B：日志文件持续捕获

适用场景：不方便做 ADB 端口转发时，将日志持续写到服务器文件。

```bash
# 在有 ADB 连接的电脑上运行（后台）
adb logcat -s flutter | ssh <服务器用户名>@<服务器 IP> \
  "cat > ~/hachimi-logs/$(date +%Y%m%d_%H%M).log" &

# Claude Code 在服务器上读取日志文件
tail -100 ~/hachimi-logs/latest.log
```

### 方案 C：应用内文件日志（最简单）

适用场景：不依赖 ADB 连接，app 自己把日志写到设备文件，测试完后拉取。

```dart
// 在 app 中添加简单的文件日志
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static File? _logFile;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File('${dir.path}/debug.log');
    // 每次启动清空旧日志
    await _logFile!.writeAsString(
      '=== Session ${DateTime.now()} ===\n',
    );
  }

  static Future<void> log(String tag, String message) async {
    final line = '${DateTime.now()} [$tag] $message\n';
    await _logFile?.writeAsString(line, mode: FileMode.append);
  }
}
```

测试完后拉取日志：

```bash
adb pull /data/data/com.hachimi.hachimi_app/app_flutter/debug.log ./
# 然后 scp 到服务器，Claude Code 即可读取
scp debug.log <服务器>:~/hachimi-logs/
```

### 方案对比

| 方案 | 实时性 | 配置难度 | 依赖 | 推荐场景 |
|------|--------|---------|------|---------|
| A. ADB 远程 | 实时 | 中等 | SSH 隧道 + ADB | 日常开发调试 |
| B. 日志文件 | 准实时 | 简单 | SSH + ADB | 长时间运行测试 |
| C. 应用内日志 | 事后 | 最简单 | 仅 ADB pull | 无网络时、初期过渡 |

---

## 六、分层 CI/CD 策略

### 6.1 第一层：日常开发（服务器本地，5-10 分钟一轮）

**目的**：快速迭代，不经过 GitHub。

```bash
# Claude Code 完成代码修改后：
dart analyze lib/                    # 10 秒
flutter test                         # 30 秒
flutter build apk --debug            # 2-4 分钟

# APK 分发到手机
# 方式 1：临时 HTTP 服务器
cd build/app/outputs/flutter-apk/
python3 -m http.server 8080
# 手机浏览器访问 http://<服务器 IP>:8080/app-debug.apk

# 方式 2：ADB 直接安装（如果配置了远程 ADB）
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

### 6.2 第二层：代码质量门禁（GitHub Actions，push/PR 触发）

**目的**：每次 push 自动检查代码质量，不构建 APK。

**当前状态**：缺失，需要新建。

建议新建 `.github/workflows/check.yml`：

```yaml
name: Code Quality Check

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.1'
          channel: 'stable'
          cache: true

      - name: Decode Firebase config (for compilation)
        run: |
          echo "${{ secrets.GOOGLE_SERVICES_JSON }}" | base64 --decode > android/app/google-services.json
          echo "${{ secrets.FIREBASE_OPTIONS_DART }}" | base64 --decode > lib/firebase_options.dart

      - name: Create empty asset directories
        run: mkdir -p assets/sprites assets/room

      - run: flutter pub get
      - run: bash scripts/setup_llm_vendor.sh
      - run: dart analyze lib/
      - run: flutter test
```

**预计耗时**：2-3 分钟（不构建 APK，只分析和测试）。

### 6.3 第三层：正式发布（GitHub Actions，tag 触发）

**当前状态**：已有，即 `.github/workflows/release.yml`。

**触发方式**：

```bash
# 1. 修改 pubspec.yaml 版本号
# 2. 提交
git add pubspec.yaml
git commit -m "chore: bump version to X.Y.Z+N"

# 3. 打 tag 并推送
git tag vX.Y.Z
git push && git push --tags

# 4. GitHub Actions 自动构建 release APK 并发布到 GitHub Releases
```

**预计耗时**：10-15 分钟（自动完成，不需要等待）。

### 各层对比

| 层级 | 触发方式 | 在哪里跑 | 耗时 | 产出 | 频率 |
|------|---------|---------|------|------|------|
| 日常开发 | 手动 | 服务器本地 | 2-4 分钟 | debug APK | 每次改动 |
| 质量门禁 | push / PR | GitHub Actions | 2-3 分钟 | 通过/失败 | 每次 push |
| 正式发布 | git tag | GitHub Actions | 10-15 分钟 | release APK | 每个版本 |

---

## 七、开发构建脚本

建议新建 `scripts/dev-build.sh`，一键完成分析 + 测试 + 构建 + 分发：

```bash
#!/bin/bash
# ---
# 开发阶段一键构建脚本
# 用法：bash scripts/dev-build.sh [--skip-test] [--serve]
# ---

set -e

SKIP_TEST=false
SERVE=false
PORT=8080

for arg in "$@"; do
  case $arg in
    --skip-test) SKIP_TEST=true ;;
    --serve) SERVE=true ;;
    --port=*) PORT="${arg#*=}" ;;
  esac
done

echo "=== [1/4] Static Analysis ==="
dart analyze lib/

if [ "$SKIP_TEST" = false ]; then
  echo "=== [2/4] Running Tests ==="
  flutter test
else
  echo "=== [2/4] Tests Skipped ==="
fi

echo "=== [3/4] Building Debug APK ==="
flutter build apk --debug

APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
APK_SIZE=$(du -h "$APK_PATH" | cut -f1)

echo "=== [4/4] Build Complete ==="
echo "  APK: $APK_PATH"
echo "  Size: $APK_SIZE"

if [ "$SERVE" = true ]; then
  echo ""
  echo "  Download URL: http://$(hostname -I | awk '{print $1}'):$PORT/app-debug.apk"
  echo "  Press Ctrl+C to stop serving."
  cd build/app/outputs/flutter-apk/
  python3 -m http.server "$PORT"
fi
```

---

## 八、完整工作流（日常开发）

```
你的手机
  │
  ├─ SSH 连接 → 远程服务器
  │               ├─ Claude Code 写代码
  │               ├─ dart analyze lib/（实时检查）
  │               ├─ flutter test（单元测试）
  │               └─ bash scripts/dev-build.sh --serve
  │                        ↓ 构建完成，启动 HTTP 服务
  │
  ├─ 手机浏览器下载 APK → 安装到手机
  │
  ├─ 手动测试 app → 发现问题
  │
  ├─ 日志回传（方案 A/B/C）→ Claude Code 读取
  │
  └─ Claude Code 修 bug → 重新构建 → 循环

  功能完成后：
  ├─ git push → GitHub Actions 质量门禁（自动）
  └─ git tag → GitHub Actions 构建 release APK（自动）
```

---

## 九、待办事项清单

### 服务器环境搭建

- [ ] 选择开发服务器（云服务器 / 自建）
- [ ] 安装 Flutter SDK 3.41.x
- [ ] 安装 OpenJDK 17
- [ ] 安装 Android SDK command-line tools
- [ ] 安装 Claude Code
- [ ] 克隆代码库到服务器
- [ ] 复制 Firebase 配置文件到服务器
- [ ] 运行 `flutter doctor` 验证环境
- [ ] 运行 `flutter build apk --debug` 验证构建

### CI/CD 流程

- [ ] 新建 `.github/workflows/check.yml`（质量门禁 workflow）
- [ ] 新建 `scripts/dev-build.sh`（开发阶段一键构建脚本）
- [ ] 测试 HTTP 服务器 APK 分发流程
- [ ] 确认 GitHub Actions secrets 在新环境中可用

### 日志方案

- [ ] 选择日志获取方案（A / B / C）
- [ ] 如果选方案 A：配置 ADB TCP 和 SSH 隧道
- [ ] 如果选方案 C：在 app 中添加 FileLogger 工具类
- [ ] 验证 Claude Code 能成功读取日志

### 签名与安全

- [ ] 将 keystore 安全备份到新服务器（不提交到 git）
- [ ] 在新服务器创建 `android/key.properties`
- [ ] 验证 release 构建在新服务器可用（可选）

---

## 十、相关文档

| 文档 | 位置 |
|------|------|
| 发布流程 SSOT | `docs/release/process.md` |
| Release Workflow | `.github/workflows/release.yml` |
| LLM Vendor 安装脚本 | `scripts/setup_llm_vendor.sh` |
| 签名配置脚本 | `scripts/setup-release-signing.sh` |
| 版本检查脚本 | `scripts/pre-commit-version-check.sh` |
| 项目规则 | `CLAUDE.md` |
