# 云端凭据与 GitHub Secrets 配置指南

## 目标
本文件是以下内容的 SSOT：
- GCP/Firebase 云端凭据配置
- Secret Manager 密钥托管策略
- GitHub Actions Secrets 配置
- 轮换、吊销与排障

范围对齐当前仓库实现（截至 2026-03-05）。

---

## 1. 凭据模型（三个平面）

1. 操作平面（人）
- 你在本机执行初始化/部署命令时使用。
- 工具：`gcloud`、`firebase`、`bq`、`gh`。

2. 运行平面（Cloud Functions）
- 已部署函数运行时使用。
- 当前实现通过 [functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts) 的 `process.env` 读取。

3. CI/CD 平面（GitHub Actions）
- `.github/workflows/release.yml` 在构建/签名/发布时使用。
- 使用 GitHub Secrets（加内置 `GITHUB_TOKEN`）。

---

## 2. 本机操作凭据基线

每台机器执行一次：

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project <PROJECT_ID>
firebase login
gh auth login
```

验证：

```bash
gcloud auth list
gcloud config get-value project
gcloud auth application-default print-access-token >/dev/null && echo "ADC OK"
firebase projects:list | head
gh auth status
```

---

## 3. GCP/Firebase 运行时凭据

## 3.1 当前 Functions 代码需要的环境变量

定义位置：[functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts)

| 变量 | 必填 | 用途 |
|---|---|---|
| `OBS_DATASET` | 是 | 可观测性 BigQuery 数据集（默认 `obs`） |
| `BQ_LOCATION` | 是 | BigQuery 查询地域（分诊任务使用） |
| `AI_DEBUG_TRIAGE_LIMIT` | 否 | 单次分诊任务数量（默认 `25`） |
| `AI_DEBUG_MODEL_NAME` | 否 | 记录到报告中的模型名 |
| `AI_DEBUG_MODEL_ENDPOINT` | 可选 | AI 推理端点（未配置时走启发式回退） |
| `AI_DEBUG_MODEL_API_KEY` | 可选 | AI 端点密钥 |
| `AI_DEBUG_GITHUB_REPO` | 可选 | 草稿 issue 目标仓库，格式 `owner/repo` |
| `GITHUB_TOKEN` | 可选 | 分诊任务创建草稿 issue 的 token |

注意：若未配置 `AI_DEBUG_MODEL_ENDPOINT` / `AI_DEBUG_MODEL_API_KEY`，分诊任务仍可运行，但输出为启发式建议。

## 3.2 Secret Manager 作为唯一真值

创建密钥（示例名）：

```bash
PROJECT_ID=<PROJECT_ID>

printf '%s' '<AI_ENDPOINT>' | gcloud secrets create ai-debug-model-endpoint --data-file=- --project "$PROJECT_ID"
printf '%s' '<AI_API_KEY>'  | gcloud secrets create ai-debug-model-api-key  --data-file=- --project "$PROJECT_ID"
printf '%s' '<OWNER/REPO>'  | gcloud secrets create ai-debug-github-repo    --data-file=- --project "$PROJECT_ID"
printf '%s' '<GH_TOKEN>'    | gcloud secrets create ai-debug-github-token   --data-file=- --project "$PROJECT_ID"
```

轮换时新增版本：

```bash
printf '%s' '<NEW_VALUE>' | gcloud secrets versions add ai-debug-model-api-key --data-file=- --project "$PROJECT_ID"
```

授权运行时服务账号读取（替换为你的实际 Functions Runtime SA）：

```bash
FUNCTIONS_SA=<functions-runtime-service-account-email>

gcloud secrets add-iam-policy-binding ai-debug-model-endpoint \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-model-api-key \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-github-repo \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-github-token \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"
```

## 3.3 安全部署注入（与当前代码实现对齐）

当前代码读取 `process.env`，可执行且安全的部署方式是：
1. 从 Secret Manager 读取真实值；
2. 仅在部署前临时生成 `functions/.env.<PROJECT_ID>`；
3. 部署后删除本地 env 文件。

示例：

```bash
PROJECT_ID=<PROJECT_ID>

get_secret() {
  gcloud secrets versions access latest --secret "$1" --project "$PROJECT_ID" | tr -d '\n'
}

cat > "functions/.env.${PROJECT_ID}" <<EOF
OBS_DATASET=obs
BQ_LOCATION=US
AI_DEBUG_TRIAGE_LIMIT=25
AI_DEBUG_MODEL_NAME=gemini-prod
AI_DEBUG_MODEL_ENDPOINT=$(get_secret ai-debug-model-endpoint)
AI_DEBUG_MODEL_API_KEY=$(get_secret ai-debug-model-api-key)
AI_DEBUG_GITHUB_REPO=$(get_secret ai-debug-github-repo)
GITHUB_TOKEN=$(get_secret ai-debug-github-token)
EOF

