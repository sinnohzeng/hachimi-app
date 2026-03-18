# 全项目代码质量审计报告

**日期**：2026-03-17
**审计范围**：`lib/` 全部 283 个 Dart 文件（~47K 行，排除 l10n）
**审计工具**：8 个专业 Agent（code-reviewer, silent-failure-hunter, type-design-analyzer, pr-test-analyzer, code-simplifier, feature-dev:code-reviewer）+ `dart analyze`
**背景**：项目由 OpenAI Codex 全程生成，首次全面代码质量审计

---

## 执行摘要

| 指标 | 数值 |
|------|------|
| 总发现数 | **333** |
| 🔴 Critical | **115** |
| 🟡 Medium | **189** |
| 🟢 Minor | **29** |
| dart analyze 基线 | 7 个 info（零 error/warning） |
| 测试健康评分 | **5/10** |
| 测试文件覆盖率 | **~25%**（50/283 文件有测试） |

### 系统性模式（AI 生成代码的共性问题）

| 模式 | 出现次数 | 严重度 | 描述 |
|------|----------|--------|------|
| Stringly-typed enums | **30+** 处 | 🔴 | String 字段应为 enum（CatState、SessionStatus、LedgerChange.type 等） |
| Silent error swallowing | **20+** 处 | 🔴 | `catch (_) {}`、`SizedBox.shrink()` 错误隐藏、bare catch 无日志 |
| Fire-and-forget async | **15+** 处 | 🔴 | 异步写入无 await、无 try-catch，UI 显示成功但数据未保存 |
| Unsafe deserialization | **15+** 处 | 🔴 | `doc.data()` 无 null guard、`as Type` 硬转换、`jsonDecode` 无 FormatException 保护 |
| 架构层违规 | **6** 处 | 🔴 | core/ 导入 Firebase SDK、services/ 导入 providers/、screens/ 导入 services/ |
| 零测试的关键路径 | **3** 个文件 | 🔴 | LedgerService + LocalDatabaseService + SyncEngine（持久化核心零覆盖） |
| 代码重复 | **3** 组 | 🟡 | `_decodeInventory` ×3、`_computeStage` ×2、awareness stats upsert ×2 |
| 函数超长 | **10+** 个 | 🟡 | 最严重：`generateRandomAppearance` 123 行（限制 30 行） |

---

## Phase 0: dart analyze 基线

```
7 issues found (all info-level):
- lib/screens/timer/timer_screen.dart: 4x avoid_dynamic_calls
- lib/services/session_completion_service.dart: 3x avoid_dynamic_calls
```

Firebase Security Rules：未验证（需 Firebase CLI 登录）

---

## Phase 1: Core + Models（80 文件，~9.4K 行）

### 🔴 Critical（28 个）

**架构违规（4 个）：**
- `core/utils/error_handler.dart:1-2` — 直接导入 firebase_analytics + firebase_crashlytics，违反 core/ 不应依赖 Firebase SDK
- `core/utils/deferred_init.dart:5-6` — 导入 services/firebase/ 和 services/，依赖箭头反向
- `core/utils/performance_traces.dart:1` — 直接导入 firebase_performance
- `core/utils/auth_error_mapper.dart:1` — 直接导入 firebase_auth

**Firestore 安全（4 个 doc.data() 无 null guard）：**
- `models/cat.dart:84` — `doc.data() as Map<String, dynamic>` 缺 `?? {}`
- `models/habit.dart:86` — 同上
- `models/focus_session.dart:50` — 同上
- `models/achievement.dart:46` — 同上

**反序列化硬转换（8+ 个）：**
- `models/diary_entry.dart:27-39` — 全部字段 `as String` / `as int` 无 null 安全
- `models/chat_message.dart:43-50` — 同上
- `models/cat.dart:165` — `created_at as int` 无 null 检查
- 及多个模型的 `fromSqlite` 中 `as int` 硬转换

**错误处理（3 个空 catch）：**
- `core/utils/error_handler.dart:43,60,95` — 错误报告基础设施自身有 3 个空 catch 块

