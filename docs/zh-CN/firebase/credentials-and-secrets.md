# 云端凭据与 Secrets（Google 优先、低维护）

## 目的
本文件是 2026-03-05 安全现代化整改后的凭据配置 SSOT。

目标：
1. 客户端不再持有长期静态 AI API Key。
2. 优先使用短期身份（OIDC/WIF/ADC），尽量不用可拷贝密钥文件。
3. 手工步骤最小化且尽量一次性。
4. Secret Manager + Terraform 作为长期控制面。

---

## 1. 凭据模型（三个平面）

1. 操作平面（人）
- 你在本机通过 `gcloud`/`firebase`/`gh` 登录。
- 用于初始化与 Terraform apply。

2. 运行平面（Cloud Functions）
- 使用 Google 托管服务账号身份（ADC/IAM）。
- Vertex AI 调用走 IAM token，不用 API key。
- GitHub App 私钥从 Secret Manager 读取。

3. CI/CD 平面（GitHub Actions）
- 使用 Workload Identity Federation（`WIF_PROVIDER`、`WIF_SERVICE_ACCOUNT`）。
- 不在 GitHub Secrets 存服务账号 JSON 密钥。

---

## 2. 你必须一次性手工完成的事项

以下操作不能完全 API 代劳，需要你作为项目所有者执行：

1. Google Chat
- 创建空间：
  - `hachimi-alerts-prod-p1`
  - `hachimi-alerts-prod-ops`
- 每个空间安装 Google Cloud Monitoring 应用。
- 在 Monitoring 中创建通知通道并记录 channel ID。

2. GitHub App
- 创建 GitHub App（最小权限）：
  - `Issues: Read & Write`
  - `Metadata: Read-only`
- 安装到 `sinnohzeng/hachimi-app`。
- 提供：
  - `APP_ID`
  - `INSTALLATION_ID`
  - `PRIVATE_KEY_PEM`

3. Firebase/GCP 控制台初始化
- 启用 Firebase App Check（Android Play Integrity；Debug 环境用 Debug provider）。
- 完成 Firebase AI Logic 首次向导（Vertex provider）。
- 批准 Terraform/部署身份所需 IAM 授权。

### 2.1 你当前进度（2026-03-05）
- 已确认目标项目：`hachimi-ai`（单环境 prod）。
- 已确认计费账号：`billingAccounts/01E301-C31477-88FDAB`（`billingEnabled=true`）。
- 已有 `APP_ID = 3015633`。
- 你提供的安装页链接是 `https://github.com/settings/installations/114226962`。
- 该链接末尾数字就是 `INSTALLATION_ID`，即 `114226962`。
- 你当前私钥文件位置：`/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem`。
- 已确认 Google Chat Monitoring channel：
  - `hachimi-alerts-prod-ops`:
    `projects/hachimi-ai/notificationChannels/7202234633594020254`
  - `hachimi-alerts-prod-p1`:
    `projects/hachimi-ai/notificationChannels/7564813615993522229`

> 安全提醒：私钥文件不要长期放在仓库目录。建议写入 Secret Manager 后，从仓库目录删除本地副本。

---

## 3. 本机凭据基线

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
gcloud auth application-default print-access-token >/dev/null && echo "ADC OK"
gcloud config get-value project
firebase projects:list | head
gh auth status
```

---

## 4. Functions 运行时凭据

代码来源：[functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts)

### 4.1 参数化配置
- `OBS_DATASET`
- `BQ_LOCATION`
- `AI_DEBUG_TRIAGE_LIMIT`
- `TRIAGE_MODEL`
- `TRIAGE_VERTEX_LOCATION`
- `AI_DEBUG_GITHUB_REPO`
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`

### 4.2 Secret 参数
- `GITHUB_APP_PRIVATE_KEY`（Secret Manager）

### 4.3 敏感 callable 安全契约
- `deleteAccountV2`、`wipeUserDataV2`：
  - `enforceAppCheck: true`
  - `consumeAppCheckToken: true`
- 客户端调用启用 `limitedUseAppCheckToken: true`。

---

