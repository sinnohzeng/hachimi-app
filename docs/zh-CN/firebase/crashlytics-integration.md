# Crashlytics 集成

## 当前错误链路
- 非致命错误统一通过 `ErrorHandler.record(...)` 上报。
- Flutter 框架错误接入 `FirebaseCrashlytics.instance.recordFlutterFatalError`。
- 异步平台错误通过 `PlatformDispatcher.instance.onError` 捕获。

## 建议上报位置
- 服务层失败（同步、认证编排、删号编排）。
- 发生降级回退但流程继续的 catch 分支。
- 永久同步失败与删号重试失败。

## 已移除内容
- `OfflineWriteGuard` 已从运行时架构移除。
- 离线韧性由 SQLite 台账 + 删号 pending 队列编排承担。

## 验证
```bash
# 在调试包触发测试崩溃
FirebaseCrashlytics.instance.crash();
```
在 Firebase Console -> Crashlytics 验证。

## 运维说明
删号失败建议在 `AccountDeletionOrchestrator` 记录：
- 操作名
- 重试次数
- 错误码/错误类型
