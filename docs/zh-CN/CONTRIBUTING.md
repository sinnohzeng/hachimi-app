# 贡献指南

感谢您为 Hachimi 做出贡献！本文档描述了项目的开发工作流、规范和标准。

---

## 开发原则

本项目遵循**文档驱动开发（DDD）**原则：

1. **文档优先**：实现功能前，先更新 `docs/` 中的相关规范文档。
2. **代码是实现**：若代码与文档冲突，修改代码。
3. **统一真值（SSOT）**：每个关注点只有一个权威来源，不在文件间重复逻辑。
4. **不做推测性功能**：只构建规范中明确要求的内容，不添加"以备不时之需"的配置选项或抽象。

---

## 环境要求

| 工具 | 版本 | 安装方式 |
|------|------|---------|
| Flutter | 3.41.x | `flutter upgrade` |
| Dart | 3.11.x | 随 Flutter 捆绑 |
| JDK | 17 | `brew install openjdk@17`（macOS） |
| Firebase CLI | 最新版 | `npm install -g firebase-tools` |
| FlutterFire CLI | 最新版 | `dart pub global activate flutterfire_cli` |

克隆仓库后：
```bash
flutter pub get
flutterfire configure --project=hachimi-ai  # 生成 firebase_options.dart
```

---

## 分支命名

| 类型 | 格式 | 示例 |
|------|------|------|
| 新功能 | `feat/<简短描述>` | `feat/cat-room-scene` |
| 缺陷修复 | `fix/<简短描述>` | `fix/timer-background-crash` |
| 文档 | `docs/<简短描述>` | `docs/update-data-model` |
| 重构 | `refactor/<简短描述>` | `refactor/xp-service-cleanup` |
| 杂项 | `chore/<简短描述>` | `chore/upgrade-agp` |

从 `main` 分支创建，所有工作在功能分支上进行，通过 PR 合并。

---

## 提交信息

遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<类型>(<范围>): <简短描述>

[可选正文]

[可选页脚]
```

**类型：** `feat`、`fix`、`docs`、`refactor`、`test`、`chore`、`style`

**示例：**
```
feat(cat-room): 添加基于性格的槽位分配算法
fix(timer): 防止快速点击"放弃"时写入重复会话
docs(data-model): 添加 sessions 子集合模式
chore: 升级 AGP 至 8.13.2
```

---

## 代码风格

每次提交前运行 Lint：
```bash
flutter analyze
```

要求零警告、零错误。若 `flutter analyze` 失败，禁止开启 PR。

**核心规范：**
- 编译器能接受的地方一律使用 `const`
- 优先使用 `final` 而非 `var`
- 正式代码中不使用 `print()`——使用 `debugPrint()` 或删除
- 不留注释掉的代码——删除它；Git 历史记录会保留
- 遵守[目录结构](architecture/folder-structure.md)中的层级依赖规则

---

## 新增功能流程

1. **更新文档**——找到相关规范文档（如猫咪机制对应 `cat-system.md`，产品功能对应 `prd.md`）并更新。
2. **更新数据模型**——若 Firestore 模式有变化，更新 `data-model.md` 和 `firestore.rules`。
3. **更新分析事件**——若有新的用户行为需要追踪，更新 `analytics-events.md` 和 `analytics_events.dart`。
4. **实现**——遵循现有层级模式：模型 → 服务 → Provider → 界面/组件。
5. **运行 `flutter analyze`**——修复所有警告。
6. **手动测试**——参照实现计划中的验证步骤。

---

## 新增界面

1. 在 `lib/screens/{功能}/` 下创建文件，遵循 `snake_case.dart` 命名规范。
2. 创建 `class {功能名}Screen extends ConsumerWidget`。
3. 在 `AppRouter` 中添加路由，并在 `overview.md` 导航表中记录。
4. 在 `screens.md` 中添加新界面规范。

---

## 新增 Provider

1. 在 `lib/providers/` 下创建文件，或添加到现有相关 Provider 文件。
2. 在 `state-management.md` 中记录新 Provider——类型、数据源、消费者、所管理的 SSOT。
3. 确保 Provider 遵循图谱规则：无循环依赖，Provider 中不引用 Screen。

---

## Firebase 规则变更

1. 更新项目根目录的 `firestore.rules`。
2. 更新 `docs/firebase/security-rules.md` 以反映变更。
3. 使用 Firebase 控制台的规则模拟器进行测试。
4. 部署：`firebase deploy --only firestore:rules`

---

## PR 提交检查清单

申请审查前：

- [ ] `flutter analyze` 通过，零警告
- [ ] 相关文档已更新（规范、数据模型、分析事件等）
- [ ] 无硬编码颜色、字体或间距值
- [ ] Screen 文件中无直接导入 Service
- [ ] 新分析事件已同时添加到 `analytics_events.dart` 和 `analytics-events.md`
- [ ] Firestore 模式变更已同时反映在 `firestore.rules` 和 `data-model.md`

---

## .gitignore 文件

以下文件**绝不提交**：
- `lib/firebase_options.dart`——由 `flutterfire configure` 生成
- `android/app/google-services.json`——Firebase Android 配置
- `ios/Runner/GoogleService-Info.plist`——Firebase iOS 配置

每位贡献者需在本地运行 `flutterfire configure` 自行生成这些文件。

---

## 常用命令

```bash
# 在已连接设备上运行
flutter run

# 构建 APK（用于手动 ADB 安装）
flutter build apk

# 通过 ADB 直接安装（部分设备如 vivo）
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk

# 代码检查
flutter analyze

# 格式化代码
dart format lib/

# 启用 Firebase Analytics DebugView
adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app

# 部署 Firestore 规则
firebase deploy --only firestore:rules

# 清除应用数据（用于测试首次启动流程）
adb shell pm clear com.hachimi.hachimi_app
```
