---
level: 1
file_id: plan_07
status: pending
created: 2026-03-17 23:30
children: []
---

# 代码质量修复计划

**来源**：`docs/audit/code-quality-audit-2026-03-17.md`
**总发现**：115 🔴 Critical + 189 🟡 Medium + 29 🟢 Minor = 333 个问题
**目标**：修复全部 🔴 + 高优先级 🟡，将测试评分从 5/10 提升到 7/10

---

## Track 概览

| Track | 聚焦 | 涉及文件 | 预估复杂度 | 依赖 |
|-------|------|----------|-----------|------|
| **T1** | 类型安全 | models/ + providers/ + services/ | 高 | 无（基础 Track） |
| **T2** | 错误处理 | 全层 | 中 | 无 |
| **T3** | 架构修正 | core/ + services/ + screens/ | 中 | 无 |
| **T4** | 内存 & 性能 | services/ + widgets/ | 低 | 无 |
| **T5** | 代码简化 | services/ + widgets/ | 中 | T1 完成后更优 |
| **T6** | 测试补全 | test/ | 高 | T1-T2 完成后更优 |
| **T7** | l10n & 文档 | 全层 | 低 | 无 |

**推荐执行顺序**：T1 → T2 → T3 → T4 → T5 → T6 → T7

---

## Track 1: 类型安全修复

**目标**：消除 stringly-typed 模式，建立编译时类型安全

### 1.1 创建缺失的 enum 类型

| 新建 enum | 替代什么 | 影响文件数 |
|-----------|---------|-----------|
| `CatState` enum | String 常量 `'active'`/`'graduated'` | ~8 |
| `CatStage` enum | String `'kitten'`/`'adolescent'`/`'adult'`/`'senior'` | ~6 |
| `SessionStatus` enum | String 常量命名空间 | ~5 |
| `TimerMode` model enum | String `'countdown'`/`'stopwatch'` | ~4 |
| `AccessoryCategory` enum | String `'plant'`/`'wild'`/`'collar'` | ~3 |
| `ReminderMode` enum | String + `validModes` list | ~3 |
| `CelebrationHeadline` enum | String key | ~2 |

### 1.2 修复 `LedgerChange.type`：String → ActionType

- 将 `LedgerChange.type` 从 `String` 改为 `ActionType`
- 添加 notification-only 值到 `ActionType`（`hydrate`、`weekly_review_saved` 等）
- 更新所有 15+ filter lambda 使用 enum 比较
- **关键文件**：`ledger_action.dart`、`ledger_service.dart`、所有 `*_provider.dart`

### 1.3 修复 Firestore doc.data() null guard

4 个旧模型添加安全模式：
```dart
// 修改前
final data = doc.data() as Map<String, dynamic>;
// 修改后
final data = doc.data() as Map<String, dynamic>? ?? {};
```
- `models/cat.dart:84`
- `models/habit.dart:86`
- `models/focus_session.dart:50`
- `models/achievement.dart:46`
- `services/sync_engine.dart:136`

### 1.4 修复反序列化硬转换

- `models/diary_entry.dart:27-39` — 全部 `as String` → `as String? ?? ''`
- `models/chat_message.dart:43-50` — 同上
- `providers/timer_persistence.dart:99,119` — 添加 `TimerMode.values` 越界检查

### 1.5 修复 Widget 层类型传播

- `MoodSelector`: `int` → `Mood` enum
- `CatBedtimeAnimation.mood`: `int` → `Mood`
- `session_completion_service.dart:80`: `dynamic cat` → `Cat?`

### 验收标准
- `dart analyze lib/` 无新增 warning
- 所有 `grep -r "as Map<String, dynamic>;" lib/models/` 返回零结果（全部加 `?? {}`）
- 所有 `grep -r "LedgerChange(type: '" lib/` 返回零结果（全部用 ActionType）

---

## Track 2: 错误处理加固

**目标**：消除静默失败，建立可观测性

### 2.1 修复 SizedBox.shrink 反模式（7 处）

| 文件 | 行号 | 修复 |
|------|------|------|
| `widgets/check_in_banner.dart` | 79 | 添加 debugPrint + 显示错误卡片 |
| `widgets/awareness/monthly_ritual_card.dart` | 32 | 添加 ErrorState 或文字提示 |
| `screens/home/components/today_tab.dart` | 54 | 添加 debugPrint |
| `screens/achievements/overview_weekly_trend.dart` | 39 | 添加错误文字 |
| `screens/achievements/overview_heatmap_card.dart` | 36 | 同上 |
| `screens/achievements/overview_recent_sessions.dart` | 34 | 同上 |
| `widgets/pixel_cat_sprite.dart` | 72 | 添加 debugPrint |

### 2.2 修复 bare catch / unbound exception（15+ 处）

统一模式：`catch (_)` → `catch (e) { debugPrint('[Module] op failed: $e'); }`

