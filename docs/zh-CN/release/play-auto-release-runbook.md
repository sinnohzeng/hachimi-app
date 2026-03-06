# Play 自动发布运行手册

> **SSOT**：本文档是 Google Play 自动化生产发布流水线的手动设置与日常运维的唯一真值源。

## 概述

从 v2.27.0 开始，CI/CD 流水线（`release.yml`）在每次 `v*` tag 推送时，将 AAB 直接上传到 Google Play **生产（production）** 轨道，实现 100% 全量发布。不再需要手动登录 Play Console 推广。

本文档包含两部分：
1. **一次性设置**——启用自动生产发布所需的 3 项手动操作
2. **日常运维**——发版流程、回滚策略、供应链安全维护

### 新旧流程对比

```
旧流程（v2.26.x 及之前）：
  tag push → CI 构建 → 上传到 internal 轨道 → 手动在 Play Console 推广到 production

新流程（v2.27.0+）：
  tag push → CI 构建 → 直接上传到 production 轨道（自动，无需手动操作）
```

### 架构图

```
┌────────────────────────────────────────────────────────────┐
│                    GitHub Actions Runner                     │
│                                                              │
│  ┌──────────┐   ┌──────────┐   ┌─────────────┐             │
│  │ 质量门禁  │──▶│ 构建 AAB │──▶│ WIF 认证    │             │
│  │ format   │   │ + APK    │   │ (OIDC token) │             │
│  │ analyze  │   └──────────┘   └──────┬──────┘             │
│  │ test     │                         │                      │
│  │ quality  │                         ▼                      │
│  │ gate     │              ┌──────────────────┐             │
│  └──────────┘              │ Google Play API   │             │
│                            │ track: production │             │
│                            │ status: completed │             │
│                            └──────────────────┘             │
│                                                              │
│  ┌──────────────────┐   ┌──────────────────┐               │
│  │ Sigstore 溯源证明 │   │ GitHub Release   │               │
│  │ APK provenance   │   │ whatsnew + notes  │               │
│  └──────────────────┘   └──────────────────┘               │
└────────────────────────────────────────────────────────────┘
```

### 安全架构

```
┌─────────────────────────────────────────────────┐
│              GitHub Repository                    │
│                                                   │
│  Repo-level Secrets:                              │
│  └─ FIREBASE_OPTIONS_DART  ← ci.yml 可访问       │
│                                                   │
│  production Environment Secrets:                  │
│  ├─ KEYSTORE_BASE64        ← 仅 v* tag 可访问   │
│  ├─ KEYSTORE_PASSWORD                             │
│  ├─ KEY_ALIAS                                     │
│  ├─ KEY_PASSWORD                                  │
│  ├─ GOOGLE_SERVICES_JSON                          │
│  ├─ FIREBASE_OPTIONS_DART                         │
│  ├─ WIF_PROVIDER                                  │
│  └─ WIF_SERVICE_ACCOUNT                           │
│                                                   │
│  部署分支限制: refs/tags/v*                        │
│  └─ 只有 v* tag push 才能触发 production 部署     │
│  └─ PR 构建、main push 均无法访问生产 secrets     │
└─────────────────────────────────────────────────┘
```

---

## 一次性设置（3 项操作）

> 以下操作只需执行一次。完成后，所有后续发版将自动发布到 Play 生产轨道。

### 操作 1：创建 GitHub `production` Environment

**在哪里找**：GitHub 仓库页面 → 顶部 **Settings** 标签页 → 左侧菜单 **Environments**

**详细步骤**：

1. 在浏览器打开 https://github.com/sinnohzeng/hachimi-app/settings/environments
2. 点击页面右上角的 **New environment** 按钮
3. 在弹出的输入框中填写名称 `production`（必须全小写），点击 **Configure environment**
4. 进入 Environment 配置页面后，找到 **Deployment branches and tags** 段落：
   - 点击下拉菜单，选择 **Selected branches and tags**（默认是 "All branches"）
   - 点击出现的 **Add deployment branch or tag rule** 按钮
   - 在弹出的选择器中，切换到 **Tag** 标签页
   - 在模式输入框中输入 `v*`
   - 点击 **Add rule** 确认

   > 这一步的效果：只有推送 `v*` 格式的 tag（如 `v2.28.0`）时，workflow 才能访问 production Environment 中的 secrets。普通 commit push、PR 构建、`ci.yml` 都无法访问。

