# Hachimi.ai Official Website — Deployment & Maintenance Guide

> **SSOT**: This document is the single source of truth for how the hachimi.ai official website is deployed, maintained, and updated.

## Overview

| Concern | Value |
|---------|-------|
| Live URL | https://hachimi.ai |
| Fallback URL | https://hachimi-ai.pages.dev |
| Source repo | [sinnohzeng/hachimi-app-website](https://github.com/sinnohzeng/hachimi-app-website) |
| Hosting | Cloudflare Pages (free tier) |
| DNS / CDN | Cloudflare (zone: hachimi.ai) |
| SSL | Auto-provisioned by Cloudflare (Let's Encrypt) |
| Build step | None — pure static HTML, no bundler |
| Tech stack | HTML + Tailwind CSS (CDN) + vanilla JS |

## Architecture: Two Separate Repos

```
sinnohzeng/hachimi-app           ← Flutter mobile app (this repo)
sinnohzeng/hachimi-app-website   ← Official website (separate repo)
```

**Why separate?**
- The website is a static HTML page; the app is a Flutter project. Different toolchains, different deploy targets.
- Cloudflare Pages deploys from a single Git repo. Keeping the website in its own repo gives it a clean, independent deploy pipeline.
- Changes to the website never affect the app, and vice versa.

## Repo Structure

```
hachimi-app-website/
├── index.html      # The entire website (single-page)
├── CNAME           # Custom domain config
├── .gitignore      # Ignores .wrangler/, node_modules/, .DS_Store
└── .git/
```

## Deployment Pipeline

### How it works

```
git push to main → Cloudflare Pages auto-builds → Live at hachimi.ai
```

Cloudflare Pages is connected to the GitHub repo `sinnohzeng/hachimi-app-website`. On every push to `main`, Cloudflare Pages automatically pulls the latest code and deploys it. There is no build command — Cloudflare serves the static files directly.

### Custom domain binding

| Domain | Status |
|--------|--------|
| `hachimi.ai` | Bound to Cloudflare Pages project `hachimi-ai` |
| `www.hachimi.ai` | Bound to Cloudflare Pages project `hachimi-ai` |
| `hachimi-ai.pages.dev` | Default Cloudflare Pages subdomain (always works) |

DNS records are auto-managed by Cloudflare since the zone `hachimi.ai` is on the same Cloudflare account.

### Cloudflare Pages project settings

| Setting | Value |
|---------|-------|
| Project name | `hachimi-ai` |
| Production branch | `main` |
| Build command | _(empty — no build step)_ |
| Build output directory | _(empty — serve root)_ |
| Root directory | `/` |

## How to Update the Website

### 1. Edit locally

```bash
cd ~/projects/hachimi-app-website
# Edit index.html
```

### 2. Preview locally

Open `index.html` directly in a browser, or use any local server:

```bash
npx serve .
# or
python3 -m http.server 8000
```

### 3. Deploy

```bash
git add -A
git commit -m "feat: update website content"
git push
```

Cloudflare Pages picks up the push automatically. The site updates within ~30 seconds.

### 4. Manual deploy (alternative)

If you need to deploy without pushing to Git (e.g., testing):

```bash
CLOUDFLARE_API_TOKEN="<your-token>" \
CLOUDFLARE_ACCOUNT_ID="<your-account-id>" \
wrangler pages deploy . --project-name hachimi-ai
```

## Relationship to Other Projects

### Personal portfolio (zixuan.net)

The portfolio website at `zixuan.net` includes Hachimi.ai as a featured project in the Projects section. The project modal links to:
- https://hachimi.ai (official website)
- https://github.com/sinnohzeng/hachimi-app (source code)

### Resume

The resume (in the zixuan-net-website repo) includes Hachimi.ai as the first item under SELECTED PROJECTS.

### Cross-reference map

| Asset | Location | Purpose |
|-------|----------|---------|
| App source code | `sinnohzeng/hachimi-app` | Flutter mobile app |
| App architecture docs | `hachimi-app/docs/` | DDD specs (this repo) |
| Official website | `sinnohzeng/hachimi-app-website` | Product landing page |
| Website deployment docs | `hachimi-app/docs/website/` | This document |
| Portfolio project entry | `zixuan-net-website/src/components/sections/Projects.tsx` | Project showcase |
| Portfolio i18n | `zixuan-net-website/src/i18n/index.ts` | EN/ZH translations |
| Resume entry | `zixuan-net-website/resume-*.md` | Job application |

> **Note:** The portfolio site (zixuan.net) is also deployed via Cloudflare Pages with GitHub auto-deploy — same pattern as hachimi.ai.

## Troubleshooting

### Site not updating after push
- Check Cloudflare Pages dashboard for deployment status
- Verify the GitHub repo connection in Pages > hachimi-ai > Settings > Builds & deployments
- Clear browser cache / try incognito

### SSL certificate issues
- Cloudflare auto-provisions Let's Encrypt certificates
- Initial provisioning may take up to 15 minutes
- Check status: Cloudflare Dashboard > Pages > hachimi-ai > Custom domains

### `.wrangler/` directory appearing
- This is a local cache created by the `wrangler` CLI tool
- Already in `.gitignore` for both repos — safe to ignore
- Can be deleted: `rm -rf .wrangler/`
