# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.22.0] - 2026-02-27

### Fixed
- **CRITICAL: Achievement evaluation context**: Filled 3 unassigned `AchievementEvalContext` fields (`lastSessionMinutes`, `hasCompletedGoalOnTime`, `hasCompletedGoalAhead`). Achievements `quest_marathon`, `goal_on_time`, and `goal_ahead` can now be unlocked.
- **9 unsafe `cast<String>()`**: Replaced `.cast<String>()` with `.whereType<String>().toList()` across sync, hydration, inventory, and profile providers. Prevents `TypeError` when Firestore returns non-string elements in lists.
- **3 fire-and-forget error swallows**: `UserProfileNotifier` `updateDisplayName/updateAvatar/updateTitle` now log errors via `ErrorHandler.record()` instead of silently ignoring sync failures.
- **Chat service error tracking**: `sendMessage()` catch block now records errors to Crashlytics instead of silently falling back.
- **Titles JSON decode crash**: `_decodeTitles()` in `user_profile_provider.dart` now wrapped in try-catch, returning empty list on malformed data.
- **Ledger deserialization safety**: New `LedgerAction.fromSqliteSafe()` factory with try-catch, used in `getUnsyncedActions()` to skip corrupted rows instead of crashing the sync loop.
- **Migration service sampling**: `checkNeedsMigration()` now samples 50 docs (was 5), reducing false negatives for accounts with many cats.

### Added
- **`SyncConstants` materialization keys**: 7 key constants (`keyCoins`, `keyLastCheckInDate`, `keyInventory`, `keyAvatarId`, `keyDisplayName`, `keyCurrentTitle`, `keyUnlockedTitles`) eliminating magic strings.
- **`ChipSelectorRow` reusable widget**: Shared chip selection UI extracted from `EditQuestSheet` and `AdoptionStep1Form`, removing ~80 lines of duplicated code.
- **Schema version history comments**: `LocalDatabaseService` now documents v1/v2/v3 schema changes inline.
- **Notification error isolation**: Each reminder in `scheduleReminders()` is now wrapped in individual try-catch, preventing one failed schedule from blocking subsequent reminders.

### Changed
- **Achievement evaluator**: 24-case switch replaced with static predicate map + persist fallback (3 branches total).
- **`hydrateFromFirestore()` refactored** (86 → ~10 lines): Extracted `_hydrateCollection()`, `_hydrateUserProfile()`, `_hydrateListField()` helpers with declarative field mapping.
- **`checkIn()` refactored** (120 → orchestrator + 3 helpers): `_loadMonthlyCheckIn()`, `_calculateRewards()`, `_persistCheckIn()`.
- **`getUserDataSummary()` refactored**: Manual for-loop replaced with SQL `COALESCE(SUM())` + `COUNT()` aggregates.
- **`getSessionHistory()` refactored**: Extracted `_buildHistoryQuery()` + `_parseMonthRange()` with month format validation.
- **`scheduleReminders()` split** (71 → 4 methods): `_scheduleByMode()`, `_scheduleDaily()`, `_scheduleWeekdays()`, `_scheduleSpecificDay()`.
- **`firebase_auth_backend.dart`**: Extracted `_getGoogleCredential()` shared by `signInWithGoogle()` and `linkWithGoogle()`.
- **`notification_service.dart`**: Extracted `_androidPlugin` getter eliminating platform-check duplication.
- **`timer_screen.dart`**: Split `_buildRunningButtons()` into `_buildCountdownRunningButton()` + `_buildStopwatchRunningButtons()`. Extracted `_updateHabitAndCatProgress()` from `_persistSession()`.

## [2.21.0] - 2026-02-27

### Fixed
- **P0: CoinService assert → runtime validation**: Replaced 4 `assert` statements (stripped in release mode) with `ArgumentError` throws for coin amount and accessory validation. Prevents silent acceptance of invalid values in production.
- **P0: Date parsing crash protection**: `int.parse()` in `LocalSessionRepository` replaced with `int.tryParse()` + range validation. Invalid dates now return empty results instead of crashing.
- **P0: SyncEngine error reporting**: 6 `debugPrint()` calls replaced with `ErrorHandler.record()` / `ErrorHandler.breadcrumb()` for production-grade error tracking via Crashlytics.
- **Account deletion transaction recovery**: Added SharedPreferences-based deletion progress markers with `resumeIfNeeded()` for automatic recovery if deletion is interrupted mid-process.
- **SyncEngine auto-hydration**: `start()` now calls `_autoHydrateIfNeeded()` to ensure data is pulled from Firestore before sync begins, preventing empty-state sync issues.
- **5 silent error swallows**: Replaced `debugPrint` / `catch(_)` in `AccountDeletionService` with `ErrorHandler.record` for proper error tracking.

### Added
- **Offline-first user profile updates**: Avatar, nickname, and title changes now write to local ledger + materialized_state first, then fire-and-forget sync to Firestore. Profile edits no longer silently lost when offline.
- **SQLite integrity check**: Database initialization now runs `PRAGMA integrity_check`. Corrupted databases are automatically rebuilt with re-hydration flag.
- **MigrationService timeout protection**: Firestore `.get()` calls wrapped with 5-second timeout to prevent migration hangs on poor connections.
- **Sync constants**: New `SyncConstants` class centralizing `syncDebounceInterval` and `syncBatchSize` (previously magic numbers).
- **Privacy policy & terms of service**: Draft templates in `docs/legal/` (EN + zh-CN) covering all data collection, third-party services, and user rights.
- **`totalCheckInDays` documentation**: Added missing field to data-model.md (EN + zh-CN).

