# Cloud Credentials & Secrets (Google-First, Low-Maintenance)

## Purpose
This document is the SSOT for Hachimi cloud credential setup after security modernization (2026-03-05).

Goals:
1. No long-lived static AI API keys in client code.
2. Prefer short-lived identity (OIDC/WIF/ADC) over copied key files.
3. Keep manual steps minimal and one-time.
4. Use Secret Manager + Terraform as long-term control plane.

---

## 1. Credential Model (Three Planes)

1. Operator plane (human)
- You authenticate locally with `gcloud`/`firebase`/`gh`.
- Used for bootstrap and Terraform apply.

2. Runtime plane (Cloud Functions)
- Uses Google-managed service account identity (ADC/IAM).
- Vertex AI calls use IAM token flow, not API key.
- GitHub App private key is read from Secret Manager.

3. CI/CD plane (GitHub Actions)
- Uses Workload Identity Federation (`WIF_PROVIDER`, `WIF_SERVICE_ACCOUNT`).
- No service-account JSON key file in GitHub Secrets.

---

## 2. One-Time Manual Actions (Required)

These cannot be fully automated and must be completed by the project owner:

1. Google Chat
- Create spaces:
  - `hachimi-alerts-prod-p1`
  - `hachimi-alerts-prod-ops`
- Install Google Cloud Monitoring app in each space.
- Create notification channels and record channel resource IDs.

2. GitHub App
- Create GitHub App with minimum permissions:
  - `Issues: Read & Write`
  - `Metadata: Read-only`
- Install app to `sinnohzeng/hachimi-app`.
- Collect:
  - `APP_ID`
  - `INSTALLATION_ID`
  - `PRIVATE_KEY_PEM`

3. Firebase/GCP console bootstrap
- Enable Firebase App Check (Android Play Integrity; debug uses Debug provider).
- Complete Firebase AI Logic initial setup with Vertex provider.
- Approve IAM grants for Terraform/deploy identities.

### 2.1 Current captured values (2026-03-05)
- Confirmed target project: `hachimi-ai` (single prod environment)
- Confirmed billing account: `billingAccounts/01E301-C31477-88FDAB` (`billingEnabled=true`)
- `APP_ID = 3015633`
- Installation URL: `https://github.com/settings/installations/114226962`
- The trailing numeric segment is your `INSTALLATION_ID`: `114226962`.
- Downloaded private key path:
  `/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem`
- Confirmed Google Chat Monitoring channels:
  - `hachimi-alerts-prod-ops`:
    `projects/hachimi-ai/notificationChannels/7202234633594020254`
  - `hachimi-alerts-prod-p1`:
    `projects/hachimi-ai/notificationChannels/7564813615993522229`

Security note: do not keep the PEM file in repository directories after uploading it to Secret Manager.

---

## 3. Local Operator Baseline

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project <PROJECT_ID>
firebase login
gh auth login
```

Verify:

```bash
gcloud auth list
gcloud auth application-default print-access-token >/dev/null && echo "ADC OK"
gcloud config get-value project
firebase projects:list | head
gh auth status
```

---

## 4. Runtime Credentials (Functions)

Source of truth: [functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts)

### 4.1 Parameterized config
- `OBS_DATASET`
- `BQ_LOCATION`
- `AI_DEBUG_TRIAGE_LIMIT`
- `TRIAGE_MODEL`
- `TRIAGE_VERTEX_LOCATION`
- `AI_DEBUG_GITHUB_REPO`
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`

### 4.2 Secret parameters
- `GITHUB_APP_PRIVATE_KEY` (Secret Manager)

### 4.3 Sensitive callable security contract
- `deleteAccountV2` and `wipeUserDataV2`:
  - `enforceAppCheck: true`
  - `consumeAppCheckToken: true`
- Client calls use `limitedUseAppCheckToken: true`.

---

## 5. GitHub Secrets (Release Workflow)

Workflow file: [.github/workflows/release.yml](/data/workspace/hachimi-app/.github/workflows/release.yml)

