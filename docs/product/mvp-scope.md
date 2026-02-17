# MVP Scope Definition

## In Scope

| Feature | Priority | Day |
|---------|----------|-----|
| Email auth (login/register) | Must | 1 |
| Create/delete habits | Must | 1-2 |
| Daily check-in with timer | Must | 2 |
| Manual time entry | Must | 2 |
| Progress bar (hours vs target) | Must | 2 |
| Streak counter | Must | 2 |
| Firebase Analytics (6+ events) | Must | 2 |
| Material Design 3 UI | Must | 1-3 |
| FCM push notification | Should | 3 |
| Remote Config A/B test | Should | 3 |
| Crashlytics | Should | 3 |
| Calendar heatmap | Should | 3 |
| Complete docs/ | Must | 1,3 |

## Out of Scope

| Feature | Reason |
|---------|--------|
| Social/sharing | Not needed for interview demo |
| Multi-language | MVP is single-language |
| Dark mode toggle | M3 supports it but adds scope |
| App Store submission | Not required |
| Unit/widget tests | Not required for demo |
| Offline support | Firebase handles basic caching |
| Data export | Not core to interview narrative |

## Definition of Done

The MVP is complete when:
1. A user can register, create a habit, start a timer, check in, and see progress
2. Firebase Console shows real analytics events in DebugView
3. All docs/ are written and consistent with implementation
4. UI uses M3 components with no hardcoded styles
