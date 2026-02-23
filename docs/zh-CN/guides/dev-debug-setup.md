# 开发调试环境启动指南

> **目的：** 连接物理 Android 设备、启动调试会话的完整操作流程。
> **适用范围：** macOS 本地开发。测试机型：vivo V2405A（Android 16，API 36）。
> **状态：** 有效
> **证据来源：** `CLAUDE.md` 命令章节、`firestore.rules`、调试会话日志（2026-02-19）
> **相关文档：** [development-workflow.md](development-workflow.md) · [firebase/security-rules.md](../firebase/security-rules.md) · [release/process.md](../release/process.md)
> **Changelog：** 2026-02-19 — 首次创建，整合首次调试会话的经验

---

## 前置条件

| 依赖项 | 版本要求 | 备注 |
|--------|---------|------|
| Flutter | 3.41.x stable | `flutter --version` |
| Dart | 3.11.x | 随 Flutter 捆绑 |
| Android SDK | 任意 | 路径：`/opt/homebrew/share/android-commandlinetools` |
| ADB | 任意 | `adb version` |
| Firebase CLI | 任意 | `firebase --version` |
| JDK | OpenJDK 17 | JDK 25 与 Gradle 8.x 不兼容 |

---

## 第一步 — 连接设备

1. 在 vivo 设备上开启 **USB 调试**：设置 → 开发者选项 → USB 调试。
2. 通过 USB 数据线连接电脑。
3. 确认 ADB 识别到设备：

```bash
adb devices
# 期望输出：<serial>  device
```

如果设备显示 `unauthorized`，解锁屏幕后在手机上点击"允许 USB 调试"对话框中的 **允许**。

---

## 第二步 — 验证 Firebase 登录凭证

启动 App 前，确认 Firebase CLI 凭证有效：

```bash
firebase projects:list
```

如果看到 `Authentication Error: Your credentials are no longer valid`，重新认证：

```bash
firebase login --reauth
```

浏览器会自动打开 Google 登录页面，完成授权后返回终端即可。

> **为什么要提前检查：** 凭证过期只在执行部署或 Firebase 命令时才会报错，不影响 Flutter App 本身运行，但调试过程中若需要修复 Firestore 规则，就必须有有效凭证。

---

## 第三步 — 启动调试会话

```bash
flutter run --device-id <adb-serial>
```

将 `<adb-serial>` 替换为 `adb devices` 输出的设备序列号。

Flutter 执行流程：
1. 解析 Dart 依赖（`flutter pub get`）
2. 通过 Gradle 执行 `assembleDebug`（热缓存约 10–15 秒）
3. 安装 APK 到设备
4. 连接 Dart VM，打印热重载快捷键说明

### 成功时的输出示例

```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
d Detach（终止 flutter run，但保留 App 运行）
q Quit（终止设备上的应用）

A Dart VM Service on <设备> is available at: http://127.0.0.1:<端口>/...
```

---

## 故障排查：安装失败

### `INSTALL_FAILED_ABORTED: User rejected permissions`

**原因：** vivo 系统弹出了"允许通过电脑安装应用"的对话框，被误关或超时消失。

**修复步骤：**
1. 解锁手机屏幕。
2. 留意系统弹出的 USB 安装确认框，点击 **允许**。
3. 重新执行安装：

```bash
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

如果对话框未弹出，先禁用包验证器：

```bash
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

### `flutter run` 失败但 APK 构建成功

手动构建 APK，再单独安装并启动：

```bash
flutter build apk --debug
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.hachimi.hachimi_app/.MainActivity
```

---

## 故障排查：运行时错误

### 某个页面出现 `[cloud_firestore/permission-denied]`

**原因：** 该页面访问的 Firestore 子集合在 `firestore.rules` 中没有对应规则。Firestore 默认拒绝未覆盖的路径——App 能正常编译运行，但受影响的 Widget 会抛出异常。其他不访问该集合的页面不受影响。

**诊断：** 在 logcat 输出中查找如下日志：
```
W/Firestore: Listen for Query(target=Query(users/.../集合名称/...)) failed: PERMISSION_DENIED
```

记录 `集合名称`，打开 `firestore.rules`，确认 `match /users/{userId}` 下是否有对应的 `match /集合名称/{id}` 规则。

**修复步骤：**
1. 在 `firestore.rules` 中补充缺失的规则。
2. 同步更新本文档和 [firebase/security-rules.md](../firebase/security-rules.md)（EN + zh-CN）。
3. 部署规则：

```bash
firebase deploy --only firestore:rules --project hachimi-ai
```

完整的新增集合检查清单见 [security-rules.md — 已知陷阱](../firebase/security-rules.md#已知陷阱)。

**实际案例（2026-02-19）：**
- `CheckInBanner`（Today 页面）通过 `CoinService` 访问 `users/{uid}/monthlyCheckIns/{yyyy-MM}`
- `firestore.rules` 中只有 `checkIns` 的规则，缺少 `monthlyCheckIns`
- 修复：补充规则后重新部署，错误消失

### logcat 显示 `Firestore UNAVAILABLE` / `Channel shutdownNow`

**原因：** VPN 或代理干扰了 gRPC 长连接。这不是代码 Bug，Firestore 在网络恢复后会自动重连。

**修复：** 关闭 VPN/代理，或等待 Firestore 自动重连。

---

## 可忽略的 logcat 噪音

以下日志在每次运行时都会出现，均为正常现象：

| 日志 Tag | 消息内容 | 可忽略原因 |
|---------|---------|---------|
| `SurfaceComposerClient` | `Transaction::setDataspace: 142671872` | Android 渲染管线，高频正常输出 |
| `GoogleApiManager` | `Failed to get service from broker` | vivo 设备上 GMS 版本差异，不影响 Firebase Auth 和 Firestore |
| `FlagRegistrar` | `Phenotype.API is not available on this device` | Google 功能标志服务在此设备不可用 |
| `ProviderInstaller` | `Failed to load providerinstaller module` | 回退使用 Conscrypt，TLS 仍然正常工作 |

---

## Changelog

| 日期 | 变更内容 |
|------|---------|
| 2026-02-19 | 首次创建；整合 vivo 安装流程和 Firestore permission-denied 诊断经验 |
