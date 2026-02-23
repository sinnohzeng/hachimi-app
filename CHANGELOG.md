# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
