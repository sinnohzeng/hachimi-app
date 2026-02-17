# Firebase Setup Guide

## Prerequisites
- Google account
- Firebase CLI installed: `curl -sL https://firebase.tools | bash`
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name: `hachimi-app`
4. Enable Google Analytics (select default account)
5. Wait for project creation

## Step 2: Configure Flutter App
```bash
# Login to Firebase
firebase login

# Configure Flutter project (generates firebase_options.dart)
flutterfire configure --project=hachimi-app
```
This will:
- Register Android and iOS apps in Firebase
- Download config files (google-services.json, GoogleService-Info.plist)
- Generate `lib/firebase_options.dart`

## Step 3: Enable Firebase Services

### Authentication
1. Firebase Console → Authentication → Get Started
2. Enable "Email/Password" sign-in provider

### Firestore
1. Firebase Console → Firestore Database → Create Database
2. Start in **test mode** (for development)
3. Choose nearest region (asia-east1 for Shanghai)

### Analytics
- Enabled by default when project has Google Analytics
- DebugView: enable on device with `adb shell setprop debug.firebase.analytics.app com.example.hachimi_app`

### Cloud Messaging (FCM)
- Enabled by default, no additional setup needed

### Remote Config
1. Firebase Console → Remote Config → Create configuration
2. Add parameters (see remote-config.md)

### Crashlytics
1. Firebase Console → Crashlytics → Enable
2. Force a test crash to verify: `FirebaseCrashlytics.instance.crash()`

## Step 4: Firestore Security Rules
See [security-rules.md](security-rules.md) for the rules to deploy.

```bash
firebase deploy --only firestore:rules
```
