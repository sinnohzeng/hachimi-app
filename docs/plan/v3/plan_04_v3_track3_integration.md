---
level: 2
file_id: plan_04
parent: plan_01
status: pending
created: 2026-03-17 23:30
children: []
estimated_time: 600分钟
prerequisites: [plan_03]
---

# 模块：轨道三 — 飞轮桥接 + 导航重组 + 月初仪式

## 1. 模块概述

### 模块目标

轨道三是 V3 觉知伴侣的 **集成层**，负责将轨道一（数据基础）和轨道二（觉知核心 UI）的成果缝合进现有 App 骨架。核心交付：

1. **导航重组**：HomeScreen 从 3 Tab 升级为 4 Tab，觉知 Tab 成为默认首页
2. **飞轮桥接**：FocusCompleteScreen 完成后引导用户记录「一点光」，闭合 **专注 → 觉知 → 猫咪反应** 的产品飞轮
3. **月初仪式**：在觉知 Tab 的「今天」子 Tab 内嵌入 MonthlyRitualCard，完成三幕结构的最后一幕
4. **成就系统扩展**：8 个觉知成就（全部累计制，无连续天数要求）
5. **通知调度**：4 种觉知相关通知
6. **Onboarding 文案刷新**：反映 V3「觉知伴侣」定位

### 在项目中的位置

```
轨道一（数据基础）  ─────────────┐
                                │
轨道二（觉知核心 UI）────────────┤
                                ▼
              ┌──────────────────────────────┐
              │  ★ 轨道三：飞轮桥接 + 导航重组  │  ← 本文档
              │    爆炸半径最大，必须最后做     │
              └──────────────────────────────┘
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
              轨道四（历史视图）        轨道五（模板库）
```

### 风险提示

本轨道修改 `home_screen.dart` 和 `focus_complete_screen.dart`，这两个文件是全 App 流量最密集的入口。**必须在轨道一和轨道二完全稳定后再开始**。

### 关键约束

- 独立开发者，无真实用户，无向后兼容需求
- MVP 零 AI 依赖（猫咪反应使用模板库，不调用 AI）
- 所有成就均为 **累计制**（totalLightDays >= N），不是连续制
- 召回通知最多每 **两周** 一次（非每周）
- 月度目标默认 **20 天**（非 30 天），可灵活设定 10-30

---

## 2. HomeScreen Tab 重组

### 2.1 当前结构

**文件**：`lib/screens/home/home_screen.dart`

当前 3 Tab 布局：

| 索引 | Tab | 屏幕 | 图标 |
|------|-----|------|------|
| 0 | 今日 | `TodayTab` | `Icons.today` |
| 1 | 猫舍 | `CatRoomScreen` | `Icons.pets` |
| 2 | 成就 | `AchievementScreen` | `Icons.emoji_events` |

当前关键行为：
- `_selectedIndex = 0`（默认选中「今日」）
- FAB 仅在 Tab 0 显示（`if (_selectedIndex != 0) return null`）
- FAB 导航到 `AppRouter.adoption`

### 2.2 新结构

新 4 Tab 布局：

| 索引 | Tab | 屏幕 | 图标 | L10n key |
|------|-----|------|------|----------|
| 0 | 觉知 | `AwarenessScreen` | `Icons.auto_awesome` | `homeTabAwareness` |
| 1 | 习惯 | `TodayTab` | `Icons.today` | `homeTabHabits` |
| 2 | 猫咪 | `CatRoomScreen` | `Icons.pets` | `homeTabCatHouse` |
| 3 | 我的 | `ProfileScreen` | `Icons.person` | `homeTabProfile` |

> **注意**：原「成就」Tab 被吸收进「我的」Tab 中的 ProfileScreen，不再作为独立 Tab。

### 2.3 详细代码变更

#### 2.3.1 import 更新

```dart
// 移除
import 'package:hachimi_app/screens/achievements/achievement_screen.dart';

// 新增
import 'package:hachimi_app/screens/awareness/awareness_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';
```

#### 2.3.2 `_screens` 列表

```dart
static const _screens = <Widget>[
  AwarenessScreen(),    // Tab 0: 觉知（默认）
  TodayTab(),           // Tab 1: 习惯
  CatRoomScreen(),      // Tab 2: 猫咪
  ProfileScreen(),      // Tab 3: 我的
];
```

#### 2.3.3 `_selectedIndex` 初始值

```dart
int _selectedIndex = 0; // 不变，但现在 0 = 觉知 Tab
```

#### 2.3.4 `_buildFab` 逻辑

FAB 仅在 Tab 1（习惯）显示：

```dart
Widget? _buildFab(BuildContext context) {
  if (_selectedIndex != 1) return null; // 原 0 → 改为 1
  return FloatingActionButton(
    onPressed: () => Navigator.of(context).pushNamed(AppRouter.adoption),
    tooltip: context.l10n.todayNewQuest,
    child: const Icon(Icons.add),
  );
}
```

#### 2.3.5 `_buildNavDestinations` — 底部导航栏

