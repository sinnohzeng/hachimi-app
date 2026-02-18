# Firebase 配置指南

本指南介绍如何从头为 Hachimi 应用配置 Firebase。请按步骤 1 至 6 的顺序操作。

---

## 环境要求

| 工具 | 安装方式 |
|------|---------|
| Flutter 3.41.x | `flutter upgrade` |
| Firebase CLI | `npm install -g firebase-tools` |
| FlutterFire CLI | `dart pub global activate flutterfire_cli` |
| JDK 17（Android） | `brew install openjdk@17`（macOS） |

验证工具：
```bash
flutter --version     # Flutter 3.41.x
firebase --version    # 13.x+
flutterfire --version # 1.x+
java -version         # openjdk 17
```

---

## 第 1 步：创建 Firebase 项目

1. 前往 [Firebase 控制台](https://console.firebase.google.com)
2. 点击 **「添加项目」**
3. 项目名称：`hachimi-ai`（或自定义名称）
4. **启用 Google Analytics（谷歌分析）** —— 选择或创建分析账号
5. 等待项目创建完成

---

## 第 2 步：配置 Flutter 应用

```bash
# 登录 Firebase
firebase login

# 为 Firebase 项目配置 Flutter 工程
# 此命令会注册 Android 和 iOS 应用并生成配置文件
flutterfire configure --project=hachimi-ai
```

此命令将：

- 在 Firebase 中注册 Android 应用（`com.hachimi.hachimi_app`）和 iOS 应用
- 下载 `android/app/google-services.json` 和 `ios/Runner/GoogleService-Info.plist`
- 生成 `lib/firebase_options.dart`

> **这些文件已加入 .gitignore** —— 切勿提交到代码仓库。每位开发者需使用自己的 Firebase 项目本地运行 `flutterfire configure` 生成这些文件。

---

## 第 3 步：启用认证

1. Firebase 控制台 → **Authentication（认证）** → 开始使用
2. **登录方式** 标签页 → 启用：
   - **电子邮件/密码** —— 开启切换
   - **Google** —— 开启切换，填写支持邮箱，保存

---

## 第 4 步：创建 Firestore 数据库

1. Firebase 控制台 → **Firestore Database（数据库）** → 创建数据库
2. 以 **生产模式** 启动（稍后第 6 步部署规则）
3. 选择最近的区域：
   - 亚洲：`asia-east1`（台湾）或 `asia-northeast1`（日本）
   - 北美：`us-central1`
   - 欧洲：`europe-west1`

> 注意：区域一经设定无法更改，请谨慎选择。

---

## 第 5 步：启用其余服务

### Firebase Analytics
- 在第 1 步连接 Google Analytics 后自动启用。
- 设备上启用 **DebugView**：
  ```bash
  adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
  ```

### Firebase Cloud Messaging（FCM，云消息推送）
- 默认启用，Android 无需额外配置。
- iOS 需上传 APNs 证书（未来工作）。

### Remote Config（远程配置）
1. Firebase 控制台 → **Remote Config** → 创建配置
2. 添加 4 个必填参数（详见 [远程配置文档](remote-config.md)）：
   - `xp_multiplier` = `1`
   - `notification_copy_variant` = `A`
   - `mood_threshold_lonely_days` = `3`
   - `default_focus_duration` = `25`
3. 点击 **发布更改**

### Crashlytics（崩溃报告）
1. Firebase 控制台 → **Crashlytics** → 开始使用
2. 启用 Crashlytics（SDK 已在 `pubspec.yaml` 中配置，无需额外操作）
3. 运行应用，强制触发测试崩溃验证：
   ```dart
   // 仅限调试版本
   FirebaseCrashlytics.instance.crash();
   ```
4. 几分钟内在 Crashlytics 控制台确认崩溃出现

---

## 第 6 步：部署 Firestore 安全规则

```bash
# 从项目根目录执行，从 firestore.rules 部署规则
firebase deploy --only firestore:rules
```

验证规则生效：Firebase 控制台 → Firestore → **规则** 标签页。

完整规则规范和设计依据详见 [安全规则文档](security-rules.md)。

---

## 第 7 步：运行应用

```bash
# 在已连接的设备或模拟器上运行
flutter run

# 若 USB 安装失败（部分设备报 INSTALL_FAILED_ABORTED）：
flutter build apk
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

---

## 常见问题排查

### `google-services.json` 找不到
重新运行 `flutterfire configure`。该文件已加入 .gitignore，每台机器需独立生成。

### 启动时出现插件崩溃
确保在 `main()` 中 `runApp()` 之前调用了 `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`。

### Analytics 事件未出现在 DebugView
1. 确认 DebugView 已启用：`adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app`
2. 运行 adb 命令后重启应用
3. 事件可能需要 30-60 秒才会出现

### 前台服务通知未显示
确认 Android 13 以上系统已授予 `POST_NOTIFICATIONS`（发送通知）权限。应用会在首次启动计时器时请求该权限。

### Remote Config 返回默认值
首次拉取可能缓存长达 12 小时。开发时可强制立即拉取：
```bash
# 清除应用数据以重置 Remote Config 缓存
adb shell pm clear com.hachimi.hachimi_app
```
