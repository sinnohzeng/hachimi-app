# Data Model

> SSOT for account lifecycle related data after 2026-03 refactor.

## Firestore Structure
```
users/{uid}
├── habits/{habitId}
│   └── sessions/{sessionId}
├── cats/{catId}
├── achievements/{achievementId}
├── monthlyCheckIns/{yyyy-MM}
├── dailyLights/{date}
├── weeklyReviews/{weekId}
└── worries/{worryId}
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
- `local_daily_lights` (v4)
- `local_weekly_reviews` (v4)
- `local_worries` (v4)
- `local_awareness_stats` (v4)

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
### `deleteAccountV2`
- Requires authenticated user.
- Requires valid App Check token (consumed to prevent replay).
- Recursively deletes all `users/{uid}` data.
- Deletes Firebase Auth user.
- Idempotent for missing doc/user.

### `wipeUserDataV2`
- Requires authenticated user.
- Requires valid App Check token (consumed to prevent replay).
- Recursively deletes all `users/{uid}` data.
- Keeps Firebase Auth user.
- Used by guest upgrade `keepLocal` path.

Compatibility aliases (`deleteAccountV1` / `wipeUserDataV1`) remain available during migration.

## Merge Semantics
- Keep cloud: local old guest data is removed; cloud hydrates local.
- Keep local: cloud data is wiped first; local migrates to new uid and pushes to cloud.

## Deletion Semantics
- Local-first deletion is irreversible.
- Cloud/Auth deletion is immediate when online or queued when offline.
- Pending deletion is retried automatically on app startup and periodic retry loop.

## Domain Enums

Strongly-typed enums introduced in the B1 quality batch to replace raw `String` / `int` constants.

| Enum | File | Values | Used By |
|------|------|--------|---------|
| `CatState` | `core/constants/cat_constants.dart` | `active`, `graduated`, `dormant` | `Cat.state` field |
| `CatStage` | `core/constants/pixel_cat_constants.dart` | `kitten`, `adolescent`, `adult`, `senior` | Pixel cat sprite stage |
| `SessionStatus` | `core/constants/session_constants.dart` | `completed`, `abandoned`, `interrupted` | `FocusSession.status` field |
| `SessionMode` | `models/focus_session.dart` | `countdown`, `stopwatch` | `FocusSession.mode` field |
| `AccessoryCategory` | `providers/accessory_provider.dart` | `plant`, `wild`, `collar` | Accessory filtering |
| `ReminderMode` | `models/reminder_config.dart` | `daily`, `weekdays`, `monday`–`sunday` | `ReminderConfig.mode` field |
| `CelebrationHeadline` | `widgets/celebration/celebration_tier.dart` | `achievementUnlocked`, `achievementAwesome`, `achievementIncredible` | `CelebrationConfig.headline` |

## V3 Awareness Data Layer

### Local SQLite — Awareness Tables (DB v4)

DB version bumped from v3 → v4 with migration adding 4 new tables.

**`local_daily_lights`** — 每日一光记录
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `date` | TEXT | NOT NULL |
| `mood` | INTEGER | NOT NULL |
| `light_text` | TEXT | |
| `tags` | TEXT (JSON) | |
| `timeline_events` | TEXT (JSON) | |
| `habit_completions` | TEXT (JSON) | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, date) |

**`local_weekly_reviews`** — 周回顾
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `week_id` | TEXT | NOT NULL |
| `week_start_date` | TEXT | |
| `week_end_date` | TEXT | |
| `happy_moment_1` | TEXT | |
| `happy_moment_1_tags` | TEXT (JSON) | |
| `happy_moment_2` | TEXT | |
| `happy_moment_2_tags` | TEXT (JSON) | |
| `happy_moment_3` | TEXT | |
| `happy_moment_3_tags` | TEXT (JSON) | |
| `gratitude` | TEXT | |
| `learning` | TEXT | |
| `cat_weekly_summary` | TEXT | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, week_id) |

**`local_worries`** — 烦恼处理器
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `description` | TEXT | NOT NULL |
| `solution` | TEXT | |
| `status` | TEXT | DEFAULT 'ongoing' |
| `resolved_at` | INTEGER | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |

**`local_awareness_stats`** — 觉知聚合统计
| Column | Type | Constraint |
|--------|------|------------|
| `uid` | TEXT | PK |
| `total_light_days` | INTEGER | DEFAULT 0 |
| `total_weekly_reviews` | INTEGER | DEFAULT 0 |
| `total_worries_resolved` | INTEGER | DEFAULT 0 |
| `last_light_date` | TEXT | |
| `updated_at` | INTEGER | |

### Firestore — Awareness Collections

Under `users/{uid}/`:

```
users/{uid}
├── ...existing collections...
├── dailyLights/{date}
├── weeklyReviews/{weekId}
└── worries/{worryId}
```

**`dailyLights/{date}`**
- `mood` (int)
- `lightText` (string)
- `tags` (array<string>)
- `timelineEvents` (array<map>)
- `habitCompletions` (array<map>)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**`weeklyReviews/{weekId}`**
- `weekStartDate` (string)
- `weekEndDate` (string)
- `happyMoment1` / `happyMoment1Tags` (string / array)
- `happyMoment2` / `happyMoment2Tags` (string / array)
- `happyMoment3` / `happyMoment3Tags` (string / array)
- `gratitude` (string)
- `learning` (string)
- `catWeeklySummary` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**`worries/{worryId}`**
- `description` (string)
- `solution` (string)
- `status` (string, default: `"ongoing"`)
- `resolvedAt` (timestamp, nullable)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)
