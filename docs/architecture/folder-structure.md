# Project Folder Structure

```
hachimi_app/
│
├── docs/                              # DDD: All specification documents
│   ├── README.md                      # Documentation index
│   ├── architecture/                  # Technical architecture docs
│   ├── product/                       # Product requirements docs
│   ├── firebase/                      # Firebase configuration docs
│   └── design/                        # UI/UX design docs
│
├── lib/                               # Application source code
│   ├── main.dart                      # Entry point: Firebase init
│   ├── app.dart                       # MaterialApp + M3 Theme + Router
│   │
│   ├── core/                          # Shared foundations
│   │   ├── theme/
│   │   │   └── app_theme.dart         # M3 theme definition (SSOT)
│   │   ├── constants/
│   │   │   └── analytics_events.dart  # Analytics event names (SSOT)
│   │   └── router/
│   │       └── app_router.dart        # Route definitions
│   │
│   ├── models/                        # Data models (Dart classes)
│   │   ├── habit.dart                 # Habit model + Firestore mapping
│   │   └── check_in.dart             # CheckInEntry model + mapping
│   │
│   ├── services/                      # Firebase service wrappers
│   │   ├── auth_service.dart          # Firebase Auth operations
│   │   ├── firestore_service.dart     # Firestore CRUD operations
│   │   ├── analytics_service.dart     # Custom event logging
│   │   ├── notification_service.dart  # FCM push notifications
│   │   └── remote_config_service.dart # Remote Config fetch
│   │
│   ├── providers/                     # Riverpod providers (SSOT)
│   │   ├── auth_provider.dart         # Auth state provider
│   │   ├── habits_provider.dart       # Habits list provider
│   │   └── stats_provider.dart        # Computed stats provider
│   │
│   ├── screens/                       # Full-page screens
│   │   ├── auth/
│   │   │   └── login_screen.dart      # Login / Register
│   │   ├── home/
│   │   │   └── home_screen.dart       # Main screen with habit list
│   │   ├── habits/
│   │   │   ├── add_habit_screen.dart   # Create new habit
│   │   │   └── habit_detail_screen.dart # Habit detail + history
│   │   ├── timer/
│   │   │   └── timer_screen.dart      # Active timer for a habit
│   │   └── stats/
│   │       └── stats_screen.dart      # Statistics dashboard
│   │
│   └── widgets/                       # Reusable UI components
│       ├── habit_card.dart            # Habit list item card
│       ├── check_in_button.dart       # Check-in action button
│       ├── timer_display.dart         # Timer countdown/up display
│       ├── progress_ring.dart         # Circular progress indicator
│       └── streak_indicator.dart      # Streak badge/counter
│
├── pubspec.yaml                       # Dependencies
├── firebase.json                      # Firebase project config
└── README.md                          # Project overview + quick start
```

## Conventions
- One class per file, file name matches class name in snake_case
- Screens are full-page widgets that consume Providers
- Widgets are reusable components that receive data via constructor
- Services are stateless classes that wrap Firebase SDK calls
- Providers are the only bridge between Services and Screens
