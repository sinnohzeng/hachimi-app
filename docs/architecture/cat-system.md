# Cat System — Game Design SSOT

> **SSOT**: This document is the single source of truth for all cat game mechanics. The implementation in `lib/core/constants/cat_constants.dart` must match this specification exactly.

---

## Overview

The cat system is the emotional core of Hachimi. It transforms abstract habit tracking into a nurturing experience: every habit you maintain grows a unique virtual companion. The system is designed to:

1. **Reward consistency** — XP, level-ups, and mood improvements are earned through regular focus sessions
2. **Create attachment** — unique breeds, personalities, and names make each cat feel personal
3. **Visualize progress** — cat evolution provides clear, emotionally resonant feedback for habit streaks
4. **Scale with ambition** — up to 10 active cats in the room; unlimited in the cat album

---

## Breeds

There are **10 breeds**, each with a rarity weight and color palette used for sprite tinting.

| Breed ID | Display Name | Rarity | Weight | Base Color | Accent Color |
|----------|-------------|--------|--------|-----------|-------------|
| `orange_tabby` | Orange Tabby | common | 20 | `#FF8C00` | `#FFA500` |
| `grey_shorthair` | Grey Shorthair | common | 18 | `#808080` | `#A9A9A9` |
| `white_persian` | White Persian | common | 16 | `#FFFAFA` | `#E8E8E8` |
| `black_cat` | Black Cat | uncommon | 12 | `#2D2D2D` | `#4A4A4A` |
| `calico` | Calico | uncommon | 10 | `#E8A87C` | `#F4C2A1` |
| `siamese` | Siamese | uncommon | 10 | `#C8A882` | `#B8926A` |
| `tuxedo` | Tuxedo | uncommon | 8 | `#1C1C1C` | `#FFFFFF` |
| `bengal` | Bengal | rare | 3 | `#C68E4A` | `#D4A254` |
| `russian_blue` | Russian Blue | rare | 2 | `#7A9BB5` | `#8FAFC7` |
| `golden_tabby` | Golden Tabby | rare | 1 | `#DAA520` | `#FFD700` |

**Total weight: 100.** Draft selection is weighted-random; at least 1 breed in each draft should be new (not previously owned) when possible.

### Patterns (3 per breed, 30 total)

Each breed has 3 patterns. Patterns are cosmetic only — no gameplay effect:

```
classic_stripe, spotted, solid
```

Pattern is assigned randomly at adoption with equal probability.

---

## Personalities

There are **6 personalities**, each affecting:
- Room slot preferences
- Speech bubble messages
- Idle animation key (future feature)

| Personality ID | Display Name | Emoji | Preferred Slots | Flavor Text |
|----------------|-------------|-------|----------------|-------------|
| `lazy` | Lazy | 😴 | sofa, bed | "Shhh... just five more minutes..." |
| `curious` | Curious | 🔍 | shelf, windowsill | "What's out there today?" |
| `playful` | Playful | 🎮 | rug, desk | "Let's play! Let's play! Let's play!" |
| `shy` | Shy | 🙈 | corner, box | "Oh! I didn't see you there..." |
| `brave` | Brave | 🦁 | door, chair | "I'll guard this spot!" |
| `clingy` | Clingy | 🤗 | food_bowl, rug | "Don't leave me! Stay here!" |

Personalities are assigned randomly at adoption.

---

## Growth Stages

Cats evolve through **4 stages** based on cumulative XP:

| Stage | ID | Name | Emoji | XP Threshold | Description |
|-------|----|------|-------|-------------|-------------|
| 1 | `kitten` | Kitten | 🐱 | 0 XP | Newborn, tiny, full of potential |
| 2 | `young` | Young | 🐈 | 100 XP | Growing fast, more expressive |
| 3 | `adult` | Adult | 🐈‍⬛ | 300 XP | Fully formed, confident |
| 4 | `shiny` | Shiny | ✨🐈 | 600 XP | Rare evolved form, golden glow effect |

**Stage calculation** is derived from `xp` at read time — it is not stored separately in Firestore (to prevent drift). The computed getter `cat.computedStage` always returns the authoritative stage.

**Stage progress** (used for XP progress bars):
```
progress = (xp - currentStageThreshold) / (nextStageThreshold - currentStageThreshold)
```
At max stage (Shiny), progress is always `1.0`.

---

## Mood System

