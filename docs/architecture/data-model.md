# Data Model

> SSOT for account lifecycle related data after 2026-03 refactor.

## Firestore Structure
```
users/{uid}
├── habits/{habitId}
│   └── sessions/{sessionId}
├── cats/{catId}
├── achievements/{achievementId}
├── monthlyCheckIns/{yyyy-MM}
├── dailyLights/{date}
├── weeklyReviews/{weekId}
└── worries/{worryId}
```

## User Document (`users/{uid}`)
Required core fields:
- `email` (string)
- `displayName` (string)
- `coins` (int)
- `inventory` (array<string>)
- `createdAt` (timestamp)

Optional profile fields:
- `avatarId`
- `currentTitle`
- `lastCheckInDate`

`ensureProfile(...)` is idempotent and must never overwrite existing user documents.

## Local SQLite (Runtime SSOT)
- `action_ledger`: immutable local write-ahead log
- `materialized_state`: key/value aggregates (coins, profile cache)
- `local_habits`
- `local_cats`
- `local_sessions`
- `local_monthly_checkins`
- `local_achievements`
- `local_daily_lights` (v4)
- `local_weekly_reviews` (v4)
- `local_worries` (v4)
- `local_awareness_stats` (v4)

## SharedPreferences Keys
### Identity
- `cached_uid`
- `local_guest_uid`

### Sync
- `local_data_hydrated_v1`

### Deletion queue
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Cloud Functions
### `deleteAccountV2`
- Requires authenticated user.
- Requires valid App Check token (consumed to prevent replay).
- Recursively deletes all `users/{uid}` data.
- Deletes Firebase Auth user.
- Idempotent for missing doc/user.

### `wipeUserDataV2`
- Requires authenticated user.
- Requires valid App Check token (consumed to prevent replay).
- Recursively deletes all `users/{uid}` data.
- Keeps Firebase Auth user.
- Used by guest upgrade `keepLocal` path.

Compatibility aliases (`deleteAccountV1` / `wipeUserDataV1`) remain available during migration.

## Merge Semantics
- Keep cloud: local old guest data is removed; cloud hydrates local.
- Keep local: cloud data is wiped first; local migrates to new uid and pushes to cloud.

## Deletion Semantics
- Local-first deletion is irreversible.
- Cloud/Auth deletion is immediate when online or queued when offline.
- Pending deletion is retried automatically on app startup and periodic retry loop.

## Domain Enums

Strongly-typed enums introduced in the B1 quality batch to replace raw `String` / `int` constants.

| Enum | File | Values | Used By |
|------|------|--------|---------|
| `CatState` | `core/constants/cat_constants.dart` | `active`, `graduated`, `dormant` | `Cat.state` field |
| `CatStage` | `core/constants/pixel_cat_constants.dart` | `kitten`, `adolescent`, `adult`, `senior` | Pixel cat sprite stage |
| `SessionStatus` | `core/constants/session_constants.dart` | `completed`, `abandoned`, `interrupted` | `FocusSession.status` field |
| `SessionMode` | `models/focus_session.dart` | `countdown`, `stopwatch` | `FocusSession.mode` field |
| `AccessoryCategory` | `providers/accessory_provider.dart` | `plant`, `wild`, `collar` | Accessory filtering |
| `ReminderMode` | `models/reminder_config.dart` | `daily`, `weekdays`, `monday`–`sunday` | `ReminderConfig.mode` field |
| `CelebrationHeadline` | `widgets/celebration/celebration_tier.dart` | `achievementUnlocked`, `achievementAwesome`, `achievementIncredible` | `CelebrationConfig.headline` |

## V3 Awareness Data Layer

### Local SQLite — Awareness Tables (DB v4)

DB version bumped from v3 → v4 with migration adding 4 new tables.

