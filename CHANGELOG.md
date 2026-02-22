# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
