# Google Play Store — CI/CD 配置指南

> **SSOT**：本文档是通过 GitHub Actions + Workload Identity Federation 实现 Google Play 自动化发布的唯一配置指南。

## 概览

本指南完整介绍从 GitHub Actions 到 Google Play 自动上传 AAB 的端到端配置流程。认证方式采用 **Workload Identity Federation（WIF，工作负载身份联合）** 而非长期服务账号密钥——这是 Google 官方推荐的方案，符合禁止创建密钥的组织策略。

### 认证架构简介

传统方式是创建一个服务账号密钥（JSON 文件），将其存储在 GitHub Secrets 中。这种方式的风险是密钥永不过期，一旦泄露就等于永久暴露。

WIF 的工作方式完全不同：

```
传统方式（不推荐）：
  服务账号密钥 (JSON) ──存储在──▶ GitHub Secrets ──使用──▶ Google Cloud API
  └─ 永不过期的长期凭证，泄露 = 永久暴露

WIF 方式（推荐）：
  GitHub Actions OIDC Token ──交换──▶ Google Cloud 短期凭证 ──使用──▶ Google Cloud API
  └─ Token 每次运行自动生成       └─ 凭证几分钟后自动过期
  └─ 严格绑定仓库名 + 分支
```

### AI（Claude）已完成的工作

| 项目 | 状态 |
|------|------|
| `.github/workflows/release.yml` — AAB 构建 + Play Store 上传步骤 | 已完成 |
| `distribution/whatsnew/` — 5 种语言的 Play Store 更新说明 | 已完成 |
| `android/app/proguard-rules.pro` — 移除过时 legacy keep 规则 | 已完成 |
| `docs/release/process.md` — 更新 Play Store 发布流程 | 已完成 |
| `hachimi.ai/privacy` — 隐私政策页面（Play Store 强制要求） | 已完成 |
| `CLAUDE.md` — 新增 AAB 构建命令 | 已完成 |
| `release.yml` — 生产轨道直发 + SHA 固定 + Environment + 溯源证明 | 已完成 |

### 你必须手动完成的配置

| 步骤 | 在哪里操作 | 预估耗时 | 说明 |
|------|-----------|---------|------|
| 1. 启用 Google Play Android Developer API | Google Cloud Console | 2 分钟 | 一行命令或网页点击 |
| 2. 创建 Workload Identity Pool + Provider | Google Cloud Console（gcloud CLI） | 5 分钟 | 3 条 gcloud 命令 |
| 3. 创建服务账号 + 授予 WIF 绑定 | Google Cloud Console（gcloud CLI） | 3 分钟 | 2 条 gcloud 命令 |
| 4. 在 Play Console 授予服务账号权限 | Google Play Console | 2 分钟 | 网页表单操作 |
| 5. 添加 2 个 GitHub Secrets | GitHub 仓库 Settings | 2 分钟 | 复制粘贴 |
| 6. 在 Play Console 创建应用列表 | Google Play Console | 15 分钟 | 填写表单 + 上传截图 |
| 7. 手动上传首个 AAB | Google Play Console | 5 分钟 | API 前提条件 |
| 8. ~~推广到正式版~~ | ~~Google Play Console~~ | CI 自动完成 | 无需手动操作 |

---

## 前置条件

在开始之前，确认你已具备以下条件：

