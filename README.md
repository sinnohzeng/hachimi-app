# Hachimi

A habit check-in and time tracking app built with **Flutter + Firebase + Material Design 3**.

Track daily habits, log investment time, and monitor progress toward long-term goals. Built to demonstrate hands-on Firebase SDK integration across 6 services.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x (Dart 3.x) |
| Design | Material Design 3 (Material You) |
| State | Riverpod 2.x |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Analytics | Firebase Analytics (custom events) |
| Messaging | Firebase Cloud Messaging (FCM) |
| Config | Firebase Remote Config (A/B testing) |
| Monitoring | Firebase Crashlytics |

## Features

- Email registration and login (Firebase Auth)
- Create habits with name, icon, and target hours
- Timer-based or manual time logging
- Progress tracking (accumulated vs target hours)
- Streak tracking (consecutive check-in days)
- Firebase Analytics with 7+ custom conversion events
- Push notification reminders (FCM)
- A/B test motivational copy (Remote Config)

## Firebase Analytics Events

```
Conversion funnel:
app_open → sign_up → habit_created → timer_started → daily_check_in → streak_7_days

Custom events: sign_up, habit_created, timer_started, timer_completed,
daily_check_in, streak_achieved, goal_progress, notification_opened

User properties: total_habits, longest_streak, total_hours_logged, days_since_signup
```

## Architecture

```
Screens → Providers (Riverpod) → Services → Firebase SDK
```

- **DDD**: Documentation-driven development — specs in `docs/` before code
- **SSOT**: Single source of truth — Firestore for data, Theme for UI, Riverpod for state

See [docs/](docs/) for full architecture, product, and Firebase documentation.

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Firebase CLI
- FlutterFire CLI

### Setup

```bash
# Clone and install dependencies
flutter pub get

# Configure Firebase (requires Firebase project)
flutterfire configure

# Uncomment firebase_options imports in lib/main.dart

# Run on device/emulator
flutter run
```

### Firebase Configuration
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password)
3. Create Firestore database (test mode)
4. Run `flutterfire configure` to generate `firebase_options.dart`
5. See [docs/firebase/setup-guide.md](docs/firebase/setup-guide.md) for details

## Project Structure

```
lib/
├── main.dart                    # Entry point + Firebase init
├── app.dart                     # MaterialApp + M3 theme
├── core/                        # Theme (SSOT), constants, router
├── models/                      # Dart data models
├── services/                    # Firebase service wrappers
├── providers/                   # Riverpod providers (SSOT)
├── screens/                     # Full-page screens
└── widgets/                     # Reusable UI components

docs/                            # DDD documentation
├── architecture/                # Tech architecture specs
├── product/                     # PRD, user stories, MVP scope
├── firebase/                    # Firebase setup + event definitions
└── design/                      # M3 design system + screen specs
```
