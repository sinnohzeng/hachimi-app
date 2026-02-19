# Cat System — Game Design SSOT

> **SSOT**: This document is the single source of truth for all cat game mechanics. The implementation in `lib/core/constants/cat_constants.dart` and `lib/core/constants/pixel_cat_constants.dart` must match this specification exactly.

---

## Overview

The cat system is the emotional core of Hachimi. It transforms abstract habit tracking into a nurturing experience: every habit you maintain grows a unique virtual companion. The system is designed to:

1. **Reward consistency** — growth stages and mood improvements are earned through regular focus sessions
2. **Create attachment** — pixel-art appearance, personalities, and names make each cat feel personal
3. **Visualize progress** — cat evolution provides clear, emotionally resonant feedback for habit streaks
4. **Scale with ambition** — unlimited cats displayed in a 2-column CatHouse grid; unlimited in the cat album

---

## Appearance Parameter System

Cat appearance is generated using the **pixel-cat-maker** parameter system. Each cat's look is defined by a set of appearance parameters stored as a `Map<String, dynamic>` in Firestore. These parameters are immutable after adoption — they define the cat's visual identity for life.

### Appearance Parameters

| Parameter | Type | Description | Example Values |
|-----------|------|-------------|----------------|
| `peltType` | String | Base fur pattern type | `"tabby"`, `"solid"`, `"ticked"`, `"mackerel"` |
| `peltColor` | String | Primary fur color | `"orange"`, `"black"`, `"cream"`, `"grey"` |
| `eyeColor` | String | Eye color | `"green"`, `"blue"`, `"amber"`, `"copper"` |
| `skinColor` | String | Nose and inner ear color | `"pink"`, `"darkBrown"`, `"black"` |
| `whitePatches` | String? | White patch distribution pattern | `"chest"`, `"tuxedo"`, `"mittens"`, `null` |
| `points` | String? | Color-point pattern (Siamese-like) | `"seal"`, `"blue"`, `null` |
| `vitiligo` | bool | Whether the cat has vitiligo patches | `true`, `false` |
| `tortieBases` | String? | Tortoiseshell base (if applicable) | `"tortie"`, `"calico"`, `null` |
| `tortiePatterns` | String? | Tortoiseshell pattern variant | `"classic"`, `"mackerel"`, `null` |
| `tortieColors` | String? | Tortoiseshell secondary color | `"ginger"`, `"cream"`, `null` |
| `isLonghair` | bool | Long or short fur | `true`, `false` |
| `reverse` | bool | Whether to mirror the sprite horizontally | `true`, `false` |
| `spriteVariant` | int | Sprite sheet variant index | `0`, `1`, `2` |
| `tint` | String? | Overall color tint overlay | `"warm"`, `"cool"`, `null` |
| `whitePatchesTint` | String? | Tint applied to white patches | `"cream"`, `"ivory"`, `null` |

All parameters are stored in the `appearance` field of the cat Firestore document and passed to the `PixelCatRenderer` for sprite composition.

---

## Personalities

There are **6 personalities**, each affecting:
- Speech bubble messages
- Idle animation key (future feature)

| Personality ID | Display Name | Emoji | Flavor Text |
|----------------|-------------|-------|-------------|
| `lazy` | Lazy | 😴 | "Shhh... just five more minutes..." |
| `curious` | Curious | 🔍 | "What's out there today?" |
| `playful` | Playful | 🎮 | "Let's play! Let's play! Let's play!" |
| `shy` | Shy | 🙈 | "Oh! I didn't see you there..." |
| `brave` | Brave | 🦁 | "I'll guard this spot!" |
| `clingy` | Clingy | 🤗 | "Don't leave me! Stay here!" |

Personalities are assigned randomly at adoption.

---

## Growth Stages

