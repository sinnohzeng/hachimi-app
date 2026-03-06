# Hachimi App — 发版流程

> **SSOT**：本文档是 Hachimi App 创建和发布 GitHub Release 的唯一真值来源。

## 概览

| 关注点 | 值 |
|--------|-----|
| 发布平台 | GitHub Releases + Google Play Store |
| APK 类型 | Release 签名 APK（AOT 编译、代码压缩） |
| AAB 类型 | Release 签名 AAB（用于 Google Play） |
| 构建方式 | GitHub Actions 自动化（tag 触发） |
| 签名方式 | 生产级 keystore（`hachimi-release.jks`）作为上传密钥；Google Play App Signing 管理分发密钥 |
| 版本格式 | `pubspec.yaml` version 字段（`主版本.次版本.补丁版本+构建号`） |
| GitHub Release 页面 | https://github.com/sinnohzeng/hachimi-app/releases |
| Google Play 页面 | https://play.google.com/store/apps/details?id=com.hachimi.hachimi_app |

> **说明**：https://hachimi.ai 上的下载按钮同时指向 GitHub Releases 和 Google Play。

---

## 版本命名规范

遵循 [语义化版本](https://semver.org/lang/zh-CN/)：

| 组成部分 | 含义 | 示例 |
|----------|------|------|
| `主版本（major）` | 重大变更或里程碑 | 1 → 2 |
| `次版本（minor）` | 新功能或重大改进 | 1.0 → 1.1 |
| `补丁版本（patch）` | Bug 修复或小调整 | 1.0.0 → 1.0.1 |
| `+构建号（buildNumber）` | Flutter 内部构建号，每次发布递增 1 | +61 → +62 |

**示例：**
- `1.0.0+1` → 首次公开发布（tag 为 `v1.0.0`）
- `1.1.0+2` → 新增功能
- `1.1.1+3` → Bug 修复

> **重要**：tag 版本号必须与 `pubspec.yaml` 中的语义版本号一致（不含 `+构建号`）。例如 pubspec 为 `2.28.0+63`，则 tag 必须为 `v2.28.0`。

---

## 发版完整步骤

### 第一步：格式化整个代码库

```bash
dart format lib/ test/
```

> **关键点**：必须对 **所有** 文件运行 `dart format`，而不仅仅是你编辑过的文件。
>
> **原因**：CI 强制执行 `dart format --set-exit-if-changed lib/ test/`。如果你只格式化了自己改过的文件，可能遗漏以下情况：
> - 添加命名参数导致某个已有的单行调用超过 80 字符，formatter 会自动折行——即使你没直接编辑那个文件
> - 其他开发者或 AI 助手修改了文件但忘记格式化
>
> **养成习惯**：每次发版前无脑运行 `dart format lib/ test/`，就不会因为格式问题导致 CI 失败重跑。

### 第二步：更新版本号

编辑 `pubspec.yaml`，同时递增语义版本号和构建号：

```yaml
# pubspec.yaml
version: 2.28.0+63   # 语义版本号 + 构建号，两者都要递增
```

**版本号递增规则**：
- 新功能：递增 `minor`，`patch` 归零（如 `2.27.0` → `2.28.0`）
- Bug 修复：递增 `patch`（如 `2.28.0` → `2.28.1`）
- 构建号：始终 +1，不能跳号也不能重复

### 第三步：更新 CHANGELOG 和 whatsnew

#### 3a. 更新 CHANGELOG.md

在文件顶部新增一个版本段落，遵循 [Keep a Changelog](https://keepachangelog.com/) 格式：

```markdown
## [2.28.0] - 2026-03-07

### Added
- 新增的功能描述

### Changed
- 改进的功能描述

### Fixed
- 修复的 Bug 描述
```

#### 3b. 更新 whatsnew 文件（5 种语言）

更新 `distribution/whatsnew/` 目录下的全部 5 个文件：

```
distribution/whatsnew/
├── whatsnew-en-US    # 英语
├── whatsnew-zh-CN    # 简体中文
├── whatsnew-zh-TW    # 繁体中文
├── whatsnew-ja-JP    # 日语
└── whatsnew-ko-KR    # 韩语
```

**whatsnew 写作规范**：

| 规则 | 说明 |
|------|------|
| 字符限制 | 每个文件 ≤ 500 字符（Google Play 硬性限制） |
| 内容要求 | 必须是**版本特定**的发布说明，不能是通用 app 描述 |
| 语言风格 | 面向用户的通俗语言，不要写开发者术语 |
| 格式建议 | 以版本号开头（如 `v2.28.0`），列出 3-6 条用户可感知的变更 |

> **CI 鲜度守卫**：CI 会检查 whatsnew 文件的第一行。如果包含 "Welcome to Hachimi"、"欢迎来到"、"ようこそ" 或 "환영합니다" 等通用描述文本，workflow 会 **自动失败**。这是为了防止忘记更新 whatsnew 导致 Play Store 的版本说明始终显示通用描述。

#### 3c. 审查 Store Listing（可选）

如果本次发版有重大功能变化，审查并更新 `docs/release/google-play-listing.md` 中的商店文案。更新后需手动复制到 Play Console。

### 第四步：提交并打 tag

```bash
# 暂存所有变更
git add pubspec.yaml CHANGELOG.md distribution/whatsnew/

# 提交（使用 conventional commit 格式，英文）
git commit -m "chore(release): prepare v2.28.0"

# 创建带注释的 tag
git tag -a v2.28.0 -m "v2.28.0: brief description of main changes"

# 推送 commit 和 tag（一起推送）
git push origin main --tags
```

> **为什么 commit 和 tag 一起推送？** 如果分开推送（先 push commit，再 push tag），tag 的 CI 运行可能在 commit 还没到 remote 时就触发，导致 checkout 失败。`git push origin main --tags` 保证两者原子性到达。

### 第五步：CI 自动接管

推送 tag 后，GitHub Actions（`.github/workflows/release.yml`）自动执行以下流水线：

```
┌─────────────────────────────────────────────────────┐
│                  CI 自动执行的 16 个步骤              │
├─────────────────────────────────────────────────────┤
│                                                      │
│  准备阶段                                            │
│  ├── 1. 检出 tag 对应的代码                          │
│  ├── 2. 配置 JDK 17 + Flutter 3.41.1 + Node 20     │
│  └── 3. 校验 8 个 release secrets 是否配置完整       │
│                                                      │
│  恢复阶段                                            │
│  ├── 4. 从 Secrets 解码 google-services.json         │
│  ├── 5. 从 Secrets 解码 firebase_options.dart        │
│  └── 6. 从 Secrets 解码 keystore + 生成 key.properties│
│                                                      │
│  质量门禁                                            │
│  ├── 7. 验证版本一致性（tag vs pubspec）              │
│  ├── 8. 检查代码格式 (dart format --set-exit-if-changed)│
│  ├── 9. 检查占位符（TODO/FIXME/TBD）                 │
│  ├── 10. 校验 whatsnew 文件内容新鲜度                 │
│  ├── 11. 运行 quality_gate.dart                      │
│  ├── 12. 静态分析 (dart analyze lib test)             │
│  ├── 13. Flutter 单元测试                             │
│  └── 14. Functions 测试 (npm ci && npm test)          │
│                                                      │
│  构建阶段                                            │
│  ├── 15. 构建 release AAB (flutter build appbundle)   │
│  └── 16. 构建 release APK (flutter build apk)        │
│                                                      │
│  发布阶段                                            │
│  ├── 17. 报告构建尺寸到 Step Summary                  │
│  ├── 18. WIF 认证 → 获取 Google Cloud 临时凭证        │
│  ├── 19. 上传 AAB 到 Play production 轨道（100%）     │
│  ├── 20. 重命名 APK 为 hachimi-vX.Y.Z.apk            │
│  ├── 21. Sigstore 溯源证明                            │
│  ├── 22. 创建 GitHub Release（附带 APK + whatsnew）    │
│  └── 23. 生成 Release Summary                         │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### 第六步：监控 CI 构建

推送 tag 后，**立即** 开始监控 CI 运行状态：

```bash
# 查找最近的 workflow 运行
gh run list --limit 3

# 阻塞等待直到完成（成功返回 0，失败返回非零）
gh run watch <RUN_ID> --exit-status
```

**CI 失败的处理流程**：

1. 查看失败日志：`gh run view <RUN_ID> --log-failed`
2. 在本地修复问题
3. 推送修复 commit 到 main
4. **移动 tag 到新的 commit**（关键步骤）：
   ```bash
   # 删除本地旧 tag
   git tag -d v2.28.0
   # 创建新 tag（指向最新 commit）
   git tag -a v2.28.0 -m "v2.28.0: description"
   # 强制推送新 tag（覆盖远端旧 tag）
   git push origin v2.28.0 --force
   ```
5. 监控新的 CI 运行直到全部通过

**常见 CI 失败原因与修复**：

| 失败步骤 | 根因 | 修复方法 |
|---------|------|---------|
| Check formatting | 未对全部文件运行 `dart format` | 运行 `dart format lib/ test/`，提交，移动 tag |
| Verify version consistency | pubspec 版本号与 tag 不匹配 | 修正 pubspec 版本号，提交，移动 tag |
| Static analysis | 新引入了 error 级别的 lint | 修复 lint 问题，提交，移动 tag |
| Build release APK/AAB | 编译错误 | 修复代码，提交，移动 tag |
| Validate whatsnew | whatsnew 文件包含通用 app 描述 | 更新为版本特定内容，提交，移动 tag |
| Check for placeholders | 代码或文档中有 TODO/FIXME | 移除占位符，提交，移动 tag |

### 第七步：验证发布结果

发布完成后，逐项确认：

1. **GitHub Release 页面**：打开 https://github.com/sinnohzeng/hachimi-app/releases
   - 确认 tag、标题、描述正确
   - 确认 APK 附件可下载
   - 确认顶部显示 whatsnew-en-US 的用户视角内容
   - 确认底部显示自动生成的 commit notes

2. **APK 验证**：下载 APK 并在测试设备上安装，验证功能正常

3. **Google Play Console**：打开 Play Console → Hachimi → Releases → Production
   - 确认新版本号出现在 production 轨道
   - 注意：Google 审核可能需要 1-3 天，"审核中" 状态是正常的

4. **构建物溯源**：
   - Actions 运行页面的 Step Summary 应显示 Release 表格
   - https://github.com/sinnohzeng/hachimi-app/attestations 应有新记录

---

## 回滚与紧急修复

CI 直接上传到 **production** 轨道（100% 全量发布）。没有手动推广步骤。

### 关键约束

- **无法撤回**：Google Play 不支持撤回或回退已发布的版本。一旦发布，只能用更高 `versionCode` 的新版本覆盖
- **审核延迟**：Google 审核生产轨道更新通常需要 1-3 天
- **版本替代**：一天内可以推送多个版本，新版本会自动替代前一个版本的审核流程

### 紧急修复流程

```
发现严重 Bug
      │
      ▼
修复代码
      │
      ▼
递增 patch 版本（如 2.28.0 → 2.28.1）
      │
      ▼
git commit + git tag -a v2.28.1 + git push origin main --tags
      │
      ▼
CI 自动构建并上传新版本到 production
      │
      ▼
Google 审核新版本（1-3 天）
      │
      ├── 如果不紧急：等待审核通过
      │
      └── 如果紧急：
          ├── 通过 GitHub Release 页面分发 APK（用户直接下载安装）
          └── 网站 hachimi.ai 的下载按钮指向 GitHub Releases，用户可立即获取
```

### 阶段性发布（Staged Rollout）

目前**不使用**阶段性发布，原因：
- Hachimi 的发版节奏接近每日一次
- Google Play 每条轨道只允许一个活跃的阶段性发布
- 新版本会自动替代旧版本的 rollout，无法观测到单版本的稳定性数据

如果未来发版节奏放缓（如每月一次），可以考虑切换到 `status: inProgress` + `userFraction: 0.2`。

---

## 供应链安全

发布流水线遵循 2025-2026 年供应链安全最佳实践：

### SHA 固定

所有 GitHub Actions 固定到 **commit SHA**（不使用可变的 tag 引用）。这是为了防御类似 `tj-actions` 事件的 tag-repointing 供应链攻击。

```yaml
# 正确示范（SHA 固定）
- uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5  # v4.3.1

# 错误示范（可变 tag）
- uses: actions/checkout@v4  # 攻击者可以修改 v4 tag 指向恶意 commit
```

Dependabot 每周自动创建 PR 更新 Actions 到新版本 SHA，确保不错过安全补丁。

### Environment 隔离

Release secrets（keystore、WIF 凭证等）限定在 GitHub `production` Environment 中：
- 只有 `v*` tag 推送才能触发的 workflow 可以访问这些 secrets
- 普通 commit push、PR 构建、`ci.yml` 都**无法**访问
- 即使有人获得了 PR 提交权限，也无法窃取 release secrets

详细设置步骤参见 [自动发布运行手册](play-auto-release-runbook.md)。

### 构建物溯源证明

每个发布的 APK 通过 Sigstore 进行构建物溯源证明（`actions/attest-build-provenance`）。用户可以验证 APK 确实由官方 CI 构建：

```bash
gh attestation verify hachimi-v2.28.0.apk --repo sinnohzeng/hachimi-app
```

### 零权限默认

workflow 顶层声明 `permissions: {}`（拒绝一切权限），每个 job 仅显式授予所需的最小权限：

```yaml
permissions: {}  # 顶层：零权限

jobs:
  build-and-release:
    permissions:
      contents: write       # 创建 GitHub Release
      id-token: write       # WIF OIDC 认证
      attestations: write   # Sigstore 溯源证明
```

---

## 发版前检查清单

- [ ] `dart format lib/ test/` 已对 **整个** 代码库执行
- [ ] `dart analyze lib/` 无错误
- [ ] `flutter test --exclude-tags golden` 全部通过
- [ ] `pubspec.yaml` 版本号已更新（语义版本 + 构建号）
- [ ] `CHANGELOG.md` 已更新新条目
- [ ] `distribution/whatsnew/whatsnew-*` 已更新全部 5 种语言（≤ 500 字符，版本特定内容）
- [ ] Store Listing 文案已审查（如功能有变化，更新 `docs/release/google-play-listing.md`）
- [ ] 官网 `hachimi-app-website` 仓库的 version badge 和 footer 已更新
- [ ] 所有变更已 commit
- [ ] Git tag 已创建（格式 `v2.28.0`，与 pubspec 版本号一致）
- [ ] commit + tag 一起推送（`git push origin main --tags`）
- [ ] CI workflow 已监控并成功完成
- [ ] GitHub Release 页面显示正确的描述、APK 附件和 commit notes
- [ ] APK 可在测试设备上正常安装和运行
- [ ] Play Console 确认 AAB 已到达 production 轨道
- [ ] APK 溯源证明可在 attestations 页面查看

---

## Release 签名

### Keystore 管理

生产级 keystore（`hachimi-release.jks`）存储在项目仓库外部，**绝不可提交到 git**。

**本地配置方式**：通过 `android/key.properties`（已加入 `.gitignore`）配置签名信息：

```properties
storePassword=你的密码
keyPassword=你的密码
keyAlias=hachimi-release
storeFile=/absolute/path/to/hachimi-release.jks
```

初次配置请运行 `scripts/setup-release-signing.sh`，该脚本会引导你创建 keystore 并生成 `key.properties`。

### 本地构建（可选）

如果你想在本地构建 release APK（不通过 CI）：

```bash
flutter build apk --release
```

需要 `android/key.properties` 文件存在。构建产物位于 `build/app/outputs/flutter-apk/app-release.apk`。

### CI 所需的 GitHub Secrets

CI workflow 需要以下 8 个 secrets。这些 secrets 存储在 GitHub `production` Environment 中（`FIREBASE_OPTIONS_DART` 同时存在于 repo-level）：

| Secret | 用途 | 如何获取 |
|--------|------|---------|
| `KEYSTORE_BASE64` | Base64 编码的生产级 keystore | `base64 < android/app/hachimi-release.jks` |
| `KEYSTORE_PASSWORD` | Keystore 密码 | 创建 keystore 时设置 |
| `KEY_ALIAS` | 签名密钥别名 | 通常为 `hachimi-release` |
| `KEY_PASSWORD` | 密钥密码 | 创建 key 时设置 |
| `GOOGLE_SERVICES_JSON` | Base64 编码的 Firebase 配置 | `base64 < android/app/google-services.json` |
| `FIREBASE_OPTIONS_DART` | Base64 编码的 Firebase 选项 | `base64 < lib/firebase_options.dart` |
| `WIF_PROVIDER` | WIF Provider 全名 | Google Cloud Console 获取 |
| `WIF_SERVICE_ACCOUNT` | 服务账号邮箱 | 格式 `name@project.iam.gserviceaccount.com` |

> 旧版客户端 AI key secrets（`MINIMAX_API_KEY`、`GEMINI_API_KEY`）已不再需要。如果仍然存在，CI 会打印警告但不影响构建。

---

## Google Play Store

> 完整的 WIF + Play Console 配置指南，参见 [Google Play CI/CD 配置指南](google-play-setup.md)。

### 概览

应用以包名 `com.hachimi.hachimi_app` 发布到 Google Play。CI 在每次 `v*` tag 推送时自动上传 AAB 到 **production** 轨道。**无需手动推广**——tag push 即等于生产发布。

### 应用签名

Google Play App Signing 对所有 AAB 上传强制要求。工作原理：

```
你的 keystore (hachimi-release.jks)   →   上传密钥（Upload Key）
                                              │
                                              ▼
                                    Google Play 验证签名
                                              │
                                              ▼
                                    Google 用分发密钥重签名
                                              │
                                              ▼
                                    用户从 Play Store 下载的 APK
                                    使用 Google 的分发密钥签名
```

- 你的 keystore 仅用于 **上传验证**，不是最终用户设备上的签名
- Google 管理实际的分发签名密钥，你无法导出
- 如果上传密钥泄露，可以在 Play Console 申请重置（需要 Google 人工审核）

### Play Store 更新说明（What's New）

Release notes 以纯文本文件存储在 `distribution/whatsnew/` 目录：

```
distribution/whatsnew/
├── whatsnew-en-US    # 英语（美国）
├── whatsnew-zh-CN    # 简体中文
├── whatsnew-zh-TW    # 繁体中文（台湾）
├── whatsnew-ja-JP    # 日语
└── whatsnew-ko-KR    # 韩语
```

- 文件命名遵循 `r0adkll/upload-google-play` 规范：`whatsnew-{BCP47 语言代码}`
- 每个文件 ≤ 500 字符（Google Play 硬性限制）
- 每次发版前必须更新全部 5 个文件
- CI 会自动上传到 Play Store 对应语言的 "What's New" 区域

### Store Listing 文案（SSOT）

所有商店上架文字（应用名称、简短描述、完整描述）维护在 [google-play-listing.md](google-play-listing.md) 中作为 SSOT。当功能有重大变化时，更新文档后手动复制到 Play Console。

### 身份验证：Workload Identity Federation（WIF）

CI 通过 WIF 向 Google Cloud 认证——**无需长期服务账号密钥**。认证流程：

```
GitHub Actions Runner
        │
        ├── 1. 向 GitHub 请求 OIDC Token
        │      （token 包含仓库名、分支、触发者等信息）
        │
        ├── 2. 将 OIDC Token 发送给 Google Cloud
        │
        ├── 3. Google Cloud 验证 Token：
        │      - 签发者是否为 GitHub？
        │      - 仓库是否为 sinnohzeng/hachimi-app？
        │      - 是否匹配 WIF Provider 的 attribute-condition？
        │
        ├── 4. 验证通过 → 签发短期 Google Cloud 凭证
        │
        └── 5. 使用短期凭证调用 Google Play Publishing API
```

**安全优势**：
- 无需存储长期密钥（降低泄露风险）
- 凭证自动过期（每次 CI 运行生成新的）
- 严格绑定仓库（其他仓库无法冒充）

详细配置步骤参见 [Google Play CI/CD 配置指南](google-play-setup.md)。

Release secrets 限定在 GitHub `production` Environment 中（非仓库级别）。配置方法参见 [自动发布运行手册](play-auto-release-runbook.md)。

### 首次发布

首个 AAB 必须通过 Play Console 网页手动上传。Google Play API 要求应用已有至少一个上传记录后，才能通过 API 上传后续版本。详见 [Google Play CI/CD 配置指南](google-play-setup.md) 第七步。

---

## 官网同步

官网（`hachimi-app-website` 仓库，位于 `/data/workspace/hachimi-app-website`）每次发版时必须同步更新。以下 3 个硬编码位置需要更新版本号：

| 文件 | 大约行号 | 更新内容 |
|------|---------|---------|
| `lib/i18n/en.ts` | ~15 | Hero badge：`vX.Y.Z — Release highlight` |
| `lib/i18n/zh.ts` | ~15 | Hero badge（中文）：`vX.Y.Z — 发布亮点` |
| `components/footer.tsx` | ~70 | Footer 版本号：`vX.Y.Z` |

更新后提交并推送到官网仓库：

```bash
cd /data/workspace/hachimi-app-website
# 编辑上述 3 个文件中的版本号
git add -A && git commit -m "feat: update version to vX.Y.Z"
git push origin main
```

### 下载链接

https://hachimi.ai 上的下载按钮同时链接到：
- **GitHub Releases**：https://github.com/sinnohzeng/hachimi-app/releases （GitHub 自动在顶部显示最新 Release）
- **Google Play**：https://play.google.com/store/apps/details?id=com.hachimi.hachimi_app

---

## 相关文档

| 文档 | 说明 |
|------|------|
| [Google Play CI/CD 配置指南](google-play-setup.md) | WIF、服务账号、Play Console 完整配置步骤 |
| [Google Play 商店文案](google-play-listing.md) | 商店上架文字 SSOT（5 种语言） |
| [自动发布运行手册](play-auto-release-runbook.md) | Environment 设置、Secrets 迁移、日常运维 |
| [自动发布计划文档](../plan/20260306-play-auto-release-plan.md) | 本次自动化改造的决策记录 |
