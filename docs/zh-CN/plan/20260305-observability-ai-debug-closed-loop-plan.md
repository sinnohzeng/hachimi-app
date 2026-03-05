# 2026-03-05 可观测性与 AI Debug 闭环实施计划

## 范围
- 仅覆盖 Android 客户端与 Firebase/GCP 后端。
- 单次交付完成，不分期，不留占位代码，不留 TODO。
- 告警标准通道：Google Chat（主）+ Email（兜底）。
- 计费基线：Firebase Blaze（Pay-As-You-Go）。

## 交付物
1. Flutter 端强类型可观测性契约：
- `ErrorContext`
- `OperationContext`
- `ObservabilityTags`
- `UidHasher`
- `CorrelationIdFactory`
2. 客户端错误上报链路：
- `ErrorHandler.record(...)` 强类型上下文
- Crashlytics + Analytics `app_error` 关联字段
- PII 白名单过滤与脱敏
3. Callable 协议升级：
- `deleteAccountV1`
- `wipeUserDataV1`
- 强制入参：`correlation_id`、`uid_hash`、`operation_stage`、`retry_count`
- 统一出参：`ok`、`correlation_id`、`function_name`、`latency_ms`、`result`、`error_code?`
4. Functions 结构化日志：
- 统一使用 `firebase-functions/logger`
- 必备字段：`correlation_id`、`uid_hash`、`function_name`、`latency_ms`、`result`、`error_code`
5. AI 分诊自动化：
- 定时函数 `runAiDebugTriageV1`（每 15 分钟）
- 从 `obs.ai_debug_tasks_v1` 读取任务
- 生成报告并写入 `obs.ai_debug_reports_v1`
- 自动创建 GitHub 草稿 issue（`[DRAFT][AI-DEBUG]`）
6. BigQuery 资产：
- `functions/sql/observability/obs_schema.sql`
- `functions/sql/observability/refresh_ai_debug_tasks.sql`
- 初始化脚本 `scripts/gcp/setup_observability.sh`（支持 `ANALYTICS_DATASET` 显式绑定）
7. CI 门禁：
- `.github/workflows/ci.yml`
- 校验 analyze、测试、quality gate、无 TODO/FIXME/TBD

## 公共接口/类型变更
- `ErrorHandler.record(Object error, {required ErrorContext context, StackTrace? stackTrace, bool fatal = false})`
- `ErrorHandler.recordOperation(...)` 便捷封装
- `AccountLifecycleBackend.deleteAccountHard({required OperationContext context})`
- `AccountLifecycleBackend.wipeUserData({required OperationContext context})`

## 运行标准
- 禁止上传明文 UID/邮箱/手机号到日志、Crashlytics、Analytics。
- 统一使用 `uid_hash`。
- Google Chat 为预览能力时，Email 兜底必须常驻启用。
- `obs` 数据集必须配置预算告警和数据保留策略。

## 验证门禁
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`
- `rg -n "TODO|FIXME|TBD|占位" lib test functions/src functions/test .claude/memory`

## 验收标准
1. synthetic non-fatal 在 5 分钟内可在 Crashlytics 看见。
2. 同一 issue 在 60 分钟内可在 BigQuery 查询。
3. 删号失败可通过 `correlation_id` 端到端串联排查。
4. Callable 日志必须携带 `latency_ms` 与 `result`。
5. Google Chat 与 Email 均可收到测试告警。
6. 活跃文档与本次改动代码中无 TODO/FIXME/TBD。