Required:
- `GOOGLE_SERVICES_JSON`
- `FIREBASE_OPTIONS_DART`
- `KEYSTORE_BASE64`
- `KEYSTORE_PASSWORD`
- `KEY_ALIAS`
- `KEY_PASSWORD`
- `WIF_PROVIDER`
- `WIF_SERVICE_ACCOUNT`

Not required anymore:
- Legacy client AI key secrets (deprecated)

A mandatory health check runs before release build:
- [tool/check_release_secrets.sh](/data/workspace/hachimi-app/tool/check_release_secrets.sh)

---

## 6. GitHub App Secrets and Wiring

### 6.1 Put GitHub App values into Secret Manager (recommended)

```bash
PROJECT_ID=<PROJECT_ID>

printf '%s' '<PRIVATE_KEY_PEM>' | gcloud secrets create GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" --data-file=-
```

If secret already exists, rotate by adding a new version:

```bash
printf '%s' '<NEW_PRIVATE_KEY_PEM>' | gcloud secrets versions add GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" --data-file=-
```

### 6.2 Set non-secret parameters for Functions

Use Firebase parameter config or deploy-time environment according to your deployment process:
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`
- `AI_DEBUG_GITHUB_REPO`

### 6.3 Runtime IAM grant

Grant runtime service account read access to the secret:

```bash
gcloud secrets add-iam-policy-binding GITHUB_APP_PRIVATE_KEY \
  --project "$PROJECT_ID" \
  --member "serviceAccount:<FUNCTIONS_RUNTIME_SA>" \
  --role roles/secretmanager.secretAccessor
```

---

## 7. Terraform as Long-Term Control Plane

Directory:
- [infra/terraform/README.md](/data/workspace/hachimi-app/infra/terraform/README.md)

Managed by Terraform:
1. `obs` BigQuery dataset and views/tables
2. Scheduled query (`every 15 minutes`)
3. Logging sink to BigQuery
4. Monitoring channels/policies (Google Chat IDs + Email)
5. Billing budget policy
6. Secret Manager + IAM split

Apply sequence:

```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

The current `prod` config is intentionally set to:
- `PROJECT_ID=hachimi-ai`
- `enable_export_dependent_resources=false` (bootstrap infra first without export-dependent views/jobs)
- `enable_budget_metric_alert=false` (budget notifications are handled by Billing Budget + Email)

Before the first `terraform apply`, run export prechecks. Views that depend on Firebase exports will fail if datasets/tables are not ready:

```bash
PROJECT_ID=hachimi-ai

# Crashlytics export
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.firebase_crashlytics.INFORMATION_SCHEMA.TABLES`
LIMIT 1;
SQL

# Analytics export (replace analytics_xxx with your real dataset id)
bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_xxx.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 1;
SQL
```

If you get `Dataset ... was not found` or `... does not match any table`, enable the corresponding Firebase BigQuery export first, then re-run Terraform.

After exports are ready, finalize with:

```bash
# 1) Update infra/terraform/envs/prod/terraform.tfvars:
#    - analytics_dataset = "analytics_<real_property_id>"
#    - enable_export_dependent_resources = true

cd infra/terraform/envs/prod
terraform plan
terraform apply
```

---

## 8. Recommended GitHub Repo Secrets Setup (CLI)

```bash
gh secret set GOOGLE_SERVICES_JSON < /tmp/google-services.b64
gh secret set FIREBASE_OPTIONS_DART < /tmp/firebase-options.b64
gh secret set KEYSTORE_BASE64 < /tmp/keystore.b64