Cat mood is computed from `lastSessionAt` (the timestamp of the most recent focus session). It is **not stored** in Firestore (it's recomputed on read to always reflect current reality).

| Mood ID | Name | Emoji | Condition | Behavior |
|---------|------|-------|-----------|----------|
| `happy` | Happy | 😸 | Last session < 24 hours ago | Default display; cat is lively |
| `neutral` | Neutral | 😐 | Last session 1–3 days ago | Slightly subdued |
| `lonely` | Lonely | 😿 | Last session 3–7 days ago | Sad sprite; worried speech |
| `missing` | Missing | 💔 | Last session > 7 days ago | Very sad; triggers win-back notification |

> The `mood_threshold_lonely_days` Remote Config key (default: 3) controls the lonely threshold in days.

**Mood affects:**
- Cat sprite selection (happy/neutral/sad pose variant)
- Speech bubble text content
- Cat room atmosphere (dormant cats appear faded)

---

## Speech Bubble Messages

Speech messages follow a `personality:mood` matrix. Each combination has 1–3 message variants; the current implementation returns one message per combination.

| | `happy` | `neutral` | `lonely` | `missing` |
|--|---------|-----------|---------|---------|
| `lazy` | "Purrrfect day for a nap..." | "Hmm, I suppose I'm okay." | "I miss our lazy days together..." | "Where have you been? My spot is cold..." |
| `curious` | "I discovered something amazing today!" | "Things are... okay I guess." | "I wonder where you've been exploring..." | "Have you forgotten our adventures?" |
| `playful` | "Can we play?! Can we?!" | "I've been waiting to play..." | "No one to play with is so sad..." | "Please come back and play with me..." |
| `shy` | "Oh! You're here! *blushes*" | "I've been waiting quietly..." | "I was worried you forgot about me..." | "I miss you so much it hurts..." |
| `brave` | "I've been guarding everything!" | "Still on patrol." | "The house feels empty without you." | "I've been so brave waiting for you..." |
| `clingy` | "Don't go! Stay with me!" | "I need more cuddles..." | "Please don't leave me alone..." | "I've been counting every second..." |

---

## XP System

XP is earned at the end of each focus session. All calculations are in `XpService` (pure Dart, no Firebase dependency).

### XP Formula

```
totalXp = baseXp + streakBonus + milestoneBonus + fullHouseBonus
```

| Component | Formula | Condition |
|-----------|---------|-----------|
| `baseXp` | `minutes × 1` | Always |
| `streakBonus` | `+5` per session | `currentStreak >= 3` |
| `milestoneBonus` | `+30` one-time | Streak reaches 7, 14, or 30 days |
| `fullHouseBonus` | `+10` per session | All habits completed today |

The XP multiplier from Remote Config (`xp_multiplier`, default `1.0`) scales `totalXp` for promotional events.

### Abandoned Sessions

Sessions ended early (Give Up) still earn XP if the user focused for **≥ 5 minutes**:
- XP = `focusedMinutes × 1` (base only; no streak or bonus XP)
- The session is marked `completed: false` in Firestore

---

## Room Slot System

The Cat Room has **11 named slots**, each with a (x%, y%) coordinate in the room scene:

| Slot ID | Display | X% | Y% | Natural Occupants |
|---------|---------|----|----|------------------|
| `sofa` | Sofa | 0.68 | 0.42 | lazy, clingy |
| `windowsill` | Window | 0.65 | 0.12 | curious, brave |
| `rug` | Rug | 0.45 | 0.62 | playful, clingy |
| `desk` | Desk | 0.20 | 0.30 | playful, curious |
| `shelf` | Bookshelf | 0.12 | 0.18 | curious, shy |
| `food_bowl` | Food Bowl | 0.08 | 0.75 | clingy, lazy |
| `door` | Door | 0.85 | 0.55 | brave |
| `chair` | Chair | 0.35 | 0.40 | brave, shy |
| `bed` | Bed | 0.15 | 0.60 | lazy |
| `corner` | Corner | 0.05 | 0.85 | shy |
| `box` | Box | 0.55 | 0.80 | shy, playful |

**Slot assignment algorithm:**
1. Collect personality's preferred slots from `CatPersonality.preferredRoomSlots`
2. Filter to open (unoccupied) slots
3. If no preferred slot is open, fall back to any open slot
4. If all slots are taken (>11 cats active), overflow cats are hidden (shown in "See all" album)

The slot is **stored** in Firestore as `roomSlot` (String?) on the Cat document. It is assigned at adoption and may be updated when cats are repositioned.

---

## Cat Generation (Draft Algorithm)

The `CatGenerationService.generateDraft()` method produces 3 candidate cats for the adoption flow:

```
generateDraft(userOwnedBreeds, boundHabitId) → List<Cat> (length = 3)
```

**Algorithm:**
1. Build weighted breed pool from `catBreeds` (rarity weights sum to 100)
2. Select 3 breeds via weighted-random draw **without replacement** (no duplicates in a single draft)
3. If user owns all available breeds, skip uniqueness requirement; otherwise guarantee at least 1 breed the user hasn't owned
4. For each breed: assign random pattern (equal probability), random personality (equal probability), compute rarity from breed, generate random name from `catNames` pool
5. Return 3 `Cat` objects with `state: 'active'`, `xp: 0`, `stage: 1`, `mood: 'happy'`, no `id` (assigned by Firestore on creation)

---

## Cat States

| State | Meaning | Visibility |
|-------|---------|-----------|
| `active` | Bound to an active habit; appears in Cat Room | Full color |
| `dormant` | Habit was deactivated; cat is resting | Slightly faded |
| `graduated` | Habit was deleted; cat moved to album permanently | Greyed out, frozen stats |

State transitions:
- `active` → `dormant`: habit marked inactive
- `active` → `graduated`: habit deleted (`deleteHabit` in FirestoreService)
- `dormant` → `active`: habit reactivated (future feature)

---

## Cat Album

The Cat Album (`allCatsProvider` — includes all states) displays:
- **Active** cats: full color, clickable to Cat Room position
- **Dormant** cats: 70% opacity
- **Graduated** cats: 50% opacity, "Graduated" label

Cats are sorted by `createdAt` descending (most recently adopted first).
