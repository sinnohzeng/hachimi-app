---
level: 2
file_id: plan_04
parent: plan_01
status: pending
created: 2026-03-19
children: []
estimated_time: 600分钟
prerequisites: [plan_03]
---

# 模块：轨道三 — LUMI 集成（Onboarding + 导航 + 通知 + 解锁）

## 1. 模块概述

### 模块目标

轨道三是 LUMI 转型的 **集成层**，负责将轨道一（数据基础）和轨道二（核心 UI）的成果缝合进全新的 LUMI 骨架。核心交付：

1. **新 Onboarding**：LUMI 4 页温暖引导（替换旧猫咪 3 页引导）
2. **3-Tab 导航**：HomeScreen 从 4 Tab 精简为 3 Tab（今天 / 旅程 / 我的）
3. **猫咪系统降级**：移除 `_FirstHabitGate` 强制领养，猫咪退到「我的」二级入口
4. **渐进解锁**：`FeatureGateProvider` 根据记录天数解锁旅程段
5. **通知策略**：4 种温柔通知（睡前一点光 / 周日复盘 / 月初仪式 / 温柔提醒）
6. **Analytics 事件**：7 个新分析事件
7. **Google Play 标题更新 + l10n**

### 在项目中的位置

```
轨道一（数据基础）  ─────────────┐
                                │
轨道二（核心 UI）  ──────────────┤
                                ▼
              ┌──────────────────────────────┐
              │  ★ 轨道三：LUMI 集成          │  ← 本文档
              │    Onboarding + 导航 + 解锁   │
              └──────────────────────────────┘
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
              轨道四（月度/年度）       轨道五（丰富度）
```

### 关键约束

- 独立开发者，无真实用户，无向后兼容需求
- 全新 Schema，无数据库迁移
- MVP 零 AI 依赖（猫咪反应使用模板库，不调用 AI）
- 猫咪不再是入口门槛，降为「我的」Tab 中的可选入口
- 通知文案遵循关怀原则，绝不使用催促/操纵性文案

---

## 2. LUMI Onboarding（4 页）

### 2.1 替换策略

完全替换 `lib/screens/onboarding/onboarding_screen.dart` 中的旧 3 页猫咪引导。

**旧 Onboarding（3 页）**：认识猫咪 → 习惯追踪 → 猫咪陪伴
**新 LUMI Onboarding（4 页）**：欢迎 → 你是谁 → 开始日期 → 使用指南

### 2.2 四页详细规格

#### Page 1: 欢迎

```
┌───────────────────────────────┐
│                               │
│        ✦ ✧ ✦                  │
│    （星星缓缓出现动画）         │
│                               │
│         你好                   │
│      这里是 LUMI               │
│                               │
│  每写一行，都是在为你的          │
│  内心宇宙添一颗星              │
│                               │
│        [继续]                  │
└───────────────────────────────┘
```

- 纯展示页，无输入
- 星星动画使用简单 `AnimatedOpacity` + `AnimatedScale`

#### Page 2: 你是谁

```
┌───────────────────────────────┐
│                               │
│  这本手册的主人是               │
│  ┌─────────────────────┐      │
│  │ [名字输入框]         │      │
│  └─────────────────────┘      │
│                               │
│  你的生日                      │
│  [月] 月 [日] 日               │
│                               │
│        [下一步]                │
└───────────────────────────────┘
```

- 名字：`TextField`，必填，最大 20 字符
- 生日：月+日选择器（无需年份），可选
- 验证：名字非空时才能下一步

#### Page 3: 开始日期

```
┌───────────────────────────────┐
│                               │
│  你想从哪天开始这段旅程？       │
│                               │
│     [日历选择器]               │
│     （默认：今天）              │
│                               │
│  小字：你可以随时修改           │
│                               │
│        [下一步]                │
└───────────────────────────────┘
```

- 日历默认选中今天
- 不允许选未来日期

#### Page 4: 使用指南

