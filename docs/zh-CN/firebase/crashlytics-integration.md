# Crashlytics 集成

## 当前错误契约
- 所有捕获异常必须通过带 `ErrorContext` 的 `ErrorHandler.record(...)` 上报。
- `ErrorContext` 必填字段：
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

## 身份与隐私
- Crashlytics 用户标识必须使用哈希（`uid_hash`）。
- 禁止将明文 UID、邮箱、手机号写入 custom key。
- 自定义字段通过 `ObservabilityTags` 白名单过滤。

## 运行时接入点
- Flutter 框架级致命错误统一走 `ErrorHandler.recordOperation(..., fatal: true)`。
- 平台异步致命错误统一走 `ErrorHandler.recordOperation(..., fatal: true)`。
- Service/Provider 领域层非致命错误统一走 `ErrorHandler.recordOperation(...)`。

## 关联追踪
在账户生命周期和重试链路中：
- 客户端错误事件必须带 `correlation_id`
- callable 请求必须传 `OperationContext`
- 函数日志必须使用同一个 `correlation_id`

## 验证
```bash
# 在应用代码路径触发 synthetic non-fatal，
# 然后验证 Crashlytics 看板与 BigQuery 导出。
```

验证目标：
1. 5 分钟内在 Crashlytics 可见。
2. 60 分钟内在 BigQuery 可查。
3. callable 失败时可通过 `correlation_id` 串联函数日志。
