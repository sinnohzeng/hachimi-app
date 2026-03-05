# 2026-03-05 Execution Plan: Cloud Credentials & AI Security Modernization

## Summary
This plan is the single source of truth for migrating Hachimi from client static AI keys and manually rotated long-lived credentials to Google-native short-lived identity and IaC-managed security controls.

Core direction:
- Google-first AI path: Firebase AI Logic + Vertex AI
- App Check enforced on sensitive callables
- GitHub App token flow (no long-lived PAT)
- Terraform as the long-term control plane for observability and security resources
- Alerting channels fixed to Google Chat + Email

## Scope
Included in one-time delivery:
1. Flutter(Android) AI and security runtime migration
2. Firebase Functions V2 security contract and GitHub App auth
3. Terraform IaC for `obs` data plane, alerts, budget, secrets, IAM
4. CI/CD credential hygiene and release secret health checks
5. DDD/SSOT document synchronization (EN + ZH)
6. Long-term memory synchronization

Excluded:
1. iOS/Web code migration
2. Automatic PR merge/release by AI

## Final Architecture Contract
1. AI provider: `firebase_gemini` only (Firebase AI Logic)
2. Sensitive callables:
- `deleteAccountV2`
- `wipeUserDataV2`
3. App Check:
- Android release: Play Integrity
- Debug build: Debug provider
- Sensitive callable calls use limited-use tokens
4. Functions configuration:
- Parameterized config + Secret parameters
- no runtime dependency on client-side static AI keys
5. GitHub auth:
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`
- `GITHUB_APP_PRIVATE_KEY` (Secret Manager)
6. Alerting:
- Google Chat + Email only

## IaC Deliverables
Directory:
- `infra/terraform/modules/observability`
- `infra/terraform/envs/prod`

Managed resources:
1. BigQuery dataset and observability objects:
- `issue_daily_v1`
- `issue_velocity_v1`
- `issue_user_impact_v1`
- `flow_error_funnel_v1`
- `release_stability_v1`
- `ai_debug_tasks_v1`
- `ai_debug_reports_v1`
2. Scheduled query refresh (`every 15 minutes`)
3. Cloud Logging sink to BigQuery
4. Monitoring policies and notification bindings
5. Billing budget and threshold rules
6. Secret Manager and IAM split

Outputs:
- `obs_dataset_id`
- `notification_channel_ids`
- `alert_policy_ids`
- `budget_id`

## Manual Cooperation (Minimal Set)
Required once by project owner:
1. Google Chat:
- Create spaces:
  - `hachimi-alerts-prod-p1`
  - `hachimi-alerts-prod-ops`
- Install Google Cloud Monitoring app in each space
- Provide Monitoring notification channel IDs
2. GitHub:
- Create GitHub App with minimum permissions:
  - `Issues: Read & Write`
  - `Metadata: Read-only`
- Install app to `sinnohzeng/hachimi-app`
- Provide:
  - `APP_ID`
  - `INSTALLATION_ID`
  - `PRIVATE_KEY_PEM`
3. Firebase/GCP:
- Enable App Check (Play Integrity) for Android app
- Complete Firebase AI Logic initial setup (Vertex provider)
- Approve IAM grants for Terraform/deploy identities

## Locked Execution Inputs (2026-03-05)
1. Project and billing:
- `PROJECT_ID=hachimi-ai` (single prod environment)
- `BILLING_ACCOUNT_ID=billingAccounts/01E301-C31477-88FDAB`
2. GitHub App:
- `APP_ID=3015633`
- `INSTALLATION_ID=114226962`
- Private key file: `/data/workspace/hachimi-app/hachimi-ai-debug-bot.2026-03-05.private-key.pem`
3. Google Chat channels:
- prod ops: `projects/hachimi-ai/notificationChannels/7202234633594020254`
- prod p1: `projects/hachimi-ai/notificationChannels/7564813615993522229`

## Remaining Manual Actions
1. Enable Android App Check (Play Integrity) in Firebase Console.
2. Complete Firebase AI Logic initial setup (Vertex provider) in Firebase Console.
3. Confirm Crashlytics and Analytics BigQuery exports are enabled and have produced datasets/tables.
4. Update `infra/terraform/envs/prod/terraform.tfvars`:
   - `analytics_dataset = "analytics_<real_property_id>"`
   - `enable_export_dependent_resources = true`
5. Run `cd infra/terraform/envs/prod && terraform apply` to provision export-dependent objects.

## Automated by Repository Changes
1. Client AI provider migration
2. App Check runtime activation and limited-use token path
3. Functions V2 callable and triage hardening
4. GitHub App token exchange integration
5. Release workflow secret hygiene and checks
6. Terraform resource definitions and output contracts
7. EN/ZH docs and long-memory updates

## Acceptance Criteria
1. `deleteAccountV2/wipeUserDataV2` reject requests without valid App Check
2. AI features run without client-side static AI keys
3. `runAiDebugTriageV2` writes reports and can create draft GitHub issues through GitHub App auth
4. Alert drill reaches Google Chat + Email channels
5. No plaintext UID/email/phone in logs and observability reports
6. Quality gates pass:
- `dart analyze lib test`
- `flutter test --exclude-tags golden`
- `dart run tool/quality_gate.dart`
- `cd functions && npm test`
- `terraform fmt -check`
