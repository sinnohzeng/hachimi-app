# Firebase Analytics 事件（SSOT）

> **SSOT**：本文档是所有自定义分析事件和用户属性的单一权威来源。
> `lib/core/constants/analytics_events.dart` 和 `lib/services/analytics_service.dart` 的代码实现必须与本文档定义完全一致。

---

## 转化漏斗

```
app_open → sign_up → cat_adopted → focus_session_started → focus_session_completed → cat_level_up
```

漏斗中的每一步代表一个有意义的用户行为。在 Firebase Analytics → 漏斗中监控各步骤间的流失率。

---

## 事件定义

### `sign_up`（注册）
- **触发条件**：用户成功注册新账号
- **参数**：`method`（string：`"email"` 或 `"google"`）
- **是否转化**：是（漏斗第 2 步）

### `cat_adopted`（领养猫咪）
- **触发条件**：用户完成 3 步领养流程，成功创建习惯 + 猫咪
- **参数**：
  - `breed`（string）：品种 ID，如 `"orange_tabby"`
  - `pattern`（string）：`"classic_stripe"`、`"spotted"` 或 `"solid"`
  - `personality`（string）：性格 ID，如 `"curious"`
  - `rarity`（string）：`"common"`、`"uncommon"` 或 `"rare"`
  - `is_first_habit`（bool）：`true` 表示这是用户的第一个习惯
- **是否转化**：是（漏斗第 3 步）

### `habit_deleted`（删除习惯）
- **触发条件**：用户删除习惯（猫咪进入毕业状态）
- **参数**：
  - `habit_id`（string）：被删除的习惯 ID
  - `cat_total_xp`（int）：猫咪毕业时的总 XP

### `focus_session_started`（开始专注会话）
- **触发条件**：用户在 FocusSetupScreen 点击「开始专注」并启动计时器
- **参数**：
  - `habit_id`（string）
  - `timer_mode`（string）：`"countdown"` 或 `"stopwatch"`
  - `target_minutes`（int）：预计会话时长
- **是否转化**：是（漏斗第 4 步）

### `focus_session_completed`（完成专注会话）
- **触发条件**：用户完成专注会话（倒计时归零，或用户结束正计时）
- **参数**：
  - `habit_id`（string）
  - `actual_minutes`（int）：实际专注分钟数
  - `xp_earned`（int）：本次会话获得的总 XP
  - `streak_days`（int）：会话结束后的当前连续记录天数
  - `timer_mode`（string）：`"countdown"` 或 `"stopwatch"`
- **是否转化**：是（漏斗第 5 步）—— **核心参与度指标**

### `focus_session_abandoned`（放弃专注会话）
- **触发条件**：用户长按「放弃」按钮并确认
- **参数**：
  - `habit_id`（string）
  - `minutes_completed`（int）：放弃前已专注的分钟数
  - `xp_earned`（int）：获得的 XP（≥ 5 分钟得基础 XP，< 5 分钟为 0）

### `cat_level_up`（猫咪升级）
- **触发条件**：猫咪过渡至新的成长阶段
- **参数**：
  - `cat_id`（string）
  - `new_stage`（string）：`"young"`、`"adult"` 或 `"shiny"`
  - `total_xp`（int）：升级时猫咪的累计总 XP
  - `breed`（string）：猫咪品种 ID
- **是否转化**：是（漏斗第 6 步）

### `streak_achieved`（达成连续记录里程碑）
- **触发条件**：用户连续记录达到里程碑（7、14 或 30 天）
- **参数**：
  - `streak_days`（int）：里程碑值（7、14 或 30）
  - `habit_id`（string）
- **是否转化**：是（里程碑事件标志深度参与）

### `all_habits_done`（所有习惯完成）
- **触发条件**：用户今日完成所有活跃习惯的会话（触发全家福奖励）
- **参数**：
  - `habit_count`（int）：完成的习惯数量
  - `total_bonus_xp`（int）：奖励的全家福 XP

### `cat_room_viewed`（查看猫咪房间）
- **触发条件**：用户打开猫咪房间标签
- **参数**：
  - `cat_count`（int）：房间中活跃猫咪数量

### `cat_tapped`（点击猫咪）
- **触发条件**：用户在猫咪房间点击一只猫咪
- **参数**：
  - `cat_id`（string）
  - `action`（string）：后续操作 —— `"start_focus"`、`"view_details"` 或 `"speech_bubble_dismissed"`

### `notification_opened`（通知打开）
- **触发条件**：用户通过推送通知打开应用
- **参数**：
  - `notification_type`（string）：`"daily_reminder"`、`"streak_at_risk"`、`"level_up"` 或 `"win_back"`

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

通过以下命令启用 DebugView：
```bash
adb shell setprop debug.firebase.analytics.app com.hachimi.hachimi_app
```

- [ ] `sign_up` 在注册时触发，`method` 参数正确
- [ ] `cat_adopted` 在领养流程完成后触发，包含品种、性格、稀有度参数
- [ ] `focus_session_started` 在计时器启动时触发，模式和时长正确
- [ ] `focus_session_completed` 触发，包含实际分钟数和获得 XP
- [ ] `focus_session_abandoned` 在确认放弃时触发
- [ ] `cat_level_up` 在猫咪阶段进化时触发
- [ ] `streak_achieved` 在 7、14、30 天里程碑时触发
- [ ] `all_habits_done` 在今日所有习惯完成时触发
- [ ] `cat_room_viewed` 在打开猫咪房间标签时触发
- [ ] `notification_opened` 在通过通知打开应用时触发
- [ ] 用户属性在领养和会话后正确更新

---

## 代码参考

**事件名称常量**：`lib/core/constants/analytics_events.dart`

**记录方法**：`lib/services/analytics_service.dart`
