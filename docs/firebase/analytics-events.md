# Firebase Analytics Events (SSOT)

> **SSOT**: This document is the single source of truth for all custom analytics events and user properties.
> The code implementation in `lib/core/constants/analytics_events.dart` and `lib/services/analytics_service.dart` must match these definitions exactly.

---

## Conversion Funnel

```
app_open → sign_up → cat_adopted → focus_session_started → focus_session_completed → cat_level_up
```

Each step in the funnel represents a meaningful user action. Monitor drop-off rates between steps in Firebase Analytics → Funnels.

---

## Event Definitions

### `sign_up`
- **Trigger**: User successfully registers a new account
- **Parameters**: `method` (string: `"email"` or `"google"`)
- **Conversion**: Yes (funnel step 2)

### `cat_adopted`
- **Trigger**: User completes the 3-step adoption flow and creates a habit + cat
- **Parameters**:
  - `breed` (string): breed ID, e.g. `"orange_tabby"`
  - `pattern` (string): `"classic_stripe"`, `"spotted"`, or `"solid"`
  - `personality` (string): personality ID, e.g. `"curious"`
  - `rarity` (string): `"common"`, `"uncommon"`, or `"rare"`
  - `is_first_habit` (bool): `true` if this is the user's first habit
- **Conversion**: Yes (funnel step 3)

### `habit_deleted`
- **Trigger**: User deletes a habit (cat graduates)
- **Parameters**:
  - `habit_id` (string): the deleted habit ID
  - `cat_total_xp` (int): XP the cat had at graduation

### `focus_session_started`
- **Trigger**: User taps "Start Focus" on FocusSetupScreen and timer begins
- **Parameters**:
  - `habit_id` (string)
  - `timer_mode` (string): `"countdown"` or `"stopwatch"`
  - `target_minutes` (int): intended session duration
- **Conversion**: Yes (funnel step 4)

### `focus_session_completed`
- **Trigger**: User completes a focus session (timer hits 0, or user ends stopwatch session)
- **Parameters**:
  - `habit_id` (string)
  - `actual_minutes` (int): actual focused minutes
  - `xp_earned` (int): total XP awarded this session
  - `streak_days` (int): current streak after this session
  - `timer_mode` (string): `"countdown"` or `"stopwatch"`
- **Conversion**: Yes (funnel step 5) — primary engagement metric

### `focus_session_abandoned`
- **Trigger**: User long-presses "Give Up" button and confirms
- **Parameters**:
  - `habit_id` (string)
  - `minutes_completed` (int): minutes focused before giving up
  - `xp_earned` (int): XP awarded (base only if >= 5 min; 0 otherwise)

### `cat_level_up`
- **Trigger**: Cat transitions to a new growth stage
- **Parameters**:
  - `cat_id` (string)
  - `new_stage` (string): `"young"`, `"adult"`, or `"shiny"`
  - `total_xp` (int): cat's total XP at level-up
  - `breed` (string): cat's breed ID
- **Conversion**: Yes (funnel step 6)

### `cat_stage_evolved`
- **Trigger**: Same as `cat_level_up` — use this for segmentation without marking as conversion
- **Parameters**: same as `cat_level_up`

### `streak_achieved`
- **Trigger**: User's streak reaches a milestone (7, 14, or 30 days)
- **Parameters**:
  - `streak_days` (int): milestone value (7, 14, or 30)
  - `habit_id` (string)
- **Conversion**: Yes (milestone events signal deep engagement)

### `all_habits_done`
- **Trigger**: User completes sessions for ALL active habits today (full house bonus)
- **Parameters**:
  - `habit_count` (int): number of habits completed
  - `total_bonus_xp` (int): full house bonus XP awarded

### `cat_room_viewed`
- **Trigger**: User opens the Cat Room tab
- **Parameters**:
  - `cat_count` (int): number of active cats in room

### `cat_tapped`
- **Trigger**: User taps a cat in the Cat Room
- **Parameters**:
  - `cat_id` (string)
  - `action` (string): action taken — `"start_focus"`, `"view_details"`, or `"speech_bubble_dismissed"`

### `notification_opened`
- **Trigger**: User opens the app via a push notification
- **Parameters**:
  - `notification_type` (string): `"daily_reminder"`, `"streak_at_risk"`, `"level_up"`, or `"win_back"`

---

## User Properties

Set once and update as values change. Used for audience segmentation in Firebase Analytics.

| Property | Type | Description | When Updated |
|----------|------|-------------|-------------|
| `cat_count` | int | Number of active cats (= active habits) | On habit create/delete |
| `max_cat_stage` | string | Highest stage reached across all cats (`"kitten"`, `"young"`, `"adult"`, `"shiny"`) | On cat level-up |
| `total_cats_ever` | int | All cats ever adopted (including graduated) | On cat adoption |
| `longest_streak` | int | Best streak across all habits | After each session |
| `days_active` | int | Days since account creation | On each app open |
| `rare_cats_owned` | int | Count of cats with `rarity == "rare"` | On cat adoption |

---

## DebugView Verification Checklist

Use `adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app` to enable DebugView.

- [ ] `sign_up` fires on registration with correct `method`
- [ ] `cat_adopted` fires with breed, personality, rarity params after adoption flow
- [ ] `focus_session_started` fires when timer starts with correct mode and duration
- [ ] `focus_session_completed` fires with actual minutes and XP earned
- [ ] `focus_session_abandoned` fires when Give Up is confirmed
- [ ] `cat_level_up` fires when cat transitions to new stage
- [ ] `streak_achieved` fires at 7, 14, 30-day milestones
- [ ] `all_habits_done` fires when all habits completed in a day
- [ ] `cat_room_viewed` fires on Cat Room tab open
- [ ] `notification_opened` fires when app opened via notification
- [ ] User properties update after adoption and sessions

---

## Code Reference

**Event name constants:** `lib/core/constants/analytics_events.dart`

```dart
class AnalyticsEvents {
  static const String signUp = 'sign_up';
  static const String catAdopted = 'cat_adopted';
  static const String focusSessionStarted = 'focus_session_started';
  static const String focusSessionCompleted = 'focus_session_completed';
  static const String focusSessionAbandoned = 'focus_session_abandoned';
  static const String catLevelUp = 'cat_level_up';
  static const String streakAchieved = 'streak_achieved';
  static const String allHabitsDone = 'all_habits_done';
  static const String catRoomViewed = 'cat_room_viewed';
  static const String catTapped = 'cat_tapped';
  static const String notificationOpened = 'notification_opened';
}
```

**Logging methods:** `lib/services/analytics_service.dart`