firebase deploy --only functions --project "$PROJECT_ID"
rm -f "functions/.env.${PROJECT_ID}"
```

## 3.4 可观测性初始化脚本所需权限

脚本：[scripts/gcp/setup_observability.sh](/data/workspace/hachimi-app/scripts/gcp/setup_observability.sh)

执行身份需具备以下能力：
- 创建/更新 BigQuery dataset、table、view；
- 创建 scheduled query transfer；
- （如传入 `BILLING_ACCOUNT_ID`）创建/更新预算告警。

推荐命令：

```bash
PROJECT_ID=<project-id> \
LOCATION=US \
DATASET=obs \
ANALYTICS_DATASET=analytics_<property_id> \
TTL_DAYS=90 \
BILLING_ACCOUNT_ID=<billing-account-id> \
BUDGET_AMOUNT=50 \
./scripts/gcp/setup_observability.sh
```

---

## 4. GitHub Actions Secrets（当前 release workflow 必需）

工作流：[.github/workflows/release.yml](/data/workspace/hachimi-app/.github/workflows/release.yml)

| Secret | 必需 | 用途 |
|---|---|---|
| `GOOGLE_SERVICES_JSON` | 是 | 解码为 `android/app/google-services.json` |
| `FIREBASE_OPTIONS_DART` | 是 | 解码为 `lib/firebase_options.dart` |
| `KEYSTORE_BASE64` | 是 | 解码 Android 签名 keystore |
| `KEYSTORE_PASSWORD` | 是 | Android 签名 |
| `KEY_ALIAS` | 是 | Android 签名 |
| `KEY_PASSWORD` | 是 | Android 签名 |
| `MINIMAX_API_KEY` | 是 | release 构建 `--dart-define` |
| `GEMINI_API_KEY` | 是 | release 构建 `--dart-define` |
| `WIF_PROVIDER` | 是 | OIDC 方式登录 Google Cloud |
| `WIF_SERVICE_ACCOUNT` | 是 | WIF 对应服务账号 |

说明：
- 发布 release 时使用的 `GITHUB_TOKEN` 是 GitHub Actions 内置 token，不需要手工创建。
- WIF 的完整配置流程见 [docs/release/google-play-setup.md](/data/workspace/hachimi-app/docs/release/google-play-setup.md)。

## 4.1 安全生成 Base64

Linux：

```bash
base64 -w 0 android/app/google-services.json > /tmp/google-services.b64
base64 -w 0 lib/firebase_options.dart > /tmp/firebase-options.b64
base64 -w 0 android/app/hachimi-release.jks > /tmp/keystore.b64
```

macOS：

```bash
base64 < android/app/google-services.json | tr -d '\n' > /tmp/google-services.b64
base64 < lib/firebase_options.dart | tr -d '\n' > /tmp/firebase-options.b64
base64 < android/app/hachimi-release.jks | tr -d '\n' > /tmp/keystore.b64
```

## 4.2 用 GitHub CLI 写入 Secrets

```bash
gh secret set GOOGLE_SERVICES_JSON < /tmp/google-services.b64
gh secret set FIREBASE_OPTIONS_DART < /tmp/firebase-options.b64
gh secret set KEYSTORE_BASE64 < /tmp/keystore.b64

printf '%s' '<KEYSTORE_PASSWORD>' | gh secret set KEYSTORE_PASSWORD
printf '%s' '<KEY_ALIAS>'         | gh secret set KEY_ALIAS
printf '%s' '<KEY_PASSWORD>'      | gh secret set KEY_PASSWORD
printf '%s' '<MINIMAX_API_KEY>'   | gh secret set MINIMAX_API_KEY
printf '%s' '<GEMINI_API_KEY>'    | gh secret set GEMINI_API_KEY
printf '%s' '<WIF_PROVIDER>'      | gh secret set WIF_PROVIDER
printf '%s' '<WIF_SERVICE_ACCOUNT>' | gh secret set WIF_SERVICE_ACCOUNT
```

若采用 environment 级 secret（推荐 release 使用 `production` 环境）：

```bash
gh secret set MINIMAX_API_KEY --env production
```

---

## 5. 最小权限建议（IAM 职责拆分）

建议至少拆为三个身份：
1. `ops-observability`：仅负责可观测性初始化（dataset/sql/告警/预算）。
2. `functions-runtime`：仅负责运行时 BigQuery 写入 + Secret 读取。
3. `github-release`（WIF 映射 SA）：仅负责发布与上传职责。

禁止三类职责共用同一个高权限管理员身份。

---

## 6. 密钥轮换与吊销

## 6.1 轮换周期建议
- AI endpoint/API key：90 天。
- AI 分诊 GitHub token：30~60 天。
- Android 签名相关：按公司策略或事件响应触发。

## 6.2 运行时密钥轮换流程
1. 在 Secret Manager 新增版本；
2. 重新部署 Functions 使运行时读取新值；
3. 检查 `runAiDebugTriageV1` 成功日志；
4. 下线旧版本。

## 6.3 泄露应急流程
1. 立即禁用泄露版本；
2. 立即删除/替换对应 GitHub Secret；
3. 重新发放并部署；
4. 审计泄露时间窗口内的访问日志。

---

## 7. 验收清单

1. `firebase deploy --only functions` 成功。
2. `runAiDebugTriageV1` 无 auth/env 报错。
3. 配置 GitHub token + repo 后可创建 draft issue。
4. 打 tag (`vX.Y.Z`) 触发 release workflow 时无缺失 secret。
5. 仓库无明文密钥提交（`.env*`、`google-services.json`、`firebase_options.dart`、keystore 均被忽略）。

---

## 8. 常见故障

| 现象 | 常见原因 | 修复 |
|---|---|---|
| GitHub Actions 报 `Missing secret ...` | Secret 名称不一致 | 对照 release workflow 中的精确 key |
| AI 分诊只产出 heuristic | 未配置 AI endpoint 或 API key | 设置 `AI_DEBUG_MODEL_ENDPOINT` + `AI_DEBUG_MODEL_API_KEY` |
| 没有创建 GitHub draft issue | `GITHUB_TOKEN` 缺失或 `AI_DEBUG_GITHUB_REPO` 格式错误 | 补齐并确认 `owner/repo` |
| BigQuery 报 location mismatch | `BQ_LOCATION` 与数据集地域不一致 | 将 `BQ_LOCATION` 设为数据集真实地域 |
| 初始化脚本在 Analytics 视图失败 | 未指定/识别 `ANALYTICS_DATASET` | 显式传入 `ANALYTICS_DATASET=analytics_<property_id>` |
