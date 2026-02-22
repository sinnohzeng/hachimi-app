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
| Tech stack | Next.js 16 + React 19 + Tailwind CSS v4 + Three.js |
| Build command | `npm run build` |
| Build output | `out/` (static export) |
| i18n | `/en` and `/zh` routes via `[locale]` dynamic segment |

## Architecture: Two Separate Repos

```
sinnohzeng/hachimi-app           ← Flutter mobile app (this repo)
sinnohzeng/hachimi-app-website   ← Official website (separate repo)
```

**Why separate?**
- The website is a Next.js project; the app is a Flutter project. Different toolchains, different deploy targets.
- Cloudflare Pages deploys from a single Git repo. Keeping the website in its own repo gives it a clean, independent deploy pipeline.
- Changes to the website never affect the app, and vice versa.

## Repo Structure

```
hachimi-app-website/
├── app/
│   ├── globals.css            # Tailwind v4 + CSS custom properties (amber theme)
│   ├── layout.tsx             # Root layout (fonts + globals)
│   ├── page.tsx               # Root redirect → /en or /zh based on browser lang
│   ├── robots.ts              # robots.txt (static export)
│   ├── sitemap.ts             # sitemap.xml (/en + /zh)
│   └── [locale]/
│       ├── layout.tsx         # Locale-aware layout (Header, Providers, ThemeSwitch)
│       └── page.tsx           # Home page (all sections)
├── components/
│   ├── hero.tsx               # Three.js aurora shader + CTA
│   ├── header.tsx             # Flat nav + LangSwitch (no dropdowns)
│   ├── lang-switch.tsx        # EN | 中文 locale toggle
│   ├── feature-cards.tsx      # 3 feature cards with screenshot placeholders
│   ├── feature-highlight.tsx  # Cat room showcase with phone mockup
│   ├── principles.tsx         # "Why Hachimi?" 4-card grid
│   ├── stats.tsx              # Animated counters (breeds, accessories, etc.)
│   ├── faq.tsx                # Accordion FAQ
│   ├── final-cta.tsx          # Three.js shader + download CTA
│   ├── footer.tsx             # Simplified footer with GitHub links
│   ├── providers.tsx          # ThemeProvider + ReducedMotion + SmoothScroll
│   ├── theme-switch.tsx       # Floating dark mode toggle
│   ├── theme-toggle.tsx       # Header theme toggle
│   ├── smooth-scroll.tsx      # Lenis smooth scrolling
│   ├── gradual-blur.tsx       # Reusable blur mask
│   └── skip-to-content.tsx    # Accessibility landmark
├── lib/
│   ├── config.ts              # Site config + feature flags
│   ├── metadata.ts            # SEO metadata (hachimi.ai)
│   ├── motion.tsx             # Animation utilities
│   └── i18n/
│       ├── types.ts           # Translation key types
│       ├── en.ts              # English translations
│       ├── zh.ts              # Chinese translations
│       └── index.ts           # getTranslations() + generateStaticParams()
├── public/
│   ├── screenshots/           # Real device screenshots (user-provided)
│   └── site.webmanifest
├── next.config.ts             # output: 'export' for static HTML
├── package.json
└── CNAME
```

## i18n Implementation

The website uses Next.js App Router `[locale]` dynamic segments for multi-language support:

- **Routes**: `/en` (English) and `/zh` (Chinese)
- **Root `/`**: Client-side redirect based on `navigator.language`
- **Static export**: `generateStaticParams()` returns `[{locale:'en'},{locale:'zh'}]`
- **Translation files**: `lib/i18n/en.ts` and `lib/i18n/zh.ts`
- **Language switch**: `<LangSwitch />` component in header, toggles between `/en` and `/zh`
- **SEO**: Each page includes `<link rel="alternate" hreflang>` tags

**Note**: `middleware.ts` is NOT used because `output: 'export'` does not support server-side middleware. Language detection happens client-side in the root `page.tsx`.

## Deployment Pipeline

### How it works

```
git push to main → Cloudflare Pages auto-builds → Live at hachimi.ai
```

Cloudflare Pages is connected to the GitHub repo `sinnohzeng/hachimi-app-website`. On every push to `main`, Cloudflare Pages runs `npm run build` and deploys the `out/` directory.

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
| Build command | `npm run build` |
| Build output directory | `out` |
| Root directory | `/` |
| Node.js version | 18+ |

## How to Update the Website

### 1. Install dependencies

```bash
cd ~/projects/hachimi-app-website
npm install
```

### 2. Develop locally

```bash
npm run dev
# Visit http://localhost:3000/en or http://localhost:3000/zh
```

### 3. Update translations

Edit `lib/i18n/en.ts` and `lib/i18n/zh.ts` to change website copy. All text is centralized in these files.

### 4. Build and verify

```bash
npm run build          # Static export to out/
npx serve out          # Preview the static build locally
```

### 5. Deploy

```bash
git add -A
git commit -m "feat: update website content"
git push
```

Cloudflare Pages picks up the push automatically. The site updates within ~30 seconds.

### 6. Manual deploy (alternative)

If you need to deploy without pushing to Git (e.g., testing):

```bash
CLOUDFLARE_API_TOKEN="<your-token>" \
CLOUDFLARE_ACCOUNT_ID="<your-account-id>" \
wrangler pages deploy out --project-name hachimi-ai
```

## Feature Flags

Toggle sections on/off in `lib/config.ts`:

```typescript
export const features = {
  smoothScroll: true,
  darkMode: true,
  statsSection: true,
  blogSection: false,          // No blog content
  testimonialsSection: false,  // No user testimonials
} as const;
```

## Screenshots

The website uses placeholder visuals for feature cards and the phone mockup. To add real screenshots:

1. Take device screenshots (1080x2400 or similar, PNG)
2. Place in `public/screenshots/`
3. Update component `src` attributes to reference the screenshot paths
4. Rebuild and deploy

**Needed screenshots:**

| # | Content | Component |
|---|---------|-----------|
| 1 | Cat room (multiple cats + ambience) | feature-highlight.tsx |
| 2 | Focus timer (countdown + ring) | feature-cards.tsx card 2 |
| 3 | Cat adoption (3 candidates) | feature-cards.tsx card 1 |
| 4 | AI chat (chat bubbles) | feature-highlight.tsx alt |
| 5 | Stats page (trend + heatmap) | feature-cards.tsx card 3 |

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

### Build fails on Cloudflare
- Ensure Node.js version is 18+ in Pages settings
- Check that `npm run build` succeeds locally first
- Verify no missing dependencies in `package.json`

### SSL certificate issues
- Cloudflare auto-provisions Let's Encrypt certificates
- Initial provisioning may take up to 15 minutes
- Check status: Cloudflare Dashboard > Pages > hachimi-ai > Custom domains

### `.wrangler/` directory appearing
- This is a local cache created by the `wrangler` CLI tool
- Already in `.gitignore` for both repos — safe to ignore
- Can be deleted: `rm -rf .wrangler/`

### i18n routes not working
- Ensure `generateStaticParams()` in `app/[locale]/layout.tsx` returns both locales
- Verify `next.config.ts` has `output: 'export'`
- Check that `out/en/index.html` and `out/zh/index.html` exist after build
