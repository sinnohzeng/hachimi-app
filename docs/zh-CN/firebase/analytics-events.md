# Firebase Analytics 事件（SSOT）

> **SSOT**：本文档是所有自定义分析事件和用户属性的单一权威来源。
> `lib/core/constants/analytics_events.dart` 和 `lib/services/analytics_service.dart` 的代码实现必须与本文档定义完全一致。

---

## 转化漏斗

```
app_open → sign_up → cat_adopted → focus_session_started → focus_session_completed → cat_level_up
```

漏斗中的每一步代表一个有意义的用户行为。在 Firebase Analytics → 漏斗中监控各步骤间的流失率。

### 增强留存漏斗

```
app_opened → onboarding_completed → first_session_completed → streak_achieved(7d) → streak_achieved(30d)
```

---

## 事件定义

### 核心生命周期事件

#### `sign_up`（注册）
- **触发条件**：用户成功注册新账号
- **参数**：`method`（string：`"email"` 或 `"google"`）
- **是否转化**：是（漏斗第 2 步）

#### `onboarding_completed`（引导完成）
- **触发条件**：用户完成引导流程
- **参数**：无
- **代码位置**：`onboarding_screen.dart`

#### `cat_adopted`（领养猫咪）
- **触发条件**：用户完成 3 步领养流程，成功创建习惯 + 猫咪
- **参数**：
  - `breed`（string）：品种 ID，如 `"orange_tabby"`
  - `pattern`（string）：`"classic_stripe"`、`"spotted"` 或 `"solid"`
  - `personality`（string）：性格 ID，如 `"curious"`
  - `rarity`（string）：`"common"`、`"uncommon"` 或 `"rare"`
  - `is_first_habit`（bool）：`true` 表示这是用户的第一个习惯
- **是否转化**：是（漏斗第 3 步）

#### `habit_deleted`（删除习惯）
- **触发条件**：用户删除习惯（猫咪进入毕业状态）
- **参数**：
  - `habit_id`（string）：被删除的习惯 ID
  - `cat_total_xp`（int）：猫咪毕业时的总 XP

### 专注会话事件

#### `focus_session_started`（开始专注）
- **触发条件**：用户点击「开始专注」并启动计时器
- **参数**：
  - `habit_id`（string）
  - `timer_mode`（string）：`"countdown"` 或 `"stopwatch"`
  - `target_minutes`（int）：预计会话时长
- **是否转化**：是（漏斗第 4 步）

#### `focus_session_completed`（完成专注）
- **触发条件**：用户完成专注会话（倒计时归零，或用户结束正计时）
- **参数**：
  - `habit_id`（string）
  - `actual_minutes`（int）：实际专注分钟数
  - `xp_earned`（int）：本次获得的总 XP
  - `streak_days`（int）：会话后的连续天数
  - `timer_mode`（string）：`"countdown"` 或 `"stopwatch"`
- **是否转化**：是（漏斗第 5 步）—— **核心参与度指标**

#### `focus_session_abandoned`（放弃专注）
- **触发条件**：用户长按「放弃」按钮并确认
- **参数**：
  - `habit_id`（string）
  - `minutes_completed`（int）：放弃前已专注的分钟数
  - `xp_earned`（int）：获得的 XP（>= 5 分钟得基础 XP，否则为 0）

#### `first_session_completed`（首次会话完成）
- **触发条件**：用户完成有史以来的第一次专注会话
- **参数**：
  - `habit_id`（string）
  - `actual_minutes`（int）
- **代码位置**：`focus_timer_provider.dart`

#### `session_quality`（会话质量）
- **触发条件**：伴随 `focus_session_completed` 记录会话分析数据
- **参数**：
  - `session_duration`（int）：实际时长（秒）
  - `completion_ratio`（double）：实际/目标比（如 0.85）
- **代码位置**：`focus_timer_provider.dart`

### 猫咪事件

#### `cat_level_up`（猫咪升级）
- **触发条件**：猫咪过渡至新的成长阶段
- **参数**：
  - `cat_id`（string）
  - `new_stage`（string）：`"young"`、`"adult"` 或 `"shiny"`
  - `total_xp`（int）：升级时猫咪的累计总 XP
  - `breed`（string）：猫咪品种 ID
- **是否转化**：是（漏斗第 6 步）

#### `cat_stage_evolved`（猫咪阶段进化）
- **触发条件**：同 `cat_level_up` —— 用于细分，不标记为转化
- **参数**：同 `cat_level_up`

### 参与度事件

#### `feature_used`（功能使用）
- **触发条件**：用户打开特定功能页面
- **参数**：
  - `feature`（string）：功能标识（如 `"cat_chat"`、`"diary"`、`"shop"`、`"inventory"`）
- **代码位置**：各页面 `initState`

#### `ai_chat_started`（AI 聊天开始）
- **触发条件**：用户在猫咪聊天中发送消息
- **参数**：
  - `cat_id`（string）
- **代码位置**：`chat_provider.dart`

#### `ai_diary_generated`（AI 日记生成）
- **触发条件**：AI 日记生成成功完成
- **参数**：
  - `cat_id`（string）
- **代码位置**：`diary_service.dart`