```
┌───────────────────────────────┐
│                               │
│  LUMI 只有三件小事             │
│                               │
│  ┌─────────────────────┐      │
│  │ ✦ 睡前写一句         │      │
│  │   今天的一点光        │      │
│  └─────────────────────┘      │
│  ┌─────────────────────┐      │
│  │ ✦ 周末回顾           │      │
│  │   三个幸福时刻        │      │
│  └─────────────────────┘      │
│  ┌─────────────────────┐      │
│  │ ✦ 写下烦恼           │      │
│  │   放进烦恼罐          │      │
│  └─────────────────────┘      │
│                               │
│  准备好了吗？                   │
│        [开始旅程]              │
└───────────────────────────────┘
```

- 点击「开始旅程」→ 保存数据 → 进入 TodayScreen（不经过猫咪领养）

### 2.3 数据存储

Onboarding 数据存入 `materialized_state`：

| Key | 类型 | 说明 | 示例值 |
|-----|------|------|--------|
| `lumi_user_name` | String | 手册主人名字 | `"小明"` |
| `lumi_birthday` | String | 生日（月-日）| `"03-19"` |
| `lumi_start_date` | String | 旅程开始日期 | `"2026-03-19"` |
| `lumi_onboarding_version` | int | Onboarding 版本 | `2` |

### 2.4 Onboarding 后行为

- 标记 `onboardingComplete = true`（SharedPreferences）
- 标记 `hasOnboardedBefore = true`（SharedPreferences）
- 直接进入 TodayScreen（Tab 0）
- **不经过** 猫咪领养流程
- 首次打开 TodayScreen 显示引导气泡：「写下今天的第一束光 ✦」

---

## 3. HomeScreen 3-Tab 导航

### 3.1 旧结构（4 Tab）

| 索引 | Tab | 屏幕 |
|------|-----|------|
| 0 | 觉知 | `AwarenessScreen` |
| 1 | 习惯 | `TodayTab` |
| 2 | 猫咪 | `CatRoomScreen` |
| 3 | 我的 | `ProfileScreen` |

### 3.2 新结构（3 Tab）

| 索引 | Tab | 屏幕 | 图标 | L10n key |
|------|-----|------|------|----------|
| 0 | 今天 | `TodayScreen` | `Icons.auto_awesome` | `homeTabToday` |
| 1 | 旅程 | `JourneyScreen` | `Icons.explore` | `homeTabJourney` |
| 2 | 我的 | `ProfileScreen` | `Icons.person` | `homeTabProfile` |

### 3.3 关键变更

- `_selectedIndex = 0` 默认选中「今天」Tab
- FAB 移除（今天 Tab 的 QuickLightCard 是 inline 组件，无需 FAB）
- 原「觉知」Tab 功能融入「今天」Tab
- 原「习惯」Tab 功能降为月度规划子模块
- 原「猫咪」Tab 降为「我的」Tab 中的二级入口

### 3.4 影响审计

| 受影响代码位置 | 原行为 | 新行为 | 处理方式 |
|--------------|--------|--------|---------|
| `_buildFab` | 显示加号按钮 | 移除 FAB | 删除逻辑 |
| AppDrawer | 可能假设 4 Tab | 3 Tab | 检查并更新 |
| 通知点击导航 | 切换到 Tab 0/1 | 新 Tab 映射 | 检查 payload 消费逻辑 |
| Deep link 路由 | 可能有 Tab 索引硬编码 | 全局搜索确认 | 修正所有硬编码 |

---

## 4. 猫咪系统降级

### 4.1 `_FirstHabitGate` 移除

**当前行为**：`_FirstHabitGate` 在 `AuthGate` 中检查用户是否有习惯，无习惯则强制跳转猫咪领养。

**新行为**：完全绕过 `_FirstHabitGate`，直接进入 HomeScreen。

**实现方式**：在 `AuthGate` 中跳过 `_FirstHabitGate` 检查，或将其替换为直接进入 HomeScreen 的逻辑。

### 4.2 猫咪入口新位置

```
ProfileScreen（Tab 2: 我的）
├── LumiStatsCard（星星统计）
├── CatCompanionCard → CatRoomScreen  ← 二级入口
├── Settings 入口
└── ...
```

