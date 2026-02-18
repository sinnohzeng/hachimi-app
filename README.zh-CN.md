# Hachimi 🐱

<p align="center">
  <strong>养猫。养习惯。一次专注，一步成长。</strong>
</p>

<p align="center">
  <a href="README.md">🇬🇧 English</a>
  &nbsp;·&nbsp;
  <a href="docs/zh-CN/README.md">文档目录</a>
  &nbsp;·&nbsp;
  <a href="docs/zh-CN/CONTRIBUTING.md">贡献指南</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41.1-blue?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11.0-blue?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-backend-orange?logo=firebase" alt="Firebase" />
  <img src="https://img.shields.io/badge/Material_Design-3-purple?logo=materialdesign" alt="MD3" />
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License" />
</p>

---

## 什么是 Hachimi？

Hachimi 是一款**养猫习惯 App**——每创建一个习惯，你就会领养一只虚拟猫咪来陪伴这段成长旅程。专注完成习惯 → 赚取 XP → 看着猫咪从小奶猫进化成闪闪发光的成年猫。随着你养成更多习惯，温馨的猫咪房间逐渐被各种猫咪占满，形成你成长历程的可视化记录。

核心玩法循环：

> **创建习惯 → 领养猫咪 → 开始专注计时 → 赚取 XP → 猫咪进化**

---

## 功能特性

### 🐱 猫咪收养系统
- 每个新习惯从 3 只随机生成的候选猫咪中领养一只
- 10 种猫咪品种 × 6 种性格 × 3 个稀有度等级（普通 / 非普通 / 稀有）
- 猫咪经历 4 个成长阶段：**幼猫 → 少年猫 → 成年猫 → 闪光猫**
- 猫咪心情随你的坚持程度动态变化：开心 → 普通 → 孤独 → 想你了

### ⏱️ 专注计时器
- 倒计时模式（设定目标时长）和正计时模式（开放时长）
- Android 前台服务持久化 — 退出 App 后计时器继续运行
- 离开 15 秒后自动暂停；离开 5 分钟后自动结束
- XP 计算公式：基础值（1 XP/分钟）+ 连续打卡加成 + 里程碑加成 + 全完成加成

### 🏠 猫咪房间
- 温馨图解房间场景，展示所有活跃猫咪
- 根据系统时间自动切换白天/夜晚氛围
- 点击猫咪 → 弹出心情对话气泡 + 快捷操作面板（开始专注 / 查看详情）
- 根据猫咪性格分配房间位置（慵懒型猫咪爱沙发，好奇型猫咪占窗台）

### 📊 统计与猫咪相册
- 每个习惯对应 GitHub 风格的 91 天活动热力图
- 今日专注摘要（分钟数、总时长、猫咪数量）
- 完整猫咪相册，含稀有度统计（活跃猫、休眠猫、毕业猫）

### 🔔 推送通知
- 每日提醒（可按习惯设置具体时间）
- 当天无打卡且连续天数 ≥ 3 时，晚 8 点发送"连续天数危险"提醒
- 猫咪升级庆祝通知

---

## 技术栈

| 层次 | 技术 | 版本 | 用途 |
|------|------|------|------|
| UI 框架 | Flutter | 3.41.1 | 跨平台移动开发 |
| 编程语言 | Dart | 3.11.0 | 类型安全、空安全 |
| 设计系统 | Material Design 3 | — | 统一 UI 主题 |
| 状态管理 | Riverpod | 2.6.1 | 响应式 SSOT 提供者 |
| 身份认证 | Firebase Auth | 5.x | Google + 邮箱登录 |
| 数据库 | Cloud Firestore | 5.x | 实时数据同步 |
| 分析统计 | Firebase Analytics | 11.x | GA4 事件追踪 |
| 推送通知 | Firebase Messaging | 15.x | 服务端触发 FCM |
| 本地通知 | flutter_local_notifications | 18.x | 定时每日提醒 |
| 后台计时 | flutter_foreground_task | 8.x | Android 前台服务 |
| A/B 测试 | Firebase Remote Config | 5.x | 动态配置 |
| 崩溃报告 | Firebase Crashlytics | 4.x | 生产环境错误追踪 |

---

## 项目结构