关键位置：
- `core/utils/error_handler.dart:43,60,95`
- `models/ledger_action.dart:113-116`
- `widgets/check_in_banner.dart:59`
- `widgets/celebration/celebration_overlay.dart:269`
- `screens/profile/edit_name_dialog.dart:77`
- `screens/profile/avatar_picker_sheet.dart:91`
- `screens/cat_room/cat_room_screen.dart:381,422`
- `services/account_deletion_orchestrator.dart:89`
- `services/firebase_remote_config_backend.dart:23`

### 2.3 修复 fire-and-forget 写入（10+ 处）

统一模式：添加 `await` + `try-catch` 或至少 `.catchError()`

关键位置：
- `providers/user_profile_notifier.dart:96-98` — 登出 prefs 写入
- `providers/auth_provider.dart:69-70` — onboarding 标记
- `widgets/tappable_cat_sprite.dart:76` — pose 更新
- `screens/cat_room/inventory_screen.dart:207-218` — equip/unequip
- `screens/home/components/today_tab.dart:223` — 习惯删除
- `screens/cat_detail/components/edit_quest_sheet.dart:452` — 习惯更新
- `screens/settings/settings_screen.dart:437` — 访客数据重置

### 2.4 修复 sync_engine 静默 sync 跳过

7 处 early return 改为：log warning + mark action as permanently failed

### 2.5 修复 session_completion 错误吞没

`_persistSession` catch 块应 rethrow 或返回 partial failure 结果

### 2.6 修复 hydration 失败假成功

`firebase_sync_backend.dart:71-74` — 使用 `ErrorHandler.recordOperation` 并 rethrow

### 2.7 添加 jsonDecode FormatException 保护

- `services/coin_service.dart:292`
- `services/inventory_service.dart:168`
- `services/diary_service.dart:88,129,185`
- `providers/inventory_provider.dart:30`

### 2.8 修复 debugPrint → ErrorHandler.recordOperation

`notification_service.dart` 4 处 + `awareness_repository.dart:278` + `session_completion_service.dart:292`

### 验收标准
- `grep -rn "SizedBox.shrink" lib/` 中无 error handler 结果
- `grep -rn "catch (_)" lib/` 所有结果有 debugPrint 或合理注释
- `grep -rn "=> SizedBox" lib/` 中无 error/AsyncValue.when 上下文

---

## Track 3: 架构修正

**目标**：恢复严格的依赖流 `Screens → Providers → Services → Firebase SDK`

### 3.1 core/ 层：移除 Firebase SDK 直接导入

| 文件 | 修复方案 |
|------|---------|
| `core/utils/error_handler.dart` | 注入 CrashBackend + AnalyticsBackend |
| `core/utils/deferred_init.dart` | 移到 services/ 或注入 backend |
| `core/utils/performance_traces.dart` | 创建 PerformanceBackend 或移到 services/ |
| `core/utils/auth_error_mapper.dart` | 在 AuthBackend 层定义平台无关错误码 |

### 3.2 services/ 层：移除 providers/ 导入

| 文件 | 修复方案 |
|------|---------|
| `session_completion_service.dart:8` | 将 FocusTimerState/TimerMode 移到 models/ |
| `account_deletion_service.dart:2` | 将 TimerPersistence 移到 core/utils/ |

### 3.3 screens/ 层：移除 services/ 导入

| 文件 | 修复方案 |
|------|---------|
| `timer/timer_screen.dart:18-19` | 通过 Provider 暴露 FocusTimerService 操作 |

### 3.4 修复 LocalDatabaseService 双实例

- 删除 `ai_provider.dart` 中的 `localDatabaseProvider`
- 所有引用改为 `service_providers.dart` 的 `localDatabaseServiceProvider`

### 3.5 修复 ObservabilityTags PII 过滤逻辑 bug

`isAllowedKey` 应先检查 allowedExtras 再检查 PII hints

### 验收标准
- `grep -rn "import.*firebase" lib/core/` 返回零结果
- `grep -rn "import.*providers" lib/services/` 返回零结果
- `grep -rn "import.*services" lib/screens/` 返回零结果（除 router）

---

## Track 4: 内存 & 性能

### 4.1 修复 pixel_cat_renderer LRU 缓存内存泄漏

缓存驱逐时调用 `evictedImage.dispose()`

### 4.2 修复 TextEditingController 泄漏（3 处）

- `widgets/quest_form_dialogs.dart:12,58` — `.whenComplete(() => controller.dispose())`
- `screens/profile/edit_name_dialog.dart:17` — 同上
- `screens/settings/delete_account_flow.dart:109` — 同上

### 4.3 修复 coin_service.dart finally 块

将 `notifyChange` 移出 `finally`，只在成功路径触发

### 验收标准
- LRU 缓存驱逐时 `ui.Image.dispose()` 被调用
- 所有 dialog 中的 TextEditingController 有对应 dispose

