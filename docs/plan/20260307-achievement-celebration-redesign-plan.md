# Achievement System Redesign — Celebration Popup + List Page

**Created**: 2026-03-07
**Status**: In Progress

## Summary

Redesign the achievement celebration overlay and list page with:
- Part A: Premium full-screen celebration with tiered ceremony, 100% opaque background, choreographed haptics
- Part B: Upgraded achievement list page with tier-aware visual hierarchy

## Key Changes

### Part A — Celebration Popup
- File decomposition: 1 file (541L) → 6 focused files in `lib/widgets/celebration/`
- Fix: 100% opaque background (was 92-96% alpha)
- 3-tier celebration system: Standard / Notable / Epic
- 3-phase staggered entrance + exit animation
- Haptic scarcity: Standard=none, Notable=mediumImpact, Epic=3-beat vibration
- Multi-shape confetti (5 shapes, staggered birth)
- OverlayPortal migration from MaterialApp.builder Stack

### Part B — Achievement List Page
- Circle icon containers with tier accent stripe
- Animated progress ring on summary card
- Larger icon (64px) and tier chip in detail sheet

## Files

| Action | File |
|--------|------|
| Create | `lib/widgets/celebration/celebration_tier.dart` |
| Create | `lib/widgets/celebration/celebration_confetti_painter.dart` |
| Create | `lib/widgets/celebration/celebration_glow_icon.dart` |
| Create | `lib/widgets/celebration/celebration_reward_badges.dart` |
| Create | `lib/widgets/celebration/celebration_overlay.dart` |
| Create | `lib/widgets/celebration/achievement_celebration_layer.dart` |
| Create | `test/widgets/celebration/celebration_tier_test.dart` |
| Edit | `lib/core/theme/app_motion.dart` |
| Edit | `lib/app.dart` |
| Delete | `lib/widgets/achievement_celebration_overlay.dart` |
| Edit | Achievement list page files (4 files) |
| Edit | L10N ARB files (5 languages, +3 keys) |