### Changed
- **adoption_flow_screen.dart split** (983 → 344 lines): Extracted 3 step components (`AdoptionStep1Form`, `AdoptionStep2CatPreview`, `AdoptionStep3NameCat`).
- **timer_screen.dart refactored**: `build()` reduced from 277 → 45 lines via 6 private builder methods. Fixed `build()` side-effect by moving listener to `ref.listenManual` in `initState`.
- **edit_quest_sheet.dart**: Extracted dialog helpers to `quest_form_dialogs.dart`.
- **_createV2Tables() split** (147 → 8 lines): Orchestrator + 7 table-level methods in `LocalDatabaseService`.
- **purchaseAccessory() split**: Extracted `_executePurchaseTxn()` for cleaner transaction handling.
- **initializePlugins() split**: Extracted `_initNotificationPlugin()` + `_createNotificationChannels()`.
- **AchievementEvaluator refactored**: `_evaluate()` and `_buildContext()` split into 6 sub-methods + 2 private data classes (`_HabitData`, `_CatData`).
- **Riverpod Notifier migration**: 3 `StateNotifier` classes in `ai_provider.dart` migrated to modern `Notifier` pattern. Removed `legacy.dart` import.
- **chat_service.dart**: Magic number `50` replaced with named constant `recentMessagesFetchLimit`.
- **Accessibility improvements**: Removed `visualDensity: VisualDensity.compact` from IconButtons to ensure 48dp touch targets. Added `semanticLabel` to achievement icons, diary/chat chevrons. Wrapped decorative emojis in `ExcludeSemantics`.

## [2.20.0] - 2026-02-27

### Added
- **Multi-backend abstraction layer**: Strategy Pattern abstractions in `lib/core/backend/` (AuthBackend, SyncBackend, UserProfileBackend, AnalyticsBackend, CrashBackend, RemoteConfigBackend) with Firebase implementations in `lib/services/firebase/`. Enables future China (Tencent CloudBase) deployment from a single codebase.
- **BackendRegistry + region providers**: `backendRegionProvider`, `backendRegistryProvider`, and individual backend providers registered in `service_providers.dart`. Region switching UI is architecturally ready.
- **Auth error mapping**: `auth_error_mapper.dart` translates Firebase Auth error codes to localized, user-friendly messages. Added 8 L10N keys across all 5 languages (EN, zh, zh-Hant, ja, ko).
- **User title providers**: `currentTitleProvider` and `unlockedTitlesProvider` read from local materialized_state, completing local-first title management.
- **Logout consolidation**: `UserProfileNotifier.logout()` unifies SyncEngine stop + Auth signOut. Profile and Settings screens share one code path.
- **Title management**: `UserProfileNotifier.updateTitle()` writes to local ledger + fire-and-forget Firestore sync.

### Removed
- **CatFirestoreService** (135 lines): Dead code since local-first migration — zero runtime callers.
- **AchievementService** (193 lines): Entirely replaced by local `AchievementEvaluator` — zero callers.
- **AchievementTriggerHelper** (99 lines): Deprecated wrapper with zero callers.
- **FirestoreService** (590 lines): Legacy monolithic service deleted in prior cleanup.

### Changed
- **UserProfileService**: Refactored from direct Firestore access to delegate via `UserProfileBackend` constructor injection.
- **SyncEngine hydration**: Now pulls `currentTitle` and `unlockedTitles` from Firestore during hydration for pre-migration users.
- **Architecture docs**: Updated all 6 architecture docs (EN + zh-CN) — overview, folder-structure, state-management — to reflect backend abstraction layer, removed deleted services, added new providers.

## [2.19.11] - 2026-02-25

### Fixed
- **Account deletion permission-denied**: Authenticated users deleting their account would hit `permission-denied` on sessions and achievements subcollections. Split Firestore security rules to keep `update: if false` (immutability) while allowing `delete: if isOwner` for account cleanup.
- **Guest "Reset data" incomplete**: Previously only called `signOut()`, leaving SQLite, SharedPreferences, notifications, and timer state as orphaned data. Now properly cleans all local data and (for Firebase anonymous guests) deletes Firestore data and Auth account.

### Added
- **Achievement detail sheet**: Tap any achievement card to view full details — unlock date, reward coins, and description in a bottom sheet.
- **Cat info card**: Extracted cat information display into a reusable `CatInfoCard` component on the cat detail screen.
- **Stage milestone widget**: Reusable `StageMilestone` widget for displaying growth stage progress.

### Changed
- **AccountDeletionService refactored**: Extracted shared Firestore cleanup into `_deleteFirestoreData()`, exposed `cleanLocalData()` as public, added `deleteGuestData()` for guest-specific flow.
- **Achievement card**: Refactored to support tap-to-detail interaction.
- **Cat detail screen**: Decomposed into smaller components (`CatInfoCard`), removed heatmap legend section.
- **Adoption flow & quest edit**: Minor UI adjustments.

## [2.19.10] - 2026-02-25

### Fixed
- **Google sign-in admin-restricted-operation**: Removed `_ensureCurrentUser()` which called `signInAnonymously()` as fallback — fails when anonymous auth is disabled in Firebase Console. Link methods now gracefully degrade: if an anonymous user exists, link credentials; otherwise, sign in directly.
- **Achievement celebration transparent background**: Background gradient Container had no explicit sizing in Stack, causing unreliable rendering. Replaced with `Positioned.fill` + `DecoratedBox` for guaranteed full-screen coverage. Added proper alpha values (0.92/0.96) for near-opaque overlay.
- **Achievement celebration text invisible in light theme**: Text used `onSurface` colors (dark in light theme) against dark gradient background. Changed to white color scale (`Colors.white`, `Colors.white70`, `Colors.white54`) for reliable contrast.
- **Achievement icon invisible**: Glow icon used `colorScheme.primary` which blended into the gradient center. Changed to `Colors.white`.

