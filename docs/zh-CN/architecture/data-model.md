# 数据模型 — Firestore 模式（SSOT）

> **SSOT**（Single Source of Truth，单一真值来源）：本文档是所有 Firestore 集合、文档模式及数据完整性规则的权威来源。`lib/models/` 和 `lib/services/firestore_service.dart` 的实现必须与此规范完全一致。

---

## 集合层级

```
users/{uid}                          <- 用户基本信息文档
├── habits/{habitId}                 <- 习惯元数据 + 目标追踪
│   └── sessions/{sessionId}        <- 专注会话历史
├── cats/{catId}                     <- 猫咪状态（外观、成长、配饰）
└── monthlyCheckIns/{YYYY-MM}        <- 月度签到追踪（每月重置）
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
| `coins` | int | 是 | 当前金币余额，用于购买配饰（默认值：0） |
| `inventory` | list\<string\> | 是 | 用户级道具箱——已拥有但未装备的配饰 ID 列表（默认值：空列表） |
| `lastCheckInDate` | string | 否 | 最近一次每日签到奖励领取的 ISO 日期字符串 "YYYY-MM-DD" |
| `avatarId` | string | 否 | 预设头像图标 ID，用于用户资料头像。null = 显示首字母缩写 |

**说明：**
- `uid` 是 Firebase Auth UID，同时作为文档 ID 和所有用户数据的顶层命名空间。
- `fcmToken` 在每次应用启动时通过 `NotificationService.initialize()` 更新，目前不支持多设备（后写优先）。
- `coins` 通过 `FieldValue.increment()` 修改以防止竞态条件，不直接设置为计算后的总值。
- `lastCheckInDate` 与今日日期比较，判断是否已领取每日签到奖励。

---

## 集合：`users/{uid}/habits/{habitId}`

每个用户习惯一个文档，`habitId` 由 Firestore 自动生成。

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| `name` | string | 是 | — | 习惯显示名称，如「每日阅读」 |
| `catId` | string | 是 | — | 绑定猫咪文档 ID（位于 `users/{uid}/cats/`） |
| `goalMinutes` | int | 是 | 25 | 每日专注目标分钟数（用于进度显示） |
| `targetHours` | int? | 否 | null | 累计长期目标小时数。`null` 表示永续模式（无目标上限）。设置后用于猫咪成长计算。 |
| `totalMinutes` | int | 是 | 0 | 所有时间累计记录的总分钟数 |
| `deadlineDate` | timestamp? | 否 | null | 里程碑模式的可选截止日期。仅在 `targetHours` 设置时有意义。 |
| `targetCompleted` | bool | 是 | false | 里程碑目标是否已达成。为 `true` 时，任务自动转换为永续模式。 |
| `lastCheckInDate` | string | 否 | null | 最近一次会话的 ISO 日期字符串 "YYYY-MM-DD" |
| `totalCheckInDays` | int | 是 | 0 | 用户在此习惯上累计打卡的不同天数 |
| `reminders` | list\<map\> | 否 | [] | 提醒列表（上限 5 个）。每个 map 包含 `hour`（int）、`minute`（int）、`mode`（string："daily"、"weekdays"、"weekends"、"monday"~"sunday"）。由 `ReminderConfig.tryFromMap()` 解析。 |
| `motivationText` | string | 否 | null | 备忘文本，最长 240 字符 |
| `isActive` | bool | 是 | true | `false` 表示习惯已停用（猫咪进入休眠状态） |
| `createdAt` | timestamp | 是 | — | 习惯创建时间戳 |

**任务模式：**
- **永续模式**（Unlimited mode）：`targetHours == null` —— 无累计目标，无限积累专注时间。
- **里程碑模式**（Milestone mode）：设置 `targetHours`，可选 `deadlineDate` —— 朝着特定小时目标努力。
- **自动转换**：当 `totalMinutes >= targetHours * 60` 时，`targetCompleted` 设为 `true`，任务自动转换为永续模式。

**计算属性：** `isUnlimited` 在 `targetHours == null` 或 `targetCompleted == true` 时返回 `true`。

**Dart 模型：** `lib/models/habit.dart` -> `class Habit`

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
| `targetDurationMinutes` | int | 是 | 计划时长（倒计时目标分钟数；正计时模式为 0） |
| `pausedSeconds` | int | 是 | 本次会话中累计暂停的秒数 |
| `status` | string | 是 | 会话结果：`"completed"`、`"abandoned"` 或 `"interrupted"` |
| `completionRatio` | double | 是 | 实际 / 目标比率（正计时模式为 1.0） |
| `xpEarned` | int | 是 | 会话结束时奖励的 XP（由 `XpService` 计算） |
| `coinsEarned` | int | 是 | 会话结束时奖励的金币（`durationMinutes × 10`；放弃 < 5 分钟则为 0） |
| `mode` | string | 是 | 计时器模式：`"countdown"` 或 `"stopwatch"` |
| `checksum` | string | 否 | HMAC-SHA256 签名，用于防篡改检测 |
| `clientVersion` | string | 是 | 会话创建时的客户端应用版本 |

**说明：** `completed` 布尔字段已移除，替换为 `status` 字符串字段，支持三种状态：completed（已完成）、abandoned（已放弃）、interrupted（已中断）。

**未完成会话的 XP 规则：**
- `status == "abandoned"` 且 `durationMinutes >= 5`：`xpEarned = durationMinutes x 1`（仅基础 XP）
- `status == "abandoned"` 且 `durationMinutes < 5`：`xpEarned = 0`
- `status == "interrupted"`：XP 计算方式与放弃会话相同

**Dart 模型：** `lib/models/focus_session.dart` -> `class FocusSession`

---

## 集合：`users/{uid}/cats/{catId}`

每只猫咪一个文档，`catId` 由 Firestore 自动生成。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `name` | string | 是 | 猫咪名字，如 "Mochi" |
| `appearance` | map | 是 | pixel-cat-maker 外观参数——详见[猫咪系统](cat-system.md)完整参数列表 |
| `personality` | string | 是 | 性格 ID——详见[猫咪系统](cat-system.md) |
| `totalMinutes` | int | 是 | 该猫咪对应习惯累计的专注分钟数。阶段使用固定阈值从此字段计算。 |
| `accessories` | list\<string\> | 是 | **已弃用** —— 旧版按猫存储的配饰列表。已迁移至 `users/{uid}.inventory`。仅在迁移期间使用。 |
| `equippedAccessory` | string | 否 | 当前装备的配饰 ID（null = 未装备） |
| `boundHabitId` | string | 是 | 生成此猫咪的习惯 ID |
| `state` | string | 是 | `"active"`、`"dormant"` 或 `"graduated"` |
| `lastSessionAt` | timestamp | 否 | 最近一次专注会话的时间戳 |
| `highestStage` | string | 否 | 曾达到的最高成长阶段（单调递增；旧猫为 null）。有效值："kitten"、"adolescent"、"adult"、"senior"。 |
| `createdAt` | timestamp | 是 | 猫咪领养时间戳 |

**计算字段（不存储于 Firestore）：**

| 计算字段 | 来源 | 计算逻辑 |
|---------|------|---------|
| `stage` | `totalMinutes` | 固定 200h（12000min）阶梯：kitten（0h）、adolescent（20h/1200min）、adult（100h/6000min）、senior（200h/12000min） |
| `growthProgress` | `totalMinutes` | `totalMinutes / 12000`，上限为 1.0。进度基于固定 200h 阶梯，而非习惯的 `targetHours`。 |
| `mood` | `lastSessionAt` | happy（24h 内）、neutral（1-3 天）、lonely（3-7 天）、missing（7 天以上） |

**为何不直接存储 `stage` 和 `mood`？**
存储派生值会产生漂移风险（存储值与公式计算值不一致）。通过在读取时从权威输入（`totalMinutes` 和 `lastSessionAt`）计算，应用始终显示正确状态，无需后台任务。`highestStage` 是例外——它必须存储，因为它需要单调递增（只升不降），以防止阶段回退。

**状态转换：**
```
active --[习惯停用]--> dormant
active --[习惯删除]--> graduated
dormant --[习惯重新激活]--> active（未来功能）
```

**Dart 模型：** `lib/models/cat.dart` -> `class Cat`
**外观模型：** `lib/models/cat_appearance.dart` -> `class CatAppearance`

---

## 集合：`users/{uid}/monthlyCheckIns/{YYYY-MM}`

每个日历月一个文档，追踪每日签到进度和里程碑领取情况。文档 ID 为月份字符串，如 "2026-02"。

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `checkedDays` | list\<int\> | 是 | 本月已签到的日期号，如 `[1, 2, 5, 8]` |
| `totalCoins` | int | 是 | 本月签到累计获得的金币（每日奖励 + 里程碑奖励） |
| `milestonesClaimed` | list\<int\> | 是 | 已领取的里程碑天数阈值，如 `[7, 14]` |

**说明：**
- 文档在新月份首次签到时创建。
- `checkedDays` 使用 `FieldValue.arrayUnion` 追加，日期号从 1 开始。
- 里程碑（7、14、21、全月）在 `checkedDays` 长度跨过阈值时自动领取。
- 全月奖励在 `checkedDays.length` 等于该月总天数时发放。

**Dart 模型：** `lib/models/monthly_check_in.dart` -> `class MonthlyCheckIn`

---

## 原子操作（批量写入）

跨多个文档的操作使用 Firestore **批量写入** 保证全有或全无的一致性。任意写入失败则整批回滚。

### 1. 习惯 + 猫咪创建（领养流程）
**方法：** `FirestoreService.createHabitWithCat(uid, habit, cat)`

批量操作包括：
1. `SET users/{uid}/habits/{habitId}` — 新习惯文档（`targetHours` 为可选字段，`null` 表示永续模式）
2. `SET users/{uid}/cats/{catId}` — 新猫咪文档，包含 `appearance` Map、`totalMinutes: 0`、`accessories: []` 和指向习惯的 `boundHabitId`
3. `UPDATE users/{uid}/habits/{habitId}.catId` — 习惯到猫咪的反向引用

### 2. 专注会话完成
**方法：** `FirestoreService.logFocusSession(uid, session)`

批量操作包括：
1. `SET users/{uid}/habits/{habitId}/sessions/{sessionId}` — 会话记录
2. `UPDATE users/{uid}/habits/{habitId}` — 累加 `totalMinutes`，更新 `lastCheckInDate`
3. `UPDATE users/{uid}/cats/{catId}.totalMinutes` — `totalMinutes += session.durationMinutes`
4. `UPDATE users/{uid}/cats/{catId}.lastSessionAt` — 设置为当前时间
5. `UPDATE users/{uid}.coins` — `FieldValue.increment(session.coinsEarned)`（专注奖励：`durationMinutes × 10`）

> **注意：** 每日签到奖励不再在此批量操作中发放，由 `CoinService.checkIn()` 通过月度签到系统独立管理。

### 3. 习惯删除（毕业）
**方法：** `FirestoreService.deleteHabit(uid, habitId)`

批量操作包括：
1. `DELETE users/{uid}/habits/{habitId}` — 删除习惯文档
2. `UPDATE users/{uid}/cats/{catId}.state = "graduated"` — 猫咪进入毕业状态

### 4. 习惯更新（编辑）
**方法：** `FirestoreService.updateHabit(uid, habitId, {name?, goalMinutes?, targetHours?, clearTargetHours, reminders?, clearReminders, motivationText?, clearMotivation, deadlineDate?, clearDeadlineDate})`

单文档更新：
1. `UPDATE users/{uid}/habits/{habitId}` — 仅设置提供的字段（`name`、`goalMinutes`、`targetHours`、`deadlineDate`、`reminders`、`motivationText`；若 `clearTargetHours == true`，则将 `targetHours` 设为 `null`；若 `clearReminders == true`，则将 `reminders` 设为 `[]`；若 `clearMotivation == true`，则将 `motivationText` 设为 `null`；若 `clearDeadlineDate == true`，则将 `deadlineDate` 设为 `null`）

**验证**：至少一个字段不为 null 或某个 clear 标志必须为 true，空字符串将被拒绝。

> **注意：** 内部标识符仍为 `habit`，面向用户的术语为 **Quest（任务）**。

### 5. 配饰购买（道具箱模型）

**方法：** `CoinService.purchaseAccessory(uid, accessoryId, price)`

事务操作包括：
1. `READ users/{uid}` — 检查余额和已有道具箱
2. `UPDATE users/{uid}.coins` — `FieldValue.increment(-price)`（扣除费用）
3. `UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([accessoryId])`（加入道具箱）

### 5. 装备配饰
**方法：** `InventoryService.equipAccessory(uid, catId, accessoryId)`

事务操作包括：
1. `UPDATE users/{uid}.inventory` — `FieldValue.arrayRemove([accessoryId])`（从道具箱移除）
2. `READ users/{uid}/cats/{catId}` — 获取当前 `equippedAccessory`
3. 若猫已有装备：`UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([oldAccessoryId])`（旧配饰返回道具箱）
4. `UPDATE users/{uid}/cats/{catId}.equippedAccessory` — 设为 `accessoryId`

### 6. 卸下配饰
**方法：** `InventoryService.unequipAccessory(uid, catId)`

事务操作包括：
1. `READ users/{uid}/cats/{catId}` — 获取当前 `equippedAccessory`
2. `UPDATE users/{uid}.inventory` — `FieldValue.arrayUnion([equippedAccessory])`（返回道具箱）
3. `UPDATE users/{uid}/cats/{catId}.equippedAccessory` — 设为 `null`

### 7. 每日签到（月度系统）
**方法：** `CoinService.checkIn(uid)`

事务操作包括：
1. `READ users/{uid}` — 检查 `lastCheckInDate`；若为今日则提前返回（已签到）
2. `READ users/{uid}/monthlyCheckIns/{YYYY-MM}` — 获取或准备月度文档
3. 计算每日奖励：工作日 = 10 金币，周末（周六/日） = 15 金币
4. 检查新的 `checkedDays.length` 是否跨过里程碑阈值（7、14、21、或全月）
5. `SET/UPDATE users/{uid}/monthlyCheckIns/{YYYY-MM}` — 追加日期到 `checkedDays`，累加 `totalCoins`，追加新里程碑到 `milestonesClaimed`
6. `UPDATE users/{uid}.coins` — `FieldValue.increment(totalReward)`（每日 + 里程碑奖励）
7. `UPDATE users/{uid}.lastCheckInDate` — 设置为今日日期字符串

返回 `CheckInResult`，包含 `dailyCoins`、`milestoneBonus` 和 `newMilestones`。

---

## 索引

### 需要的复合索引

| 集合 | 字段 | 顺序 | 用途 |
|------|------|------|------|
| `users/{uid}/cats` | `state ASC`, `createdAt ASC` | 复合 | `watchCats()` —— 按领养日期排序的活跃猫咪 |
| `users/{uid}/habits/{habitId}/sessions` | `habitId ASC`, `endedAt DESC` | 复合 | 按习惯查询会话历史 |
| `sessions`（集合组） | `endedAt DESC` | 单字段集合组 | 跨习惯会话历史查询 |

其他查询使用单字段默认索引。

---

## 数据完整性规则

1. **无孤立猫咪**：每个猫咪文档必须有有效的 `boundHabitId`，通过批量写入保证。
2. **无孤立习惯引用**：删除习惯时，绑定猫咪的状态在同一批次中更新为 `"graduated"`。
3. **totalMinutes 只增不减**：`totalMinutes` 始终递增，不能设置为更低的值。
4. **阶段是计算值，不存储**：不向 Firestore 写入 `stage`，始终使用固定 200h 成长阶梯从 `totalMinutes` 派生。
5. **心情是计算值，不存储**：不向 Firestore 写入 `mood`，始终从 `lastSessionAt` 派生。
6. **`totalMinutes` 是累加的**：始终使用 `FieldValue.increment(delta)`——不用计算后的总值覆盖（防止竞态条件）。
7. **金币不能为负**：`CoinService` 在扣除前必须验证余额充足。余额不足时购买批量写入应优雅失败。
8. **外观不可变**：`appearance` Map 在猫咪创建时设置，此后不再修改。
9. **会话不可修改**：会话文档一旦创建，不可修改；所有者可删除（账号注销时清理数据）。日常使用中审计轨迹的完整性得到保证。
10. **成就不可修改**：成就文档一旦创建，不可修改；所有者可删除（账号注销时清理数据）。

---

## 安全模型

所有文档按 `uid` 完全隔离。详见[安全规则](../firebase/security-rules.md)完整规则规范。

**访问模式摘要：**
- 用户只能读写自己 `users/{uid}` 路径下的文档。
- 无跨用户数据访问。
- 无公共集合。
- 匿名认证用户在其 `users/{uid}` 路径下享有与普通用户相同的读写权限。未认证访问对所有路径均被拒绝。

**Firestore 安全规则 — 字段校验：**

`firestore.rules` 文件在写操作时强制执行服务端字段校验：

| 集合 | 字段 | 校验规则 |
|------|------|---------|
| `habits` | `targetHours` | `int`（可选，可为 null），存在时范围 `1–10000` |
| `habits` | `goalMinutes` | `int`（可选），范围 `1–480` |
| `habits` | `motivationText` | `string`（可选），长度 `0–240` 字符 |
| `cats` | `name` | `string`，长度 `1–30` 字符 |
| `cats` | `state` | `string`，必须为 `['active', 'graduated', 'dormant']` 之一 |
| `cats` | `totalMinutes` | `int`，`>= 0` |

这些规则与客户端校验互补，防止无效数据写入 Firestore。

**猫咪状态常量：**

有效的猫咪状态值定义于 `lib/core/constants/cat_constants.dart` 的 `CatState` 类中：
- `CatState.active` = `'active'`
- `CatState.graduated` = `'graduated'`
- `CatState.dormant` = `'dormant'`

所有引用猫咪状态字符串的代码必须使用这些常量，而非硬编码字符串字面量。

---

## 本地存储 — SQLite + SharedPreferences

除 Firestore 外，应用还使用本地存储来保存 AI 生成的内容。这些数据不同步到云端，卸载应用时自动删除。

### SQLite 数据库：`hachimi_local.db`

**服务：** `lib/services/local_database_service.dart`

#### 表：`diary_entries`

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `cat_id` | TEXT | NOT NULL | 关联猫咪 |
| `habit_id` | TEXT | NOT NULL | 关联习惯 |
| `content` | TEXT | NOT NULL | 生成的日记文本（2-4 句话） |
| `date` | TEXT | NOT NULL | ISO 日期 "YYYY-MM-DD" |
| `personality` | TEXT | NOT NULL | 生成时的性格快照 |
| `mood` | TEXT | NOT NULL | 生成时的心情快照 |
| `stage` | TEXT | NOT NULL | 生成时的阶段快照 |
| `total_minutes` | INTEGER | NOT NULL | 总分钟数快照 |
| `created_at` | INTEGER | NOT NULL | Unix 时间戳 |

**唯一约束：** `UNIQUE(cat_id, date)` — 每只猫每天最多一条日记。

**Dart 模型：** `lib/models/diary_entry.dart` -> `class DiaryEntry`

#### 表：`chat_messages`

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `cat_id` | TEXT | NOT NULL | 关联猫咪 |
| `role` | TEXT | NOT NULL | `'user'` 或 `'assistant'` |
| `content` | TEXT | NOT NULL | 消息文本 |
| `created_at` | INTEGER | NOT NULL | Unix 时间戳 |

**索引：** `idx_chat_cat_created`（`cat_id, created_at`）用于高效查询最近消息。

**Dart 模型：** `lib/models/chat_message.dart` -> `class ChatMessage`

### SharedPreferences 键（AI 功能）

| 键名 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `ai_features_enabled` | bool | false | AI 功能总开关 |
| `ai_selected_provider` | String | "minimax" | 当前 AI 提供商 ID（`minimax` 或 `gemini`） |

**常量定义：** `lib/core/constants/ai_constants.dart` -> `class AiConstants`

---

### 数据库版本 2 — 本地优先表（v2.18.0+）

数据库从版本 1 升级到版本 2，以支持本地优先架构。这些表镜像 Firestore 模式，作为运行时 SSOT。

#### 表：`action_ledger`

不可变的追加写入日志，记录所有数据变更操作。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | UUID |
| `type` | TEXT | NOT NULL | ActionType 枚举字符串（如 "focus_complete"、"check_in"、"purchase"） |
| `uid` | TEXT | NOT NULL | Firebase Auth UID |
| `started_at` | INTEGER | NOT NULL | 操作开始的 Unix 时间戳 |
| `ended_at` | INTEGER | | 操作结束的 Unix 时间戳（即时操作为 null） |
| `payload` | TEXT | NOT NULL | JSON 编码的操作输入数据 |
| `result` | TEXT | | JSON 编码的操作输出数据 |
| `synced` | INTEGER | NOT NULL DEFAULT 0 | 0 = 未同步，1 = 已同步至 Firestore |
| `synced_at` | INTEGER | | 同步成功的 Unix 时间戳 |
| `sync_attempts` | INTEGER | NOT NULL DEFAULT 0 | 同步重试次数 |
| `sync_error` | TEXT | | 最后一次同步错误信息 |
| `created_at` | INTEGER | NOT NULL | 台账条目创建的 Unix 时间戳 |

**索引：** `idx_ledger_synced`（`synced, created_at`）用于高效同步队列查询。
**索引：** `idx_ledger_type`（`type, uid`）用于按类型过滤查询。

**ActionType 枚举值：** `check_in`、`focus_complete`、`focus_abandon`、`purchase`、`equip`、`unequip`、`habit_create`、`habit_update`、`habit_delete`、`account_created`、`account_linked`、`achievement_unlocked`、`achievement_claimed`

**Dart 模型：** `lib/models/ledger_action.dart` -> `class LedgerAction`、`enum ActionType`

#### 表：`local_habits`

`users/{uid}/habits/{habitId}` Firestore 文档的本地镜像。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | 习惯 ID |
| `uid` | TEXT | NOT NULL | 用户 UID |
| `name` | TEXT | NOT NULL | 习惯显示名称 |
| `cat_id` | TEXT | NOT NULL | 绑定猫咪 ID |
| `goal_minutes` | INTEGER | NOT NULL | 每日专注目标分钟数 |
| `target_hours` | INTEGER | | 累计目标小时数（null = 永续模式） |
| `total_minutes` | INTEGER | NOT NULL DEFAULT 0 | 总累计分钟数 |
| `deadline_date` | TEXT | | 里程碑截止日期 ISO 字符串 |
| `target_completed` | INTEGER | NOT NULL DEFAULT 0 | 1 表示里程碑目标已达成 |
| `last_check_in_date` | TEXT | | 最近会话的 ISO 日期 |
| `reminders` | TEXT | | JSON 编码的提醒列表 |
| `motivation_text` | TEXT | | 备忘文本 |
| `is_active` | INTEGER | NOT NULL DEFAULT 1 | 0 = 已停用 |
| `created_at` | INTEGER | NOT NULL | Unix 时间戳 |

**索引：** `idx_habits_uid`（`uid, is_active`）。

#### 表：`local_cats`

`users/{uid}/cats/{catId}` Firestore 文档的本地镜像。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | 猫咪 ID |
| `uid` | TEXT | NOT NULL | 用户 UID |
| `name` | TEXT | NOT NULL | 猫咪名字 |
| `appearance` | TEXT | NOT NULL | JSON 编码的 CatAppearance |
| `personality` | TEXT | NOT NULL | 性格 ID |
| `total_minutes` | INTEGER | NOT NULL DEFAULT 0 | 累计专注分钟数 |
| `equipped_accessory` | TEXT | | 当前装备的配饰 ID |
| `bound_habit_id` | TEXT | NOT NULL | 绑定习惯 ID |
| `state` | TEXT | NOT NULL | "active"、"dormant"、"graduated" |
| `last_session_at` | INTEGER | | 最近会话的 Unix 时间戳 |
| `highest_stage` | TEXT | | 曾达到的最高成长阶段 |
| `created_at` | INTEGER | NOT NULL | Unix 时间戳 |

**索引：** `idx_cats_uid`（`uid, state`）。

#### 表：`local_sessions`

专注会话文档的本地镜像。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | 会话 ID |
| `uid` | TEXT | NOT NULL | 用户 UID |
| `habit_id` | TEXT | NOT NULL | 父习惯 ID |
| `cat_id` | TEXT | NOT NULL | 获得 XP 的猫咪 |
| `started_at` | INTEGER | NOT NULL | Unix 时间戳 |
| `ended_at` | INTEGER | NOT NULL | Unix 时间戳 |
| `duration_minutes` | INTEGER | NOT NULL | 实际专注分钟数 |
| `target_duration_minutes` | INTEGER | NOT NULL | 计划时长 |
| `paused_seconds` | INTEGER | NOT NULL | 累计暂停时间 |
| `status` | TEXT | NOT NULL | "completed"、"abandoned"、"interrupted" |
| `completion_ratio` | REAL | NOT NULL | 实际 / 目标比率 |
| `xp_earned` | INTEGER | NOT NULL | 奖励 XP |
| `coins_earned` | INTEGER | NOT NULL | 奖励金币 |
| `mode` | TEXT | NOT NULL | "countdown" 或 "stopwatch" |
| `created_at` | INTEGER | NOT NULL | Unix 时间戳 |

**索引：** `idx_sessions_uid_date`（`uid, ended_at`）。
**索引：** `idx_sessions_habit`（`habit_id, ended_at`）。

#### 表：`local_monthly_checkins`

月度签到文档的本地镜像。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | "uid_YYYY-MM" 组合键 |
| `uid` | TEXT | NOT NULL | 用户 UID |
| `month` | TEXT | NOT NULL | "YYYY-MM" 格式 |
| `checked_days` | TEXT | NOT NULL | JSON 编码的已签到日期号列表 |
| `total_coins` | INTEGER | NOT NULL DEFAULT 0 | 月度累计金币 |
| `milestones_claimed` | TEXT | NOT NULL | JSON 编码的已领取里程碑阈值列表 |

**索引：** `idx_checkins_uid`（`uid, month`）。

#### 表：`materialized_state`

计算代价高昂的派生聚合值的键值存储。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `key` | TEXT | PRIMARY KEY | 状态键（如 "coin_balance"、"last_check_in_date"） |
| `value` | TEXT | NOT NULL | 序列化值 |
| `updated_at` | INTEGER | NOT NULL | 最后更新的 Unix 时间戳 |

#### 表：`local_achievements`

已解锁成就的本地记录。

| 列名 | 类型 | 约束 | 说明 |
|------|------|------|------|
| `id` | TEXT | PRIMARY KEY | 成就 ID |
| `uid` | TEXT | NOT NULL | 用户 UID |
| `unlocked_at` | INTEGER | NOT NULL | 解锁的 Unix 时间戳 |
| `claimed` | INTEGER | NOT NULL DEFAULT 0 | 1 表示奖励已领取 |
| `claimed_at` | INTEGER | | 领取的 Unix 时间戳 |

**索引：** `idx_achievements_uid`（`uid`）。

**Dart 模型：** `lib/models/unlocked_achievement.dart` -> `class UnlockedAchievement`

---

### 同步策略

本地优先架构使用 **基于台账的同步** 模式：

1. 所有变更写入 `action_ledger` + 更新本地表，在同一 SQLite 事务中完成
2. `SyncEngine` 处理未同步的操作（`synced = 0`），按 `created_at` 排序
3. 每个操作被转换为对应的 Firestore 批量写入
4. 成功后设置 `synced = 1` 和 `synced_at`
5. 失败时递增 `sync_attempts`，使用指数退避重试
6. `synced = 1` 且超过 90 天的操作自动清理

这确保应用在完全离线状态下正常运行，在网络可用时自动同步至 Firestore。
