# Data Model — Firestore Schema (SSOT)

> **SSOT**: This document is the single source of truth for all Firestore collections, document schemas, and data integrity rules. Implementation in `lib/models/` and `lib/services/firestore_service.dart` must match this specification exactly.

---

## Collection Hierarchy

```
users/{uid}                          <- User profile document
├── habits/{habitId}                 <- Habit metadata + goal tracking
│   └── sessions/{sessionId}        <- Focus session history
├── cats/{catId}                     <- Cat state (appearance, growth, accessories)
└── monthlyCheckIns/{YYYY-MM}        <- Monthly check-in tracking (resets each month)
```

---

## Collection: `users/{uid}`

The top-level user document. Created on first sign-in.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `displayName` | string | yes | User's display name (from Firebase Auth profile) |
| `email` | string | yes | User's email address |
| `createdAt` | timestamp | yes | Account creation timestamp |
| `fcmToken` | string | no | Firebase Cloud Messaging device token for push notifications |
| `coins` | int | yes | Current coin balance for purchasing accessories (default: 0) |
| `inventory` | list\<string\> | yes | User-level accessory inventory — IDs of owned but unequipped accessories (default: empty list) |
| `lastCheckInDate` | string | no | ISO date string "YYYY-MM-DD" of the most recent daily check-in bonus claim |
| `avatarId` | string | no | Predefined avatar icon ID for the user's profile picture. null = show initials fallback |

**Notes:**
- `uid` is the Firebase Auth UID and serves as both the document ID and the top-level namespace for all user data.
- `fcmToken` is updated on each app launch via `NotificationService.initialize()`. Multiple devices are not currently supported (last write wins).
- `coins` is modified via `FieldValue.increment()` to prevent race conditions. It is never set to a calculated total directly.
- `lastCheckInDate` is compared against today's date to determine if the daily check-in bonus has already been claimed.

---

## Collection: `users/{uid}/habits/{habitId}`

One document per user habit. `habitId` is a Firestore auto-generated ID.

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Habit display name, e.g. "Daily Reading" |
| `catId` | string | yes | — | Reference to the bound cat document ID in `users/{uid}/cats/` |
| `goalMinutes` | int | yes | 25 | Daily focus goal in minutes (used for progress display) |
| `targetHours` | int? | no | null | Cumulative long-term target in hours. `null` = unlimited mode (no target). Used for cat growth calculation when set. |
| `totalMinutes` | int | yes | 0 | Total minutes logged across all time |
| `deadlineDate` | timestamp? | no | null | Optional deadline for milestone mode. Only meaningful when `targetHours` is set. |
| `targetCompleted` | bool | yes | false | Whether the milestone target has been reached. When `true`, quest auto-converts to unlimited mode. |
| `lastCheckInDate` | string | no | null | ISO date string "YYYY-MM-DD" of most recent session |
| `reminders` | list\<map\> | no | [] | Reminder list (up to 5). Each map contains `hour` (int), `minute` (int), `mode` (string: "daily", "weekdays", "weekends", "monday"–"sunday"). Parsed by `ReminderConfig.tryFromMap()`. |
| `motivationText` | string | no | null | Note/memo text, max 240 characters |
| `isActive` | bool | yes | true | `false` when habit is deactivated (cat becomes dormant) |
| `createdAt` | timestamp | yes | — | Habit creation timestamp |

**Quest Modes:**
- **Unlimited mode** (永续模式): `targetHours == null` — no cumulative target, keep accumulating focus time indefinitely.
- **Milestone mode** (里程碑模式): `targetHours` is set, with optional `deadlineDate` — work toward a specific hour goal.
- **Auto-conversion**: When `totalMinutes >= targetHours * 60`, `targetCompleted` is set to `true` and the quest automatically converts to unlimited mode.

**Computed property:** `isUnlimited` returns `true` when `targetHours == null` or `targetCompleted == true`.

