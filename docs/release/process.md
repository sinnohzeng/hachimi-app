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

### Step 2.5 — Format the entire codebase before tagging

```bash
dart format lib/ test/
```

> **Critical**: Run `dart format` on ALL files, not just the ones you edited. CI enforces `--set-exit-if-changed` and will fail on any unformatted file. Adding a named parameter to an existing single-line call can push it over 80 chars, causing the formatter to reflow files you didn't explicitly touch.

### Step 3 — CI takes over automatically

GitHub Actions (`.github/workflows/release.yml`) will:

1. Check out the code at the tagged commit
2. Set up JDK 17 + Flutter 3.41.1
3. Restore Firebase config files and signing keystore from GitHub Secrets
4. Verify version consistency (tag must match pubspec version)
5. Check formatting (`dart format --set-exit-if-changed lib/ test/`)
6. Run `dart analyze lib/`
7. Run tests (`flutter test --exclude-tags golden`)
8. Build a release-signed APK (`flutter build apk --release`)
9. Rename the APK to `hachimi-vX.Y.Z.apk`
10. Create a GitHub Release with the APK attached

### Step 3.5 — Monitor CI build

Immediately after pushing the tag, monitor the GitHub Actions run:

```bash
# Find the run ID
gh run list --limit 3

# Watch until completion (blocks until done)
gh run watch <RUN_ID> --exit-status
```

If CI fails:
1. Read the failed step logs: `gh run view <RUN_ID> --log-failed`
2. Fix the issue locally (most common: `dart format` failures)
3. Push a fix commit to main
4. Move the tag: `git tag -d vX.Y.Z && git tag -a vX.Y.Z -m "..."` then `git push origin vX.Y.Z --force`
5. Watch the new CI run until it passes

### Step 4 — Create GitHub Release with user-facing notes

Use `gh release create` with a user-facing release body. The release page is what users see from the website — it must NOT be just a CHANGELOG link.

**Required structure:**

```markdown
## What's New in vX.Y.Z

### [Feature Title]
[2-3 sentences in plain language. Focus on what changed for the user.]

### [Another Change]
[Same approach — benefit-oriented, no jargon.]

---

**Full changelog:** [CHANGELOG.md](https://github.com/sinnohzeng/hachimi-app/blob/main/CHANGELOG.md)
```

**Writing principles:**
- User-first language — explain what the user will experience, not implementation details
- Group related changes — combine small fixes into logical sections
- Plain language — avoid jargon like "ConsumerWidget", "surfaceContainerHigh"
- Always include both the user-facing sections AND a CHANGELOG link at the bottom

### Step 5 — Verify

1. Open https://github.com/sinnohzeng/hachimi-app/releases
2. Confirm the release tag, title, description, and APK asset appear correctly
3. Download and install the APK to verify it works

## Checklist

- [ ] `CHANGELOG.md` updated with new entry
- [ ] Version bumped in `pubspec.yaml` (semver + build number)
- [ ] `dart format lib/ test/` applied to entire codebase
- [ ] `dart analyze lib/` passes with no errors
- [ ] All changes committed
- [ ] Git tag created (e.g. `v1.1.0`)
- [ ] Tag pushed to remote (`git push origin main --tags`)
- [ ] GitHub Actions workflow monitored and completed successfully
- [ ] GitHub Release created with user-facing description and APK attached
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