## 5. GitHub Release 所需 Secrets

工作流：[.github/workflows/release.yml](/data/workspace/hachimi-app/.github/workflows/release.yml)

必需：
- `GOOGLE_SERVICES_JSON`
- `FIREBASE_OPTIONS_DART`
- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `WIF_PROVIDER`
- `WIF_SERVICE_ACCOUNT`

已不再需要：
- 旧版客户端 AI key secrets（已废弃）

发布前强制执行 secrets 健康检查：
- [tool/check_release_secrets.sh](/data/workspace/hachimi-app/tool/check_release_secrets.sh)

---

## 6. GitHub App 凭据落地

### 6.1 将 GitHub App 私钥写入 Secret Manager（推荐）

```bash
PROJECT_ID=<PROJECT_ID>

printf '%s' '<PRIVATE_KEY_PEM>' | gcloud secrets create GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" --data-file=-
```

若 secret 已存在，轮换时新增版本：

```bash
printf '%s' '<NEW_PRIVATE_KEY_PEM>' | gcloud secrets versions add GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" --data-file=-
```

### 6.2 配置 Functions 的非密钥参数

通过 Firebase 参数化配置或部署时参数注入设置：
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`
- `AI_DEBUG_GITHUB_REPO`

### 6.3 运行时 IAM 授权

```bash
gcloud secrets add-iam-policy-binding GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" \
  --member "serviceAccount:<FUNCTIONS_RUNTIME_SA>" \
  --role roles/secretmanager.secretAccessor
```

---

## 7. Terraform 作为长期资源入口

目录：
- [infra/terraform/README.md](/data/workspace/hachimi-app/infra/terraform/README.md)

Terraform 托管：
1. `obs` BigQuery 数据集与视图/表
2. 定时 SQL（每 15 分钟）
3. Logging sink 到 BigQuery
4. Monitoring 通道与告警策略（Google Chat IDs + Email）
5. Budget 与阈值策略
6. Secret Manager 与 IAM 最小权限拆分

执行（prod）：

```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

当前仓库的 `prod` 配置已默认：
- `PROJECT_ID=hachimi-ai`
- `enable_export_dependent_resources=false`（先落地不依赖导出的基础设施）
- `enable_budget_metric_alert=false`（预算通过 Billing Budget + Email 通知）

在首次 `terraform apply` 前，先做导出数据集预检查（否则部分 BigQuery 视图会创建失败）：

```bash
PROJECT_ID=hachimi-ai

# Crashlytics 导出
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.firebase_crashlytics.INFORMATION_SCHEMA.TABLES`
LIMIT 1;
SQL

# Analytics 导出（将 analytics_xxx 替换成你的真实 dataset）
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_xxx.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 1;
SQL
```

若报 `Dataset ... was not found` 或 `... does not match any table`，先在 Firebase Console 打开对应 BigQuery 导出，再回到 Terraform。

导出就绪后，再做一次收口：

```bash
# 1) 更新 infra/terraform/envs/prod/terraform.tfvars
#    - analytics_dataset = "analytics_<real_property_id>"
#    - enable_export_dependent_resources = true

cd infra/terraform/envs/prod
terraform plan
terraform apply
```

---

## 8. GitHub Secrets CLI 配置示例

```bash
gh secret set GOOGLE_SERVICES_JSON < /tmp/google-services.b64
gh secret set FIREBASE_OPTIONS_DART < /tmp/firebase-options.b64
gh secret set KEYSTORE_BASE64 < /tmp/keystore.b64