```dart
List<NavigationDestination> _buildNavDestinations(BuildContext context) {
  final l10n = context.l10n;
  return [
    NavigationDestination(
      icon: const Icon(Icons.auto_awesome_outlined),
      selectedIcon: const Icon(Icons.auto_awesome),
      label: l10n.homeTabAwareness,
    ),
    NavigationDestination(
      icon: const Icon(Icons.today_outlined),
      selectedIcon: const Icon(Icons.today),
      label: l10n.homeTabHabits,
    ),
    NavigationDestination(
      icon: const Icon(Icons.pets_outlined),
      selectedIcon: const Icon(Icons.pets),
      label: l10n.homeTabCatHouse,
    ),
    NavigationDestination(
      icon: const Icon(Icons.person_outline),
      selectedIcon: const Icon(Icons.person),
      label: l10n.homeTabProfile,
    ),
  ];
}
```

#### 2.3.6 `_buildRailDestinations` — 平板侧边栏

同步更新为 4 个 `NavigationRailDestination`，图标和标签与底部导航栏一致。

#### 2.3.7 `_buildMediumLayout` FAB 逻辑

```dart
leading: _selectedIndex == 1 ? _buildFab(context) : null, // 原 0 → 改为 1
```

### 2.4 影响审计

Tab 索引变更会影响所有假设 Tab 索引的代码：

| 受影响代码位置 | 原行为 | 新行为 | 处理方式 |
|--------------|--------|--------|---------|
| `_buildFab` | `_selectedIndex != 0` | `_selectedIndex != 1` | 直接改 |
| `_buildMediumLayout` leading | `_selectedIndex == 0` | `_selectedIndex == 1` | 直接改 |
| AppDrawer（如果有 Tab 切换逻辑） | 可能假设 Tab 0 = 今日 | Tab 0 = 觉知 | 检查并更新 |
| 通知点击导航（payload `habit:xxx`） | 可能需要切换到 Tab 0 | 需要切换到 Tab 1 | 检查 `_pendingNavigation` 消费逻辑 |
| Deep link 路由 | 可能 index 硬编码 | 确认无硬编码 | 全局搜索 `_selectedIndex` |

> **操作**：全局搜索 `selectedIndex`、`homeTabToday`、`Tab 0` 等关键词，确保无遗漏。

---

## 3. FocusCompleteScreen 桥接 Banner

### 3.1 目标

在专注完成后，用一张轻量级卡片引导用户记录「一点光」，闭合飞轮：

```
专注完成 → 看到桥接 Banner → 点击「记录」→ 快速录入一点光 → 猫咪模板反应
```

### 3.2 文件

`lib/screens/timer/focus_complete_screen.dart`

### 3.3 插入位置

在现有 `_buildDoneButton` 之前、Spacer 之前插入：

```dart
// 在 stats Card 和 diary feedback 之后，Spacer 和 Done button 之前
// （约第 486 行 `const Spacer()` 之前）

// 觉知桥接 Banner
if (!widget.isAbandoned)
  _AwarenessBridgeBanner(
    onRecord: () => _showQuickLight(context),
  ),

const Spacer(),
_buildDoneButton(colorScheme, textTheme, l10n),
```

### 3.4 `_AwarenessBridgeBanner` 私有 Widget 规格

