# Hachimi App Privacy Policy

> **Status**: Draft template — requires legal review before publication.
>
> **Last updated**: 2026-02-27

---

## 1. Introduction

Welcome to Hachimi ("we", "our", "us"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the Hachimi mobile application ("App"). Please read this policy carefully. By using the App, you agree to the practices described in this policy.

---

## 2. Information We Collect

### 2.1 Account Information

| Data | When Collected | Purpose |
|------|----------------|---------|
| Email address | Email/password sign-up | Authentication, account recovery |
| Display name | User-provided during registration | Personalization |
| Google account info | Google Sign-In | Authentication |
| Firebase UID | Automatic on sign-up | Internal user identification |

**Guest mode**: You may use the App without creating an account. A local anonymous identifier is generated and stored only on your device.

### 2.2 Habit and Focus Data

| Data | Description |
|------|-------------|
| Habits | Name, daily goal, target hours, deadline, motivation note |
| Focus sessions | Start/end time, duration, pause time, completion status, XP/coins earned |
| Check-in records | Daily check-in dates, monthly summaries |
| Achievements | Unlocked achievement IDs and timestamps |

### 2.3 Cat and Game Data

| Data | Description |
|------|-------------|
| Cat profiles | Name, personality, appearance, growth stage |
| Accessories | Purchased and equipped items |
| Virtual currency | Coin balance and transaction history |

### 2.4 AI Feature Data (Opt-in Only)

When you enable AI features, the following data is sent to our AI providers:

- Cat name, personality, mood, and growth stage
- Habit name, focus minutes, and progress statistics
- Chat messages you send to your virtual cat
- App locale (language preference)

**Important**: AI features are entirely optional. You must explicitly enable them and acknowledge the privacy implications before any data is sent to AI providers.

### 2.5 Device and Usage Data

| Data | Collection Method | Purpose |
|------|-------------------|---------|
| App usage events | Firebase Analytics | Product improvement |
| Crash reports | Firebase Crashlytics | Bug fixing, stability |
| FCM token | Firebase Cloud Messaging | Push notifications |
| Device type, OS version | Automatic | Compatibility |

### 2.6 Local-Only Data

The following data is stored only on your device and never transmitted:

- Theme preferences (color, mode, animations)
- Language preference
- Notification settings
- Timer recovery state
- Offline data cache (SQLite)

---

## 3. How We Use Your Information

We use the information we collect to:

- **Provide core features**: Habit tracking, focus timer, cat-parenting game
- **Sync your data**: Keep your data consistent across sessions via cloud sync
- **Personalize experience**: AI-powered chat and diary generation (opt-in)
- **Send notifications**: Habit reminders, streak alerts, celebration messages
- **Improve the App**: Analyze usage patterns and fix crashes
- **Ensure data integrity**: HMAC-SHA256 checksums on focus session records

We do **not** use your data for:

- Advertising or ad targeting
- Selling to third parties
- Profiling for purposes unrelated to the App

---

## 4. Third-Party Services

We use the following third-party services:

| Service | Provider | Purpose | Privacy Policy |
|---------|----------|---------|----------------|
| Firebase Authentication | Google | User sign-in | [Firebase Privacy](https://firebase.google.com/support/privacy) |
| Cloud Firestore | Google | Data storage and sync | Same as above |
| Firebase Analytics | Google | Usage analytics | Same as above |
| Firebase Crashlytics | Google | Crash reporting | Same as above |
| Firebase Cloud Messaging | Google | Push notifications | Same as above |
| Google Sign-In | Google | OAuth authentication | [Google Privacy](https://policies.google.com/privacy) |
| MiniMax API | MiniMax | AI chat and diary (opt-in) | [MiniMax Privacy](https://www.minimaxi.com/privacy) |
| Google Gemini API | Google | AI chat and diary (opt-in) | [Google AI Privacy](https://ai.google.dev/terms) |

---

## 5. Data Storage and Security

### 5.1 Storage

- **Cloud data**: Stored in Google Cloud (Firebase) infrastructure
- **Local data**: Stored in SQLite database and SharedPreferences on your device
- **AI data**: Processed in real-time by AI providers; we do not store AI conversation logs on our servers

### 5.2 Security Measures

- All network communication uses HTTPS/TLS encryption
- Firestore security rules enforce user-only data access
- Focus session records are signed with HMAC-SHA256 for tamper detection
- Firebase Authentication handles credential security

---

## 6. Data Retention

| Data Type | Retention Period |
|-----------|-----------------|
| Account and habit data | Until account deletion |
| Focus session records | Until account deletion |
| Local cache | Until app uninstall or manual logout |
| Analytics data | Per Google Firebase retention policies (default: 14 months) |
| Crash reports | Per Google Firebase Crashlytics policies (default: 90 days) |

---

## 7. Your Rights

You have the right to:

- **Access your data**: View all your habits, sessions, and achievements in the App
- **Opt out of AI**: Disable AI features at any time in Settings
- **Opt out of analytics**: Disable analytics through your device settings
- **Delete your account**: Use the in-app account deletion feature, which permanently removes:
  - All focus session records
  - All achievement records
  - All cat and habit data
  - Your Firebase Authentication account
- **Use offline mode**: The App functions fully offline; cloud sync is optional

---

## 8. Children's Privacy

The App is not directed at children under the age of 13. We do not knowingly collect personal information from children under 13. If you believe we have inadvertently collected such information, please contact us and we will promptly delete it.

---

## 9. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Last updated" date at the top of this policy. Continued use of the App after changes constitutes acceptance of the updated policy.

---

## 10. Contact Us

If you have questions about this Privacy Policy, please contact us at:

- **Email**: [TODO: Add contact email]
- **GitHub**: [TODO: Add repository URL]

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-27 | Initial draft template created |
