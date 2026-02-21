# 技术债分析

> **目的**：记录 Hachimi 代码库中已识别的技术债、AI 编程痕迹和改进建议。
> **状态**：活跃

---

## 1. 错误处理（已解决）

### 问题

12 个 Service 文件中的 28+ 个 catch 块仅使用 `debugPrint` 记录错误。错误在生产环境中不可见 —— Crashlytics 仅捕获 Flutter 框架级别的致命错误（通过 `FlutterError.onError`），所有服务层异常均被遗漏。

**修复前：**
```dart
} catch (e) {
  debugPrint('[CoinService] checkIn: $e');
  rethrow;
}
```

### 解决方案

创建集中式 `ErrorHandler`（`lib/core/utils/error_handler.dart`），桥接：
1. `debugPrint`（本地开发）
2. `FirebaseCrashlytics.recordError`（生产环境崩溃上报）
3. GA4 `app_error` 事件（分析仪表板）

所有 28 个 catch 块已更新。在 `main.dart` 中配置了三层崩溃捕获：
- `FlutterError.onError` —— Widget 构建错误
- `PlatformDispatcher.instance.onError` —— 异步未捕获错误
- `runZonedGuarded` —— Zone 级别错误

详见：`docs/firebase/crashlytics-integration.md`

---

## 2. 分析不够深入（已解决）

### 问题

GA4 集成仅覆盖基础漏斗事件（sign_up、cat_adopted、focus_session_*）。缺少：
- 错误追踪事件
- 参与深度指标（功能使用、AI 聊天、日记生成）
- 会话质量信号（完成率）
- 留存信号（app_opened 带 days_since_last）
- 经济系统追踪（金币获取/消费、配饰）
- 用户生命周期事件（引导完成、首次会话）

### 解决方案

新增 12 个 GA4 事件及对应的 `AnalyticsService` 记录方法。添加 `app_opened` 留存追踪，支持连续天数统计。完整事件目录见 `docs/firebase/analytics-events.md`。

---

## 3. 缺失性能监控（已解决）

### 问题

关键操作无 Firebase Performance 追踪，无法测量：
- 专注会话写入延迟
- LLM 模型加载/生成时间
- 日记生成耗时
- 签到交易速度

### 解决方案

添加 `firebase_performance` 依赖，创建 `AppTraces` 工具类（`lib/core/utils/performance_traces.dart`）。5 个自定义追踪现已测量关键操作，每个追踪自动设置 `status: success/error` 属性。

---

## 4. AI 编程痕迹（已解决）

### 问题

~76 个文件包含冗余的中文伪代码文件头（每个 10-28 行），由 AI 编码规则（`.claude/rules/22-code-header-template.md`）生成。这些文件头在已有 `///` 文档注释的情况下没有额外价值，增加了文件体积。

3 个 Claude 规则文件与 Flutter 项目无关：
- `03-glue-code-principles.md` —— Python/通用编程哲学
- `04-project-structure.md` —— Python 项目结构
- `22-code-header-template.md` —— 冗余文件头的根源

### 解决方案

- 删除 3 个不相关的 Claude 规则
- 精简 `21-variable-naming-index.md` 为 Dart/Flutter 命名规范
- 移除所有 76 个文件中的 `// ---` 伪代码块

---

## 5. 硬编码字符串（已解决）

### 问题

6 处英文字符串未纳入 i18n：
- 领养流程中的 `'min'` / `'h'` 时间单位后缀
- 签到日历中的星期缩写 `['M', 'T', 'W', ...]`
- 设置页面的版权归属文字
- 专注设置中的 `'Your cat'` 回退文案

### 解决方案

在全部 5 个 ARB 文件（en、zh、zh_Hant、ja、ko）中新增 10 个 l10n 键。更新 4 个 Dart 文件使用本地化字符串。

---

## 6. 大型页面文件（待处理）

### 问题

8 个页面文件超过 400 行，在单文件中混合了布局、逻辑和组件定义：

| 文件 | 行数 | 建议提取 |
|------|------|---------|
| `adoption_flow_screen.dart` | 831 | `habit_step.dart`、`cat_step.dart`、`name_step.dart` |
| `timer_screen.dart` | 695 | `timer_controls.dart`、`timer_progress_ring.dart` |
| `home_screen.dart` | 558 | `today_tab.dart`、`habit_list_section.dart` |
| `focus_complete_screen.dart` | 545 | `xp_breakdown_card.dart`、`stage_up_celebration.dart` |
| `check_in_screen.dart` | 545 | `calendar_grid.dart`、`check_in_milestones.dart` |
| `login_screen.dart` | 541 | `login_form.dart`、`social_login_buttons.dart` |
| `model_test_chat_screen.dart` | 525 | `chat_message_bubble.dart`、`model_test_input.dart` |
| `cat_chat_screen.dart` | 378 | `chat_bubble.dart`、`chat_input_bar.dart` |

### 建议

将私有 Widget 提取到各页面文件夹下的 `components/` 子目录。保持主页面文件作为提取组件的组合入口。目标：每文件 < 300 行。

---

## 7. 离线数据保护（已解决）

### 问题

Firestore 离线持久化已启用，但边界情况（如写入过程中应用崩溃）可能丢失专注会话数据 —— 这是最关键的用户操作。

### 解决方案

创建 `OfflineWriteGuard`（`lib/core/utils/offline_write_guard.dart`）：
1. 正常尝试 Firestore 写入
2. 失败时，将操作排队到 SharedPreferences
3. 下次启动时重试待处理的写入

---

## 优先级矩阵

| 问题 | 严重程度 | 用户影响 | 解决状态 |
|------|---------|---------|---------|
| 错误处理 | 高 | 生产环境 bug 不可见 | 已解决 |
| 分析不够深入 | 中 | 缺少参与度数据 | 已解决 |
| 缺失性能监控 | 中 | 对延迟问题不可见 | 已解决 |
| AI 编程痕迹 | 低 | 代码噪音、审阅摩擦 | 已解决 |
| 硬编码字符串 | 低 | 部分语言 i18n 缺失 | 已解决 |
| 大型页面文件 | 低 | 可维护性 | 待处理 |
| 离线数据保护 | 中 | 潜在数据丢失 | 已解决 |

---

## 变更日志

- **2025-02**：初始分析并解决问题 1-5、7