## [2.19.9] - 2026-02-25

### Fixed
- **Guest Google sign-in stuck**: Guest users completing Google OAuth would see no response — the app silently failed because `_auth.currentUser` was null when anonymous sign-in hadn't finished yet. Added `_ensureCurrentUser()` guard that falls back to anonymous sign-in before credential linking.
- **Email link assertion crash**: `email_auth_screen.dart` linkMode branch used `authService.currentUser!.uid` which could crash; now captures the `linkWithEmail()` return value directly.
- **TOCTOU race in credential linking**: Both `linkWithGoogle()` and `linkWithEmail()` now capture a local `User` reference before the async credential operation, eliminating the check-then-use race condition.

## [2.19.8] - 2026-02-25

### Fixed
- **Guest visibility bug**: Guest users no longer see "Log out" and "Delete account" in Drawer and Settings menus
- **isGuestProvider SSOT**: Replaced `isAnonymousProvider` (which only checked Firebase anonymous auth) with reactive `isGuestProvider` that correctly detects both local guests and Firebase anonymous users
- **Reactivity**: Guest state provider now watches `authStateProvider` stream, automatically re-evaluating when auth state changes (login, link credentials, sign out)

### Removed
- Dead code `isLocalGuestProvider` (defined but never consumed)

## [2.19.7] - 2026-02-25

### Improved
- **Guest drawer redesign**: Replaced passive "Guest / Tap to sign in" header and redundant upgrade banner with a single CTA card featuring shield icon, subtitle, and sign-in button
- **Guest settings account area**: Guest users now see "Sign in" (primary) and "Reset all data" (error) instead of the misleading "Log out" and "Delete account"
- **Reset data confirmation**: Three-action dialog (Cancel / Link account / Reset) with warning icon, replacing the old guest logout flow
- **Drawer cleanup**: Account section (logout) is now hidden entirely for guest users, reducing visual noise

### Removed
- Guest upgrade banner card in drawer (consolidated into header CTA)
- `_confirmGuestLogout` method and 8 associated L10N keys (`drawerGuest`, `drawerGuestTapToLink`, `drawerLinkAccountHint`, `drawerLinkAccount`, `drawerGuestLogout*`)

### Fixed
- Scaffold background color now explicitly uses `colorScheme.surface` for consistency
- Drawer `openDrawer` callback simplified (tear-off instead of lambda)

## [2.19.6] - 2026-02-24

### Improved
- **Drawer navigation**: Drawer close animation now completes before navigating to the next page, eliminating visual interruption
- **Cat name Hero transition**: Cat names no longer flash ellipsis during Hero fly animation between CatHouse and CatDetail
- **Cat name length limit**: All cat name inputs (adoption, rename) now enforce a 20-character maximum
- **Particle overlay fade-in**: Floating particles on cat detail page now fade in after route transition completes, synchronized with mesh background
- **Cat pose persistence**: Tapping a cat to change its pose is now saved to local SQLite and restored on re-entry (DB v3 migration)
- **Achievement celebration full-screen**: Redesigned from a centered card to an immersive full-screen layout with radial gradient background, larger icon (96px), headline text, full-width button, and single-play confetti
- **Cat detail entry animation**: All content cards now use staggered fade+slide animations that wait for route transition to complete before playing, including tablet wide layout

### Changed
- `ParticleOverlay` converted from `ConsumerWidget` to `ConsumerStatefulWidget` with `fadeIn` parameter
- `StaggeredListItem` gains `waitForRoute` parameter to delay animation until route transition completes
- `TappableCatSprite` converted to `ConsumerStatefulWidget` for SQLite persistence via `LocalCatRepository.updateDisplayPose`
- Local database schema upgraded from v2 to v3 (`display_pose` column on `local_cats`)

## [2.19.5] - 2026-02-24

### Improved
- **Focus timer dial**: Duration picker now snaps to 5-minute increments instead of 1-minute, reducing dial clutter and making selection faster
- **Scroll conflict resolved**: Dragging the circular dial no longer causes the page to scroll simultaneously — scroll is disabled while touching the dial and restored on release
- **Cleaner layout**: Removed preset duration chips (5/10/20/30/45/60/90/120) to reduce visual noise; the dial alone provides sufficient control

### Changed
- Default focus duration rounds to nearest 5 minutes (range 5–120)
- `CircularDurationPicker` exposes `onDragStart`/`onDragEnd` callbacks for parent gesture coordination

## [2.19.4] - 2026-02-24

### Fixed
- **Offline-first auth**: First-time install no longer requires network — local guest UID generated synchronously after onboarding, Firebase sign-in moved to non-blocking background task
- **Error screen on first launch**: Removed the "something went wrong" error page that appeared when Firebase anonymous sign-in failed offline; app now enters main screen immediately
- **UID migration**: When Firebase auth completes later, local guest data is atomically migrated to the Firebase UID via `LedgerService.migrateUid`
- **SyncEngine guest guard**: SyncEngine and Firestore hydration skip entirely for local guest UIDs, preventing unnecessary network calls
- **Onboarding back button placement**: Moved back button from bottom bar to top-left corner IconButton for better discoverability and consistent navigation pattern
- **Achievement celebration width collapse**: Added `ConstrainedBox(minWidth: 280, maxWidth: 360)` to prevent card from collapsing on short achievement text

