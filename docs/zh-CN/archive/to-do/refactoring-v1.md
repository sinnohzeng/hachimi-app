# 一次性全面整改记录（Refactoring v1）

> **创建时间**：2026-02-20
> **状态**：9/11 项已完成，2 项待最终验证
> **审计评级**：B+（7.2/10）→ 目标 A-（8.5+/10）

---

## 整改总览

基于对 70+ Dart 文件的全面代码审计，发现 19 类技术债。本次整改在一次会话中完成了全部代码变更，仅剩最终构建验证未完成。

---

## 已完成项目（1-8）

### 1. 创建共享工具文件 ✅

**新建文件：**

| 文件 | 说明 |
|------|------|
| `lib/core/utils/date_utils.dart` | `AppDateUtils` — 统一 `todayString()` 和 `currentMonth()` 静态方法 |
| `lib/core/utils/streak_utils.dart` | `StreakUtils` — 统一 `calculateNewStreak()` 静态方法 |

**消除了 4 处重复的日期格式化方法和 2 处重复的 streak 计算逻辑。**

---

### 2. 修复 Services 层 ✅

#### 2.1 修复静默吞异常（5 处）

| 文件 | 修改 |
|------|------|
| `atomic_island_service.dart` ×2 | `catch (_)` → `catch (e) { debugPrint(...); }` |
| `llm_service.dart` ×2 | `catch (_)` → `catch (e) { debugPrint(...); }` |
| `local_database_service.dart` ×1 | `catch (_)` → `catch (e) { debugPrint(...); return false; }` |

#### 2.2 消除重复代码

| 文件 | 变更 |
|------|------|
| `firestore_service.dart` | 删除 `_todayDate()` → `AppDateUtils.todayString()`；streak 计算 → `StreakUtils.calculateNewStreak()`；`logFocusSession()` 新增 `habitName` 参数 |
| `coin_service.dart` | 删除 `_todayDate()` / `_currentMonth()` → `AppDateUtils` |
| `diary_service.dart` | 删除 `_todayString()` → `AppDateUtils.todayString()` |
| `local_database_service.dart` | 删除 `_todayString()` → `AppDateUtils.todayString()` |
| `chat_service.dart` | 删除 `_cleanResponse()` → 使用 `_llmService.cleanResponse()`；提取 `_saveAssistantMessage()` 私有方法 |
| `llm_service.dart` | `_cleanResponse()` → public `cleanResponse()` |

#### 2.3 添加输入验证

| 文件 | 变更 |
|------|------|
| `coin_service.dart` | `spendCoins()` 添加 `assert(amount > 0)`；`purchaseAccessory()` 添加 `assert(price > 0)` + `assert(accessoryId.isNotEmpty)` |

#### 2.4 LLM SHA-256

`llm_constants.dart` — 空字符串保留（`model_manager_service.dart` 已跳过 `isEmpty` 的校验），添加了说明注释。

---

### 3. 修复 Providers 层和 app.dart ✅

#### 3.1 拆分 Service Provider

| 文件 | 变更 |
|------|------|
| **新建** `lib/providers/service_providers.dart` | 从 `auth_provider.dart` 迁出 8 个非认证 service provider |
| `auth_provider.dart` | 仅保留 auth 相关 provider + `export service_providers.dart` 向后兼容 |

#### 3.2 清理冗余包装

`focus_timer_provider.dart` — 删除 `_clearSavedState()` wrapper，所有 7 处调用改为 `FocusTimerNotifier.clearSavedState()`。

#### 3.3 修复 dark theme crash

`app.dart` line 44 — `darkDynamic!` → `darkDynamic ?? lightDynamic`（消除 null crash 风险）。

---

### 4. 拆分超大 Screen 文件 ✅

#### cat_detail_screen.dart（1570 行 → 9 个文件）

新建 `lib/screens/cat_detail/components/` 目录：