```dart
class _AwarenessBridgeBanner extends ConsumerStatefulWidget {
  final VoidCallback onRecord;

  const _AwarenessBridgeBanner({required this.onRecord});

  @override
  ConsumerState<_AwarenessBridgeBanner> createState() =>
      _AwarenessBridgeBannerState();
}

class _AwarenessBridgeBannerState extends ConsumerState<_AwarenessBridgeBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    // 用户已点击跳过，直接隐藏
    if (_dismissed) return const SizedBox.shrink();

    // 如果今天已经记录过一点光，不显示 Banner
    final hasRecorded = ref.watch(hasRecordedTodayLightProvider).value ?? false;
    if (hasRecorded) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.paddingTopMd,
      child: Card(
        color: colorScheme.secondaryContainer,
        child: ListTile(
          leading: const Text('✨', style: TextStyle(fontSize: 24)),
          title: Text(l10n.awarenessBridgePrompt),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => setState(() => _dismissed = true),
                child: Text(l10n.awarenessBridgeSkip),
              ),
              FilledButton.tonal(
                onPressed: widget.onRecord,
                child: Text(l10n.awarenessBridgeRecord),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3.5 快速录入模式

点击「记录」后弹出 DailyLightScreen 的快速模式：

```dart
void _showQuickLight(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => DailyLightScreen(
        quickMode: true,
        scrollController: scrollController,
      ),
    ),
  );
}
```

**快速模式特点**：
- 仅显示 MoodSelector + 一句话输入框（无标签、无时间轴编辑器）
- 保存后自动关闭 BottomSheet
- 保存后触发猫咪模板反应（通过 Provider 自动传播）

### 3.6 新增 Provider

```dart
/// 今日是否已记录一点光
final hasRecordedTodayLightProvider = FutureProvider.autoDispose<bool>((ref) async {
  final repo = ref.watch(awarenessRepositoryProvider);
  final today = DateTime.now();
  final light = await repo.getDailyLight(today);
  return light != null;
});
```

---

## 4. 月初极简仪式

### 4.1 设计定位

月初仪式 **不是** 独立屏幕，而是 AwarenessScreen 的「今天」子 Tab 内的一张卡片。每月 1 日会显示设定提示，之后显示进度追踪。

### 4.2 Widget 定义

**文件**：`lib/widgets/awareness/monthly_ritual_card.dart`

```dart
class MonthlyRitualCard extends ConsumerWidget {
  const MonthlyRitualCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 读取 materialized_state 中的月度仪式数据
    // 根据是否已设定，显示不同 UI
  }
}
```

### 4.3 状态存储方案

使用现有 `materialized_state` 表（key-value 存储），不创建新表：

| Key | 类型 | 说明 | 示例值 |
|-----|------|------|--------|
| `monthly_ritual_habit_id` | String | 选定的习惯 ID | `"abc123"` |
| `monthly_ritual_month` | String | 仪式所属月份 | `"2026-03"` |
| `monthly_ritual_target_days` | String | 目标天数（10-30） | `"20"` |
| `monthly_ritual_reward_text` | String | 用户的奖励承诺 | `"吃一顿火锅"` |
| `monthly_ritual_completed_days` | String | 已完成日期的 JSON 数组 | `'["2026-03-01","2026-03-03"]'` |

> **为什么用 materialized_state 而非新表**：月初仪式本质是一组关联的 key-value 对，复杂度不足以支撑独立表。复用现有 LedgerService 的 `readState` / `writeState` 方法即可。

### 4.4 行为流程

#### 4.4.1 判断当前月是否已设定仪式

```dart
final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
final ritualMonth = await ledgerService.readState(uid, 'monthly_ritual_month');
final hasRitual = ritualMonth == currentMonth;
```

#### 4.4.2 未设定 → 显示设定提示卡

```
┌─────────────────────────────────────────────┐
│  🌙 新的一月，选一个习惯来专注              │
│                                             │
│  选一个这个月最想坚持的习惯，                │
│  设定一个灵活的目标，给自己一个小奖励。      │
│                                             │
│                     [开始设定]              │
└─────────────────────────────────────────────┘
```

点击「开始设定」→ `showDialog`，对话框内容：

1. **习惯选择器**：从 `habitsProvider` 获取习惯列表，下拉选择
2. **目标天数滑块**：`Slider(min: 10, max: 30, value: 20, divisions: 20)`
3. **奖励文案输入**：`TextField(hintText: "完成后我要奖励自己...")`
4. **确认按钮**：保存到 materialized_state（5 个 key 一次性写入）

#### 4.4.3 已设定 → 显示进度卡

```
┌─────────────────────────────────────────────┐
│  📖 三月挑战：阅读                           │
│  完成后奖励：吃一顿火锅 🎁                   │
│                                             │
│  一 二 三 四 五 六 日                        │
│  ○  ●  ○  ●  ●  ○  ○                       │
│  ○  ○  ○  ...                               │
│                                             │
│  已完成 3/20 天 ✨                           │
│  每一天都算数                                │
└─────────────────────────────────────────────┘
```

**30 天网格实现**：

```dart
GridView.count(
  crossAxisCount: 7,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  children: List.generate(daysInMonth, (index) {
    final day = index + 1;
    final date = DateTime(now.year, now.month, day);
    final isCompleted = completedDays.contains(
      DateFormat('yyyy-MM-dd').format(date),
    );
    final isToday = day == now.day;
    final isFuture = date.isAfter(now);

    return _DayDot(
      day: day,
      isCompleted: isCompleted,
      isToday: isToday,
      isFuture: isFuture,
    );
  }),
)
```

**数据来源**：查询 `local_sessions` 表中选定习惯在当月的完成记录：

```dart
final sessions = await db.query(
  'local_sessions',
  where: 'habit_id = ? AND date >= ? AND date <= ?',
  whereArgs: [habitId, monthStart, monthEnd],
);
final completedDays = sessions.map((s) => s['date'] as String).toSet();
```

#### 4.4.4 目标达成状态

| 状态 | 条件 | 显示文案 |
|------|------|---------|
| 进行中 | completedDays < targetDays | `"已完成 X/{target} 天 ✨"` |
| 已达成 | completedDays >= targetDays | `"达成目标！🎉"` |
| 月末未达成 | 月已结束且未达标 | `"完成了 X 天，每一天都有意义"` |

---

## 5. 8 个觉知成就（累计制）

### 5.1 文件

`lib/core/constants/achievement_constants.dart`

### 5.2 新增成就分类

在 `AchievementCategory` 中新增：

```dart
class AchievementCategory {
  AchievementCategory._();

  static const String quest = 'quest';
  static const String cat = 'cat';
  static const String persist = 'persist';
  static const String awareness = 'awareness'; // 新增

