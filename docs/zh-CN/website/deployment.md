# Hachimi.ai 官方网站 — 部署与维护指南

> **SSOT**: 本文档是 hachimi.ai 官方网站部署、维护和更新方式的唯一真实来源。

## 概览

| 关注点 | 值 |
|--------|------|
| 线上地址 | https://hachimi.ai |
| 备用地址 | https://hachimi-ai.pages.dev |
| 源码仓库 | [sinnohzeng/hachimi-app-website](https://github.com/sinnohzeng/hachimi-app-website) |
| 托管平台 | Cloudflare Pages（免费套餐） |
| DNS / CDN | Cloudflare（zone: hachimi.ai） |
| SSL 证书 | Cloudflare 自动签发（Let's Encrypt） |
| 构建步骤 | 无 — 纯静态 HTML，无打包工具 |
| 技术栈 | HTML + Tailwind CSS (CDN) + 原生 JS |

## 架构：两个独立仓库

```
sinnohzeng/hachimi-app           ← Flutter 移动端应用（本仓库）
sinnohzeng/hachimi-app-website   ← 官方网站（独立仓库）
```

**为什么分开？**
- 网站是纯静态 HTML；应用是 Flutter 项目。不同工具链、不同部署目标。
- Cloudflare Pages 从单个 Git 仓库部署。独立仓库让网站有自己干净的部署流水线。
- 网站的修改不会影响应用，反之亦然。

## 仓库结构

```
hachimi-app-website/
├── index.html      # 整个网站（单页面）
├── CNAME           # 自定义域名配置
├── .gitignore      # 忽略 .wrangler/、node_modules/、.DS_Store
└── .git/
```

## 部署流水线

### 工作原理

```
git push 到 main → Cloudflare Pages 自动构建 → 上线 hachimi.ai
```

Cloudflare Pages 已连接到 GitHub 仓库 `sinnohzeng/hachimi-app-website`。每次推送到 `main` 分支，Cloudflare Pages 会自动拉取最新代码并部署。没有构建命令 — Cloudflare 直接提供静态文件服务。

### 自定义域名绑定

| 域名 | 状态 |
|------|------|
| `hachimi.ai` | 已绑定到 Cloudflare Pages 项目 `hachimi-ai` |
| `www.hachimi.ai` | 已绑定到 Cloudflare Pages 项目 `hachimi-ai` |
| `hachimi-ai.pages.dev` | Cloudflare Pages 默认子域（始终可用） |

DNS 记录由 Cloudflare 自动管理，因为 `hachimi.ai` 域名在同一个 Cloudflare 账号下。

### Cloudflare Pages 项目配置

| 配置项 | 值 |
|--------|------|
| 项目名称 | `hachimi-ai` |
| 生产分支 | `main` |
| 构建命令 | _（空 — 无需构建）_ |
| 构建输出目录 | _（空 — 直接服务根目录）_ |
| 根目录 | `/` |

## 如何更新网站

### 1. 本地编辑

```bash
cd ~/projects/hachimi-app-website
# 编辑 index.html
```

### 2. 本地预览

直接在浏览器中打开 `index.html`，或使用本地服务器：

```bash
npx serve .
# 或者
python3 -m http.server 8000
```

### 3. 部署

```bash
git add -A
git commit -m "feat: 更新网站内容"
git push
```

Cloudflare Pages 自动检测推送，网站约 30 秒内更新。

### 4. 手动部署（备选方案）

如果需要不经过 Git 推送直接部署（例如测试）：

```bash
CLOUDFLARE_API_TOKEN="<你的-token>" \
CLOUDFLARE_ACCOUNT_ID="<你的-account-id>" \
wrangler pages deploy . --project-name hachimi-ai
```

## 与其他项目的关系

### 个人作品集网站（zixuan.net）

作品集网站 `zixuan.net` 将 Hachimi.ai 作为精选项目展示在 Projects 区域。项目弹窗链接至：
- https://hachimi.ai（官方网站）
- https://github.com/sinnohzeng/hachimi-app（源代码）

### 简历

简历（zixuan-net-website 仓库中）将 Hachimi.ai 列为 SELECTED PROJECTS 的第一项。

### 交叉引用地图

| 资产 | 位置 | 用途 |
|------|------|------|
| App 源代码 | `sinnohzeng/hachimi-app` | Flutter 移动应用 |
| App 架构文档 | `hachimi-app/docs/` | DDD 规格文档（本仓库） |
| 官方网站 | `sinnohzeng/hachimi-app-website` | 产品着陆页 |
| 网站部署文档 | `hachimi-app/docs/website/` | 本文档 |
| 作品集项目条目 | `zixuan-net-website/src/.../Projects.tsx` | 项目展示 |
| 作品集国际化 | `zixuan-net-website/src/i18n/index.ts` | 中英文翻译 |
| 简历条目 | `zixuan-net-website/resume-*.md` | 求职投递 |

> **注意**：作品集网站（zixuan.net）也通过 Cloudflare Pages + GitHub 自动部署 — 与 hachimi.ai 相同的模式。

## 故障排除

### 推送后网站未更新
- 在 Cloudflare Pages 面板查看部署状态
- 确认 GitHub 仓库连接：Pages > hachimi-ai > Settings > Builds & deployments
- 清除浏览器缓存 / 尝试无痕模式

### SSL 证书问题
- Cloudflare 自动签发 Let's Encrypt 证书
- 首次签发可能需要最多 15 分钟
- 查看状态：Cloudflare Dashboard > Pages > hachimi-ai > Custom domains

### 出现 `.wrangler/` 目录
- 这是 `wrangler` CLI 工具创建的本地缓存
- 两个仓库的 `.gitignore` 都已忽略它 — 可以安全忽略
- 可以直接删除：`rm -rf .wrangler/`
