# 数据模型

> 2026-03 重构后账户生命周期相关数据 SSOT。

## Firestore 结构
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

## 用户文档（`users/{uid}`）
核心字段：
- `email`（string）
- `displayName`（string）
- `coins`（int）
- `inventory`（array<string>）
- `createdAt`（timestamp）

可选字段：
- `avatarId`
- `currentTitle`
- `lastCheckInDate`

`ensureProfile(...)` 必须幂等，禁止覆盖已有用户文档。

## 本地 SQLite（运行时 SSOT）
- `action_ledger`：不可变行为台账
- `materialized_state`：聚合缓存（金币、资料等）
- `local_habits`
- `local_cats`
- `local_sessions`
- `local_monthly_checkins`
- `local_achievements`
- `local_daily_lights`（v4）
- `local_weekly_reviews`（v4）
- `local_worries`（v4）
- `local_awareness_stats`（v4）

## SharedPreferences 键
### 身份
- `cached_uid`
- `local_guest_uid`

### 同步
- `local_data_hydrated_v1`

### 删号队列
- `pending_deletion_job`
- `deletion_tombstone`
- `deletion_retry_count`

## Cloud Functions
### `deleteAccountV2`
- 需要登录态。
- 需要有效 App Check token（消费 token 防重放）。
- 递归删除 `users/{uid}` 全量业务数据。
- 删除 Firebase Auth 用户。
- 对缺失文档/缺失用户幂等成功。

### `wipeUserDataV2`
- 需要登录态。
- 需要有效 App Check token（消费 token 防重放）。
- 仅递归删除 `users/{uid}` 业务数据。
- 保留 Firebase Auth 用户。
- 用于访客升级 `keepLocal` 路径。

兼容别名（`deleteAccountV1` / `wipeUserDataV1`）在迁移期仍保留。

## 合并语义
- 保留云端：删除旧访客本地数据，云端 hydrate 覆盖本地。
- 保留本地：先清空云端，再迁移本地 UID 并回推。

## 删号语义
- 本地先删不可恢复。
- 云端/Auth 在线立即硬删，离线则排队补删。
- 启动期与轮询重试自动推进 pending job。

## V3 觉知数据层

### 本地 SQLite — 觉知表（DB v4）

DB 版本从 v3 升级至 v4，迁移新增 4 张表。

**`local_daily_lights`** — 每日一光记录
| 字段 | 类型 | 约束 |
|------|------|------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `date` | TEXT | NOT NULL |
| `mood` | INTEGER | NOT NULL |
| `light_text` | TEXT | |
| `tags` | TEXT（JSON） | |
| `timeline_events` | TEXT（JSON） | |
| `habit_completions` | TEXT（JSON） | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, date) |

**`local_weekly_reviews`** — 周回顾
| 字段 | 类型 | 约束 |
|------|------|------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `week_id` | TEXT | NOT NULL |
| `week_start_date` | TEXT | |
| `week_end_date` | TEXT | |
| `happy_moment_1` | TEXT | |
| `happy_moment_1_tags` | TEXT（JSON） | |
| `happy_moment_2` | TEXT | |
| `happy_moment_2_tags` | TEXT（JSON） | |
| `happy_moment_3` | TEXT | |
| `happy_moment_3_tags` | TEXT（JSON） | |
| `gratitude` | TEXT | |
| `learning` | TEXT | |
| `cat_weekly_summary` | TEXT | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |
| | | UNIQUE(uid, week_id) |

**`local_worries`** — 烦恼处理器
| 字段 | 类型 | 约束 |
|------|------|------|
| `id` | INTEGER | PK |
| `uid` | TEXT | NOT NULL |
| `description` | TEXT | NOT NULL |
| `solution` | TEXT | |
| `status` | TEXT | DEFAULT 'ongoing' |
| `resolved_at` | INTEGER | |
| `created_at` | INTEGER | NOT NULL |
| `updated_at` | INTEGER | NOT NULL |

**`local_awareness_stats`** — 觉知聚合统计
| 字段 | 类型 | 约束 |
|------|------|------|
| `uid` | TEXT | PK |
| `total_light_days` | INTEGER | DEFAULT 0 |
| `total_weekly_reviews` | INTEGER | DEFAULT 0 |
| `total_worries_resolved` | INTEGER | DEFAULT 0 |
| `last_light_date` | TEXT | |
| `updated_at` | INTEGER | |

### Firestore — 觉知集合

位于 `users/{uid}/` 下：

```
users/{uid}
├── ...既有集合...
├── dailyLights/{date}
├── weeklyReviews/{weekId}
└── worries/{worryId}
```

**`dailyLights/{date}`**
- `mood`（int）
- `lightText`（string）
- `tags`（array<string>）
- `timelineEvents`（array<map>）
- `habitCompletions`（array<map>）
- `createdAt`（timestamp）
- `updatedAt`（timestamp）

**`weeklyReviews/{weekId}`**
- `weekStartDate`（string）
- `weekEndDate`（string）
- `happyMoment1` / `happyMoment1Tags`（string / array）
- `happyMoment2` / `happyMoment2Tags`（string / array）
- `happyMoment3` / `happyMoment3Tags`（string / array）
- `gratitude`（string）
- `learning`（string）
- `catWeeklySummary`（string）
- `createdAt`（timestamp）
- `updatedAt`（timestamp）

**`worries/{worryId}`**
- `description`（string）
- `solution`（string）
- `status`（string，默认：`"ongoing"`）
- `resolvedAt`（timestamp，可空）
- `createdAt`（timestamp）
- `updatedAt`（timestamp）