**测试缺口（6 个 Critical gap）：**
- `models/json_helpers.dart` — 无测试，所有 awareness 模型依赖它
- `models/ledger_action.dart` — 无测试，审计日志的序列化
- `core/utils/date_utils.dart` — `isoWeekId` 未测试（ISO 周年界算法）
- `models/reminder_config.dart` — 验证逻辑未测试
- Cat/FocusSession `fromSqlite` roundtrip — 缺失
- `models/monthly_check_in.dart` — `List<int>.from()` 可崩溃

**类型安全（3 个 Red）：**
- 4 个旧模型 `doc.data()` 无 null guard（与上面重叠）
- `DiaryEntry.fromMap` 全硬转换
- `ChatMessage.fromMap` 全硬转换

**Observability 逻辑 Bug：**
- `core/observability/observability_tags.dart:41-42` — `isAllowedKey` 的 PII 过滤阻止了 `function_name` 和 `model_name` 被发送到 Crashlytics，尽管它们在 allowedExtras 列表中

### 🟡 Medium（26 个）

- 大量 stringly-typed 字段：Cat.state、Cat.personality、FocusSession.status/mode、AchievementDef.category
- `WeeklyReview` happyMoment1/2/3 重复结构应为 `List<HappyMoment>`
- `MonthlyCheckIn` 用 `List<int>.from()` 应为 `whereType<int>()`
- Backend 接口缺少错误契约
- `awareness_constants.dart` 硬编码中文 preset tags

---

## Phase 2: Providers（26 文件，~3K 行）

### 🔴 Critical（18 个）

**架构 & 数据完整性：**
- **`ai_provider.dart:14` + `service_providers.dart:86` — 两个独立的 LocalDatabaseService 实例（split-brain）** ← 被 3 个 Agent 独立发现，最高确信度
- `user_profile_notifier.dart:3` — Provider 直接导入 firebase_crashlytics
- `achievement_provider.dart:38` + `coin_provider.dart:68` — Provider 中直接写 SQL

**Fire-and-forget SharedPreferences：**
- `user_profile_notifier.dart:96-98` — 登出时 3 个 prefs 写入未 await
- `auth_provider.dart:69-70` — onboarding 标记未 await
- `ai_provider.dart:71` — `_load()` fire-and-forget 无错误处理

**崩溃风险：**
- `timer_persistence.dart:99,119` — `TimerMode.values[modeIndex]` 无越界检查 ← 被 3 个 Agent 独立发现

**类型安全：**
- `awarenessStatsProvider` 返回 `Map<String, int>` 而非类型化 struct
- `getSavedSessionInfo()` 返回 `Map<String, dynamic>?`
- `LedgerChange.type` 是 String 而非 ActionType enum

**测试缺口：**
- 62% 的 provider 文件零测试覆盖
- AI 断路器、ChatNotifier、GuestUpgradeCoordinator、UserProfileNotifier.logout 未测试

### 🟡 Medium（26 个）

- `AccessoryInfo.category` String → enum
- `ChatNotifier` catId 不一致风险
- `FocusTimerState` 15 字段混合了 L10N 标签和计时器状态
- `SessionHistoryState.error` 用 `e.toString` tear-off（可读性差）
- 多个 provider 的 `_persist()` 无 `.catchError()`

---

## Phase 3: Services（37 文件，~8.2K 行）⚠️ 最高风险

### 🔴 Critical（22 个）

**数据完整性（最危险）：**
- **`sync_engine.dart:349-579` — 7 处静默跳过 sync：payload 字段为 null 时 early return，但动作被标记为已同步** ← 永久数据丢失，零日志
- **`firebase_sync_backend.dart:71-74` — hydration 失败返回空数据，标记为成功** ← 用户云端数据永久丢失
- **`session_completion_service.dart:220-251` — `_persistSession` catch 吞没错误，调用者收到"成功"结果**
- `sync_engine.dart:136` — `userDoc.data()!` 不安全的强制解包

**架构违规：**
- `session_completion_service.dart:8` — Service 导入 providers/（focus_timer_provider）
- `account_deletion_service.dart:2` — Service 导入 providers/（timer_persistence）

**内存泄漏：**
- **`pixel_cat_renderer.dart:533-539` — LRU 缓存驱逐未 dispose ui.Image，原生 GPU 纹理泄漏**