**`local_daily_lights`** — 每日一光记录
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `date` | TEXT | NOT NULL |
| `mood` | INTEGER | NOT NULL |
| `light_text` | TEXT | |
| `tags` | TEXT (JSON) | |
| `timeline_events` | TEXT (JSON) | |
| `habit_completions` | TEXT (JSON) | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, date) |

**`local_weekly_reviews`** — 周回顾
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `week_id` | TEXT | NOT NULL |
| `week_start_date` | TEXT | |
| `week_end_date` | TEXT | |
| `happy_moment_1` | TEXT | |
| `happy_moment_1_tags` | TEXT (JSON) | |
| `happy_moment_2` | TEXT | |
| `happy_moment_2_tags` | TEXT (JSON) | |
| `happy_moment_3` | TEXT | |
| `happy_moment_3_tags` | TEXT (JSON) | |
| `gratitude` | TEXT | |
| `learning` | TEXT | |
| `cat_weekly_summary` | TEXT | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, week_id) |

**`local_worries`** — 烦恼处理器
| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `description` | TEXT | NOT NULL |
| `solution` | TEXT | |
| `status` | TEXT | DEFAULT 'ongoing' |
| `resolved_at` | INTEGER | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |

**`local_awareness_stats`** — 觉知聚合统计
| Column | Type | Constraint |
|--------|------|------------|
| `uid` | TEXT | PK |
| `total_light_days` | INTEGER | DEFAULT 0 |
| `total_weekly_reviews` | INTEGER | DEFAULT 0 |
| `total_worries_resolved` | INTEGER | DEFAULT 0 |
| `last_light_date` | TEXT | |
| `updated_at` | INTEGER | |

### Firestore — Awareness Collections

Under `users/{uid}/`:

```
users/{uid}
├── ...existing collections...
├── dailyLights/{date}
├── weeklyReviews/{weekId}
└── worries/{worryId}
```

**`dailyLights/{date}`**
- `mood` (int)
- `lightText` (string)
- `tags` (array<string>)
- `timelineEvents` (array<map>)
- `habitCompletions` (array<map>)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**`weeklyReviews/{weekId}`**
- `weekStartDate` (string)
- `weekEndDate` (string)
- `happyMoment1` / `happyMoment1Tags` (string / array)
- `happyMoment2` / `happyMoment2Tags` (string / array)
- `happyMoment3` / `happyMoment3Tags` (string / array)
- `gratitude` (string)
- `learning` (string)
- `catWeeklySummary` (string)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**`worries/{worryId}`**
- `description` (string)
- `solution` (string)
- `status` (string, default: `"ongoing"`)
- `resolvedAt` (timestamp, nullable)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

## V3 LUMI 数据层

### 新增 Firestore Collections

```
users/{uid}
├── ...existing collections...
├── weeklyPlans/{weekId}
├── monthlyPlans/{yyyy-MM}
├── yearlyPlans/{year}
├── lists/{listId}
└── highlightEntries/{id}
```

### 新增模型定义

#### YearlyPlan（年度计划）

**Firestore**: `users/{uid}/yearlyPlans/{year}`

| 字段 | 类型 | 说明 |
|------|------|------|
| `year` | int | 年份 |
| `messages` | map | 年度寄语（7 个提问的回答） |
| `messages.become` | string | 我希望成为…… |
| `messages.achieve` | string | 我想要达成…… |
| `messages.breakthrough` | string | 我要突破性地完成…… |
| `messages.stopDoing` | string | 我不再做…… |
| `messages.keyword` | string | 我的年度关键词 |
| `messages.letterToFuture` | string | 给亲爱的未来的我 |
| `messages.motto` | string | 我的座右铭 |
| `growthPlan` | array<map> | 8 维度成长计划 |
| `growthPlan[].dimension` | string | 维度名称 |
| `growthPlan[].goals` | array<string> | 3 个具体目标 |
| `growthPlan[].status` | string | completed / inProgress / notStarted |
| `annualMarkers` | map<string, string> | 年历标记 {MM-dd: note} |
| `smallWin100` | map | 100 天挑战 |
| `smallWin100.habitName` | string | 挑战习惯名称 |
| `smallWin100.completedDays` | array<string> | 已完成日期列表 |
| `smallWin100.reward` | string | 奖励 |
| `travelActivities` | array<map> | 旅行与活动（16 条） |
| `createdAt` | timestamp | |
| `updatedAt` | timestamp | |