### Changed
- `currentUidProvider` now falls back to `local_guest_uid` in auth error/null states, ensuring all providers have a usable UID even fully offline
- Added `isLocalGuestProvider` for downstream components to check local guest status

## [2.19.3] - 2026-02-24

### Fixed
- **Onboarding navigation crash**: `late final` field in AuthGate was reassigned on "Let's go" tap, causing `LateInitializationError` that permanently blocked users on the onboarding screen
- **Anonymous sign-in failure**: Users stuck on infinite spinner when network unavailable during auto sign-in; now shows error screen with retry button
- **Onboarding async gap**: `_finish()` used raw `SharedPreferences.getInstance()` introducing unnecessary async delay; replaced with synchronous provider access
- **Android back key on onboarding**: No `PopScope` handling caused back key to exit the app; now navigates to previous onboarding page
- **No back navigation in onboarding**: Added back button and `_previous()` method so users can review earlier pages

## [2.19.2] - 2026-02-24

### Fixed
- **Cat rename**: CatDetailScreen and CatRoomScreen now write to local SQLite instead of Firestore, with `cat_update` ledger notification for instant UI refresh
- **Account deletion order**: Firestore cleanup now executes before Auth deletion, preventing `permission-denied` errors on orphaned data cleanup
- **Account deletion data summary**: `getUserDataSummary` reads from local SQLite first, with Firestore fallback
- **Avatar picker**: Writes to local `materialized_state` (SSOT) with best-effort Firestore sync
- **Nickname edit**: Writes to local `materialized_state` alongside Firebase Auth, Firestore becomes best-effort
- **Registration init**: New accounts initialize local `materialized_state` (coins, inventory, check-in date) immediately after profile creation
- **Avatar hydration**: `SyncEngine.hydrateFromFirestore` now pulls `avatarId` and `displayName` into local state
- **Avatar provider**: `avatarIdProvider` reads from local SQLite instead of Firestore Stream

### Changed
- `AchievementService` and `triggerAchievementEvaluation` marked `@Deprecated` — replaced by ledger-driven `AchievementEvaluator`

## [2.19.1] - 2026-02-24

### Fixed
- **Write path migration**: All data-mutating operations (create quest, timer completion, edit quest, reminders, delete, archive) now write to local SQLite instead of Firestore, completing the local-first architecture
- **Firestore hydration**: Existing users' data is automatically pulled from Firestore into SQLite on first launch after upgrade (`SyncEngine.hydrateFromFirestore`)
- **SyncEngine**: `_syncHabit` now reads full habit/cat data from SQLite and pushes to Firestore for `habitCreate` and `habitUpdate` actions
- **Timer rewards**: Focus session completion now correctly updates habit progress, cat progress, and coin balance locally
- **Heatmap data**: Activity heatmap reads from local SQLite sessions instead of Firestore
- **Achievement card overflow**: Grid item height increased from 100 to 116px; progress section spacing tightened to prevent layout overflow on two-line descriptions
- **Drawer button consistency**: CatRoom and Achievement screens now show menu button matching Today tab for consistent M3 navigation

### Added
- `CoinService.earnCoins()` for local coin increment (focus session rewards)
- `LocalSessionRepository.getDailyMinutesForHabit()` for per-habit heatmap queries
- `earnCoins` assertion tests in CoinService test suite

## [2.19.0] - 2026-02-24

### Added
- **Local-first architecture**: Action Ledger (`action_ledger` table) records all data-mutating operations as immutable events; `materialized_state` caches derived aggregates; 7 new SQLite tables mirror Firestore schema as runtime SSOT
- **Guest mode**: Auto anonymous sign-in on first launch; guest upgrade prompt in Drawer; account linking via `linkWithGoogle()` / `linkWithEmail()`
- **Sync Engine**: Background Firestore synchronization with debounced triggers (2s), exponential backoff retry, and 90-day ledger cleanup
- **Achievement Evaluator**: Event-driven achievement evaluation that listens to ledger changes, replacing manual trigger calls across screens
- **App Drawer**: M3 NavigationDrawer with guest upgrade banner, milestone card, session history, settings, and account management
- **AI teaser cards**: ShaderMask blur preview for guest users on CatDetailScreen, encouraging account upgrade
- Guest ID generator (`guest_id_generator.dart`) for secure 10-char short IDs
- `LedgerAction` and `ActionType` models for action ledger events
- `UnlockedAchievement` model for local achievement records
- `LedgerService` for ledger writes, broadcast stream, and materialized state CRUD
- `LocalHabitRepository`, `LocalCatRepository`, `LocalSessionRepository` for SQLite-backed domain CRUD
- `isAnonymousProvider` for guest mode detection across UI
- `newlyUnlockedProvider` for achievement celebration queue
- `syncEngineProvider` for background sync lifecycle management
- Login screen and email auth screen support `linkMode` for guest account linking
- 22 new L10N strings across 5 languages (EN, zh, zh-Hant, ja, ko) for Drawer, guest upgrade, and AI teaser

### Changed
- Navigation restructured: 4 Tab → 3 Tab (Today, CatRoom, Achievement) + Drawer; Profile moved to Drawer
- AuthGate auto-signs-in anonymously instead of showing LoginScreen for unauthenticated users
- `habitsProvider` now reads from `local_habits` SQLite table via `LedgerService.changes` stream
- `catsProvider` now reads from `local_cats` SQLite table via `LedgerService.changes` stream
- `coinBalanceProvider` now reads from `materialized_state` SQLite table
- `CoinService` and `InventoryService` now delegate to `LedgerService` for atomic SQLite transactions
- `LocalDatabaseService` upgraded from DB v1 to v2 with 7 new tables
- Models (`Habit`, `Cat`, `FocusSession`, `MonthlyCheckIn`) now include `toSqlite()` / `fromSqlite()` methods
- Architecture documentation updated across all 8 docs (EN + zh-CN) to reflect local-first architecture