**Dart Model:** `lib/models/habit.dart` -> `class Habit`

---

## Collection: `users/{uid}/habits/{habitId}/sessions/{sessionId}`

One document per focus session. `sessionId` is a Firestore auto-generated ID.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `habitId` | string | yes | Reference back to parent habit ID (for cross-collection queries) |
| `catId` | string | yes | Reference to the cat that earned XP in this session |
| `startedAt` | timestamp | yes | When the focus session began |
| `endedAt` | timestamp | yes | When the session ended (completed or abandoned) |
| `durationMinutes` | int | yes | Actual focused minutes (may be less than target if abandoned) |
| `targetDurationMinutes` | int | yes | Planned duration in minutes (countdown target; 0 for stopwatch mode) |
| `pausedSeconds` | int | yes | Cumulative paused time in seconds during this session |
| `status` | string | yes | Session outcome: "completed", "abandoned", or "interrupted" |
| `completionRatio` | double | yes | Actual / target ratio (1.0 for stopwatch mode) |
| `xpEarned` | int | yes | XP awarded at session end (computed by `XpService`) |
| `coinsEarned` | int | yes | Coins awarded at session end (`durationMinutes × 10`; 0 if abandoned < 5 min) |
| `mode` | string | yes | Timer mode: "countdown" or "stopwatch" |
| `checksum` | string | no | HMAC-SHA256 signature for tamper detection |
| `clientVersion` | string | yes | Client app version at session creation time |

**Note:** The `completed` bool field has been removed and replaced by the `status` string field which supports three states: completed, abandoned, interrupted.

**XP for Non-Completed Sessions:**
- If `status == "abandoned"` AND `durationMinutes >= 5`: `xpEarned = durationMinutes x 1` (base XP only)
- If `status == "abandoned"` AND `durationMinutes < 5`: `xpEarned = 0`
- If `status == "interrupted"`: XP is calculated same as abandoned sessions

**Dart Model:** `lib/models/focus_session.dart` -> `class FocusSession`

---

## Collection: `users/{uid}/cats/{catId}`

One document per cat. `catId` is a Firestore auto-generated ID.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Cat's given name, e.g. "Mochi" |
| `appearance` | map | yes | Pixel-cat-maker appearance parameters — see [Cat System](cat-system.md) for full parameter list |
| `personality` | string | yes | Personality ID from `CatPersonality.id` — see [Cat System](cat-system.md) |
| `totalMinutes` | int | yes | Total focus minutes accumulated for this cat's habit. Stage is computed from this using fixed thresholds. |
| `accessories` | list\<string\> | yes | **DEPRECATED** — Legacy per-cat owned accessories. Migrated to `users/{uid}.inventory`. Only used during migration. |
| `equippedAccessory` | string | no | Currently equipped accessory ID (null = none equipped) |
| `boundHabitId` | string | yes | Reference to the habit that spawned this cat |
| `state` | string | yes | "active", "dormant", or "graduated" |
| `lastSessionAt` | timestamp | no | Timestamp of the most recent focus session for this cat's habit |
| `highestStage` | string | no | Highest growth stage ever reached (monotonic; null for legacy cats). Valid values: "kitten", "adolescent", "adult", "senior". |
| `createdAt` | timestamp | yes | Cat adoption timestamp |

**Computed Fields (not stored in Firestore):**
These are derived from stored fields at read time to prevent drift.

| Computed | Derived From | Logic |
|----------|-------------|-------|
| `stage` | `totalMinutes` | Fixed 200h (12000min) ladder: kitten (0h), adolescent (20h/1200min), adult (100h/6000min), senior (200h/12000min) |
| `growthProgress` | `totalMinutes` | `totalMinutes / 12000` capped at 1.0. Progress is relative to the fixed 200h ladder, not to habit `targetHours`. |
| `mood` | `lastSessionAt` | happy (under 24h), neutral (1–3d), lonely (3–7d), missing (over 7d) |

