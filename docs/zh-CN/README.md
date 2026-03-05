# Hachimi — 文档索引

> **文档驱动开发（DDD）：** 所有功能、行为和架构决策均在 `docs/` 目录中**先于实现**进行规范。文档是契约，代码是实现。当文档与代码产生冲突时，以文档为准。

---

## 架构

| 文档 | 说明 |
|------|------|
| [架构概览](architecture/overview.md) | 系统设计、技术栈、依赖层级、核心模式 |
| [数据模型](architecture/data-model.md) | Firestore 数据模型（SSOT）——所有集合、字段及原子操作 |
| [猫咪系统](architecture/cat-system.md) | 猫咪游戏设计（SSOT）——品种、XP、心情、房间槽位、生成算法 |
| [状态管理](architecture/state-management.md) | Riverpod Provider 图谱（SSOT）——所有 Provider 及其职责 |
| [目录结构](architecture/folder-structure.md) | 目录布局、命名规范、层级规则 |
| [可观测性架构](architecture/observability.md) | 错误遥测契约、Callable 链路追踪与 AI 分诊闭环 |

---

## 产品

| 文档 | 说明 |
|------|------|
| [PRD v3.0](product/prd.md) | 完整产品需求文档——功能、导航、分析策略 |
| [用户故事](product/user-stories.md) | 用户故事与验收标准 |

---

## Firebase

| 文档 | 说明 |
|------|------|
| [配置指南](firebase/setup-guide.md) | Firebase 从零配置步骤 |
| [凭据与 Secrets 指南](firebase/credentials-and-secrets.md) | 云端凭据、Secret Manager 流程与 GitHub Actions 密钥配置 |
| [Terraform IaC](../../infra/terraform/README.md) | 可观测性、告警、预算、Secrets、IAM 的长期资源入口 |
| [分析事件](firebase/analytics-events.md) | GA4 自定义事件定义（SSOT）——所有事件、参数、用户属性 |
| [安全规则](firebase/security-rules.md) | Firestore 安全规则规范及部署说明 |
| [Cloud Functions](firebase/setup-guide.md#cloud-functions-账户生命周期) | 账户生命周期 callable 部署与本地验证 |
| [可观测性运行手册](firebase/observability-runbook.md) | BigQuery/告警/AI 分诊运维清单 |

---

## 计划

| 文档 | 说明 |
|------|------|
| [20260304 生命周期重构计划](plan/20260304-account-lifecycle-refactor-governance-plan.md) | 离线优先账户生命周期、质量闸门与 SSOT 治理 |
| [20260305 可观测性闭环计划](plan/20260305-observability-ai-debug-closed-loop-plan.md) | Blaze + Google Chat/Email 可观测性与 AI Debug 自动化 |
| [20260305 安全现代化整改计划](plan/20260305-security-modernization-collaboration-plan.md) | Google 优先凭据治理、无长期静态密钥与 Terraform 治理 |

---

## 已归档

| 文档 | 说明 |
|------|------|
| [远程配置（已归档）](archive/firebase/remote-config.md) | 历史资料保留，仅供追溯，不再属于当前架构 |

---

## 设计

| 文档 | 说明 |
|------|------|
| [设计系统](design/design-system.md) | Material 3 主题（SSOT）——色彩系统、排版、组件、间距 |
| [界面规范](design/screens.md) | 各界面布局、交互及分析事件 |

---

## 指南

| 文档 | 说明 |
|------|------|
| [开发工作流](guides/development-workflow.md) | 构建模式、热重载、调试工具、日常开发循环 |
| [开发调试环境启动](guides/dev-debug-setup.md) | 设备连接、Firebase 凭证、安装故障排查 |
| [Git Worktree](guides/git-worktree.md) | 使用 Git Worktree 和 Claude Code 进行并行开发 |

---

## 贡献

| 文档 | 说明 |
|------|------|
| [贡献指南](CONTRIBUTING.md) | 开发工作流、分支命名、提交规范 |

---

## 英文文档

| Document | Description |
|----------|-------------|
| [English Documentation Index](../README.md) | All documents in English |
