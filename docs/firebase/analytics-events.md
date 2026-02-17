# Firebase Analytics Events (SSOT)

> This document is the single source of truth for all custom analytics events.
> Code implementation must match these definitions exactly.
> See `lib/core/constants/analytics_events.dart` for the code SSOT.

## Conversion Funnel

```
app_open → sign_up → first_habit_created → first_timer_started → daily_check_in → streak_7_days
```

## Event Definitions

### sign_up
- **Trigger**: User completes registration
- **Parameters**: `method` (email)
- **Conversion**: Yes

### habit_created
- **Trigger**: User creates a new habit
- **Parameters**:
  - `habit_name`: string
  - `target_hours`: int
- **Conversion**: Yes (first occurrence)

### habit_deleted
- **Trigger**: User deletes a habit
- **Parameters**:
  - `habit_name`: string

### timer_started
- **Trigger**: User starts the timer for a habit
- **Parameters**:
  - `habit_name`: string

### timer_completed
- **Trigger**: User completes a timer session
- **Parameters**:
  - `habit_name`: string
  - `duration_minutes`: int

### daily_check_in
- **Trigger**: Time is logged for a habit (timer or manual)
- **Parameters**:
  - `habit_name`: string
  - `streak_count`: int
  - `minutes_today`: int

### streak_achieved
- **Trigger**: User hits a streak milestone
- **Parameters**:
  - `habit_name`: string
  - `milestone`: int (7, 14, 30)

### goal_progress
- **Trigger**: User's progress crosses 25%, 50%, 75%, 100% thresholds
- **Parameters**:
  - `habit_name`: string
  - `percent_complete`: int

### notification_opened
- **Trigger**: User opens app via push notification
- **Parameters**: none

## User Properties

| Property | Type | Description |
|----------|------|-------------|
| `total_habits` | int | Number of active habits |
| `longest_streak` | int | Best streak across all habits |
| `total_hours_logged` | int | Total hours logged across all habits |
| `days_since_signup` | int | Days since account creation |

## DebugView Verification Checklist
- [ ] sign_up fires on registration
- [ ] habit_created fires with correct params
- [ ] timer_started fires when timer begins
- [ ] timer_completed fires with correct duration
- [ ] daily_check_in fires with streak count
- [ ] streak_achieved fires at milestones
- [ ] User properties update correctly