Cats evolve through **4 stages** based on the percentage of `totalMinutes` against `targetMinutes` (the cumulative minute goal derived from the habit's `targetHours`):

| Stage | ID | Name | Emoji | Condition | Description |
|-------|----|------|-------|-----------|-------------|
| 1 | `kitten` | Kitten | 🐱 | progress < 20% | Newborn, tiny, full of potential |
| 2 | `adolescent` | Adolescent | 🐈 | 20% <= progress < 45% | Growing fast, more expressive |
| 3 | `adult` | Adult | 🐈‍⬛ | 45% <= progress < 75% | Fully formed, confident |
| 4 | `senior` | Senior | 🎓🐈 | progress >= 75% | Wise elder, distinguished appearance |

**Stage calculation** is derived at read time from `totalMinutes` and `targetMinutes` — it is not stored separately in Firestore (to prevent drift). The computed getter `cat.computedStage` always returns the authoritative stage.

**Progress formula:**
```
progress = totalMinutes / (targetMinutes)
stage = kitten     if progress < 0.20
        adolescent if progress < 0.45
        adult      if progress < 0.75
        senior     if progress >= 0.75
```

**Stage progress** (used for progress bars within a stage):
```
stageProgress = (progress - stageFloor) / (stageCeiling - stageFloor)
```
At max stage (Senior), `stageProgress` scales from 0.75 to 1.0, capped at `1.0`.

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
- CatHouse card atmosphere (dormant cats appear faded)

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
| `baseXp` | `minutes x 1` | Always |
| `streakBonus` | `+5` per session | `currentStreak >= 3` |
| `milestoneBonus` | `+30` one-time | Streak reaches 7, 14, or 30 days |
| `fullHouseBonus` | `+10` per session | All habits completed today |

The XP multiplier from Remote Config (`xp_multiplier`, default `1.0`) scales `totalXp` for promotional events.

### Abandoned Sessions

Sessions ended early (Give Up) still earn XP if the user focused for **>= 5 minutes**:
- XP = `focusedMinutes x 1` (base only; no streak or bonus XP)
- The session is marked `completed: false` in Firestore

---

## Sprite Rendering Pipeline

The `PixelCatRenderer` composites a cat sprite by layering 13 image layers from the `assets/pixel_cat/` directory. Layers are drawn bottom-to-top in the following order:

| Order | Layer | Source Asset Pattern | Conditional |
|-------|-------|---------------------|-------------|
| 1 | Base body | `body/{peltType}_{spriteVariant}.png` | Always |
| 2 | Pelt color overlay | `pelt/{peltColor}.png` | Always |
| 3 | White patches | `white/{whitePatches}.png` | Only if `whitePatches != null` |
| 4 | White patches tint | `white_tint/{whitePatchesTint}.png` | Only if `whitePatchesTint != null` |
| 5 | Points pattern | `points/{points}.png` | Only if `points != null` |
| 6 | Vitiligo | `vitiligo/vitiligo.png` | Only if `vitiligo == true` |
| 7 | Tortie base | `tortie/{tortieBases}.png` | Only if `tortieBases != null` |
| 8 | Tortie pattern | `tortie_pattern/{tortiePatterns}.png` | Only if `tortiePatterns != null` |
| 9 | Tortie color | `tortie_color/{tortieColors}.png` | Only if `tortieColors != null` |
| 10 | Fur length | `fur/{isLonghair ? "long" : "short"}.png` | Always |
| 11 | Eyes | `eyes/{eyeColor}.png` | Always |
| 12 | Skin (nose/ears) | `skin/{skinColor}.png` | Always |
| 13 | Tint overlay | `tint/{tint}.png` | Only if `tint != null` |

After compositing, the sprite is optionally flipped horizontally if `reverse == true`. The final `dart:ui.Image` is cached per `catId` to avoid redundant re-rendering.

---

## Cat Generation

The `PixelCatGenerationService.generateRandomCat()` method produces a single random cat for the adoption flow:

```
generateRandomCat(boundHabitId, targetMinutes) -> Cat
```

**Algorithm:**
1. Generate random appearance parameters by selecting each field independently from valid values defined in `pixel_cat_constants.dart`
2. Assign a random personality (equal probability)
3. Generate a random name from the `catNames` pool
4. Return a single `Cat` object with `state: 'active'`, `totalMinutes: 0`, `targetMinutes: targetMinutes`, no `id` (assigned by Firestore on creation)

**Refresh mechanism:** The adoption screen shows one cat at a time. The user can tap a "refresh" button to re-roll a new random cat as many times as desired before confirming adoption. Each refresh calls `generateRandomCat()` again.

---

## CatHouse Grid

The CatHouse replaces the previous room scene with a **2-column GridView** layout. Each active cat is displayed as a `CatHouseCard` widget containing:

1. The composited pixel-art sprite (from `PixelCatRenderer`)
2. The cat's name
3. The cat's current mood indicator
4. A stage progress bar
5. The bound habit's name

Cards are sorted by `createdAt` descending (most recently adopted first). Tapping a card navigates to `CatDetailScreen`.

Dormant cats appear at 70% opacity. Graduated cats appear at 50% opacity with a "Graduated" label.

---

## Coins & Accessories

### Coin Economy

Coins are earned through **daily check-in**:
- First session of the day awards **+50 coins**
- Only one check-in bonus per calendar day (tracked via `lastCheckInDate` on the user document)

The coin balance is stored as `coins` on the `users/{uid}` document and exposed via `coinBalanceProvider`.

### Accessories

Accessories are cosmetic items that overlay on the cat's sprite. Each accessory costs **150 coins** and is permanently unlocked per cat.

- Purchased accessories are stored in the cat's `accessories` field (a `List<String>` of accessory IDs)
- The accessory layer is drawn on top of layer 13 (tint overlay) in the rendering pipeline
- Accessories are purchased via the `AccessoryShopSection` widget in `CatDetailScreen`

### Check-In Banner

The `CheckInBanner` widget appears on the HomeScreen when the user has not yet earned today's coin bonus. After the user completes their first focus session of the day, the banner updates to show "+50 coins earned!" and the `hasCheckedInTodayProvider` flips to `true`.

---

## Cat States

| State | Meaning | Visibility |
|-------|---------|-----------|
| `active` | Bound to an active habit; appears in CatHouse grid | Full color |
| `dormant` | Habit was deactivated; cat is resting | Slightly faded |
| `graduated` | Habit was deleted; cat moved to album permanently | Greyed out, frozen stats |

State transitions:
- `active` -> `dormant`: habit marked inactive
- `active` -> `graduated`: habit deleted (`deleteHabit` in FirestoreService)
- `dormant` -> `active`: habit reactivated (future feature)

---

## Cat Album

The Cat Album (`allCatsProvider` — includes all states) displays:
- **Active** cats: full color, clickable to CatHouse position
- **Dormant** cats: 70% opacity
- **Graduated** cats: 50% opacity, "Graduated" label

Cats are sorted by `createdAt` descending (most recently adopted first).
