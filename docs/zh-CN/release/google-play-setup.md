# Google Play Store — CI/CD 配置指南

> **SSOT**：本文档是通过 GitHub Actions + Workload Identity Federation 实现 Google Play 自动化发布的唯一配置指南。

## 概览

本指南完整介绍从 GitHub Actions 到 Google Play 自动上传 AAB 的端到端配置流程。认证方式采用 **Workload Identity Federation（WIF）** 而非长期服务账号密钥——这是 Google 官方推荐的方案，符合禁止创建密钥的组织策略。

### AI（Claude）已完成的工作

| 项目 | 状态 |
|------|------|
| `.github/workflows/release.yml` — AAB 构建 + Play Store 上传步骤 | 已完成 |
| `distribution/whatsnew/en-US` — Play Store 更新说明 | 已完成 |
| `android/app/proguard-rules.pro` — 移除遗留 llama_cpp_dart 规则 | 已完成 |
| `docs/release/process.md` — 更新 Play Store 发布流程 | 已完成 |
| `hachimi.ai/privacy` — 隐私政策页面（Play Store 强制要求） | 已完成 |
| `CLAUDE.md` — 新增 AAB 构建命令 | 已完成 |

### 你必须手动完成的配置

| 步骤 | 在哪里操作 | 预估耗时 |
|------|-----------|----------|
| 1. 启用 Google Play Android Developer API | Google Cloud Console | 2 分钟 |
| 2. 创建 Workload Identity Pool + Provider | Google Cloud Console（gcloud CLI） | 5 分钟 |
| 3. 创建服务账号 + 授予 WIF 绑定 | Google Cloud Console（gcloud CLI） | 3 分钟 |
| 4. 在 Play Console 授予服务账号权限 | Google Play Console | 2 分钟 |
| 5. 添加 2 个 GitHub Secrets | GitHub 仓库 Settings | 2 分钟 |
| 6. 在 Play Console 创建应用列表 | Google Play Console | 15 分钟 |
| 7. 手动上传首个 AAB | Google Play Console | 5 分钟 |
| 8. 推广到正式版 | Google Play Console | 2 分钟 |

---

## 前置条件