**Why not store `stage` and `mood` directly?**
Storing derived values creates a risk of drift (the stored value diverges from what the formula would compute). By computing at read time from authoritative inputs (`totalMinutes` and `lastSessionAt`), the app always shows the correct state without background jobs. The `highestStage` field is the exception — it is stored because it must be monotonically increasing (only goes up, never down) to protect against stage regression.

**State Transitions:**

```
active --[habit deactivated]--> dormant
active --[habit deleted]------> graduated
dormant --[habit reactivated]-> active  (future feature)
```

**Dart Model:** `lib/models/cat.dart` -> `class Cat`
**Appearance Model:** `lib/models/cat_appearance.dart` -> `class CatAppearance`

---

## Collection: `users/{uid}/monthlyCheckIns/{YYYY-MM}`

One document per calendar month, tracking daily check-in progress and milestone claims. Document ID is the month string, e.g. "2026-02".

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `checkedDays` | list\<int\> | yes | Day-of-month numbers that have been checked in, e.g. `[1, 2, 5, 8]` |
| `totalCoins` | int | yes | Cumulative coins earned from check-ins this month (daily + milestone bonuses) |
| `milestonesClaimed` | list\<int\> | yes | Milestone day thresholds already claimed, e.g. `[7, 14]` |

**Notes:**
- The document is created on the first check-in of a new month.
- `checkedDays` uses `FieldValue.arrayUnion` to append; day numbers are 1-based.
- Milestones (7, 14, 21, full month) are claimed automatically when the `checkedDays` length crosses the threshold.
- The full-month bonus is awarded when `checkedDays.length` equals the total days in that month.

**Dart Model:** `lib/models/monthly_check_in.dart` -> `class MonthlyCheckIn`

---

## Atomic Operations (Batch Writes)

Operations that span multiple documents use Firestore **batch writes** to guarantee all-or-nothing consistency. If any write fails, the entire batch rolls back.

### 1. Habit + Cat Creation (Adoption Flow)
**Method:** `FirestoreService.createHabitWithCat(uid, habit, cat)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}` — new habit document (`targetHours` is optional; `null` for unlimited mode)
2. `SET users/{uid}/cats/{catId}` — new cat document with `appearance` Map, `totalMinutes: 0`, `accessories: []`, and `boundHabitId` pointing to habit
3. `UPDATE users/{uid}/habits/{habitId}.catId` — back-reference from habit to cat

### 2. Focus Session Completion
**Method:** `FirestoreService.logFocusSession(uid, session)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}/sessions/{sessionId}` — session record
2. `UPDATE users/{uid}/habits/{habitId}` — increment `totalMinutes`, update `lastCheckInDate`
3. `UPDATE users/{uid}/cats/{catId}.totalMinutes` — `totalMinutes += session.durationMinutes`
4. `UPDATE users/{uid}/cats/{catId}.lastSessionAt` — set to now
5. `UPDATE users/{uid}.coins` — `FieldValue.increment(session.coinsEarned)` (focus reward: `durationMinutes × 10`)

> **Note:** Daily check-in bonus is no longer awarded in this batch. It is managed independently by `CoinService.checkIn()` via the monthly check-in system.

### 3. Habit Deletion (Graduation)
**Method:** `FirestoreService.deleteHabit(uid, habitId)`

Batch includes:
1. `DELETE users/{uid}/habits/{habitId}` — remove habit document
2. `UPDATE users/{uid}/cats/{catId}.state = "graduated"` — graduate the bound cat

### 4. Habit Update (Edit)
**Method:** `FirestoreService.updateHabit(uid, habitId, {name?, goalMinutes?, targetHours?, clearTargetHours, reminders?, clearReminders, motivationText?, clearMotivation, deadlineDate?, clearDeadlineDate})`

