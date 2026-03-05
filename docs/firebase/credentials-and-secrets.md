# Cloud Credentials & GitHub Secrets Guide

## Purpose
This document is the SSOT for:
- GCP/Firebase cloud credential setup
- Secret Manager storage strategy
- GitHub Actions secret configuration
- Rotation, revocation, and troubleshooting

Scope matches current repo implementation as of 2026-03-05.

---

## 1. Credential Model (Three Planes)

1. Operator plane (human)
- Used for bootstrap/deploy commands on your workstation.
- Tools: `gcloud`, `firebase`, `bq`, `gh`.

2. Runtime plane (Cloud Functions)
- Used by deployed functions at runtime.
- Inputs currently come from `process.env` in [functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts).

3. CI/CD plane (GitHub Actions)
- Used by `.github/workflows/release.yml` to build/sign/release.
- Uses GitHub Secrets only (plus built-in `GITHUB_TOKEN`).

---

## 2. Local Operator Credential Baseline

Run once per machine:

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
gcloud config get-value project
gcloud auth application-default print-access-token >/dev/null && echo "ADC OK"
firebase projects:list | head
gh auth status
```

---

## 3. GCP/Firebase Runtime Credentials

## 3.1 Runtime env vars required by current Functions code

Defined in [functions/src/index.ts](/data/workspace/hachimi-app/functions/src/index.ts):

| Variable | Required | Purpose |
|---|---|---|
| `OBS_DATASET` | Yes | BigQuery dataset for observability tables/views (default `obs`) |
| `BQ_LOCATION` | Yes | BigQuery query location (for scheduled triage query) |
| `AI_DEBUG_TRIAGE_LIMIT` | No | Number of tasks per run (default `25`) |
| `AI_DEBUG_MODEL_NAME` | No | Model label written to reports |
| `AI_DEBUG_MODEL_ENDPOINT` | Optional | AI inference endpoint (if unset, heuristic fallback is used) |
| `AI_DEBUG_MODEL_API_KEY` | Optional | API key for model endpoint |
| `AI_DEBUG_GITHUB_REPO` | Optional | `owner/repo` target for draft issue creation |
| `GITHUB_TOKEN` | Optional | Token used by triage job to create draft issues |

Note: If `AI_DEBUG_MODEL_ENDPOINT` / `AI_DEBUG_MODEL_API_KEY` are missing, triage still runs with heuristic output.

## 3.2 Secret Manager as source of truth

Create secrets (example names):

```bash
PROJECT_ID=<PROJECT_ID>

printf '%s' '<AI_ENDPOINT>' | gcloud secrets create ai-debug-model-endpoint --data-file=- --project "$PROJECT_ID"
printf '%s' '<AI_API_KEY>'  | gcloud secrets create ai-debug-model-api-key  --data-file=- --project "$PROJECT_ID"
printf '%s' '<OWNER/REPO>'  | gcloud secrets create ai-debug-github-repo    --data-file=- --project "$PROJECT_ID"
printf '%s' '<GH_TOKEN>'    | gcloud secrets create ai-debug-github-token   --data-file=- --project "$PROJECT_ID"
```

For updates (rotation), add a new version:

```bash
printf '%s' '<NEW_VALUE>' | gcloud secrets versions add ai-debug-model-api-key --data-file=- --project "$PROJECT_ID"
```

Grant runtime access (replace with your actual runtime service account):

```bash
FUNCTIONS_SA=<functions-runtime-service-account-email>

gcloud secrets add-iam-policy-binding ai-debug-model-endpoint \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-model-api-key \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-github-repo \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"

gcloud secrets add-iam-policy-binding ai-debug-github-token \
  --member="serviceAccount:${FUNCTIONS_SA}" \
  --role="roles/secretmanager.secretAccessor" \
  --project "$PROJECT_ID"
```

## 3.3 Deploy-safe injection to Functions env

Current repo reads `process.env`, so the practical deploy path is:
1. Read canonical values from Secret Manager.
2. Materialize `functions/.env.<PROJECT_ID>` just before deploy.
3. Deploy.
4. Remove local env file.

Example:

```bash
PROJECT_ID=<PROJECT_ID>

get_secret() {
  gcloud secrets versions access latest --secret "$1" --project "$PROJECT_ID" | tr -d '\n'
}

cat > "functions/.env.${PROJECT_ID}" <<EOF
OBS_DATASET=obs
BQ_LOCATION=US
AI_DEBUG_TRIAGE_LIMIT=25
AI_DEBUG_MODEL_NAME=gemini-prod
AI_DEBUG_MODEL_ENDPOINT=$(get_secret ai-debug-model-endpoint)
AI_DEBUG_MODEL_API_KEY=$(get_secret ai-debug-model-api-key)
AI_DEBUG_GITHUB_REPO=$(get_secret ai-debug-github-repo)
GITHUB_TOKEN=$(get_secret ai-debug-github-token)
EOF