**函数超长（严重违规）：**
- `pixel_cat_generation_service.dart:24-146` — `generateRandomAppearance()` **123 行**（限制 30 行，超 4 倍）
- `account_deletion_orchestrator.dart:95-182` — `_attemptRemoteDeletion()` 88 行
- `inventory_service.dart:16-96` — `equipAccessory()` 81 行
- `inventory_service.dart:99-166` — `unequipAccessory()` 68 行

**未保护的 jsonDecode：**
- `coin_service.dart:292` — `_decodeInventory` 无 FormatException 保护
- `inventory_service.dart:168` — 同上

**测试零覆盖（3 个最关键文件）：**
- **`ledger_service.dart`（291 行）— 所有写操作的基础，零测试**
- **`local_database_service.dart`（506 行）— Schema 迁移，零测试**
- **`sync_engine.dart`（674 行）— Firestore 同步，零测试**

### 🟡 Medium（48 个）

- `notification_service.dart` 4 处 `debugPrint` 应为 `ErrorHandler.recordOperation`
- `diary_service.dart` 3 处 `jsonDecode` 无 try-catch
- `coin_service.dart:47` — `finally` 块即使在失败时也触发 `notifyChange`
- `local_database_service.dart:46-67` — 完整性检查删除整个 DB 无用户通知
- 大量 stringly-typed 值：Cat state/stage、SessionStatus、ReminderConfig.mode
- 代码重复：`_decodeInventory` ×3、`_computeStage` ×2、stats upsert ×2
- `sync_engine.dart:278` — `_syncAction` 14 分支 switch（超 10 分支天花板）

---

## Phase 4: Widgets（64 文件，~9.7K 行）

### 🔴 Critical（17 个）

**经典反模式：**
- `check_in_banner.dart:79` — `error: (_, _) => SizedBox.shrink()` ← 被 3 个 Agent 独立发现
- `check_in_banner.dart:59` — `on Exception {}` 无绑定
- `monthly_ritual_card.dart:32-35` — SizedBox.shrink + 误导性注释

**TextEditingController 泄漏：**
- `quest_form_dialogs.dart:12,58` — 对话框中创建 controller 从未 dispose

**Fire-and-forget：**
- `tappable_cat_sprite.dart:76` — SQLite 写入无 await 无错误处理

**类型安全：**
- `CatBedtimeAnimation.mood` 是 `int` 应为 `Mood` enum
- `MoodSelector` 用 `int` 应为 `Mood`
- `AccessoryInfo.category` String → enum
- `stageColor()` 接受 String 应为 CatStage enum

**l10n 违规：**
- `mood_calendar.dart:145-158` — 硬编码英文/中文月份名

### 🟡 Medium（23 个）

- `celebration_overlay.dart:269` — 过宽 catch
- `pixel_cat_sprite.dart:72` — 视觉回退无日志
- `app_drawer.dart:413` — FutureBuilder 忽略 error 状态
- `streak_indicator.dart:16` — 硬编码英文 Semantics label
- `chip_selector_row.dart:42` — 硬编码 `'Custom'` 默认值

---

## Phase 5: Screens（73 文件，~16K 行）

### 🔴 Critical（10 个）

**SizedBox.shrink 错误隐藏：**
- `home/components/today_tab.dart:54-55` — 猫数据加载失败隐藏
- `achievements/components/overview_weekly_trend.dart:39` — 空盒子
- `achievements/components/overview_heatmap_card.dart:36` — 空盒子
- `achievements/components/overview_recent_sessions.dart:34` — 空盒子

**Fire-and-forget 数据操作：**
- `home/components/today_tab.dart:223-237` — 习惯删除无 try-catch
- `cat_room/inventory_screen.dart:207-218` — 装备/卸下无 await 无错误处理
- `settings/settings_screen.dart:437-441` — 访客数据重置无错误处理
- `cat_detail/components/edit_quest_sheet.dart:452` — 习惯更新无 try-catch

**架构违规：**
- `timer/timer_screen.dart:18-19` — Screen 直接导入 Services

**l10n 违规：**
- `awareness/daily_detail_screen.dart:163-165` — 硬编码中文星期名

### 🟡 Medium（15 个）

- 2 个 TextEditingController 泄漏（edit_name_dialog、delete_account_flow）
- 4 个 bare `catch (_)` 无日志
- `adoption_flow_screen.dart:152` — `on Exception` 无绑定
- 多处 fire-and-forget analytics 调用

---

