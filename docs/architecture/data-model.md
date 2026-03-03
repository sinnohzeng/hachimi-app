# Data Model

> SSOT for account lifecycle related data after 2026-03 refactor.

## Firestore Structure
```
users/{uid}
├── habits/{habitId}
│   └── sessions/{sessionId}
├── cats/{catId}
├── achievements/{achievementId}
└── monthlyCheckIns/{yyyy-MM}
```

## User Document (`users/{uid}`)
Required core fields:
- `email` (string)
- `displayName` (string)
- `coins` (int)
- `inventory` (array<string>)
- `createdAt` (timestamp)

Optional profile fields:
- `avatarId`
- `currentTitle`
- `lastCheckInDate`

`ensureProfile(...)` is idempotent and must never overwrite existing user documents.

## Local SQLite (Runtime SSOT)
- `action_ledger`: immutable local write-ahead log
- `materialized_state`: key/value aggregates (coins, profile cache)
- `local_habits`
- `local_cats`
- `local_sessions`
- `local_monthly_checkins`
- `local_achievements`

## SharedPreferences Keys
### Identity
- `cached_uid`
- `local_guest_uid`

### Sync
- `local_data_hydrated_v1`

### Deletion queue
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Cloud Functions
### `deleteAccountV1`
- Requires authenticated user.
- Recursively deletes all `users/{uid}` data.
- Deletes Firebase Auth user.
- Idempotent for missing doc/user.

### `wipeUserDataV1`
- Requires authenticated user.
- Recursively deletes all `users/{uid}` data.
- Keeps Firebase Auth user.
- Used by guest upgrade `keepLocal` path.

## Merge Semantics
- Keep cloud: local old guest data is removed; cloud hydrates local.
- Keep local: cloud data is wiped first; local migrates to new uid and pushes to cloud.

## Deletion Semantics
- Local-first deletion is irreversible.
- Cloud/Auth deletion is immediate when online or queued when offline.
- Pending deletion is retried automatically on app startup and periodic retry loop.
