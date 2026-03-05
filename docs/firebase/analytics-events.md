# Analytics Events

> SSOT for custom analytics event names in `lib/core/constants/analytics_events.dart`.

## Event Families
### Auth
- `sign_up`

### Habit / Session
- `habit_created`
- `habit_deleted`
- `focus_session_started`
- `focus_session_completed`
- `focus_session_abandoned`

### Cat / Achievement
- `cat_adopted`
- `cat_level_up`
- `achievement_unlocked`

### Economy
- `coins_earned`
- `coins_spent`
- `accessory_purchased`
- `accessory_equipped`

### Account lifecycle
- `account_deletion_started`
- `account_deletion_completed`
- `account_deletion_failed`

### Observability
- `app_error`
  - required params:
    - `error_type`
    - `error_source`
    - `error_operation`
  - additional params:
    - `correlation_id`
    - `operation_stage`
    - `error_code`

## Removed Legacy Events
The following compatibility events were removed from active tracking:
- `timer_started`
- `timer_completed`
- `daily_check_in`
- `goal_progress`

## Implementation Rule
- New event names must be added to `analytics_events.dart` first.
- Service API (`AnalyticsService`) must mirror constants exactly.
- Docs and code must be updated in the same change.