  static const List<String> all = [quest, cat, persist, awareness];
}
```

### 5.3 完整成就定义

```dart
// ─── 觉知成就 (Awareness, 8 个) ───

static const List<AchievementDef> awarenessAchievements = [
  // 一点光系列（累计记录天数）
  AchievementDef(
    id: 'light_first',
    category: AchievementCategory.awareness,
    nameKey: 'achievementLightFirstName',
    descKey: 'achievementLightFirstDesc',
    icon: Icons.auto_awesome,
    targetValue: 1,
    coinReward: 50,
  ),
  AchievementDef(
    id: 'light_7',
    category: AchievementCategory.awareness,
    nameKey: 'achievementLight7Name',
    descKey: 'achievementLight7Desc',
    icon: Icons.auto_awesome,
    targetValue: 7,
    coinReward: 100,
  ),
  AchievementDef(
    id: 'light_30',
    category: AchievementCategory.awareness,
    nameKey: 'achievementLight30Name',
    descKey: 'achievementLight30Desc',
    icon: Icons.auto_awesome,
    targetValue: 30,
    coinReward: 300,
  ),
  AchievementDef(
    id: 'light_100',
    category: AchievementCategory.awareness,
    nameKey: 'achievementLight100Name',
    descKey: 'achievementLight100Desc',
    icon: Icons.auto_awesome,
    targetValue: 100,
    coinReward: 500,
  ),
  // 周回顾系列（累计完成次数）
  AchievementDef(
    id: 'review_first',
    category: AchievementCategory.awareness,
    nameKey: 'achievementReviewFirstName',
    descKey: 'achievementReviewFirstDesc',
    icon: Icons.calendar_view_week,
    targetValue: 1,
    coinReward: 50,
  ),
  AchievementDef(
    id: 'review_4',
    category: AchievementCategory.awareness,
    nameKey: 'achievementReview4Name',
    descKey: 'achievementReview4Desc',
    icon: Icons.calendar_view_week,
    targetValue: 4,
    coinReward: 200,
  ),
  // 烦恼处理系列（累计解决/消失数）
  AchievementDef(
    id: 'worry_resolved_1',
    category: AchievementCategory.awareness,
    nameKey: 'achievementWorryResolved1Name',
    descKey: 'achievementWorryResolved1Desc',
    icon: Icons.sentiment_satisfied_alt,
    targetValue: 1,
    coinReward: 50,
  ),
  AchievementDef(
    id: 'worry_resolved_10',
    category: AchievementCategory.awareness,
    nameKey: 'achievementWorryResolved10Name',
    descKey: 'achievementWorryResolved10Desc',
    icon: Icons.sentiment_satisfied_alt,
    targetValue: 10,
    coinReward: 200,
  ),
];
```

### 5.4 注册到全局成就列表

```dart
static final List<AchievementDef> all = [
  ...questAchievements,
  ...hoursAchievements,
  ...catAchievements,
  ...awarenessAchievements, // 新增
  ...persistAchievements,
];
```

### 5.5 AchievementEvaluator 更新

#### 5.5.1 新增 AchievementTrigger 值

```dart
enum AchievementTrigger {
  sessionCompleted,
  habitCreated,
  catAdopted,
  catEvolved,
  checkedIn,
  accessoryEquipped,
  allHabitsDone,
  goalCompleted,
  // V3 觉知新增
  lightRecorded,          // 一点光保存后触发
  weeklyReviewCompleted,  // 周回顾完成后触发
  worryResolved,          // 烦恼标记为已解决/已消失后触发
}
```

#### 5.5.2 扩展 AchievementEvalContext

```dart
class AchievementEvalContext {
  // ... 现有字段 ...

  // V3 觉知新增
  final int totalLightDays;       // 累计记录一点光的天数
  final int totalWeeklyReviews;   // 累计完成周回顾的次数
  final int totalWorriesResolved; // 累计解决/消失的烦恼数

  const AchievementEvalContext({
    // ... 现有参数 ...
    this.totalLightDays = 0,
    this.totalWeeklyReviews = 0,
    this.totalWorriesResolved = 0,
  });
}
```

#### 5.5.3 `_buildContext` 数据查询

```dart
// 在 _buildContext 方法中新增：
final lightDays = await db.rawQuery(
  'SELECT COUNT(DISTINCT date(created_at)) AS cnt FROM local_daily_lights WHERE uid = ?',
  [uid],
);
final totalLightDays = Sqflite.firstIntValue(lightDays) ?? 0;

final reviewCount = await db.rawQuery(
  'SELECT COUNT(*) AS cnt FROM local_weekly_reviews WHERE uid = ?',
  [uid],
);
final totalWeeklyReviews = Sqflite.firstIntValue(reviewCount) ?? 0;

