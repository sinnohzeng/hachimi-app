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
| `milestoneBonus` | `+30` one-time | Streak reaches a milestone day (see below) |
| `fullHouseBonus` | `+10` per session | All habits completed today |

**Streak Milestone Constants** (defined in `lib/core/constants/pixel_cat_constants.dart`):
- `streakMilestones = [7, 14, 30]` — the streak day thresholds that trigger a milestone bonus
- `streakMilestoneXpBonus = 30` — XP awarded for each milestone reached

The XP multiplier from Remote Config (`xp_multiplier`, default `1.0`) scales `totalXp` for promotional events.

### Abandoned Sessions

Sessions ended early (Give Up) still earn XP if the user focused for **>= 5 minutes**:
- XP = `focusedMinutes x 1` (base only; no streak or bonus XP)
- The session is marked `completed: false` in Firestore

---

## Pelt Color Background Mapping

The `peltColorToMaterial()` function in `pixel_cat_constants.dart` maps each of the 19 `peltColor` IDs to a soft Material color. This color is used as a 70% weight in the CatDetailScreen header gradient (mixed 30% with the stage color) to give each cat a personalized background.

| Color Group | Pelt Color IDs | Material Color Range |
|-------------|---------------|---------------------|
| White/Grey | WHITE, PALEGREY, SILVER, GREY, DARKGREY, GHOST | #E0E0E0 – #546E7A |
| Black | BLACK | #455A64 (lightened for gradient visibility) |
| Ginger/Cream | CREAM, PALEGINGER, GOLDEN, GINGER, DARKGINGER, SIENNA | #FFE0B2 – #E65100 |
| Brown | LIGHTBROWN, LILAC, BROWN, GOLDEN-BROWN, DARKBROWN, CHOCOLATE | #BCAAA4 – #4E342E |

**Implementation**: `Color peltColorToMaterial(String peltColor)` in `lib/core/constants/pixel_cat_constants.dart`.

---

## TappableCatSprite — Reusable Tap-to-Cycle Widget

**File:** `lib/widgets/tappable_cat_sprite.dart`

`TappableCatSprite` is a reusable `StatefulWidget` that wraps `PixelCatSprite` with tap-to-cycle pose animation and bounce feedback. It is used **everywhere** a cat sprite appears in the app (10+ screens).

**Props:**

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `cat` | `Cat` | required | The cat to display |
| `size` | `double` | required | Sprite display size in logical pixels |
| `enableTap` | `bool` | `true` | Whether tap-to-cycle is enabled |

**Internal State:**
- `_displayVariant` (int?) — local-only pose index, not persisted. Resets when widget is disposed.
- `_bounceController` — `AnimationController` (200ms) for scale bounce animation.

**Behavior:**
- **Tap**: Cycles variant = `(current + 1) % 3`, triggers `HapticFeedback.lightImpact()`, plays bounce
- **Animation**: Scale bounce (0.9x → 1.0x over ~200ms) via `TweenSequence`
- **Sprite**: Calls `computeSpriteIndex(stage, _displayVariant, isLonghair)` with local variant override
- **Build**: `GestureDetector` → `AnimatedBuilder` → `Transform.scale` → `PixelCatSprite`

**Navigation Layer vs Interaction Layer (v2.8.2+):**

Lists and grids are navigation entry points — tapping a cat should navigate to its detail page, not cycle poses. Detail and ambient screens are interaction spaces where pose-cycling is appropriate.

| Context | `enableTap` | Reason |
|---------|-------------|--------|
| Profile cat album | `false` | Navigation entry — tap navigates to detail |
| Home featured cat card | `false` | Navigation entry — tap navigates to detail |
| CatHouse grid card | `false` | Navigation entry — tap navigates to detail |
| Cat detail page | `true` | Interaction space — tap cycles poses |
| Timer screen | `true` | Ambient — tap cycles poses |
| Focus complete screen | `true` | Celebration — tap cycles poses |
| Focus setup screen | `true` | Preview — tap cycles poses |
| Adoption flow | `true` | Preview — tap cycles poses |

