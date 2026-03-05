# 可观测性架构

> 应用错误遥测、Callable 链路追踪与 AI 分诊自动化的 SSOT。

## 目标
定义移动端错误、Cloud Functions 日志、BigQuery 查询、告警与 AI 分诊之间的统一运行契约。

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

## 客户端链路
1. 捕获异常。
2. 构建 `ErrorContext`。
3. `ErrorHandler.record(...)` 基于白名单过滤字段。
4. 写入 Crashlytics 自定义键与错误事件。
5. 发出 Analytics `app_error` 事件并带关联字段。

## Callable 链路
1. 校验 `OperationContext`。
2. 函数按统一结构写入开始/成功/失败日志。
3. 返回统一 telemetry 响应。
4. 失败时输出 `error_code` 并抛 `HttpsError`。

## 数据层
- Crashlytics 导出到 BigQuery 与 Cloud Logging。
- Analytics 导出到 BigQuery。
- Functions 日志进入 Cloud Logging（可导出到 BigQuery）。
- `obs` 数据集承载问题视图与 AI 分诊表。

## AI Debug 闭环
1. 每 15 分钟刷新 `obs.ai_debug_tasks_v1`。
2. `runAiDebugTriageV1` 读取任务并生成可执行报告。
3. 报告落库到 `obs.ai_debug_reports_v1`。
4. 自动创建 GitHub 草稿 issue（前缀 `[DRAFT][AI-DEBUG]`）。

## 告警
- 主通道：Google Chat。
- 兜底通道：Email。
- 禁止单通道运行。

## 隐私红线
- 禁止记录明文 UID/邮箱/手机号。
- 全链路统一使用 `uid_hash`。
- 非白名单字段不进入遥测。

## 关联文件
- `lib/core/observability/*`
- `lib/core/utils/error_handler.dart`
- `functions/src/index.ts`
- `functions/sql/observability/*`
- `scripts/gcp/setup_observability.sh`