final resolvedCount = await db.rawQuery(
  "SELECT COUNT(*) AS cnt FROM local_worries WHERE uid = ? AND status IN ('resolved', 'disappeared')",
  [uid],
);
final totalWorriesResolved = Sqflite.firstIntValue(resolvedCount) ?? 0;
```

#### 5.5.4 `_checkCondition` 判定逻辑

```dart
bool _checkCondition(AchievementDef def, AchievementEvalContext ctx) {
  switch (def.id) {
    // 一点光系列
    case 'light_first':
    case 'light_7':
    case 'light_30':
    case 'light_100':
      return ctx.totalLightDays >= def.targetValue;

    // 周回顾系列
    case 'review_first':
    case 'review_4':
      return ctx.totalWeeklyReviews >= def.targetValue;

    // 烦恼处理系列
    case 'worry_resolved_1':
    case 'worry_resolved_10':
      return ctx.totalWorriesResolved >= def.targetValue;

    // ... 现有成就判定 ...
  }
}
```

### 5.6 触发时机

| 触发点 | 触发代码位置 | 调用方式 |
|--------|------------|---------|
| 一点光保存后 | `AwarenessRepository.saveDailyLight()` | `achievementEvaluator.evaluate(AchievementTrigger.lightRecorded)` |
| 周回顾完成后 | `AwarenessRepository.saveWeeklyReview()` | `achievementEvaluator.evaluate(AchievementTrigger.weeklyReviewCompleted)` |
| 烦恼标记解决后 | `WorryRepository.updateWorryStatus()` | `achievementEvaluator.evaluate(AchievementTrigger.worryResolved)` |

---

## 6. 通知调度（4 种）

### 6.1 文件

`lib/services/notification_service.dart`

### 6.2 新增通知通道

```dart
static const String _awarenessChannelId = 'hachimi_awareness';
static const String _awarenessChannelName = 'Awareness Reminders';
static const String _awarenessChannelDesc = 'Daily light, weekly review, and monthly ritual reminders';
```

在 `_createNotificationChannels()` 中创建此通道。

### 6.3 通知 ID 分配方案

| 类型 | 通知 ID | 调度方式 | 通知内容 L10n Key | 备注 |
|------|---------|---------|------------------|------|
| 睡前一点光 | `200001` | 每日定时（用户设定，默认 22:00） | `notifBedtimeLight` | 可在设置中配置时间 |
| 周日复盘 | `200002` | 每周日 20:00 | `notifWeeklyReview` | 固定时间 |
| 月初仪式 | `200003` | 每月 1 日 10:00 | `notifMonthlyRitual` | App 启动时检查 `day == 1` |
| 温柔召回 | `200004` | 最后一次一点光后 3 天 | `notifGentleReengagement` | 最多每两周一次 |

### 6.4 新增 SharedPreferences Key

| Key | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `awareness_reminder_hour` | int | 22 | 睡前一点光提醒小时 |
| `awareness_reminder_minute` | int | 0 | 睡前一点光提醒分钟 |
| `last_gentle_reengagement_at` | String | `""` | 上次温柔召回发送时间（ISO 格式） |

### 6.5 各通知详细调度逻辑

#### 6.5.1 睡前一点光（ID: 200001）

```dart
/// 调度每日一点光提醒。
/// 调用时机：App 启动 + 设置页修改提醒时间后。
Future<void> scheduleAwarenessBedtimeReminder({
  required int hour,
  required int minute,
  required String title,
  required String body,
}) async {
  await _localNotifications.cancel(200001);
  await _localNotifications.zonedSchedule(
    id: 200001,
    scheduledDate: sched.nextInstanceOfTime(hour, minute),
    notificationDetails: _awarenessDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: title,
    body: body,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: 'awareness:daily_light',
  );
}
```

#### 6.5.2 周日复盘（ID: 200002）

```dart
/// 调度每周日 20:00 的周回顾提醒。
Future<void> scheduleWeeklyReviewReminder({
  required String title,
  required String body,
}) async {
  await _localNotifications.cancel(200002);
  await _localNotifications.zonedSchedule(
    id: 200002,
    scheduledDate: sched.nextInstanceOfWeekdayTime(
      DateTime.sunday, 20, 0,
    ),
    notificationDetails: _awarenessDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: title,
    body: body,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    payload: 'awareness:weekly_review',
  );
}
```

#### 6.5.3 月初仪式（ID: 200003）

月初仪式不使用 `zonedSchedule`（因为 `matchDateTimeComponents` 不支持「每月 N 日」）。改为在 App 启动时检查：

```dart
/// 在 App 启动时调用，检查是否为每月 1 日且尚未提醒。
Future<void> checkMonthlyRitualReminder({
  required String title,
  required String body,
}) async {
  final now = DateTime.now();
  if (now.day != 1) return;

  // 检查今天是否已经提醒过（用 SharedPreferences 存日期）
  final prefs = await SharedPreferences.getInstance();
  final lastReminded = prefs.getString('monthly_ritual_last_reminded') ?? '';
  final todayStr = DateFormat('yyyy-MM-dd').format(now);
  if (lastReminded == todayStr) return;

  await _localNotifications.show(
    id: 200003,
    title: title,
    body: body,
    notificationDetails: _awarenessDetails,
  );
  await prefs.setString('monthly_ritual_last_reminded', todayStr);
}
```

#### 6.5.4 温柔召回（ID: 200004）

```dart
/// 温柔召回调度逻辑。
/// 调用时机：每次一点光保存后。
Future<void> scheduleGentleReengagement({
  required String title,
  required String body,
}) async {
  // 1. 取消现有召回通知
  await _localNotifications.cancel(200004);

  // 2. 检查上次召回时间，如果 < 14 天前则跳过
  final prefs = await SharedPreferences.getInstance();
  final lastReengagement = prefs.getString('last_gentle_reengagement_at') ?? '';
  if (lastReengagement.isNotEmpty) {
    final lastDate = DateTime.tryParse(lastReengagement);
    if (lastDate != null &&
        DateTime.now().difference(lastDate).inDays < 14) {
      return; // 两周内已发送过，跳过
    }
  }

  // 3. 调度 3 天后的通知
  final fireAt = tz.TZDateTime.now(tz.local).add(const Duration(days: 3));
  await _localNotifications.zonedSchedule(
    id: 200004,
    scheduledDate: fireAt,
    notificationDetails: _awarenessDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: title,
    body: body,
    payload: 'awareness:gentle_reengagement',
  );

  // 4. 记录预期触发时间（而非调度时间），用于 14 天间隔检查
  // 14 天间隔检查基于「上次通知实际触发时间」而非「上次调度时间」
  await prefs.setString(
    'last_gentle_reengagement_at',
    DateTime.now().add(const Duration(days: 3)).toIso8601String(),
  );
}
```

**通知文案原则**：温柔召回使用关怀语气，**不使用操纵性文案**：

- 正确：`"没关系，什么时候回来都好 🌿"`
- 错误：`"猫咪想你了"、"你的猫咪很寂寞"`

### 6.6 通知详情

```dart
static const _awarenessDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    _awarenessChannelId,
    _awarenessChannelName,
    channelDescription: _awarenessChannelDesc,
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  ),
);
```

---

## 7. Analytics 事件

### 7.1 文件

`lib/core/constants/analytics_events.dart`

### 7.2 新增事件名

在 `// Engagement depth` 区块后新增：

