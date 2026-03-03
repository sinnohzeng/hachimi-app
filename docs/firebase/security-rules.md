# Firestore Security Rules

## Rule Model
- Deny-by-default.
- User data namespace: `users/{uid}` only.
- Access allowed only when `request.auth.uid == uid`.

## Active Subcollections
- `habits`
- `habits/{habitId}/sessions`
- `cats`
- `achievements`
- `monthlyCheckIns`

## Removed Legacy Paths
- `checkIns` and nested `entries` are removed from active rules.

## Deployment
```bash
firebase deploy --only firestore:rules
```

## Validation Checklist
- Authenticated user can CRUD own `users/{uid}` subtree (with per-collection constraints).
- User cannot access another user's namespace.
- Account deletion via Cloud Functions succeeds without `permission-denied`.
- Guest local deletion (`guest_*`) does not invoke Firestore deletes.
