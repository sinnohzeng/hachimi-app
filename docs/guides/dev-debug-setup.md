# Dev / Debug Environment Setup

> **Purpose:** Step-by-step procedure to start a debug session against a physical Android device.
> **Scope:** Local development on macOS. Test device: vivo V2405A (Android 16, API 36).
> **Status:** Active
> **Evidence:** `CLAUDE.md` commands section, `firestore.rules`, session logs (2026-02-19)
> **Related:** [development-workflow.md](development-workflow.md) · [firebase/security-rules.md](../firebase/security-rules.md) · [release/process.md](../release/process.md)
> **Changelog:** 2026-02-19 — Initial version, capturing lessons from first debug session

---

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Flutter | 3.41.x stable | `flutter --version` |
| Dart | 3.11.x | bundled with Flutter |
| Android SDK | any | at `/opt/homebrew/share/android-commandlinetools` |
| ADB | any | `adb version` |
| Firebase CLI | any | `firebase --version` |
| JDK | OpenJDK 17 | JDK 25 is incompatible with Gradle 8.x |

---

## Step 1 — Connect the Device

1. Enable **USB Debugging** on the vivo device: Settings → Developer Options → USB Debugging.
2. Connect via USB cable.
3. Verify ADB sees the device:

```bash
adb devices
# Expected: <serial>  device
```

If the device shows `unauthorized`, unlock the screen and tap **Allow** on the "Allow USB debugging?" dialog.

---

## Step 2 — Verify Firebase Credentials

Before running the app, make sure Firebase CLI credentials are valid:

```bash
firebase projects:list
```

If you see `Authentication Error: Your credentials are no longer valid`, re-authenticate:

```bash
firebase login --reauth
```

This opens a browser window. Complete Google sign-in and return to the terminal.

> **Why this matters:** Stale credentials only surface when you try to deploy rules or run Firebase commands. It does not affect the Flutter app itself, but you will need valid credentials to fix Firestore rules issues during a debug session.

---

## Step 3 — Start the Debug Session

```bash
flutter run --device-id <adb-serial>
```

Replace `<adb-serial>` with the device serial from `adb devices`.

Flutter will:
1. Resolve Dart dependencies (`flutter pub get`)
2. Run `assembleDebug` via Gradle (~10–15 s on a warm build cache)
3. Install the APK onto the device
4. Connect the Dart VM and print hot-reload key commands

### Expected output on success

```
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
d Detach (terminate "flutter run" but leave application running).
q Quit (terminate the application on the device).

A Dart VM Service on <device> is available at: http://127.0.0.1:<port>/...
```

---

## Troubleshooting: Install Failures

### `INSTALL_FAILED_ABORTED: User rejected permissions`

**Cause:** The vivo system displayed a "Allow installation from computer?" dialog and it was dismissed or timed out.

**Fix:**
1. Unlock the phone screen.
2. Watch for a system dialog asking to allow USB installation — tap **Allow**.
3. Retry:

```bash
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

If the dialog does not appear, disable the package verifier first:

```bash
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

### `flutter run` fails but APK builds fine

Build the APK manually, then install and launch separately:

```bash
flutter build apk --debug
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.hachimi.hachimi_app/.MainActivity
```

---

## Troubleshooting: Runtime Errors

### `[cloud_firestore/permission-denied]` on a specific screen

**Cause:** The screen accesses a Firestore subcollection that has no rule in `firestore.rules`. Firestore denies access silently — the app compiles and runs, but the affected widget throws an exception.

**Diagnosis:** Check the logcat output for a line like:
```
W/Firestore: Listen for Query(target=Query(users/.../COLLECTION_NAME/...)) failed: PERMISSION_DENIED
```

Note the `COLLECTION_NAME`. Open `firestore.rules` and confirm a `match /COLLECTION_NAME/{id}` rule exists under `match /users/{userId}`.

**Fix:**
1. Add the missing rule to `firestore.rules`.
2. Update this document and [firebase/security-rules.md](../firebase/security-rules.md).
3. Deploy:

```bash
firebase deploy --only firestore:rules --project hachimi-ai
```

See [Known Pitfalls in security-rules.md](../firebase/security-rules.md#known-pitfalls) for the full checklist.

### `Firestore UNAVAILABLE` / `Channel shutdownNow` in logcat

**Cause:** A VPN or proxy is disrupting gRPC long-lived connections. This is not a code bug — Firestore auto-reconnects when the network is stable.

**Fix:** Disable VPN/proxy, or wait for Firestore to reconnect automatically.

---

## Normal Logcat Noise (Safe to Ignore)

The following lines appear on every run and are not errors:

| Log tag | Message | Why it's harmless |
|---------|---------|-------------------|
| `SurfaceComposerClient` | `Transaction::setDataspace: 142671872` | Android render pipeline, high frequency |
| `GoogleApiManager` | `Failed to get service from broker` | GMS version mismatch on vivo, does not affect Firebase Auth or Firestore |
| `FlagRegistrar` | `Phenotype.API is not available on this device` | Google feature flags unavailable on this device |
| `ProviderInstaller` | `Failed to load providerinstaller module` | Conscrypt fallback used instead; TLS still works |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-19 | Initial document created; captured vivo install flow and Firestore permission-denied diagnosis |
