# Firebase Setup Guide

## 1. Required Services
Enable in Firebase Console:
- Authentication: Google + Email/Password (+ Anonymous if guest anonymous mode is used)
- Firestore
- Cloud Functions (Blaze plan required)
- Analytics
- Crashlytics

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
npm install
npm test
cd ..
firebase deploy --only functions
```

### Cloud Functions account lifecycle
- `deleteAccountV1`: recursively delete `users/{uid}` and delete Auth user.
- `wipeUserDataV1`: recursively delete `users/{uid}` only.
- Both callables require authenticated context and are idempotent.

## 5. Client Runtime Expectations
- Client deletion flow is local-first and may queue pending cloud deletion when offline.
- App startup retries pending deletion jobs automatically.
- Guest local UID (`guest_*`) does not call Firestore deletion APIs.
