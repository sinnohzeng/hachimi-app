# Firebase Remote Config

> Remote Config enables dynamic parameter updates and A/B experiments without a new app release. The code SSOT is `lib/services/remote_config_service.dart`.

---

## Parameters

All parameters are initialized with in-code defaults in `RemoteConfigService._defaults`. Remote Config values override these defaults after the first successful fetch.

### `xp_multiplier`
- **Type**: Double
- **Default**: `1.0`
- **Code getter**: `remoteConfigService.xpMultiplier`
- **Description**: Multiplies total XP earned at end of every focus session. Used for seasonal events (e.g., set to `2.0` for a "Double XP Weekend").
- **A/B use**: Test `1.0` vs `1.5` to measure impact on session completion rate.

### `notification_copy_variant`
- **Type**: String
- **Default**: `"A"`
- **Code getter**: `remoteConfigService.notificationCopyVariant`
- **Description**: Controls which notification copy variant is used for daily reminders.
  - `"A"` — "{cat name} is waiting for you! Time to focus on {habit name}."
  - `"B"` — "Day {streak} check-in for {habit name}. Don't stop now!"
- **A/B use**: Compare open rates between variants.

### `mood_threshold_lonely_days`
- **Type**: Int
- **Default**: `3`
- **Code getter**: `remoteConfigService.moodThresholdLonelyDays`
- **Description**: Number of days without a session before a cat's mood transitions from `neutral` to `lonely`. Controls emotional urgency.
  - Lower value (e.g., `2`): more urgency, potentially more annoying
  - Higher value (e.g., `5`): less urgency, may reduce win-back effectiveness
- **A/B use**: Test `3` vs `5` to measure impact on session return rate after a gap.

### `default_focus_duration`
- **Type**: Int
- **Default**: `25`
- **Code getter**: `remoteConfigService.defaultFocusDuration`
- **Description**: The pre-selected timer duration (in minutes) on the Focus Setup screen, overriding the habit's `goalMinutes` only if this config value differs. Currently used as a fallback when `goalMinutes` is not set.
- **A/B use**: Test `25` vs `15` to measure impact on session start rate (shorter sessions may lower barrier).

---

## Code Usage

```dart
// In any widget or service that has access to RemoteConfigService:
final multiplier = remoteConfigService.xpMultiplier;          // double
final copyVariant = remoteConfigService.notificationCopyVariant; // String
final lonelyDays = remoteConfigService.moodThresholdLonelyDays;  // int
final defaultDuration = remoteConfigService.defaultFocusDuration; // int
```

The service fetches and activates remote values on app startup. The minimum fetch interval is 1 hour in production (12 hours by default for Firebase).

---

## Setup in Firebase Console

### 1. Publish Default Parameters

Go to **Firebase Console → Remote Config → Create configuration**. Add each parameter with its default value:

| Parameter | Type | Default Value |
|-----------|------|---------------|
| `xp_multiplier` | Number | `1` |
| `notification_copy_variant` | String | `A` |
| `mood_threshold_lonely_days` | Number | `3` |
| `default_focus_duration` | Number | `25` |

Click **Publish changes**.

### 2. Create an A/B Experiment

Go to **Firebase Console → A/B Testing → Create experiment → Remote Config**.

Example: Test notification copy
1. **Name**: "Notification Copy Variant Test"
2. **Target**: All users (or a specific audience)
3. **Split**: 50% / 50%
4. **Control group**: `notification_copy_variant = "A"`
5. **Treatment group**: `notification_copy_variant = "B"`
6. **Goal metric**: `notification_opened` event count
7. **Duration**: 14 days minimum

---

## Fetch & Activate Behavior

The app calls `RemoteConfigService.initialize()` in `main.dart` before `runApp()`. This:
1. Sets in-code defaults (so the app works even without network)
2. Fetches the latest config from Firebase (with minimum 1-hour cache)
3. Activates the fetched config (makes it available to getters)

During development, you can reduce the fetch interval to 0 for instant updates:
```dart
// Development only — remove for production
await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(minutes: 1),
  minimumFetchInterval: Duration.zero,
));
```
