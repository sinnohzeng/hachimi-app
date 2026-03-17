# Hachimi PRD research: competitive landscape, UX science, and technical architecture

**Hachimi — a habit tracking and emotional wellness app with a virtual cat companion — enters a $11.4 billion market projected to reach $43.9 billion by 2034.** The clearest opportunity lies in the gap no competitor has filled: deep journaling, habit tracking, mood analytics, and emotionally resonant gamification unified in a single product. Finch, the closest analog at **$12M+ ARR bootstrapped**, proves the virtual pet model works — but leaves significant openings in UX polish, notification intelligence, adult tone, and task differentiation that Hachimi can exploit. This report synthesizes findings across seven research domains to inform a comprehensive PRD.

---

## The competitive landscape reveals a convergence gap

The habit tracking and wellness app market has matured into distinct clusters, but **no dominant app successfully combines deep journaling, habit tracking, mood analytics, and emotionally engaging gamification in one cohesive experience**. Each leader owns a niche while leaving adjacent territory underserved.

**Finch** (virtual bird companion, **~$1–2M monthly revenue**, 4.95 stars from 550K+ reviews) dominates the pet-as-self-care mechanic with projection psychology — "people won't care for themselves, but they'll care for something else." **Daylio** (4.8 stars, 393K+ reviews) pioneered no-writing micro-journaling with emoji-based mood logging in under 60 seconds. **Habitica** turns habits into a full RPG, driving social accountability through party quests. **Streaks** ($4.99 one-time) delivers the most frictionless Apple-native experience with one-tap completion. **Forest** (44M+ downloads) uses loss aversion brilliantly — your tree dies if you leave the app. **Reflectly** was first-to-market with AI-guided journaling prompts. **Fabulous** (37M users) applies Duke University behavioral science through deliberate habit stacking. **Journey** offers the richest cross-platform journaling but lacks gamification entirely.

Three market trends are particularly relevant for Hachimi. First, **habit-emotion convergence** is accelerating — users want to understand how habits affect how they feel, not just check boxes. Daylio's mood-activity correlation engine exemplifies this. Second, **AI integration** reached 58% of wellness apps in 2025, with personalized prompts, pattern recognition, and insights becoming table-stakes. Third, **subscription fatigue** is real — apps with opaque or expensive pricing face backlash (James Clear's Atoms at $120/year drew criticism), while generous free tiers drive organic growth. Finch's no-ads, generous free tier is a key growth driver.

**How We Feel** deserves special attention as a nonprofit backed by Yale's Center for Emotional Intelligence. It achieved a **4.9-star rating** and Apple's Cultural Impact Award 2022 by helping users build emotional vocabulary across 144 emotion words rather than rating mood on a simple scale. Its approach — free, privacy-first, research-backed — sets a credibility standard Hachimi should aspire to match.

| App | Habit Tracking | Mood Tracking | Journaling | Gamification | Price |
|-----|:---:|:---:|:---:|:---:|-----|
| Finch | ✅ | ✅ | ✅ Guided | ✅ Virtual pet | Free / ~$70/yr |
| Daylio | ✅ | ✅ | ✅ Icon-based | ⚡ Streaks | Free / $36/yr |
| Habitica | ✅ | ❌ | ❌ | ✅ Full RPG | Free / $48/yr |
| Streaks | ✅ | ❌ | ❌ | ⚡ Minimal | $4.99 once |
| Reflectly | ⚡ | ✅ | ✅ AI-guided | ⚡ Streaks | Free / $60/yr |
| How We Feel | ❌ | ✅ | ⚡ | ❌ | Free (nonprofit) |

---

## UX science points to a 60-second core loop with layered depth

Research consistently shows that **the optimal daily check-in takes under 60 seconds**, with optional expansion to 5–10 minutes for deeper engagement. Apps that activate users within 3 minutes see nearly **2x higher retention rates**. Daylio's benchmark — two taps (mood + activities) completing an entry in under a minute — is the gold standard for minimum viable interaction.