printf '%s' '<KEYSTORE_PASSWORD>' | gh secret set KEYSTORE_PASSWORD
printf '%s' '<KEY_ALIAS>'         | gh secret set KEY_ALIAS
printf '%s' '<KEY_PASSWORD>'      | gh secret set KEY_PASSWORD
printf '%s' '<WIF_PROVIDER>'      | gh secret set WIF_PROVIDER
printf '%s' '<WIF_SERVICE_ACCOUNT>' | gh secret set WIF_SERVICE_ACCOUNT
```

---

## 9. Rotation and Revocation Policy

1. Client-side AI keys
- Removed from release path; no rotation required.

2. GitHub App private key
- Rotate only when compromise risk/policy requires.
- Rotation is version-based in Secret Manager.

3. WIF configuration
- No secret value rotation; maintain trust policy and least privilege.

4. Emergency response
- Disable compromised secret version immediately.
- Redeploy Functions.
- Audit Cloud Logging for suspicious access window.

---

## 10. Verification Checklist

1. Functions deploy and run with no missing param/secret errors.
2. `deleteAccountV2` / `wipeUserDataV2` reject requests without valid App Check.
3. AI triage writes to `obs.ai_debug_reports_v1`.
4. GitHub draft issue is created with GitHub App auth mode.
5. Release workflow passes secret health check and build.
6. No plaintext UID/email/phone in logs and reports.

---

## 11. Common Failures

| Symptom | Cause | Fix |
|---|---|---|
| `permission-denied` on V2 callable | App Check missing/invalid/replayed token | Ensure App Check enabled and client uses limited-use token |
| Triage cannot create issue | GitHub App params/secret invalid | Verify `GITHUB_APP_ID`, `GITHUB_APP_INSTALLATION_ID`, `GITHUB_APP_PRIVATE_KEY` |
| Vertex call fallback only | Runtime SA missing Vertex IAM | Grant `roles/aiplatform.user` |
| Terraform alert apply fails for Chat | Channel IDs not created in Monitoring | Create channels from Google Chat spaces and update tfvars |
| Release build fails at secrets check | Missing required GitHub secrets | Set required secrets listed in section 5 |

---

## 12. Step-by-Step Guide (Beginner Friendly)

### 12.1 How to find `INSTALLATION_ID`
1. Open GitHub App -> `Install App`.
2. Open the installation detail page.
3. URL will be like:
   `https://github.com/settings/installations/114226962`
4. The trailing number is `INSTALLATION_ID`.

### 12.2 Where to find Monitoring `notification channel id`
Important: Chat `space id` (`AAQA...`) is not the Monitoring channel id.
Terraform needs:
`projects/<PROJECT_ID>/notificationChannels/<NUMERIC_ID>`

Console path:
1. Google Cloud Console -> `Monitoring`.
2. `Alerting` -> `Edit notification channels`.
3. Open each Google Chat channel.
4. Copy `Resource name` / `Channel ID`.

CLI path (if `gcloud` installed):
```bash
PROJECT_ID=<your-project-id>
gcloud beta monitoring channels list \
  --project "$PROJECT_ID" \
  --format="table(name,displayName,type,enabled)"
```

Validated prod channel IDs ready for Terraform:

```text
projects/hachimi-ai/notificationChannels/7564813615993522229  # hachimi-alerts-prod-p1
projects/hachimi-ai/notificationChannels/7202234633594020254 # hachimi-alerts-prod-ops
```

### 12.3 Safe handling of GitHub App private key
```bash
PROJECT_ID=<your-project-id>
KEY_FILE=/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem

gcloud secrets create GITHUB_APP_PRIVATE_KEY \
  --replication-policy=automatic \
  --project "$PROJECT_ID" || true

gcloud secrets versions add GITHUB_APP_PRIVATE_KEY \
  --data-file="$KEY_FILE" \
  --project "$PROJECT_ID"
```

After successful upload, delete local PEM from repository directory.

### 12.4 Remaining manual actions (current)
1. Finish Firebase Console setup:
   - App Check (Android Play Integrity)
   - Firebase AI Logic initial setup (Vertex provider)
2. Enable and verify BigQuery exports:
   - Crashlytics export produces `firebase_crashlytics.*`
   - Analytics export produces `analytics_xxx.events_*`
3. Update Terraform prod vars:
   - `analytics_dataset = "analytics_<real_property_id>"`
   - `enable_export_dependent_resources = true`
4. Run `cd infra/terraform/envs/prod && terraform apply`.

---

## 13. Detailed Walkthrough for the 3 Remaining Manual Actions (Single `prod`: `hachimi-ai`)

This section is intentionally explicit for first-time operators.

### 13.1 Action 1: Firebase App Check (Android + Play Integrity)

