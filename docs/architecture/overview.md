# Architecture Overview

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | Flutter 3.x | Cross-platform mobile UI |
| Design System | Material Design 3 | Google-aligned UI components |
| State Management | Riverpod 2.x | Reactive state with SSOT providers |
| Backend | Firebase (cloud) | Auth, database, analytics, messaging |
| Language | Dart 3.x | Type-safe, null-safe development |

## System Architecture

```
┌─────────────────────────────────────────────┐
│                  Flutter App                 │
├─────────────────────────────────────────────┤
│  Screens (UI Layer)                         │
│  ├── LoginScreen                            │
│  ├── HomeScreen                             │
│  ├── AddHabitScreen                         │
│  ├── TimerScreen                            │
│  └── StatsScreen                            │
├─────────────────────────────────────────────┤
│  Providers (State Layer - Riverpod)         │
│  ├── authProvider          (SSOT: auth)     │
│  ├── habitsProvider        (SSOT: habits)   │
│  └── statsProvider         (SSOT: stats)    │
├─────────────────────────────────────────────┤
│  Services (Data Layer)                      │
│  ├── AuthService           → Firebase Auth  │
│  ├── FirestoreService      → Firestore      │
│  ├── AnalyticsService      → Analytics      │
│  ├── NotificationService   → FCM            │
│  └── RemoteConfigService   → Remote Config  │
├─────────────────────────────────────────────┤
│  Firebase SDK                               │
│  ├── firebase_auth                          │
│  ├── cloud_firestore                        │
│  ├── firebase_analytics                     │
│  ├── firebase_messaging                     │
│  ├── firebase_remote_config                 │
│  └── firebase_crashlytics                   │
└─────────────────────────────────────────────┘
```

## Design Principles

### Document-Driven Development (DDD)
- All interfaces and behaviors are defined in `docs/` before implementation
- Documents serve as the contract; code is the implementation

### Single Source of Truth (SSOT)
- **Data**: Firestore is the sole source of truth for business data
- **State**: Each Riverpod Provider is the sole source for its state domain
- **Style**: M3 Theme is the sole source for all UI styling — no hardcoded colors or fonts
- **Events**: `analytics_events.dart` is the sole source for all analytics event definitions
- **Config**: Firebase Remote Config is the sole source for dynamic configuration

### Dependency Flow
```
Screens → Providers → Services → Firebase SDK
```
- Screens only read from Providers (never call Services directly)
- Providers orchestrate Services and expose reactive state
- Services encapsulate all Firebase SDK interactions
