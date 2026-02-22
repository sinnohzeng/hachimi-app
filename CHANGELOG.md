# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
