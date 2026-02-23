# Screen Specifications

> Screen-by-screen UI specifications. Each screen section references the implementing file, describes the layout structure, key interactions, and analytics events fired.

---

## Navigation Overview

```
OnboardingScreen (first launch only)
    ↓
LoginScreen
    ↓ (authenticated + habits exist)
HomeScreen ─ 4-tab NavigationBar shell ─┬─ Today Tab
                                         ├─ Cat Room Tab → CatRoomScreen
                                         ├─ Stats Tab → StatsScreen
                                         └─ Profile Tab → ProfileScreen

HomeScreen → FocusSetupScreen → TimerScreen → FocusCompleteScreen
HomeScreen → AdoptionFlowScreen (FAB or first habit)
CatRoomScreen → CatDetailScreen (via bottom sheet)
ProfileScreen → CatDetailScreen (via Cat Album)
```

---

## S1: Onboarding Screen
**File:** `lib/screens/onboarding/onboarding_screen.dart`

### Layout
- Full-screen `PageView` with 3 pages
- Each page: centered emoji (96pt), bold headline, subtitle body text
- Page 1: 🐱 "Welcome to Hachimi" / "Raise cats. Build habits. One focus session at a time."
- Page 2: ⏱️ "Focus & Earn XP" / "Every minute counts. Your cat grows stronger with every session."
- Page 3: ✨ "Watch Them Evolve" / "From kitten to shiny — your cat's journey mirrors your own."
- Bottom: `SmoothPageIndicator` dots + "Get Started" `FilledButton` (visible on last page only)

### Behavior
- Swipe left/right to advance
- "Get Started" → navigate to `LoginScreen`
- On completion, `SharedPreferences.setBool('onboarding_complete', true)`
- Never shown again after completion

---

## S2: Login Screen
**File:** `lib/screens/auth/login_screen.dart`

### Layout
- Centered `Column` with top cat emoji 🐱 + app name "Hachimi" headline
- Tagline: "Raise cats. Build habits."
- Email `TextField` + Password `TextField` (with obscure toggle)
- "Sign in" `FilledButton`
- "Continue with Google" `OutlinedButton` with Google logo
- Toggle: "Don't have an account? Register" `TextButton`

### Register Mode
- Same layout; button changes to "Create account"
- Password field shows strength hint

### Analytics Events
- `sign_up` (method: `"email"` or `"google"`) on successful registration

---

## S3: Home Screen (4-Tab Shell)
**File:** `lib/screens/home/home_screen.dart`

### Navigation
4-destination `NavigationBar` at bottom:
1. **Today** (home icon) — habit list + featured cat
2. **Cat Room** (pets icon) — illustrated room scene
3. **Stats** (bar_chart icon) — activity + progress
4. **Profile** (person icon) — settings + cat album

### Today Tab

**Featured Cat Card** (top of scroll) — 3-line header + progress row:
- Row 1 (header): Cat sprite (56px) + right column with 3 lines:
  - Line 1: Cat name (`titleMedium`, bold)
  - Line 2: Quest name (`bodySmall`, maxLines: 2)
  - Line 3: Note/memo (`bodySmall`, italic, maxLines: 2, only shown when non-empty)
- Row 2 (progress): Growth progress bar + hours/stage label + "Focus" `FilledButton.tonal`
- Gradient background tinted by cat's growth stage color

**Habit List** (below featured card):
- Each row: mini `CatSprite` (~40px) | habit name | today's progress bar | "Start" button
- "Start" → FocusSetupScreen(habitId)
- Today's progress bar fills as minutes accumulate vs `goalMinutes`

**Empty State** (no habits):
- Cat illustration placeholder + "Adopt your first cat!" text + "Get Started" FilledButton → AdoptionFlowScreen

**FAB:** `FloatingActionButton.extended` — "New Habit" → AdoptionFlowScreen

### Analytics Events
- `cat_room_viewed` fires when Cat Room tab is selected

---

## S4: Adoption Flow Screen (3-Step Habit Creation)
**File:** `lib/screens/habits/adoption_flow_screen.dart`