Single-document update:
1. `UPDATE users/{uid}/habits/{habitId}` — set only the provided fields (`name`, `goalMinutes`, `targetHours`, `deadlineDate`, `reminders`, `motivationText`; if `clearTargetHours == true`, set `targetHours` to `null`; if `clearReminders == true`, set `reminders` to `[]`; if `clearMotivation == true`, set `motivationText` to `null`; if `clearDeadlineDate == true`, set `deadlineDate` to `null`)

**Validation**: At least one field must be non-null or a clear flag must be true. Empty strings are rejected.

> **Note:** Internal identifier remains `habit`. User-facing term is **Quest**.

### 5. Accessory Purchase (Inventory Model)
**Method:** `CoinService.purchaseAccessory(uid, accessoryId, price)`

Transaction includes:
1. `READ users/{uid}` — check balance and existing inventory
2. `UPDATE users/{uid}.coins` — `FieldValue.increment(-price)` (deduct cost)
3. `UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([accessoryId])` (add to inventory)

### 6. Equip Accessory
**Method:** `InventoryService.equipAccessory(uid, catId, accessoryId)`

Transaction includes:
1. `UPDATE users/{uid}.inventory` — `FieldValue.arrayRemove([accessoryId])` (remove from box)
2. `READ users/{uid}/cats/{catId}` — get current `equippedAccessory`
3. If cat already has an equipped accessory: `UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([oldAccessoryId])` (return old to box)
4. `UPDATE users/{uid}/cats/{catId}.equippedAccessory` — set to `accessoryId`

### 7. Unequip Accessory
**Method:** `InventoryService.unequipAccessory(uid, catId)`

Transaction includes:
1. `READ users/{uid}/cats/{catId}` — get current `equippedAccessory`
2. `UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([equippedAccessory])` (return to box)
3. `UPDATE users/{uid}/cats/{catId}.equippedAccessory` — set to `null`

### 8. Daily Check-In (Monthly)
**Method:** `CoinService.checkIn(uid)`

Transaction includes:
1. `READ users/{uid}` — check `lastCheckInDate`; if already today, return early (already checked in)
2. `READ users/{uid}/monthlyCheckIns/{YYYY-MM}` — get or prepare monthly document
3. Compute daily reward: weekday = 10 coins, weekend (Sat/Sun) = 15 coins
4. Check if new `checkedDays.length` crosses milestone thresholds (7, 14, 21, or full month)
5. `SET/UPDATE users/{uid}/monthlyCheckIns/{YYYY-MM}` — append day to `checkedDays`, increment `totalCoins`, append new milestones to `milestonesClaimed`
6. `UPDATE users/{uid}.coins` — `FieldValue.increment(totalReward)` (daily + any milestone bonus)
7. `UPDATE users/{uid}.lastCheckInDate` — set to today's date string

Returns `CheckInResult` with `dailyCoins`, `milestoneBonus`, and `newMilestones`.

---

## Indexes

### Composite Indexes Required

| Collection | Fields | Order | Purpose |
|-----------|--------|-------|---------|
| `users/{uid}/cats` | `state ASC`, `createdAt ASC` | Compound | `watchCats()` — active cats ordered by adoption date |
| `users/{uid}/habits/{habitId}/sessions` | `habitId ASC`, `endedAt DESC` | Compound | Session history per habit |
| `sessions` (collection group) | `endedAt DESC` | Single-field collection group | Cross-habit session history queries |

All other queries use single-field default indexes.

---

## Data Integrity Rules

