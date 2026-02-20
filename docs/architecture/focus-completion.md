# Focus Completion Experience

> Specification for the post-focus celebration flow: notification, haptic feedback, confetti, and L10N.

**Status:** Active
**Evidence:** `lib/screens/timer/focus_complete_screen.dart`, `lib/screens/timer/timer_screen.dart`, `lib/services/notification_service.dart`
**Related:** [state-management.md](./state-management.md), [cat-system.md](./cat-system.md)

---

## Overview

When a focus session ends (countdown completes or stopwatch "Done" pressed), the app delivers a multi-sensory celebration:

1. **System notification** — appears in the notification tray with XP summary
2. **Haptic feedback** — platform vibration pattern (stronger for completion, lighter for abandon)
3. **Confetti blast** — full-screen particle effect on the celebration page
4. **Animated stats card** — XP breakdown with staggered entrance animations

---

## Completion Flow

```
TimerScreen._saveSession()
  ├── FocusTimerService.stop()          // Stop foreground service
  ├── Calculate XP, coins, stage-up
  ├── Save FocusSession to Firestore
  ├── NotificationService.showFocusComplete()  // System notification (if completed)
  └── Navigator → FocusCompleteScreen
        ├── ConfettiController.play()   // 2s blast (if not abandoned)
        ├── Vibration.vibrate(pattern)  // Strong pattern (or light for abandon)
        ├── Staggered animations        // emoji → content → stats card
        └── DiaryService.generateTodayDiary()  // Fire-and-forget AI diary
```

---

## Notification

| Field | Value |
|-------|-------|
| Channel | `hachimi_focus` (importance HIGH) |
| ID | `300000` (fixed — new notification overwrites old) |
| Title | L10N `focusCompleteNotifTitle` ("Quest complete!") |
| Body | L10N `focusCompleteNotifBody` ("{catName} earned +{xp} XP from {minutes}min of focus") |
| Trigger | Only on successful completion (`isCompleted == true`) |

---

## Haptic Feedback

| Scenario | Pattern |
|----------|---------|
| Completed | `[0, 200, 100, 300]` ms at max intensity (255) |
| Abandoned | Single 100ms vibration at half intensity (128) |

Uses `vibration` package for custom pattern support (replaces `HapticFeedback.heavyImpact()`).

---

## Confetti

Uses `confetti_widget` package. Only plays on successful completion (not abandoned).

| Parameter | Value |
|-----------|-------|
| Duration | 2 seconds |
| Direction | `BlastDirectionality.explosive` (center burst) |
| Particles | 30 |
| Blast force | 8–20 |
| Gravity | 0.1 |
| Colors | `primary`, `tertiary`, `secondary`, `amber`, `pink` |

---

## L10N Keys (ARB)

All hardcoded strings in `focus_complete_screen.dart` are replaced with ARB keys:

| Key | EN | ZH |
|-----|----|----|
| `focusCompleteItsOkay` | It's okay! | 没关系！ |
| `focusCompleteEvolved` | {catName} evolved! | {catName} 进化了！ |
| `focusCompleteFocusedFor` | You focused for {minutes} minutes | 你专注了 {minutes} 分钟 |
| `focusCompleteAbandonedMessage` | {catName} says: "We'll try again!" | {catName} 说："我们下次再来！" |
| `focusCompleteFocusTime` | Focus time | 专注时长 |
| `focusCompleteCoinsEarned` | Coins earned | 获得金币 |
| `focusCompleteBaseXp` | Base XP | 基础 XP |
| `focusCompleteStreakBonus` | Streak bonus | 连续奖励 |
| `focusCompleteMilestoneBonus` | Milestone bonus | 里程碑奖励 |
| `focusCompleteFullHouseBonus` | Full house bonus | 全勤奖励 |
| `focusCompleteTotal` | Total | 总计 |
| `focusCompleteEvolvedTo` | Evolved to {stage}! | 进化到 {stage}！ |
| `focusCompleteDiaryWriting` | Writing diary... | 正在写日记... |
| `focusCompleteDiaryWritten` | Diary written! | 日记已写好！ |
| `focusCompleteNotifTitle` | Quest complete! | 任务完成！ |
| `focusCompleteNotifBody` | {catName} earned +{xp} XP from {minutes}min of focus | {catName} 通过 {minutes} 分钟专注获得了 +{xp} XP |

---

## Changelog

| Date | Change |
|------|--------|
| 2026-02-19 | Initial spec — notification, vibration, confetti, L10N |
