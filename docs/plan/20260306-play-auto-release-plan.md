# 计划：Play 自动发布 + 供应链安全加固

> 日期：2026-03-06 | 状态：Active | 范围：CI/CD 管线

## 目标

将发布管线从"tag > internal 轨道 > 手动推广"升级为"tag > 生产轨道（自动）"，同时加固供应链安全。

## 关键决策

| 决策 | 选择 | 理由 |
|------|------|------|
| 发布轨道 | 生产轨道（100% 发布） | 近乎每日的发布节奏使分阶段发布不现实 |
| 认证方式 | WIF/OIDC（不变） | 已是最佳实践的无密钥认证 |
| Action 锁定 | Commit SHA + Dependabot | 防止 tag 重指向供应链攻击 |
| Secrets 隔离 | GitHub `production` Environment | 仅 `v*` tag 可访问发布 secrets |
| 构建来源证明 | Sigstore attestation | 可验证的 APK 来源 |

## 已执行变更

| 文件 | 变更内容 |
|------|----------|
| `.github/workflows/release.yml` | SHA 锁定、`permissions: {}`、`environment: production`、`track: production`、whatsnew 校验、来源证明、增强版 release body + summary |
| `.github/workflows/ci.yml` | 4 个 action 的 SHA 锁定 |
| `.github/dependabot.yml` | 新增——每周更新 GitHub Actions |
| `distribution/whatsnew/*` | 版本特定内容（原为通用描述） |
| `docs/release/process.md` | 生产轨道、回滚流程、供应链安全 |
| `docs/release/google-play-setup.md` | Environment 设置、生产轨道 |
| `docs/release/play-auto-release-runbook.md` | 新增——手动设置指南 + 运维操作 |
| `.claude/rules/12-workflow-release.md` | 生产轨道、whatsnew 校验失败模式 |

## 延后事项（过度工程）

- RC tag 路由（`vX.Y.Z-rc.N`）——历史上从未使用
- 通过 Dart 脚本自动生成 whatsnew——在 500 字符限制下易出错
- 国家可用性漂移检测——当前无排除项
- 4-job workflow 拆分——增加开销但无实际收益
- 分阶段发布——与每日发布节奏不兼容

## 所需手动步骤

详细说明参见 `docs/release/play-auto-release-runbook.md`。

## 变更记录

| 日期 | 变更 |
|------|------|
| 2026-03-06 | 初始计划创建并执行 |
