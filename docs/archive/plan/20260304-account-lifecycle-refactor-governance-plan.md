# 2026-03-04 账户生命周期与仓库治理重构计划

## 范围
- 以**离线优先**重建账户生命周期。
- 清除未上线阶段的 legacy 兼容包袱。
- 在 `lib/` 手写代码执行质量红线治理。
- 按 DDD + SSOT 完成文档与长期记忆收敛。

## 质量硬阈值
- 单文件行数：`<= 800`
- 单函数行数：`<= 30`
- 嵌套层级：`<= 3`
- 分支数量：`<= 3`

## 目标架构
1. 访客升级冲突流程
- 引入快照模型：`AccountDataSnapshot`。
- Google/Email 登录成功后同时计算本地与云端快照。
- 冲突判定矩阵：
  - 本地空 + 云端有 -> 保留云端
  - 云端空 + 本地有 -> 保留本地
  - 两端都有 -> 强制弹窗二选一

2. 合并执行
- `keepCloud`：清理旧访客本地数据、hydrate 云端、重启同步。
- `keepLocal`：调用 `wipeUserDataV1`、迁移台账 UID、`ensureProfile`、回推本地数据。

3. 删号流程
- 用三段式替代重认证删号：
  - 数据摘要确认
  - 输入 `DELETE`
  - 执行删除编排
- 本地数据立即删除。
- 在线时立即硬删云端/Auth；离线时写入队列并自动重试。
- 队列键：
  - `pending_deletion_job`
  - `deletion_tombstone`
  - `deletion_retry_count`

4. Cloud Functions
- 新增 `functions/`（Node 20 + TypeScript）。
- Callable 接口：
  - `deleteAccountV1`：递归删除 `users/{uid}` + 删除 Auth 用户（幂等）
  - `wipeUserDataV1`：仅递归删除 `users/{uid}`（幂等）

5. Legacy 清理
- 移除迁移网关与迁移服务。
- 从规则与删号拓扑移除 `checkIns` 兼容路径。
- 移除未使用 `RemoteConfigService` 与 `OfflineWriteGuard`。
- 多区域后端收敛为单 Firebase 运行路径。

## 治理工作
- 新增 `tool/quality_gate.dart` 并接入 CI。
- 同步更新架构文档、Firebase 文档与根文档。
- 过时文档迁移到 `docs/archive/`，并在索引标记 Archived。
- 更新 `.claude/memory/*`，保证长期记忆与现状一致。

## 验证门禁
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`

## 交付策略
- 第一次提交（代码）：生命周期重构、云函数、测试、质量闸门。
- 第二次提交（文档）：SSOT 文档治理、归档、README/CHANGELOG/记忆更新。
- 推送 `origin/main`，不打 tag、不发 release。
