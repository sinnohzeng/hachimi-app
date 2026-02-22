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
  <img src="https://img.shields.io/badge/license-All%20Rights%20Reserved-red" alt="License" />
</p>

---

## 什么是 Hachimi？

Hachimi 是一款**养猫习惯 App**——每创建一个习惯，你就会领养一只虚拟猫咪来陪伴这段成长旅程。专注完成习惯 → 赚取 XP → 看着猫咪从小奶猫进化成闪闪发光的成年猫。随着你养成更多习惯，温馨的猫咪房间逐渐被各种猫咪占满，形成你成长历程的可视化记录。

核心玩法循环：

> **创建习惯 → 领养猫咪 → 开始专注计时 → 赚取 XP 和金币 → 猫咪进化**

---

## 功能特性

### 核心循环
**猫咪领养** · **专注计时器** · **XP 与进化**
- 每个新习惯从 3 只随机生成的候选猫咪中领养一只
- 15 种毛色花纹 × 19 种颜色 × 21 种眼色 × 6 种性格
- 倒计时 / 正计时模式，Android 前台服务持久化运行
- XP 公式：基础值 + 连续打卡加成 + 里程碑加成 + 全完成加成
- 4 个成长阶段：幼猫 → 少年猫 → 成年猫 → 长老猫

### 猫咪世界
**猫咪房间** · **配饰商店** · **背包**
- 白天/夜晚氛围的图解房间，根据性格分配位置
- 100+ 配饰，5 档定价（50–350 金币）
- 金币来源：专注（10 金币/分钟）+ 每日签到奖励

### AI 陪伴
**猫咪聊天** · **AI 日记**
- 本地 LLM（Qwen3-1.7B，通过 llama_cpp_dart），无云端依赖
- 猫咪以性格化语气回复，完全隐私
- 每日自动生成日记，融合心情/成长/专注数据

### 进度与奖励
**统计面板** · **每日签到** · **通知提醒**
- 周趋势柱状图（fl_chart）+ 91 天热力图 + 分页专注历史
- 月历 UI，平日 10 / 周末 15 金币，7/14/21/满月里程碑
- 每日提醒 + 连续天数危险提醒 + 升级庆祝

---

## 技术栈

| 层次 | 技术 | 版本 | 用途 |
|------|------|------|------|
| UI 框架 | Flutter | 3.41.1 | 跨平台移动开发 |
| 编程语言 | Dart | 3.11.0 | 类型安全、空安全 |
| 设计系统 | Material Design 3 | — | 统一 UI 主题 |
| 状态管理 | Riverpod | 3.2.1 | 响应式 SSOT 提供者 |
| 身份认证 | Firebase Auth | 6.x | Google + 邮箱登录 |
| 数据库 | Cloud Firestore | 6.x | 实时数据同步 |
| 本地数据库 | sqflite | 2.4.x | LLM 聊天记录 + 日记缓存 |
| 分析统计 | Firebase Analytics | 12.x | GA4 事件追踪 |
| 性能监控 | Firebase Performance | 0.11.x | 自定义 trace + 性能监控 |
| 推送通知 | Firebase Messaging | 16.x | 服务端触发 FCM |
| 本地通知 | flutter_local_notifications | 20.x | 定时每日提醒 |
| 后台计时 | flutter_foreground_task | 9.x | Android 前台服务 |
| A/B 测试 | Firebase Remote Config | 6.x | 动态配置 |
| 崩溃报告 | Firebase Crashlytics | 5.x | 非致命 + 致命错误追踪 |
| 图表 | fl_chart | 0.70.x | 周趋势 + 统计可视化 |
| 动态颜色 | dynamic_color | 1.8.x | Material You 取色 |
| 本地 LLM | llama_cpp_dart | vendored | 设备端 Qwen3-1.7B 推理 |

---

## 项目结构

```
lib/
├── core/
│   ├── constants/       # SSOT：分析事件、猫咪、LLM、像素猫（4 个文件）
│   ├── router/          # 命名路由注册表
│   ├── theme/           # Material 3 种子色 + 颜色工具
│   └── utils/           # 错误处理、校验和、日期工具（9 个文件）
├── models/              # 7 个 Firestore/本地数据模型
├── providers/           # 19 个 Riverpod 状态提供者
├── services/            # 19 个 Firebase + 本地服务封装
├── screens/             # 11 个功能页面目录
└── widgets/             # 17 个可复用 UI 组件
```

完整文件清单 → [目录结构](docs/zh-CN/architecture/folder-structure.md)

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
git clone https://github.com/sinnohzeng/hachimi-app.git
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
6. **Performance** → 在性能监控面板中启用

部署安全规则：
```bash
firebase deploy --only firestore:rules
```

### 4. 设置本地 LLM（可选，用于 AI 聊天）

```bash
bash scripts/setup_llm_vendor.sh
```

此脚本会下载设备端 AI 聊天所需的 Qwen3-1.7B 模型文件。不设置也能正常使用 App，但猫咪聊天和 AI 日记功能将不可用。

### 5. 运行 App

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
| [用户故事](docs/zh-CN/product/user-stories.md) | 各功能验收标准 |
| [Firebase 配置](docs/zh-CN/firebase/setup-guide.md) | Firebase 逐步配置说明 |
| [分析事件](docs/zh-CN/firebase/analytics-events.md) | GA4 自定义事件参考（SSOT）|
| [安全规则](docs/zh-CN/firebase/security-rules.md) | Firestore 安全规则说明 |
| [Remote Config](docs/zh-CN/firebase/remote-config.md) | A/B 测试参数定义 |
| [设计系统](docs/zh-CN/design/design-system.md) | Material 3 主题规范、颜色角色、字体 |
| [官网部署](docs/website/deployment.md) | hachimi.ai 官网部署与维护 |

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
| 金币余额 | `coinBalanceProvider` |
| 背包 | `inventoryProvider` |
| 签到状态 | `checkInProvider` |
| UI 主题 | `lib/core/theme/app_theme.dart` |
| 分析事件 | `lib/core/constants/analytics_events.dart` |
| 猫咪游戏数据 | `lib/core/constants/cat_constants.dart` |
| LLM 配置 | `lib/core/constants/llm_constants.dart` |
| 聊天记录 | SQLite（通过 sqflite）|
| 动态配置 | Firebase Remote Config |

---

## Firestore 数据结构（概览）

```
users/{uid}
├── habits/{habitId}              习惯元数据 + 连续天数追踪
│   └── sessions/{sessionId}     专注记录（XP、时长、模式、金币、状态）
├── cats/{catId}                  猫咪状态（XP、阶段、心情、房间位置、外观）
└── monthlyCheckIns/{YYYY-MM}    每月签到日历（日期映射、连续天数、金币）
```

完整结构 → [数据模型](docs/zh-CN/architecture/data-model.md)

---

## 贡献

参见 [贡献指南](docs/zh-CN/CONTRIBUTING.md)。

## 许可证

Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.

本源代码以作品集与参考目的公开，仅允许查阅与参考，未经书面授权不得复制、修改、分发或使用。
完整条款详见 [LICENSE](LICENSE)。
