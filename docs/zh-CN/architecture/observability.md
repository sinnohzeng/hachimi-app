# 可观测性架构

> 遥测契约、数据链路与 AI Debug 闭环的 SSOT。

## 目标
定义从客户端错误到 AI 分诊报告与告警联动的一体化契约。

## 核心契约
### ErrorContext（客户端）
必填字段：
- `feature`
- `operation`
- `operation_stage`
- `correlation_id`
- `uid_hash`
- `app_version`
- `build_number`
- `network_state`
- `retry_count`
- `error_code`

### OperationContext（客户端 -> callable）
必填字段：
- `correlation_id`
- `uid_hash`
- `operation_stage`
- `retry_count`

### Callable telemetry 响应
- `ok`
- `correlation_id`
- `function_name`
- `latency_ms`
- `result`
- `error_code?`

## 客户端链路
1. 捕获异常。
2. 构建强类型 `ErrorContext`。
3. `ErrorHandler.record(...)` 按白名单过滤字段。
4. 写入 Crashlytics custom key 和错误事件。
5. 发出带关联元数据的 Analytics `app_error`。

## Callable 链路
敏感操作：
- `deleteAccountV2`
- `wipeUserDataV2`

执行规则：
1. 校验 auth 与 `OperationContext`。
2. 强制 App Check 并消费 token。
3. 输出结构化开始/成功/失败日志。
4. 返回统一 telemetry 响应或抛出 `HttpsError`。

## 数据层
- Crashlytics 导出 -> BigQuery + Cloud Logging
- Analytics 导出 -> BigQuery
- Functions 日志 -> Cloud Logging -> BigQuery sink
- BigQuery `obs` 数据集承载：
  - `issue_daily_v1`
  - `issue_velocity_v1`
  - `issue_user_impact_v1`
  - `flow_error_funnel_v1`
  - `release_stability_v1`
  - `ai_debug_tasks_v1`
  - `ai_debug_reports_v1`

## AI Debug 闭环
1. 定时 SQL 每 15 分钟刷新 `ai_debug_tasks_v1`。
2. `runAiDebugTriageV2` 读取任务并通过 IAM/ADC 调用 Vertex AI。
3. AI 调用失败时回退 heuristic。
4. 输出写入 `ai_debug_reports_v1`。
5. 通过 GitHub App 安装令牌创建草稿 issue。

## 告警
允许通道：
- Google Chat（主）
- Email（兜底）

策略名称约束：
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`
- `budget_threshold`

## 隐私与合规
- 禁止记录明文 UID/邮箱/手机号。
- 身份关联仅使用 `uid_hash`。
- 非白名单字段不进入遥测。
- AI 报告保留审计字段：`model_name`、`prompt_version`、`decision_trace_id`。

## 关联文件
- `lib/core/observability/*`
- `lib/core/utils/error_handler.dart`
- `lib/services/firebase/firebase_account_lifecycle_backend.dart`
- `functions/src/index.ts`
- `infra/terraform/modules/observability/*`
