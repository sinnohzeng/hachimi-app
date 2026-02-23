# Google Play Store — CI/CD Setup Guide

> **SSOT**: This document is the single source of truth for setting up automated Google Play publishing via GitHub Actions with Workload Identity Federation.

## Overview

This guide walks through the **complete, end-to-end** process of connecting GitHub Actions to Google Play for automated AAB uploads. The setup uses **Workload Identity Federation (WIF)** instead of long-lived service account keys — this is Google's recommended approach and complies with organization policies that block key creation.

### What AI (Claude) already did

| Item | Status |
|------|--------|
| `.github/workflows/release.yml` — AAB build + Play Store upload steps | Done |
| `distribution/whatsnew/en-US` — Play Store "What's New" text | Done |
| `android/app/proguard-rules.pro` — removed legacy llama_cpp_dart rules | Done |
| `docs/release/process.md` — updated with Play Store workflow | Done |
| `hachimi.ai/privacy` — privacy policy page (required by Play Store) | Done |
| `CLAUDE.md` — added AAB build command | Done |

### What you must do manually

| Step | Where | Time Estimate |
|------|-------|---------------|
| 1. Enable Google Play Android Developer API | Google Cloud Console | 2 min |
| 2. Create Workload Identity Pool + Provider | Google Cloud Console (gcloud CLI) | 5 min |
| 3. Create service account + grant WIF binding | Google Cloud Console (gcloud CLI) | 3 min |
| 4. Grant service account access in Play Console | Google Play Console | 2 min |
| 5. Add 2 GitHub Secrets | GitHub repo Settings | 2 min |
| 6. Create app listing in Play Console | Google Play Console | 15 min |
| 7. Upload first AAB manually | Google Play Console | 5 min |
| 8. Promote to production | Google Play Console | 2 min |

---

## Prerequisites

