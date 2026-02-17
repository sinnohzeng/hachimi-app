# Firestore Data Model (SSOT)

> This document is the single source of truth for all Firestore collections and document schemas.

## Collection Structure

```
users/{uid}
├── profile (document fields on user doc)
│   ├── displayName: string
│   ├── email: string
│   └── createdAt: timestamp
│
├── habits/{habitId} (subcollection)
│   ├── name: string              // e.g. "LeetCode Practice"
│   ├── icon: string              // Material icon name, e.g. "code"
│   ├── targetHours: number       // Goal: total hours, e.g. 100
│   ├── totalMinutes: number      // Accumulated minutes logged
│   ├── currentStreak: number     // Current consecutive days
│   ├── bestStreak: number        // All-time best streak
│   ├── lastCheckInDate: string   // "2026-02-18" for streak calculation
│   └── createdAt: timestamp
│
└── checkIns/{date} (subcollection, date = "2026-02-18")
    └── entries/{entryId} (subcollection)
        ├── habitId: string
        ├── habitName: string     // Denormalized for read performance
        ├── minutes: number       // Minutes invested this session
        └── completedAt: timestamp
```

## Design Decisions

### Why subcollections?
- `habits` as subcollection: each user's habits are isolated, security rules are simpler
- `checkIns/{date}/entries`: date-partitioned for efficient "today's check-ins" queries

### Why denormalize `habitName` in entries?
- Avoids an extra read when displaying check-in history
- Acceptable trade-off: habit names rarely change

### Indexes Required
- `checkIns/{date}/entries` ordered by `completedAt` (default)
- No composite indexes needed for MVP

## Dart Model Mapping

### Habit
```dart
class Habit {
  final String id;
  final String name;
  final String icon;
  final int targetHours;
  final int totalMinutes;
  final int currentStreak;
  final int bestStreak;
  final String? lastCheckInDate;
  final DateTime createdAt;
}
```

### CheckInEntry
```dart
class CheckInEntry {
  final String id;
  final String habitId;
  final String habitName;
  final int minutes;
  final DateTime completedAt;
}
```