```dart
// Awareness
static const String lightRecorded = 'light_recorded';
static const String weeklyReviewCompleted = 'weekly_review_completed';
static const String worryCreated = 'worry_created';
static const String worryResolved = 'worry_resolved';
```

### 7.3 新增参数 Key

在 `// Engagement depth params` 区块后新增：

```dart
// Awareness params
static const String paramMood = 'mood';
static const String paramTagCount = 'tag_count';
static const String paramHappyMomentCount = 'happy_moment_count';
static const String paramWorryStatus = 'worry_status';
static const String paramQuickMode = 'quick_mode';
```

### 7.4 埋点位置

| 事件 | 触发位置 | 参数 |
|------|---------|------|
| `light_recorded` | `AwarenessRepository.saveDailyLight()` 成功后 | `mood`, `tag_count`, `quick_mode` |
| `weekly_review_completed` | `AwarenessRepository.saveWeeklyReview()` 成功后 | `happy_moment_count` |
| `worry_created` | `WorryRepository.createWorry()` 成功后 | 无 |
| `worry_resolved` | `WorryRepository.updateWorryStatus()` 且新状态为 resolved/vanished | `worry_status` |

---

## 8. Onboarding 文案更新

### 8.1 文件

`lib/screens/onboarding/onboarding_screen.dart`

### 8.2 变更说明

无代码结构变更，仅更新 L10n key 的值。现有 key 保持不变：

| Key | 用途 | 旧值（ZH-CN） | 新值（ZH-CN） |
|-----|------|--------------|--------------|
| `onboardTitle1` | 第 1 页标题 | （旧版领养猫咪相关） | `"认识哈奇米"` |
| `onboardSubtitle1` | 第 1 页副标题 | （旧版） | `"你的觉知伴侣"` |
| `onboardBody1` | 第 1 页正文 | （旧版） | `"哈奇米是一只会感应你心情的猫咪，陪你在每天的小事中觉察自己。"` |
| `onboardTitle2` | 第 2 页标题 | （旧版习惯追踪相关） | `"每天 5 分钟"` |
| `onboardSubtitle2` | 第 2 页副标题 | （旧版） | `"记录你的一点光"` |
| `onboardBody2` | 第 2 页正文 | （旧版） | `"睡前记录一个让你微笑的瞬间，选一个心情，写一句话就够了。"` |
| `onboardTitle3` | 第 3 页标题 | （旧版多猫相关） | `"猫咪陪你觉知自己"` |
| `onboardSubtitle3` | 第 3 页副标题 | （旧版） | `"慢慢变好"` |
| `onboardBody3` | 第 3 页正文 | （旧版） | `"专注习惯、记录心情、觉察烦恼。不完美也没关系，猫咪一直在。"` |