### Removed
- SummaryItem triple from TodayTab (coin/cat/quest counts)
- Direct Firestore dependency for runtime data reads (now via SQLite local tables)

## [2.18.1] - 2026-02-23

### Removed
- Unused `assets/sprites/` and `assets/room/` declarations from pubspec.yaml (legacy placeholders never implemented)
- CI workaround that created empty asset directories during build

## [2.18.0] - 2026-02-23

### Added
- M3 tablet-responsive achievement page: adaptive grid (Feed Layout) and side-by-side stats dashboard (Supporting Pane Layout)
- OverviewTab sub-component extraction: `OverviewStatCard`, `OverviewWeeklyTrend`, `OverviewHeatmapCard`, `OverviewRecentSessions`
- Onboarding tablet layout: side-by-side illustration + content on expanded screens
- Login screen tablet adaptation with centered constrained width (480dp)
- Focus setup screen scrollable layout for tablet compatibility
- Development workflow documentation (EN + zh-CN) covering hot reload, build modes, and debugging
- Gradle build optimizations: parallel builds, build cache, UseParallelGC

### Changed
- Achievement grid uses `SliverGridDelegateWithMaxCrossAxisExtent` for auto-adapting columns (replaces fixed column count)
- OverviewTab: expanded layout shows 4×1 summary cards, side-by-side charts, 2-column habit progress
- Cat room navigation replaced `OpenContainer` with standard `MaterialPageRoute`
- Onboarding copy refreshed across all languages — removed outdated XP/streak references, aligned with cumulative time growth model
- `AchievementCard` margin reduced from 16dp to 8dp to work with grid cross-axis spacing

### Removed
- `ContentWidthConstraint` wrapper from `AchievementScreen` (root cause of tablet layout issues)

## [2.17.0] - 2026-02-23

### Added
- Hero flight animation for cat sprites and names during CatHouse → CatDetail transitions
- Tablet-optimized responsive layouts for CatDetail (2-column) and Achievement (adaptive grid) screens
- `AppIconSize` design token system for consistent icon sizing across the app
- `SegmentedButton` for quest mode selection in adoption and edit flows (replacing custom cards)
- `SharedAxisTransition` for same-level navigation routes (AI Settings, Test Chat, Session History)
- Comprehensive accessibility: `Semantics` labels, `semanticLabel` on icons, tooltips on all `IconButton`s
- `StaggeredListItem` stagger animations extended to Profile, Settings, and CatDetail screens

### Changed
- Onboarding copy refreshed: removed outdated XP/streak references, aligned with cumulative time growth model
- All hardcoded `Colors.*` in UI body areas replaced with `ColorScheme` semantic tokens (8 locations, 6 files)
- Bare `TextStyle()` constructors replaced with `textTheme.*` base styles (migration screen, accessory card)
- Chat bubble `BoxShadow` replaced with `Material(elevation:)` for M3 tonal elevation (2 chat screens)
- Component themes added: `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Dialog` + global `MaterialTapTargetSize.padded`
- Quest mode toggle upgraded from custom `_ModeOption` cards to native M3 `SegmentedButton`
- CatDetail screen refactored with `LayoutBuilder` for phone (single column) and tablet (2-column) layouts
- Achievement grid columns adapt to screen width: 1 (compact), 2 (medium), 3 (expanded)

### Removed
- Custom `_ModeOption` widget class from adoption flow and edit quest sheet (replaced by `SegmentedButton`)

## [2.16.0] - 2026-02-23

### Added
- M3 design token system: `AppShape` (shape scale), `AppElevation` (elevation scale)
- `AppMotion` extended with `durationShimmer` and `durationParticle` special-purpose tokens
- `StaggeredListItem` reusable widget for fade+slide stagger animations on lists and grids
- Container Transform transitions (`OpenContainer`) for cat card → detail and featured card → focus navigation
- Onboarding uses `SharedAxisTransition` (horizontal) for proper M3 step-based flow
- Google Play Store distribution: CI now builds AAB and uploads to internal track via Workload Identity Federation
- `distribution/whatsnew/` for Google Play release notes
- Google Play setup guide (`docs/release/google-play-setup.md`, EN + zh-CN)

### Changed
- All hardcoded `BorderRadius.circular(N)` replaced with `AppShape` tokens across 29 files (49 replacements)
- All hardcoded `Duration(milliseconds:)` and `Curves.*` replaced with `AppMotion` tokens across 12 files
- All `showModalBottomSheet` calls now include `showDragHandle: true` (6 call sites)
- NavigationBar `labelBehavior` changed from `onlyShowSelected` to `alwaysShow` (M3 spec for ≤4 destinations)
- Achievement cards use Outlined Card variant; Profile Journey card uses Filled Card variant
- Profile `_StageChip` refactored to M3 `Chip` widget; `_StatBadge` wrapped with surface container
- `_CatHouseCard` Card wrapper removed — `OpenContainer` provides container styling
- `app_theme.dart` consumes `AppShape` and `AppElevation` tokens for card, dialog, and bottom sheet theming
- CI workflow updated: builds both APK and AAB, reports sizes for both, uploads to Google Play
- Release process docs updated for Google Play dual-channel distribution (EN + zh-CN)
- `auth_service.dart` null-safety improvement for `updateDisplayName`
- `firestore_service.dart` `updateUserProfile` now records errors via `ErrorHandler`

