# Firestore Security Rules

> The rules in `firestore.rules` at the project root are the deployed source of truth. This document explains the rule design and the rationale behind each decision.

---

## Design Principles

1. **User isolation**: Every user can only access documents under their own `users/{uid}` path.
2. **No cross-user reads**: There are no shared collections, leaderboards, or social features that would require cross-user access.
3. **Deny by default**: The final wildcard rule (`match /{document=**}`) explicitly denies everything not matched above. This prevents unintended access if new collections are added without corresponding rules.
4. **Auth required**: All `allow` clauses require `request.auth != null`. Unauthenticated (anonymous) access is never allowed.

---

## Current Rules

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only access their own document and subcollections
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Habits subcollection
      match /habits/{habitId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;

        // Focus sessions within a habit
        match /sessions/{sessionId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }

      // Cats subcollection
      match /cats/{catId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      // Check-ins subcollection (date-partitioned)
      match /checkIns/{date} {
        allow read, write: if request.auth != null && request.auth.uid == userId;

        // Entries within a check-in date
        match /entries/{entryId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }

    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Rule Rationale

### Why repeat the auth check on each subcollection?

Firestore rules are **not inherited**. A `match /users/{userId}` rule does not automatically cover `match /users/{userId}/habits/{habitId}`. Each subcollection must have its own explicit rule. The repeated `request.auth.uid == userId` check is the correct pattern for subcollection isolation.

### Why use `allow read, write` instead of granular `create/update/delete`?

For the current product, all operations (create, read, update, delete) are performed by the authenticated owner. Granular rules would add complexity without meaningful security benefit since there are no shared resources or role-based access.

If the product evolves to support social features or admin access, this is where to introduce more specific rules:
```javascript
allow read: if ...;
allow create: if ...;
allow update: if ...;
allow delete: if ...;
```

### Why is the deny-all wildcard at the bottom?

Firestore applies the **most specific matching rule**. The wildcard `/{document=**}` is the least specific, so it only applies to paths not covered by more specific rules above. Placing it last is convention; Firestore would evaluate correctly regardless of order, but bottom placement makes the intent clear to readers.

---

## Deploying Rules

The `firestore.rules` file at the project root is the deployed version. Always edit that file, then deploy:

```bash
# Deploy only Firestore rules (safe; does not affect Functions or other services)
firebase deploy --only firestore:rules
```

Verify deployment in the Firebase Console → Firestore → Rules tab.

---

## Testing Rules

Use the Firestore Rules Simulator in the Firebase Console, or the Firebase Emulator Suite:

```bash
# Start emulator with rules loaded
firebase emulators:start --only firestore

# Run rules unit tests (if test files exist)
npm test
```

**Recommended test cases:**
- Authenticated user reading their own habit: should ALLOW
- Authenticated user reading another user's habit: should DENY
- Unauthenticated read of any document: should DENY
- Authenticated user writing to cats subcollection: should ALLOW
- Authenticated user writing to another user's cats: should DENY

---

## Planned Additions

If future features require new collections, add corresponding rules before deploying:

| Future Feature | New Collection | Rule Pattern |
|---------------|---------------|-------------|
| Social sharing | `publicProfiles/{uid}` | `allow read: if true; allow write: if request.auth.uid == uid;` |
| Push token management | `fcmTokens/{uid}` | Same as user doc pattern |