**Notification strategy is the single highest-leverage retention mechanism.** Users who enable push notifications show **88% higher engagement**, and a single push notification within the first 90 days makes users **3x more likely** to be retained. The consensus: one daily reminder at a user-chosen time, personalized, under 10 words, with emoji. Notifications with ≤10 words get nearly **2x the click rate** of longer messages. Pre-permission screens explaining value before the iOS system prompt dramatically improve opt-in rates.

**Onboarding must deliver a first "aha moment" within 60 seconds.** Products with great onboarding increase retention by up to 50%, while 77% of new app users are lost within 3 days. The proven pattern: 3–4 screens maximum, first check-in completed during onboarding (not after), intent question first ("How do you plan to use this app?"), and no forced sign-up. Duolingo's "play first, profile second" approach — users complete an engaging lesson before creating an account — is the model to follow.

**Streaks are the most powerful retention mechanic, but require safety valves.** Users are **2.3x more likely to engage daily** after building a 7+ day streak. Apps combining streaks and milestones reduce 30-day churn by **35%**. However, streak anxiety is well-documented — especially among ADHD and neurodivergent users. The solution is mandatory streak recovery features: streak freezes (Duolingo), flexible frequency goals (3x/week instead of daily), rolling 24-hour windows, and optional streak visibility. Finch handles this through pause mode and Rainbow Stone–based streak repair, but users still report anxiety at long streak counts.

Retention benchmarks for the category are sobering: **Day 1 averages 27%, Day 7 drops to 10–15%, and Day 30 falls to 3–8%** for mental health apps. The elite target is Insight Timer's **16% Day 30 retention**, achieved through community features and gamification. Hachimi should target **35%+ Day 1** (via exceptional onboarding), **20%+ Day 7** (via streaks and notifications), and **10%+ Day 30** (via emotional attachment to the cat and community).

---

## The Four Laws of Behavior Change map directly to app design decisions

James Clear's framework from Atomic Habits provides the structural backbone for Hachimi's feature design. Each law translates into specific digital product patterns, validated by the success of apps like Duolingo, Habitica, and Forest.

**Law 1 — Make it obvious (看得见)** means the cue for Hachimi must be inescapable. This translates to home screen widgets showing the cat and today's progress, contextual push notifications at user-specified times, and a habit stacking UX that links new habits to existing routines ("After I pour my morning coffee, I will open Hachimi for 2 minutes"). Duolingo layers multiple cue types — push notifications, badge counts, email, and even guilt-trip messages — and neuromarketing research confirmed these trigger genuine engagement. Hachimi's cat appearing on the home screen widget is the equivalent of Duolingo's owl.

**Law 2 — Make it attractive (想去做)** leverages dopamine's anticipation mechanism. The neuroscience is clear: **dopamine fires in anticipation of reward, not upon receiving it**. Variable rewards — where the cat discovers unpredictable things on adventures (a tiny hat, a poem about soup, a preference for rain) — sustain craving more effectively than predictable point accumulation. Habitica proves that framing habits as gameplay events transforms failure from personal shortcoming into a gameplay moment. Identity-based framing is also powerful: Clear's own Atoms app asks users to define "the kind of person you want to become," and Hachimi should frame daily actions as identity reinforcement.

**Law 3 — Make it easy (易上手)** is governed by Clear's "Two-Minute Rule" and BJ Fogg's Behavior Model (B=MAP). **When ability is high, you need less motivation.** Every tap between "open app" and "log habit" is potential dropout. Streaks achieves this with a single tap-and-hold gesture; Daylio with two icon selections. Hachimi's core daily check-in should complete in one tap (mood emoji selection), with optional depth layers (activities → short text → full journal). Delay account creation until the user has experienced value. Support multiple input methods: widgets, watch apps, voice, notification quick-reply actions.

