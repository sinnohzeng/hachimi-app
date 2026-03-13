# 架构概览

> 2026-03 安全与可观测现代化后的运行架构 SSOT。

## 核心原则
- 离线优先：SQLite + 台账是运行时 SSOT。
- 确定性同步：`SyncEngine` 将本地动作回推 Firestore。
- Google 优先安全：App Check + IAM/ADC + Secret Manager。
- Release 主路径不再使用客户端静态 AI API key。

## 技术栈
| 层 | 技术 |
|---|---|
| App | Flutter 3.41.x + Dart 3.11.x |
| 状态管理 | Riverpod 3.x |
| 本地存储 | sqflite + SharedPreferences |
| 认证/数据 | Firebase Auth + Firestore |
| 账户后端操作 | Firebase Functions callable V2 |
| AI | Firebase AI Logic + Vertex AI |
| 可观测性 | Crashlytics + Cloud Logging + BigQuery + Google Chat/Email |
| 基础设施控制面 | Terraform |

## 分层设计
```text
Screens -> Providers -> Services -> Backend 抽象 -> Firebase SDK / Cloud Functions
```

## 账户生命周期
### 访客升级冲突
1. 登录成功。
2. 构建本地快照 + 云端快照。
3. 通过冲突矩阵判定（`keepLocal` / `keepCloud` / 用户显式选择）。
4. 由 `AccountMergeService` 执行合并。

### 删号（离线优先）
1. 摘要确认 + 输入 `DELETE`。
2. `AccountDeletionOrchestrator` 先清理本地数据。
3. 在线调用 `deleteAccountV2`。
4. 离线进入待重试队列。
5. UI `_executeDelete` 使用 `finally` 不变量：若 `localDataDestroyed && !navigatedAway`，无条件重置 onboarding — 任何错误路径都不会让应用停留在半销毁状态。

## Cloud Functions 契约
主 callable 契约：
- `deleteAccountV2`
- `wipeUserDataV2`

约束：
- 必须登录态
- 强制 App Check（并消费 token 防重放）
- `OperationContext` 必填：
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

兼容别名（`V1`）仍保留用于平滑迁移。

## AI 与安全契约
- 客户端 AI provider 仅保留 `firebase_gemini`。
- 服务端分诊函数为 `runAiDebugTriageV2`。
- GitHub 草稿工单使用 GitHub App 安装令牌链路。
- GitHub App 私钥托管在 Secret Manager。

## 可观测性契约
- 客户端错误统一走强类型 `ErrorContext` + `ErrorHandler.record(...)`。
- 隐私红线：禁止明文 UID/邮箱/手机号进入遥测。
- Functions 结构化日志强制字段：
  - `correlation_id`
  - `uid_hash`
  - `function_name`
  - `latency_ms`
  - `result`
  - `error_code`
- 告警通道固定为 Google Chat + Email。

## Android 平台配置
- **Edge-to-edge**：`MainActivity.onCreate()` 中调用 `enableEdgeToEdge()`（原生窗口配置 SSOT）。
- **基础 Activity**：`FlutterFragmentActivity`（提供 `ComponentActivity` 以支持 AndroidX edge-to-edge API）。
- **主题**：`Theme.Material3.Light.NoActionBar` / `Theme.Material3.Dark.NoActionBar`。
- **系统栏样式**：`app_theme.dart` 中的 `AppBarTheme.systemOverlayStyle`（Flutter 侧系统 UI 的 SSOT）。
- **依赖**：`activity-ktx:1.10.1`、`material:1.12.0`（在 `build.gradle` 中显式声明）。
- **预测性返回**：AndroidManifest 中 `android:enableOnBackInvokedCallback="true"`。

## 双 UI 风格架构

应用支持两种视觉模式，可在设置中切换：

- **Material 3** — 标准 M3 圆角组件，支持动态色。
- **复古像素（Retro Pixel）** — 星露谷物语风格的暖色调像素 UI，所有 Material 组件通过 `PixelBorderShape` 自动获得阶梯角。

架构要点：
- `ThemeSkin` 策略模式（`MaterialSkin` / `RetroPixelSkin`）消除主题构建中的条件分支。
- `PixelBorderShape extends OutlinedBorder` — 注入 `cardTheme.shape`、`dialogTheme.shape` 等主题级联。一个 `ShapeBorder` 替代 7+ 个包装组件。
- 复古色映射到 `ColorScheme` 槽位（如 `surface` → 复古背景色、`outline` → 像素边框色），所有 Material 组件零改动自动适配。
- `AppScaffold` 包裹 `Scaffold`，在复古模式下条件性叠加 `RetroTiledBackground` — 23+ 个屏幕的唯一集成点。
- `PixelThemeExtension` 承载像素专用令牌（经验条、成功/警告色、Silkscreen 字体样式）。

## SSOT 映射
| 关注点 | SSOT |
|---|---|
| 运行时业务状态 | SQLite（`local_*`, `materialized_state`） |
| 写前日志 | `action_ledger` |
| 云端持久化 | Firestore `users/{uid}` 子树 |
| 认证状态 | `authStateProvider` |
| 可观测性契约 | `docs/zh-CN/architecture/observability.md` |
| 基础设施状态 | `infra/terraform/*` |