#### MonthlyPlan（月度计划）

**Firestore**: `users/{uid}/monthlyPlans/{yyyy-MM}`

| 字段 | 类型 | 说明 |
|------|------|------|
| `monthKey` | string | 格式 yyyy-MM |
| `goals` | array<map> | 5 个月目标 |
| `goals[].text` | string | 目标描述 |
| `goals[].completed` | bool | 是否完成 |
| `smallWinChallenge` | map | 小赢挑战 |
| `smallWinChallenge.habitName` | string | 挑战习惯名称 |
| `smallWinChallenge.fourLaws` | map | 四法则 {cue, craving, response, reward} |
| `smallWinChallenge.completedDays` | array<string> | 已完成日期列表 |
| `smallWinChallenge.reward` | string | 奖励 |
| `habitTrackers` | array<map> | 4 个小习惯追踪 |
| `habitTrackers[].habitName` | string | 习惯名称 |
| `habitTrackers[].completedDays` | array<string> | 已完成日期列表 |
| `selfCareActivities` | array<string> | 爱自己活动清单 |
| `memory` | string | 本月记忆 |
| `achievement` | string | 本月成就 |
| `createdAt` | timestamp | |
| `updatedAt` | timestamp | |

#### WeeklyPlan（周计划）

**Firestore**: `users/{uid}/weeklyPlans/{weekId}`

| 字段 | 类型 | 说明 |
|------|------|------|
| `weekId` | string | ISO 周 ID，格式 yyyy-Www |
| `weekStartDate` | string | 周一日期 |
| `weekEndDate` | string | 周日日期 |
| `oneLineWish` | string | 一句话给自己（本周心愿）|
| `eisenhowerMatrix` | map | 艾森豪威尔四象限 |
| `eisenhowerMatrix.mustDo` | array<map> | 必须做 [{text, duration}] |
| `eisenhowerMatrix.shouldDo` | array<map> | 要做 |
| `eisenhowerMatrix.couldDo` | array<map> | 该做 |
| `eisenhowerMatrix.wantDo` | array<map> | 想做 |
| `newWorries` | array<map> | 本周新增烦恼 [{description, solution}] |
| `createdAt` | timestamp | |
| `updatedAt` | timestamp | |

#### WeeklyReview 扩展字段

在现有 `weeklyReviews/{weekId}` 基础上新增：

| 字段 | 类型 | 说明 |
|------|------|------|
| `freeNote` | string | 随笔（自由记录区）|
| `worrySummary` | map | 烦恼状态总结 |
| `worrySummary.vanished` | array<string> | 自然消失的烦恼 |
| `worrySummary.resolved` | array<string> | 自己搞定的烦恼 |
| `worrySummary.remaining` | array<string> | 还在的烦恼 → 烦恼罐 |

#### UserList（用户清单）

**Firestore**: `users/{uid}/lists/{listId}`

| 字段 | 类型 | 说明 |
|------|------|------|
| `listType` | string | book / movie / custom |
| `customName` | string, nullable | 自定义清单名称 |
| `year` | int | 所属年份 |
| `items` | array<map> | 清单条目（10 条） |
| `items[].title` | string | 标题 |
| `items[].creator` | string | 作者/导演 |
| `items[].genre` | string | 类型 |
| `items[].rating` | int | 1-5 评分 |
| `items[].keywords` | string | 关键词 |
| `items[].feeling` | string | 感受 |
| `yearPick` | map, nullable | 年度精选 |
| `yearPick.treasure` | string | 宝藏推荐 |
| `yearPick.inspiration` | string | 灵感一击 |
| `yearPick.wall` | array<string> | 精华墙（3 条） |
| `createdAt` | timestamp | |
| `updatedAt` | timestamp | |