1. **No orphaned cats**: Every cat document must have a valid `boundHabitId`. Use batch writes to enforce this.
2. **No orphaned habit references**: When a habit is deleted, the bound cat's state is updated to "graduated" in the same batch.
3. **totalMinutes never decreases**: `totalMinutes` is always incremented, never set to a lower value.
4. **Stage is computed, not stored**: Never write `stage` to Firestore. Always derive it from `totalMinutes` using the fixed 200h growth ladder.
5. **Mood is computed, not stored**: Never write `mood` to Firestore. Always derive it from `lastSessionAt`.
6. **`totalMinutes` is additive**: Always use `FieldValue.increment(delta)` — never overwrite with a calculated total (prevents race conditions).
7. **Coins never go negative**: The `CoinService` must validate sufficient balance before deducting. The purchase batch write should fail gracefully if balance is insufficient.
8. **Appearance is immutable**: The `appearance` map is set at cat creation and never modified afterward.
9. **Sessions are immutable**: Once created, session documents cannot be updated or deleted. This ensures audit trail integrity.

---

## Security Model

All documents are fully isolated per `uid`. See [Security Rules](../firebase/security-rules.md) for the full rule specification.

**Access pattern summary:**
- Users can only read/write documents under their own `users/{uid}` path.
- No cross-user data access.
- No public collections.
- Anonymous authenticated users have the same read/write access as regular users under their own `users/{uid}` path. Unauthenticated access is denied.

**Firestore Security Rules — Field Validation:**

The `firestore.rules` file enforces server-side field validation on write operations:

| Collection | Field | Validation Rule |
|-----------|-------|----------------|
| `habits` | `targetHours` | `int` (optional, nullable), range `1–10000` when present |
| `habits` | `goalMinutes` | `int` (optional), range `1–480` |
| `habits` | `motivationText` | `string` (optional), length `0–240` characters |
| `cats` | `name` | `string`, length `1–30` characters |
| `cats` | `state` | `string`, must be one of `['active', 'graduated', 'dormant']` |
| `cats` | `totalMinutes` | `int`, `>= 0` |

These rules complement client-side validation to prevent invalid data from reaching Firestore.

**Cat State Constants:**

The valid cat state values are defined as constants in `lib/core/constants/cat_constants.dart` via the `CatState` class:
- `CatState.active` = `'active'`
- `CatState.graduated` = `'graduated'`
- `CatState.dormant` = `'dormant'`

All code referencing cat state strings must use these constants instead of hardcoded string literals.

---

## Local Storage — SQLite + SharedPreferences

In addition to Firestore, the app uses local-only storage for AI-generated content. This data is not synced to the cloud and is deleted when the app is uninstalled.

### SQLite Database: `hachimi_local.db`

**Service:** `lib/services/local_database_service.dart`

#### Table: `diary_entries`

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `cat_id` | TEXT | NOT NULL | Reference to cat |
| `habit_id` | TEXT | NOT NULL | Reference to habit |
| `content` | TEXT | NOT NULL | Generated diary text (2-4 sentences) |
| `date` | TEXT | NOT NULL | ISO date "YYYY-MM-DD" |
| `personality` | TEXT | NOT NULL | Personality snapshot at generation time |
| `mood` | TEXT | NOT NULL | Mood snapshot at generation time |
| `stage` | TEXT | NOT NULL | Stage snapshot at generation time |
| `total_minutes` | INTEGER | NOT NULL | Total minutes snapshot |
| `created_at` | INTEGER | NOT NULL | Unix timestamp |

**Unique constraint:** `UNIQUE(cat_id, date)` — one diary entry per cat per day.

**Dart Model:** `lib/models/diary_entry.dart` -> `class DiaryEntry`

#### Table: `chat_messages`

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `cat_id` | TEXT | NOT NULL | Reference to cat |
| `role` | TEXT | NOT NULL | `'user'` or `'assistant'` |
| `content` | TEXT | NOT NULL | Message text |
| `created_at` | INTEGER | NOT NULL | Unix timestamp |

**Index:** `idx_chat_cat_created` on `(cat_id, created_at)` for efficient recent message queries.

**Dart Model:** `lib/models/chat_message.dart` -> `class ChatMessage`

### SharedPreferences Keys (AI Features)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `ai_features_enabled` | bool | false | Master toggle for AI features |
| `ai_selected_provider` | String | "minimax" | Active AI provider ID (`minimax` or `gemini`) |