| 条件 | 如何确认 |
|------|---------|
| Google Play Console 开发者账号 | 打开 https://play.google.com/console 能看到控制台 |
| Google Cloud 项目（已启用 Play Developer API） | 在 [Google Cloud Console](https://console.cloud.google.com) 中确认项目存在，并已启用 Google Play Android Developer API |
| `gcloud` CLI 已安装 | 终端运行 `gcloud --version` 有输出 |
| `gcloud` 已登录 | 运行 `gcloud auth list` 确认当前账号 |
| GitHub 仓库管理员权限 | 能访问 https://github.com/sinnohzeng/hachimi-app/settings |

### 查找你的 Google Cloud 项目 ID 和项目编号

**这两个值在后续步骤中反复用到**，请现在记录下来：

1. 打开 [Google Cloud Console](https://console.cloud.google.com)
2. 在页面左上角的项目选择器中选择你的项目（如 `hachimi-ai`）
3. 在 Dashboard 页面右侧的"项目信息"卡片中找到：
   - **Project ID**（项目 ID）：字母数字组合，如 `hachimi-ai`
   - **Project number**（项目编号）：纯数字，如 `123456789`
4. 或者通过命令行获取：
   ```bash
   gcloud projects describe YOUR_PROJECT_ID --format="value(projectNumber)"
   ```

> **重要区别**：后续命令中 `YOUR_PROJECT_ID` 用项目 ID（字母数字），`YOUR_PROJECT_NUMBER` 用项目编号（纯数字）。混淆这两个值是最常见的配置错误。

> **关于 Play Console 的 API access 页面**：Google 在 2024-2025 年间移除了 Play Console 中 Settings → API access 页面的公开可见性（需要 "Manage API access" 权限，且部分账号类型不显示此菜单项）。当前**不再需要**在 Play Console 中关联 Cloud 项目——只需在 Cloud Console 中启用 API 即可。

---

## 第一步：启用 Google Play Android Developer API

**操作位置**：Google Cloud Console

**为什么需要**：这个 API 是 CI 通过程序化方式上传 AAB 到 Play Store 的前提。没有启用它，后续所有 Play Store API 调用都会返回 403。

### 方法一：命令行（推荐）

```bash
gcloud services enable androidpublisher.googleapis.com \
  --project=YOUR_PROJECT_ID
```

如果命令成功，会输出类似 `Operation ... finished successfully`。

### 方法二：网页 UI

1. 打开 [Google Cloud Console](https://console.cloud.google.com)
2. 确认左上角的项目选择器显示的是你的项目（如 `hachimi-ai`）
3. 在左侧导航栏点击 **APIs & Services** → **Library**
4. 在搜索框输入 `Google Play Android Developer API`
5. 点击搜索结果中的 API 名称
6. 点击蓝色的 **Enable** 按钮
7. 等待几秒钟，页面会跳转到 API 详情页，显示 "API enabled"

**验证方法**：

```bash
gcloud services list --enabled --project=YOUR_PROJECT_ID | grep androidpublisher
```

如果输出包含 `androidpublisher.googleapis.com`，说明已启用。

---

## 第二步：创建 Workload Identity Pool 和 Provider

**操作位置**：Google Cloud Console（通过 gcloud CLI）

**背景知识**：WIF 的核心概念有两层：
- **Pool（池）**：一个容器，用于组织多个 Provider。你可以把它理解为"信任域"
- **Provider（提供者）**：定义具体的信任关系。在我们的场景中，Provider 告诉 Google Cloud："来自 GitHub Actions 的 OIDC Token，如果仓库名是 sinnohzeng/hachimi-app，就信任它"

### 2a. 创建 Workload Identity Pool

```bash
gcloud iam workload-identity-pools create "github-actions" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions Pool"
```

**参数说明**：
- `"github-actions"`：Pool 的 ID（只能包含小写字母、数字和连字符）
- `--location="global"`：Pool 的位置，始终使用 `global`
- `--display-name`：在 Console 中显示的友好名称

> 如果报错 `already exists`，说明之前已创建过，可以跳过此步骤直接进入 2b。

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

**参数逐行解释**：

| 参数 | 说明 |
|------|------|
| `"github-repo"` | Provider 的 ID |
| `--workload-identity-pool` | 关联到上一步创建的 Pool |
| `--attribute-mapping` | 将 GitHub Token 中的字段映射到 Google Cloud 属性。`assertion.sub` 是 Token 的主题（subject），`assertion.repository` 是仓库全名 |
| `--attribute-condition` | **安全核心**：限制只有 `sinnohzeng/hachimi-app` 仓库的 Token 才被接受 |
| `--issuer-uri` | GitHub Actions 的 OIDC Token 签发地址（固定值） |

**安全要点**：
- `attribute-condition` 是最关键的安全防线。它确保**只有**你的仓库可以获取凭证
- 同一 GitHub 组织下的其他仓库也**无法**使用此 Provider
- 如需进一步限制到特定分支，可以在条件中添加 `&& assertion.ref=='refs/heads/main'`
- 但对于 tag 触发的 release 场景，不建议限制分支（tag 的 ref 是 `refs/tags/vX.Y.Z`，不是分支名）

### 2c. 获取 Provider 完整资源名称

```bash
gcloud iam workload-identity-pools providers describe "github-repo" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions" \
  --format="value(name)"
```

**保存此输出**——它的格式类似：
```
projects/123456789/locations/global/workloadIdentityPools/github-actions/providers/github-repo
```

这个完整路径将在第五步中作为 `WIF_PROVIDER` GitHub Secret 的值。

> **常见错误**：有人只保存了 `github-repo`（Provider ID），而不是完整路径。必须保存以 `projects/` 开头的完整字符串。

---

## 第三步：创建服务账号并授予 WIF 绑定

**操作位置**：Google Cloud Console（通过 gcloud CLI）

**背景知识**：服务账号是 Google Cloud 中代表"非人类用户"的身份。CI 通过 WIF 获得的临时凭证，本质上是"以这个服务账号的身份"调用 Google API。

### 3a. 创建服务账号（不需要创建密钥）

```bash
gcloud iam service-accounts create play-store-publisher \
  --project="YOUR_PROJECT_ID" \
  --display-name="Play Store Publisher"
```

**重要**：这里**故意不创建密钥**（不运行 `gcloud iam service-accounts keys create`）。WIF 的设计就是为了避免使用长期密钥。

创建成功后，服务账号的邮箱地址为：
```
play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

**验证方法**：

```bash
gcloud iam service-accounts list --project=YOUR_PROJECT_ID | grep play-store
```

### 3b. 允许 GitHub Actions 通过 WIF 扮演此服务账号

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --project="YOUR_PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions/attribute.repository/sinnohzeng/hachimi-app"
```

**关键细节**：

| 参数部分 | 说明 |
|---------|------|
| `--role="roles/iam.workloadIdentityUser"` | 授予"模拟身份"权限——允许 WIF 身份扮演此服务账号 |
| `YOUR_PROJECT_NUMBER` | 必须使用**纯数字的项目编号**，不是项目 ID！ |
| `attribute.repository/sinnohzeng/hachimi-app` | 进一步限制只有此仓库的身份可以扮演 |

> **最常见的错误**：在 `--member` 中使用了 `YOUR_PROJECT_ID`（字母数字）而非 `YOUR_PROJECT_NUMBER`（纯数字）。这会导致 CI 运行时报 "Permission denied on resource"。
>
> **如何查看项目编号**：打开 https://console.cloud.google.com → 选择项目 → Dashboard 页面右侧卡片中的 "Project number"。

---

## 第四步：在 Play Console 授予服务账号权限

**操作位置**：Google Play Console

**背景知识**：即使服务账号已经有了 WIF 绑定和 Google Cloud IAM 权限，它还需要在 **Play Console** 中被授予"上传 AAB"的权限。这是两个独立的权限系统——Google Cloud IAM 管的是"谁能调用哪些 API"，Play Console 管的是"谁能操作哪些应用"。

> **重要变更**：Google 在 2024-2025 年间逐步移除了 Play Console 中旧的 "Setup → API access" 页面（部分账号仍可见，但已非推荐路径）。当前标准做法是通过 **Users and permissions → Invite new users** 将服务账号作为普通用户邀请。本文档的所有步骤均基于此新流程。

### 详细步骤

1. 打开 [Google Play Console](https://play.google.com/console)
2. 点击左侧导航栏的 **Users and permissions**
3. 点击页面右上角的 **Invite new users** 按钮
4. 在 **Email address** 输入框中输入你的服务账号邮箱：
   ```
   play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com
   ```
   > 注意：不要输入你自己的邮箱，要输入服务账号的邮箱
5. 在 **Account permissions** 标签页下，勾选以下两项：
   - **Release apps to testing tracks** — 允许上传 AAB 到 internal/closed/open 测试轨道
   - **Release to production, exclude devices, and use Play App Signing** — 允许发布到正式版
6. 切换到 **App permissions** 标签页：
   - 点击 **Add app** 按钮
   - 在弹出的列表中选择 **Hachimi**
   - 对 Hachimi 应用勾选与 Account permissions 相同的两项权限
7. 点击页面右下角的 **Invite user** 按钮
8. 在确认弹窗中点击 **Send invitation**

### 权限生效时间

- 服务账号**无需**通过邮件接受邀请（与普通用户不同）
- 但权限变更**可能需要 24-48 小时才能完全生效**
- 如果在配置后立即推送 tag，CI 的 Play 上传步骤可能报 `403 Forbidden`
- 遇到 403 时，先等待 24 小时再重试

### 故障排查

如果邀请失败或提交后看不到服务账号出现在用户列表中：

1. **确认 API 已启用**：回到第一步，验证 `Google Play Android Developer API` 已在 Cloud Console 中启用
2. **确认邮箱格式正确**：必须是 `name@project-id.iam.gserviceaccount.com`，注意 `project-id` 是你的 Google Cloud 项目 ID（不是项目编号）
3. **确认 API 已在正确的 Cloud 项目中启用**：在 Google Cloud Console 中运行 `gcloud services list --enabled --project=YOUR_PROJECT_ID | grep androidpublisher`，确认 `androidpublisher.googleapis.com` 出现在列表中

---

## 第五步：添加 GitHub Secrets

**操作位置**：GitHub → 仓库 Settings → Secrets and variables → Actions

需要添加 2 个 secrets（标识符，非敏感凭证）：

| Secret 名称 | 值 | 来源 |
|-------------|-----|------|
| `WIF_PROVIDER` | Provider 完整资源名称（以 `projects/` 开头的长字符串） | 第 2c 步命令的输出 |
| `WIF_SERVICE_ACCOUNT` | `play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com` | 第 3a 步创建的服务账号邮箱 |

### 详细操作

1. 在浏览器打开 https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions
2. 点击页面右上角的 **New repository secret** 按钮
3. 在 **Name** 输入框中输入 `WIF_PROVIDER`
4. 在 **Secret** 文本框中粘贴第 2c 步的输出值（完整路径，如 `projects/123456789/locations/global/...`）
5. 点击 **Add secret**
6. 重复步骤 2-5，添加 `WIF_SERVICE_ACCOUNT`

> **安全说明**：这两个值**不是**敏感凭证——它们只是标识符（类似于"用户名"而非"密码"）。攻击者即使知道这些值，也无法使用它们，因为还需要一个有效的 GitHub Actions OIDC Token（只能由你仓库中的 workflow 生成）。

> **关于 Environment secrets**：这两个 WIF secrets 最终应迁移到 GitHub `production` Environment 中，与其他 release secrets 一起。迁移步骤详见 [自动发布运行手册](play-auto-release-runbook.md) 操作 2。

---

## 第六步：在 Play Console 创建应用列表

**操作位置**：Google Play Console

这是最耗时的一步（约 15 分钟），需要填写大量的应用信息表单和上传素材。

### 6a. 创建应用

1. 打开 [Google Play Console](https://play.google.com/console)
2. 在首页点击蓝色的 **Create app** 按钮
3. 填写基本信息：

| 字段 | 值 | 说明 |
|------|-----|------|
| App name | `Hachimi` | 应用在 Play Store 中显示的名称 |
| Default language | English (United States) | 默认语言，可以后续添加其他语言 |
| App or game | **App** | 选择"应用"而非"游戏" |
| Free or paid | **Free** | 免费应用 |

4. 勾选底部的两个声明复选框
5. 点击 **Create app**

### 6b. 完成必填声明

创建应用后，Play Console 左侧导航栏会出现一系列需要完成的部分。Google 不会让你发布应用，直到所有必填信息都已填写。

在以下位置逐项完成：

| 位置 | 版块 | 填写内容 | 详细说明 |
|------|------|---------|---------|
| Grow → Store presence | **Main store listing** | 标题、简短描述、完整描述 | 从 [google-play-listing.md](google-play-listing.md) 复制文字 |
| Grow → Store presence | **Graphics** | 截图（≥ 6 张）、Feature Graphic（1024×500px）、应用图标（512×512px） | 截图建议包含主要功能页面 |
| Policy → App content | **Content rating** | 完成 IARC 问卷 | 我们的应用无暴力/赌博/色情内容，评级结果为 PEGI 3 / Everyone |
| Policy → App content | **Target audience** | 目标受众 | 选择"非儿童专属应用"，勾选适合的年龄段 |
| Policy → App content | **News app** | 是否为新闻应用 | 选择 **否** |
| Policy → App content | **Data safety** | 数据安全表单 | 详见下方 6c 小节 |
| Policy → App content | **Government apps** | 是否为政府应用 | 选择 **否** |
| Policy → App content | **Financial features** | 是否包含金融功能 | 选择 **否** |
| Policy → App content | **Health apps** | 是否为健康应用 | 选择 **否** |
| Monetize → App pricing | **Ads** | 是否包含广告 | 选择 **不包含广告** |
| App integrity | **App access** | 应用访问方式 | 选择"所有功能无需特殊权限即可访问" |
| Grow → Store presence | **Store settings** | 应用类别 | 选择 **Productivity**（效率工具） |

**Privacy policy URL**：在 Store listing 页面底部，填写隐私政策地址：

```
https://hachimi.ai/en/privacy
```

### 6c. 数据安全表单

数据安全表单需要声明应用收集和共享了哪些用户数据。按照以下表格逐项填写：

| 数据类型 | 是否收集 | 是否共享 | 共享对象 | 用途 | 是否可选 |
|----------|---------|---------|---------|------|---------|
| 邮箱地址 | 是 | 否 | — | 账号管理 | 否（登录必需） |
| 姓名（显示名称） | 是 | 否 | — | 应用功能 | 否 |
| 应用交互数据（习惯、专注记录） | 是 | 否 | — | 应用功能 | 否 |
| 崩溃日志 | 是 | 是 | Google（Firebase Crashlytics） | 数据分析、应用稳定性 | 否 |
| 性能诊断数据 | 是 | 是 | Google（Firebase Performance） | 应用性能监控 | 否 |
| 设备标识符（FCM Token） | 是 | 是 | Google（Firebase Cloud Messaging） | 推送通知 | 否 |
| 其他数据（AI 聊天内容） | 是 | 是 | Google（Firebase AI Logic / Vertex AI） | AI 功能 | **是**（用户可选启用） |

**额外声明**：
- 勾选"数据在传输中加密"
- 勾选"用户可请求删除数据"
- 勾选"数据不会出售给第三方"

### 6d. 特殊权限声明

如果 Google Play 在审核时要求解释以下权限的用途，按表格填写：

| 权限 | 理由 |
|------|------|
| `FOREGROUND_SERVICE_SPECIAL_USE` | 专注计时器需要一个持久的前台通知来保持倒计时/正计时运行，即使应用进入后台。这是计时器应用的标准做法。 |
| `SCHEDULE_EXACT_ALARM` | 习惯提醒通知需要在用户配置的精确时间点触发。非精确闹钟会有 ±10 分钟的误差，不适合提醒场景。 |

---

## 第七步：手动上传首个 AAB

**操作位置**：Google Play Console + 本地终端

**为什么需要手动上传**：Google Play Publishing API 有一个前提条件——应用必须先通过网页控制台上传过至少一个 AAB/APK，然后 API 才能接管后续上传。这是 Google 的安全设计，确保首次发布由有完整 Play Console 权限的人类操作。

### 7a. 在本地构建 AAB

确保你有正确的签名配置（`android/key.properties` 已创建），然后运行：

```bash
flutter build appbundle --release
```

构建成功后，AAB 文件位于：

```
build/app/outputs/bundle/release/app-release.aab
```

> **如果构建失败**：
> - 确认 `android/key.properties` 存在且路径正确
> - 确认 JDK 版本为 17（`java --version`）
> - 运行 `flutter clean && flutter pub get` 后重试

### 7b. 上传到内部测试轨道

1. 打开 Play Console → 选择 Hachimi 应用
2. 在左侧导航栏点击 **Testing** → **Internal testing**
3. 点击 **Create new release** 按钮
4. **Google Play App Signing**：
   - 如果是首次上传，系统会提示启用 Google Play App Signing
   - 这是**强制性**的（所有 AAB 上传都必须启用）
   - 点击确认后，你的 keystore（`hachimi-release.jks`）自动成为**上传密钥（Upload Key）**
   - Google 会自动生成并管理实际的**分发签名密钥（App Signing Key）**
   - **无需**更改你本地的 keystore 或签名配置

5. 在 **App bundles** 区域，点击 **Upload** 并选择刚才构建的 `app-release.aab`
6. 等待上传和处理完成（通常 1-2 分钟）
7. 在 **Release notes** 区域添加发布说明（可以是简短的测试说明）
8. 点击 **Review release**
9. 确认无误后，点击 **Start rollout to Internal testing**

### 7c. 验证上传

上传完成后，确认以下几点：

- [ ] AAB 出现在 Internal testing 轨道的版本列表中
- [ ] 版本状态不是 "Error" 或 "Draft"
- [ ] Play Console 没有显示红色的错误警告
- [ ] 如果有黄色警告（如"未优化"），可以先忽略

---

## 第八步：正式版发布（CI 自动完成）

**无需手动操作**。

从 v2.27.0 开始，CI 在每次 `v*` tag 推送时自动将 AAB 上传到 **production（正式版）** 轨道。整个流程如下：

```
开发者推送 tag (如 v2.28.0)
        │
        ▼
GitHub Actions 自动触发 release.yml
        │
        ├── 质量门禁通过（格式、分析、测试）
        │
        ├── 构建 AAB + APK
        │
        ├── WIF 认证 → 获取 Google Cloud 临时凭证
        │
        ├── 上传 AAB 到 production 轨道
        │   └── status: completed（100% 全量发布）
        │   └── whatsNewDirectory: distribution/whatsnew/
        │
        ├── Sigstore 溯源证明（APK）
        │
        └── 创建 GitHub Release（附带 APK + whatsnew 内容）
```

由于你使用 **企业主体账号（Organization Account）**，无需满足 Google Play 的 12 人 × 14 天封闭测试要求，因此可以直接发布到正式版。

### Google 审核时间

| 类型 | 预期时间 | 说明 |
|------|---------|------|
| 首次提交 | 3-7 个工作日 | Google 会对新应用进行较为严格的审核 |
| 后续更新 | 1-3 天 | 已建立良好记录的应用审核更快 |
| 紧急安全更新 | 可能加速 | 可以在 Play Console 请求加急审核（不保证） |

审核完成后，你会收到邮件通知（发送到 Play Console 账号关联的邮箱）。

---

## 上架地区配置

**操作位置**：Google Play Console

默认情况下，新上架的应用可能只在部分地区可见。建议**选择全部地区**发布，这是绝大多数应用的标准做法。

### 操作步骤

1. 打开 [Google Play Console](https://play.google.com/console) → 选择 Hachimi 应用
2. 左侧导航 → **Test and release** → **Production**
3. 选择页面顶部的 **Countries/regions** 标签页
4. 点击 **Add countries/regions**
5. 勾选 **Select all** 选中全部 170+ 个国家和地区
6. 点击 **Add countries/regions** 确认
7. 变更立即生效，无需重新提交审核

### 常见问题

| 问题 | 回答 |
|------|------|
| 选全部地区会增加审核难度吗？ | 不会。地区选择不影响审核流程 |
| 中国大陆选不选有区别吗？ | 无区别。Google Play 在中国大陆不可用 |
| 需要针对不同地区做合规处理吗？ | 一般应用不需要。GDPR（欧盟）、LGPD（巴西）等法规主要影响数据处理方式，Hachimi 的隐私政策和数据安全声明已覆盖 |
| 韩国/日本有特殊要求吗？ | 有年龄分级要求，但 Play Console 的 IARC 内容评级问卷已自动覆盖 |

---

## 验证

完成全部配置后，通过以下测试验证端到端流水线可用。

### 测试 1：WIF 认证

推送一个 tag 并检查 GitHub Actions 中的 "Authenticate to Google Cloud" 步骤。

**如果成功**：该步骤显示绿色勾号，日志中包含 "Created credentials file"。

**如果失败**，按以下清单排查：

| 错误信息 | 原因 | 修复 |
|---------|------|------|
| "Unable to generate credentials" | WIF Provider 配置错误 | 验证 `WIF_PROVIDER` Secret 的值与第 2c 步输出**完全一致**（注意空格和换行） |
| "Permission denied on resource" | IAM 绑定中使用了错误的项目标识 | 确认第 3b 步中 `--member` 参数使用的是**纯数字的项目编号**（不是字母数字的项目 ID） |
| "Workload Identity Pool does not exist" | Pool 名称拼写错误 | 运行 `gcloud iam workload-identity-pools list --project=YOUR_PROJECT_ID --location=global` 确认 Pool 存在 |

### 测试 2：Play Store 上传

WIF 认证通过后，检查 "Upload to Google Play" 步骤。

**如果成功**：该步骤显示绿色勾号，日志中包含上传确认信息。

**如果失败**，按以下清单排查：

| 错误信息 | 原因 | 修复 |
|---------|------|------|
| "403 Forbidden" | 服务账号缺少 Play Console 权限 | 重做第四步；权限可能需要 24-48 小时生效 |
| "Package not found" | 应用尚未通过网页上传首个 AAB | 先完成第七步 |
| "Version code already exists" | 构建号未递增 | 在 `pubspec.yaml` 中递增 `+buildNumber` 后缀 |
| "APK/AAB not found in release files" | AAB 构建步骤静默失败 | 检查 "Build release AAB" 步骤的完整日志 |
| "Release notes too long" | whatsnew 文件超过 500 字符 | 缩短 `distribution/whatsnew/` 文件内容 |

### 测试 3：完整流水线端到端

```bash
# 在一次正常的代码变更后，运行完整发版流程
git tag -a v2.28.0 -m "v2.28.0: test Play production pipeline"
git push origin main --tags

# 监控 CI 运行
gh run list --limit 3
gh run watch <RUN_ID> --exit-status
```

**预期结果**：
- [ ] GitHub Actions workflow 全绿通过
- [ ] GitHub Release 页面已创建，附带 APK 下载
- [ ] GitHub Release 顶部显示 whatsnew-en-US 内容
- [ ] Play Console → Hachimi → Production 显示新版本（可能处于"审核中"状态）
- [ ] Actions 页面的 Step Summary 显示构建尺寸和 Release 信息表格
- [ ] https://github.com/sinnohzeng/hachimi-app/attestations 有新的溯源记录

---

## 日常维护

### 每次发版需要做的事

1. 更新 `distribution/whatsnew/` 下全部 5 个语言文件（≤ 500 字符，版本特定内容）
2. 递增 `pubspec.yaml` 版本号（语义版本 + 构建号）
3. 推送 tag → CI 自动完成构建、上传到 production、创建 GitHub Release

### 不需要做的事

- **不需要** 登录 Play Console 手动推广
- **不需要** 轮换密钥——WIF 使用短期 Token，每次 CI 运行自动生成新凭证
- **不需要** 手动创建 GitHub Release——CI 自动创建（使用 whatsnew-en-US 作为 body）

### 更换服务账号

如果需要更换服务账号（如迁移项目、权限审计等）：

1. 在 Cloud Console 创建新的服务账号
2. 授予 WIF 绑定（重做第 3b 步，使用新服务账号邮箱）
3. 在 Play Console 邀请新服务账号（重做第四步）
4. 更新 `WIF_SERVICE_ACCOUNT` GitHub Secret（或 Environment Secret）
5. 等待 24-48 小时权限生效
6. 推送一个 tag 验证
7. 验证成功后，在 Cloud Console 撤销旧服务账号

---

## 架构示意图

```
开发者推送 tag（v2.28.0）
              │
              ▼
    GitHub Actions 触发 release.yml
              │
              ├── 1. 准备环境
              │   ├── 检出代码
              │   ├── JDK 17 + Flutter 3.41.1 + Node 20
              │   └── 恢复 Firebase 配置 + 签名 keystore
              │
              ├── 2. 质量门禁
              │   ├── 版本一致性校验
              │   ├── 代码格式检查
              │   ├── whatsnew 新鲜度检查
              │   ├── 静态分析
              │   └── 单元测试 + Functions 测试
              │
              ├── 3. 构建
              │   ├── AAB（Google Play 格式）
              │   └── APK（GitHub Release + 侧载渠道）
              │
              ├── 4. 发布到 Google Play
              │   │
              │   ├── google-github-actions/auth
              │   │   ├── 向 GitHub 请求 OIDC Token
              │   │   └── 换取 Google Cloud 临时凭证
              │   │
              │   └── r0adkll/upload-google-play
              │       ├── 使用临时凭证上传 AAB
              │       ├── 轨道: production
              │       ├── 状态: completed（100% 全量）
              │       └── 附带 5 种语言的 whatsnew
              │
              ├── 5. 溯源证明
              │   └── Sigstore 对 APK 签名
              │
              └── 6. GitHub Release
                  ├── 附带重命名后的 APK
                  ├── Body: whatsnew-en-US
                  └── 追加自动生成的 commit notes
```

---

## 故障排查

| 现象 | 原因 | 修复方法 |
|------|------|---------|
| Auth 步骤："Unable to generate credentials" | WIF Provider 路径错误 | 验证 `WIF_PROVIDER` 值与第 2c 步输出**完全一致** |
| Auth 步骤："Permission denied on resource" | IAM 绑定使用了项目 ID 而非项目编号 | 用正确的**纯数字项目编号**重新运行第 3b 步 |
| Upload 步骤："APK/AAB not found" | AAB 构建静默失败 | 检查 "Build release AAB" 步骤的完整输出日志 |
| Upload 步骤："403 Forbidden" | 服务账号缺少 Play Console 权限 | 重做第四步，等 24-48 小时权限生效 |
| Upload 步骤："Package not found" | 首个 AAB 未手动上传 | 先完成第七步 |
| Upload 步骤："Version code already exists" | 忘记递增 `pubspec.yaml` 构建号 | 递增 `+buildNumber` 后缀 |
| Upload 步骤："Release notes too long" | whatsnew 超过 500 字符 | 缩短文件内容 |
| Secrets 步骤：变量为空 | Secrets 未配置或未迁移到 Environment | 检查 `production` Environment 中 8 个 secrets 是否完整 |

---

## 参考链接

- [Google Cloud Workload Identity Federation — GitHub Actions](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines) — WIF 官方文档
- [google-github-actions/auth — README](https://github.com/google-github-actions/auth) — GitHub Actions 认证 Action 文档
- [r0adkll/upload-google-play — README](https://github.com/r0adkll/upload-google-play) — Play Store 上传 Action 文档
- [Google Play Developer API — Getting Started](https://developers.google.com/android-publisher/getting_started) — Play API 入门指南
- [Play Console — App signing](https://support.google.com/googleplay/android-developer/answer/9842756) — 应用签名官方说明

---

## 变更记录

| 日期 | 变更 |
|------|------|
| 2026-03-06 | 新增"上架地区配置"章节，建议全球发布 |
| 2026-03-06 | 修正过时的 Play Console 导航路径：移除 "Settings → API access" 和 "Link existing project" 引用，改为 Cloud Console 直接操作 |
| 2026-03-06 | 更新为中文，增加详细讲解；新增 WIF 架构介绍、参数逐行解释、故障排查扩展 |
| 2026-03-02 | 初始创建，用于 v2.24.0 首次上架 Google Play |