`CatCompanionCard` 是一个简单的入口卡片：
- 如果已领养猫咪：显示猫咪名字 + 头像 + 「去看看」
- 如果未领养：显示「领养一只猫咪伴侣？」+ 入口按钮
- 完全可选，不领养不影响任何核心功能

---

## 5. 渐进解锁机制

### 5.1 FeatureGateProvider

```dart
/// 文件：lib/providers/feature_gate_provider.dart
///
/// 根据用户累计记录天数决定功能解锁状态。
final featureGateProvider = FutureProvider<FeatureGate>((ref) async {
  final uid = ref.watch(currentUidProvider);
  final stats = await ref.watch(awarenessStatsProvider.future);
  final totalDays = stats.totalLightDays;

  return FeatureGate(
    todayTab: true,                    // Day 0: 始终可用
    weeklyView: totalDays >= 1,        // Day 1: 记录 1 天
    monthlyView: totalDays >= 3,       // Day 3: 记录 3 天
    yearlyView: totalDays >= 14,       // Day 14: 记录 14 天
    exploreView: totalDays >= 30,      // Day 30: 记录 30 天
    growthReview: totalDays >= 90,     // Day 90: 记录 90 天
  );
});
```

### 5.2 解锁时间表

| 阶段 | 条件 | 解锁内容 |
|------|------|---------|
| Day 0 | 完成 Onboarding | 今天 Tab（每日一点光）|
| Day 1 | 记录 1 天 | 旅程 Tab · 本周视图 |
| Day 3 | 记录 3 天 | 旅程 Tab · 本月视图 |
| Day 14 | 记录 14 天 | 旅程 Tab · 年度视图 |
| Day 30 | 记录 30 天 | 旅程 Tab · 探索（月度活动 6 主题）|
| Day 90 | 记录 90 天 | 成长回望 |

### 5.3 未解锁内容呈现

不使用灰色锁图标或"权限不足"。使用温暖的提示卡片：

> "再记录 X 天，就可以开始年度规划了。不急，慢慢来 ✦"

---

## 6. 通知策略（4 种）

### 6.1 通知通道

```dart
static const String _lumiChannelId = 'hachimi_lumi';
static const String _lumiChannelName = 'LUMI Reminders';
static const String _lumiChannelDesc = 'Daily light, weekly review, and monthly ritual reminders';
```

### 6.2 通知类型

| 类型 | 通知 ID | 调度方式 | 文案 L10n Key | 备注 |
|------|---------|---------|-------------|------|
| 睡前一点光 | `200001` | 每日定时（用户设定，默认 22:00）| `notifBedtimeLight` | 可在设置中配置时间 |
| 周日复盘 | `200002` | 每周日 20:00 | `notifWeeklyReview` | 固定时间 |
| 月初仪式 | `200003` | 每月 1 日 10:00（App 启动检查）| `notifMonthlyRitual` | 不使用 zonedSchedule |
| 温柔提醒 | `200004` | 连续 3 天未记录后触发 | `notifGentleReminder` | 最多每周 1 次 |

### 6.3 通知文案

| Key | EN | ZH-CN |
|-----|-----|-------|
| `notifBedtimeLight` | `Today's little light is waiting for you ✦` | `今天的一点光，在等你 ✦` |
| `notifWeeklyReview` | `A good week! Time to look back ✦` | `这周辛苦了，来回顾一下吧 ✦` |
| `notifMonthlyRitual` | `New month — set a small goal? ✦` | `新的一月，设个小目标？✦` |
| `notifGentleReminder` | `No rush — come back whenever you're ready ✦` | `好久没写了……随时回来 ✦` |

### 6.4 通知设计原则

**绝对不做的通知**：
- 「你今天还没打卡！」
- 「你的连续天数即将中断！」
- 「猫咪想你了 / 猫咪很寂寞」
- 每日弹窗催促

---

## 7. Analytics 事件

### 7.1 文件

`lib/core/constants/analytics_events.dart`

### 7.2 新增事件

