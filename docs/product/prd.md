# Product Requirements Document (PRD)

## Product Vision

**Hachimi** is a habit check-in and time tracking app designed for goal-oriented individuals who want to systematically track their daily investment toward long-term goals (e.g., interview preparation, skill building).

## Problem Statement

When preparing for important milestones (like job interviews), people need to:
1. Set clear time investment goals for each preparation area
2. Track daily progress consistently
3. Maintain motivation through streaks and visible progress
4. Get reminded to stay on track

## Target User

Professionals preparing for career milestones who want to track their daily study/practice investment across multiple preparation areas.

## Core Features (MVP)

### F1: User Authentication
- Email/password registration and login
- Persistent session (stay logged in)

### F2: Habit Management
- Create a habit with: name, icon, target hours
- View all habits on home screen
- Delete a habit

### F3: Daily Check-in + Time Logging
- Start a timer for a specific habit (count-up, not Pomodoro-fixed)
- Pause and resume timer
- Complete timer → log minutes to Firestore
- Alternative: manually enter minutes invested
- Each check-in updates the habit's total accumulated time

### F4: Progress Tracking
- Per-habit: accumulated hours vs target (progress bar/ring)
- Per-habit: current streak (consecutive days checked in)
- Overall: today's total investment time
- Calendar heatmap: which days had check-ins

### F5: Push Notifications
- Daily reminder to check in (configurable time)
- Streak-at-risk notification (if no check-in by evening)

### F6: A/B Testing
- Test motivational copy on check-in completion screen
- Variant A: "Great job! Keep the momentum going."
- Variant B: "Day {streak} complete. You're {percent}% closer to your goal."

## Out of Scope (MVP)
- Social features / sharing
- Multiple languages
- Dark mode toggle
- App Store submission
- Offline-first / local caching
- Data export
