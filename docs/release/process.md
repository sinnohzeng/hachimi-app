# Hachimi App — Release Process

> **SSOT**: This document is the single source of truth for how to create and publish GitHub Releases for the Hachimi app.

## Overview

| Concern | Value |
|---------|-------|
| Release platform | GitHub Releases (`sinnohzeng/hachimi-app`) |
| APK type | Release-signed APK (AOT compiled, minified) |
| Build method | Automated via GitHub Actions (tag-triggered) |
| Signing | Production keystore (`hachimi-release.jks`) |
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

Commit the version bump:

```bash
git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+2"
```

### Step 2 — Create a git tag and push

```bash
git tag v1.1.0
git push && git push --tags
```

> **Important**: The tag version must match the semver in `pubspec.yaml` (without `+buildNumber`).

### Step 3 — CI takes over automatically

GitHub Actions (`.github/workflows/release.yml`) will:

1. Check out the code at the tagged commit
2. Set up JDK 17 + Flutter 3.41.1
3. Restore Firebase config files and signing keystore from GitHub Secrets
4. Run `dart analyze lib/`
5. Build a release-signed APK (`flutter build apk --release`)
6. Rename the APK to `hachimi-vX.Y.Z.apk`
7. Create a GitHub Release with auto-generated release notes and the APK attached

### Step 4 — Verify

1. Open https://github.com/sinnohzeng/hachimi-app/releases
2. Confirm the release tag, title, and APK asset appear correctly
3. Download and install the APK to verify it works

## Checklist

- [ ] Version bumped in `pubspec.yaml`
- [ ] Version bump committed
- [ ] Git tag created (e.g. `v1.1.0`)
- [ ] Tag pushed to remote (`git push --tags`)
- [ ] GitHub Actions workflow completed successfully
- [ ] Release visible at https://github.com/sinnohzeng/hachimi-app/releases
- [ ] APK installs and runs correctly on test device

## Release Signing

### Keystore

The production keystore (`hachimi-release.jks`) is stored outside the repository and must never be committed. It is configured via `android/key.properties` (gitignored).

### Local build (optional)

For local release builds:

```bash
flutter build apk --release
```

This requires `android/key.properties` to be present. See `scripts/setup-release-signing.sh` for initial setup.

### GitHub Secrets

The CI workflow requires these secrets configured in the repository:

| Secret | Purpose |
|--------|---------|
| `KEYSTORE_BASE64` | Base64-encoded production keystore |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Signing key alias |
| `KEY_PASSWORD` | Key password |
| `GOOGLE_SERVICES_JSON` | Base64-encoded `google-services.json` |
| `FIREBASE_OPTIONS_DART` | Base64-encoded `firebase_options.dart` |

Run `scripts/setup-release-signing.sh` to generate these values.

## Relationship to the Website

The download button on https://hachimi.ai links to:
```
https://github.com/sinnohzeng/hachimi-app/releases
```

GitHub automatically shows the latest release at the top. No change to the website is needed when publishing new releases.