**Usage locations (10+ files):**
- `cat_detail_screen.dart` (120px), `featured_cat_card.dart` (72px), `focus_setup_screen.dart` (120px), `timer_screen.dart` (100px), `focus_complete_screen.dart` (120px), `cat_room_screen.dart` (80px), `profile_screen.dart` (48px), `adoption_flow_screen.dart` (preview)

> **Note:** `PixelCatSprite` is retained as the low-level rendering widget. `TappableCatSprite` is the interaction layer wrapper.

---

## Appearance Parameter Human-Readable Descriptions

**File:** `lib/core/utils/appearance_descriptions.dart`

Provides human-readable descriptions for all cat appearance parameters. Used by the Cat Detail Page's enhanced Cat Info Card.

| Function | Input → Output | Example |
|----------|---------------|---------|
| `peltTypeDescription(String)` | Pelt type ID → readable name | `"tabby"` → `"Classic tabby stripes"` |
| `peltColorDescription(String)` | Pelt color ID → readable name | `"GINGER"` → `"Bright ginger"` |
| `eyeDescription(String, String?)` | Eye color + second eye → description | `"BLUE", "GREEN"` → `"Heterochromia (Blue / Green)"` |
| `furLengthDescription(bool)` | isLonghair → readable | `true` → `"Longhair"` |
| `fullSummary(CatAppearance)` | Full appearance → 1-line summary | `"Ginger tabby, golden eyes, longhair"` |

---

## Cat Detail Page Layout

The Cat Detail Page (`CatDetailScreen`) is the **information hub** for a cat and its associated quest. Layout from top to bottom:

```
┌─────────────────────────────────────┐
│ SliverAppBar (280px)                │
│   TappableCatSprite (120px)         │
│   Cat Name + Rename Button          │
│   Personality Badge                 │
├─────────────────────────────────────┤
│ Mood Badge                          │
├─────────────────────────────────────┤
│ Growth Progress Card                │
├─────────────────────────────────────┤
│ Focus Statistics Card               │
│   name + [Edit]                     │
│   2-column stats grid (9 metrics)   │
│   [Start Focus] button              │
├─────────────────────────────────────┤
│ Reminder Card                       │
│   Set / Change / Remove reminder    │
├─────────────────────────────────────┤
│ Activity Heatmap Card               │
├─────────────────────────────────────┤
│ Accessories Card                    │
├─────────────────────────────────────┤
│ Cat Info Card (expandable)          │
│   Personality + flavor text         │
│   1-line appearance summary         │
│   [Expand] full appearance details  │
│   Status + Adopted date             │
└─────────────────────────────────────┘
```

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

Coins are earned through two channels:

1. **Focus Reward**: Every completed focus session awards **+10 coins per minute** of actual focus time. Abandoned sessions with ≥ 5 minutes still earn the per-minute reward; sessions < 5 minutes earn 0 coins.
2. **Daily Check-in (Monthly System)**: Auto-triggered on HomeScreen load. Resets each calendar month. Rewards vary by day type and accumulate toward monthly milestones.

#### Check-In Daily Rewards

| Day Type | Coins |
|----------|-------|
| Weekday (Mon–Fri) | 10 |
| Weekend (Sat–Sun) | 15 |

#### Monthly Milestones

Milestones award a one-time bonus when the cumulative checked days in a month reaches the threshold:

| Milestone | Bonus Coins |
|-----------|-------------|
| 7 days | +30 |
| 14 days | +50 |
| 21 days | +80 |
| Full month (all days) | +150 |

**Maximum monthly check-in income: ~640–660 coins** (daily rewards + all milestones). Focus rewards (10 coins/min) remain the primary coin source.

The coin balance is stored as `coins` on the `users/{uid}` document and exposed via `coinBalanceProvider`. Check-in progress is tracked in `users/{uid}/monthlyCheckIns/{YYYY-MM}` and exposed via `monthlyCheckInProvider`. The per-minute focus rate is defined as `focusRewardCoinsPerMinute` in `pixel_cat_constants.dart`.

