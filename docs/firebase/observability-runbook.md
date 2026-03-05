# Firebase/GCP Observability Runbook

## Purpose
Operational checklist for enabling and validating Hachimi observability stack.

## Prerequisites
- Firebase project on Blaze plan.
- Google Cloud project billing enabled.
- Firebase services enabled: Crashlytics, Analytics, Cloud Functions.
- Google Chat space prepared and Cloud Monitoring notification channel created.
- Email notification channel created as fallback.

## 1) Provision BigQuery Assets
```bash
export PROJECT_ID=<your-project-id>
export LOCATION=US
export DATASET=obs
export ANALYTICS_DATASET=analytics_<property_id> # optional if auto-discovery fails
export TTL_DAYS=90
export BILLING_ACCOUNT_ID=<billing-account-id>
export BUDGET_AMOUNT=50

./scripts/gcp/setup_observability.sh
```

## 2) Deploy Functions
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

## 3) Configure AI Triage Runtime Secrets
Set environment variables for functions runtime:
- `AI_DEBUG_MODEL_ENDPOINT`
- `AI_DEBUG_MODEL_API_KEY`
- `AI_DEBUG_MODEL_NAME`
- `AI_DEBUG_GITHUB_REPO` (`owner/repo`)
- `GITHUB_TOKEN`
- `OBS_DATASET`
- `BQ_LOCATION`

## 4) Enable Exports
- Crashlytics -> BigQuery
- Crashlytics -> Cloud Logging
- Analytics -> BigQuery
- Cloud Logging sink (optional) -> BigQuery

## 5) Alert Policies
Create/verify policies:
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`
- `budget_threshold`

Attach both channels:
- Google Chat (primary)
- Email (fallback)

## 6) Verification Drills
1. Trigger synthetic non-fatal from app.
2. Confirm Crashlytics visibility within 5 minutes.
3. Confirm BigQuery visibility within 60 minutes.
4. Trigger test alert from Cloud Monitoring.
5. Confirm both Google Chat and Email receive the alert.
6. Confirm `runAiDebugTriageV1` writes into `obs.ai_debug_reports_v1`.

## 7) Incident Triage Procedure
1. Query by `correlation_id` across Crashlytics and Functions logs.
2. Confirm `uid_hash`, `error_code`, `operation_stage`, `retry_count` consistency.
3. Check generated GitHub draft issue for actionable fix suggestion.
4. Assign owner and track fix via release gate.

## 8) Cost Guardrails
- Keep dataset TTL enabled.
- Keep budget alerts at 50% / 80% / 100%.
- Keep scheduled query cadence at 15 minutes.
- Review heavy queries weekly.
