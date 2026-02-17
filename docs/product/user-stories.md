# User Stories

## Authentication
- **US-1**: As a new user, I can register with email and password so that my data is saved to my account.
- **US-2**: As a returning user, I can log in with my credentials so that I can access my habits and progress.
- **US-3**: As a logged-in user, I stay authenticated across app restarts.

## Habit Management
- **US-4**: As a user, I can create a new habit with a name, icon, and target hours so that I can track a specific preparation area.
- **US-5**: As a user, I can see all my habits on the home screen with today's status (checked in or not).
- **US-6**: As a user, I can delete a habit I no longer need.

## Daily Check-in
- **US-7**: As a user, I can start a timer for a habit to track my active study time.
- **US-8**: As a user, I can pause and resume the timer if I take a break.
- **US-9**: As a user, I can complete the timer session, which logs the time to my habit.
- **US-10**: As a user, I can manually enter minutes if I forgot to use the timer.

## Progress Tracking
- **US-11**: As a user, I can see my accumulated hours vs my target for each habit.
- **US-12**: As a user, I can see my current streak (consecutive check-in days) per habit.
- **US-13**: As a user, I can see a calendar view showing which days I checked in.
- **US-14**: As a user, I can see my total time invested today across all habits.

## Notifications
- **US-15**: As a user, I receive a daily push notification reminding me to check in.

## Acceptance Criteria Format
Each user story is considered done when:
1. The feature works as described
2. Relevant Firebase Analytics events fire correctly
3. UI follows Material Design 3 guidelines