---

## Track 5: 代码简化

### 5.1 消除代码重复

| 重复 | 修复 |
|------|------|
| `_decodeInventory` ×3 | 提取到 `core/utils/json_helpers.dart` |
| `_computeStage` / `_stageOrder` ×2 | 移到 `CatStage` enum（T1 创建的） |
| awareness stats upsert ×2 | 提取共享 `_incrementStatInTxn(txn, uid, column)` |

### 5.2 拆分超长函数

| 函数 | 行数 | 修复 |
|------|------|------|
| `generateRandomAppearance` | 123 | 提取 `_generatePeltType()`、`_generateEyeColors()` 等 |
| `_attemptRemoteDeletion` | 88 | 提取 `_handleRemoteError()` + `_postDeletionCleanup()` |
| `equipAccessory` | 81 | 提取 `_executeEquipTxn()` |
| `unequipAccessory` | 68 | 提取 `_executeUnequipTxn()` |
| `setUserProperties` | 67 | 用 Map 驱动循环替代重复 if-null 模式 |
| `_syncAction` | 58 | Map dispatch 替代 14-case switch |

### 5.3 简化 WeeklyReview 结构（可选）

`happyMoment1/2/3` + `happyMomentTags1/2/3` → `List<HappyMoment>` value object

### 验收标准
- `grep -rn "_decodeInventory" lib/` 只有 1 处定义
- 所有函数 ≤30 行（`dart analyze` 配合自定义 lint rule）

---

## Track 6: 测试补全

**目标**：将测试评分从 5/10 提升到 7/10

### 6.1 基础设施（先做）

- 创建 `test/helpers/` 目录
- 共享 Fakes：`FakeLedgerService`、`FakeLocalDatabaseService`
- 内存 SQLite 测试基础设施（`sqflite_common_ffi`）
- 共享 `setupFirebaseCoreMocks()` 初始化

### 6.2 P0 测试（数据持久化核心）

| 测试文件 | 覆盖 | 预估 |
|----------|------|------|
| `ledger_service_test.dart` | migrateUid、markSyncFailed、cleanOldSyncedActions | 中 |
| `local_database_service_test.dart` | Schema v1→v4 迁移、完整性检查 | 中 |
| `sync_engine_test.dart` | _syncAction dispatch、hydration、permanent error 分类 | 高 |

### 6.3 P1 测试（V3 功能 + 关键模型）

| 测试文件 | 覆盖 |
|----------|------|
| `awareness_repository_test.dart` | saveDailyLight new/update、saveWeeklyReview complete 流程 |
| `ledger_action_test.dart` | fromSqlite roundtrip、ActionType.fromValue 全枚举 |
| `worry_repository_test.dart` | resolve stat increment、delete 不减计数 |
| `json_helpers_test.dart` | 损坏 JSON 降级、类型过滤 |
| `date_utils_test.dart` | isoWeekId 年界边界 |

### 6.4 P2 测试（Provider + Widget）

| 测试文件 | 覆盖 |
|----------|------|
| `ai_availability_notifier_test.dart` | 断路器 3-failure 阈值、恢复 |
| `chat_notifier_test.dart` | _userFacingError 映射、sendMessage 守卫 |
| `guest_upgrade_coordinator_test.dart` | _decide 决策矩阵 |
| `circular_duration_picker_test.dart` | 角度数学、边界钳制 |
| `quest_form_dialogs_test.dart` | 输入验证边界 |

### 验收标准
- `flutter test` 全部通过
- 持久化核心（LedgerService + DB + SyncEngine）有 roundtrip 测试
- 测试文件数从 50 增加到 65+

---

## Track 7: l10n & 文档对齐

### 7.1 l10n 修复

| 文件 | 问题 | 修复 |
|------|------|------|
| `awareness/daily_detail_screen.dart:163` | 硬编码中文星期名 | 用 `DateFormat.yMMMMEEEEd(locale)` |
| `awareness/mood_calendar.dart:145` | 硬编码英文月份名 | 同上 |
| `widgets/streak_indicator.dart:16` | 硬编码英文 Semantics | 用 `context.l10n` |
| `widgets/chip_selector_row.dart:42` | 硬编码 `'Custom'` | 改为 required 参数 |
| `core/constants/awareness_constants.dart:12` | 中文 preset tags | 改为语言无关 ID + 映射 |

### 7.2 DDD 文档同步

审计完成后更新：
- `docs/architecture/data-model.md` — 新增 enum 类型
- `docs/architecture/state-management.md` — 更新 provider 变更
- `CLAUDE.md` — Per-Track 审查升级为 4 Agent

### 验收标准
- `grep -rn "hardcoded" lib/` 无中文/英文硬编码字符串（l10n 相关）
- 所有 SSOT 文档与代码一致
