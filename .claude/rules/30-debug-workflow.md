# Android 真机调试工作流

> 本文件定义 Claude Code 如何使用 `scripts/adb-debug.sh` 进行设备调试闭环。

## 常量

- ADB 路径：`/opt/homebrew/share/android-commandlinetools/platform-tools/adb`
- 包名：`com.hachimi.hachimi_app`
- 日志文件：`/tmp/hachimi-logcat.log`

## 可用命令

| 命令 | 用途 | 典型场景 |
|------|------|----------|
| `scripts/adb-debug.sh status` | 检查设备连接和 App 运行状态 | 调试开始前 |
| `scripts/adb-debug.sh logs` | 日志快照（最近 500 行） | 查看完整上下文 |
| `scripts/adb-debug.sh errors` | 仅错误和异常 | **最常用** — 快速定位问题 |
| `scripts/adb-debug.sh crash` | 最近一次崩溃堆栈 | App 闪退时 |
| `scripts/adb-debug.sh clear` | 清空日志缓冲区 | 测试前重置 |
| `scripts/adb-debug.sh start-bg` | 启动后台日志收集 | 长时间调试 |
| `scripts/adb-debug.sh stop-bg` | 停止后台日志收集 | 结束调试 |
| `scripts/adb-debug.sh install` | 安装 debug APK | Build-Install 模式 |
| `scripts/adb-debug.sh screenshot` | 截取设备屏幕 | UI 问题确认 |

### 常用参数

- `--lines N`：返回行数（默认 500）
- `--level W|E|F`：最低日志级别（W=Warning，E=Error，F=Fatal）
- `--tag TAG`：按模块标签过滤（如 `FocusTimer`、`DiaryService`）
- `--since "MM-DD HH:MM:SS"`：时间过滤

## 标准调试循环

```
1. scripts/adb-debug.sh status       ← 确认设备已连接、App 在运行
2. scripts/adb-debug.sh clear        ← 清空旧日志
3. [用户在设备上触发 Bug]
4. scripts/adb-debug.sh errors       ← 读取错误
5. [分析错误 → 修改代码]
6. [用户按 r 热重载 / 或重新 build]
7. scripts/adb-debug.sh errors       ← 验证修复
8. 重复 5-7 直到无错误
```

## 两种部署模式

### Hot Reload 模式（推荐，快速迭代）

用户在独立终端运行 `flutter run`，Claude 在这边修改代码后：
- 用户在 flutter run 终端按 `r` 热重载
- Claude 运行 `scripts/adb-debug.sh errors` 检查结果

### Build-Install 模式（结构性变更）

当热重载不够时（新增依赖、修改 native 代码、改 AndroidManifest）：
```bash
flutter build apk --debug && scripts/adb-debug.sh install
```

## 错误模式识别

### App 自定义错误格式
项目使用 `[模块名]` 前缀的结构化日志：
- `[STARTUP]` — 启动流程
- `[FocusTimer]` — 专注计时器
- `[DiaryService]` — 日记生成
- `[ChatService]` — 聊天功能
- `[CatDetail]` — 猫咪详情
- `[REMINDER]` — 提醒通知
- `[FirebaseAiProvider]` — AI 功能

### Flutter 框架错误
- `══╡ EXCEPTION CAUGHT` — Flutter 框架捕获的异常（包含完整 widget 树）
- `E/flutter` — Flutter 引擎级错误

### Native 崩溃
- `FATAL EXCEPTION` — Android Runtime 致命异常
- `signal 11 (SIGSEGV)` — 段错误（通常是 native 插件问题）
- `ANR` — 应用无响应

## 注意事项

- 日志读取使用 `adb logcat -d`（dump 模式），不会阻塞
- App 未运行时，日志过滤退化为标签模式，覆盖面较窄
- 后台日志文件超过 5MB 会自动清空
- vivo 设备安装 APK 需要 `-r -t -d` 参数（脚本已内置）