### Step 1 — Define Quest
- AppBar with title + back button
- Progress indicator (step 1 of 3)
- **Basic Info** section header:
  - Quest name `TextFormField` (required, prefixIcon: edit_outlined)
  - Note/memo `TextFormField` (maxLength: 240, maxLines: 4, minLines: 2, with random-fill refresh button)
- **Goals** section header:
  - Hint text explaining growth ladder
  - Mode toggle: `_ModeOption` cards (Unlimited / Milestone)
  - [Milestone] Target hours chips `[50h] [100h] [200h] [500h] [Custom]` + deadline date picker
  - Daily goal chips `[15min] [25min] [40min] [60min] [Custom]`
- **Reminder** section header:
  - Reminder list (up to 5) with delete buttons + "Add reminder" button → `showReminderPickerSheet`
- **Growth Path** card (always fully expanded, no collapse) — shows 4-stage growth ladder + research tip
- "Next" `FilledButton` (validates name is non-empty)

### Step 2 — Adopt Your Cat
- "A kitten is waiting for you!" headline
- 3 `CatPreviewCard` widgets side by side
- Each card: sprite placeholder + breed name + personality badge + flavor text
- Tap to select (unselected cards dim to 40% opacity with animation)
- "Next" `FilledButton` (validates a cat is selected)

### Step 3 — Name Your Cat
- Selected cat shown large (center)
- "What will you name them?" label
- Cat name `TextField` pre-filled with random name from `catNames` pool
- "Adopt" `FilledButton` → batch write → navigate to Home
- Confetti animation on adoption success

### Analytics Events
- `cat_adopted` (breed, pattern, personality, rarity, is_first_habit) on step 3 completion

---

## S5: Focus Setup Screen
**File:** `lib/screens/timer/focus_setup_screen.dart`

### Layout
- Habit name + streak badge at top
- `CatSprite` (large, ~160px) with idle animation
- Duration chip selector: `[15] [25] [40] [60] [Custom]` — default from habit `goalMinutes`
- Mode toggle: `SegmentedButton` — "Countdown ⏳" / "Stopwatch ⏱️"
- "Start Focus" `FilledButton.extended`

### Behavior
- "Custom" chip opens a number-input dialog
- Selected duration remembered within session (not persisted)
- "Start Focus" → navigate to TimerScreen(habitId, totalSeconds, mode)

### Analytics Events
- `focus_session_started` (habit_id, timer_mode, target_minutes)

---

## S6: Timer Screen (Focus In Progress)
**File:** `lib/screens/timer/timer_screen.dart`

### Layout
- Full-screen with soft gradient (breed color → dark)
- Top bar: habit name + current streak (fire badge + number)
- Center: `CatSprite` inside circular progress ring (`ProgressRing` widget)
- Progress ring: fills (stopwatch) or drains (countdown) over session
- Large timer display (`displayLarge` text style): `MM:SS` or `HH:MM:SS`
- Bottom: "Give Up" `TextButton` (subtle, bottom-left corner)

### Behavior
- Timer starts immediately on screen load
- Android foreground service keeps timer alive when minimized
- Persistent notification: cat emoji + habit name + remaining/elapsed time
- "Give Up": long-press (600ms) to confirm — prevents accidents
- AppLifecycle handling:
  - Background < 15s: continue normally
  - Background 15s–5min: auto-pause
  - Background > 5min: auto-end (save session up to backgrounding point)

### On Timer Complete (countdown hits 0)
- Success sound / haptic
- Navigate to FocusCompleteScreen

---

## S7: Focus Complete Screen
**File:** `lib/screens/timer/focus_complete_screen.dart`

### Layout
- `CatSprite` (large) with bounce/celebration animation
- "+{xp} XP" floating text animates upward from cat
- If stage evolved: `AnimatedSwitcher` shows new stage sprite with glow
- "Full House!" banner if all habits done today
- Stats summary card:
  - Focus duration
  - XP earned
  - Current streak (fire badge)
  - Total cat XP
- "Done" `FilledButton` → navigate back to HomeScreen

### Analytics Events
- `focus_session_completed` (habit_id, actual_minutes, xp_earned, streak_days)
- `cat_level_up` (cat_id, new_stage, total_xp) — if applicable
- `streak_achieved` (streak_days, habit_id) — if milestone reached
- `all_habits_done` (habit_count, total_bonus_xp) — if full house

