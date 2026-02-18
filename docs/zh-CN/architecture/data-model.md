# 数据模型 — Firestore 模式（SSOT）

> **SSOT**（Single Source of Truth，单一真值来源） ：本文档是所有 Firestore 集合、文档模式及数据完整性规则的权威来源。`lib/models/` 和 `lib/services/firestore_service.dart` 的实现必须与此规范完全一致。

---

## 集合层级

```
users/{uid}                          ← 用户基本信息文档
├── habits/{habitId}                 ← 习惯元数据 + 连续记录追踪
│   └── sessions/{sessionId}        ← 专注会话历史
├── cats/{catId}                     ← 猫咪状态（XP、阶段、心情、房间槽位）
└── checkIns/{date}                  ← 按日期分区的打卡桶（向后兼容）
    └── entries/{entryId}            ← 每次会话的分钟数记录
```

---

## 集合：`users/{uid}`

顶层用户文档，在首次登录时创建。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `displayName` | string | 是 | 用户显示名称（来自 Firebase Auth） |
| `email` | string | 是 | 用户邮箱地址 |
| `createdAt` | timestamp | 是 | 账户创建时间戳 |
| `fcmToken` | string | 否 | Firebase Cloud Messaging 设备令牌 |

**说明：**
- `uid` 是 Firebase Auth UID，同时作为文档 ID 和所有用户数据的顶层命名空间。
- `fcmToken` 在每次应用启动时通过 `NotificationService.initialize()` 更新，目前不支持多设备（后写优先）。

---

## 集合：`users/{uid}/habits/{habitId}`

每个用户习惯一个文档，`habitId` 由 Firestore 自动生成。

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `name` | string | 是 | — | 习惯显示名称，如 "每日阅读" |
| `icon` | string | 是 | — | 习惯图标 Emoji，如 "📚" |
| `catId` | string | 是 | — | 绑定猫咪文档 ID（位于 `users/{uid}/cats/`） |
| `goalMinutes` | int | 是 | 25 | 每日专注目标分钟数（用于进度显示） |
| `targetHours` | int | 是 | 100 | 累计长期目标小时数（用于整体进度） |
| `totalMinutes` | int | 是 | 0 | 所有时间累计记录的总分钟数 |
| `currentStreak` | int | 是 | 0 | 当前连续打卡天数 |
| `bestStreak` | int | 是 | 0 | 历史最高连续打卡天数 |
| `lastCheckInDate` | string | 否 | null | 最近一次会话的 ISO 日期字符串 "YYYY-MM-DD" |
| `reminderTime` | string | 否 | null | 每日提醒时间，24 小时格式 "HH:mm"，如 "08:30" |
| `isActive` | bool | 是 | true | `false` 表示习惯已停用（猫咪进入休眠状态） |
| `createdAt` | timestamp | 是 | — | 习惯创建时间戳 |

**连续记录计算规则：**
- 每次会话完成后，将今日日期与 `lastCheckInDate` 比较。
- `lastCheckInDate == 昨天`：`currentStreak += 1`
- `lastCheckInDate == 今天`：连续记录不变（同一天多次会话）
- 其他情况：`currentStreak = 1`（连续记录中断）
- 每次更新后：`bestStreak = max(bestStreak, currentStreak)`

**Dart 模型：** `lib/models/habit.dart` → `class Habit`

---

## 集合：`users/{uid}/habits/{habitId}/sessions/{sessionId}`

每次专注会话一个文档，`sessionId` 由 Firestore 自动生成。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `habitId` | string | 是 | 父习惯 ID 的反向引用（用于跨集合查询） |
| `catId` | string | 是 | 本次会话中获得 XP 的猫咪 ID |
| `startedAt` | timestamp | 是 | 专注会话开始时间 |
| `endedAt` | timestamp | 是 | 会话结束时间（完成或放弃） |
| `durationMinutes` | int | 是 | 实际专注分钟数（放弃时可能少于目标） |
| `xpEarned` | int | 是 | 会话结束时奖励的 XP（由 `XpService` 计算） |
| `mode` | string | 是 | 计时器模式：`"countdown"` 或 `"stopwatch"` |
| `completed` | bool | 是 | `true` 表示正常完成；`false` 表示提前放弃 |

**放弃会话的 XP 规则：**
- `completed == false` 且 `durationMinutes >= 5`：`xpEarned = durationMinutes × 1`（仅基础 XP）
- `completed == false` 且 `durationMinutes < 5`：`xpEarned = 0`

**Dart 模型：** `lib/models/focus_session.dart` → `class FocusSession`

---

## 集合：`users/{uid}/cats/{catId}`