printf '%s' '<KEYSTORE_PASSWORD>' | gh secret set KEYSTORE_PASSWORD
printf '%s' '<KEY_ALIAS>'         | gh secret set KEY_ALIAS
printf '%s' '<KEY_PASSWORD>'      | gh secret set KEY_PASSWORD
printf '%s' '<WIF_PROVIDER>'      | gh secret set WIF_PROVIDER
printf '%s' '<WIF_SERVICE_ACCOUNT>' | gh secret set WIF_SERVICE_ACCOUNT
```

---

## 9. 轮换与吊销策略

1. 客户端 AI key
- 已从发布主路径移除，无需周期轮换。

2. GitHub App 私钥
- 按风险或审计策略轮换。
- 通过 Secret Manager 版本化轮换。

3. WIF
- 无需轮换 secret 值，重点维护信任策略与最小权限。

4. 应急响应
- 立即禁用泄露 secret 版本。
- 重新部署 Functions。
- 审计泄露窗口期 Cloud Logging 访问记录。

---

## 10. 验收清单

1. Functions 部署运行无参数/密钥缺失报错。
2. `deleteAccountV2` / `wipeUserDataV2` 在无有效 App Check 时拒绝请求。
3. AI 分诊可写入 `obs.ai_debug_reports_v1`。
4. GitHub 草稿 issue 可通过 GitHub App 鉴权创建。
5. Release workflow 通过 secrets 健康检查并完成构建。
6. 日志和报表中无明文 UID/邮箱/手机号。

---

## 11. 常见问题

| 现象 | 原因 | 处理 |
|---|---|---|
| V2 callable 报 `permission-denied` | App Check 缺失/失效/重放 | 确认开启 App Check 且客户端使用 limited-use token |
| 分诊无法建单 | GitHub App 参数或私钥错误 | 检查 `GITHUB_APP_ID`、`GITHUB_APP_INSTALLATION_ID`、`GITHUB_APP_PRIVATE_KEY` |
| Vertex 始终 fallback | Runtime SA 缺少 Vertex 权限 | 授予 `roles/aiplatform.user` |
| Terraform 告警配置失败 | Chat channel ID 未准备 | 先在 Monitoring 绑定 Chat 空间后填入 tfvars |
| Release 被 secrets check 拦截 | 缺少必需 secrets | 按第 5 节补齐 |

---

## 12. 超详细操作教程（面向第一次操作的独立开发者）

本节按“从零到可用”顺序写，照做即可。

### 12.1 GitHub App：完整创建流程

1. 打开 GitHub 网页右上角头像 -> `Settings`。
2. 左侧滚动到最下方 -> `Developer settings`。
3. 点击 `GitHub Apps` -> 右上角 `New GitHub App`。
4. 表单建议填写：
- `GitHub App name`: `hachimi-ai-debug-bot`（如果重名，后面加日期）
- `Homepage URL`: 你的仓库地址（例如 `https://github.com/sinnohzeng/hachimi-app`）
- `Webhook`: 可以先不启用（本项目不依赖 webhook）
5. 设置权限（只给最小权限）：
- Repository permissions:
  - `Issues`: `Read and write`
  - `Metadata`: `Read-only`
6. 其他权限全部保持 `No access`。
7. 点击页面底部 `Create GitHub App`。
8. 创建后点击左侧 `Install App`。
9. 选择安装到账号 `sinnohzeng`，并只安装到仓库 `hachimi-app`（不要 All repositories）。

### 12.2 `APP_ID` 在哪里看

1. 进入刚创建的 GitHub App 页面。
2. 在 `About` 区域可看到 `App ID`。
3. 你当前值已确认：`3015633`。

### 12.3 `INSTALLATION_ID` 在哪里看（你问的重点）

方法 A（最直观，推荐）：
1. 打开 App 的 `Install App` 页面。
2. 点进该安装记录后，地址栏会类似：
   `https://github.com/settings/installations/114226962`
3. 最后的数字就是 `INSTALLATION_ID`。
4. 你当前就是：`114226962`。

方法 B（给以后排查）：
1. 在安装详情页里，查看安装目标仓库是否是 `sinnohzeng/hachimi-app`。
2. 只要仓库正确，这个 `INSTALLATION_ID` 就是我们要的值。

### 12.4 `PRIVATE_KEY_PEM` 如何处理才安全

你已经下载到：
`/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem`

建议流程：
1. 先把私钥写入 Secret Manager。
2. 验证写入成功。
3. 删除仓库目录中的私钥文件。

示例命令：