| 文件 | 组件 |
|------|------|
| `focus_stats_card.dart` | `FocusStatsCard` + `StatCell` |
| `reminder_card.dart` | `ReminderCard` |
| `edit_quest_sheet.dart` | `EditQuestSheet` |
| `cat_info_card.dart` | `EnhancedCatInfoCard` + `InfoRow` |
| `diary_preview_card.dart` | `DiaryPreviewCard` |
| `chat_entry_card.dart` | `ChatEntryCard` |
| `habit_heatmap_card.dart` | `HabitHeatmapCard` + `StageMilestone` |
| `accessories_card.dart` | `AccessoriesCard` |

#### settings_screen.dart（1013 行 → 7 个文件）

新建 `lib/screens/settings/components/` 目录：

| 文件 | 组件 |
|------|------|
| `notification_settings_dialog.dart` | `NotificationSettingsDialog` |
| `language_dialog.dart` | `LanguageDialog` |
| `theme_mode_dialog.dart` | `ThemeModeDialog` |
| `theme_color_dialog.dart` | `ThemeColorDialog` |
| `ai_model_section.dart` | `AiModelSection` + `StatusChip` + `FeatureRow` |
| `section_header.dart` | `SectionHeader` |

---

### 5. 国际化补全 ✅

- 补全 `app_zh.arb` 的 ~30 个 `@` 元数据条目
- 新增 12 个 l10n key（EN + ZH）：`offlineMessage`、`offlineModeLabel`、`habitTodayMinutes`、`habitDeleteTooltip`、`heatmapActiveDays`、`heatmapTotal`、`heatmapRate`、`heatmapLess`、`heatmapMore`、`accessoryEquipped`、`accessoryOwned`、`pickerMinUnit`
- 迁移 5 个 widget 的硬编码字符串：`offline_banner.dart`、`habit_card.dart`、`streak_heatmap.dart`、`accessory_card.dart`、`circular_duration_picker.dart`
- `flutter gen-l10n` 验证通过 ✅

---

### 6. Config、Lint、清理、Accessibility ✅

| 变更 | 详情 |
|------|------|
| SDK 约束 | `pubspec.yaml`：`^3.6.2` → `^3.11.0` |
| Lint 规则 | `analysis_options.yaml` 新增 5 条规则 |
| 废弃常量 | 删除 `pixel_cat_constants.dart` 的 `dailyCheckInCoins` |
| Accessibility | `accessory_card.dart` + `habit_card.dart` 添加 `Semantics` 包装 |
| AI 冗余注释 | `pixel_cat_renderer.dart`（15 处）、`circular_duration_picker.dart`（4 处）、`check_in_banner.dart`（2 处）|

---

### 7. 添加单元测试 ✅

创建 9 个新测试文件，共 **96 个测试用例**，全部通过。

| 测试文件 | 测试数 | 覆盖内容 |
|----------|--------|---------|
| `test/core/utils/date_utils_test.dart` | 4 | 日期格式化 |
| `test/core/utils/streak_utils_test.dart` | 6 | 连续打卡计算 |
| `test/models/cat_test.dart` | 19 | Firestore 序列化、growthProgress、stageName、copyWith |
| `test/models/habit_test.dart` | 14 | progressPercent、progressText、isActive |
| `test/models/focus_session_test.dart` | 6 | 序列化、durationMinutes |
| `test/models/chat_message_test.dart` | 8 | toMap/fromMap、ChatRole enum |
| `test/models/diary_entry_test.dart` | 4 | 序列化 round-trip |
| `test/services/llm_service_test.dart` | 10 | cleanResponse 清理标记 |
| `test/services/xp_service_test.dart` | 20 | XP 计算、streak bonus、milestone、full house |
| `test/services/coin_service_test.dart` | 5 | 输入验证断言（含 Firebase mock） |

---

### 8. 文档同步更新 ✅

| 文档 | 变更 |
|------|------|
| `docs/architecture/folder-structure.md` | 新增 `core/utils/`、`service_providers.dart`、`components/` 目录 |
| `docs/architecture/state-management.md` | 3 个 provider File 引用从 `auth_provider.dart` → `service_providers.dart` |
| `docs/zh-CN/architecture/folder-structure.md` | 镜像同步 |
| `docs/zh-CN/architecture/state-management.md` | 镜像同步 |