### Accessories

Accessories are cosmetic items that overlay on the cat's sprite. Each accessory has a **tiered price** based on rarity, and is permanently added to the user's **inventory** upon purchase. A cat can **equip** one accessory at a time, which renders on its sprite. Accessories can be freely moved between cats via equip/unequip.

#### Tiered Pricing

| Tier | Price (coins) | Days to Earn | Representative Items |
|------|--------------|-------------|---------------------|
| Budget | 50 | 1 | Common plants: Maple Leaf, Holly, Herbs, Clover, Daisy, all Dry series |
| Standard | 100 | 2 | Flowers/berries: Poppies, Bluebells, Snapdragon + plain collars |
| Premium | 150 | 3 | Rare plants: Lavender, Catmint, Juniper, all Bulbs + Bell/Bow collars |
| Rare | 250 | 5 | Wild accessories: feathers, moth/butterfly wings + Nylon collars |
| Legendary | 350 | 7 | Rainbow/Spikes/Multi collars + Lily of the Valley, Oak Leaves, Maple Seed |

Price data is defined in `pixel_cat_constants.dart` via `accessoryPriceMap`.

#### Inventory Model

Accessories use a **user-level inventory** model instead of per-cat storage:

- `users/{uid}.inventory` — `List<String>` of unequipped accessory IDs (the "box")
- Each cat's `equippedAccessory` — the one accessory currently rendered on the cat
- An accessory ID exists in **exactly one place**: either in `inventory` or on one cat's `equippedAccessory`

#### Equip/Unequip

- Each cat has an `equippedAccessory` field (nullable String) — the currently equipped accessory ID
- Only one accessory can be equipped at a time per cat
- Equipping: `InventoryService.equipAccessory()` — removes from inventory, sets on cat (if cat already has one, the old one returns to inventory)
- Unequipping: `InventoryService.unequipAccessory()` — removes from cat, returns to inventory
- The equipped accessory ID flows through the rendering pipeline: `Cat.equippedAccessory` → `PixelCatSprite.accessoryId` → `CatSpriteParams.accessoryId` → `PixelCatRenderer.renderCat(accessoryId:)`
- CatDetailScreen shows an "Accessories" card with equip/unequip controls sourced from `inventoryProvider`

#### Accessory Shop

- Accessed from CatRoomScreen AppBar (storefront icon) → route `/accessory-shop`
- 3 tabs: Plants, Wild, Collars
- Each tab: 3-column grid of `AccessoryCard` widgets
- Purchase flow: tap unowned item → confirm dialog → `CoinService.purchaseAccessory()`
- Purchased accessories go to `users/{uid}.inventory` (not to any specific cat)
- "Owned" check: accessory is in `inventory` OR on any cat's `equippedAccessory`
- The accessory layer is drawn as layer 13 in the rendering pipeline

#### Inventory Screen

