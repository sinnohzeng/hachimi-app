# Firebase Setup Guide

## 1. Required Services
Enable in Firebase Console:
- Authentication: Google + Email/Password (+ Anonymous if guest anonymous mode is used)
- Firestore
- Cloud Functions (Blaze plan required)
- Analytics
- Crashlytics
- Cloud Logging export for Crashlytics
- BigQuery export for Crashlytics + Analytics

## 2. Local Project Bootstrap
```bash
flutter pub get
firebase login
flutterfire configure --project <project-id>
```

## 3. Firestore Rules
Deploy rules and indexes:
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## 4. Cloud Functions Account Lifecycle
### Functions included
- `deleteAccountV1`
- `wipeUserDataV1`

### Deploy
```bash
cd functions
npm ci
npm test
cd ..
firebase deploy --only functions
```

### Cloud Functions account lifecycle
- `deleteAccountV1`: recursively delete `users/{uid}` and delete Auth user.
- `wipeUserDataV1`: recursively delete `users/{uid}` only.
- Both callables require authenticated context and are idempotent.
- Both callables require operation context payload fields:
  - `correlation_id`
  - `uid_hash`
  - `operation_stage`
  - `retry_count`

## 5. Client Runtime Expectations
- Client deletion flow is local-first and may queue pending cloud deletion when offline.
- App startup retries pending deletion jobs automatically.
- Guest local UID (`guest_*`) does not call Firestore deletion APIs.

## 6. Observability Bootstrap
```bash
export PROJECT_ID=<your-project-id>
export LOCATION=US
export DATASET=obs
export ANALYTICS_DATASET=analytics_<property_id> # optional if auto-discovery fails
export TTL_DAYS=90
./scripts/gcp/setup_observability.sh
```

Then configure Cloud Monitoring notification channels:
- Google Chat (primary)
- Email (fallback)

See [Observability Runbook](observability-runbook.md) for full operational steps.
Credential and GitHub secret setup details are in [Credentials & Secrets](credentials-and-secrets.md).
