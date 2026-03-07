# Firebase Setup Guide

## 1. Required Services
Enable in Firebase/GCP:
- Firebase Authentication
- Firestore
- Cloud Functions (Blaze required)
- Analytics
- Crashlytics
- Firebase App Check
- Firebase AI Logic (Vertex provider)
- Crashlytics export to BigQuery and Cloud Logging
- Analytics export to BigQuery

## 2. Local Bootstrap
```bash
flutter pub get
firebase login
flutterfire configure --project <project-id>
```

## 3. Firestore Rules
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## 4. Cloud Functions Contracts
Current callable contracts:
- `deleteAccountV2`
- `wipeUserDataV2`

Compatibility aliases are still exported:
- `deleteAccountV1`
- `wipeUserDataV1`

### Security behavior (V2)
- Requires authenticated user context
- Requires valid App Check token
- Consumes App Check token for replay protection
- Requires `OperationContext` fields:
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

### Deploy
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

Post-deploy verification:
```bash
./scripts/check-account-lifecycle-functions.sh <project-id>
```

## 5. App Check Configuration
Client runtime behavior is implemented in [lib/main.dart](/data/workspace/hachimi-app/lib/main.dart):
- Android release: Play Integrity
- Debug builds: Debug provider

Console actions required:
1. Register Android app in App Check.
2. Enable Play Integrity provider in production.
3. Keep Debug provider available for local development.

## 6. AI Path (Google-First)
- Client AI provider is Firebase AI Logic (`firebase_ai`) with Vertex backend.
- No client static AI API key is required in release workflow.
- Server triage function uses IAM/ADC for Vertex calls.

## 7. Observability Bootstrap
Primary path is Terraform:

```bash
cd infra/terraform/envs/prod
terraform init
terraform plan
terraform apply
```

Operational details:
- [Observability Runbook](observability-runbook.md)
- [Credentials & Secrets](credentials-and-secrets.md)
