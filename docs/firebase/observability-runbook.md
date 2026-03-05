# Firebase/GCP Observability Runbook

## Purpose
Operational checklist for Hachimi observability closed loop:
- Crashlytics + Cloud Logging + BigQuery
- AI triage (`runAiDebugTriageV2`)
- Alerting via Google Chat + Email

## Preconditions
1. Firebase project is on Blaze.
2. App Check enabled for Android (Play Integrity in release).
3. Firebase AI Logic enabled (Vertex provider).
4. Google Chat spaces created and Monitoring app installed.
5. Email fallback channel defined.

## 1) Provision via Terraform
```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

Required tfvars values:
- `project_id`
- `analytics_dataset`
- `chat_notification_channel_ids`
- `alert_email`
- `billing_account_id`

## 2) Deploy Functions
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

## 3) Runtime Param/Secret Validation
Validate these runtime parameters exist:
- `OBS_DATASET`
- `BQ_LOCATION`
- `AI_DEBUG_TRIAGE_LIMIT`
- `TRIAGE_MODEL`
- `TRIAGE_VERTEX_LOCATION`
- `AI_DEBUG_GITHUB_REPO`
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`

Validate secret parameter exists:
- `GITHUB_APP_PRIVATE_KEY`

## 4) Export and Data Plane Checks
1. Crashlytics -> BigQuery enabled
2. Crashlytics -> Cloud Logging enabled
3. Analytics -> BigQuery enabled
4. Logging sink writes to `obs` dataset

## 5) Alert Policy Checks
Required policy names:
- `crash_free_users`
- `fatal_rate`
- `delete_account_error_rate`
- `high_velocity_issues`
- `ai_pipeline_failure`

Each policy must include both:
- Google Chat channel
- Email fallback channel

Budget guardrail is implemented by Billing Budget resource (`hachimi-observability-budget`) with Email notification.

## 6) Verification Drill
1. Trigger synthetic non-fatal from app.
2. Confirm Crashlytics visibility within 5 minutes.
3. Confirm BigQuery visibility within 60 minutes.
4. Trigger test alert in Cloud Monitoring.
5. Confirm notifications in Google Chat and Email.
6. Confirm `runAiDebugTriageV2` writes to `obs.ai_debug_reports_v1`.
7. Confirm draft issue creation with GitHub App auth.

## 7) Incident Triage Procedure
1. Start from alert.
2. Query by `correlation_id` across Crashlytics + Functions logs.
3. Confirm `uid_hash` / `operation_stage` / `error_code` consistency.
4. Read AI triage report and draft issue.
5. Assign owner and gate release on fix verification.

## 8) Cost Guardrails
1. Keep BigQuery TTL enabled.
2. Keep budget thresholds at 50/80/100%.
3. Keep scheduled query interval at 15 minutes.
4. Review high-cost queries weekly.