#### HighlightEntry（幸福/高光时刻）

**Firestore**: `users/{uid}/highlightEntries/{id}`

| 字段 | 类型 | 说明 |
|------|------|------|
| `entryType` | string | happy / highlight |
| `year` | int | 所属年份 |
| `description` | string | 发生了什么 / 幸福的事 |
| `companion` | string, nullable | 和谁一起（幸福时刻专用）|
| `myAction` | string, nullable | 我做了什么（高光时刻专用）|
| `feeling` | string | 感受 |
| `eventDate` | string | 事件日期 |
| `rating` | int, nullable | 1-5 评分（幸福仪表盘）|
| `createdAt` | timestamp | |
| `updatedAt` | timestamp | |

### 新增 SQLite 表（全新 Schema，无迁移）

**`local_weekly_plans`**

| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `week_id` | TEXT | NOT NULL |
| `week_start_date` | TEXT | |
| `week_end_date` | TEXT | |
| `one_line_for_self` | TEXT | |
| `urgent_important` | TEXT (JSON) | |
| `important_not_urgent` | TEXT (JSON) | |
| `urgent_not_important` | TEXT (JSON) | |
| `not_urgent_not_important` | TEXT (JSON) | |
| `new_worries` | TEXT (JSON) | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, week_id) |

**`local_monthly_plans`**

| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `month_id` | TEXT | NOT NULL |
| `goals` | TEXT (JSON) | |
| `small_win_challenge` | TEXT (JSON) | |
| `habit_trackers` | TEXT (JSON) | |
| `self_care_activities` | TEXT (JSON) | |
| `memory` | TEXT | |
| `achievement` | TEXT | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, month_id) |

**`local_yearly_plans`**

| Column | Type | Constraint |
|--------|------|------------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `year` | INTEGER | NOT NULL |
| `messages` | TEXT (JSON) | |
| `growth_plan` | TEXT (JSON) | |
| `annual_markers` | TEXT (JSON) | |
| `small_win_100` | TEXT (JSON) | |
| `travel_activities` | TEXT (JSON) | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, year) |

**`local_user_lists`**

| Column | Type | Constraint |
|--------|------|------------|
| `id` | TEXT | PK |
| `uid` | TEXT | NOT NULL |
| `list_type` | TEXT | NOT NULL |
| `custom_name` | TEXT | |
| `year` | INTEGER | NOT NULL |
| `items` | TEXT (JSON) | |
| `year_pick` | TEXT (JSON) | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |

**`local_highlight_entries`**

| Column | Type | Constraint |
|--------|------|------------|
| `id` | TEXT | PK |
| `uid` | TEXT | NOT NULL |
| `entry_type` | TEXT | NOT NULL |
| `year` | INTEGER | NOT NULL |
| `description` | TEXT | NOT NULL |
| `companion` | TEXT | |
| `my_action` | TEXT | |
| `feeling` | TEXT | |
| `event_date` | TEXT | |
| `rating` | INTEGER | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |

**`local_weekly_reviews` 扩展列**

| Column | Type | 说明 |
|--------|------|------|
| `free_note` | TEXT | 随笔 |
| `worry_summary` | TEXT (JSON) | 烦恼状态总结 |

### LUMI Onboarding 数据

存入 `materialized_state`：

| Key | 类型 | 说明 |
|-----|------|------|
| `lumi_user_name` | String | 手册主人名字 |
| `lumi_birthday` | String | 生日（MM-dd）|
| `lumi_start_date` | String | 旅程开始日期（yyyy-MM-dd）|
| `lumi_onboarding_version` | int | Onboarding 版本（2）|