Goal: protect sensitive callable endpoints (`deleteAccountV2`, `wipeUserDataV2`) so only valid app-origin traffic is accepted.

Where:
1. Firebase Console: `https://console.firebase.google.com/`
2. Select project `hachimi-ai`
3. Left nav: `Build` -> `App Check`
4. Open your Android app card

Configure:
1. Click `Register`/`Manage`.
2. Select provider: `Play Integrity` for production.
3. Keep Debug provider for local/dev debugging.
4. Enable protection at least for Cloud Functions.

Which SHA-256 fingerprint should be used:
1. Production distributed via Google Play (recommended):
- Use the SHA-256 of `Play App Signing` (App signing key certificate).
- Do not confuse it with your upload key.
2. Local/sideloaded release testing:
- Use SHA-256 from your release keystore.
3. Local debug:
- Use Debug provider instead of Play Integrity.
- Debug keystore SHA-256 can still be registered for other Firebase integrations, but it is not your production App Check trust anchor.
4. Multiple SHA-256 fingerprints can be registered for the same Android app.

Where to get SHA-256:
1. Play App Signing certificate:
- Play Console -> `Test and release` -> `App integrity` -> `App signing key certificate` -> copy `SHA-256`.
2. Release keystore:
```bash
keytool -list -v -keystore <release-keystore.jks> -alias <key-alias> | rg "SHA256|SHA-256"
```
3. Debug keystore:
```bash
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android -keypass android | rg "SHA256|SHA-256"
```
4. Alternative (all variants):
```bash
cd android
./gradlew signingReport
```

Where to set SHA-256 in Firebase:
1. Firebase Console -> gear icon `Project settings`.
2. `General` -> `Your apps` -> open Android app (`com.hachimi.hachimi_app`).
3. In `SHA certificate fingerprints`, click `Add fingerprint`.
4. Paste SHA-256 and save.

CLI alternative:
```bash
firebase apps:list --project hachimi-ai

firebase apps:android:sha:create \
  1:360008924406:android:24f480bcb469cd565240d7 \
  <SHA256_FINGERPRINT>

firebase apps:android:sha:list 1:360008924406:android:24f480bcb469cd565240d7
```

If you need to remove a wrong one:
```bash
firebase apps:android:sha:delete <APP_ID> <SHA_ID>
```

After setting SHA-256:
1. Return to `Build` -> `App Check` -> Android app -> `Manage`.
2. Confirm provider is still `Play Integrity` and Cloud Functions protection is enabled.
3. Run one signed test build, then check App Check metrics and callable behavior.

Verify:
1. App Check metrics show valid token traffic.
2. Valid app request succeeds.
3. Request without valid App Check token returns `permission-denied`.

Common pitfalls:
1. Enforcing too early for all users before traffic observation.
2. Using Play Integrity in local debug flow.
3. Registering App Check but forgetting to enforce on target resources.

---

### 13.2 Action 2: Firebase AI Logic Initial Setup (Vertex Provider)

Goal: complete Google-native AI path without client static AI keys.

Where:
1. Firebase Console project overview:
   `https://console.firebase.google.com/project/hachimi-ai/overview`
2. Open `AI` / `AI Logic`.
3. Click `Get started`.

Configure:
1. Choose `Google / Vertex AI` provider.
2. Confirm billing/API enablement prompts.

Verify:
1. AI Logic status is enabled in console.
2. App-side AI features work without `MINIMAX_API_KEY` / `GEMINI_API_KEY`.
3. Backend triage (`runAiDebugTriageV2`) uses Vertex primary path.

---

### 13.3 Action 3: Enable and Verify BigQuery Exports (Crashlytics + Analytics)

Goal: unblock export-dependent Terraform resources (`enable_export_dependent_resources=true`).

Crashlytics export:
1. Firebase Console -> `Crashlytics`.
2. Open BigQuery export/integration.
3. Link and enable export to `hachimi-ai`.

Analytics export:
1. Firebase Console -> `Project settings` -> `Integrations`.
2. Enable BigQuery export for Analytics.
3. Wait for dataset `analytics_<property_id>` and `events_*` tables.

