# Cat Detail Screen UI Optimization Plan

## Context

猫猫详情页存在三个待优化问题：
1. Quest 使用独立 emoji 选择器，实际多余 — 用户可直接在名称中输入 emoji
2. "编辑任务"按钮占用标题行空间，导致名称区域过窄且只能 1 行
3. MD3 颜色映射 — `surfaceContainerHighest`（Tone ~90）与 Card surface（Tone ~98）色差仅 ~8，进度条底色 / 热力图空白格 / 里程碑圆点不可见

项目未上线、无真实用户，**彻底清除所有 `icon` 相关代码和 Firestore 字段**，不保留兼容逻辑。

---

## 1. 彻底移除 Habit `icon` 字段

### 1.1 数据模型

**`lib/models/habit.dart`**
- 删除 `icon` 字段声明（line 8）
- 删除构造函数中的 `required this.icon`
- `fromFirestore`: 删除 `icon: data['icon'] ...` 行
- `toFirestore`: 删除 `'icon': icon` 行
- `copyWith`: 删除 `icon` 参数及赋值

### 1.2 Firestore Service

**`lib/services/firestore_service.dart`**
- `createHabit()`: 删除 `icon` 参数和 `'icon': icon` 写入（lines 59, 67）
- `createHabitWithCat()`: 删除 `icon` 参数和 `'icon': icon` 写入（lines 87, 99）
- `updateHabit()`: 删除 `icon` 参数和 `icon` 更新逻辑（lines 136, 144）

### 1.3 Emoji Picker 组件 — 删除

**删除文件**: `lib/widgets/emoji_picker.dart`

### 1.4 创建流程

**`lib/screens/habits/adoption_flow_screen.dart`**
- 删除 `import emoji_picker.dart`（line 9）
- 删除 `_selectedEmoji` 状态变量（line 32）
- 删除 Step 1 中 "Choose an icon" 标题 + `EmojiPicker` 组件块（lines 294-301）
- `createHabitWithCat()` 调用中删除 `icon:` 参数（line 141）

### 1.5 编辑面板

**`lib/screens/cat_detail/components/edit_quest_sheet.dart`**
- 删除 `_iconController`（声明 line 38、init line 50、dispose line 58）
- 删除 emoji TextField + SizedBox（lines 101-110）
- `_save()`: 删除 `icon` 变量及 `icon:` 参数传递

### 1.6 显示层 — 所有引用 `habit.icon` 的 UI

| 文件 | 行 | 当前代码 | 改动 |
|------|-----|---------|------|
| `focus_stats_card.dart` | 60-61 | `Text(habit.icon)` + SizedBox | 删除这两行 |
| `timer_screen.dart` | 367-370 | `Text(habit.icon, fontSize: 20)` + SizedBox | 删除 emoji 行和 SizedBox，只保留 `habit.name` |
| `timer_screen.dart` | 428-429 | `Text(habit.icon, fontSize: 64)` 作为无猫时 fallback | 替换为 `Icon(Icons.self_improvement, size: 64, color: colorScheme.onSurfaceVariant)` |
| `focus_setup_screen.dart` | 147-150 | `Text(habit.icon, fontSize: 64)` 作为无猫时 fallback | 替换为 `Icon(Icons.self_improvement, size: 64, color: colorScheme.onSurfaceVariant)` |
| `home_screen.dart` | 371 | `'${habit.icon} ${habit.name}'` | 改为 `habit.name` |
| `home_screen.dart` | 457-461 | `Text(habit.icon)` 在圆形容器中 | 替换为 `Icon(Icons.flag_outlined, size: 24, color: colorScheme.primary)` |
| `habit_card.dart` | 43 | `iconMap[habit.icon]` 旧版 icon 映射 | 删除 iconMap，固定使用 `Icons.check_circle` |

### 1.7 AI 服务层

**`lib/core/constants/llm_constants.dart`**
- `DiaryPrompt.build()` / `_buildEn()` / `_buildZh()`: 删除 `habitIcon` 参数
- Prompt 文本中 `$habitIcon $habitName` → `$habitName`

**`lib/services/diary_service.dart`**
- line 121: 删除 `habitIcon: habit.icon`

**`lib/services/chat_service.dart`**
- line 164: `'${habit.icon} ${habit.name}'` → `habit.name`

**`lib/screens/cat_room/cat_room_screen.dart`**
- 删除 `habitIcon` 参数（lines 241, 258, 266）
- line 312: `'${habitIcon ?? ""} $habitName'` → `habitName`

### 1.8 L10n 清理

- `app_en.arb`: 删除 `catDetailIconEmoji` key
- `app_zh.arb`: 删除 `catDetailIconEmoji` key

### 1.9 文档更新

- `docs/architecture/data-model.md`: 从 habits schema 中删除 `icon` 字段
- `docs/zh-CN/architecture/data-model.md`: 同步
- `docs/architecture/cat-system.md`: line 235 删除 `habit.icon`
- `docs/zh-CN/architecture/cat-system.md`: line 238 同步
- `docs/architecture/folder-structure.md`: 删除 `emoji_picker.dart` 描述
- `docs/zh-CN/architecture/folder-structure.md`: 同步
- `README.md`: line 136 删除 `emoji_picker.dart` 描述

---

## 2. 重新布局编辑按钮 + 任务名称两行显示