---

## S8: Cat Room Screen
**File:** `lib/screens/cat_room/cat_room_screen.dart`

### Layout
- Full-screen `Stack`
- **Layer 1**: Room background image (day: 6:00–19:59, night: 20:00–5:59)
- **Layer 2**: `Positioned` cat sprites at slot coordinates from `catRoomSlots`
- **Layer 3**: Speech bubble overlay (shown on tap)

### Cat Tap Interaction
1. Speech bubble appears (personality × mood message) for 3 seconds
2. Bottom sheet slides up (ModalBottomSheet):
   - Cat name + breed + personality
   - "Start Focus" → FocusSetupScreen
   - "View Details" → CatDetailScreen

### Overflow
- If > 10 active cats: a "See all {n} cats →" button opens the full Cat Album

### Analytics Events
- `cat_room_viewed` (cat_count) on screen mount
- `cat_tapped` (cat_id, action) on each interaction

---

## S9: Cat Detail Screen
**File:** `lib/screens/cat_detail/cat_detail_screen.dart`

### Layout (scrollable)
1. **Hero section**: Large `CatSprite` (centered, ~180px) + stage label + shine effect for Shiny stage
2. **Identity card**: Cat name | breed | rarity chip | personality badge + emoji
3. **XP Progress card**: Current XP / next stage threshold + `LinearProgressIndicator` + "Stage X → Stage Y" labels
4. **Focus Stats card**: Quest name + note + 2-column stats grid + "Edit" + "Start Focus" buttons
5. **Reminder card**: Reminder list with add/remove actions
6. **Activity Heatmap card**: `StreakHeatmap` widget — 91-day GitHub-style grid with stats row

### Edit Quest (Full-Screen Page)
**File:** `lib/screens/cat_detail/components/edit_quest_sheet.dart`

Navigated via `Navigator.push` from the "Edit" button in Focus Stats card. Layout is unified with AdoptionFlowScreen Step 1:

- `Scaffold` + `AppBar` (title: edit quest, back button)
- **Basic Info** section: Quest name + Note/memo (multiline)
- **Goals** section: Mode toggle (`_ModeOption` cards) + target hours + deadline + daily goal
- **Reminder** section: Reminder list with add/remove (persisted on save)
- **Growth Path** card (always fully expanded)
- Bottom: fixed-position "Save" `FilledButton`

### Analytics Events
- No custom events (navigated from Cat Room or Profile — parent screens already track)

---

## S10: Stats Screen
**File:** `lib/screens/stats/stats_screen.dart`

### Layout (scrollable)
1. **Today's Summary row**: Total minutes today | cat count | active streak count
2. **Per-habit section**: Each habit shows:
   - Emoji icon + name
   - `LinearProgressIndicator` for today's progress (minutes / goalMinutes)
   - Hours logged / targetHours (cumulative)
   - Streak fire badge
3. (Future) 91-day heatmap for overall activity

---

## S11: Profile Screen
**File:** `lib/screens/profile/profile_screen.dart`

### Layout (scrollable)
1. **Your Journey card**: Total focus time (formatted as "Xh Ym") | Total cats | Best streak
2. **Rarity Breakdown row**: Common (n) | Uncommon (n) | Rare (n) chips
3. **Cat Album section**: 3-column grid preview of first 6 cats + "View all {n} →" button
4. **Account section**: Display name + email
5. **Settings**: Notification preferences (future) | Sign out button

### Full Cat Album Modal
- `DraggableScrollableSheet` with full-screen cat grid
- All cats (active + dormant + graduated), sorted by `createdAt` descending
- Active: full color. Dormant: 70% opacity. Graduated: 50% opacity + "Graduated" badge
- Tap any cat → CatDetailScreen

---

## Empty States

| Screen | Trigger | Message |
|--------|---------|---------|
| Today Tab | No habits | "Adopt your first cat!" + CTA |
| Cat Room | No active cats | "You don't have any cats yet. Create a habit to adopt one." |
| Stats Screen | No habits | "Track your first focus session to see stats." |
| Cat Album | No cats | "Your album is empty — start adopting!" |