---

## 待完成项目（9）

### 9. 最终验证 ⏳

以下验证步骤需在新环境中重新执行：

```bash
# 1. 静态分析（已通过 ✅）
dart analyze lib/

# 2. 本地化生成（已通过 ✅）
flutter gen-l10n

# 3. 运行测试（已通过 ✅ — 96/96）
flutter test

# 4. 构建 debug APK（未完成 — 上次因多任务并发导致机器卡死）
flutter build apk --debug

# 5. 安装到测试设备进行冒烟测试
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
```

**冒烟测试清单：**
- [ ] 打开 app → 走完 onboarding + login
- [ ] 创建习惯 → 领养猫猫
- [ ] 进入猫咪详情页 → 各卡片正常展示
- [ ] 开始专注计时 → 完成 → 完成页展示
- [ ] 设置页 → 切换语言/主题/AI 开关
- [ ] 离线模式 → offline banner 显示中文
- [ ] streak heatmap 显示中文标签

---

## 涉及文件清单

### 新建文件（23 个代码/测试文件）

```
lib/core/utils/date_utils.dart
lib/core/utils/streak_utils.dart
lib/providers/service_providers.dart
lib/screens/cat_detail/components/focus_stats_card.dart
lib/screens/cat_detail/components/reminder_card.dart
lib/screens/cat_detail/components/edit_quest_sheet.dart
lib/screens/cat_detail/components/cat_info_card.dart
lib/screens/cat_detail/components/diary_preview_card.dart
lib/screens/cat_detail/components/chat_entry_card.dart
lib/screens/cat_detail/components/habit_heatmap_card.dart
lib/screens/cat_detail/components/accessories_card.dart
lib/screens/settings/components/notification_settings_dialog.dart
lib/screens/settings/components/language_dialog.dart
lib/screens/settings/components/theme_mode_dialog.dart
lib/screens/settings/components/theme_color_dialog.dart
lib/screens/settings/components/ai_model_section.dart
lib/screens/settings/components/section_header.dart
test/core/utils/date_utils_test.dart
test/core/utils/streak_utils_test.dart
test/models/cat_test.dart
test/models/habit_test.dart
test/models/focus_session_test.dart
test/models/chat_message_test.dart
test/models/diary_entry_test.dart
test/services/llm_service_test.dart
test/services/xp_service_test.dart
test/services/coin_service_test.dart
```

### 修改文件（~25 个）

```
lib/app.dart
lib/services/atomic_island_service.dart
lib/services/llm_service.dart
lib/services/local_database_service.dart
lib/services/firestore_service.dart
lib/services/chat_service.dart
lib/services/coin_service.dart
lib/services/diary_service.dart
lib/services/pixel_cat_renderer.dart
lib/providers/auth_provider.dart
lib/providers/focus_timer_provider.dart
lib/screens/cat_detail/cat_detail_screen.dart
lib/screens/settings/settings_screen.dart
lib/screens/timer/timer_screen.dart
lib/l10n/app_en.arb
lib/l10n/app_zh.arb
lib/widgets/offline_banner.dart
lib/widgets/habit_card.dart
lib/widgets/streak_heatmap.dart
lib/widgets/accessory_card.dart
lib/widgets/circular_duration_picker.dart
lib/widgets/check_in_banner.dart
lib/core/constants/pixel_cat_constants.dart
lib/core/constants/llm_constants.dart
analysis_options.yaml
pubspec.yaml
docs/architecture/folder-structure.md
docs/architecture/state-management.md
docs/zh-CN/architecture/folder-structure.md
docs/zh-CN/architecture/state-management.md
```

### 删除的代码（无文件删除，仅函数/常量移除）

- 各 service 中的重复 `_todayString()` / `_todayDate()` / `_currentMonth()`
- `chat_service.dart` 的 `_cleanResponse()`
- `pixel_cat_constants.dart` 的 `dailyCheckInCoins`
- `focus_timer_provider.dart` 的 `_clearSavedState()` wrapper
- 21 处冗余行内注释（pixel_cat_renderer、circular_duration_picker、check_in_banner）