**Constants:** `lib/core/constants/ai_constants.dart` -> `class AiConstants`

---

### Database Version 2 — Local-First Tables (v2.18.0+)

The database was upgraded from version 1 to version 2 to support the local-first architecture. These tables mirror the Firestore schema and serve as the runtime SSOT.

#### Table: `action_ledger`

The immutable append-only log of all data-mutating operations.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `type` | TEXT | NOT NULL | ActionType enum string (e.g. "focus_complete", "check_in", "purchase") |
| `uid` | TEXT | NOT NULL | Firebase Auth UID |
| `started_at` | INTEGER | NOT NULL | Unix timestamp of action start |
| `ended_at` | INTEGER | | Unix timestamp of action end (null for instant actions) |
| `payload` | TEXT | NOT NULL | JSON-encoded action input data |
| `result` | TEXT | | JSON-encoded action output data |
| `synced` | INTEGER | NOT NULL DEFAULT 0 | 0 = unsynced, 1 = synced to Firestore |
| `synced_at` | INTEGER | | Unix timestamp of successful sync |
| `sync_attempts` | INTEGER | NOT NULL DEFAULT 0 | Number of sync retry attempts |
| `sync_error` | TEXT | | Last sync error message |
| `created_at` | INTEGER | NOT NULL | Unix timestamp of ledger entry creation |

**Index:** `idx_ledger_synced` on `(synced, created_at)` for efficient sync queue queries.
**Index:** `idx_ledger_type` on `(type, uid)` for type-filtered queries.

**ActionType enum values:** `check_in`, `focus_complete`, `focus_abandon`, `purchase`, `equip`, `unequip`, `habit_create`, `habit_update`, `habit_delete`, `account_created`, `account_linked`, `achievement_unlocked`, `achievement_claimed`

**Dart Model:** `lib/models/ledger_action.dart` -> `class LedgerAction`, `enum ActionType`

#### Table: `local_habits`

Local mirror of `users/{uid}/habits/{habitId}` Firestore documents.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | Habit ID |
| `uid` | TEXT | NOT NULL | User UID |
| `name` | TEXT | NOT NULL | Habit display name |
| `cat_id` | TEXT | NOT NULL | Bound cat ID |
| `goal_minutes` | INTEGER | NOT NULL | Daily focus goal minutes |
| `target_hours` | INTEGER | | Cumulative target hours (null = unlimited) |
| `total_minutes` | INTEGER | NOT NULL DEFAULT 0 | Total accumulated minutes |
| `deadline_date` | TEXT | | ISO date string for milestone deadline |
| `target_completed` | INTEGER | NOT NULL DEFAULT 0 | 1 if milestone target reached |
| `last_check_in_date` | TEXT | | ISO date of last session |
| `reminders` | TEXT | | JSON-encoded reminder list |
| `motivation_text` | TEXT | | Note/memo text |
| `is_active` | INTEGER | NOT NULL DEFAULT 1 | 0 = deactivated |
| `created_at` | INTEGER | NOT NULL | Unix timestamp |

**Index:** `idx_habits_uid` on `(uid, is_active)`.

#### Table: `local_cats`

Local mirror of `users/{uid}/cats/{catId}` Firestore documents.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | Cat ID |
| `uid` | TEXT | NOT NULL | User UID |
| `name` | TEXT | NOT NULL | Cat name |
| `appearance` | TEXT | NOT NULL | JSON-encoded CatAppearance |
| `personality` | TEXT | NOT NULL | Personality ID |
| `total_minutes` | INTEGER | NOT NULL DEFAULT 0 | Accumulated focus minutes |
| `equipped_accessory` | TEXT | | Currently equipped accessory ID |
| `bound_habit_id` | TEXT | NOT NULL | Bound habit ID |
| `state` | TEXT | NOT NULL | "active", "dormant", "graduated" |
| `last_session_at` | INTEGER | | Unix timestamp of last session |
| `highest_stage` | TEXT | | Highest growth stage reached |
| `created_at` | INTEGER | NOT NULL | Unix timestamp |