> **不需要制作升级引导页**：无真实用户，新用户直接看到新 Onboarding 即可。

---

## 9. L10n Key 清单

### 9.1 导航标签（4 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `homeTabAwareness` | `Awareness` | `觉知` |
| `homeTabHabits` | `Habits` | `习惯` |
| `homeTabCatHouse` | `Cats` | `猫咪` |
| `homeTabProfile` | `Me` | `我的` |

### 9.2 桥接 Banner（3 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `awarenessBridgePrompt` | `Anything made you smile today? ✨` | `今天有什么让你微笑的事？✨` |
| `awarenessBridgeRecord` | `Record` | `记录` |
| `awarenessBridgeSkip` | `Skip` | `跳过` |

### 9.3 月初仪式（12 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `monthlyRitualSetupTitle` | `A new month — pick a habit to focus on` | `新的一月，选一个习惯来专注` |
| `monthlyRitualSetupDesc` | `Choose your focus habit, set a flexible goal, and promise yourself a reward.` | `选一个这个月最想坚持的习惯，设定一个灵活的目标，给自己一个小奖励。` |
| `monthlyRitualSetupButton` | `Set up` | `开始设定` |
| `monthlyRitualDialogTitle` | `Monthly ritual` | `月度仪式` |
| `monthlyRitualHabitLabel` | `Focus habit` | `专注习惯` |
| `monthlyRitualTargetLabel` | `Target days` | `目标天数` |
| `monthlyRitualTargetValue` | `{count} days` | `{count} 天` |
| `monthlyRitualRewardHint` | `Reward myself with...` | `完成后我要奖励自己...` |
| `monthlyRitualRewardLabel` | `Reward` | `奖励` |
| `monthlyRitualProgress` | `{completed}/{target} days done ✨` | `已完成 {completed}/{target} 天 ✨` |
| `monthlyRitualAchieved` | `Goal achieved! 🎉` | `达成目标！🎉` |
| `monthlyRitualEncouragement` | `Every day counts` | `每一天都算数` |

### 9.4 成就名称与描述（16 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `achievementLightFirstName` | `First Light` | `第一缕光` |
| `achievementLightFirstDesc` | `Record your first daily light` | `记录第一个每日一点光` |
| `achievementLight7Name` | `Week of Light` | `一周之光` |
| `achievementLight7Desc` | `Record daily light for 7 days (cumulative)` | `累计记录 7 天一点光` |
| `achievementLight30Name` | `Month of Light` | `月光收集者` |
| `achievementLight30Desc` | `Record daily light for 30 days (cumulative)` | `累计记录 30 天一点光` |
| `achievementLight100Name` | `Century of Light` | `百日之光` |
| `achievementLight100Desc` | `Record daily light for 100 days (cumulative)` | `累计记录 100 天一点光` |
| `achievementReviewFirstName` | `First Review` | `初次回顾` |
| `achievementReviewFirstDesc` | `Complete your first weekly review` | `完成第一次周回顾` |
| `achievementReview4Name` | `Monthly Reviewer` | `每月回顾家` |
| `achievementReview4Desc` | `Complete 4 weekly reviews (cumulative)` | `累计完成 4 次周回顾` |
| `achievementWorryResolved1Name` | `First Release` | `第一次释然` |
| `achievementWorryResolved1Desc` | `Resolve or release your first worry` | `解决或释放你的第一个烦恼` |
| `achievementWorryResolved10Name` | `Worry Whisperer` | `烦恼轻语者` |
| `achievementWorryResolved10Desc` | `Resolve or release 10 worries (cumulative)` | `累计解决或释放 10 个烦恼` |

### 9.5 通知文案（4 个）

| Key | EN | ZH-CN |
|-----|-----|-------|
| `notifBedtimeLight` | `How was your day? Take a moment to notice something good ✨` | `今天过得怎么样？花一点时间，留意一件美好的事 ✨` |
| `notifWeeklyReview` | `Sunday evening — a good time to look back at your week 📖` | `周日晚上，适合回顾这一周 📖` |
| `notifMonthlyRitual` | `A new month begins! Pick a habit to focus on this month 🌙` | `新的一个月开始了！选一个习惯来专注吧 🌙` |
| `notifGentleReengagement` | `No pressure — come back whenever you're ready 🌿` | `没关系，什么时候回来都好 🌿` |

### 9.6 Onboarding 文案（6 个更新）

见第 8 节表格，更新现有 key 的值。

### 9.7 统计

- 新增 key 数量：约 **39 个**
- 更新 key 数量：约 **6 个**（Onboarding）
- 涉及语言：EN + ZH-CN

---

## 10. 文件操作清单

### 10.1 需要修改的文件

