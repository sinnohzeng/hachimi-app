# 2026-03-05 执行计划：云端凭据与 AI 安全现代化整改

## 摘要
本计划是 Hachimi 从“客户端静态 AI Key + 手工轮换长期密钥”迁移到“Google 原生短期身份 + IaC 治理”的唯一真值文档。

核心方向：
- AI 路径统一为 Firebase AI Logic + Vertex AI
- 敏感 callable 强制 App Check
- GitHub 鉴权改为 GitHub App 安装令牌（不再使用长期 PAT）
- Terraform 作为可观测与安全资源的长期控制面
- 告警通道固定为 Google Chat + Email

## 范围
本次一次性交付包含：
1. Flutter(Android) AI 与安全运行时迁移
2. Firebase Functions V2 安全契约与 GitHub App 鉴权
3. Terraform IaC（obs 数据面、告警、预算、Secrets、IAM）
4. CI/CD 凭据治理与 release secret 健康检查
5. 中英文 DDD/SSOT 文档同步
6. 长期记忆同步

不包含：
1. iOS/Web 代码改造
2. AI 自动合并/自动发布

## 最终架构契约
1. AI 提供商：仅保留 `firebase_gemini`（Firebase AI Logic）
2. 敏感 callable：
- `deleteAccountV2`
- `wipeUserDataV2`
3. App Check：
- Android release：Play Integrity
- Debug：Debug provider
- 敏感 callable 使用 limited-use token
4. Functions 配置：
- 参数化配置 + Secret 参数
- 不依赖客户端静态 AI key
5. GitHub 鉴权：
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`
- `GITHUB_APP_PRIVATE_KEY`（Secret Manager）
6. 告警通道：
- 仅 `Google Chat + Email`

## IaC 交付物
目录：
- `infra/terraform/modules/observability`
- `infra/terraform/envs/prod`

托管资源：
1. BigQuery 数据集与可观测对象：
- `issue_daily_v1`
- `issue_velocity_v1`
- `issue_user_impact_v1`
- `flow_error_funnel_v1`
- `release_stability_v1`
- `ai_debug_tasks_v1`
- `ai_debug_reports_v1`
2. 定时 SQL 刷新（每 15 分钟）
3. Cloud Logging 到 BigQuery sink
4. Monitoring 告警策略与通知绑定
5. Billing 预算与阈值规则
6. Secret Manager 与 IAM 最小权限拆分

输出契约：
- `obs_dataset_id`
- `notification_channel_ids`
- `alert_policy_ids`
- `budget_id`

## 你需要手工配合（最小集合）
项目负责人仅需一次性完成：
1. Google Chat：
- 创建空间：
  - `hachimi-alerts-prod-p1`
  - `hachimi-alerts-prod-ops`
- 每个空间安装 Google Cloud Monitoring 应用
- 提供 Monitoring notification channel ID
2. GitHub：
- 创建 GitHub App（最小权限）
  - `Issues: Read & Write`
  - `Metadata: Read-only`
- 安装到 `sinnohzeng/hachimi-app`
- 提供：
  - `APP_ID`
  - `INSTALLATION_ID`
  - `PRIVATE_KEY_PEM`
3. Firebase/GCP：
- 为 Android 应用启用 App Check（Play Integrity）
- 完成 Firebase AI Logic 首次向导（Vertex provider）
- 批准 Terraform/部署身份所需 IAM 授权

## 已锁定执行输入（2026-03-05）
1. 项目与计费：
- `PROJECT_ID=hachimi-ai`（单环境 prod）
- `BILLING_ACCOUNT_ID=billingAccounts/01E301-C31477-88FDAB`
2. GitHub App：
- `APP_ID=3015633`
- `INSTALLATION_ID=114226962`
- 私钥文件：`/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem`
3. Google Chat 通道：
- prod ops：`projects/hachimi-ai/notificationChannels/7202234633594020254`
- prod p1：`projects/hachimi-ai/notificationChannels/7564813615993522229`

## 当前剩余人工事项
1. Firebase Console 开启 Android App Check（Play Integrity）。
2. Firebase Console 完成 Firebase AI Logic 首次开通（Vertex provider）。
3. 确认 Crashlytics/Analytics BigQuery 导出均已启用并已产生数据集/数据表。
4. 回填 `infra/terraform/envs/prod/terraform.tfvars`：
   - `analytics_dataset = "analytics_<real_property_id>"`
   - `enable_export_dependent_resources = true`
5. 执行 `cd infra/terraform/envs/prod && terraform apply` 完成导出依赖对象落地。

## 由仓库改造自动完成的内容
1. 客户端 AI provider 迁移
2. App Check 运行时接入与 limited-use token 路径
3. Functions V2 callable 与 AI 分诊后端加固
4. GitHub App 安装令牌链路
5. release workflow secrets 健康检查
6. Terraform 资源定义与输出契约
7. 中英文文档与长期记忆同步

## 验收标准
1. 无有效 App Check 的 `deleteAccountV2/wipeUserDataV2` 调用必须拒绝
2. AI 功能可用且不依赖客户端静态 AI key
3. `runAiDebugTriageV2` 可写表并通过 GitHub App 创建草稿 issue
4. 告警演练可同时触达 Google Chat 与 Email
5. 日志与报表中无明文 UID/邮箱/手机号
6. 质量门禁通过：
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`
- `terraform fmt -check`
