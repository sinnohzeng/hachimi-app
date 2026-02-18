# Hachimi App — Release Process

> **SSOT**: This document is the single source of truth for how to create and publish GitHub Releases for the Hachimi app.

## Overview

| Concern | Value |
|---------|-------|
| Release platform | GitHub Releases (`sinnohzeng/hachimi-app`) |
| APK type | Debug APK (for direct distribution / sideloading) |
| Versioning | `pubspec.yaml` version field (`major.minor.patch+buildNumber`) |
| Release URL | https://github.com/sinnohzeng/hachimi-app/releases |

> **Note**: The download button on https://hachimi.ai links directly to this releases page.

## Version Naming Convention

Follow [Semantic Versioning](https://semver.org/):

| Component | Meaning |
|-----------|---------|
| `major` | Breaking change or major milestone (e.g. 1→2) |
| `minor` | New feature or significant improvement (e.g. 1.0→1.1) |
| `patch` | Bug fix or minor tweak (e.g. 1.0.0→1.0.1) |
| `+buildNumber` | Flutter internal build number — increment by 1 each release |

**Examples:**
- `1.0.0+1` → First public release (`v1.0.0`)
- `1.1.0+2` → Added new feature
- `1.1.1+3` → Bug fix

## How to Publish a Release

### Step 1 — Bump version in `pubspec.yaml`

```yaml
# pubspec.yaml
version: 1.1.0+2   # bump both the semver and the build number
```

Commit the version bump before building:

```bash
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"
```

### Step 2 — Build the APK

```bash
flutter build apk --debug
```

The output APK is at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### Step 3 — Create the GitHub Release

Use the `gh` CLI to create the release and attach the APK in one command:

```bash
gh release create v1.0.0 \
  build/app/outputs/flutter-apk/app-debug.apk \
  --title "Hachimi v1.0.0" \
  --notes "$(cat <<'EOF'
## What's New

- Initial public release
- Cat parenting gamification system
- Focus timer with XP rewards
- Firebase sync + offline support
- Google Sign-In

## Installation

1. Download `app-debug.apk`
2. On Android: **Settings → Security → Install unknown apps** → enable for your browser/file manager
3. Tap the downloaded APK to install

> This is a debug build for direct sideloading. Production release via Google Play is planned.
EOF
)"
```

### Step 4 — Verify

1. Open https://github.com/sinnohzeng/hachimi-app/releases
2. Confirm the release tag, title, and APK asset appear correctly
3. Download and install the APK to verify it's valid

### Step 5 — Push any remaining commits

```bash
git push
```

## Checklist

- [ ] Version bumped in `pubspec.yaml`
- [ ] Version bump committed
- [ ] `flutter build apk --debug` completed successfully
- [ ] `gh release create` ran with APK attached
- [ ] Release visible at https://github.com/sinnohzeng/hachimi-app/releases
- [ ] APK installs and runs correctly on test device

## Relationship to the Website

The download button on https://hachimi.ai links to:
```
https://github.com/sinnohzeng/hachimi-app/releases
```

GitHub automatically shows the latest release at the top. No change to the website is needed when publishing new releases.