5. 在 **Environment protection rules** 段落：
   - 勾选 **Allow administrators to bypass configured protection rules**（确保紧急情况下可以绕过）
   - **不要**勾选 Required reviewers（独立开发者只有自己，设置审批人无意义）
   - **不要**设置 Wait timer（tag 推送本身已是主动、有意识的行为，不需要冷却期）
6. 点击页面底部的 **Save protection rules** 按钮

**验证方式**：刷新页面，确认 `production` environment 出现在列表中，且 Deployment rules 显示 `Tags: v*`。

---

### 操作 2：迁移 Secrets 到 production Environment

**在哪里找**：GitHub 仓库 → Settings → 左侧菜单 Environments → 点击 `production` → 页面下方 **Environment secrets** 段落

**为什么要迁移**：当前 8 个 release secrets 存储在 repo-level（仓库级别），意味着所有 workflow（包括 `ci.yml`）都能访问。迁移到 `production` Environment 后，只有声明了 `environment: production` 的 job 在 `v*` tag 触发时才能访问，实现了 secrets 隔离。

**详细步骤**：

#### 步骤 A：复制 secrets 值

1. 打开 https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions
2. 你会看到当前的 repo-level secrets 列表。**注意：GitHub 不允许查看已存储的 secret 值**。你需要从原始来源获取这些值：

| Secret 名称 | 原始来源 |
|-------------|---------|
| `KEYSTORE_BASE64` | 运行 `base64 < android/app/hachimi-release.jks` 获取，或查看 `scripts/setup-release-signing.sh` 的输出记录 |
| `KEYSTORE_PASSWORD` | 创建 keystore 时设置的密码 |
| `KEY_ALIAS` | 通常为 `hachimi-release` |
| `KEY_PASSWORD` | 创建 key 时设置的密码 |
| `GOOGLE_SERVICES_JSON` | 运行 `base64 < android/app/google-services.json` 获取 |
| `FIREBASE_OPTIONS_DART` | 运行 `base64 < lib/firebase_options.dart` 获取 |
| `WIF_PROVIDER` | 格式：`projects/PROJECT_NUM/locations/global/workloadIdentityPools/POOL/providers/PROVIDER`。查看 `docs/release/google-play-setup.md` Step 2 的输出记录 |
| `WIF_SERVICE_ACCOUNT` | 格式：`play-store-publisher@hachimi-ai.iam.gserviceaccount.com` |

> 如果找不到原始值，可以通过触发一次当前 workflow（在迁移前）来验证现有 secrets 仍然有效，确认无误后再迁移。

#### 步骤 B：添加到 production Environment

1. 打开 https://github.com/sinnohzeng/hachimi-app/settings/environments
2. 点击 `production` environment 名称
3. 滚动到页面下方的 **Environment secrets** 段落
4. 点击 **Add environment secret**
5. 逐个添加上表中的 8 个 secrets（名称必须完全一致，区分大小写）

#### 步骤 C：清理 repo-level secrets

1. 回到 https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions
2. 逐个删除以下 **7** 个 repo-level secrets（点击 secret 名称右侧的垃圾桶图标）：
   - `KEYSTORE_BASE64`
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`
   - `GOOGLE_SERVICES_JSON`
   - `WIF_PROVIDER`
   - `WIF_SERVICE_ACCOUNT`

3. **保留** `FIREBASE_OPTIONS_DART` 在 repo-level！
   - 原因：`ci.yml` 需要此 secret 来恢复 `firebase_options.dart`，而 `ci.yml` 不声明 `environment: production`，因此无法访问 Environment secrets
   - 最终状态：`FIREBASE_OPTIONS_DART` 同时存在于 repo-level 和 production Environment

#### 最终 secrets 分布

```
Repo-level secrets (1 个):
  └─ FIREBASE_OPTIONS_DART  ← ci.yml + release.yml 均可访问

