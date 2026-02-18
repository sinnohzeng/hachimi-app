# Data Model — Firestore Schema (SSOT)

> **SSOT**: This document is the single source of truth for all Firestore collections, document schemas, and data integrity rules. Implementation in `lib/models/` and `lib/services/firestore_service.dart` must match this specification exactly.

---

## Collection Hierarchy

```
users/{uid}                          ← User profile document
├── habits/{habitId}                 ← Habit metadata + streak tracking
│   └── sessions/{sessionId}        ← Focus session history
├── cats/{catId}                     ← Cat state (XP, stage, mood, room slot)
└── checkIns/{date}                  ← Date-partitioned check-in buckets (backward compat)
    └── entries/{entryId}            ← Per-session minute log entries
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

**Notes:**
- `uid` is the Firebase Auth UID and serves as both the document ID and the top-level namespace for all user data.
- `fcmToken` is updated on each app launch via `NotificationService.initialize()`. Multiple devices are not currently supported (last write wins).

---

## Collection: `users/{uid}/habits/{habitId}`

One document per user habit. `habitId` is a Firestore auto-generated ID.

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Habit display name, e.g. "Daily Reading" |
| `icon` | string | yes | — | Emoji character used as the habit icon, e.g. "📚" |
| `catId` | string | yes | — | Reference to the bound cat document ID in `users/{uid}/cats/` |
| `goalMinutes` | int | yes | 25 | Daily focus goal in minutes (used for progress display) |
| `targetHours` | int | yes | 100 | Cumulative long-term target in hours (used for overall progress) |
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

**Dart Model:** `lib/models/habit.dart` → `class Habit`

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

**XP for Abandoned Sessions:**
- If `completed == false` AND `durationMinutes >= 5`: `xpEarned = durationMinutes × 1` (base XP only)
- If `completed == false` AND `durationMinutes < 5`: `xpEarned = 0`

**Dart Model:** `lib/models/focus_session.dart` → `class FocusSession`

---

## Collection: `users/{uid}/cats/{catId}`

One document per cat. `catId` is a Firestore auto-generated ID.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Cat's given name, e.g. "Mochi" |
| `breed` | string | yes | Breed ID from `CatBreed.id` — see [Cat System](cat-system.md) for full list |
| `pattern` | string | yes | Pattern ID: "classic_stripe", "spotted", or "solid" |
| `personality` | string | yes | Personality ID from `CatPersonality.id` — see [Cat System](cat-system.md) |
| `rarity` | string | yes | Rarity tier: "common", "uncommon", or "rare" |
| `xp` | int | yes | Total XP accumulated. Stage is computed from this at read time. |
| `roomSlot` | string | no | Room slot ID where this cat sits — see [Cat System](cat-system.md) for slot list |
| `boundHabitId` | string | yes | Reference to the habit that spawned this cat |
| `state` | string | yes | "active", "dormant", or "graduated" |
| `lastSessionAt` | timestamp | no | Timestamp of the most recent focus session for this cat's habit |
| `createdAt` | timestamp | yes | Cat adoption timestamp |

**Computed Fields (not stored in Firestore):**
These are derived from stored fields at read time to prevent drift.

| Computed | Derived From | Logic |
|----------|-------------|-------|
| `stage` | `xp` | kitten (0), young (100+), adult (300+), shiny (600+) |
| `mood` | `lastSessionAt` | happy (under 24h), neutral (1–3d), lonely (3–7d), missing (over 7d) |

**Why not store `stage` and `mood` directly?**
Storing derived values creates a risk of drift (the stored value diverges from what the formula would compute). By computing at read time from authoritative inputs (`xp` and `lastSessionAt`), the app always shows the correct state without background jobs.

**State Transitions:**

```
active ──[habit deactivated]──► dormant
active ──[habit deleted]──────► graduated
dormant ──[habit reactivated]─► active  (future feature)
```

**Dart Model:** `lib/models/cat.dart` → `class Cat`

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

**Dart Model:** `lib/models/check_in.dart` → `class CheckInEntry`

---

## Atomic Operations (Batch Writes)

Operations that span multiple documents use Firestore **batch writes** to guarantee all-or-nothing consistency. If any write fails, the entire batch rolls back.

### 1. Habit + Cat Creation (Adoption Flow)
**Method:** `FirestoreService.createHabitWithCat(uid, habit, cat)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}` — new habit document
2. `SET users/{uid}/cats/{catId}` — new cat document (with `boundHabitId` pointing to habit)
3. `UPDATE users/{uid}/habits/{habitId}.catId` — back-reference from habit to cat

### 2. Focus Session Completion
**Method:** `FirestoreService.logFocusSession(uid, session)`

Batch includes:
1. `SET users/{uid}/habits/{habitId}/sessions/{sessionId}` — session record
2. `UPDATE users/{uid}/habits/{habitId}` — increment `totalMinutes`, update `currentStreak`, `bestStreak`, `lastCheckInDate`
3. `UPDATE users/{uid}/cats/{catId}.xp` — `xp += session.xpEarned`
4. `UPDATE users/{uid}/cats/{catId}.lastSessionAt` — set to now
5. `SET users/{uid}/checkIns/{today}/entries/{entryId}` — legacy check-in entry (for heatmap)

### 3. Habit Deletion (Graduation)
**Method:** `FirestoreService.deleteHabit(uid, habitId)`

Batch includes:
1. `DELETE users/{uid}/habits/{habitId}` — remove habit document
2. `UPDATE users/{uid}/cats/{catId}.state = "graduated"` — graduate the bound cat

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
3. **XP never decreases**: `xp` is always incremented, never set to a lower value.
4. **Stage is computed, not stored**: Never write `stage` to Firestore. Always derive it from `xp`.
5. **Mood is computed, not stored**: Never write `mood` to Firestore. Always derive it from `lastSessionAt`.
6. **`totalMinutes` is additive**: Always use `FieldValue.increment(delta)` — never overwrite with a calculated total (prevents race conditions).

---

## Security Model

All documents are fully isolated per `uid`. See [Security Rules](../firebase/security-rules.md) for the full rule specification.

**Access pattern summary:**
- Users can only read/write documents under their own `users/{uid}` path.
- No cross-user data access.
- No public collections.
- Anonymous access is denied for all paths.
