# Hachimi App — 发布流程

> **SSOT**: 本文档是 Hachimi App GitHub Release 发布方式的唯一真实来源。

## 概览

| 关注点 | 值 |
|--------|-----|
| 发布平台 | GitHub Releases（`sinnohzeng/hachimi-app`） |
| APK 类型 | Debug APK（用于直接分发 / 侧载安装） |
| 版本格式 | `pubspec.yaml` version 字段（`主版本.次版本.补丁版本+构建号`） |
| 发布页面 | https://github.com/sinnohzeng/hachimi-app/releases |

> **说明**：https://hachimi.ai 上的下载按钮直接指向此发布页面。

## 版本命名规范

遵循[语义化版本](https://semver.org/lang/zh-CN/)：

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

构建前先提交版本号变更：

```bash
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"
```

### 第二步 — 构建 APK

```bash
flutter build apk --debug
```

输出 APK 路径：
```
build/app/outputs/flutter-apk/app-debug.apk
```

### 第三步 — 创建 GitHub Release

使用 `gh` CLI 一次性创建 Release 并附上 APK：

```bash
gh release create v1.0.0 \
  build/app/outputs/flutter-apk/app-debug.apk \
  --title "Hachimi v1.0.0" \
  --notes "$(cat <<'EOF'
## 新增内容

- 首次公开发布
- 猫咪养成游戏化系统
- 专注计时器 + XP 奖励
- Firebase 同步 + 离线支持
- Google 一键登录

## 安装方法

1. 下载 `app-debug.apk`
2. 在 Android 上：**设置 → 安全 → 安装未知应用** → 为浏览器/文件管理器开启权限
3. 点击下载的 APK 文件进行安装

> 这是用于直接侧载安装的 Debug 构建版本。Google Play 正式发布计划中。
EOF
)"
```

### 第四步 — 验证

1. 打开 https://github.com/sinnohzeng/hachimi-app/releases
2. 确认 Release 标签、标题和 APK 附件显示正确
3. 下载并安装 APK，验证其有效性

### 第五步 — 推送剩余提交

```bash
git push
```

## 发布前检查清单

- [ ] `pubspec.yaml` 版本号已更新
- [ ] 版本号变更已提交
- [ ] `flutter build apk --debug` 成功完成
- [ ] `gh release create` 已运行并附上 APK
- [ ] https://github.com/sinnohzeng/hachimi-app/releases 页面显示新 Release
- [ ] APK 可在测试设备上正常安装和运行

## 与官网的关系

https://hachimi.ai 上的下载按钮链接到：
```
https://github.com/sinnohzeng/hachimi-app/releases
```

GitHub 自动在顶部显示最新 Release。发布新版本时无需修改官网。