### Removed
- Redundant `Hero` tags on FeaturedCatCard and CatHouseCard (replaced by OpenContainer container transform)
- Manual drag handle bar in `reminder_picker_sheet.dart` (replaced by native `showDragHandle: true`)

## [2.15.0] - 2026-02-23
### Added
- Gemini 3 Flash as second AI provider — user-selectable in AI settings
- AI settings moved to dedicated sub-page with provider selection (MiniMax/Gemini)
- `SseParser` now supports pluggable token extractors via `SseTokenExtractor` typedef
- `AiProviderId` enum and `AiProviderSelectionNotifier` for persistent provider selection
- `.env.example` for local development API key management (`flutter run --dart-define-from-file=.env`)
- New L10N keys for provider selection across all 5 languages

### Changed
- MiniMax model upgraded from M2 to M2.5
- AI settings extracted from Settings main page into `/ai-settings` route (full-screen Scaffold)
- Settings main page now shows AI as a navigation ListTile with status subtitle
- `RadioListTile` migrated to `RadioGroup` pattern (Flutter 3.41 deprecation fix)
- `animated_mesh_background.dart` null-safety fix for `ModalRoute.animation`
- CI workflow updated to inject `GEMINI_API_KEY` secret during release builds

### Removed
- `ai_settings_section.dart` — logic migrated to `ai_settings_page.dart`

## [2.14.0] - 2026-02-23
### Changed
- AI system migrated from local LLM (Qwen-1.7B via llama_cpp_dart) to cloud-based MiniMax API
- Provider-agnostic architecture: abstract `AiProvider` interface with Strategy Pattern for future provider support
- AI availability simplified from 5-state to 3-state model (disabled/ready/error)
- Prompt format migrated from ChatML strings to structured `List<AiMessage>` (OpenAI messages format)
- Settings AI section rewritten: removed model download UI, added cloud badge, connection test, and privacy dialog
- Test chat screen simplified: removed model loading/corruption handling, validates cloud connection directly

### Added
- `AiProvider` abstract interface (`core/ai/`) — supports generate, generateStream, cancel, validateConnection
- `MiniMaxProvider` implementation with SSE streaming, MiniMax-specific error mapping, and dart:io HttpClient
- `SseParser` reusable SSE stream parser for all OpenAI-compatible providers
- `AiService` facade with Completer-based mutex for concurrency control
- Privacy disclosure dialog on first AI enable (persisted via SharedPreferences)
- `AiRequestConfig` with static presets (chat, diary, validation)
- `AiException` typed error hierarchy (network, auth, rate limit, balance, server, cancelled, unconfigured)
- New L10N keys for cloud AI UI across all 5 languages (EN/ZH/ZH-Hant/JA/KO)

### Removed
- `llama_cpp_dart` vendored package and all local model infrastructure
- `background_downloader` dependency (was used for model download)
- `LlmService`, `ModelManagerService`, `llm_constants.dart`, `llm_provider.dart`
- Model download progress UI, pause/resume/cancel buttons, model deletion dialog
- `scripts/setup_llm_vendor.sh` build script

## [2.13.0] - 2026-02-23
### Changed
- Quest creation and editing forms unified — identical field order, section headers, and component styles
- Edit Quest upgraded from bottom sheet to full-screen Scaffold page with AppBar
- Mode toggle in Edit Quest replaced from `SegmentedButton` to `_ModeOption` cards (matching creation flow)
- Note/memo field (formerly "motivation") now supports multiline input (maxLines: 4, minLines: 2)
- GrowthPathCard always fully expanded — removed `ExpansionTile` and `initiallyExpanded` parameter
- GrowthPathCard moved to bottom of form (after reminders) in both creation and editing flows
- Featured cat card on Today page upgraded to 3-line layout: cat name, quest name, and note/memo
- "Motivational quote" renamed to "Note/memo" across all 5 languages (EN/ZH/ZH-Hant/JA/KO)
- Dividers removed from adoption flow Step 1 — replaced with spacing for cleaner visual separation

### Added
- Reminder management in Edit Quest — add/remove reminders with persistence and notification rescheduling
- GrowthPathCard displayed in Edit Quest page (was only in creation flow)

### Fixed
- Documentation sync: `screens.md` and `data-model.md` updated to reflect current implementation (EN + zh-CN)
- `data-model.md` corrected stale `reminderTime` field to `reminders` list, `motivationText` max length 40 → 240

## [2.12.0] - 2026-02-23
### Added
- Multi-reminder system — each quest supports up to 5 independent reminders with 9 scheduling modes (daily, weekdays, individual days)
- Reminder picker bottom sheet with time and mode selection
- 4-step account deletion flow with data summary, DELETE confirmation, Google re-auth, and progress dialog
- Custom daily goal and target hours input dialogs in quest editing
- Motivation quote field expanded to 240 characters
- `ReminderConfig` model with localized descriptions and defensive Firestore parsing
- `AccountDeletionService` with auth-first deletion order (prevents orphaned accounts)
- 48 new L10N keys across 5 languages (EN/ZH/ZH-Hant/JA/KO) for reminders, account deletion, and achievements

### Changed
- Check-in banner redesigned: removed spinner, switched to manual check-in with explicit button
- Featured cat card redesigned with two-row layout
- Adoption flow Step 1 UI simplified — removed Card containers for cleaner look
- Keyboard auto-dismisses on step switch in adoption flow
- Notification text fully localized (was hardcoded English)
- `NotificationService` access unified through provider pattern across all screens and providers
- `NotificationSettingsDialog` converted from `StatefulWidget` to `ConsumerStatefulWidget`
- Notification ID space expanded from `%10000` to `%100000` to reduce collision probability