- Google Play Console 开发者账号（企业主体）
- 与 Play Console 关联的 Google Cloud 项目
- 本地已安装 `gcloud` CLI（[安装指南](https://cloud.google.com/sdk/docs/install)）
- GitHub 仓库管理员权限

### 查找你的 Google Cloud 项目

Play Console 关联了一个 Google Cloud 项目。查找方法：

1. 打开 [Google Play Console](https://play.google.com/console)
2. 前往 **Settings** → **API access**
3. 页面顶部显示已关联的 Google Cloud 项目

如未关联项目，点击 **Link existing project** 选择（或创建）一个。

> 本指南中，将 `YOUR_PROJECT_ID` 替换为你的实际项目 ID（如 `hachimi-ai`），将 `YOUR_PROJECT_NUMBER` 替换为数字项目编号（Cloud Console → Dashboard 中可查看）。

---

## 第一步：启用 Google Play Android Developer API

**操作位置**：Google Cloud Console

```bash
gcloud services enable androidpublisher.googleapis.com \
  --project=YOUR_PROJECT_ID
```

或通过网页 UI：
1. 打开 [Google Cloud Console](https://console.cloud.google.com)
2. 选择你的项目
3. 前往 **APIs & Services** → **Library**
4. 搜索 **Google Play Android Developer API**
5. 点击 **Enable**

---

## 第二步：创建 Workload Identity Pool 和 Provider

**操作位置**：Google Cloud Console（gcloud CLI）

此步骤建立 GitHub Actions 与 Google Cloud 之间的信任桥梁。

### 2a. 创建 Workload Identity Pool

```bash
gcloud iam workload-identity-pools create "github-actions" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions Pool"
```

### 2b. 创建 OIDC Provider（绑定到你的 GitHub 仓库）

```bash
gcloud iam workload-identity-pools providers create-oidc "github-repo" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions" \
  --display-name="GitHub Repo Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='sinnohzeng/hachimi-app'" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

**安全要点**：
- `attribute-condition` 限制**仅** `sinnohzeng/hachimi-app` 仓库可获取凭证
- 同一组织下的其他 GitHub 仓库无法使用此 Provider
- 可进一步限制分支，在条件中添加 `&& assertion.ref=='refs/heads/main'`

### 2c. 获取 Provider 完整资源名称

```bash
gcloud iam workload-identity-pools providers describe "github-repo" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions" \
  --format="value(name)"
```

**保存此输出**——格式类似：
```
projects/123456789/locations/global/workloadIdentityPools/github-actions/providers/github-repo
```

你将在第五步中使用此值作为 `WIF_PROVIDER` GitHub Secret。

---

## 第三步：创建服务账号并授予 WIF 绑定

**操作位置**：Google Cloud Console（gcloud CLI）

### 3a. 创建服务账号（无需创建密钥）

```bash
gcloud iam service-accounts create play-store-publisher \
  --project="YOUR_PROJECT_ID" \
  --display-name="Play Store Publisher"
```

### 3b. 允许 GitHub Actions 通过 WIF 扮演此服务账号

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --project="YOUR_PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions/attribute.repository/sinnohzeng/hachimi-app"
```

> **注意**：`--member` 参数中必须使用**数字项目编号**（非项目 ID）。在 Cloud Console → Dashboard → Project number 中查找。

---

## 第四步：在 Play Console 授予服务账号权限

**操作位置**：Google Play Console

> **说明**：Google 已移除 Play Console 中旧的 "Setup → API access" 页面。现在通过 "Users and permissions" 将服务账号作为普通用户邀请。

1. 打开 [Google Play Console](https://play.google.com/console)
2. 前往左侧导航栏的 **Users and permissions**
3. 点击 **Invite new users**
4. 在邮箱地址字段输入你的服务账号邮箱：
   ```
   play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com
   ```
5. 在 **Account permissions** 下授予：
   - **Release apps to testing tracks** — 允许上传 AAB 到 internal/closed/open 测试轨道
   - **Release to production, exclude devices, and use Play App Signing** — 允许管理正式版发布
6. 在 **App permissions** 下，点击 **Add app** → 选择 **Hachimi** → 授予：
   - **Release apps to testing tracks**
   - **Release to production, exclude devices, and use Play App Signing**
7. 点击 **Invite user** → **Send invitation**

服务账号无需通过邮件接受邀请。但**权限生效可能需要 24-48 小时**。如果配置后 CI 上传出现 "403 Forbidden"，请等待后重试。

> **故障排查**：如果邀请失败，请验证：（1）Cloud Console 中已启用 Google Play Android Developer API（第一步），（2）服务账号邮箱格式正确，形如 `name@project-id.iam.gserviceaccount.com`。

---

## 第五步：添加 GitHub Secrets

**操作位置**：GitHub → Repository Settings → Secrets and variables → Actions

添加以下 2 个 Secrets：

| Secret 名称 | 值 | 来源 |
|-------------|-----|------|
| `WIF_PROVIDER` | Provider 完整资源名称 | 第 2c 步的输出 |
| `WIF_SERVICE_ACCOUNT` | `play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com` | 第 3a 步创建的邮箱 |

### 如何添加 GitHub Secret

1. 前往 https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions
2. 点击 **New repository secret**
3. 输入 Secret 名称和值
4. 点击 **Add secret**

> 这些**不是**敏感凭证——它们只是标识符。攻击者没有来自你仓库的 GitHub Actions OIDC Token 就无法使用它们。

---

## 第六步：在 Play Console 创建应用列表

**操作位置**：Google Play Console

### 6a. 创建应用

1. 打开 [Google Play Console](https://play.google.com/console)
2. 点击 **Create app**
3. 填写：
   - App name：`Hachimi`
   - Default language：English (United States)
   - App or game：**App**
   - Free or paid：**Free**
4. 接受声明并点击 **Create app**

### 6b. 完成必填声明

在左侧导航栏的 **Grow** → **Store presence** 和 **Policy** → **App content** 下逐项完成：

| 版块 | 填写内容 |
|------|---------|
| **Store listing** | 标题、简短描述、详细描述、截图（≥6 张）、Feature Graphic（1024×500）、应用图标（512×512） |
| **Content rating** | 完成 IARC 问卷——无暴力/赌博/色情内容 → 评级为 PEGI 3 / Everyone |
| **Target audience** | 非儿童专属应用 |
| **News app** | 否 |
| **COVID-19 contact tracing / status app** | 否 |
| **Data safety** | 按隐私政策填写（见下表） |
| **Ads** | 不包含广告 |
| **App access** | 所有功能无需特殊权限即可访问（如需登录，提供测试账号） |
| **App category** | Productivity（效率工具） |
| **Privacy policy URL** | `https://hachimi.ai/en/privacy` |

### 6c. 数据安全表单

按隐私政策中描述的数据类型填写：

| 数据类型 | 是否收集 | 是否共享 | 用途 |
|----------|---------|---------|------|
| 邮箱地址 | 是 | 否 | 账号管理 |
| 姓名（显示名称） | 是 | 否 | 应用功能 |
| 应用交互（习惯、专注记录） | 是 | 否 | 应用功能 |
| 崩溃日志 | 是 | 是（Google） | 数据分析 |
| 性能诊断 | 是 | 是（Google） | 应用性能 |
| 设备或其他标识符（FCM Token） | 是 | 是（Google） | 推送通知 |
| 其他（AI 聊天内容） | 可选 | 是（MiniMax 或 Google Gemini） | 应用功能（AI 功能） |

标记：数据在传输中加密，用户可请求删除数据。

### 6d. 特殊权限声明（如被要求填写）

| 权限 | 说明 |
|------|------|
| `FOREGROUND_SERVICE_SPECIAL_USE` | 专注计时器需要持久的前台通知，以在应用后台运行时保持倒计时/正计时 |
| `SCHEDULE_EXACT_ALARM` | 习惯提醒通知需要在用户配置的精确时间触发 |

---

## 第七步：手动上传首个 AAB

**操作位置**：Google Play Console + 本地终端

Google Play API 要求**首个 AAB 必须通过网页控制台上传**，之后 CI 可自动处理后续上传。

### 7a. 在本地构建 AAB

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

AAB 文件位于：`build/app/outputs/bundle/release/app-release.aab`

### 7b. 上传到内部测试轨道

1. Play Console → **Testing** → **Internal testing**
2. 点击 **Create new release**
3. **Google Play App Signing** 会自动启用（所有 AAB 上传强制要求）
   - 你现有的 keystore（`hachimi-release.jks`）自动成为**上传密钥**
   - Google 生成并管理实际的分发签名密钥
   - 无需更改你的 keystore 或签名配置
4. 上传 `app-release.aab`
5. 添加发布说明
6. 点击 **Review release** → **Start rollout to Internal testing**

### 7c. 验证上传

- AAB 应出现在内部测试轨道
- 检查 Play Console 中是否有警告或错误

---

## 第八步：推广到正式版

**操作位置**：Google Play Console

由于你使用**企业主体账号**，无需满足 12 人 × 14 天封闭测试要求。可直接推广到正式版。

1. Play Console → **Production** → **Create new release**
2. 点击 **Add from library** → 选择内部测试中的 AAB
3. 添加发布说明
4. 点击 **Review release** → **Start rollout to Production**

### 审核时间

- **首次提交**：3-7 个工作日
- **后续更新**：通常 1-3 天
- 审核完成后会收到邮件通知

---

## 验证

完整配置完成后，验证流水线端到端可用：

### 测试 1：WIF 认证

推送 tag 并检查 GitHub Actions 中的 "Authenticate to Google Cloud" 步骤。如果失败：
- 验证 `WIF_PROVIDER` 值与第 2c 步输出完全一致
- 验证 `WIF_SERVICE_ACCOUNT` 邮箱正确
- 检查第 3b 步中的 IAM 绑定是否使用了正确的项目**编号**（非 ID）

### 测试 2：Play Store 上传

认证成功后，"Upload to Google Play" 步骤应成功。如果失败：
- 验证服务账号在 Play Console 中具有 **Release manager** 权限
- 验证首个 AAB 已手动上传（第七步）
- 检查 `distribution/whatsnew/en-US` 文件是否存在且 ≤500 字符

### 测试 3：完整流水线

```bash
# 代码变更后，运行完整发布流程
git tag -a v2.15.1 -m "v2.15.1: test Google Play pipeline"
git push origin main --tags

# 监控
gh run list --limit 3
gh run watch <RUN_ID> --exit-status
```

预期结果：
- GitHub Release 已创建，附带 APK
- AAB 已上传到 Google Play internal 轨道
- 构建尺寸已在 Actions Summary 中报告

---

## 日常维护

### 每次发布

1. 更新 `distribution/whatsnew/en-US` 中的发布说明（≤500 字符）
2. 更新 `pubspec.yaml` 版本号
3. 推送 tag → CI 自动完成其余工作
4. CI 成功后，在 Play Console 从 internal 推广到 production

### 无需密钥轮换

WIF 使用短期 Token，每次 CI 运行时自动生成新凭证。没有需要轮换的长期凭证。

### 如需更换服务账号

1. 在 Cloud Console 创建新的服务账号
2. 授予 WIF 绑定（第 3b 步）和 Play Console 权限（第四步）
3. 更新 `WIF_SERVICE_ACCOUNT` GitHub Secret
4. 撤销旧服务账号

---

## 架构示意图

```
开发者推送 tag（v2.15.0）
              │
              ▼
    GitHub Actions 触发
              │
              ├── 格式检查 + 静态分析 + 测试
              │
              ├── 构建 AAB ──────────────────────────┐
              │                                        │
              ├── 构建 APK                             │
              │                                        ▼
              │                          ┌──────────────────────────┐
              │                          │  google-github-actions/  │
              │                          │       auth@v3            │
              │                          │                          │
              │                          │  1. 向 GitHub 请求       │
              │                          │     OIDC Token           │
              │                          │  2. 换取 Google Cloud    │
              │                          │     临时凭证             │
              │                          └────────────┬─────────────┘
              │                                       │
              │                                       ▼
              │                          ┌──────────────────────────┐
              │                          │  r0adkll/upload-google-  │
              │                          │       play@v1            │
              │                          │                          │
              │                          │  使用临时凭证上传 AAB    │
              │                          │  到 internal 轨道        │
              │                          └──────────────────────────┘
              │
              ├── 创建 GitHub Release（附带 APK）
              │
              ▼
    开发者在 Play Console
    手动推广到正式版
```

---

## 故障排查

| 现象 | 原因 | 修复 |
|------|------|------|
| Auth 步骤："Unable to generate credentials" | WIF Provider 未找到 | 验证 `WIF_PROVIDER` 值与第 2c 步输出完全一致 |
| Auth 步骤："Permission denied on resource" | IAM 绑定不正确 | 使用正确的项目**编号**重新运行第 3b 步 |
| Upload 步骤："APK/AAB not found" | 构建静默失败 | 检查 AAB 构建步骤输出 |
| Upload 步骤："403 Forbidden" | 服务账号缺少 Play Console 权限 | 重新执行第四步 |
| Upload 步骤："Package not found" | 首个 AAB 未手动上传 | 先完成第七步 |
| Upload 步骤："Version code already exists" | 忘记更新 `pubspec.yaml` 构建号 | 递增 `+buildNumber` 后缀 |

---

## 参考链接

- [Google Cloud Workload Identity Federation — GitHub Actions](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines)
- [google-github-actions/auth — README](https://github.com/google-github-actions/auth)
- [r0adkll/upload-google-play — README](https://github.com/r0adkll/upload-google-play)
- [Google Play Developer API — Getting Started](https://developers.google.com/android-publisher/getting_started)
- [Play Console — App signing](https://support.google.com/googleplay/android-developer/answer/9842756)