#### `streak_achieved`（达成连续记录里程碑）
- **触发条件**：用户连续记录达到里程碑（7、14 或 30 天）
- **参数**：
  - `streak_days`（int）：里程碑值
  - `habit_id`（string）
- **是否转化**：是

#### `all_habits_done`（所有习惯完成）
- **触发条件**：用户今日完成所有活跃习惯的会话
- **参数**：
  - `habit_count`（int）：完成的习惯数量
  - `total_bonus_xp`（int）：奖励的全家福 XP

### 经济系统事件

#### `coins_earned`（获得金币）
- **触发条件**：用户从任何来源获得金币
- **参数**：
  - `coin_amount`（int）：金币数量
  - `coin_source`（string）：来源（如 `"focus_session"`、`"daily_checkin"`、`"streak_bonus"`）
- **代码位置**：`coin_service.dart`

#### `coins_spent`（消费金币）
- **触发条件**：用户消费金币（购买配饰）
- **参数**：
  - `coin_amount`（int）：消费数量
  - `accessory_id`（string）：购买物品 ID
- **代码位置**：`coin_service.dart`

#### `accessory_purchased`（购买配饰）
- **触发条件**：用户在商店购买配饰
- **参数**：
  - `accessory_id`（string）
  - `price`（int）：金币价格
- **代码位置**：`coin_service.dart`

#### `accessory_equipped`（装备配饰）
- **触发条件**：用户给猫咪装备配饰
- **参数**：
  - `cat_id`（string）
  - `accessory_id`（string）
- **代码位置**：`inventory_service.dart`

### 导航事件

#### `cat_room_viewed`（查看猫咪房间）
- **触发条件**：用户打开猫咪房间标签
- **参数**：`cat_count`（int）

#### `cat_tapped`（点击猫咪）
- **触发条件**：用户在猫咪房间点击猫咪
- **参数**：`cat_id`（string）、`action`（string）

#### `notification_opened`（通知打开）
- **触发条件**：用户通过推送通知打开应用
- **参数**：`notification_type`（string）

### 留存信号

#### `app_opened`（应用打开）
- **触发条件**：用户打开应用（认证完成后）
- **参数**：
  - `days_since_last`（int）：距上次打开的天数
  - `consecutive_days`（int）：当前连续打开天数
- **代码位置**：`app.dart`（`_FirstHabitGateState`）

### 错误追踪

#### `app_error`（应用错误）
- **触发条件**：通过 `ErrorHandler.record()` 记录的任何捕获错误
- **参数**：
  - `error_type`（string）：Dart 运行时错误类型
  - `error_source`（string）：错误发生的类/模块
  - `error_operation`（string）：失败的方法名
- **代码位置**：`lib/core/utils/error_handler.dart`（自动触发）

---

## 用户属性

设置后随值变化更新，用于 Firebase Analytics 中的受众细分。

| 属性 | 类型 | 说明 | 更新时机 |
|------|------|------|---------|
| `cat_count` | int | 活跃猫咪数量（= 活跃习惯数） | 习惯创建/删除时 |
| `max_cat_stage` | string | 所有猫咪中的最高阶段 | 猫咪升级时 |
| `total_cats_ever` | int | 历史领养总数（含已毕业） | 领养猫咪时 |
| `longest_streak` | int | 所有习惯中的最长连续记录 | 每次会话后 |
| `days_active` | int | 距账户创建的天数 | 每次应用打开时 |
| `rare_cats_owned` | int | 稀有度为 `"rare"` 的猫咪数量 | 领养猫咪时 |

---

## DebugView 验证清单

```bash
adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
```

**核心事件：**
- [ ] `sign_up` 在注册时触发，`method` 参数正确
- [ ] `cat_adopted` 在领养流程完成后触发
- [ ] `focus_session_started` 在计时器启动时触发
- [ ] `focus_session_completed` 触发，包含实际分钟数和 XP
- [ ] `focus_session_abandoned` 在确认放弃时触发
- [ ] `cat_level_up` 在猫咪阶段进化时触发
- [ ] `streak_achieved` 在里程碑时触发
- [ ] `all_habits_done` 在今日所有习惯完成时触发
- [ ] `cat_room_viewed` 在打开猫咪房间时触发
- [ ] `notification_opened` 在通过通知打开应用时触发

**新增事件（v2.5）：**
- [ ] `app_error` 在通过 ErrorHandler 捕获错误时触发
- [ ] `feature_used` 在功能页面打开时触发
- [ ] `ai_chat_started` 在用户发送聊天消息时触发
- [ ] `ai_diary_generated` 在日记生成成功时触发
- [ ] `session_quality` 伴随 focus_session_completed 触发
- [ ] `app_opened` 在认证后触发，days_since_last 正确
- [ ] `coins_earned` 触发，金额和来源正确
- [ ] `coins_spent` 在购买配饰时触发
- [ ] `accessory_equipped` 在装备配饰时触发
- [ ] `accessory_purchased` 触发，包含 accessory_id 和 price
- [ ] `onboarding_completed` 在引导结束时触发
- [ ] `first_session_completed` 仅在首次会话时触发

---

## 代码参考

**事件名称常量**：`lib/core/constants/analytics_events.dart`

**记录方法**：`lib/services/analytics_service.dart`

**错误追踪**：`lib/core/utils/error_handler.dart`（自动记录 `app_error` 事件）
