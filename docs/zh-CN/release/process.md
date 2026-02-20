# Hachimi App — 发布流程

> **SSOT**: 本文档是 Hachimi App GitHub Release 发布方式的唯一真实来源。

## 概览

| 关注点 | 值 |
|--------|-----|
| 发布平台 | GitHub Releases（`sinnohzeng/hachimi-app`） |
| APK 类型 | Release 签名 APK（AOT 编译、代码压缩） |
| 构建方式 | GitHub Actions 自动化（tag 触发） |
| 签名方式 | 生产级 keystore（`hachimi-release.jks`） |
| 版本格式 | `pubspec.yaml` version 字段（`主版本.次版本.补丁版本+构建号`） |
| 发布页面 | https://github.com/sinnohzeng/hachimi-app/releases |

> **说明**：https://hachimi.ai 上的下载按钮直接指向此发布页面。

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

### 第三步 — CI 自动接管

GitHub Actions（`.github/workflows/release.yml`）将自动执行：

1. 检出 tag 对应的代码
2. 配置 JDK 17 + Flutter 3.41.1
3. 从 GitHub Secrets 恢复 Firebase 配置文件和签名 keystore
4. 运行 `dart analyze lib/`
5. 构建 release 签名 APK（`flutter build apk --release`）
6. 将 APK 重命名为 `hachimi-vX.Y.Z.apk`
7. 创建 GitHub Release，自动生成 release notes 并附上 APK

### 第四步 — 验证

1. 打开 https://github.com/sinnohzeng/hachimi-app/releases
2. 确认 Release 标签、标题和 APK 附件显示正确
3. 下载并安装 APK，验证功能正常

## 发布前检查清单

- [ ] `pubspec.yaml` 版本号已更新
- [ ] 版本号变更已提交
- [ ] Git tag 已创建（如 `v1.1.0`）
- [ ] Tag 已推送到远程（`git push --tags`）
- [ ] GitHub Actions workflow 运行成功
- [ ] https://github.com/sinnohzeng/hachimi-app/releases 页面显示新 Release
- [ ] APK 可在测试设备上正常安装和运行

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

运行 `scripts/setup-release-signing.sh` 可自动生成这些值。

## 与官网的关系

https://hachimi.ai 上的下载按钮链接到：
```
https://github.com/sinnohzeng/hachimi-app/releases
```

GitHub 自动在顶部显示最新 Release。发布新版本时无需修改官网。
