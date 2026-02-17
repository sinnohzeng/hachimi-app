# Firebase Remote Config

> A/B test configuration for motivational copy on check-in completion.

## Parameters

### `checkin_success_message`
- **Type**: String
- **Default**: "Great job! Keep the momentum going."
- **Description**: Message shown after a successful check-in

### `checkin_success_variant`
- **Type**: String
- **Default**: "A"
- **Description**: Controls which success message variant to show

## A/B Test: Check-in Success Message

### Variant A (Control)
```
"Great job! Keep the momentum going."
```

### Variant B (Treatment)
```
"Day {streak} complete. You're {percent}% closer to your goal."
```

## Setup in Firebase Console
1. Go to Remote Config → Add parameter
2. Add `checkin_success_message` with default value
3. Go to A/B Testing → Create experiment
4. Target: 50% of users per variant
5. Goal metric: `daily_check_in` event count (engagement)

## Code Usage
```dart
final message = remoteConfigService.getString('checkin_success_message');
```
