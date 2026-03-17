# Hachimi

Cat-focused habit tracking app. Adopt pixel cats, build habits through focused work,
watch them grow. Built with Flutter + Firebase + Material Design 3.

[![CI](https://github.com/sinnohzeng/hachimi-app/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/sinnohzeng/hachimi-app/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/sinnohzeng/hachimi-app)](https://github.com/sinnohzeng/hachimi-app/releases/latest)

## What it does

Each habit you create is paired with a unique pixel cat companion.
Focus sessions grow your cat — from kitten (0 h) through adolescent (20 h) and adult
(100 h) to senior (200 h). An AI generates a daily diary in your cat's voice and enables
in-app chat, all shaped by their personality and mood.

## Architecture Highlights

- **Offline-first**: SQLite action ledger + materialized state as runtime SSOT; Firestore for cloud sync
- **Dual UI**: Material 3 and Retro Pixel (Stardew Valley–inspired) via `ThemeSkin` strategy pattern
- **AI pipeline**: Gemini / MiniMax with circuit breaker, diary retry queue, and per-cat daily chat limits
- **Account lifecycle**: guest-to-account migration with explicit local/cloud conflict resolution
- **Supply-chain hardening**: Sigstore attestation, Workload Identity Federation, deny-by-default CI permissions

## Quality Gates

| Metric | Limit |
| ------ | ----- |
| File size | ≤ 800 lines |
| Function size | ≤ 30 lines |
| Nesting depth | ≤ 3 |
| Branch count | ≤ 5 / function |

## Tech Stack

- Flutter 3.41.x / Dart 3.11.x
- Riverpod 3.x
- Firebase Auth + Firestore + Cloud Functions
- Firebase Analytics + Crashlytics
- sqflite + SharedPreferences

## Quick Start

**Prerequisites:**
- JDK 17 — `brew install openjdk@17` (JDK 21+ breaks Gradle 8.x)
- Android SDK — Android Studio or `commandlinetools`
- Flutter 3.41.x stable channel

```bash
flutter pub get
cd functions && npm install && cd ..
```

Configure Firebase:
```bash
firebase login
flutterfire configure --project <project-id>
```

Deploy backend assets:
```bash
firebase deploy --only firestore:rules,firestore:indexes,functions
```

## Validation

```bash
dart analyze lib test
flutter test --exclude-tags golden
dart run tool/quality_gate.dart
cd functions && npm test
```

## Documentation

- [Docs Index](docs/README.md)
- [Architecture Overview](docs/architecture/overview.md)
- [State Management](docs/architecture/state-management.md)
- [Data Model](docs/architecture/data-model.md)
- [Firebase Setup](docs/firebase/setup-guide.md)
- [Chinese README](README.zh-CN.md)

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## License

Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.