```dart
// LUMI Awareness
static const String lightRecorded = 'light_recorded';
static const String weeklyReviewCompleted = 'weekly_review_completed';
static const String worryCreated = 'worry_created';
static const String worryResolved = 'worry_resolved';
static const String weeklyPlanSaved = 'weekly_plan_saved';
static const String monthlyPlanSaved = 'monthly_plan_saved';
static const String yearlyPlanSaved = 'yearly_plan_saved';
```

### 7.3 新增参数 Key

```dart
// LUMI params
static const String paramMood = 'mood';
static const String paramTagCount = 'tag_count';
static const String paramHappyMomentCount = 'happy_moment_count';
static const String paramWorryStatus = 'worry_status';
static const String paramQuickMode = 'quick_mode';
static const String paramPlanType = 'plan_type';
```

### 7.4 埋点位置

| 事件 | 触发位置 | 参数 |
|------|---------|------|
| `light_recorded` | `AwarenessRepository.saveDailyLight()` 成功后 | `mood`, `tag_count`, `quick_mode` |
| `weekly_review_completed` | `AwarenessRepository.saveWeeklyReview()` 成功后 | `happy_moment_count` |
| `worry_created` | `WorryRepository.createWorry()` 成功后 | 无 |
| `worry_resolved` | `WorryRepository.updateWorryStatus()` 且新状态为 resolved/vanished | `worry_status` |
| `weekly_plan_saved` | `JourneyRepository.saveWeeklyPlan()` 成功后 | `plan_type: weekly` |
| `monthly_plan_saved` | `JourneyRepository.saveMonthlyPlan()` 成功后 | `plan_type: monthly` |
| `yearly_plan_saved` | `JourneyRepository.saveYearlyPlan()` 成功后 | `plan_type: yearly` |

---

## 8. Google Play 标题 + l10n

### 8.1 Google Play Store 标题

| 语言 | 标题 |
|------|------|
| zh | Hachimi - 点亮内心宇宙 |
| en | Hachimi - Light Up My Innerverse |
| ja | Hachimi - 心の宇宙を照らす |
| ko | Hachimi - 내면의 우주를 밝히다 |
| 其他 | Hachimi - Light Up My Innerverse |

### 8.2 L10n Key 清单

#### 导航标签（3 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `homeTabToday` | `Today` | `今天` |
| `homeTabJourney` | `Journey` | `旅程` |
| `homeTabProfile` | `Me` | `我的` |

#### Onboarding（约 15 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `onboardWelcome` | `Hello` | `你好` |
| `onboardLumiIntro` | `This is LUMI` | `这里是 LUMI` |
| `onboardSlogan` | `Every line you write adds a star to your inner universe` | `每写一行，都是在为你的内心宇宙添一颗星` |
| `onboardContinue` | `Continue` | `继续` |
| `onboardOwnerTitle` | `The owner of this journal` | `这本手册的主人是` |
| `onboardNameHint` | `Your name` | `你的名字` |
| `onboardBirthday` | `Your birthday` | `你的生日` |
| `onboardNext` | `Next` | `下一步` |
| `onboardStartDate` | `When do you want to start this journey?` | `你想从哪天开始这段旅程？` |
| `onboardStartDateDefault` | `You can change this anytime` | `你可以随时修改` |
| `onboardGuideTitle` | `LUMI has just three small things` | `LUMI 只有三件小事` |
| `onboardGuide1` | `Write one line before bed — today's little light` | `睡前写一句——今天的一点光` |
| `onboardGuide2` | `Weekend review — three happy moments` | `周末回顾——三个幸福时刻` |
| `onboardGuide3` | `Write down worries — put them in the worry jar` | `写下烦恼——放进烦恼罐` |
| `onboardReady` | `Ready?` | `准备好了吗？` |
| `onboardStart` | `Start the journey` | `开始旅程` |

#### 通知文案（4 个）

见第 6.3 节表格。

