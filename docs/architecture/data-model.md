# Data Model — Firestore Schema (SSOT)

> **SSOT**: This document is the single source of truth for all Firestore collections, document schemas, and data integrity rules. Implementation in `lib/models/` and `lib/services/firestore_service.dart` must match this specification exactly.

---

## Collection Hierarchy

```
users/{uid}                          <- User profile document
├── habits/{habitId}                 <- Habit metadata + streak tracking
│   └── sessions/{sessionId}        <- Focus session history
├── cats/{catId}                     <- Cat state (appearance, growth, accessories)
├── monthlyCheckIns/{YYYY-MM}        <- Monthly check-in tracking (resets each month)
└── checkIns/{date}                  <- Date-partitioned check-in buckets (backward compat)
    └── entries/{entryId}            <- Per-session minute log entries
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
| `targetHours` | int | yes | — | Cumulative long-term target in hours (required, used for cat growth calculation) |
| `totalMinutes` | int | yes | 0 | Total minutes logged across all time |
| `currentStreak` | int | yes | 0 | Current consecutive days with at least one session |
| `bestStreak` | int | yes | 0 | All-time highest consecutive day streak |
| `lastCheckInDate` | string | no | null | ISO date string "YYYY-MM-DD" of most recent session (for streak calculation) |
| `reminderTime` | string | no | null | Daily reminder time in "HH:mm" 24-hour format, e.g. "08:30" |
| `isActive` | bool | yes | true | `false` when habit is deactivated (cat becomes dormant) |
| `createdAt` | timestamp | yes | — | Habit creation timestamp |

**Streak Calculation Rule:**
- On each session completion, compare today's date with `lastCheckInDate`.
- If `lastCheckInDate == yesterday`: `currentStreak += 1`
- If `lastCheckInDate == today`: streak unchanged (multiple sessions same day)
- Otherwise: `currentStreak = 1` (streak broken)
- Update `bestStreak = max(bestStreak, currentStreak)` after each update.

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
| `xpEarned` | int | yes | XP awarded at session end (computed by `XpService`) |
| `mode` | string | yes | Timer mode: "countdown" or "stopwatch" |
| `completed` | bool | yes | `true` if user completed the session; `false` if they gave up early |
| `coinsEarned` | int | yes | Coins awarded at session end (`durationMinutes × 10`; 0 if abandoned < 5 min) |

**XP for Abandoned Sessions:**
- If `completed == false` AND `durationMinutes >= 5`: `xpEarned = durationMinutes x 1` (base XP only)
- If `completed == false` AND `durationMinutes < 5`: `xpEarned = 0`

**Dart Model:** `lib/models/focus_session.dart` -> `class FocusSession`

---

## Collection: `users/{uid}/cats/{catId}`

One document per cat. `catId` is a Firestore auto-generated ID.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Cat's given name, e.g. "Mochi" |
| `appearance` | map | yes | Pixel-cat-maker appearance parameters — see [Cat System](cat-system.md) for full parameter list |
| `personality` | string | yes | Personality ID from `CatPersonality.id` — see [Cat System](cat-system.md) |
| `totalMinutes` | int | yes | Total focus minutes accumulated for this cat's habit. Stage is computed from this. |
| `targetMinutes` | int | yes | Target minutes derived from the habit's `targetHours` (targetHours x 60). Used for stage calculation. |
| `accessories` | list\<string\> | yes | **DEPRECATED** — Legacy per-cat owned accessories. Migrated to `users/{uid}.inventory`. Only used during migration. |
| `equippedAccessory` | string | no | Currently equipped accessory ID (null = none equipped) |
| `boundHabitId` | string | yes | Reference to the habit that spawned this cat |
| `state` | string | yes | "active", "dormant", or "graduated" |
| `lastSessionAt` | timestamp | no | Timestamp of the most recent focus session for this cat's habit |
| `createdAt` | timestamp | yes | Cat adoption timestamp |

**Computed Fields (not stored in Firestore):**
These are derived from stored fields at read time to prevent drift.

| Computed | Derived From | Logic |
|----------|-------------|-------|
| `stage` | `totalMinutes`, `targetMinutes` | kitten (< 20%), adolescent (20%–45%), adult (45%–75%), senior (>= 75%) |
| `mood` | `lastSessionAt` | happy (under 24h), neutral (1–3d), lonely (3–7d), missing (over 7d) |

**Why not store `stage` and `mood` directly?**
Storing derived values creates a risk of drift (the stored value diverges from what the formula would compute). By computing at read time from authoritative inputs (`totalMinutes`, `targetMinutes`, and `lastSessionAt`), the app always shows the correct state without background jobs.

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

## Collection: `users/{uid}/checkIns/{date}/entries/{entryId}`

Legacy check-in storage, preserved for backward compatibility and used by the heatmap queries.

`date` is an ISO date string "YYYY-MM-DD", e.g. "2026-02-17".

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `habitId` | string | yes | Reference to parent habit |
| `habitName` | string | yes | Denormalized habit name for read performance |
| `minutes` | int | yes | Minutes logged in this session |
| `completedAt` | timestamp | yes | When this entry was created |

**Dart Model:** `lib/models/check_in.dart` -> `class CheckInEntry`

---

## Atomic Operations (Batch Writes)

Operations that span multiple documents use Firestore **batch writes** to guarantee all-or-nothing consistency. If any write fails, the entire batch rolls back.

### 1. Habit + Cat Creation (Adoption Flow)
**Method:** `FirestoreService.createHabitWithCat(uid, habit, cat)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}` — new habit document (with `targetHours` as required field)
2. `SET users/{uid}/cats/{catId}` — new cat document with `appearance` Map, `targetMinutes` (= `targetHours x 60`), `totalMinutes: 0`, `accessories: []`, and `boundHabitId` pointing to habit
3. `UPDATE users/{uid}/habits/{habitId}.catId` — back-reference from habit to cat

### 2. Focus Session Completion
**Method:** `FirestoreService.logFocusSession(uid, session)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}/sessions/{sessionId}` — session record
2. `UPDATE users/{uid}/habits/{habitId}` — increment `totalMinutes`, update `currentStreak`, `bestStreak`, `lastCheckInDate`
3. `UPDATE users/{uid}/cats/{catId}.totalMinutes` — `totalMinutes += session.durationMinutes`
4. `UPDATE users/{uid}/cats/{catId}.lastSessionAt` — set to now
5. `UPDATE users/{uid}.coins` — `FieldValue.increment(session.coinsEarned)` (focus reward: `durationMinutes × 10`)
6. `SET users/{uid}/checkIns/{today}/entries/{entryId}` — legacy check-in entry (for heatmap)

> **Note:** Daily check-in bonus is no longer awarded in this batch. It is managed independently by `CoinService.checkIn()` via the monthly check-in system.

### 3. Habit Deletion (Graduation)
**Method:** `FirestoreService.deleteHabit(uid, habitId)`

Batch includes:
1. `DELETE users/{uid}/habits/{habitId}` — remove habit document
2. `UPDATE users/{uid}/cats/{catId}.state = "graduated"` — graduate the bound cat

### 4. Habit Update (Edit)
**Method:** `FirestoreService.updateHabit(uid, habitId, {name?, goalMinutes?, targetHours?, reminderTime?, clearReminder})`

Single or multi-document update:
1. `UPDATE users/{uid}/habits/{habitId}` — set only the provided fields (`name`, `goalMinutes`, `targetHours`, `reminderTime`; if `clearReminder == true`, set `reminderTime` to `null`)
2. If `targetHours` changed: `UPDATE users/{uid}/cats/{catId}.targetMinutes` — sync to `targetHours × 60` (reads habit's `catId` to find bound cat)

**Validation**: At least one field must be non-null or `clearReminder` must be true. Empty strings are rejected.

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
| `users/{uid}/checkIns/{date}/entries` | `habitId ASC`, `completedAt DESC` | Compound | Heatmap queries per habit |

All other queries use single-field default indexes.

---

## Data Integrity Rules

1. **No orphaned cats**: Every cat document must have a valid `boundHabitId`. Use batch writes to enforce this.
2. **No orphaned habit references**: When a habit is deleted, the bound cat's state is updated to "graduated" in the same batch.
3. **totalMinutes never decreases**: `totalMinutes` is always incremented, never set to a lower value.
4. **Stage is computed, not stored**: Never write `stage` to Firestore. Always derive it from `totalMinutes` and `targetMinutes`.
5. **Mood is computed, not stored**: Never write `mood` to Firestore. Always derive it from `lastSessionAt`.
6. **`totalMinutes` is additive**: Always use `FieldValue.increment(delta)` — never overwrite with a calculated total (prevents race conditions).
7. **Coins never go negative**: The `CoinService` must validate sufficient balance before deducting. The purchase batch write should fail gracefully if balance is insufficient.
8. **Appearance is immutable**: The `appearance` map is set at cat creation and never modified afterward.

---

## Security Model

All documents are fully isolated per `uid`. See [Security Rules](../firebase/security-rules.md) for the full rule specification.

**Access pattern summary:**
- Users can only read/write documents under their own `users/{uid}` path.
- No cross-user data access.
- No public collections.
- Anonymous access is denied for all paths.

**Firestore Security Rules — Field Validation:**

The `firestore.rules` file enforces server-side field validation on write operations:

| Collection | Field | Validation Rule |
|-----------|-------|----------------|
| `habits` | `targetHours` | `int`, range `1–10000` |
| `habits` | `goalMinutes` | `int` (optional), range `1–480` |
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
| `ai_model_downloaded` | bool | false | Whether the GGUF model file exists locally |
| `ai_model_file_path` | String | "" | Absolute path to the downloaded model file |
| `ai_model_version` | String | "" | Version identifier for model upgrade detection |

**Constants:** `lib/core/constants/llm_constants.dart` -> `class LlmConstants`
