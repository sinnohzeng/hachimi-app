# Hachimi App — 发布流程

> **SSOT**: 本文档是 Hachimi App GitHub Release 发布方式的唯一真实来源。

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

## 版本命名规范

遵循 [语义化版本](https://semver.org/lang/zh-CN/)：

| 组成部分 | 含义 |
|----------|------|
| `主版本` | 重大变更或里程碑（如 1→2） |
| `次版本` | 新功能或重大改进（如 1.0→1.1） |
| `补丁版本` | Bug 修复或小调整（如 1.0.0→1.0.1） |
| `+构建号` | Flutter 内部构建号 — 每次发布递增 1 |

**示例：**
- `1.0.0+1` → 首次公开发布（`v1.0.0`）
- `1.1.0+2` → 新增功能
- `1.1.1+3` → Bug 修复

## 发布步骤

### 第一步 — 更新 `pubspec.yaml` 中的版本号

```yaml
# pubspec.yaml
version: 1.1.0+2   # 同时更新语义版本号和构建号
```

提交版本号变更：

```bash
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"
```

### 第二步 — 创建 git tag 并推送

```bash
git tag v1.1.0
git push && git push --tags
```

> **重要**：tag 版本号必须与 `pubspec.yaml` 中的语义版本号一致（不含 `+构建号`）。

### 第 2.5 步 — 打 tag 前格式化整个代码库

```bash
dart format lib/ test/
```

> **关键**：必须对所有文件运行 `dart format`，而不仅是你编辑过的文件。CI 强制执行 `--set-exit-if-changed`，任何未格式化的文件都会导致失败。添加命名参数可能导致行长超限，formatter 会重排你没有直接修改的文件。

### 第三步 — CI 自动接管

GitHub Actions（`.github/workflows/release.yml`）将自动执行：

1. 检出 tag 对应的代码
2. 配置 JDK 17 + Flutter 3.41.1
3. 从 GitHub Secrets 恢复 Firebase 配置文件和签名 keystore
4. 验证版本一致性（tag 必须与 pubspec 版本号匹配）
5. 检查代码格式（`dart format --set-exit-if-changed lib/ test/`）
6. 运行 `dart analyze lib/`
7. 运行测试（`flutter test --exclude-tags golden`）
8. 构建 release 签名 AAB（`flutter build appbundle --release`）
9. 构建 release 签名 APK（`flutter build apk --release`）
10. 报告 APK + AAB 构建尺寸
11. 通过 `r0adkll/upload-google-play` 上传 AAB 到 Google Play internal 轨道
12. 将 APK 重命名为 `hachimi-vX.Y.Z.apk`
13. 创建 GitHub Release 并附上 APK

### 第 3.5 步 — 监控 CI 构建

推送 tag 后，立即监控 GitHub Actions 运行状态：

```bash
# 查找 run ID
gh run list --limit 3

# 阻塞等待直到完成
gh run watch <RUN_ID> --exit-status
```

如果 CI 失败：
1. 读取失败步骤日志：`gh run view <RUN_ID> --log-failed`
2. 在本地修复问题（最常见：`dart format` 失败）
3. 推送修复 commit 到 main
4. 移动 tag：`git tag -d vX.Y.Z && git tag -a vX.Y.Z -m "..."` 然后 `git push origin vX.Y.Z --force`
5. 监控新的 CI 运行直到通过

### 第四步 — 创建面向用户的 GitHub Release

使用 `gh release create` 并编写面向用户的发布说明。Release 页面是用户从官网看到的内容——绝不能只放一个 CHANGELOG 链接。

**必须遵循的结构：**

```markdown
## What's New in vX.Y.Z

### [功能标题]
[2-3 句通俗易懂的描述。聚焦于用户能感受到的变化。]

### [另一项变化]
[同样的方式——以用户价值为导向，避免技术术语。]

---

**Full changelog:** [CHANGELOG.md](https://github.com/sinnohzeng/hachimi-app/blob/main/CHANGELOG.md)
```

**写作原则：**
- 用户优先——解释用户体验到了什么变化，而非实现细节
- 合并关联改动——将小修复归纳为逻辑性的段落
- 通俗语言——避免 "ConsumerWidget"、"surfaceContainerHigh" 等术语
- 同时包含面向用户的介绍和底部的 CHANGELOG 链接

### 第五步 — 验证

1. 打开 https://github.com/sinnohzeng/hachimi-app/releases
2. 确认 Release 标签、标题、描述和 APK 附件显示正确
3. 下载并安装 APK，验证功能正常
4. 检查 Google Play Console — 确认 AAB 已到达 internal 轨道

### 第六步 — 推广到正式版（手动）

CI 仅上传到 **internal** 轨道。推广到正式版的操作：

1. 打开 [Google Play Console](https://play.google.com/console) → Hachimi → 发布 → 正式版
2. 新建正式版发布
3. 从 internal 轨道添加 AAB
4. 审核并发布

> **说明**：企业主体账号无需满足 12 人 × 14 天封闭测试要求。内部测试验证通过后可直接推广到正式版。

## 发布前检查清单

- [ ] `CHANGELOG.md` 已更新新条目
- [ ] `distribution/whatsnew/en-US` 已更新 Play Store 发布说明（≤500 字符）
- [ ] `pubspec.yaml` 版本号已更新（语义版本 + 构建号）
- [ ] `dart format lib/ test/` 已对整个代码库执行
- [ ] `dart analyze lib/` 无错误
- [ ] 所有变更已 commit
- [ ] Git tag 已创建（如 `v1.1.0`）
- [ ] Tag 已推送到远程（`git push origin main --tags`）
- [ ] GitHub Actions workflow 已监控并成功完成
- [ ] GitHub Release 已创建，包含面向用户的描述和 APK 附件
- [ ] APK 可在测试设备上正常安装和运行
- [ ] AAB 已上传到 Google Play internal 轨道
- [ ] 在 Play Console 推广到正式版（如适用）

## Release 签名

### Keystore

生产级 keystore（`hachimi-release.jks`）存储在项目仓库外部，绝不可提交到 git。通过 `android/key.properties`（已 gitignore）进行配置。

### 本地构建（可选）

本地构建 release APK：

```bash
flutter build apk --release
```

需要 `android/key.properties` 文件存在。初次配置请运行 `scripts/setup-release-signing.sh`。

### GitHub Secrets

CI workflow 需要在仓库中配置以下 Secrets：

| Secret | 用途 |
|--------|------|
| `KEYSTORE_BASE64` | Base64 编码的生产级 keystore |
| `KEYSTORE_PASSWORD` | Keystore 密码 |
| `KEY_ALIAS` | 签名密钥别名 |
| `KEY_PASSWORD` | 密钥密码 |
| `GOOGLE_SERVICES_JSON` | Base64 编码的 `google-services.json` |
| `FIREBASE_OPTIONS_DART` | Base64 编码的 `firebase_options.dart` |
| `MINIMAX_API_KEY` | MiniMax AI 功能的 API 密钥 |
| `GEMINI_API_KEY` | Google Gemini AI 功能的 API 密钥 |
| `WIF_PROVIDER` | Workload Identity Federation Provider 全名 |
| `WIF_SERVICE_ACCOUNT` | 用于 Play Store 上传的 Google Cloud 服务账号邮箱 |

运行 `scripts/setup-release-signing.sh` 可自动生成 keystore 相关的值。

## Google Play Store

> 完整的配置指南（WIF、服务账号、Play Console 配置）请参见 [`docs/release/google-play-setup.md`](google-play-setup.md)。

### 概览

应用以包名 `com.hachimi.hachimi_app` 发布到 Google Play。CI 在每次 tag 推送时自动上传 AAB 到 **internal** 轨道。推广到正式版需在 Play Console 手动操作。

### 应用签名

Google Play App Signing 对所有 AAB 上传强制要求。现有 keystore（`hachimi-release.jks`）作为**上传密钥**。Google 管理实际的分发签名密钥。

### Play Store 更新说明

文件 `distribution/whatsnew/en-US` 包含 Play Store 发布说明。每次发布前更新此文件。最多 500 字符。

### 身份验证：Workload Identity Federation

CI 通过 **Workload Identity Federation（WIF）** 向 Google Cloud 认证 — 无需长期服务账号密钥。GitHub Actions 请求短期 OIDC Token，Google Cloud 验证后签发临时凭证。

配置步骤：
1. 在 Google Cloud 中创建 Workload Identity Pool 和 OIDC Provider（绑定 `sinnohzeng/hachimi-app`）
2. 创建服务账号并在 Play Console 中授予 **Release manager** 权限
3. 授予服务账号 `roles/iam.workloadIdentityUser` 到 WIF Pool
4. 将 Provider 全名存为 `WIF_PROVIDER`，服务账号邮箱存为 `WIF_SERVICE_ACCOUNT`，添加到 GitHub Secrets

详细配置参见 [Google Cloud Workload Identity Federation 文档](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines)。

### 首次发布

首个 AAB 必须通过 Play Console 网页手动上传，之后 CI 才能自动上传后续版本。

## 与官网的关系

https://hachimi.ai 上的下载按钮同时链接到：
- GitHub Releases：https://github.com/sinnohzeng/hachimi-app/releases
- Google Play：https://play.google.com/store/apps/details?id=com.hachimi.hachimi_app

GitHub 自动在顶部显示最新 Release。Google Play 更新通过 Play Console 推广流程管理。
