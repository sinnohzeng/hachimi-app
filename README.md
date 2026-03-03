# Hachimi

Cat-focused habit app built with Flutter + Firebase, with offline-first data flow.

## Highlights
- Offline-first runtime: local SQLite ledger/materialized state as SSOT.
- Guest-to-account upgrade with archive conflict comparison and explicit keep-local/keep-cloud choice.
- Account deletion redesign: summary + `DELETE` confirmation + local-first wipe + queued cloud hard delete.
- Firebase Cloud Functions callable hard-delete API:
  - `deleteAccountV1`
  - `wipeUserDataV1`
- Quality gate for `lib/` hand-written code:
  - file <= 800 lines
  - function <= 30 lines
  - nesting <= 3
  - branches <= 3

## Tech Stack
- Flutter 3.41.x / Dart 3.11.x
- Riverpod 3.x
- Firebase Auth + Firestore + Cloud Functions
- Firebase Analytics + Crashlytics
- sqflite + SharedPreferences

## Quick Start
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

## License
Copyright (c) 2025–2026 Zixuan Zeng. All Rights Reserved.