| 文件 | 改动内容 | 优先级 |
|------|---------|--------|
| `lib/screens/home/home_screen.dart` | 3 Tab → 4 Tab 重组 | P0 |
| `lib/screens/timer/focus_complete_screen.dart` | 新增桥接 Banner | P0 |
| `lib/core/constants/achievement_constants.dart` | 新增 awareness 分类 + 8 个成就定义 | P1 |
| `lib/core/constants/analytics_events.dart` | 4 个新事件 + 5 个新参数 | P1 |
| `lib/services/notification_service.dart` | 新增觉知通知通道 + 4 种通知调度方法 | P1 |
| `lib/services/achievement_evaluator.dart`（或对应文件） | 新增 3 个 Trigger + 扩展 Context + 判定逻辑 | P1 |
| `lib/l10n/app_en.arb` | ~39 个新 key + ~6 个更新 key | P1 |
| `lib/l10n/app_zh.arb` | ~39 个新 key + ~6 个更新 key | P1 |
| `lib/screens/onboarding/onboarding_screen.dart` | 无代码变更，仅 L10n 值更新 | P2 |
| `lib/core/router/app_router.dart` | 可能需要新增觉知快速录入路由 | P2 |

### 10.2 需要创建的文件

| 文件 | 内容 | 优先级 |
|------|------|--------|
| `lib/widgets/awareness/monthly_ritual_card.dart` | 月初仪式卡片 Widget | P0 |
| `lib/providers/awareness_reminder_provider.dart` | 觉知提醒时间配置 Provider | P1 |

### 10.3 需要读取/参考的文件

| 文件 | 参考内容 |
|------|---------|
| `lib/services/ledger_service.dart` | `readState` / `writeState` 用法 |
| `lib/services/notification_scheduling.dart` | `nextInstanceOfTime` / `nextInstanceOfWeekdayTime` 用法 |
| `lib/models/achievement.dart` | `AchievementDef` 类定义 |
| `lib/screens/profile/profile_screen.dart` | 确认成就入口已在 Profile 中 |

---

## 11. 完成标志

### 11.1 功能验证清单

- [ ] **完整飞轮闭环**：专注完成 → 看到桥接 Banner → 快速录入一点光 → 猫咪模板反应 → 成就触发
- [ ] **4 Tab 导航正确**：觉知为默认 Tab，习惯/猫咪/我的 切换正常
- [ ] **FAB 行为**：仅在习惯 Tab 显示加号按钮
- [ ] **月初仪式设定流程**：选习惯 → 设目标 → 写奖励 → 保存到 materialized_state
- [ ] **月初仪式进度展示**：30 天网格正确渲染，进度文案根据完成情况变化
- [ ] **8 个觉知成就**：在各自累计阈值正确触发，金币奖励正确发放
- [ ] **4 种通知调度**：睡前提醒可配置时间，周日复盘固定时间，月初仪式 App 启动检查，温柔召回 3 天后且 ≤ 每两周一次
- [ ] **通知点击导航**：点击觉知通知能正确跳转到对应页面
- [ ] **Onboarding 更新**：三页新文案正确显示
- [ ] **双主题兼容**：Material 3 和 Retro Pixel 下所有新组件正确渲染

### 11.2 质量门禁

```bash
dart analyze lib/                              # 零 warning / error
flutter test test/models/                      # 模型测试全绿
dart format lib/ test/ --set-exit-if-changed   # 零格式问题
```

### 11.3 手动真机验证场景

1. **新用户首次体验**：Onboarding → 首页默认在觉知 Tab → 空状态提示正确
2. **专注 → 桥接**：完成一次专注 → 看到 Banner → 记录一点光 → 返回后 Banner 消失
3. **月初仪式**：手动修改系统日期为 1 日 → 看到设定卡片 → 完成设定 → 查看进度网格
4. **成就触发**：记录第 1 次一点光 → 解锁「第一缕光」→ 50 金币入账
5. **通知调度**：在设置中修改提醒时间 → 验证通知在正确时间触发

---

## 依赖关系

### 前置条件

- **轨道一（plan_02）**：SQLite 表创建完成、Repository 和 Provider 就绪
- **轨道二（plan_03）**：AwarenessScreen、DailyLightScreen（含 quickMode）、WeeklyReviewScreen、WorryProcessorScreen 已实现并可独立运行

### 后续影响

- **轨道四（plan_05）**：历史视图需要依赖 4 Tab 导航结构（从「我的」Tab 或觉知 Tab 的「回顾」子 Tab 进入）
- **轨道五（plan_06）**：猫咪模板反应通过桥接 Banner 的快速录入路径触发

---

## 风险与缓解

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| HomeScreen Tab 索引变更影响深链接/通知导航 | 通知点击可能跳转到错误 Tab | 全局搜索 `_selectedIndex` 和 Tab 索引硬编码，逐一修正 |
| ProfileScreen 吸收成就 Tab 后内容过多 | 页面过长 | ProfileScreen 使用分组卡片，成就入口折叠为单行快捷入口 |
| 温柔召回通知时机不准 | 用户感受被打扰 | 严格执行 14 天间隔 + 非操纵性文案 |
| 月初仪式 materialized_state 数据一致性 | 旧月数据未清理 | 每次读取时校验 `monthly_ritual_month` 是否为当月 |
