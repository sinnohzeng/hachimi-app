# Firebase Analytics Events (SSOT)

> **SSOT**: This document is the single source of truth for all custom analytics events and user properties.
> The code implementation in `lib/core/constants/analytics_events.dart` and `lib/services/analytics_service.dart` must match these definitions exactly.

---

## Conversion Funnel

```
app_open → sign_up → cat_adopted → focus_session_started → focus_session_completed → cat_level_up
```

Each step in the funnel represents a meaningful user action. Monitor drop-off rates between steps in Firebase Analytics → Funnels.

### Enhanced Retention Funnel

```
app_opened → onboarding_completed → first_session_completed → streak_achieved(7d) → streak_achieved(30d)
```

---

## Event Definitions

### Core Lifecycle Events

#### `sign_up`
- **Trigger**: User successfully registers a new account
- **Parameters**: `method` (string: `"email"` or `"google"`)
- **Conversion**: Yes (funnel step 2)

#### `onboarding_completed`
- **Trigger**: User completes the onboarding flow
- **Parameters**: none
- **Code**: `onboarding_screen.dart`

#### `cat_adopted`
- **Trigger**: User completes the 3-step adoption flow and creates a habit + cat
- **Parameters**:
  - `breed` (string): breed ID, e.g. `"orange_tabby"`
  - `pattern` (string): `"classic_stripe"`, `"spotted"`, or `"solid"`
  - `personality` (string): personality ID, e.g. `"curious"`
  - `rarity` (string): `"common"`, `"uncommon"`, or `"rare"`
  - `is_first_habit` (bool): `true` if this is the user's first habit
- **Conversion**: Yes (funnel step 3)

#### `habit_deleted`
- **Trigger**: User deletes a habit (cat graduates)
- **Parameters**:
  - `habit_id` (string): the deleted habit ID
  - `cat_total_xp` (int): XP the cat had at graduation

### Focus Session Events

#### `focus_session_started`
- **Trigger**: User taps "Start Focus" on FocusSetupScreen and timer begins
- **Parameters**:
  - `habit_id` (string)
  - `timer_mode` (string): `"countdown"` or `"stopwatch"`
  - `target_minutes` (int): intended session duration
- **Conversion**: Yes (funnel step 4)

#### `focus_session_completed`
- **Trigger**: User completes a focus session (timer hits 0, or user ends stopwatch session)
- **Parameters**:
  - `habit_id` (string)
  - `actual_minutes` (int): actual focused minutes
  - `xp_earned` (int): total XP awarded this session
  - `streak_days` (int): current streak after this session
  - `timer_mode` (string): `"countdown"` or `"stopwatch"`
- **Conversion**: Yes (funnel step 5) — primary engagement metric

#### `focus_session_abandoned`
- **Trigger**: User long-presses "Give Up" button and confirms
- **Parameters**:
  - `habit_id` (string)
  - `minutes_completed` (int): minutes focused before giving up
  - `xp_earned` (int): XP awarded (base only if >= 5 min; 0 otherwise)

#### `first_session_completed`
- **Trigger**: User completes their very first focus session ever
- **Parameters**:
  - `habit_id` (string)
  - `actual_minutes` (int)
- **Code**: `focus_timer_provider.dart`

#### `session_quality`
- **Trigger**: Logged alongside `focus_session_completed` with session analytics
- **Parameters**:
  - `session_duration` (int): actual duration in seconds
  - `completion_ratio` (double): actual / target ratio (e.g. 0.85)
- **Code**: `focus_timer_provider.dart`

### Cat Events

#### `cat_level_up`
- **Trigger**: Cat transitions to a new growth stage
- **Parameters**:
  - `cat_id` (string)
  - `new_stage` (string): `"young"`, `"adult"`, or `"shiny"`
  - `total_xp` (int): cat's total XP at level-up
  - `breed` (string): cat's breed ID
- **Conversion**: Yes (funnel step 6)

#### `cat_stage_evolved`
- **Trigger**: Same as `cat_level_up` — use this for segmentation without marking as conversion
- **Parameters**: same as `cat_level_up`

### Engagement Events

#### `feature_used`
- **Trigger**: User opens a specific feature screen
- **Parameters**:
  - `feature` (string): feature identifier (e.g. `"cat_chat"`, `"diary"`, `"shop"`, `"inventory"`)