production Environment secrets (8 个):
  ├─ KEYSTORE_BASE64
  ├─ KEYSTORE_PASSWORD
  ├─ KEY_ALIAS
  ├─ KEY_PASSWORD
  ├─ GOOGLE_SERVICES_JSON
  ├─ FIREBASE_OPTIONS_DART  ← 与 repo-level 重复，release.yml 优先读取 Environment 版本
  ├─ WIF_PROVIDER
  └─ WIF_SERVICE_ACCOUNT
```

**验证方式**：推送一个 commit 到 main 分支，观察 `ci.yml` 是否正常通过（能读取 `FIREBASE_OPTIONS_DART`）。如果 CI 失败并报 firebase_options 相关错误，说明 repo-level 的 `FIREBASE_OPTIONS_DART` 被误删了。

---

### 操作 3：验证 Play Console 服务账号权限

**在哪里找**：打开 https://play.google.com/console → 左下角 **Settings**（齿轮图标）→ **Users and permissions**

**为什么需要验证**：之前 CI 上传到 `internal` 轨道，只需要 "Manage testing tracks" 权限。现在上传到 `production` 轨道，需要确认服务账号拥有 "Release apps to production track" 权限。

**详细步骤**：

1. 在 Users and permissions 页面，找到 WIF 服务账号
   - 邮箱地址格式：`play-store-publisher@hachimi-ai.iam.gserviceaccount.com`
   - 如果列表很长，可以使用页面上方的搜索框输入 `play-store` 过滤
2. 点击该用户的行，进入用户详情页面
3. 切换到 **App permissions** 标签页
4. 确认 **Hachimi** app 已被勾选（如果没有，点击右上角 **Add app** 并选择 Hachimi）
5. 点击 Hachimi app，展开权限详情
6. 在 **Release management** 分组下，确认以下权限已勾选：
   - **Release apps to production track** -- 这是关键权限
   - **Release apps to testing tracks** -- 应该已经勾选（之前上传 internal 时就需要）
7. 如果 "Release apps to production track" 未勾选：
   - 点击用户详情页右上角的 **Edit**（铅笔图标）
   - 勾选该权限
   - 点击 **Save changes**
   - **注意**：权限变更可能需要 **24-48 小时** 才能生效。在此期间推送 tag 可能会导致 Play 上传步骤 403 失败。

**验证方式**：无法通过界面直接验证权限是否已生效。最可靠的验证方式是完成所有设置后推送一个 tag，观察 CI 的 "Upload to Google Play" 步骤是否成功。

---

## 日常运维

### 正常发版流程

开发者工作流程不变。按照现有的发版流程（`docs/release/process.md`）操作：

```
1. 修改代码
2. dart format lib/ test/
3. 更新 CHANGELOG.md
4. 更新 distribution/whatsnew/ (5 个语言文件，必须是版本特定内容)
5. bump pubspec.yaml 版本号
6. git commit + git tag -a vX.Y.Z + git push origin main --tags
7. gh run watch 监控 CI
```

唯一区别是 CI 现在自动上传到 **production** 轨道，你不再需要登录 Play Console 手动推广。

### whatsnew 内容要求

每次发版前**必须**更新 `distribution/whatsnew/` 目录下的 5 个文件。CI 会执行鲜度守卫检查：如果文件第一行包含 "Welcome to Hachimi"、"欢迎来到"、"ようこそ" 或 "환영합니다" 等通用描述文本，workflow 会自动失败。

**whatsnew 写作原则**：
- 使用用户视角的语言，不要写开发者术语（如 "ConsumerWidget"、"StateNotifier"）
- 每个文件最多 500 字符
- 以版本号开头（如 `v2.28.0`）
- 列出 3-6 条用户可感知的变更

### 回滚与紧急修复

Google Play **不支持**回退或撤回已发布的版本。如果发现严重 bug：

```
发现 bug
    │
    ▼
修复代码
    │
    ▼
bump patch 版本 (如 2.28.0 → 2.28.1)
    │
    ▼
git commit + tag + push
    │
    ▼
CI 自动构建并上传新版本到 production
    │
    ▼