#### 解锁提示（5 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `unlockWeekly` | `Record 1 day to unlock weekly view. No rush ✦` | `再记录 1 天，就可以开始每周规划了。不急 ✦` |
| `unlockMonthly` | `Record {count} more days to unlock monthly view ✦` | `再记录 {count} 天，就可以开始月度规划了 ✦` |
| `unlockYearly` | `Record {count} more days to unlock yearly view ✦` | `再记录 {count} 天，就可以开始年度规划了 ✦` |
| `unlockExplore` | `Record {count} more days to unlock explore ✦` | `再记录 {count} 天，就可以开始探索了 ✦` |
| `unlockGrowthReview` | `Record {count} more days to unlock growth review ✦` | `再记录 {count} 天，就可以开始成长回望了 ✦` |

---

## 9. 文件操作清单

### 9.1 需要修改的文件

| 文件 | 改动内容 | 优先级 |
|------|---------|--------|
| `lib/screens/onboarding/onboarding_screen.dart` | 替换为 LUMI 4 页 Onboarding | P0 |
| `lib/screens/home/home_screen.dart` | 4 Tab → 3 Tab 重组 | P0 |
| `lib/screens/home/auth_gate.dart` | 绕过 `_FirstHabitGate` | P0 |
| `lib/core/constants/analytics_events.dart` | 7 个新事件 + 6 个新参数 | P1 |
| `lib/services/notification_service.dart` | 新增通知通道 + 4 种通知 | P1 |
| `lib/screens/profile/profile_screen.dart` | 新增猫咪伴侣入口卡片 | P1 |
| `lib/l10n/app_en.arb` | 新增约 30 个 key | P1 |
| `lib/l10n/app_zh.arb` | 新增约 30 个 key | P1 |
| `distribution/whatsnew/` | Google Play 更新说明 | P2 |

### 9.2 需要创建的文件

| 文件 | 内容 | 优先级 |
|------|------|--------|
| `lib/providers/feature_gate_provider.dart` | 渐进解锁 Provider | P0 |
| `lib/models/feature_gate.dart` | FeatureGate 数据类 | P0 |

---

## 10. 完成标志

### 10.1 功能验证清单

- [ ] **LUMI Onboarding**：4 页引导正确展示，名字/生日/日期数据正确保存
- [ ] **Onboarding 后行为**：直接进入 TodayScreen（无猫咪领养）
- [ ] **3 Tab 导航**：今天 / 旅程 / 我的 切换正常
- [ ] **猫咪降级**：未领养不影响核心体验，领养入口在「我的」中可见
- [ ] **渐进解锁**：新用户仅看到今天 Tab 和旅程 Tab 的周视图
- [ ] **4 种通知**：睡前提醒可配置时间，周日复盘固定时间，月初仪式检查，温柔提醒 3 天后
- [ ] **Analytics 事件**：7 个事件在对应操作后正确触发
- [ ] **Google Play 标题**：中英日韩正确显示

### 10.2 质量门禁

```bash
dart analyze lib/                              # 零 warning / error
flutter test test/models/                      # 模型测试全绿
dart format lib/ test/ --set-exit-if-changed   # 零格式问题
```

---

## 依赖关系

### 前置条件

- **轨道一（plan_02）**：SQLite 表创建完成、Repository 和 Provider 就绪
- **轨道二（plan_03）**：TodayScreen、JourneyScreen、WeeklyPlanScreen、WeeklyReviewScreen 已实现

### 后续影响

- **轨道四（plan_05）**：月度/年度视图依赖渐进解锁和 3 Tab 导航结构
- **轨道五（plan_06）**：丰富度功能依赖旅程 Tab 的探索段入口

---

## 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| HomeScreen Tab 缩减影响深链接/通知导航 | 通知点击可能跳转到错误 Tab | 全局搜索 `_selectedIndex` 和 Tab 索引硬编码 |
| Onboarding 数据存储方案不够灵活 | 后续扩展困难 | 使用 `materialized_state` key-value，天然可扩展 |
| 温柔提醒频率控制不精确 | 用户感受被打扰 | 严格执行 7 天间隔 + 非操纵性文案 |
| `_FirstHabitGate` 绕过后残留逻辑 | 死代码 | 彻底移除相关逻辑，不留死代码 |
