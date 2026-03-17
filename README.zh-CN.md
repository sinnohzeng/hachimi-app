# Hachimi

以养猫为核心的习惯追踪应用。领养像素猫咪，通过专注工作培养习惯，看着它们慢慢成长。基于 Flutter + Firebase + Material Design 3 构建。

[![CI](https://github.com/sinnohzeng/hachimi-app/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/sinnohzeng/hachimi-app/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/sinnohzeng/hachimi-app)](https://github.com/sinnohzeng/hachimi-app/releases/latest)

## 产品简介

每一个习惯都会配对一只专属像素猫咪伴侣。专注计时让猫咪成长——从幼猫（0 小时）到少年（20 小时）、成年（100 小时），再到资深（200 小时）。AI 以猫咪的口吻每日生成日记，并支持应用内聊天，全程由猫咪的个性与心情驱动。

## 架构亮点

- **离线优先**：SQLite 操作台账 + 物化状态作为运行时 SSOT；Firestore 负责云端同步
- **双 UI 主题**：Material 3 与复古像素（星露谷风格）通过 `ThemeSkin` 策略模式实现
- **AI 管线**：Gemini / MiniMax 双引擎，含熔断器、日记重试队列与每猫每日聊天限额
- **账号生命周期**：访客升级账号时支持本地/云端数据冲突显式选择
- **供应链加固**：Sigstore 签名认证、Workload Identity Federation、CI 默认拒绝权限

## 质量红线

| 指标 | 上限 |
| ---- | ---- |
| 单文件行数 | ≤ 800 行 |
| 单函数行数 | ≤ 30 行 |
| 嵌套层数 | ≤ 3 |
| 分支数量 | ≤ 5 / 函数 |

## 技术栈

- Flutter 3.41.x / Dart 3.11.x
- Riverpod 3.x
- Firebase Auth + Firestore + Cloud Functions
- Firebase Analytics + Crashlytics
- sqflite + SharedPreferences

## 快速开始

**前置要求：**
- JDK 17 — `brew install openjdk@17`（JDK 21+ 与 Gradle 8.x 不兼容）
- Android SDK — Android Studio 或 `commandlinetools`
- Flutter 3.41.x stable 渠道

```bash
flutter pub get
cd functions && npm install && cd ..
```

配置 Firebase：
```bash
firebase login
flutterfire configure --project <project-id>
```

部署后端：
```bash
firebase deploy --only firestore:rules,firestore:indexes,functions
```

## 验证命令

```bash
dart analyze lib test
flutter test --exclude-tags golden
dart run tool/quality_gate.dart
cd functions && npm test
```

## 文档入口

- [文档索引](docs/zh-CN/README.md)
- [架构概览](docs/zh-CN/architecture/overview.md)
- [状态管理](docs/zh-CN/architecture/state-management.md)
- [数据模型](docs/zh-CN/architecture/data-model.md)
- [Firebase 配置](docs/zh-CN/firebase/setup-guide.md)
- [English README](README.md)

## 安全

漏洞报告请参阅 [SECURITY.md](SECURITY.md)。

## 许可证

Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.