### Fixed
- Account deletion now deletes Auth account first — if Auth fails, user data is preserved
- 3 `use_build_context_synchronously` warnings resolved with mounted guards
- `_onProgress` callback in deletion dialog hardened with `ctx.mounted` guard
- `_pickDeadlineDate` missing mounted check after `showDatePicker` await
- Malformed Firestore reminder data no longer crashes — `tryFromMap` filters invalid entries

### Removed
- Redundant `_reminderDescription` switch statements in 3 files — consolidated into `ReminderConfig.localizedDescription()`

## [2.11.0] - 2026-02-22
### Changed
- Quest goal system redesigned: quests now support **unlimited mode** (no target, continuous accumulation) and **milestone mode** (target hours + optional deadline)
- Cat growth uses a fixed 4-stage time ladder (0h/20h/100h/200h) independent of quest target — all cats grow at the same pace
- Senior stage re-enabled as the 4th growth stage (200h milestone)
- Quest creation flow redesigned with mode toggle (unlimited/milestone), daily goal, and optional deadline picker
- Quest editing supports switching between unlimited and milestone modes
- Achievement celebration upgraded from SnackBar to full-screen animated overlay with confetti, coin display, and queue system
- Achievement screen reduced from 5 tabs to 4 (streak tab removed)
- Profile page stage breakdown expanded to 4 stages with responsive Wrap layout
- Architecture docs (data-model, cat-system) updated in both EN and zh-CN

