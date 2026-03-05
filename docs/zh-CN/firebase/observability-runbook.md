# Firebase/GCP 可观测性运行手册

## 目标
用于启用并验证 Hachimi 可观测性闭环的操作清单。

## 前置条件
- Firebase 项目已升级 Blaze。
- GCP 项目计费已启用。
- 已启用 Crashlytics、Analytics、Cloud Functions。
- 已准备 Google Chat 空间并创建 Cloud Monitoring 通知通道。
- 已创建 Email 兜底通知通道。

## 1）初始化 BigQuery 资产
```bash
export PROJECT_ID=<your-project-id>
export LOCATION=US
export DATASET=obs
export ANALYTICS_DATASET=analytics_<property_id> # 自动发现失败时显式指定
export TTL_DAYS=90
export BILLING_ACCOUNT_ID=<billing-account-id>
export BUDGET_AMOUNT=50

./scripts/gcp/setup_observability.sh
```

## 2）部署 Functions
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

## 3）配置 AI 分诊运行时密钥
函数运行时环境变量：
- `AI_DEBUG_MODEL_ENDPOINT`
- `AI_DEBUG_MODEL_API_KEY`
- `AI_DEBUG_MODEL_NAME`
- `AI_DEBUG_GITHUB_REPO`（`owner/repo`）
- `GITHUB_TOKEN`
- `OBS_DATASET`
- `BQ_LOCATION`

## 4）启用导出
- Crashlytics -> BigQuery
- Crashlytics -> Cloud Logging
- Analytics -> BigQuery
- Cloud Logging sink（可选）-> BigQuery

## 5）告警策略
创建/核验以下策略：
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`
- `budget_threshold`

每条策略绑定两个通道：
- Google Chat（主）
- Email（兜底）

## 6）演练验证
1. 在 App 触发 synthetic non-fatal。
2. 5 分钟内在 Crashlytics 看到事件。
3. 60 分钟内在 BigQuery 查到记录。
4. 触发 Cloud Monitoring 测试告警。
5. 确认 Google Chat 与 Email 均收到通知。
6. 确认 `runAiDebugTriageV1` 成功写入 `obs.ai_debug_reports_v1`。

## 7）故障排查流程
1. 用 `correlation_id` 关联查询 Crashlytics 与 Functions 日志。
2. 核对 `uid_hash`、`error_code`、`operation_stage`、`retry_count` 是否一致。
3. 查看 GitHub 草稿 issue 的修复建议是否可执行。
4. 指派责任人并纳入发布门禁。

## 8）成本护栏
- 保持 dataset TTL 开启。
- 预算告警阈值维持 50% / 80% / 100%。
- 定时查询周期保持 15 分钟。
- 每周复查高成本 SQL。