- **Code**: various screen `initState` methods

#### `ai_chat_started`
- **Trigger**: User sends a message in cat chat
- **Parameters**:
  - `cat_id` (string)
- **Code**: `chat_provider.dart`

#### `ai_diary_generated`
- **Trigger**: AI diary generation completes successfully
- **Parameters**:
  - `cat_id` (string)
- **Code**: `diary_service.dart`

#### `streak_achieved`
- **Trigger**: User's streak reaches a milestone (7, 14, or 30 days)
- **Parameters**:
  - `streak_days` (int): milestone value (7, 14, or 30)
  - `habit_id` (string)
- **Conversion**: Yes (milestone events signal deep engagement)

#### `all_habits_done`
- **Trigger**: User completes sessions for ALL active habits today (full house bonus)
- **Parameters**:
  - `habit_count` (int): number of habits completed
  - `total_bonus_xp` (int): full house bonus XP awarded

### Economy Events

#### `coins_earned`
- **Trigger**: User earns coins from any source (focus session, check-in, streak bonus)
- **Parameters**:
  - `coin_amount` (int): number of coins earned
  - `coin_source` (string): source identifier (e.g. `"focus_session"`, `"daily_checkin"`, `"streak_bonus"`)
- **Code**: `coin_service.dart`

#### `coins_spent`
- **Trigger**: User spends coins (purchasing an accessory)
- **Parameters**:
  - `coin_amount` (int): number of coins spent
  - `accessory_id` (string): purchased item ID
- **Code**: `coin_service.dart`

#### `accessory_purchased`
- **Trigger**: User buys an accessory from the shop
- **Parameters**:
  - `accessory_id` (string)
  - `price` (int): coin price
- **Code**: `coin_service.dart`

#### `accessory_equipped`
- **Trigger**: User equips an accessory on a cat
- **Parameters**:
  - `cat_id` (string)
  - `accessory_id` (string)
- **Code**: `inventory_service.dart`

### Navigation Events

#### `cat_room_viewed`
- **Trigger**: User opens the Cat Room tab
- **Parameters**:
  - `cat_count` (int): number of active cats in room

#### `cat_tapped`
- **Trigger**: User taps a cat in the Cat Room
- **Parameters**:
  - `cat_id` (string)
  - `action` (string): action taken — `"start_focus"`, `"view_details"`, or `"speech_bubble_dismissed"`

#### `notification_opened`
- **Trigger**: User opens the app via a push notification
- **Parameters**:
  - `notification_type` (string): `"daily_reminder"`, `"streak_at_risk"`, `"level_up"`, or `"win_back"`

### Retention Signals

#### `app_opened`
- **Trigger**: User opens the app (after authentication completes)
- **Parameters**:
  - `days_since_last` (int): days since the user last opened the app
  - `consecutive_days` (int): current consecutive daily open count
- **Code**: `app.dart` (`_FirstHabitGateState`)

### Error Tracking

#### `app_error`
- **Trigger**: Any caught error recorded via `ErrorHandler.record()`
- **Parameters**:
  - `error_type` (string): Dart runtime type of the error
  - `error_source` (string): class/module where the error occurred
  - `error_operation` (string): method name that failed
- **Code**: `lib/core/utils/error_handler.dart` (automatic)

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

**Core Events:**
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

**New Events (v2.5):**
- [ ] `app_error` fires when an error is caught via ErrorHandler
- [ ] `feature_used` fires on feature screen open
- [ ] `ai_chat_started` fires when user sends a chat message
- [ ] `ai_diary_generated` fires on successful diary generation
- [ ] `session_quality` fires alongside focus_session_completed
- [ ] `app_opened` fires after authentication with correct days_since_last
- [ ] `coins_earned` fires with correct amount and source
- [ ] `coins_spent` fires on accessory purchase
- [ ] `accessory_equipped` fires when equipping accessory
- [ ] `accessory_purchased` fires with accessory_id and price
- [ ] `onboarding_completed` fires at end of onboarding
- [ ] `first_session_completed` fires only for the very first session

---

## Code Reference

**Event name constants:** `lib/core/constants/analytics_events.dart`

**Logging methods:** `lib/services/analytics_service.dart`

**Error tracking:** `lib/core/utils/error_handler.dart` (automatically logs `app_error` events)