### Added
- "Growth Path" card in quest creation flow — shows 4-stage milestones with research-backed tips (Josh Kaufman's 20-hour rule)
- `AchievementCelebrationLayer` — global overlay mounted at app root, supports multi-achievement queue with dismiss/skip-all
- Confetti particle effect and glowing icon animation for achievement celebrations
- 4 new achievements: `hours_100`, `hours_1000`, `goal_on_time`, `goal_ahead` with associated titles
- `deadlineDate` (optional) and `targetCompleted` (auto-conversion flag) fields on Habit model
- `isUnlimited` computed property on Habit model
- Haptic feedback on achievement unlock
- Firestore rules for new habit fields and senior stage validation
- 11 new L10N keys across 5 languages (EN/ZH/ZH-Hant/JA/KO)

### Removed
- **Streak system entirely removed** — `currentStreak`, `bestStreak` fields, `streak_utils.dart`, streak calculation logic, streak XP bonuses
- 8 streak-based achievements (`streak_3` through `streak_365`) and streak achievement category
- `targetMinutes` field from Cat model (replaced by fixed growth ladder)
- `logStreakAchieved()` analytics event
- Old SnackBar-based achievement notification in HomeScreen

## [2.10.0] - 2026-02-22
### Changed
- Cat growth system simplified from 4 stages to 3: kitten (<33%), adolescent (33%–66%), adult (>=66%)
- Equal stage distribution (33/33/34) replaces old uneven thresholds (20/25/30/25)
- Cat detail page shows 3 stage milestones instead of 4
- Profile page shows 3 stage count chips instead of 4
- "Elder Whiskers" achievement renamed to "Master Cat" — now triggers at 100% growth target completion
- LLM prompt stage names updated: 青年猫 (adolescent), 成熟猫 (adult)

### Added
- `highestStage` field on Cat model — prevents visual stage regression when users increase target hours
- `displayStage` computed property — returns the higher of computed stage and stored highest stage
- Legacy data compatibility: cats without `highestStage` use old thresholds to avoid visual regression
- Firestore security rules validation for `highestStage` field
- Atomic `highestStage` update in `logFocusSession` (only increases, never decreases)

### Removed
- Senior stage (was >=75%) — merged into adult stage
- Senior-specific scoring in Featured Cat selection algorithm

## [2.9.1] - 2026-02-22
### Added
- Motivational quote field on quests — set during creation with random locale-aware quotes, editable later
- "New quote" button to randomly swap motivation quotes across 5 languages (en/zh/zh-Hant/ja/ko)
- Motivation quote display on FocusSetupScreen (italic, below cat mood) and FocusStatsCard (single-line)
- Motivation quote editing in EditQuestSheet with clear/swap support

### Changed
- Adoption flow Step 1 refactored from flat list to 3 card-based sections (Basic info / Goals / Reminder)
- Firestore security rules updated to validate `motivationText` field (optional string, max 40 chars)

## [2.9.0] - 2026-02-22
### Added
- Achievement system with 163 achievements across 4 categories: Quest (8), Streak (8), Cat (9), Persist (138)
- Achievement evaluation engine triggered after focus sessions, habit creation, check-in, and accessory equip
- 8 unlockable titles tied to milestone achievements (e.g. Marathon Cat, Centurion, Four Seasons)
- Achievement screen with 5 tabs (Overview, Quest, Streak, Cat, Persist) replacing bottom nav Stats tab
- Achievement cards with progress bars, coin rewards, and unlock status
- Achievement summary header with progress ring showing unlocked/total count
- Title display on profile page with unlocked title count chip
- Bilingual achievement names and descriptions (EN + ZH) via static string maps
- Firestore `achievements/{id}` subcollection for unlock records (immutable, create-only)
- `totalCheckInDays` field on habits for persist achievement tracking
- `totalSessionCount` field on user document for session-based achievements
- Analytics event `achievement_unlocked` with achievement ID parameter
- Firestore security rules for achievements subcollection

### Changed
- Bottom navigation tab 2: Stats icon/label replaced with Achievements (emoji_events)
- Home screen now listens to `newlyUnlockedProvider` and shows unlock celebration SnackBar
- Overview tab extracted from former StatsScreen into reusable component

## [2.8.4] - 2026-02-22
### Fixed
- Focus timer: foreground service notification now dismissed before completion notification, preventing notification overlap
- Focus timer: notification text reordered to show time before habit name, with truncation at 20 characters
- Focus history: added error handling with retry UI when loading fails (was silently swallowed)
- Focus history: added 10-second timeout to cross-habit Firestore queries

### Added
- Focus history: month and habit filter via ActionChip + BottomSheet (replaces horizontal FilterChip list)
- Focus history: month-based date range filtering at Firestore query level for faster loads
- Focus timer: AlarmManager backup notification via `zonedSchedule()` for OS-killed foreground service

### Changed
- Docs: updated focus-completion.md with backup alarm spec and corrected completion flow (EN + zh-CN)

## [2.8.3] - 2026-02-22
### Changed
- Docs: updated design-system.md with unified Theme Color dialog and brightness-aware card theme (EN + zh-CN)
- Docs: updated cat-system.md with navigation vs interaction layer design rule (EN + zh-CN)
- Docs: updated release/process.md with CI monitoring, formatting checklist, and user-facing release body requirements (EN + zh-CN)
- Added .claude/memory/ and .claude/rules/12-workflow-release.md to version control for cross-device sync

## [2.8.2] - 2026-02-22
### Changed
- Settings: merged Material You toggle into Theme Color picker — "Dynamic" wallpaper option + 8 preset colors in a single dialog
- Settings: moved Pixel Cat Sprites CC BY-NC 4.0 attribution into Flutter license registry
- Theme: improved card visibility in dark mode (surfaceContainerHigh + subtle border) and light mode (surfaceContainerLow + elevation)
### Fixed
- Cat gesture conflict: tapping cats in album, home card, and cat room now navigates instead of switching poses
- Cat detail AppBar: replaced hardcoded white foreground with theme-aware colors

## [2.8.1] - 2026-02-22
### Fixed
- Cat detail page: cat sprite and personality text now correctly centered in AppBar
- AnimatedMeshBackground: internally enforces tight constraints, preventing layout drift in loose-constraint contexts

## [2.8.0] - 2026-02-21
### Added
- Redesigned stats page with weekly trend chart (fl_chart), summary cards, and session history with pagination
- Enhanced FocusSession model: status (completed/abandoned/interrupted), completionRatio, coinsEarned, HMAC checksum
- `logStatsViewed()` and `logHistoryViewed()` analytics events
### Fixed
- 13 dark mode brightness-aware color issues across 12+ files

## [2.7.0] - 2026-02-21
### Changed
- Optimized cold startup performance 6-8x via deferred initialization
- Improved cat detail UI layout and responsiveness

## [2.6.0] - 2026-02-21
### Added
- Firebase Crashlytics deep integration with non-fatal error reporting
- Firebase Performance monitoring with custom traces
- Enhanced GA4 analytics coverage across all screens

## [2.5.0] - 2026-02-21
### Fixed
- 11 tech debt issues in focus timer and notification system
- Timer notification action buttons (pause/resume/stop)
- LLM model load failure with corrupted file detection and auto-heal

## [2.4.0] - 2026-02-21
### Added
- Traditional Chinese (zh-Hant), Japanese, and Korean language support
- Fixed 65+ hardcoded strings migrated to ARB l10n

## [2.3.0] - 2026-02-20
### Fixed
- Comprehensive audit: 43 issues fixed across runtime, error handling, i18n, tests, and security
- CI pipeline: SDK licenses, sdkmanager paths, R8 dontwarn rules, NDK pinning, vendor setup ordering

## [2.2.0] - 2026-02-20
### Changed
- Cleanup: removed dead code paths, fixed golden tests for CI
- l10n helpers for CatPersonality display name and flavor text

## [2.0.0] - 2026-02-20
### Added
- Full i18n migration for cat system, appearance descriptions, and LLM prompts
- Bilingual LLM prompt system (EN/ZH)
### Changed
- Comprehensive codebase refactoring: DRY extraction across services and providers
- Expanded test coverage and consolidated duplicate logic

## [1.9.0] - 2026-02-19

### Added

- package_info_plus: runtime version display (no more hardcoding)
- Golden tests for SkeletonLoader, EmptyState, ErrorState
- Stricter lint rules (analysis_options.yaml)
- Pre-commit hook for version/tag consistency
- CHANGELOG.md

### Changed

- AppSpacing applied across all remaining files
- CLAUDE.md: expanded Commands section
- CI: version consistency check step + test step

### Fixed

- Version number in Settings was stuck at 1.8.0 (now reads from system)
- Fixed confetti_widget package name (→ confetti) and upgraded vibration to v3.x
- Fixed avoid_dynamic_calls violations in home_screen, cat_room_screen, pixel_cat_renderer
- Fixed extra argument in _buildAppearanceDetails call (cat_detail_screen)

## [1.8.0] - 2026-02-19

### Added

- Material You (dynamic_color) with settings toggle
- Accessibility: Semantics on all custom widgets
- FadeThrough tab transitions, Hero cat sprites, celebration animations
- SkeletonLoader, EmptyState, ErrorState reusable widgets
- AppSpacing and AppMotion token constants

### Changed

- Replaced hardcoded colors (onboarding, login, coin icon)
- design-system.md rewritten to match actual code

## [1.7.0] - 2026-02-18

### Changed

- Migrated to llama_cpp_dart, upgraded to Riverpod 3.x
