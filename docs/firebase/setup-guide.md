# Firebase Setup Guide

This guide walks through setting up Firebase for the Hachimi app from scratch. Follow steps 1–6 in order.

---

## Prerequisites

| Tool | Install |
|------|---------|
| Flutter 3.41.x | `flutter upgrade` |
| Firebase CLI | `npm install -g firebase-tools` |
| FlutterFire CLI | `dart pub global activate flutterfire_cli` |
| JDK 17 (Android) | `brew install openjdk@17` (macOS) |

Verify tools:
```bash
flutter --version     # Flutter 3.41.x
firebase --version    # 13.x+
flutterfire --version # 1.x+
java -version         # openjdk 17
```

---

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Project name: `hachimi-ai` (or your chosen name)
4. **Enable Google Analytics** — select your Analytics account (or create one)
5. Wait for project creation to finish

---

## Step 2: Configure Flutter App

```bash
# Authenticate with Firebase
firebase login

# Configure Flutter project for your Firebase project
# This registers Android + iOS apps and generates config files
flutterfire configure --project=hachimi-ai
```

This command:
- Registers an Android app (`com.hachimi.hachimi_app`) and an iOS app in Firebase
- Downloads `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`
- Generates `lib/firebase_options.dart`

> **These files are gitignored** — never commit them. Each developer must run `flutterfire configure` with their own Firebase project.

---

## Step 3: Enable Authentication

1. Firebase Console → **Authentication** → Get Started
2. **Sign-in method** tab → Enable:
   - **Email/Password** — toggle on
   - **Google** — toggle on, enter your support email, save

---

## Step 4: Create Firestore Database

1. Firebase Console → **Firestore Database** → Create database
2. Start in **production mode** (we'll deploy rules in Step 6)
3. Choose nearest region:
   - Asia: `asia-east1` (Taiwan) or `asia-northeast1` (Tokyo)
   - North America: `us-central1`
   - Europe: `europe-west1`

> Note: Region cannot be changed after creation. Choose once.

---

## Step 5: Enable Remaining Services

### Firebase Analytics
- Automatically enabled if you connected Google Analytics in Step 1.
- Enable **DebugView** on device:
  ```bash
  adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
  ```

### Firebase Cloud Messaging (FCM)
- Enabled by default — no additional setup needed for Android.
- iOS requires APNs certificate upload (future work).

### Remote Config
1. Firebase Console → **Remote Config** → Create configuration
2. Add the 4 required parameters (see [remote-config.md](remote-config.md)):
   - `xp_multiplier` = `1`
   - `notification_copy_variant` = `A`
   - `mood_threshold_lonely_days` = `3`
   - `default_focus_duration` = `25`
3. Click **Publish changes**

### Crashlytics
1. Firebase Console → **Crashlytics** → Get started
2. Enable Crashlytics (no additional SDK setup needed — already in `pubspec.yaml`)
3. Run the app and force a test crash to verify:
   ```dart
   // In a debug build only
   FirebaseCrashlytics.instance.crash();
   ```
4. Confirm the crash appears in the Crashlytics dashboard within a few minutes

---

## Step 6: Deploy Firestore Security Rules

```bash
# From project root — deploys rules from firestore.rules
firebase deploy --only firestore:rules
```

Verify rules are active: Firebase Console → Firestore → **Rules** tab.

See [security-rules.md](security-rules.md) for the full rule specification and rationale.

---

## Step 7: Run the App

```bash
# Standard run on a connected device or emulator
flutter run

# If USB install fails with INSTALL_FAILED_ABORTED (vivo/some Android devices):
flutter build apk
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

---

## Troubleshooting

### `google-services.json not found`
Run `flutterfire configure` again. The file is gitignored and must be regenerated per machine.

### `PigeonFirebaseApp` or plugin crash on startup
Ensure `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` is called in `main()` before `runApp()`.

### Analytics events not appearing in DebugView
1. Confirm DebugView is enabled: `adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app`
2. Restart the app after running the adb command
3. Events may take 30–60 seconds to appear

### Foreground service notification not showing
Ensure `POST_NOTIFICATIONS` permission is granted on Android 13+. The app requests this on first timer start.

### Remote Config returning default values
The first fetch may be cached for up to 12 hours. In development, force an immediate fetch:
```bash
# Clear app data to reset Remote Config cache
adb shell pm clear com.hachimi.hachimi_app
```