**Law 4 — Make it satisfying (有奖励)** addresses temporal inconsistency — beneficial habits have delayed payoffs, so immediate reinforcement is essential. **Apps providing feedback within 2 seconds see 40% higher engagement** than those batching feedback. When Duolingo added milestone animations, 7-day retention for new learners increased by **1.7%**. Hachimi's cat should react immediately to completed tasks — a purr, a head bonk, a playful pounce — with satisfying animations and sounds. Milestone celebrations at 7, 30, 100, and 365 days should feel genuinely special, not perfunctory.

BJ Fogg's complementary insight is critical: **emotions, not repetition, wire habits into the brain**. The celebration after completing a behavior is what makes it stick. Hachimi's cat celebration moments aren't just delightful — they're the core habit-formation mechanism.

---

## Evidence-based interventions provide the app's therapeutic foundation

Three positive psychology interventions have sufficient evidence to anchor Hachimi's wellness features, each with specific digital implementation guidance.

**"Three Good Things"** (Seligman, 2005) asks users to record three positive events and their causes daily. The original study showed participants were happier and less depressed at **3-month and 6-month follow-ups** — but only those who continued voluntarily. A systematic review found **90% of studies with daily or 3–5×/week practice showed benefit**, compared to only 25% with weekly practice. Bolier et al.'s meta-analysis of 39 RCTs reported effect sizes of **d = 0.34 for subjective well-being and d = 0.23 for depression reduction**. Digital implementations (Three Good Things app by Oatmeal, Orca/Happyfeed, 5 Minute Journal) emphasize quick entry, rotating prompts, "stuck?" helper buttons, and throwback memories from past entries. For Hachimi, the cat could "ask" about three good things each evening, making the intervention feel like a conversation rather than an exercise.

**Gratitude journaling** (Emmons & McCullough, 2003) is the broader category. The foundational study found the gratitude group **exercised more, reported fewer physical symptoms, felt better about life, and was more optimistic**. A 2023 meta-analysis of 64 RCTs found gratitude interventions produced **7.76% lower anxiety and 6.89% lower depression**. A counterintuitive finding from Lyubomirsky: students who counted blessings **once weekly** reported greater improvements than those doing it three times weekly — hedonic adaptation makes too-frequent practice feel routine. The optimal hybrid: daily practice during an initial 1–2 week onboarding period, then transition to 2–3×/week. **Specificity matters** — "I'm grateful my sister called when she knew I was stressed" outperforms "I'm grateful for my family."

