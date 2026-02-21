# Variable Naming Conventions

## Dart/Flutter Naming Rules

- **Variables & functions**: `lowerCamelCase` — e.g. `habitName`, `logFocusSession`
- **Classes & enums**: `UpperCamelCase` — e.g. `FocusSession`, `TimerMode`
- **Constants**: `lowerCamelCase` — e.g. `maxCacheSize`, `coinsPerMinute`
- **Files**: `snake_case.dart` — e.g. `focus_timer_service.dart`
- **Private members**: prefix with `_` — e.g. `_db`, `_spritesheetCache`

## Semantic Naming

- Business variables should reflect domain semantics (e.g. `currentStreak`, `totalMinutes`)
- Data structure variables use **type + purpose** naming (e.g. `habitList`, `catMap`)
- Boolean variables use `is`/`has`/`can` prefix (e.g. `isActive`, `hasPermission`)
- Async results suffix with the return type when ambiguous (e.g. `habitsAsync`, `authState`)

## Provider Naming

- Service providers: `<serviceName>Provider` — e.g. `firestoreServiceProvider`
- State providers: `<noun>Provider` — e.g. `habitsProvider`, `catsProvider`
- Family providers: `<noun>Provider(param)` — e.g. `catByIdProvider(catId)`
