# Firebase/GCP 可观测性运行手册

## 目标
用于落地 Hachimi 可观测性闭环：
- Crashlytics + Cloud Logging + BigQuery
- AI 分诊（`runAiDebugTriageV2`）
- Google Chat + Email 告警

## 前置条件
1. Firebase 已升级 Blaze。
2. Android 已启用 App Check（release 使用 Play Integrity）。
3. Firebase AI Logic 已启用（Vertex provider）。
4. Google Chat 空间已创建并安装 Monitoring 应用。
5. Email 兜底通知通道已配置。

## 1）通过 Terraform 初始化
```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

必须填写的 tfvars：
- `project_id`
- `analytics_dataset`
- `chat_notification_channel_ids`
- `alert_email`
- `billing_account_id`

## 2）部署 Functions
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

## 3）运行时参数与密钥校验
确认参数存在：
- `OBS_DATASET`
- `BQ_LOCATION`
- `AI_DEBUG_TRIAGE_LIMIT`
- `TRIAGE_MODEL`
- `TRIAGE_VERTEX_LOCATION`
- `AI_DEBUG_GITHUB_REPO`
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`

确认 Secret 参数存在：
- `GITHUB_APP_PRIVATE_KEY`

## 4）导出与数据面检查
1. 已启用 Crashlytics -> BigQuery
2. 已启用 Crashlytics -> Cloud Logging
3. 已启用 Analytics -> BigQuery
4. Logging sink 正常写入 `obs` 数据集

## 5）告警策略检查
必须存在的策略名：
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`

每条策略都必须绑定：
- Google Chat 通道
- Email 兜底通道

预算护栏通过 Billing Budget 资源（`hachimi-observability-budget`）实现，通知通道使用 Email。

## 6）演练验证
1. 在 App 触发 synthetic non-fatal。
2. 5 分钟内在 Crashlytics 可见。
3. 60 分钟内在 BigQuery 可查。
4. 在 Cloud Monitoring 触发测试告警。
5. 确认 Google Chat 与 Email 均收到。
6. 确认 `runAiDebugTriageV2` 写入 `obs.ai_debug_reports_v1`。
7. 确认 GitHub App 鉴权可创建草稿 issue。

## 7）故障排查流程
1. 从告警入手。
2. 通过 `correlation_id` 串联 Crashlytics 与 Functions 日志。
3. 校验 `uid_hash` / `operation_stage` / `error_code` 一致性。
4. 查看 AI 分诊报告和草稿工单。
5. 指派责任人并纳入发布门禁。

## 8）成本护栏
1. 保持 BigQuery TTL 开启。
2. 保持预算阈值 50/80/100%。
3. 定时查询频率保持 15 分钟。
4. 每周复查高成本 SQL。