How to find `analytics_dataset`:
1. Open BigQuery:
   `https://console.cloud.google.com/bigquery?project=hachimi-ai`
2. Expand project `hachimi-ai`.
3. Find dataset with prefix `analytics_`.
4. Use that exact dataset id in:
   `infra/terraform/envs/prod/terraform.tfvars`

Example:
```hcl
analytics_dataset = "analytics_123456789"
enable_export_dependent_resources = true
```

CLI verification:
```bash
PROJECT_ID=hachimi-ai

bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.firebase_crashlytics.INFORMATION_SCHEMA.TABLES`
LIMIT 5;
SQL

bq ls --project_id="$PROJECT_ID" | rg "analytics_"

bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_123456789.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 5;
SQL
```

Finalize:
1. Update [infra/terraform/envs/prod/terraform.tfvars](/data/workspace/hachimi-app/infra/terraform/envs/prod/terraform.tfvars):
   - `analytics_dataset = "analytics_<real_property_id>"`
   - `enable_export_dependent_resources = true`
2. Run:
```bash
cd /data/workspace/hachimi-app/infra/terraform/envs/prod
terraform plan
terraform apply
```

---

### 13.4 What to send back to continue

Reply with:
1. `App Check: done`
2. `AI Logic(Vertex): done`
3. `analytics_dataset: analytics_<real_id>`

Then I will immediately run the finalization pass (second apply + alert drill + end-to-end verification).

---

## 14. What You Still Need To Do Now (Based on actual status as of 2026-03-06)

This section only lists remaining tasks.

### 14.1 Already done

1. App Check + Play Integrity is configured.
2. Android SHA-256 fingerprint is registered.
3. `firebase_crashlytics` dataset exists.
4. Google Chat + Email alert channels are active.

No need to repeat these.

### 14.2 Minimum remaining manual actions

Only 2 manual tasks remain:
1. Enable Analytics -> BigQuery export and obtain real `analytics_<property_id>` dataset.
2. Update Terraform vars with that dataset id and set `enable_export_dependent_resources = true`.

I will handle Terraform second apply, Functions deploy, and final verification after that.

---

### 14.3 Manual Task A: Enable Analytics -> BigQuery export

Where:
1. Firebase Console: `https://console.firebase.google.com/`
2. Select project `hachimi-ai`
3. Gear icon -> `Project settings`
4. Open `Integrations`
5. In `BigQuery`, click `Manage` / `Link` / `View details` (label may vary)

Enable:
1. Ensure target project is `hachimi-ai`.
2. Enable Analytics export (`Export Google Analytics data to BigQuery`).
3. Save and confirm prompts.

Verify:
1. Open BigQuery:
   `https://console.cloud.google.com/bigquery?project=hachimi-ai`
2. Expand project `hachimi-ai`.
3. Confirm a dataset named `analytics_<property_id>` appears.
4. Confirm `events_YYYYMMDD` or `events_intraday_YYYYMMDD` tables appear later.

CLI check:
```bash
PROJECT_ID=hachimi-ai

bq ls --project_id="$PROJECT_ID" | rg "analytics_"

bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `hachimi-ai.analytics_123456789.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 20;
SQL
```

Notes:
1. Dataset can appear before first `events_*` tables.
2. Initial export may take time; check again later.

---

### 14.4 Manual Task B: Update Terraform vars

Edit [infra/terraform/envs/prod/terraform.tfvars](/data/workspace/hachimi-app/infra/terraform/envs/prod/terraform.tfvars)
and update:

```hcl
analytics_dataset                 = "analytics_<real_property_id>"
enable_export_dependent_resources = true
```

Optional local validation:
```bash
cd /data/workspace/hachimi-app/infra/terraform/envs/prod
terraform plan
```

---

### 14.5 What to send me after you finish

Send:
1. `analytics_dataset = analytics_<real_id>`
2. `tfvars updated: true`

Then I will run:
1. Terraform second apply for export-dependent resources.
2. Functions deployment.
3. Final end-to-end acceptance checks.