- Accessed from CatRoomScreen AppBar (inventory icon) → route `/inventory`
- Two sections: "In Box" (from `inventoryProvider`) and "Equipped on Cats" (from all cats' `equippedAccessory`)
- Tap an inventory item → cat picker → equip to selected cat
- Tap an equipped item → unequip (returns to box)

### Check-In Banner

The `CheckInBanner` is a visible card widget on the HomeScreen that displays monthly check-in progress:

- **Not checked in**: Shows "Check in for +10 coins" and auto-triggers check-in on load. Displays success feedback via SnackBar (including milestone bonuses if applicable).
- **Already checked in**: Shows "X/N days · +Y coins today" summary. Tapping navigates to `CheckInScreen` (`/check-in` route) for full monthly details.

Data sources: `monthlyCheckInProvider` + `hasCheckedInTodayProvider`.

### Check-In Screen

The `CheckInScreen` (`/check-in` route) displays full monthly check-in details:

1. **Stats Card** — X/N days checked in, Y coins earned this month, next milestone info
2. **Calendar Grid** — 7-column grid showing checked/unchecked/future days with weekend column highlighting
3. **Milestones Card** — Progress toward 7/14/21/full-month milestones with check/pending indicators
4. **Reward Schedule** — Weekday 10 coins, Weekend 15 coins reference card

---

## Hachimi Diary (AI Cat Diary)

The Hachimi Diary gives each cat the ability to write daily diary entries based on the user's habit completion, the cat's personality, and mood. Diary generation requires the local LLM model to be downloaded and AI features enabled.

### Generation Trigger

1. **Primary**: After completing a focus session (`FocusCompleteScreen`), a background diary generation is triggered
2. **Secondary**: Opening `CatDetailScreen` when today's diary doesn't exist yet
3. **Frequency**: One diary per cat per day (`UNIQUE(cat_id, date)` constraint)

### Prompt Design

The diary prompt uses ChatML format (`<|im_start|>system/assistant<|im_end|>`) and includes:
- Cat name, personality, and flavor text
- Current mood and hours since last session
- Growth stage and progress percentage
- Habit details (today's focus, streak, total progress)
- Instruction: 2-4 sentences, first person, personality-adjusted tone
- Bilingual templates (English and Chinese based on app locale)

**Constants:** `lib/core/constants/llm_constants.dart` -> `class DiaryPrompt`

### Cat Detail Page Integration

A **Diary Preview Card** is inserted between the Focus Statistics Card and the Reminder Card:

```
Growth Progress Card
Focus Statistics Card
─────────────────────
Hachimi Diary Card
   Today's diary preview (2 lines)
   [View all diaries] ->
─────────────────────
Reminder Card
```

Tapping "View all" navigates to `CatDiaryScreen` (`/cat-diary` route).

---

## Cat Chat (AI Chat)

Users can have text conversations with their cat. The cat responds in character based on its personality. Chat requires the local LLM model to be downloaded and AI features enabled.

### Entry Point

Chat icon button in `CatDetailScreen` AppBar (only visible when `LlmAvailability.ready`).

### Chat UI

Standard message list layout:
- Cat messages on the left (with cat sprite avatar)
- User messages on the right
- Bottom text input + send button
- Typing indicator during generation
- Token-by-token streaming display

### Context Window Management

To maintain inference speed, the prompt budget is limited:
- System prompt: ~300 tokens
- Recent 10 rounds (20 messages): ~1500 tokens
- User new message: ~100 tokens
- Generation budget: 150 tokens max

Messages beyond 20 are excluded via sliding window.

### System Prompt

Uses ChatML format with personality, mood, stage, and habit context. Rules: stay in cat character, keep replies short (1-3 sentences), use cat sounds occasionally, encourage habit completion, never mention being AI.

**Constants:** `lib/core/constants/llm_constants.dart` -> `class ChatPrompt`

---

## Model Test Chat

A lightweight chat screen accessible from **Settings → AI Model → "Test Model"** that lets users verify the local LLM is working correctly after download — without needing to navigate to a specific cat.

### Purpose

After downloading the 1.2 GB model, users need a quick way to confirm everything works. The test chat provides this with zero friction.

### Differences from Cat Chat

| Aspect | Cat Chat | Model Test Chat |
|--------|----------|-----------------|
| Entry point | CatDetailScreen AppBar | Settings → AI Model section |
| Persona | Cat personality role-play | Generic helpful AI assistant |
| Message persistence | SQLite (survives app restart) | In-memory only (lost on exit) |
| System prompt | Personality + mood + habit context | Simple "helpful assistant" prompt |
| Service layer | ChatService (with history) | Direct LlmService.generateStream() |

### Entry Point

The "Test Model" button appears in the AI Model settings section only when `LlmAvailability == ready`. It navigates to `/model-test-chat`.

### System Prompt

Uses a minimal ChatML prompt via `TestPrompt.buildPrompt()`:
```
<|im_start|>system
You are a helpful AI assistant. Respond concisely in 1-2 sentences.
<|im_end|>
<|im_start|>user
{message}<|im_end|>
<|im_start|>assistant
```

**Constants:** `lib/core/constants/llm_constants.dart` -> `class TestPrompt`

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