**Worry externalization** (Pennebaker's expressive writing) has generated **400+ studies** since 1986. The overall effect size averages **d = 0.16** across 100+ studies. The mechanism: translating experiences into language **activates the prefrontal cortex while dampening amygdala activity**, creating psychological distance. WorryTree (CBT-based) categorizes worries as controllable vs. uncontrollable, then offers action plans or mindful distraction respectively. WorryBox implements a "write and burn" mechanic — users write worries, then watch an animation of the worry burning. Hachimi could implement a "cat catches the worry" mechanic: write the worry, the cat bats it away with a satisfying animation, symbolizing externalization and release.

A critical design principle across all three interventions: **acknowledge bad days**. Forcing gratitude during genuine hardship creates toxic positivity. Hachimi must offer pathways for when gratitude feels impossible — worry externalization, simple mood logging, or just sitting quietly with the cat.

---

## Flutter architecture should be local-first with Riverpod, Drift, and Supabase

The recommended technical stack centers on three pillars: **Riverpod for state management, Drift (SQLite) for local-first storage, and Supabase for optional cloud sync**.

**Riverpod 3.0** is the 2025–2026 consensus for medium-complexity Flutter apps. It provides compile-time safety, reactive database integration via `AsyncNotifier` and `StreamProvider` that pair naturally with Drift's reactive streams, and built-in state persistence. BLoC is recommended only for enterprise/regulated industries where its additional ceremony is justified.

**Drift** (formerly Moor) is the default recommendation for SQLite in Flutter. It offers type-safe queries with compile-time checking, auto-updating streams (when a journal entry changes, all watching widgets update automatically), first-class schema migrations, and compatibility with `sqlcipher_flutter_libs` for **256-bit AES encryption** — essential for journaling privacy. The database schema should use **client-generated UUIDs** for offline-first ID generation, store timestamps in UTC but perform streak calculations in user's local timezone (stored as `YYYY-MM-DD` strings), and include a `SyncQueue` table implementing the **Transactional Outbox Pattern** for reliable sync.

The streak calculation algorithm must handle three edge cases: **timezone-aware date comparison** (using the `timezone` package for DST), **grace periods** (3–6 hours after midnight count for the previous day), and **streak freezes** (auto-consume a freeze on missed days, tracked in a `freezesRemaining` field). Keep `currentStreak` and `longestStreak` as denormalized fields updated on each save — only recompute from full history on sync conflicts.

**Supabase** is recommended over Firebase because its SQL model matches the local Drift/SQLite schema (both relational), it offers Row Level Security, low vendor lock-in (standard Postgres, self-hostable), and a generous free tier. For full offline-first sync, **PowerSync** provides plug-and-play synchronization between SQLite and Supabase with causal+ consistency. For MVP, a simpler REST-based sync with the SyncQueue pattern is sufficient.

The project structure should follow a **feature-first + clean architecture hybrid**: each feature (journal, streaks, settings, cat companion) is self-contained with `data/`, `domain/`, and `presentation/` layers, while shared infrastructure (database, sync, notifications) lives in a `core/` folder. Key packages beyond the core: **fl_chart** for mood trend visualization, **flutter_local_notifications** for scheduled reminders, **table_calendar** for calendar views, **flutter_quill** for rich text journal editing, and **lottie** for celebration animations.

---

## Writing a PRD that AI coding tools can execute effectively

Writing a PRD for AI coding assistants (Claude Code, Cursor) differs fundamentally from writing one for human developers. **The specification becomes the programming interface** — AI agents are literal, can't infer organizational context, and lose memory between sessions.

The recommended document set is four files: `prd.md` (what to build), `tech-design.md` (how to build it), `entity-dictionary.md` (data model definitions), and `plan.md` (phased implementation checklist). The **Entity Dictionary is the single most critical artifact** — if the AI knows what each entity is and what each field means, it stops guessing. A separate `CLAUDE.md` or `.cursor/rules/` file defines coding conventions, project structure, and verification commands.

The right level of technical specificity: **specify WHAT and constrain HOW, but don't over-prescribe implementation details.** Be prescriptive about tech stack and versions, database schema, API contracts, authentication approach, naming conventions, and folder structure. Leave internal implementation logic, algorithm choices, and boilerplate wiring to the AI.

Key execution principles for AI-assisted development:

- **Vertical slices, not horizontal layers** — build full-stack features (DB to UI) in increasing complexity rather than building all database tables first, then all APIs, then all UI
- **One task per prompt** — never ask for multiple unrelated changes simultaneously
- **Explore → Plan → Code → Commit** — Anthropic's official workflow mandates a research phase before any code generation
- **Commit after every working change** — Git history is the safety net against regression
- **Keep CLAUDE.md under 200 lines** — overly long context files cause important rules to be ignored
- **When AI makes a mistake, update the rules file** — turn errors into permanent guardrails

The most common failure mode is **context window exhaustion**: as conversations grow long, the AI summarizes earlier context and loses critical instructions. The mitigation: reference your plan file in every prompt ("I'm working on step 3 of plan.md"), keep sessions focused, and have the AI write a `recap.md` when switching sessions.

---

## Finch proves the model — and reveals exactly where Hachimi can win

Finch is the definitive case study for Hachimi. Founded in 2021 by ex-Quora engineer Stephanie Yuan after 8 failed prototypes, it reached **$12M+ annual revenue while remaining bootstrapped** with ~34 employees. Its **4.95/5 App Store rating** from 550,000+ reviews and ~13M+ total downloads demonstrate that projection psychology — caring for a virtual pet as a proxy for self-care — is a validated, scalable product model.

Finch's core loop is elegant: complete real-world self-care tasks → earn Energy Points → bird goes on adventure → bird returns with randomized discoveries and personality traits → emotional attachment deepens → motivation to continue self-care increases. The **no-punishment design** is therapeutically critical — nothing bad happens if you miss a day; the bird just waits warmly. The bird evolves through 5 stages (Baby → Adult, requiring 67+ adventures), developing unique personality traits and preferences that make each user's bird feel genuinely personal.

Finch's **D1 retention of ~60%** (more than double the mental health app average of 27%) and **Revenue Per Download of $1.11** (nearly double Daylio's $0.69) validate the model's commercial viability. Three check-ins per day — morning motivation (weather icons), afternoon mood (facial expressions), evening satisfaction — provide structured touchpoints without feeling burdensome.