Google 审核 (1-3 天)
    │
    ├─ 如果不紧急：等待审核通过
    │
    └─ 如果紧急：
       ├─ 通过 GitHub Release 页面分发 APK（sideload）
       └─ 网站 hachimi.ai 的下载按钮指向 GitHub Releases
```

**关键约束**：
- 新版本的 `versionCode`（pubspec 的 build number）必须大于当前 Play 上的版本
- Google 审核生产轨道的更新通常需要 1-3 天
- 一天内可以推送多个版本——新版本会自动替代前一个版本的审核

### 供应链安全日常维护

| 维护项 | 频率 | 操作 |
|--------|------|------|
| Dependabot PR | 每周自动 | 收到 PR 后审查并合并。PR 标题格式：`ci: Bump actions/checkout from xxx to yyy` |
| Environment secrets 轮换 | 按需 | Keystore：除非泄露否则不轮换。WIF：无需轮换（短期凭据自动刷新） |
| 溯源证明验证 | 发版后可选 | `gh attestation verify hachimi-vX.Y.Z.apk --repo sinnohzeng/hachimi-app` |
| 权限审计 | 季度 | 检查 `production` Environment 的 deployment rules 是否仍为 `v*` |

---

## 首次发版验证清单

完成上述一次性设置后，在下一次正常发版时逐项验证：

- [ ] CI workflow 全绿通过（所有步骤无红叉）
- [ ] Play Console → Hachimi → Releases → Production 页面显示新版本号
- [ ] GitHub Release 页面顶部显示 whatsnew-en-US 的内容（用户视角描述）
- [ ] GitHub Release 页面底部显示自动生成的 commit notes
- [ ] Actions 运行页面的 Step Summary 显示 Release 表格（版本号、轨道、溯源链接）
- [ ] https://github.com/sinnohzeng/hachimi-app/attestations 页面可看到 APK 溯源记录
- [ ] `ci.yml`（非 release workflow）仍然可以正常通过 PR 检查

---

## 故障排查

| 现象 | 可能原因 | 解决方法 |
|------|---------|---------|
| Play 上传失败，报 `403 Forbidden` | 服务账号缺少 production release 权限 | 按操作 3 在 Play Console 授予权限，等 24-48h 生效 |
| Play 上传失败，报 `Package not found` | AAB 包名不匹配 | 确认 workflow 中的 `packageName` 为 `com.hachimi.hachimi_app` |
| Play 上传失败，报 `APK specifies a version code that has already been used` | 版本号（build number）没有递增 | 在 `pubspec.yaml` 中递增 `+buildNumber`，重新 tag |
| Workflow 无法访问 secrets，步骤报空值 | Secrets 未迁移到 `production` Environment | 按操作 2 迁移 secrets |
| Workflow 无法访问 secrets，但 secrets 已迁移 | `environment: production` 声明缺失 | 检查 `release.yml` 的 job 级别是否有 `environment: production` |
| CI（ci.yml）失败，报 firebase_options 错误 | repo-level 的 `FIREBASE_OPTIONS_DART` 被误删 | 重新添加到 repo-level secrets |
| whatsnew 校验失败 | whatsnew 文件仍包含通用 app 描述 | 更新 `distribution/whatsnew/` 为版本特定内容 |
| Sigstore 溯源证明步骤失败 | job 权限缺少 `attestations: write` | 检查 `release.yml` 的 `permissions` 段 |
| GitHub Release 没有 whatsnew 内容 | `body_path` 指向的文件为空 | 确认 `distribution/whatsnew/whatsnew-en-US` 非空 |
| Dependabot PR 持续失败 | SHA 解析错误或 action 仓库不可用 | 手动检查 action 仓库状态，必要时手动更新 SHA |

---

## 变更记录

| 日期 | 变更内容 |
|------|---------|
| 2026-03-06 | 初始创建——自动化生产发布流水线运行手册 |

## 相关文档

- [发版流程](process.md)——完整的发版步骤说明
- [Google Play 设置指南](google-play-setup.md)——WIF 与 Play Console 配置
- [Google Play 商店文案](google-play-listing.md)——商店文案 SSOT
- [自动发布计划文档](../plan/20260306-play-auto-release-plan.md)——本次改造的决策记录
