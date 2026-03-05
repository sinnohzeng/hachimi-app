# Terraform Observability IaC

This directory is the long-term IaC entry point for Hachimi observability and cloud credential hardening.

## Structure

- `modules/observability`: reusable module for BigQuery, Scheduled Query, Monitoring alerts/channels, budget, secrets, and IAM.
- `envs/prod`: prod environment root module.

## Prerequisites

1. `terraform` >= 1.6
2. `gcloud auth application-default login`
3. Enabled APIs in target project:
- BigQuery API
- BigQuery Data Transfer API
- Cloud Logging API
- Cloud Monitoring API
- Cloud Billing Budget API
- Secret Manager API
- IAM API
4. Firebase exports must be ready before full apply:
- Crashlytics -> BigQuery export enabled and dataset exists (for example `firebase_crashlytics`)
- Analytics -> BigQuery export enabled and `events_*` tables exist (for example `analytics_xxx.events_YYYYMMDD`)
## Apply (Prod)

```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

## Manual inputs that must be filled before apply

- `chat_notification_channel_ids`: created from Google Chat spaces in Cloud Monitoring.
- `alert_email`: fallback email channel address.
- `analytics_dataset`: Firebase Analytics export dataset id.
- `enable_export_dependent_resources`: set `true` only after Crashlytics/Analytics BigQuery exports are enabled and producing tables.
- `project_id`: target GCP/Firebase project id.
- `billing_account_id`: billing account in `billingAccounts/XXXXXX-XXXXXX-XXXXXX` format.
- `enable_budget_metric_alert`: optional; default `false`.

## Export precheck (recommended)

```bash
PROJECT_ID=<your-project-id>

bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `<your-project-id>.firebase_crashlytics.INFORMATION_SCHEMA.TABLES`
LIMIT 1;
SQL

bq query --nouse_legacy_sql --project_id="$PROJECT_ID" <<'SQL'
SELECT table_name
FROM `<your-project-id>.analytics_xxx.INFORMATION_SCHEMA.TABLES`
WHERE table_name LIKE 'events_%'
LIMIT 1;
SQL
```

## Outputs contract

The root module outputs align with the implementation plan:

- `obs_dataset_id`
- `notification_channel_ids`
- `alert_policy_ids`
- `budget_id`

## Security notes

- `github_app_private_key` should be passed only during bootstrap and then removed from `terraform.tfvars`.
- Runtime access is granted via IAM to the configured Functions service account.
- Long-lived PAT is not used; GitHub App private key is stored in Secret Manager.
- Budget notifications should use Email fallback channel; Google Chat remains primary for Monitoring alert policies.