firebase deploy --only functions --project "$PROJECT_ID"
rm -f "functions/.env.${PROJECT_ID}"
```

## 3.4 Observability bootstrap credentials

For [scripts/gcp/setup_observability.sh](/data/workspace/hachimi-app/scripts/gcp/setup_observability.sh), ensure operator identity has permissions to:
- create/update BigQuery dataset, tables, views
- create scheduled query transfer config
- create/update billing budgets (if `BILLING_ACCOUNT_ID` is provided)

Recommended run command:

```bash
PROJECT_ID=<project-id> \
LOCATION=US \
DATASET=obs \
ANALYTICS_DATASET=analytics_<property_id> \
TTL_DAYS=90 \
BILLING_ACCOUNT_ID=<billing-account-id> \
BUDGET_AMOUNT=50 \
./scripts/gcp/setup_observability.sh
```

---

## 4. GitHub Actions Secrets (Required by current release workflow)

Workflow: [.github/workflows/release.yml](/data/workspace/hachimi-app/.github/workflows/release.yml)

| Secret | Required | Used by |
|---|---|---|
| `GOOGLE_SERVICES_JSON` | Yes | decode to `android/app/google-services.json` |
| `FIREBASE_OPTIONS_DART` | Yes | decode to `lib/firebase_options.dart` |
| `KEYSTORE_BASE64` | Yes | decode Android signing keystore |
| `KEYSTORE_PASSWORD` | Yes | Android signing |
| `KEY_ALIAS` | Yes | Android signing |
| `KEY_PASSWORD` | Yes | Android signing |
| `MINIMAX_API_KEY` | Yes | `--dart-define` for release build |
| `GEMINI_API_KEY` | Yes | `--dart-define` for release build |
| `WIF_PROVIDER` | Yes | OIDC auth to Google Cloud |
| `WIF_SERVICE_ACCOUNT` | Yes | SA used by WIF |

Notes:
- `GITHUB_TOKEN` for release creation is built-in by GitHub Actions and does not need manual creation.
- WIF setup details are documented in [docs/release/google-play-setup.md](/data/workspace/hachimi-app/docs/release/google-play-setup.md).

## 4.1 Prepare Base64 values safely

Linux:

```bash
base64 -w 0 android/app/google-services.json > /tmp/google-services.b64
base64 -w 0 lib/firebase_options.dart > /tmp/firebase-options.b64
base64 -w 0 android/app/hachimi-release.jks > /tmp/keystore.b64
```

macOS:

```bash
base64 < android/app/google-services.json | tr -d '\n' > /tmp/google-services.b64
base64 < lib/firebase_options.dart | tr -d '\n' > /tmp/firebase-options.b64
base64 < android/app/hachimi-release.jks | tr -d '\n' > /tmp/keystore.b64
```

## 4.2 Set secrets via GitHub CLI

```bash
gh secret set GOOGLE_SERVICES_JSON < /tmp/google-services.b64
gh secret set FIREBASE_OPTIONS_DART < /tmp/firebase-options.b64
gh secret set KEYSTORE_BASE64 < /tmp/keystore.b64

printf '%s' '<KEYSTORE_PASSWORD>' | gh secret set KEYSTORE_PASSWORD
printf '%s' '<KEY_ALIAS>'         | gh secret set KEY_ALIAS
printf '%s' '<KEY_PASSWORD>'      | gh secret set KEY_PASSWORD
printf '%s' '<MINIMAX_API_KEY>'   | gh secret set MINIMAX_API_KEY
printf '%s' '<GEMINI_API_KEY>'    | gh secret set GEMINI_API_KEY
printf '%s' '<WIF_PROVIDER>'      | gh secret set WIF_PROVIDER
printf '%s' '<WIF_SERVICE_ACCOUNT>' | gh secret set WIF_SERVICE_ACCOUNT
```

If you use environment-scoped secrets (recommended for release):

```bash
gh secret set MINIMAX_API_KEY --env production
```

---

## 5. Recommended IAM Split (Least Privilege)

Use separate identities:
1. `ops-observability` (human or SA): bootstrap SQL/dataset/alerts/budgets.
2. `functions-runtime`: only runtime access to BigQuery write + Secret Manager accessor.
3. `github-release` (WIF mapped SA): only release/upload responsibilities.

Do not reuse one admin identity across all three planes.

---

## 6. Rotation and Revocation

## 6.1 Rotation cadence
- AI endpoint/API key: every 90 days.
- GitHub token for AI triage issue creation: every 30-60 days.
- Android signing secrets: by policy or incident response.

## 6.2 Rotation procedure (runtime secrets)
1. Add new Secret Manager version.
2. Re-deploy functions to refresh runtime env.
3. Verify `runAiDebugTriageV1` success log.
4. Disable old secret version.

## 6.3 Incident revoke procedure
1. Disable leaked secret version immediately.
2. Remove corresponding GitHub Secret immediately.
3. Recreate and redeploy.
4. Audit logs for abuse window.

---

## 7. Verification Checklist

1. `firebase deploy --only functions` succeeds.
2. `runAiDebugTriageV1` executes without auth/env errors.
3. Draft issue creation works (when GitHub token/repo configured).
4. Release workflow can run from a tag (`vX.Y.Z`) without missing-secret failures.
5. No secrets are committed (`.env*`, `google-services.json`, `firebase_options.dart`, keystore all remain ignored).

---

## 8. Common Failures

| Symptom | Likely Cause | Fix |
|---|---|---|
| `Missing secret ...` in GitHub Actions | Secret name mismatch | Check exact secret keys in release workflow |
| Functions triage writes heuristic only | Missing AI endpoint or API key | Set `AI_DEBUG_MODEL_ENDPOINT` + `AI_DEBUG_MODEL_API_KEY` |
| No GitHub draft issue created | Missing `GITHUB_TOKEN` or invalid `AI_DEBUG_GITHUB_REPO` | Set both values and verify `owner/repo` format |
| BigQuery query location error | `BQ_LOCATION` mismatch | Set `BQ_LOCATION` to dataset location |
| Observability setup fails on analytics view | Missing `ANALYTICS_DATASET` binding | Pass `ANALYTICS_DATASET=analytics_<property_id>` |