```bash
PROJECT_ID=<你的GCP项目ID>
KEY_FILE=/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem

# 若 secret 不存在则创建（存在会报错，可忽略）
gcloud secrets create GITHUB_APP_PRIVATE_KEY \
  --replication-policy=automatic \
  --project "$PROJECT_ID" || true

# 新增一个版本（真正写入）
gcloud secrets versions add GITHUB_APP_PRIVATE_KEY \
  --data-file="$KEY_FILE" \
  --project "$PROJECT_ID"
```

完成后：

```bash
rm -f /data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem
```

### 12.5 Monitoring 的 `notification channel id` 在哪里找

先澄清：  
`Google Chat space id`（你给的 `AAQA...`）不等于 Monitoring 的 notification channel id。  
Terraform 需要的是这种格式：
`projects/<PROJECT_ID>/notificationChannels/<NUMERIC_ID>`

#### 方法 A：控制台查找（推荐）

1. 打开 Google Cloud Console。
2. 左上角菜单 -> `Monitoring`。
3. 左侧进入 `Alerting`。
4. 点击 `Edit notification channels`（编辑通知渠道）。
5. 在 `Google Chat` 分组里，确认 2 个通道都已创建（建议 display name 分别对应）：
- `hachimi-alerts-prod-p1`
- `hachimi-alerts-prod-ops`
6. 点开某个通道详情，找到 `Channel ID` 或 `Resource name` 字段。
7. 复制完整值，形如：
`projects/my-project/notificationChannels/1234567890123456789`
8. 对 2 个通道重复，拿到 2 个 channel id。

#### 方法 B：命令行查找（已安装 gcloud 时）

```bash
PROJECT_ID=<你的GCP项目ID>

gcloud beta monitoring channels list \
  --project "$PROJECT_ID" \
  --format="table(name,displayName,type,enabled)"
```

输出里的 `name` 列就是我们要的 channel id（完整资源名）。

你当前已验证通过的 prod channel id（可直接用于 Terraform）：

```text
projects/hachimi-ai/notificationChannels/7564813615993522229  # hachimi-alerts-prod-p1
projects/hachimi-ai/notificationChannels/7202234633594020254 # hachimi-alerts-prod-ops
```

### 12.6 如何把 channel id 填到 Terraform（单环境 prod）

编辑 `infra/terraform/envs/prod/terraform.tfvars`：

```hcl
chat_notification_channel_ids = [
  "projects/hachimi-ai/notificationChannels/7564813615993522229",
  "projects/hachimi-ai/notificationChannels/7202234633594020254"
]
```

### 12.7 你下一步只要给我的信息

你已经把 GitHub App 与 Google Chat channel 信息提供齐全。  
当前只剩下以下必须手工确认项：

1. 在 Firebase Console 完成：
   - App Check（Android Play Integrity）
   - Firebase AI Logic（Vertex provider）首次开通
2. 确认 Crashlytics 与 Analytics 的 BigQuery 导出都已开启且已产出表：
   - `firebase_crashlytics.*`
   - `analytics_xxx.events_*`
3. 回填 `infra/terraform/envs/prod/terraform.tfvars`：
   - `analytics_dataset = "analytics_<real_property_id>"`
   - `enable_export_dependent_resources = true`
4. 执行一次：
   - `cd infra/terraform/envs/prod && terraform apply`

---

## 13. 三件手工事项超详细操作（单环境 prod：`hachimi-ai`）

本节只讲你现在还需要手工完成的 3 件事。  
每一件都按“入口在哪里 -> 点哪里 -> 填什么 -> 怎么确认成功”给出。

### 13.1 事项 1：Firebase App Check（Android + Play Integrity）

目标：让 `deleteAccountV2`、`wipeUserDataV2` 等敏感 callable 只接受有效 App Check token，拦截伪造请求和重放。

#### A. 在哪里操作
1. 打开 Firebase 控制台：`https://console.firebase.google.com/`
2. 选择项目：`hachimi-ai`
3. 左侧菜单：`Build` -> `App Check`
4. 进入 Android 应用卡片（包名应与当前 App 一致）