## Phase 6: 测试层

### 整体评分：5/10

| 测试维度 | 评分 | 说明 |
|----------|------|------|
| 测试架构 | 7/10 | 目录镜像 lib/，无 mockito，Hand-written Fakes |
| 覆盖广度 | 3/10 | 仅 25% 文件有测试，整个持久化层零覆盖 |
| 覆盖深度 | 5/10 | 有测试的文件质量不错，但多数是浅层"能跑"测试 |
| 错误路径测试 | 2/10 | 几乎无失败场景测试 |
| 集成测试 | 0/10 | 无集成测试 |

### 最需要的 10 个测试文件

| 优先级 | 文件 | 风险 |
|--------|------|------|
| P0 | `ledger_service_test.dart` | 所有写操作基础 |
| P0 | `sync_engine_test.dart` | Firestore 同步 + hydration |
| P0 | `local_database_service_test.dart` | Schema 迁移 |
| P1 | `awareness_repository_test.dart` | V3 核心数据层 |
| P1 | `ledger_action_test.dart` | 审计日志序列化 |
| P1 | `worry_repository_test.dart` | V3 数据操作 |
| P2 | `cat_appearance_test.dart` | 复杂序列化 |
| P2 | `awareness_providers_test.dart` | V3 状态管理 |
| P2 | `achievement_evaluator_test.dart` | 20+ 谓词逻辑 |
| P2 | `guest_upgrade_coordinator_test.dart` | 数据迁移决策 |

---

## Top 10 高风险文件排名

| 排名 | 文件 | 行数 | 风险因素 |
|------|------|------|----------|
| 1 | `services/sync_engine.dart` | 674 | 7 处静默 sync 跳过、`data()!`、14 分支 switch、零测试 |
| 2 | `services/ledger_service.dart` | 291 | 所有写操作基础、`migrateUid` 复杂逻辑、零测试 |
| 3 | `services/local_database_service.dart` | 506 | Schema 迁移、完整性检查删全库、零测试 |
| 4 | `core/utils/error_handler.dart` | ~100 | 错误报告基础设施有 3 个空 catch + 直接导入 Firebase |
| 5 | `services/session_completion_service.dart` | ~200 | catch 吞没错误 + 导入 providers/ |
| 6 | `providers/ai_provider.dart` | 232 | 重复 LocalDatabaseService + fire-and-forget _load |
| 7 | `services/pixel_cat_renderer.dart` | 540 | 原生内存泄漏（ui.Image 未 dispose） |
| 8 | `models/diary_entry.dart` | ~80 | 全硬转换无 null 安全 |
| 9 | `services/firebase_sync_backend.dart` | ~100 | hydration 失败返回空数据标记成功 |
| 10 | `widgets/check_in_banner.dart` | 225 | SizedBox.shrink + unbound Exception |

---

## V3 vs 旧代码质量对比

| 维度 | V3 Awareness 代码 | 旧 Codex 代码 |
|------|-------------------|---------------|
| 错误处理 | `on Exception catch (e)` + ErrorState + debugPrint | `catch (_) {}` 或 `SizedBox.shrink()` |
| Firestore 安全 | `doc.data() as Map? ?? {}` | `doc.data() as Map<String, dynamic>` |
| 类型安全 | `Mood` enum 贯穿全栈 | String 常量、`Map<int, String>` |
| 测试 | DailyLight/WeeklyReview/Worry 有 roundtrip 测试 | Cat/FocusSession 只测 toFirestore |
| l10n | 全部通过 `context.l10n` | 硬编码中文/英文混合 |

**结论：经过审查流程的 V3 代码质量显著高于未审查的旧代码。这验证了 Track-Based 开发范式中"多维度审查"步骤的价值。**

---

## 质量红线违规清单（对照 `03-code-quality-thresholds.md`）

| 红线 | 违规数 | 最严重案例 |
|------|--------|-----------|
| 单文件 ≤800 行 | **0** | 最大 674 行（sync_engine）✅ |
| 单函数 ≤30 行 | **10+** | `generateRandomAppearance` 123 行 |
| 嵌套 ≤3 层 | ~2 | achievement_evaluator 的 switch-in-switch |
| 分支 ≤5/函数 | **2** | `_syncAction` 14 分支（⛔ 超绝对天花板） |