- Google Play Console developer account (organization)
- Google Cloud project linked to your Play Console
- `gcloud` CLI installed locally ([install guide](https://cloud.google.com/sdk/docs/install))
- GitHub repository admin access

### Find your Google Cloud project

Your Play Console is linked to a Google Cloud project. To find the project ID:

1. Open [Google Play Console](https://play.google.com/console)
2. Go to **Settings** → **API access**
3. The linked Google Cloud project is shown at the top

If no project is linked, click **Link existing project** and select (or create) one.

> Throughout this guide, replace `YOUR_PROJECT_ID` with your actual project ID (e.g. `hachimi-ai`) and `YOUR_PROJECT_NUMBER` with the numeric project number (found in Cloud Console → Dashboard).

---

## Step 1: Enable Google Play Android Developer API

**Where**: Google Cloud Console

```bash
gcloud services enable androidpublisher.googleapis.com \
  --project=YOUR_PROJECT_ID
```

Or via the web UI:
1. Open [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Go to **APIs & Services** → **Library**
4. Search for **Google Play Android Developer API**
5. Click **Enable**

---

## Step 2: Create Workload Identity Pool and Provider

**Where**: Google Cloud Console (gcloud CLI)

This creates the trust bridge between GitHub Actions and Google Cloud.

### 2a. Create the Workload Identity Pool

```bash
gcloud iam workload-identity-pools create "github-actions" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions Pool"
```

### 2b. Create the OIDC Provider (bound to your GitHub repo)

```bash
gcloud iam workload-identity-pools providers create-oidc "github-repo" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions" \
  --display-name="GitHub Repo Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='sinnohzeng/hachimi-app'" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

**Key security points**:
- `attribute-condition` restricts access to **only** the `sinnohzeng/hachimi-app` repository
- No other GitHub repos (even in the same org) can use this provider
- You can further restrict to specific branches by adding `&& assertion.ref=='refs/heads/main'` to the condition

### 2c. Get the Provider full resource name

```bash
gcloud iam workload-identity-pools providers describe "github-repo" \
  --project="YOUR_PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-actions" \
  --format="value(name)"
```

**Save this output** — it looks like:
```
projects/123456789/locations/global/workloadIdentityPools/github-actions/providers/github-repo
```

You will need this value for the `WIF_PROVIDER` GitHub Secret in Step 5.

---

## Step 3: Create Service Account and Grant WIF Binding

**Where**: Google Cloud Console (gcloud CLI)

### 3a. Create the service account (no key needed)

```bash
gcloud iam service-accounts create play-store-publisher \
  --project="YOUR_PROJECT_ID" \
  --display-name="Play Store Publisher"
```

### 3b. Allow GitHub Actions to impersonate this service account via WIF

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --project="YOUR_PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-actions/attribute.repository/sinnohzeng/hachimi-app"
```

> **Important**: Use your **numeric project number** (not project ID) in the `--member` flag. Find it at Cloud Console → Dashboard → Project number.

---

## Step 4: Grant Service Account Access in Play Console

**Where**: Google Play Console

> **Note**: Google has removed the old "Setup → API access" page from Play Console. Service accounts are now invited as regular users through "Users and permissions".

1. Open [Google Play Console](https://play.google.com/console)
2. Go to **Users and permissions** (left sidebar)
3. Click **Invite new users**
4. In the email address field, enter your service account email:
   ```
   play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com
   ```
5. Under **Account permissions**, grant:
   - **Release apps to testing tracks** — allows uploading AABs to internal/closed/open tracks
   - **Release to production, exclude devices, and use Play App Signing** — allows managing production releases
6. Under **App permissions**, click **Add app** → select **Hachimi** → grant:
   - **Release apps to testing tracks**
   - **Release to production, exclude devices, and use Play App Signing**
7. Click **Invite user** → **Send invitation**

The service account does not need to accept an email invitation. However, **permission propagation can take up to 24-48 hours**. If CI uploads fail with "403 Forbidden" shortly after setup, wait and retry.

> **Troubleshooting**: If invitation fails, verify that: (1) the Google Play Android Developer API is enabled in Cloud Console (Step 1), and (2) the service account email is correctly formatted as `name@project-id.iam.gserviceaccount.com`.

---

## Step 5: Add GitHub Secrets

**Where**: GitHub → Repository Settings → Secrets and variables → Actions

Add these 2 secrets:

| Secret name | Value | Where to find it |
|-------------|-------|------------------|
| `WIF_PROVIDER` | Full resource name of the provider | Output of Step 2c |
| `WIF_SERVICE_ACCOUNT` | `play-store-publisher@YOUR_PROJECT_ID.iam.gserviceaccount.com` | The email from Step 3a |

### How to add a GitHub Secret

1. Go to https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions
2. Click **New repository secret**
3. Enter the secret name and value
4. Click **Add secret**

> These are **not** sensitive credentials — they are just identifiers. An attacker cannot use them without a valid GitHub Actions OIDC token from your repository.

---

## Step 6: Create App Listing in Play Console

**Where**: Google Play Console

### 6a. Create the app

1. Open [Google Play Console](https://play.google.com/console)
2. Click **Create app**
3. Fill in:
   - App name: `Hachimi`
   - Default language: English (United States)
   - App or game: **App**
   - Free or paid: **Free**
4. Accept declarations and click **Create app**

### 6b. Complete the required declarations

Navigate to each section in the left sidebar under **Grow** → **Store presence** and **Policy** → **App content**:

| Section | What to fill |
|---------|-------------|
| **Store listing** | Title, short description, full description, screenshots (≥6), feature graphic (1024×500), app icon (512×512) |
| **Content rating** | Complete the IARC questionnaire — no violence/gambling/sexual content → rating will be PEGI 3 / Everyone |
| **Target audience** | Not designed for children |
| **News app** | No |
| **COVID-19 contact tracing / status app** | No |
| **Data safety** | Fill based on the privacy policy (see table below) |
| **Ads** | Does not contain ads |
| **App access** | All functionality available without special access (or provide test credentials if login required) |
| **App category** | Productivity |
| **Privacy policy URL** | `https://hachimi.ai/en/privacy` |

### 6c. Data safety form

Fill the data safety form based on the data types described in the privacy policy:

| Data type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Email address | Yes | No | Account management |
| Name (display name) | Yes | No | App functionality |
| App interactions (habits, focus sessions) | Yes | No | App functionality |
| Crash logs | Yes | Yes (Google) | Analytics |
| Performance diagnostics | Yes | Yes (Google) | App performance |
| Device or other IDs (FCM token) | Yes | Yes (Google) | Push notifications |
| Other (AI chat content) | Optional | Yes (MiniMax or Google Gemini) | App functionality (AI features) |

Mark: Data is encrypted in transit, users can request data deletion.

### 6d. Special permissions (if prompted)

| Permission | Justification |
|------------|---------------|
| `FOREGROUND_SERVICE_SPECIAL_USE` | Focus timer requires a persistent foreground notification to keep the countdown/stopwatch running when the app is backgrounded |
| `SCHEDULE_EXACT_ALARM` | Habit reminder notifications need to fire at user-configured exact times |

---

## Step 7: Upload First AAB Manually

**Where**: Google Play Console + local terminal

Google Play's API requires the **first AAB to be uploaded via the web console**. After that, CI handles all subsequent uploads.

### 7a. Build the AAB locally

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

The AAB will be at: `build/app/outputs/bundle/release/app-release.aab`

### 7b. Upload to internal testing track

1. Play Console → **Testing** → **Internal testing**
2. Click **Create new release**
3. **Google Play App Signing** is automatically enabled (mandatory for all AAB uploads)
   - Your existing keystore (`hachimi-release.jks`) automatically becomes the **upload key**
   - Google generates and manages the actual distribution signing key
   - No changes to your keystore or signing config are needed
4. Upload `app-release.aab`
5. Add release notes
6. Click **Review release** → **Start rollout to Internal testing**

### 7c. Verify the upload

- The AAB should appear in the internal testing track
- Check for any warnings or errors in the Play Console

---

## Step 8: Promote to Production

**Where**: Google Play Console

Since you have an **organization account**, you are exempt from the 12-tester × 14-day closed testing requirement. You can promote directly to production.

1. Play Console → **Production** → **Create new release**
2. Click **Add from library** → select the AAB from internal testing
3. Add release notes
4. Click **Review release** → **Start rollout to Production**

### Review timeline

- **First submission**: 3-7 business days
- **Subsequent updates**: typically 1-3 days
- You will receive an email when the review is complete

---

## Verification

After the full setup is complete, verify the pipeline works end-to-end:

### Test 1: WIF authentication

Push a tag and check the "Authenticate to Google Cloud" step in GitHub Actions. If it fails:
- Verify `WIF_PROVIDER` value matches the output of Step 2c exactly
- Verify `WIF_SERVICE_ACCOUNT` email is correct
- Check that the IAM binding in Step 3b uses the correct project **number** (not ID)

### Test 2: Play Store upload

The "Upload to Google Play" step should succeed after authentication. If it fails:
- Verify the service account has **Release manager** permission in Play Console
- Verify the first AAB was manually uploaded (Step 7)
- Check that `distribution/whatsnew/en-US` exists and is ≤500 characters

### Test 3: Full pipeline

```bash
# After a code change, run the full release flow
git tag -a v2.15.1 -m "v2.15.1: test Google Play pipeline"
git push origin main --tags

# Monitor
gh run list --limit 3
gh run watch <RUN_ID> --exit-status
```

Expected results:
- GitHub Release created with APK attached
- AAB uploaded to Google Play internal track
- Build sizes reported in the Actions summary

---

## Ongoing Maintenance

### Each release

1. Update `distribution/whatsnew/en-US` with new release notes (≤500 chars)
2. Bump version in `pubspec.yaml`
3. Push tag → CI handles the rest
4. After CI succeeds, promote from internal to production in Play Console

### No key rotation needed

WIF uses short-lived tokens that are generated fresh for each CI run. There are no long-lived credentials to rotate.

### If you need to change the service account

1. Create a new service account in Cloud Console
2. Grant it WIF binding (Step 3b) and Play Console access (Step 4)
3. Update the `WIF_SERVICE_ACCOUNT` GitHub Secret
4. Revoke the old service account

---

## Architecture Diagram

```
Developer pushes tag (v2.15.0)
              │
              ▼
    GitHub Actions triggered
              │
              ├── Format check + analysis + tests
              │
              ├── Build AAB ──────────────────────────┐
              │                                        │
              ├── Build APK                            │
              │                                        ▼
              │                          ┌──────────────────────────┐
              │                          │  google-github-actions/  │
              │                          │       auth@v3            │
              │                          │                          │
              │                          │  1. Request OIDC token   │
              │                          │     from GitHub          │
              │                          │  2. Exchange for Google  │
              │                          │     Cloud temp creds     │
              │                          └────────────┬─────────────┘
              │                                       │
              │                                       ▼
              │                          ┌──────────────────────────┐
              │                          │  r0adkll/upload-google-  │
              │                          │       play@v1            │
              │                          │                          │
              │                          │  Upload AAB to internal  │
              │                          │  track using temp creds  │
              │                          └──────────────────────────┘
              │
              ├── Create GitHub Release (with APK)
              │
              ▼
    Developer promotes to production
    in Play Console (manual)
```

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Auth step: "Unable to generate credentials" | WIF provider not found | Verify `WIF_PROVIDER` value matches Step 2c output exactly |
| Auth step: "Permission denied on resource" | IAM binding incorrect | Re-run Step 3b with correct project **number** |
| Upload step: "APK/AAB not found in the specified release files" | Build failed silently | Check the AAB build step output |
| Upload step: "403 Forbidden" | Service account lacks Play Console access | Re-do Step 4 |
| Upload step: "Package not found" | First AAB not manually uploaded | Complete Step 7 first |
| Upload step: "Version code already exists" | Forgot to bump `pubspec.yaml` build number | Increment the `+buildNumber` suffix |

---

## Reference Links

- [Google Cloud Workload Identity Federation — GitHub Actions](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines)
- [google-github-actions/auth — README](https://github.com/google-github-actions/auth)
- [r0adkll/upload-google-play — README](https://github.com/r0adkll/upload-google-play)
- [Google Play Developer API — Getting Started](https://developers.google.com/android-publisher/getting_started)
- [Play Console — App signing](https://support.google.com/googleplay/android-developer/answer/9842756)