#### B. 怎么配置
1. 点击 `Register` 或 `Manage`（如果之前已注册）。
2. Provider 选择：`Play Integrity`（生产）。
3. 开发/本地调试继续使用 Debug provider（代码已支持），不要在本地强制用 Play Integrity。
4. 在 App Check 的 API 保护列表里，至少覆盖：
- Cloud Functions（必须）
- 你实际使用且希望防滥用的其他 Firebase 资源（可选，按需）

#### B1. `SHA-256 certificate fingerprint` 到底填哪个
1. 生产发版走 Google Play（推荐）：
- 填 `Play App Signing` 的 **App signing key certificate SHA-256**。
- 不要误填 Upload key（上传密钥）当成生产签名密钥。
2. 你只做本地/侧载 release 包测试：
- 填你当前 release keystore 对应的 SHA-256。
3. 本地 debug：
- 不建议用 Play Integrity，直接用 Debug provider。
- Debug keystore 的 SHA-256可以保留（给其他 Firebase 场景），但不是你生产防护主路径。
4. 一个 Android App 可以同时登记多个 SHA 指纹（例如 Play 签名 + 本地 release 签名）。

#### B2. SHA-256 从哪里找
1. Play App Signing 证书（生产最重要）：
- 打开 Play Console -> `Test and release` -> `App integrity`。
- 在 `App signing key certificate` 区域复制 `SHA-256`。
2. 本地 release keystore：
```bash
keytool -list -v -keystore <release-keystore.jks> -alias <key-alias> | rg "SHA256|SHA-256"
```
3. 本地 debug keystore（仅开发参考）：
```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android -keypass android | rg "SHA256|SHA-256"
```
4. 也可用 Gradle 一次看多变体签名：
```bash
cd android
./gradlew signingReport
```

#### B3. 在 Firebase 哪里填 SHA-256
方式 A（控制台，推荐）：
1. Firebase 控制台 -> 左上齿轮 `Project settings`。
2. `General` 页签 -> `Your apps` -> 选 Android 应用（`com.hachimi.hachimi_app`）。
3. 找到 `SHA certificate fingerprints` 区域 -> `Add fingerprint`。
4. 粘贴 SHA-256，保存；重复添加你需要的多个指纹。

方式 B（CLI，可脚本化）：
1. 先查 Android `appId`：
```bash
firebase apps:list --project hachimi-ai
```
2. 新增 SHA：
```bash
firebase apps:android:sha:create \
  1:360008924406:android:24f480bcb469cd565240d7 \
  <SHA256_FINGERPRINT>
```
3. 列表确认：
```bash
firebase apps:android:sha:list 1:360008924406:android:24f480bcb469cd565240d7
```
4. 如果填错，先 list 后 delete：
```bash
firebase apps:android:sha:delete <APP_ID> <SHA_ID>
```

#### B4. 填完 SHA 后还要做什么
1. 回到 Firebase 控制台 `Build` -> `App Check` -> Android 应用 -> `Manage`。
2. 确认 provider 仍是 `Play Integrity`，并检查保护目标至少包含 Cloud Functions。
3. 发布一个带新签名的测试构建到目标渠道，观察 App Check 指标是否出现有效请求。
4. 再做一次 callable 验收：
- 正常客户端请求通过。
- 无 App Check token 请求返回 `permission-denied`。

#### C. 怎么确认配置生效
1. 打开 Firebase 控制台 `App Check` 的监控页，确认 Android 请求开始出现有效 token 流量。
2. 你可以先保持监控模式观察，再切到强制模式；如果已经稳定可直接强制。
3. 验证逻辑：
- 正常 App 调用敏感 callable：应成功（或按业务逻辑返回）。
- 非法请求（无 token / 伪造 token）：应返回 `permission-denied`。

#### D. 常见坑
1. 直接全量强制导致旧版本客户端失败：先监控再强制更稳妥。
2. 把本地调试也切到 Play Integrity 导致开发不可用：开发环境请用 Debug provider。
3. 只开了 App Check 页面但没有对目标服务启用保护：要确认资源层真的被保护。

---

### 13.2 事项 2：Firebase AI Logic 首次开通（Vertex AI Provider）

目标：完成 Firebase AI Logic 的 Google provider 路径初始化，避免客户端静态 AI key。

