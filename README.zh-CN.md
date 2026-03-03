# Hachimi

一款 Flutter + Firebase 的养猫习惯应用，运行时采用离线优先架构。

## 核心能力
- 离线优先：本地 SQLite 台账/物化状态是运行时 SSOT。
- 访客升级：登录后对比本地/云端存档，用户明确选择“保留本地”或“保留云端”。
- 删号重构：数据摘要确认 + 输入 `DELETE` 二次确认 + 本地先删 + 云端硬删排队。
- Firebase Cloud Functions 账户接口：
  - `deleteAccountV1`
  - `wipeUserDataV1`
- `lib/` 质量闸门：
  - 单文件 <= 800 行
  - 单函数 <= 30 行
  - 嵌套 <= 3
  - 分支 <= 3

## 技术栈
- Flutter 3.41.x / Dart 3.11.x
- Riverpod 3.x
- Firebase Auth + Firestore + Cloud Functions
- Firebase Analytics + Crashlytics
- sqflite + SharedPreferences

## 快速开始
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

## 许可证
Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.