**`lib/screens/cat_detail/components/focus_stats_card.dart`**

### Header Row 改造（lines 58-95）

```
Before: [emoji] [name maxLines:1] [Quest badge] [Edit btn]
After:  [name maxLines:2, ellipsis]  [SizedBox]  [Quest badge]
```

- 移除 emoji Text 和 edit IconButton
- `maxLines` 改为 2，保持 `TextOverflow.ellipsis`
- `Row` 添加 `crossAxisAlignment: CrossAxisAlignment.start`

### 按钮区域改造（lines 150-163）

```
Before: [Start Focus (full width)]
After:  [Edit OutlinedButton.icon] [8px] [Start Focus FilledButton.tonalIcon (Expanded)]
```

- Edit 使用 `OutlinedButton.icon`（MD3 secondary action）
- Start Focus 用 `Expanded` 占满剩余宽度
- Edit 按钮加 `visualDensity: VisualDensity.compact`

### 溢出策略

`maxLines: 2 + TextOverflow.ellipsis` — MD3 Card title 行业标准。不用 marquee/滚动。

---

## 3. 修复 MD3 颜色可见性

**根因**: `surfaceContainerHighest`（Tone ~90）与 Card surface（Tone ~98）色差不足。

**策略**: 统一替换为 `outlineVariant`（Tone ~80），通过 alpha 微调各元素权重。

| 元素 | 文件:行 | Before | After |
|------|---------|--------|-------|
| 进度条底色 | `cat_detail_screen.dart:268` | `surfaceContainerHighest` | `outlineVariant.withValues(alpha: 0.5)` |
| 热力图空白格 | `streak_heatmap.dart:89` | `surfaceContainerHighest` | `outlineVariant.withValues(alpha: 0.3)` |
| 热力图图例空格 | `streak_heatmap.dart:144` | `surfaceContainerHighest` | `outlineVariant.withValues(alpha: 0.3)` |
| 未达成里程碑 | `habit_heatmap_card.dart:164` | `surfaceContainerHighest` | `outlineVariant.withValues(alpha: 0.4)` |

选用 `outlineVariant` 理由：
- 与 card surface 有 ~18 tone 差距，足够可见
- MD3 规范中用于 dividers 和低强调分隔元素
- 全部使用 `colorScheme.outlineVariant`，零硬编码

---

## 实施顺序

1. **Habit model + Firestore service** — 删除 `icon` 字段（基础层）
2. **删除 `emoji_picker.dart`**
3. **adoption_flow_screen** — 移除 emoji picker 使用
4. **edit_quest_sheet** — 移除 emoji 编辑字段
5. **focus_stats_card** — 移除 emoji + 重排 header + 移动 edit 按钮
6. **timer_screen / focus_setup_screen / home_screen / habit_card** — 替换 `habit.icon` 引用
7. **llm_constants + diary_service + chat_service + cat_room_screen** — 清除 AI 层 habitIcon
8. **MD3 颜色修复** — 4 处 `surfaceContainerHighest` 替换
9. **L10n + 文档** — 清理残留引用
10. `dart analyze lib/` 验证

## 涉及文件总览

| 文件 | 类型 |
|------|------|
| `lib/models/habit.dart` | 删除 `icon` 字段 |
| `lib/services/firestore_service.dart` | 删除 `icon` 参数 |
| `lib/widgets/emoji_picker.dart` | **删除整个文件** |
| `lib/screens/habits/adoption_flow_screen.dart` | 移除 picker |
| `lib/screens/cat_detail/components/edit_quest_sheet.dart` | 移除 emoji 字段 |
| `lib/screens/cat_detail/components/focus_stats_card.dart` | 移除 emoji + 重排 |
| `lib/screens/timer/timer_screen.dart` | 替换 fallback |
| `lib/screens/timer/focus_setup_screen.dart` | 替换 fallback |
| `lib/screens/home/home_screen.dart` | 替换引用 |
| `lib/widgets/habit_card.dart` | 移除 iconMap |
| `lib/core/constants/llm_constants.dart` | 删除 habitIcon |
| `lib/services/diary_service.dart` | 删除 habitIcon |
| `lib/services/chat_service.dart` | 删除 icon 拼接 |
| `lib/screens/cat_room/cat_room_screen.dart` | 删除 habitIcon |
| `lib/screens/cat_detail/cat_detail_screen.dart` | 颜色修复 |
| `lib/widgets/streak_heatmap.dart` | 颜色修复 |
| `lib/screens/cat_detail/components/habit_heatmap_card.dart` | 颜色修复 |
| `lib/l10n/app_en.arb` | 删除 key |
| `lib/l10n/app_zh.arb` | 删除 key |
| 6 份 docs 文件 + README | 同步更新 |

## 验证方式

1. `dart analyze lib/` — 无 warning
2. `flutter test` — 现有测试通过
3. 设备测试（浅色 + 深色主题）：
   - 新建 Quest：无 emoji picker，直接输入名称
   - 编辑 Quest：无 emoji 字段
   - 猫猫详情页：名称最多 2 行，编辑按钮在 Start Focus 旁
   - Timer / Focus Setup：无猫时显示 Material icon 而非 emoji
   - 进度条底色 / 热力图空白格 / 里程碑圆点清晰可见
   - 中文 locale 下按钮文字不溢出