```
lib/
├── app.dart                    # 根 Widget + AuthGate + _FirstHabitGate
├── main.dart                   # 入口，Firebase + 前台服务初始化
├── core/
│   ├── constants/
│   │   ├── analytics_events.dart    # SSOT：所有 GA4 事件名及参数
│   │   └── cat_constants.dart       # SSOT：品种、阶段、心情、房间位置
│   ├── router/
│   │   └── app_router.dart          # 命名路由注册表
│   └── theme/
│       └── app_theme.dart           # SSOT：Material 3 主题（种子色）
├── models/                     # 数据模型（Firestore 映射）
├── providers/                  # Riverpod 状态提供者（响应式 SSOT）
├── services/                   # Firebase 服务封装层
├── screens/                    # 页面
└── widgets/                    # 可复用 UI 组件
```

---

## 快速开始

### 前置要求

| 工具 | 版本 | 说明 |
|------|------|------|
| Flutter | 3.41.x stable | `flutter --version` 确认版本 |
| Dart | 3.11.x | 随 Flutter 捆绑 |
| JDK | 17 | `brew install openjdk@17`（macOS）|
| Android Studio | 最新版 | 用于 AVD / 设备管理 |
| Firebase CLI | 最新版 | `npm install -g firebase-tools` |
| FlutterFire CLI | 最新版 | `dart pub global activate flutterfire_cli` |

> **macOS Homebrew Android SDK 路径：** `/opt/homebrew/share/android-commandlinetools`

### 1. 克隆并安装依赖

```bash
git clone https://github.com/your-username/hachimi-app.git
cd hachimi-app
flutter pub get
```

### 2. 配置 Firebase

```bash
firebase login
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

此命令会生成 `lib/firebase_options.dart` 和 `android/app/google-services.json`（均已加入 `.gitignore`，**切勿提交**）。

### 3. 启用 Firebase 服务

在 [Firebase 控制台](https://console.firebase.google.com)中：

1. **身份验证** → 启用**邮箱/密码**和 **Google** 登录
2. **Firestore** → 以**生产模式**创建数据库
3. **Analytics** → 启用 Google Analytics
4. **Remote Config** → 发布默认参数（参见 [remote-config.md](docs/zh-CN/firebase/remote-config.md)）
5. **Crashlytics** → 在控制台启用

部署安全规则：
```bash
firebase deploy --only firestore:rules
```

### 4. 运行 App

```bash
flutter run                       # 标准运行

# 部分设备 USB 安装失败（INSTALL_FAILED_ABORTED）时：
flutter build apk
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

---

## 文档索引

| 文档 | 描述 |
|------|------|
| [架构概览](docs/zh-CN/architecture/overview.md) | 系统设计、依赖流向、SSOT 原则 |
| [数据模型](docs/zh-CN/architecture/data-model.md) | Firestore 集合结构、字段定义、索引 |
| [猫咪系统](docs/zh-CN/architecture/cat-system.md) | 游戏设计 SSOT — 品种、XP、心情、房间位置 |
| [状态管理](docs/zh-CN/architecture/state-management.md) | Riverpod 提供者设计与数据流 |
| [目录结构](docs/zh-CN/architecture/folder-structure.md) | 目录布局规范与命名规则 |
| [PRD v3.0](docs/zh-CN/product/prd.md) | 完整产品需求文档 |
| [Firebase 配置](docs/zh-CN/firebase/setup-guide.md) | Firebase 逐步配置说明 |
| [分析事件](docs/zh-CN/firebase/analytics-events.md) | GA4 自定义事件参考（SSOT）|
| [安全规则](docs/zh-CN/firebase/security-rules.md) | Firestore 安全规则说明 |
| [Remote Config](docs/zh-CN/firebase/remote-config.md) | A/B 测试参数定义 |
| [设计系统](docs/zh-CN/design/design-system.md) | Material 3 主题规范、颜色角色、字体 |

---

## 架构概要

**依赖流向**（强制执行 — 禁止跨层调用）：
```
页面（Screens）→ 提供者（Providers）→ 服务（Services）→ Firebase SDK
```

**SSOT 映射表：**

| 关注点 | 权威来源 |
|--------|---------|
| 业务数据 | Firestore |
| 认证状态 | `authStateProvider` |
| 猫咪列表 | `catsProvider` |
| 计时器状态 | `focusTimerProvider` |
| UI 主题 | `lib/core/theme/app_theme.dart` |
| 分析事件 | `lib/core/constants/analytics_events.dart` |
| 猫咪游戏数据 | `lib/core/constants/cat_constants.dart` |
| 动态配置 | Firebase Remote Config |

---

## 贡献

参见 [贡献指南](docs/zh-CN/CONTRIBUTING.md)。

## 许可证

MIT © 2024 Hachimi
