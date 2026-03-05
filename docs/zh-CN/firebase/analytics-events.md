# Analytics 事件

> `lib/core/constants/analytics_events.dart` 为事件名 SSOT。

## 事件族
### 认证
- `sign_up`

### 习惯 / 会话
- `habit_created`
- `habit_deleted`
- `focus_session_started`
- `focus_session_completed`
- `focus_session_abandoned`

### 猫咪 / 成就
- `cat_adopted`
- `cat_level_up`
- `achievement_unlocked`

### 经济系统
- `coins_earned`
- `coins_spent`
- `accessory_purchased`
- `accessory_equipped`

### 账户生命周期
- `account_deletion_started`
- `account_deletion_completed`
- `account_deletion_failed`

### 可观测性
- `app_error`
  - 必填参数：
    - `error_type`
    - `error_source`
    - `error_operation`
  - 扩展参数：
    - `correlation_id`
    - `operation_stage`
    - `error_code`

## 已移除 legacy 事件
以下兼容事件已从活跃追踪中移除：
- `timer_started`
- `timer_completed`
- `daily_check_in`
- `goal_progress`

## 实施规则
- 新事件必须先进入 `analytics_events.dart`。
- `AnalyticsService` 必须与常量一一对应。
- 文档与代码必须同次变更同步更新。