#### A. 在哪里操作
1. Firebase 控制台：`https://console.firebase.google.com/project/hachimi-ai/overview`
2. 左侧菜单找到 `AI` / `AI Logic`（不同界面文案可能略有差异）。
3. 点击 `Get started`。

#### B. 怎么配置
1. Provider 选择：`Google / Vertex AI`（不要选需要客户端长期 key 的旧路径）。
2. 按向导确认计费与服务开通（你已是 Blaze，可直接继续）。
3. 如果向导提示启用 API，逐项确认启用（通常包括 Vertex AI）。

#### C. 怎么确认配置生效
1. 控制台中 AI Logic 状态显示已启用。
2. App 端 AI 功能可正常调用（不依赖 `MINIMAX_API_KEY` / `GEMINI_API_KEY`）。
3. Functions 侧 AI 分诊（`runAiDebugTriageV2`）可走 Vertex 主路径（不是长期 fallback）。

#### D. 常见坑
1. 误选非 Google provider，后续又回到客户端 key 管理。
2. 项目/区域不一致导致调用失败：以当前 infra 默认区域/模型配置为准。
3. 忘记 IAM：Functions 运行身份需要可调用 Vertex（缺权限会持续 fallback）。

---

### 13.3 事项 3：开启并核对 BigQuery 导出（Crashlytics + Analytics）

目标：让 Terraform 能创建依赖导出数据的视图和定时任务（`enable_export_dependent_resources=true`）。

#### A. Crashlytics 导出怎么开
1. Firebase 控制台 -> `Crashlytics`。
2. 找到 `BigQuery export`（或 Integrations 里的 BigQuery 连接入口）。
3. 选择项目 `hachimi-ai` 并启用导出。
4. 启用后等待一段时间，直到 BigQuery 中出现 `firebase_crashlytics` 数据集与表。

#### B. Analytics 导出怎么开
1. Firebase 控制台 -> `Project settings` -> `Integrations`。
2. 找到 BigQuery 连接项并启用 Analytics 导出。
3. 启用后 BigQuery 会出现 `analytics_<property_id>` 数据集（例如 `analytics_123456789`）。

#### C. `analytics_dataset` 到底填什么（你最容易卡住的点）
1. 打开 BigQuery 控制台：`https://console.cloud.google.com/bigquery?project=hachimi-ai`
2. 左侧 `Explorer` 展开项目 `hachimi-ai`。
3. 找到名称以 `analytics_` 开头的数据集。
4. 把这个完整数据集 ID 填入：
`infra/terraform/envs/prod/terraform.tfvars`

示例（仅示例）：
```hcl
analytics_dataset = "analytics_123456789"
enable_export_dependent_resources = true
```

#### D. 命令行校验（推荐你直接复制执行）
```bash
PROJECT_ID=hachimi-ai

# 1) Crashlytics 导出是否存在
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.firebase_crashlytics.INFORMATION_SCHEMA.TABLES`
LIMIT 5;
SQL

# 2) 列出 analytics 数据集（找 analytics_<property_id>）
bq ls --project_id="$PROJECT_ID" | rg "analytics_"

