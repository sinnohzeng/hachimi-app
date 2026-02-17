# Screen Specifications

## S1: Login Screen (`login_screen.dart`)

### Layout
- Centered content with app logo/name at top
- Email TextField
- Password TextField
- "Login" FilledButton
- "Don't have an account? Register" TextButton
- Toggle between Login and Register mode

### Analytics Events
- `sign_up` on successful registration

---

## S2: Home Screen (`home_screen.dart`)

### Layout
- AppBar with app name and logout action
- Scrollable list of HabitCards
- Each card shows: icon, name, today's minutes, progress bar, streak badge
- Cards are tappable → navigate to timer
- FAB to add new habit
- Bottom NavigationBar: Home (selected) | Stats

### Empty State
- Illustration/icon + "Create your first habit" message + CTA button

### Analytics Events
- `screen_view` (automatic with navigator observer)

---

## S3: Add Habit Screen (`add_habit_screen.dart`)

### Layout
- AppBar with "New Habit" title and close button
- Name TextField (required)
- Icon selector (grid of common Material icons)
- Target hours TextField (number input)
- "Create" FilledButton

### Analytics Events
- `habit_created` on successful creation

---

## S4: Timer Screen (`timer_screen.dart`)

### Layout
- Large timer display (HH:MM:SS) in center
- Habit name above timer
- Start / Pause / Resume button (FilledButton.tonal)
- "Done" FilledButton to complete session
- "Enter manually" TextButton as alternative
- Progress ring showing today's total vs habit daily average

### Behavior
- Timer counts up from 00:00:00
- On "Done": logs minutes to Firestore, shows success message (from Remote Config)
- On "Enter manually": shows dialog with minutes input field

### Analytics Events
- `timer_started` when timer begins
- `timer_completed` when session is saved
- `daily_check_in` after time is logged
- `streak_achieved` if milestone is hit

---

## S5: Stats Screen (`stats_screen.dart`)

### Layout
- AppBar with "Statistics" title
- Summary cards row:
  - Total hours logged (all habits)
  - Longest streak
  - Active habits count
- Per-habit progress section:
  - Each habit: name, progress ring (% of target), hours logged / target
- Calendar heatmap (simplified): grid showing last 30 days, colored by check-in intensity
- Bottom NavigationBar: Home | Stats (selected)

### Analytics Events
- `screen_view` (automatic)

---

## Navigation Flow

```
LoginScreen
    ↓ (authenticated)
HomeScreen ←→ StatsScreen  (via NavigationBar)
    ↓ (tap habit card)
TimerScreen
    ↓ (tap FAB)
AddHabitScreen
```
