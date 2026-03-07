---
level: 1
file_id: plan_01
status: pending
created: 2026-03-07 10:00
children: [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q]
estimated_time: 360min
---

# AI Always-On Refactoring — Complete Architecture Plan

## Context

AI features (cat diary + chat) migrated from MiniMax API keys to Firebase AI Logic (Vertex AI, gemini-2.5-flash). The AI toggle defaults to `false`, making features invisible. Feature broken for all users.

**Goal:** AI always-on, remove settings, 5-msg/cat/day limit, lazy validation, diary retry, token analytics, Cloud Function cost monitor, network resilience, type safety, structured logging.

**Principles:** DDD (docs updated alongside code), SSOT, code quality hard limits, CODEX-ready quality.

---

## Critical Architecture Gaps

### 1. No Network Timeout (CRITICAL)
`FirebaseAiProvider` has zero timeout. No-network = spinner hangs indefinitely.
**Fix:** `AiRequestConfig.timeout` — chat: 15s, diary: 20s, validation: 5s. Idle-token timeout for streaming: 10s.

### 2. Type Safety Violations (5 instances)
`dynamic` used for `Cat`/`Habit` in 3 files. Fix to proper types.

### 3. No Circuit Breaker
Repeated failures hammer the API. **Fix:** Failure counter + 5-min backoff after 3 consecutive failures.

### 4. No Offline Indicator
AI cards disappear silently. **Fix:** `_AiOfflineBanner` for authenticated users.

### 5. Missing Tests
No test coverage for new features. **Fix:** 4 test files specified.

---

## UX Journey Map — Network Edge Cases

| User Journey | No Network Behavior |
|---|---|
| App boot | OK — Firebase offline, core works |
| Focus timer | OK — fully local |
| Focus complete -> diary | FIXED: 20s timeout -> graceful fail + retry queue |
| Cat detail -> diary card | OK — local SQLite read |
| Cat detail -> chat | FIXED: 15s timeout -> error message |
| Cat detail -> AI cards | FIXED: show _AiOfflineBanner instead of nothing |
| Lazy validation | FIXED: 5s timeout -> error state |
| RemoteConfig fetch | OK — DeferredInit try-catch, uses defaults |

---

## Work Streams (A-Q)

### A. Delete AI Settings UI
DELETE `ai_settings_page.dart` + `model_test_chat_screen.dart`

### B. Remove Routes
Remove `aiSettings`, `modelTestChat` from `app_router.dart`

### C. Simplify AI State Machine
Remove `AiFeatureNotifier`, 2-state `AiAvailability`, remove toggle checks

### D. Clean Settings Screen
Remove "AI Model" section, fix StaggeredListItem indices

### E. Update CatDetailScreen Gating
Guest -> teaser | aiReady -> diary+chat | else -> _AiOfflineBanner. Fix _AiTeaserCard anti-pattern.

### F. Chat Daily Limit (5/cat/day)
Database -> Service (defense-in-depth) -> Provider -> UI -> Analytics -> L10N

### G. Clean Constants
Remove dead prefs/TestPrompt, add chatDailyLimit

### H. Structured Logging
diary_service, focus_complete, chat_service — `[ServiceName] operation (key=value)`

### I. Dead L10N Key Cleanup
Remove ~25 dead keys, add 3 new keys

### J. SSOT Document Updates (EN + zh-CN)
state-management.md + cat-system.md

### K. Lazy Validation + Circuit Breaker
Optimistic `ready`, async validate, 3-failure backoff (5 min)

### L. Diary Retry Queue
SharedPreferences JSON, max 3 attempts, 1-day expiry

### M. Token Usage Analytics
GA4 `ai_token_usage` event from DiaryService/ChatService

### N. Cloud Function: AI Usage Monitor
`monitorAiUsageV1` daily, BigQuery -> Firestore `admin/ai_usage_daily`

### O. RemoteConfig Initialization
DeferredInit + ChatService reads `chat_daily_limit` from RemoteConfig

### P. Network Timeout Protection
`AiRequestConfig.timeout`, `.timeout()` wrapper in FirebaseAiProvider, streaming idle-token timeout

### Q. Type Safety Fixes
5 `dynamic` -> proper `Cat`/`Habit` types across 3 files

---

## Test Coverage

| Test File | Coverage |
|---|---|
| `test/providers/ai_provider_test.dart` | Lazy validation, circuit breaker, 2-state transitions |
| `test/services/chat_service_test.dart` | getRemainingMessages boundary: 0/4/5/next-day-reset |
| `test/services/diary_service_test.dart` | Retry save/process/max-attempts/expiry |
| `test/services/local_database_test.dart` | getTodayUserMessageCount date boundary |

## Execution Order
```
A -> B -> G -> P -> C+K -> Q -> D -> E -> O -> F -> L -> M -> H -> I -> J -> N
-> Tests -> dart analyze + dart format
```

## Verification
1. `dart analyze lib/` — zero errors
2. `flutter test` — all tests pass
3. `flutter build apk --debug`
4. Device: settings (no AI), cat detail (lazy validate -> cards), offline (banner + timeout), chat (5-limit), diary (retry on failure)
5. Analytics: DebugView for `ai_token_usage`, `ai_chat_limit_reached`
6. Cloud Function: `cd functions && npm run build`
