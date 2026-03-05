# 架构概览

> SSOT：本文档描述 2026-03 账户生命周期重构后的当前运行架构。

## 核心原则
- 离线优先：SQLite + 台账是运行时唯一真值。
- 确定性同步：`SyncEngine` 推送未同步行为到 Firestore。
- 无兼容包袱：移除迁移网关与未上线历史兼容分支。
- 单云路径：仅保留 Firebase 运行路径。

## 技术栈
| 层 | 技术 |
|---|---|
| App | Flutter 3.41.x + Dart 3.11.x |
| 状态管理 | Riverpod 3.x |
| 本地存储 | sqflite + SharedPreferences |
| 认证/数据 | Firebase Auth + Firestore |
| 账户服务端操作 | Firebase Cloud Functions（callable） |
| 可观测性 | Crashlytics + Cloud Logging + BigQuery + Google Chat/Email 告警 |

## 分层设计
```
Screens -> Providers -> Services -> Backend 抽象 -> Firebase SDK / Cloud Functions
```

## 新账户生命周期
### 访客升级冲突
1. Google/Email 登录成功。
2. 计算本地快照与云端快照。
3. 冲突矩阵判定：
- 本地空 + 云端有：保留云端
- 云端空 + 本地有：保留本地
- 两端都有：弹窗强制二选一
4. 通过 `AccountMergeService` 执行合并。

### 删号（离线优先）
1. 数据摘要确认。
2. 输入 `DELETE` 二次确认。
3. `AccountDeletionOrchestrator` 执行：
- 本地立即删除
- 在线立即调用 `deleteAccountV1`
- 离线写入 pending job + tombstone，后续自动重试

## Cloud Functions 合约
- `deleteAccountV1`：递归删除 `users/{uid}` + 删除 Auth 用户（幂等）
- `wipeUserDataV1`：仅递归删除 `users/{uid}`（幂等）
- 两个 callable 均强制 `OperationContext` 入参：
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

## 可观测性契约（新增）
- 客户端错误统一通过带 `ErrorContext` 的 `ErrorHandler.record(...)` 上报。
- 崩溃上报仅使用哈希身份（`uid_hash`），禁止明文 UID。
- Functions 日志统一结构化字段：
  - `correlation_id`
  - `uid_hash`
  - `function_name`
  - `latency_ms`
  - `result`
  - `error_code`
- AI 分诊函数 `runAiDebugTriageV1` 每 15 分钟执行一次，写入 `obs.ai_debug_reports_v1`。

## SSOT 映射
| 关注点 | SSOT |
|---|---|
| 运行时业务状态 | SQLite（`local_*`、`materialized_state`） |
| 写前日志 | `action_ledger` |
| 云端持久化 | Firestore `users/{uid}` 子树 |
| 认证状态 | `authStateProvider` |
| 删号排队状态 | SharedPreferences 队列键 |
| 分析事件名 | `lib/core/constants/analytics_events.dart` |

## 已移除 legacy 路径
- `MigrationService` 与 `_VersionGate`
- Firestore `checkIns` 兼容路径
- `RemoteConfigService` 运行时依赖
- `OfflineWriteGuard`
- `BackendRegion.china` 分支