**Index:** `idx_cats_uid` on `(uid, state)`.

#### Table: `local_sessions`

Local mirror of focus session documents.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | Session ID |
| `uid` | TEXT | NOT NULL | User UID |
| `habit_id` | TEXT | NOT NULL | Parent habit ID |
| `cat_id` | TEXT | NOT NULL | Cat that earned XP |
| `started_at` | INTEGER | NOT NULL | Unix timestamp |
| `ended_at` | INTEGER | NOT NULL | Unix timestamp |
| `duration_minutes` | INTEGER | NOT NULL | Actual focused minutes |
| `target_duration_minutes` | INTEGER | NOT NULL | Planned duration |
| `paused_seconds` | INTEGER | NOT NULL | Cumulative paused time |
| `status` | TEXT | NOT NULL | "completed", "abandoned", "interrupted" |
| `completion_ratio` | REAL | NOT NULL | Actual / target ratio |
| `xp_earned` | INTEGER | NOT NULL | XP awarded |
| `coins_earned` | INTEGER | NOT NULL | Coins awarded |
| `mode` | TEXT | NOT NULL | "countdown" or "stopwatch" |
| `created_at` | INTEGER | NOT NULL | Unix timestamp |

**Index:** `idx_sessions_uid_date` on `(uid, ended_at)`.
**Index:** `idx_sessions_habit` on `(habit_id, ended_at)`.

#### Table: `local_monthly_checkins`

Local mirror of monthly check-in documents.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | "uid_YYYY-MM" composite key |
| `uid` | TEXT | NOT NULL | User UID |
| `month` | TEXT | NOT NULL | "YYYY-MM" format |
| `checked_days` | TEXT | NOT NULL | JSON-encoded list of day numbers |
| `total_coins` | INTEGER | NOT NULL DEFAULT 0 | Monthly cumulative coins |
| `milestones_claimed` | TEXT | NOT NULL | JSON-encoded list of claimed thresholds |

**Index:** `idx_checkins_uid` on `(uid, month)`.

#### Table: `materialized_state`

Key-value store for computed aggregates that are expensive to re-derive.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `key` | TEXT | PRIMARY KEY | State key (e.g. "coin_balance", "last_check_in_date") |
| `value` | TEXT | NOT NULL | Serialized value |
| `updated_at` | INTEGER | NOT NULL | Unix timestamp of last update |

#### Table: `local_achievements`

Local record of unlocked achievements.

| Column | Type | Constraint | Description |
|--------|------|-----------|-------------|
| `id` | TEXT | PRIMARY KEY | Achievement ID |
| `uid` | TEXT | NOT NULL | User UID |
| `unlocked_at` | INTEGER | NOT NULL | Unix timestamp of unlock |
| `claimed` | INTEGER | NOT NULL DEFAULT 0 | 1 if reward has been claimed |
| `claimed_at` | INTEGER | | Unix timestamp of claim |

**Index:** `idx_achievements_uid` on `(uid)`.

**Dart Model:** `lib/models/unlocked_achievement.dart` -> `class UnlockedAchievement`

---

### Sync Strategy

The local-first architecture uses a **ledger-based sync** pattern:

1. All mutations write to `action_ledger` + update local tables in a single SQLite transaction
2. `SyncEngine` processes unsynced actions (`synced = 0`) ordered by `created_at`
3. Each action is translated to the corresponding Firestore batch write
4. On success, `synced = 1` and `synced_at` is set
5. On failure, `sync_attempts` is incremented with exponential backoff
6. Actions older than 90 days with `synced = 1` are automatically cleaned up

This ensures the app works fully offline, with automatic Firestore synchronization when connectivity is available.