# 3) 把上一步找到的数据集替换到下面，验证 events_* 是否存在
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_123456789.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 5;
SQL
```

#### E. 最后一步（你完成导出后）
1. 编辑 [infra/terraform/envs/prod/terraform.tfvars](/data/workspace/hachimi-app/infra/terraform/envs/prod/terraform.tfvars)
- `analytics_dataset = "analytics_<real_property_id>"`
- `enable_export_dependent_resources = true`
2. 执行：
```bash
cd /data/workspace/hachimi-app/infra/terraform/envs/prod
terraform plan
terraform apply
```

---

### 13.4 你完成后怎么通知我

你只要回我 3 行即可：
1. `App Check: done`
2. `AI Logic(Vertex): done`
3. `analytics_dataset: analytics_<你的真实ID>`

我会立即继续帮你做收口（terraform 二次 apply、告警演练、端到端验收与文档闭环）。

---

## 14. 你“现在”还要做什么（按 2026-03-06 实际状态）

本节只写你当前还没做完的动作，不重复已完成内容。

### 14.1 先确认当前状态（你已经做好的）

1. App Check + Play Integrity 已配置。
2. Android SHA-256 已登记到 Firebase。
3. `firebase_crashlytics` 数据集已出现（说明 Crashlytics 导出链路已连上）。
4. Google Chat + Email 告警通道已就绪。

你暂时不用再重复做上面这些。

### 14.2 你还必须手工完成的最小集合

只剩 2 件必须你在控制台完成：
1. 开启 Analytics -> BigQuery 导出，拿到真实 `analytics_<property_id>` 数据集。
2. 把该数据集 ID 回填到 Terraform 变量并开启 `enable_export_dependent_resources`。

> Functions 部署、Terraform 二次 apply、验收收口我来执行；你只需完成这 2 件并把结果发我。

---

### 14.3 手工事项 A：开启 Analytics -> BigQuery 导出（最详细）

#### A1. 入口在哪里
1. 打开 Firebase 控制台：`https://console.firebase.google.com/`
2. 选择项目：`hachimi-ai`
3. 点左上角齿轮 -> `Project settings`
4. 进入 `Integrations`（集成）标签页
5. 找到 `BigQuery` 集成卡片，点击 `Manage` / `Link` / `View details`（不同界面文案会略有差异）

#### A2. 怎么开启
1. 在 BigQuery 集成页，确认项目是 `hachimi-ai`。
2. 找到 Analytics 导出开关（通常是 `Export Google Analytics data to BigQuery`）。
3. 开启导出并保存。
4. 若出现区域/数据共享确认，按默认推荐继续（当前项目主数据面为 US）。

#### A3. 如何判断已经成功
1. 打开 BigQuery 控制台：
`https://console.cloud.google.com/bigquery?project=hachimi-ai`
2. 左侧 Explorer 展开 `hachimi-ai`。
3. 看是否出现 `analytics_` 前缀的数据集（例如 `analytics_123456789`）。
4. 进入该数据集，确认后续出现 `events_YYYYMMDD` 或 `events_intraday_YYYYMMDD` 表。

#### A4. 命令行快速确认（可复制）
```bash
PROJECT_ID=hachimi-ai

# 1) 是否已经出现 analytics 数据集
bq ls --project_id="$PROJECT_ID" | rg "analytics_"

# 2) 假设上一步看到 analytics_123456789，则验证事件表
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_123456789.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 20;
SQL
```

#### A5. 常见等待时间与排查
1. 刚开导出后立刻看不到表：常见，等一段时间再查。
2. 只看到数据集没看到 `events_*`：通常是还没到首批导出窗口，继续等待并保持 App 有真实事件流量。
3. 完全没出现 `analytics_*`：回到 Firebase `Project settings -> Integrations -> BigQuery` 检查是否真正保存成功。

---

### 14.4 手工事项 B：回填 Terraform 变量（最详细）

#### B1. 打开哪个文件
编辑 [infra/terraform/envs/prod/terraform.tfvars](/data/workspace/hachimi-app/infra/terraform/envs/prod/terraform.tfvars)。

#### B2. 改哪两行
把下面两项改成真实值：
```hcl
analytics_dataset                 = "analytics_<你的真实property_id>"
enable_export_dependent_resources = true
```

示例（仅示例）：
```hcl
analytics_dataset                 = "analytics_987654321"
enable_export_dependent_resources = true
```

#### B3. 你自己可先做的本地自检
```bash
cd /data/workspace/hachimi-app/infra/terraform/envs/prod
terraform plan
```

若 `plan` 不再依赖占位 `analytics_123456789`，说明变量已正确回填。

---

### 14.5 你完成后发我什么

发我 2 行就够：
1. `analytics_dataset = analytics_<真实ID>`
2. `tfvars updated: true`

收到后我会立即继续：
1. 执行 Terraform 二次 apply（导出依赖资源全开）。
2. 部署 Functions（含 `deleteAccountV2/wipeUserDataV2` App Check 强制链路）。
3. 跑最终验收并给你“已全部完成”报告。
