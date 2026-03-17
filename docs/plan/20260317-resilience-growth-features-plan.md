# Resilience Growth Features — Inspired by "Light Up Inner Universe"

**Created**: 2026-03-17
**Status**: Pending

## Context

Inspired by analysis of the *Dedao Podcast* episode featuring Professor Zhang Xiaomeng's product **"点亮内心宇宙：韧性成长手册"** (Light Up Inner Universe: Resilience Growth Handbook). The product implements scientifically validated psychological resilience mechanisms:

1. **Seligman Positive Psychology Intervention (Three Good Things)**: Daily recording of one positive event. 6-month study results: +5% happiness index, −20% depression index. The neural mechanism is training the brain to actively search for positive signals, counteracting the evolutionary "negativity bias".

2. **James Clear's Four Laws of Habit Formation**: Obvious → Attractive → Easy → Rewarding. Habits are not built through willpower but through intelligent system design.

3. **Emotional Externalization (Worry Processor)**: Writing worries down "offloads" them from working memory, reducing cognitive load and triggering active problem-solving.

**Gap Analysis vs. Hachimi Current State**:

| Dimension | Hachimi Today | Resilience Handbook | Gap |
|-----------|--------------|---------------------|-----|
| Daily positive emotion tracking | Cat AI diary (cat's perspective) | User-written "Today's Light" | **No user subjective writing** |
| Weekly review/reflection | None | 3 happy moments + gratitude + learning | **Completely missing** |
| Emotional offloading | None | Worry Processor | **Completely missing** |
| Habit design guidance | Name/duration/goal only | Four Laws design walkthrough | **No design-thinking guidance** |
| Joy pattern insights | None | "What truly makes me happy" review | **Completely missing** |
| Monthly planning | None | Monthly challenge list + calendar | **Missing month dimension** |

Hachimi's "reward" dimension (coins, achievements, cat growth) is already excellent. The critical missing pieces are **user subjective emotion writing** and **reflection closure loops** — the core of resilience growth.

---

## Module A: "Today's Light" — Daily Positive Moment ⭐ Highest Priority

**Design rationale**: Each day before sleep, record "one point of light" in one sentence. Minimum friction (one sentence required), but accumulated entries build self-awareness data.

**Integration points**:
- After focus session completion (`focus_complete_screen.dart`): optional card "What made you happy today?"
- Home Today Tab: "Today's Light" entry card (shown once per day if not yet filled)
- Optional evening reminder (configurable)

**New model**: `DailyMoment`
```
DailyMoment {
  uid: String
  date: String (YYYY-MM-DD)
  content: String (max 200 chars)
  emoji: String? (optional positive mood emoji)
  createdAt: DateTime
}
```

**UI**: Minimal input + optional 5-emoji positive mood selector. Displayed alongside Cat AI diary (user perspective card + cat perspective card).

**Firestore**: `users/{uid}/dailyMoments/{date}`
**SQLite**: `local_daily_moments (date, content, emoji, synced_at)`

---

## Module B: "Weekly Pulse" — Structured Weekly Review ⭐ High Priority

**Design rationale**: Every Sunday evening, surface a weekly review card with 3 guided questions:
1. Three happy moments this week
2. Who I want to thank this week
3. What I learned this week

**Integration points**:
- Home screen top banner every Sunday (disappears on Monday)
- Shows weekly stats snapshot (focus minutes, streak days)

**New model**: `WeeklyReview`
```
WeeklyReview {
  uid: String
  weekId: String (YYYY-WNN, ISO week number)
  happyMoments: List<String> (max 3)
  gratitude: String?
  learned: String?
  focusMinutes: int (snapshot)
  streakDays: int (snapshot)
  createdAt: DateTime
}
```

**Firestore**: `users/{uid}/weeklyReviews/{weekId}`
**SQLite**: `local_weekly_reviews (week_id, content_json, synced_at)`

---

## Module C: "Worry Processor" — Emotional Offload Tool ⭐ Medium Priority

**Design rationale**: Write a worry, note a potential solution, track resolution status. Core value: "externalization" — offloading anxiety from working memory to the app.

**Three statuses**:
- 🌱 Dissolved on its own
- ✅ I solved it
- ⏳ Still in progress

**Integration points**:
- Standalone entry (from Profile / Settings menu)
- Optional "Any concerns?" prompt at end of habit creation flow
- Weekly review card shows this-week worry count + resolved count

**New model**: `Worry`
```
Worry {
  uid: String
  id: String
  content: String
  solution: String?
  status: 'active' | 'dissolved' | 'solved'
  createdAt: DateTime
  resolvedAt: DateTime?
}
```

**Firestore**: `users/{uid}/worries/{worryId}`
**SQLite**: `local_worries (worry_id, content, solution, status, created_at, resolved_at, synced_at)`

---

## Module D: "Habit Designer" — Four Laws Onboarding ⭐ Medium Priority

**Design rationale**: Optional step at end of habit creation flow (`adoption_flow_screen.dart`) guiding users to think through their habit using the Four Laws.

**Four guided questions** (skippable):
1. **Obvious**: "What will you put in a visible place to remind yourself?"
2. **Attractive**: "What context naturally makes you want to do this?"
3. **Easy**: "What's the smallest 1-minute starting version?"
4. **Rewarding**: "What small reward will you give yourself after completing it?"

**Storage**: Optional field extension on `Habit` model (`habitDesignNotes: Map<String, String>?`)

---

## Module E: "Joy Map" — AI Pattern Insights ⭐ Low Priority (Requires Data Accumulation)

**Design rationale**: After 30+ "Today's Light" entries, AI analyzes patterns and generates one insight sentence: "You record moments with family most often, followed by the sense of mastery from learning new skills."

**Technical path**:
- Trigger: `DailyMoment` count ≥ 30
- AI Provider: reuse existing `AiProvider` interface
- Display: "Growth Insight" card on cat detail screen (alongside AI diary)
- Refresh: At most once every 7 days

---

## Files

### New Files

| Action | File |
|--------|------|
| Create | `lib/models/daily_moment.dart` |
| Create | `lib/models/weekly_review.dart` |
| Create | `lib/models/worry.dart` |
| Create | `lib/screens/reflection/daily_moment_screen.dart` |
| Create | `lib/screens/reflection/weekly_review_screen.dart` |
| Create | `lib/screens/reflection/worry_list_screen.dart` |
| Create | `lib/screens/reflection/worry_detail_screen.dart` |

### Modified Files

| Action | File | Change |
|--------|------|--------|
| Edit | `lib/screens/focus_complete_screen.dart` | Add "Today's Light" optional card |
| Edit | `lib/screens/home/today_tab.dart` | Add reflection entry card |
| Edit | `lib/screens/adoption_flow_screen.dart` | Add optional Four Laws step |
| Edit | `lib/screens/cat_detail/cat_detail_screen.dart` | Add "Joy Map" insight card (Module E) |
| Edit | `lib/core/router/app_router.dart` | Add 4 new routes |
| Edit | `lib/l10n/app_en.arb` | Add new localization keys |
| Edit | `lib/l10n/app_zh.arb` | Add new localization keys |

### SSOT Documents to Update (DDD — Before Coding)

| Priority | File | Change |
|----------|------|--------|
| 1 | `docs/architecture/data-model.md` | Add 3 new Firestore collections + SQLite tables |
| 2 | `docs/product/prd.md` | Add Resilience Growth module spec |
| 3 | `docs/architecture/state-management.md` | Declare new providers |
| 4 | `docs/architecture/folder-structure.md` | Add `screens/reflection/` directory |
| 5 | `docs/design/screens.md` | Add new screen layout specs |
| 6 | `docs/firebase/analytics-events.md` | Add new analytics events |
| — | All zh-CN mirrors | Sync Chinese translations |

---

## Phased Release

### Phase 1 — v2.35.0: "Today's Light" + "Weekly Pulse"
Modules A + B. 2 new models, 2 new screens. Changes to focus complete screen + home today tab.

### Phase 2 — v2.36.0: "Worry Processor" + "Habit Designer"
Modules C + D. 1 new model, 2 new screens. Changes to habit adoption flow.

### Phase 3 — v2.37.0+: "Joy Map"
Module E. Requires data accumulation from Phase 1. AI prompt engineering needed.

---

## Verification

### Module A
1. Complete a focus session → completion page shows "Today's Light" optional card
2. Enter content → cat detail page shows both Cat AI Diary + user's Today's Light side by side
3. Verify Firestore: `users/{uid}/dailyMoments/{date}` document created

### Module B
1. Open app on Sunday → Home screen shows "Weekly Pulse" banner at top
2. Fill in 3 questions and submit → data persisted locally + cloud
3. Open app on Monday → banner gone (only shown on Sunday)

### Module C
1. Enter Worry Processor → create a worry entry
2. Mark as "I solved it" → status updates, resolved count shown
3. Weekly review card shows this-week worry stats

### Module D
1. Adopt new cat (create habit) → final step shows optional "Habit Design" section
2. Skip → habit created normally
3. Fill in → data saved to `Habit.habitDesignNotes`
