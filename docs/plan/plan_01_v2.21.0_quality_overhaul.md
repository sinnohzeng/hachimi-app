---
level: 1
file_id: plan_01
status: completed
created: 2026-02-27 22:00
children: [plan_02, plan_03, plan_04, plan_05, plan_06, plan_07, plan_08, plan_09]
---

# 总体计划：v2.21.0 全面质量整改

## 项目概述

### 项目背景

基于对 Hachimi App 代码库的五维深度审计（架构、业务逻辑、UI/状态层、测试/CI、数据模型/文档），发现以下系统性问题：

- **P0 安全漏洞**：`assert` 在 release 模式被剥离、`int.parse()` 日期解析无容错、SyncEngine 错误仅 `debugPrint` 不上报 Crashlytics
- **离线优先缺口**：用户资料修改（头像/昵称/称号）直接写 Firestore 不走 Ledger，离线时静默丢失
- **代码质量红线违规**：1 个文件超 800 行（`adoption_flow_screen.dart` 983 行）、8+ 个函数超 30 行、`build()` 中存在副作用
- **架构不一致**：`StateNotifier` 与 `Notifier` 混用、魔法数字散落、账号删除无事务恢复语义
- **文档/i18n/合规缺口**：`totalCheckInDays` 字段未文档化、日韩繁中 ~287 个翻译 key 缺失、无隐私政策模板
- **无障碍不足**：部分触摸目标 < 48dp、语义标签缺失

### 项目目标

一次性修复所有已识别问题，版本从 `2.20.0+54` 升级到 `2.21.0+55`。

### 项目价值

- 消除生产环境安全隐患（币余额损坏、日期解析崩溃）
- 完善离线优先架构（用户资料修改不再依赖网络）
- 代码质量全面达标（零红线违规）
- 文档与代码 SSOT 对齐
- 多语言覆盖完整，合规文档就绪

---

## DDD 原则

**每一步代码修改必须同步更新对应的 SSOT 文档**（`docs/` EN + `docs/zh-CN/`）。

---

## 任务分解

### Work Stream A: P0 安全修复 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| A1 | CoinService assert → 运行时校验 | `lib/services/coin_service.dart` | ✅ |
| A2 | 日期解析防崩溃 | `lib/services/local_session_repository.dart` | ✅ |
| A3 | SyncEngine 错误上报 | `lib/services/sync_engine.dart` | ✅ |

### Work Stream B: 离线优先补完 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| B1 | 用户资料修改走 Ledger | `ledger_action.dart`, `user_profile_notifier.dart`, `sync_engine.dart` | ✅ |
| B2 | SQLite 完整性检查 | `lib/services/local_database_service.dart` | ✅ |
| B3 | MigrationService 超时保护 | `lib/services/migration_service.dart` | ✅ |

### Work Stream C: 代码拆分 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| C1 | adoption_flow 983→344 行（拆为 4 文件） | `screens/habits/` + `components/` | ✅ |
| C2 | timer build() 277→45 行 + 副作用修复 | `screens/timer/timer_screen.dart` | ✅ |
| C3 | edit_quest 对话框提取 + 函数拆分 | `screens/cat_detail/components/` + `widgets/quest_form_dialogs.dart` | ✅ |

### Work Stream D: 函数提取 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| D1 | `_createV2Tables()` 147→8 行 + 7 子方法 | `local_database_service.dart` | ✅ |
| D2 | `purchaseAccessory()` 69→22 行 + `_executePurchaseTxn` | `coin_service.dart` | ✅ |
| D3 | `initializePlugins()` 57→7 行 + 2 子方法 | `notification_service.dart` | ✅ |
| D4 | `_evaluate`+`_buildContext` → 6 子方法 + 2 数据类 | `achievement_evaluator.dart` | ✅ |

### Work Stream E: 错误处理加固 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| E1 | 账号删除事务恢复（SharedPreferences 标记 + `resumeIfNeeded`） | `account_deletion_service.dart`, `app.dart` | ✅ |
| E2 | 5 处 `debugPrint`/`catch(_)` → `ErrorHandler.record` | `account_deletion_service.dart` | ✅ |
| E3 | SyncEngine `_autoHydrateIfNeeded` 水化重试 | `sync_engine.dart` | ✅ |

### Work Stream F: 常量与一致性 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| F1 | `sync_constants.dart` 提取 debounce + batchSize | `lib/core/constants/sync_constants.dart`, `sync_engine.dart` | ✅ |
| F2 | 3 个 StateNotifier → Notifier 迁移（移除 legacy.dart） | `lib/providers/ai_provider.dart` | ✅ |
| F3 | `chat_service.dart` 魔法数字 50 → `recentMessagesFetchLimit` | `lib/services/chat_service.dart` | ✅ |

### Work Stream G: 文档与 i18n ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| G1 | 补全 4 语言 ARB 缺失 key | `lib/l10n/app_*.arb` | ✅（审查后发现 0 个用户可见 key 缺失） |
| G2 | data-model.md 补充 + 中英同步 | `docs/architecture/data-model.md` | ✅ |
| G3 | 隐私政策 + 用户协议模板 | `docs/legal/` | ✅ |

### Work Stream H: 无障碍 ✅

| 编号 | 任务 | 文件 | 状态 |
|------|------|------|------|
| H1 | 触摸目标 < 48dp 修复 | `reminder_card.dart`, `edit_quest_sheet.dart` | ✅ |
| H2 | 语义标签补充 | `achievement_card.dart`, `diary_preview_card.dart`, `chat_entry_card.dart` | ✅ |

---

## 执行顺序

```
Step 0（计划沉淀）→ A（安全）→ B（离线）→ C（拆分）→ D（提取）→ E（错误）→ F（一致性）→ G（文档/i18n）→ H（无障碍）→ 验证 → 发版
```

---

## 验收标准

### 功能验收

- `dart analyze lib/` 零错误
- `flutter test` 全部通过
- `flutter gen-l10n` 无错误

### 质量验收

- 所有修改文件 ≤ 800 行
- 所有修改函数 ≤ 30 行
- 嵌套 ≤ 3 层

### 文档验收

- 每处代码变更有对应 SSOT 文档更新
- 中英文档内容一致

---

## 风险评估

### 技术风险

- **代码拆分引入回归**：adoption_flow 和 timer 拆分可能破坏状态传递 → 逐步拆分并测试
- **Ledger 变更影响同步**：新增 profileUpdate ActionType 需确保 SyncEngine 正确处理 → 仔细对齐现有模式

### 缓解措施

- 每个 Work Stream 完成后运行 `dart analyze` 检查
- 拆分大文件时保持 public API 不变
- 使用 `git diff` 验证每步变更范围

---

## 不在本次范围内

| 项目 | 原因 | 建议 |
|------|------|------|
| 完整集成测试套件 | 40-60 小时专项工作 | v2.22.0 专项 |
| AI 提示词本地化 | 需逐语言验证 LLM 效果 | 独立 AI 质量迭代 |
| FocusTimerProvider 拆分 | 688 行未超 800 行红线 | 评估后单独处理 |
| 数据导出功能 | 需要产品设计 | 独立功能迭代 |
| codecov CI 集成 | 需外部服务配置 | CI 改进迭代 |