However, Finch has exploitable weaknesses that define Hachimi's differentiation opportunity:

- **No dark mode** — a glaring accessibility gap for an app used at bedtime
- **Generic notifications** — not personalized to user behavior or schedule patterns
- **All tasks treated equally** — "drink water" and "make a difficult phone call" earn identical rewards, which frustrates users seeking proportional recognition
- **Cluttered UI with no onboarding walkthrough** — most valuable features (Journeys, deep reflections) are buried
- **iOS vs. Android pricing disparity** ($14.99/yr iOS vs. $69.99/yr Android) is overwhelmingly the #1 user complaint
- **Tone feels childish** to some adult users — "pop psychology" criticism limits demographic reach
- **Seasonal event FOMO** creates anxiety that contradicts the app's wellness mission
- **Streak anxiety** persists despite no-punishment design — users with 300+ day streaks report genuine dread of losing progress

Hachimi's differentiation strategy should target five areas. **Difficulty-weighted tasks** where harder goals earn proportionally more energy and elicit bigger cat celebrations. **Adaptive, intelligent notifications** that learn user patterns ("Your cat noticed you usually check in around 3pm"). **A mature tone option** — Studio Ghibli–inspired aesthetic rather than children's cartoon — that appeals to adults without losing warmth. **Surfaced deep features** where guided reflections and journeys appear naturally in the daily flow rather than hiding behind menus. And **automatic streak forgiveness** where one missed day per week doesn't break the streak, eliminating anxiety while maintaining consistency motivation.

Cat-specific interactions also offer a richer emotional vocabulary than Finch's bird: head bonks during journaling, purring during meditation, playful pouncing on completed goals, sleeping in a sunbeam when the user rests, and "bringing gifts" (discovered items on adventures). These behaviors map naturally to feline personalities — independent, curious, affectionate on their own terms — and can model healthy attachment patterns.

---

## Conclusion: from research to action

This research converges on a clear product thesis for Hachimi. The **core daily loop** should be: open app → cat greets you → one-tap mood check (under 10 seconds) → view daily goals → complete tasks throughout the day (cat celebrates each one) → optional evening "three good things" or worry externalization → cat goes on adventure → returns with variable rewards. The **minimum viable interaction** is a single mood tap; the **maximum session** is a 10-minute guided reflection. Everything between should be optional, inviting, and layered.

The technical foundation — Riverpod + Drift + Supabase in a feature-first Flutter architecture — supports offline-first reliability with optional cloud sync. The PRD should be structured as four documents (prd.md, entity-dictionary.md, tech-design.md, plan.md) with vertical-slice implementation phases, designed for AI coding tools to execute incrementally.

Three novel insights emerged from cross-referencing the research streams. First, **Lyubomirsky's frequency finding** (weekly gratitude outperforms daily for long-term practice) suggests Hachimi should use daily practice during onboarding but intelligently transition users to 2–3×/week for sustained engagement — a strategy no competitor currently implements. Second, **Fogg's celebration research** (emotions, not repetition, wire habits) means the cat's reaction to completed tasks isn't merely delightful UX — it's the core mechanism of habit formation. Investing heavily in cat animation quality is investing in the product's fundamental effectiveness. Third, **combining worry externalization with the cat mechanic** (the cat "catches" or "bats away" the worry) transforms a clinical technique into an emotionally resonant, shareable moment — the kind of interaction that drives TikTok virality organically, following Finch's #finchtok growth playbook.