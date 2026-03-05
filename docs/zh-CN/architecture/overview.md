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

## SSOT 映射
| 关注点 | SSOT |
|---|---|
| 运行时业务状态 | SQLite（`local_*`, `materialized_state`） |
| 写前日志 | `action_ledger` |
| 云端持久化 | Firestore `users/{uid}` 子树 |
| 认证状态 | `authStateProvider` |
| 可观测性契约 | `docs/zh-CN/architecture/observability.md` |
| 基础设施状态 | `infra/terraform/*` |
