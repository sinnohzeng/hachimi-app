# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