每只猫咪一个文档，`catId` 由 Firestore 自动生成。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `name` | string | 是 | 猫咪名字，如 "Mochi" |
| `breed` | string | 是 | 品种 ID——详见[猫咪系统](cat-system.md) |
| `pattern` | string | 是 | 花纹 ID：`"classic_stripe"`、`"spotted"` 或 `"solid"` |
| `personality` | string | 是 | 性格 ID——详见[猫咪系统](cat-system.md) |
| `rarity` | string | 是 | 稀有度：`"common"`、`"uncommon"` 或 `"rare"` |
| `xp` | int | 是 | 累计总 XP。阶段在读取时从此字段计算得出。 |
| `roomSlot` | string | 否 | 猫咪在房间中所在的槽位 ID |
| `boundHabitId` | string | 是 | 生成此猫咪的习惯 ID |
| `state` | string | 是 | `"active"`、`"dormant"` 或 `"graduated"` |
| `lastSessionAt` | timestamp | 否 | 最近一次专注会话的时间戳 |
| `createdAt` | timestamp | 是 | 猫咪领养时间戳 |

**计算字段（不存储于 Firestore）：**

| 计算字段 | 来源 | 计算逻辑 |
|---------|------|---------|
| `stage` | `xp` | kitten（0）、young（100+）、adult（300+）、shiny（600+） |
| `mood` | `lastSessionAt` | happy（24h 内）、neutral（1-3 天）、lonely（3-7 天）、missing（7 天以上） |

**为何不直接存储 `stage` 和 `mood`？**
存储派生值会产生漂移风险（存储值与公式计算值不一致）。通过在读取时从权威输入（`xp` 和 `lastSessionAt`）计算，应用始终显示正确状态，无需后台任务。

**状态转换：**
```
active ──[习惯停用]──► dormant
active ──[习惯删除]──► graduated
dormant ──[习惯重新激活]─► active（未来功能）
```

**Dart 模型：** `lib/models/cat.dart` → `class Cat`

---

## 集合：`users/{uid}/checkIns/{date}/entries/{entryId}`

遗留打卡存储，保留以向后兼容，并用于热力图查询。

`date` 为 ISO 日期字符串 "YYYY-MM-DD"，如 "2026-02-17"。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `habitId` | string | 是 | 父习惯 ID |
| `habitName` | string | 是 | 反规范化的习惯名称（提升读取性能） |
| `minutes` | int | 是 | 本次会话记录的分钟数 |
| `completedAt` | timestamp | 是 | 条目创建时间 |

**Dart 模型：** `lib/models/check_in.dart` → `class CheckInEntry`

---

## 原子操作（批量写入）

跨多个文档的操作使用 Firestore **批量写入** 保证全有或全无的一致性。任意写入失败则整批回滚。

### 1. 习惯 + 猫咪创建（领养流程）
**方法：** `FirestoreService.createHabitWithCat(uid, habit, cat)`

批量操作包括：
1. `SET users/{uid}/habits/{habitId}` — 新习惯文档
2. `SET users/{uid}/cats/{catId}` — 新猫咪文档（含指向习惯的 `boundHabitId`）
3. `UPDATE users/{uid}/habits/{habitId}.catId` — 习惯到猫咪的反向引用

### 2. 专注会话完成
**方法：** `FirestoreService.logFocusSession(uid, session)`

批量操作包括：
1. `SET users/{uid}/habits/{habitId}/sessions/{sessionId}` — 会话记录
2. `UPDATE users/{uid}/habits/{habitId}` — 累加 `totalMinutes`，更新 `currentStreak`、`bestStreak`、`lastCheckInDate`
3. `UPDATE users/{uid}/cats/{catId}.xp` — `xp += session.xpEarned`
4. `UPDATE users/{uid}/cats/{catId}.lastSessionAt` — 设置为当前时间
5. `SET users/{uid}/checkIns/{today}/entries/{entryId}` — 遗留打卡条目（用于热力图）

### 3. 习惯删除（毕业）
**方法：** `FirestoreService.deleteHabit(uid, habitId)`

批量操作包括：
1. `DELETE users/{uid}/habits/{habitId}` — 删除习惯文档
2. `UPDATE users/{uid}/cats/{catId}.state = "graduated"` — 猫咪进入毕业状态

---

## 索引

### 需要的复合索引

| 集合 | 字段 | 顺序 | 用途 |
|------|------|------|------|
| `users/{uid}/habits/{habitId}/sessions` | `habitId ASC`, `endedAt DESC` | 复合 | 按习惯查询会话历史 |
| `users/{uid}/checkIns/{date}/entries` | `habitId ASC`, `completedAt DESC` | 复合 | 按习惯查询热力图数据 |

其他查询使用单字段默认索引。

---

## 数据完整性规则

1. **无孤立猫咪** ：每个猫咪文档必须有有效的 `boundHabitId`，通过批量写入保证。
2. **无孤立习惯引用** ：删除习惯时，绑定猫咪的状态在同一批次中更新为 `"graduated"`。
3. **XP 只增不减** ：`xp` 始终递增，不能设置为更低的值。
4. **阶段是计算值，不存储** ：不向 Firestore 写入 `stage`，始终从 `xp` 派生。
5. **心情是计算值，不存储** ：不向 Firestore 写入 `mood`，始终从 `lastSessionAt` 派生。
6. **`totalMinutes` 是累加的** ：始终使用 `FieldValue.increment(delta)`——不用计算后的总值覆盖（防止竞态条件）。
