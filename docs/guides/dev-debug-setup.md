# Dev / Debug Setup

## Prerequisites
- Flutter 3.41.x
- Dart 3.11.x
- Node.js 20+ (for `functions/`)
- Firebase CLI

## First-time bootstrap
```bash
flutter pub get
cd functions && npm install && cd ..
```

## Local validation commands
```bash
dart analyze lib test
flutter test --exclude-tags golden
dart run tool/quality_gate.dart
cd functions && npm test
```

## Account Lifecycle Debug Checklist
### Guest upgrade
- Test Google login in link mode.
- Test Email login/register in link mode.
- Confirm archive conflict dialog appears when both sides have data.
- Verify keep-cloud and keep-local branches both succeed.

### Account deletion
- Online: local data clears immediately and `deleteAccountV1` executes.
- Offline: local clears immediately; `pending_deletion_job` is written.
- Reconnect: app startup/polling retries cloud hard delete until completion.

## Common Failures
- `permission-denied` during deletion: check callable auth context and rules deployment.
- Pending deletion never clears: verify Functions deployment and user still authenticated.
- Missing conflict dialog: verify both local and cloud snapshots are non-empty.
