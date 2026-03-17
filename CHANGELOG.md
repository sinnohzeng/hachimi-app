# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.33.4] - 2026-03-17

### Added
- **15 语言国际化**：新增 German、Spanish、French、Portuguese、Hindi、Indonesian 等语言完整支持，成就系统扩展 Japanese/Korean/Traditional Chinese 本地化（617 条成就数据）
- **密码重置功能**：登录页新增"忘记密码"入口，支持邮箱重置密码
- **聊天错误处理**：AI 聊天引入 `ChatResult` 三态模型（成功/取消/错误），错误时显示内联重试气泡
- **熔断器保护**：AI 服务层新增断路器机制，连续 3 次失败自动 5 分钟回退

### Changed
- **无障碍增强**：20+ 组件添加 Semantics 标签和 ExcludeSemantics 包裹，改善屏幕阅读器体验
- **猫咪屏幕重构**：重命名对话框提取为共享 widget、猫咪详情/聊天/猫舍页面增加加载/错误状态处理
- **账号删除优化**：删除确认对话框改为异步加载用户数据摘要，删除重试定时器生命周期优化
- **PixelCatRenderer 内存管理**：渲染管线中显式释放 native texture，减少内存泄漏

### Fixed
- **孤立测试文件**：删除 `sse_parser_test.dart`（引用的源文件已移除）
- **未使用字段**：移除 `AiAvailabilityNotifier._validated`
- **弃用 API**：`SemanticsService.announce` 替换为 `sendAnnouncement`

## [2.33.3] - 2026-03-14

### Fixed
- **账号删除"出了点问题"误报**：`deleteAccountHard()` 成功后 `signOut()` 异常不再否定删除结果；清理步骤独立 try-catch，任意步骤失败仅记录不影响成功判定
- **离线优先超时加固**：7 个关键网络调用增加超时保护，弱网/离线下不再阻塞用户操作
  - Cloud Function 删号：15s 超时，超时后排队下次重试
  - Firebase Auth 登录/注册/关联：10s 超时
  - Firestore 数据水化：8s 超时，超时后使用本地数据
  - 登录后 Profile 设置：8s 超时，超时后直接进入主页
  - 云端快照读取：5s 超时，加速 fallback 触发

## [2.33.2] - 2026-03-14

### Fixed
- **10 语言翻译质量全面提升**：修复翻译地道性问题，从"功能可用"升级到"地道自然"
  - **日历热图星期缩写重复**（CRITICAL）：DE（6/7 天重复）、FR/IT（二/三均为"M"）、PT（Mon/Fri/Sat 均为"S"）、ID（Mon/Tue/Sat 均为"S"）全部修复为无歧义缩写
  - **意大利语德语文本污染**（CRITICAL）：`onboardBody2` 含德语原文，已替换为正确意大利语
  - **全 10 语言 `settingsLanguageEnglish` 未翻译**（CRITICAL）：补齐 Inglés/Inglês/Anglais/Englisch/Inglese/अंग्रेज़ी/อังกฤษ/Tiếng Anh/Inggris/İngilizce
  - **意大利语 "focus" 全替换**（HIGH）：28 个 key 中的英语借词 "focus" 统一改为 "concentrazione"
  - **法语 vous/tu 语气混用**（HIGH）：通知 body 和猫咪对话 7 个 key 统一为非正式 "tu" 语气
  - **德语拼写错误**（HIGH）：`notifEvolutionBody` 中 "devon" → "zu einem"；`onboardBody2` 语序修复
  - **泰语 placeholder 缺空格**（HIGH）：3 个通知 key 中 `{habitName}`/`{stageName}` 前后补空格
  - **ES/PT `personalityClingy` 词义不当**（HIGH）："Pegajoso"→"Mimoso"，"Grudento"→"Apegado"
  - **多语言 timer 标签大写**（MEDIUM）：FR/IT/DE 的 `timerRemaining`/`timerElapsed` 首字母大写
  - **FR/DE/IT `adoptionRefreshCat` 缺宾语**（MEDIUM）：补全缺失的"猫"宾语
  - **单项修复**（MEDIUM）：TR 古语替换、VI/PT `timerPaused` 全大写改正常格式、ID/HI 单复数代词、PT 虚拟式
- **`tool/l10n_check.dart` 代码质量**：占位符正则支持 Unicode（`\w+` → `[^}]+`）；空值检测加 `trim()`；`_setsEqual` 保留并补注 Dart `Set` 不重写 `==` 的说明
- **`language_dialog.dart` 繁中检测**：`_localeToCode` 新增 `countryCode == 'TW'/'HK'` 兜底，台湾/香港地区码正确映射到 `zh_Hant`

## [2.33.1] - 2026-03-14

### Fixed
- **多用户切换数据丢失**：登出不再删除本地数据，SQLite UID 列天然隔离多用户数据；`deleteUidData` 仅保留给账号删除流程使用
- **空访客虚假升级**：`GuestUpgradeCoordinator.resolve()` 内置空数据守卫，`readLocal().isEmpty` 时直接清理标记、跳过合并对话框
- **`_recoverOrphanedGuestData` 盲设 `dataHydrated`**：空快照不再设置 `dataHydrated=true`，避免阻断 Firestore 水化
- **账号删除僵尸态**：远程删除失败时 `finally` 块调用 `logout()` 强制签出 + 创建访客身份，防止用户停留在"认证有效但数据为空"的状态
- **Riverpod 3.x `async*` 订阅断言崩溃**：11 个 StreamProvider 从 `async*` + `await for` 重构为 `StreamController` + `ref.onDispose`，消除 `pausedActiveSubscriptionCount` 不匹配的无限重建循环
- **RenderFlex 布局警告**：`PixelSectionHeader` 分隔线从 `Expanded` 改为 `Flexible`，修复嵌套 Row 中无界宽度断言错误
- **App Check Debug Token 随机化**：解码 Firebase SharedPreferences 文件名的 Base64 编码格式，从 `google-services.json` 注入正确的 `FIREBASE_APP_ID`

### Added
- **`ledgerDrivenStream<T>()` 共享助手**：封装 StreamController 模式，供所有 Ledger 驱动的 StreamProvider 复用
- **结构化认证日志**：登出流程 `[Auth]` 前缀、账号删除 `[AccountDeletion]` 前缀，方便 `adb logcat` 快速过滤
- **10 语种国际化**：新增德语、西班牙语、法语、印地语、印尼语、意大利语、葡萄牙语、泰语、土耳其语、越南语翻译
- **语言选择对话框**：设置页新增手动语言切换功能，支持所有 15 种语言
- **登录页猫咪动画**：`AuthCatHero` 像素猫动画组件，增强登录 / 注册页视觉体验

### Changed
- **SyncEngine 日志脱敏**：`debugPrint` 中移除明文 UID，遵循 PII 最小化原则
- **文档同步**：`docs/architecture/state-management.md`（EN + zh-CN）更新登出语义、空访客守卫、FirstHabitGate 恢复逻辑

## [2.33.0] - 2026-03-13

### Changed
- **认证架构简化 — sealed class 替代 boolean isGuest**：新增 `AppAuthState` sealed class（`AuthenticatedState | GuestState`），通过模式匹配消除登出过渡态盲区，根除"幽灵用户"bug
- **`appAuthStateProvider` 单一认证 SSOT**：组合 Firebase Auth stream + 本地访客 UID，`currentUidProvider` 和 `isGuestProvider` 作为向后兼容的薄派生层保留（26+ 文件零改动）
- **登出流程 3 步化**：从 6 阶段手动编排简化为 stop → signOut + delete → 新访客 UID，依赖 Provider 级联自动清理下游状态，移除 10 个 SharedPreferences key 的手动清扫
- **AuthGate switch 模式匹配**：用 Dart 3 exhaustive switch 替代 7 层嵌套的 if-else 判断，3 条路径清晰可读
- **移除 cachedUid 冗余层**：Firebase SDK 原生持久化 session，`cachedUid` SharedPreferences key 是不必要的双重缓存，已从全链路清除
- **移除匿名登录**：`_autoSignInAnonymously()` 和 `wasAnonymous` 追踪已删除，访客纯本地运行，无 Firebase 匿名用户

### Fixed
- **侧边栏幽灵用户**：`app_drawer.dart` 改用 `appAuthStateProvider` 模式匹配，登出后正确显示访客登录引导而非 fallback 名字"用户"
- **退出按钮无反馈**：`logout_confirmation.dart` 新增 loading 状态，确认后禁用按钮并显示进度指示器，防止重复点击
- **访客升级 cachedUid 残留**：`AccountMergeService` 移除对已废弃 `cachedUid` key 的写入

## [2.32.1] - 2026-03-13

### Fixed
- **ThemeMode 反序列化越界防御**：SharedPreferences 存储的主题模式索引越界时不再导致启动崩溃，与 AppUiStyle 采用一致的 bounds check 策略
- **页面转场动画值 clamp**：防御弹性曲线或物理模拟产生的越界动画值（<0 或 >1），避免 debug 模式下 FadeTransition assert 失败

## [2.32.0] - 2026-03-13

### Added
- **双 UI 风格切换**：新增 Material 3 与复古像素（Retro Pixel）两种视觉风格，可在设置中一键切换
- **ThemeSkin 策略模式**：`MaterialSkin` / `RetroPixelSkin` 通过策略接口消除主题构建中的条件分支，遵循开闭原则
- **PixelBorderShape**：自定义 `OutlinedBorder` 子类，注入 ThemeData 组件主题级联，一个类替代 7+ 个包装组件
- **AppScaffold**：统一 Scaffold 包装器，在复古模式下自动叠加 `RetroTiledBackground`，23+ 个屏幕的唯一集成点
- **像素风专属组件**：`PixelSwitch`（矩形开关）、`PixelSkeletonLoader`（脉冲虚线骨架屏）、`PixelLoadingIndicator`（4 帧阶梯旋转）、`PixelProgressRing`（12 段离散弧）
- **像素风页面转场**：`PixelPageTransitionsBuilder` 实现 4 级阶梯透明度交叉淡入，模拟 8-bit 屏幕切换
- **SectionHeader 风格感知**：设置页分组标题在复古模式下自动切换为像素字体 + "━━━" 装饰线

### Changed
- **RetroTiledBackground 性能优化**：从 static 缓存重构为 StatefulWidget 实例缓存，GPU 纹理与 widget 生命周期绑定，正确 dispose 防止内存泄漏；新增 4096px 尺寸上限和 toImageSync 异常防御
- **PixelThemeExtension 新增 isRetro 标志**：组件可通过 `pixelExt.isRetro` 判断当前风格，替代脆弱的字体名检测
- **语义色映射**：复古配色映射到 `ColorScheme` 槽位，所有 Material 组件零改动自动适配
- **FadeTransition 替代 Opacity**：页面转场使用 `_SteppedOpacity` 动画代理 + `FadeTransition`，避免创建额外合成层

### Removed
- 自定义 `lerpDouble` 函数（冗余，改用 `dart:ui.lerpDouble`）
- 手写牛顿法 `_sqrt`（改用 `dart:math.sqrt`）

## [2.31.4] - 2026-03-13

### Fixed
- **登出卡死修复**：重构 `logout()` 为 Clean-Then-Navigate 模式，先清理 SharedPreferences + SQLite + Firebase Auth，再触发导航，消除旧会话与新会话的竞态条件
- **访客升级 UNIQUE 约束修复**：`migrateUid()` 对复合主键表（materialized_state、local_monthly_checkins）改用 DELETE-then-UPDATE 策略，避免 `ensureProfile()` 写入的默认行与真实数据冲突
- **`_isLoggingOut` 永久锁死修复**：用 try-finally 包裹 `logout()` 全流程，确保异常路径也能重置守卫标志

### Added
- **返回用户跳过引导**：新增 `hasOnboardedBefore` 持久化标记，登出后的返回用户自动跳过 3 页引导教程直接进入主页；删号时清除该标记以保证全新开始语义

## [2.31.3] - 2026-03-13

### Refactored
- **渲染管线精修**：提取 `_renderLayer()` 统一画布合成模板，消除 6 处 PictureRecorder 样板代码；修复 `rec`/`c` 单字母变量为语义化命名
- **类型安全修复**：`dynamic l10n` → `S l10n` 恢复静态类型检查；`_performRename` 中 `context.l10n` → `dialogCtx.l10n` 修复潜在 BuildContext 错用
- **异常处理规范化**：所有 `catch (_) {}` 静默吞异常替换为 `catch (e) { debugPrint(...) }`，日记生成 `.then/.catchError` 重写为 async/await
- **状态机去重**：提取 `_computeWallClockElapsed`（壁钟计算 3×→1×）、`_resolveCatDisplayName`（猫名回退 3×→1×）、`_computePendingPauseDelta`（暂停增量 2×→1×）
- **常量提取**：`_defaultDurationSeconds`、`_autoCompleteThresholdMinutes`、`_saveIntervalTicks`、`_habitNameMaxLength`、`_buttonHeight` 替代散布的魔法数字
- **按钮组件统一**：提取 `_TimerActionButton` 消除 timer_controls.dart 中 5 处 `SizedBox(height: 56)` 按钮布局重复
- **日记触发架构修正**：从 `build()` 内的 `addPostFrameCallback` 移至 `initState()`，消除每次重建注册回调的反模式

## [2.31.2] - 2026-03-13

### Refactored
- **渲染管线拆分**：`pixel_cat_renderer.dart` 的 `renderCat`（213 行）拆分为 6 个独立层方法，配置加载拆分为 5 个解析方法
- **专注完成页组件提取**：提取 `FocusCatDisplay` 和 `FocusSessionStatsCard` 为独立 widget，`initState` 拆分为动画初始化和交错启动
- **计时器控制按钮提取**：`TimerControls` 提取为独立 StatelessWidget，timer_screen.dart 从 800 行降至 686 行
- **状态机逻辑优化**：`focus_timer_provider.dart` 的 `_onTick` 提取倒计时完成处理，`complete`/`abandon` 合并为 `_terminateSession` 消除代码重复
- **猫咪详情页去重**：窄屏/宽屏卡片列表统一为 `_buildCardWidgets` 共享方法，消除 ~80 行重复代码
- **应用生命周期拆分**：`app.dart` 的会话恢复、后台引擎启动、提醒调度各自拆分为独立方法

## [2.31.1] - 2026-03-10

### Fixed
- 登录 Google 账号后现在能正确返回主页，不再停留在登录页面
- 登录后习惯、金币、签到、猫咪、成就等数据立即刷新，不再需要重启应用
- 已有云端数据的用户登录后不再被误导进入新手引导
- 删除账号时即使遇到网络错误，也能正确返回引导页，不再出现界面卡死

### Added
- 新增本地开发反馈闭环指南（开发者文档）

## [2.31.0] - 2026-03-08

### Added
- **猫猫归档相册**：归档的猫猫现在可在猫屋底部的可折叠「相册」section 中查看，支持点击查看详情、长按打开操作菜单
- **重新激活**：已归档的猫猫可通过相册菜单一键恢复到活跃状态，关联的习惯任务同步恢复
- **归档/恢复 SnackBar 反馈**：归档和重新激活操作完成后显示确认提示
- **8 个 L10N 键**（5 种语言）：相册标题、归档标签、重新激活确认对话框、操作成功提示
- `habitRestore` 台账行为类型，支持猫猫恢复的完整审计链路

### Fixed
- **成就误触发**：归档任意阶段的猫（含 0h kitten）都会触发"毕业日"成就并发放 150 金币。现在仅 senior 阶段（200h+）的猫归档才计入毕业成就
- **归档非原子操作**：归档前需要分两步调用 `graduate()` + `delete()`，中间失败会导致数据不一致。现在 `archive()` 在单一 SQLite 事务中完成猫状态 + 习惯软删除 + 台账写入
- **Firestore 猫状态不同步**：归档后 Firestore 中猫的 `state` 仍为 `active`，换设备登录后已归档猫重新出现在猫屋。现在 `_syncHabit` 同步归档/恢复时同步猫状态到 Firestore
- **成就评估器不响应归档/恢复**：`_triggerMap` 缺少 `habit_delete` 和 `habit_restore` 映射，归档/恢复后 `activeHabitCount` 变化不触发成就重评估

### Changed
- `CatRoomScreen` 从 `ConsumerWidget` 升级为 `ConsumerStatefulWidget`，布局从 `GridView` 改为 `CustomScrollView`（活跃 Grid + 可折叠相册）
- `graduate()` 标记为 `@Deprecated`，委托给 `archive()`

### Refactored
- **退出登录**: logout() 改为 Navigation-First 模式 — 先导航再后台清理，确保用户立即看到引导页
- **退出确认 Dialog**: 从 StatefulWidget 简化为纯确认 Dialog，移除 loading 状态（因 Navigation-First 导航瞬间完成）
- **登录流程**: `Navigator.popUntil` 移入 `finally` 块，确保即使 finalizeAccountSetup 失败也能正确导航
- **FirebaseAuthBackend**: 构造函数支持依赖注入，`googleSignIn.signOut()` 增加 3s 超时防止网络阻塞

## [2.30.2] - 2026-03-08

### Fixed
- **退出登录无响应**: AppDrawer 退出按钮因先关闭 Drawer 再弹 Dialog 导致 context 已 dispose，操作被静默取消。现在 Dialog 直接在 Drawer 上层弹出，消除竞态根因（6 行 → 1 行）
- **退出流程缺乏容错**: `logout()` 前置步骤异常会阻止 `reset()` 执行导致卡死。重写为 5 阶段流水线，每阶段独立 try-catch，`reset()` 结构性置底确保导航必定触发
- **退出不清理本地数据**: 退出后 SQLite 7 张表残留旧用户数据、已调度通知未取消、SharedPreferences 仅清理 4/10 个 key。现在完整清理 SQLite（`deleteUidData`）、取消全部通知、清除全量用户级 SharedPreferences
- **Google SignOut 级联阻塞**: `_googleSignIn.signOut()` 失败会阻止 `_auth.signOut()` 执行。现在独立 try-catch 隔离
- **退出无加载反馈**: 确认 Dialog 用 `StatefulBuilder` 就地变形为加载态（`CircularProgressIndicator` + 文案），`PopScope` 禁止返回键关闭
- **访客可见退出按钮**: ProfileScreen 退出按钮无条件渲染，访客点击会丢失本地数据。现在用 `isGuestProvider` 守卫

### Added
- `loggingOut` L10N key（5 种语言：en/zh/zh_Hant/ja/ko）

## [2.30.1] - 2026-03-07

### Fixed
- **Login data loss**: Guest data no longer lost when UID changes during login — `_FirstHabitGate` now handles `didUpdateWidget` with engine-run serialization
- **Logout non-responsive**: Centralized reactive `popUntil` listener in `AuthGate` ensures OnboardingScreen is shown from all 3 logout entry points
- **Delete account broken state**: Explicit `AccountDeletionResult` state machine with retryable/non-retryable error classification; progress dialog always dismissed correctly
- **Delete timing glitch**: `onboarding.reset()` now fires before progress dialog pop to prevent brief HomeScreen flash
- **Consolidated logout**: Three identical `_confirmLogout` methods replaced by single `showLogoutConfirmation()` utility

### Added
- `IdentityTransitionResolver` — deterministic migration-source UID resolution for guest-to-credentialed upgrades
- `AccountDeletionResult` model — typed deletion outcome with `localDeleted`, `remoteDeleted`, `queued`, `errorCode`
- Pre-release Cloud Functions check script (`scripts/check-account-lifecycle-functions.sh`)
- 8 new unit tests for deletion orchestrator and identity resolver

### Deployed
- Cloud Functions `deleteAccountV2` and `wipeUserDataV2` deployed to `hachimi-ai` Firebase project (App Check enforced)
- Cloud Functions `monitorAiUsageV1` and `runAiDebugTriageV2` scheduled functions deployed
- Fixed `functions/package.json` main entry point and `@octokit/rest` ESM dynamic import

## [2.30.0] - 2026-03-07

### Changed
- **AI always-on**: AI features (diary generation, cat chat) are now always available for authenticated users — no toggle needed
- **Simplified AI state**: `AiAvailability` reduced from 3-state to 2-state (`ready` / `error`); removed `AiFeatureNotifier` and privacy dialog
- **Lazy validation**: AI availability uses optimistic `ready` state with async background probe instead of blocking on startup
- **Circuit breaker**: After 3 consecutive AI failures, requests are suppressed for 5 minutes to prevent retry storms
- **Celebration redesign**: Achievement overlay decomposed from 1 file (541L) into 6 focused files in `lib/widgets/celebration/`; 3-tier celebration system (Standard/Notable/Epic) with haptic scarcity; migrated from `MaterialApp.builder` to `OverlayPortal`

### Added
- **Chat daily limit**: 5 messages per cat per day with remaining count in chat bar; configurable via Firebase RemoteConfig
- **Diary retry queue**: Failed diary generations are saved to SharedPreferences and retried (up to 3 attempts) on next CatDetail visit
- **Network timeout protection**: Per-operation timeouts (chat 15s, diary 20s, validation 5s, streaming idle 10s)
- **AI offline banner**: Authenticated users see a `cloud_off` banner when AI is unavailable, instead of silently hiding cards
- **Token analytics**: `ai_token_usage` and `ai_chat_limit_reached` GA4 events for cost monitoring
- **Cloud Function**: `monitorAiUsageV1` daily scheduled function aggregates AI token usage from BigQuery to Firestore
- 3 new L10N keys across 5 languages: `chatDailyRemaining`, `chatDailyLimitReached`, `aiTemporarilyUnavailable`

### Removed
- AI settings page (`ai_settings_page.dart`) and test chat screen (`model_test_chat_screen.dart`)
- `aiSettings` and `modelTestChat` routes
- ~26 dead L10N keys (AI settings, privacy dialog, test chat, network requirement)
- AI Model section from Settings screen

### Fixed
- Type safety: `dynamic` parameters replaced with proper `Cat`/`Habit` types in `focus_complete_screen.dart` and `cat_chat_screen.dart`
- `_AiTeaserCard`: removed `BuildContext context` constructor parameter (anti-pattern)
- AppBar chat icon now properly hidden for guest users

## [2.29.1] - 2026-03-07

### Fixed
- **Login error handling**: Split auth flow into Phase A (authentication) and Phase B (account setup). Only Phase A failures show user-facing error SnackBar; Phase B failures log silently without misleading users
- **Guest data preservation**: Reordered `AccountMergeService.keepLocal()` — local UID migration (atomic SQLite transaction) now executes before cloud cleanup, preventing data loss when cloud operations fail
- **Saga compensation**: Added `_recoverOrphanedGuestData()` in `_FirstHabitGate` startup to detect and recover incomplete guest-to-authenticated migrations via `localGuestUid` persistence signal
- **Account deletion state machine**: UID mismatch and max retries now properly clear pending deletion markers instead of looping indefinitely; `_PendingDeletionScreen` shows state-driven escape button after 3 failed retries
- **Cloud snapshot resilience**: `GuestUpgradeCoordinator.readCloud()` now catches exceptions and defaults to empty snapshot, preventing cloud failures from blocking local data merge

### Added
- `SyncConstants.deletionMaxRetryCount` and `deletionEscapeRetryThreshold` constants
- `AccountDeletionOrchestrator.abandonPendingDeletion()` for user-initiated escape from stuck deletion
- `deleteAccountAbandon` L10N key across all 5 languages
- 11 unit tests: `AccountDeletionOrchestrator` (6 tests) and `AccountMergeService` (5 tests)

## [2.29.0] - 2026-03-06

### Changed
- **Onboarding redesign**: Replaced emoji-based onboarding (🐱⏱️✨) with real `PixelCatSprite` visuals — users now see actual pixel cats from their first interaction
- **Page 1 "Meet Your Companion"**: 160px kitten with breathing scale animation on a rounded surface platform
- **Page 2 "Focus, Grow, Evolve"**: 4 growth stages displayed horizontally (kitten → adolescent → adult → senior) with size progression (48-96px) and staggered entrance animations
- **Page 3 "Build Your Cat Room"**: 3 randomly generated cats with unique appearances in a cluster layout
- **Particle overlay**: Moved to screen level — firefly particles now persist across all 3 pages without visual discontinuity
- **Unified color scheme**: Removed per-page gradient backgrounds and `_ColorRole` enum; all pages now use consistent M3 surface colors with `primary` accent
- **Responsive layout**: Added height check (>= 500dp) to prevent landscape phones from triggering tablet layout
- **Updated L10N**: New onboarding copy across all 5 languages (en, zh, zh-Hant, ja, ko) reflecting the cat-focused narrative

### Added
- `OnboardingCatHero` component — single kitten with breathing animation and accessibility support
- `OnboardingStageStrip` component — 4-stage growth visualization with `stageColor()` labels
- `OnboardingCatCluster` component — multi-cat group display with `FittedBox` overflow protection
- 6 widget tests for onboarding screen (navigation, skip, completion, back)

## [2.28.2] - 2026-03-06

### Fixed
- **Auth observability**: Login failures (Google Sign-In and email) now report to ErrorHandler → Crashlytics + GA4 `app_error` event, closing the blind spot where auth errors were invisible in monitoring.
- **BigQuery queries**: Replaced placeholder `analytics_PROPERTY_ID` with actual GA4 dataset `analytics_522585423` in `bq-debug-queries.sh` and all documentation.

### Added
- **Analytics events**: `signInFailed` and `signUpFailed` constants in `AnalyticsEvents`.

## [2.28.1] - 2026-03-06

### Changed
- **Edge-to-edge compliance**: Android themes migrated from legacy `Theme.Light.NoTitleBar` / `Theme.Black.NoTitleBar` to `Theme.Material3.Light.NoActionBar` / `Theme.Material3.Dark.NoActionBar`.
- **MainActivity**: Switched from `FlutterActivity` to `FlutterFragmentActivity` with `enableEdgeToEdge()` call for proper Android 15+ edge-to-edge rendering.
- **System bar styling**: Centralized transparent system bar configuration in `AppBarTheme.systemOverlayStyle` (theme SSOT) with adaptive icon brightness for light/dark themes.
- **Flutter edge-to-edge bootstrap**: Added `SystemUiMode.edgeToEdge` and transparent system bar overlay in `main.dart`.
- **CatDetailScreen**: Replaced implicit `SystemUiOverlayStyle.dark/light` presets with explicit transparent color declaration.

### Fixed
- **Deprecated API warnings**: Upgraded `com.google.android.material:material` from 1.7.0 to 1.12.0 (fixes datepicker deprecated `setStatusBarColor` call) and `androidx.activity:activity-ktx` from 1.8.1 to 1.10.1.
- **Google Play Console warnings**: Resolved "Edge-to-edge may not display for all users" and "deprecated APIs for edge-to-edge" recommended actions.

## [2.28.0] - 2026-03-06

### Added
- **BigQuery debug tooling**: `scripts/bq-debug-queries.sh` parameterized query script for Crashlytics crash analysis and GA4 analytics queries.
- **BigQuery setup guide**: `docs/guides/bigquery-debug-setup.md` with Firebase → BigQuery export instructions and 5 ready-to-use SQL templates.
- **WIF one-click setup**: `scripts/setup-wif.sh` automates GCP Workload Identity Federation configuration and GitHub secrets provisioning.
- **Country availability docs**: Global distribution guidance added to Play Store setup guide.

### Fixed
- **Play Console navigation**: Corrected "Reach and devices" → "Test and release → Production → Countries/regions" to match current Play Console UI.

## [2.27.0] - 2026-03-06

### Added
- **Full-auto production release pipeline**: `release.yml` now builds APK + AAB, uploads AAB to Google Play production track (100% rollout), creates GitHub Release with APK attached, all triggered by `v*` tag push.
- **Supply-chain security hardening**: All GitHub Actions pinned to commit SHA, top-level `permissions: {}` deny-by-default, `production` GitHub Environment with `v*` tag deployment restriction.
- **APK provenance attestation**: Sigstore build provenance via `actions/attest-build-provenance`, verifiable with `gh attestation verify`.
- **whatsnew freshness guard**: CI blocks release if whatsnew files contain generic app description instead of version-specific notes.
- **WIF setup automation**: `scripts/setup-wif.sh` one-click script for configuring GCP Workload Identity Federation + GitHub secrets.
- **BigQuery debug setup guide**: `docs/guides/bigquery-debug-setup.md` with Crashlytics/GA4 export instructions and query templates.
- **BigQuery debug query script**: `scripts/bq-debug-queries.sh` for parameterized crash and analytics queries.
- **Country availability documentation**: Added global distribution guidance to `docs/release/google-play-setup.md`.

### Changed
- **Google Play setup docs updated**: Removed outdated "Settings -> API access" and "Link existing project" references, replaced with current Cloud Console and "Users and permissions" workflows.
- **Release secret validation**: `tool/check_release_secrets.sh` validates all 8 required secrets before build.
- **Dependabot**: Weekly auto-updates for GitHub Actions SHA pins.

## [2.26.0] - 2026-03-04

### Added
- New account lifecycle services:
  - `AccountSnapshotService`
  - `AccountMergeService`
  - `GuestUpgradeCoordinator`
  - `AccountDeletionOrchestrator`
  - `AccountLifecycleBackend` + Firebase Functions implementation
- New account conflict UI: `ArchiveConflictDialog` with local/cloud metric comparison.
- Firebase Cloud Functions workspace (`functions/`) with:
  - `deleteAccountV1`
  - `wipeUserDataV1`
- Repository quality gate script: `tool/quality_gate.dart`.

### Changed
- `UserProfileBackend.createProfile` replaced with idempotent `ensureProfile`.
- Auth screens now route guest upgrade through unified conflict coordinator for both Google and Email flows.
- `FirebaseAuthBackend` now degrades `credential-already-in-use` / `email-already-in-use` link attempts to sign-in flow.
- Account deletion flow rebuilt to 3-step UX:
  - data summary
  - type `DELETE`
  - execute deletion
- Deletion semantics changed to offline-first queue model using:
  - `pending_deletion_job`
  - `deletion_tombstone`
  - `deletion_retry_count`
- `AuthGate` now handles pending deletion tombstones and auto-retries queued cloud hard-deletes.
- Firestore rules removed legacy `checkIns` compatibility subtree.
- Removed legacy analytics compatibility events (`timer_started`, `timer_completed`, `daily_check_in`, `goal_progress`).

### Removed
- `MigrationService` and `_VersionGate` migration compatibility flow.
- `RemoteConfigService` (unused runtime service).
- `OfflineWriteGuard` (unused compatibility safety net).
- Multi-region backend compatibility branch (`BackendRegion.china`).

## [2.25.0] - 2026-03-02

### Fixed
- **Logout not working**: Users could never reach "logged out" state because `cached_uid` was never cleared and AuthGate auto-signed-in anonymously. All 4 logout entry points now route through `UserProfileNotifier.logout()` which performs full cleanup.
- **Account deletion state leak**: After deletion, app stayed on HomeScreen because onboarding state was a stale boolean in `initState`. Now uses reactive `onboardingCompleteProvider`.
- **Account deletion recovery markers lost**: `prefs.clear()` could wipe recovery markers if crash occurred between clear and re-set. Markers are now preserved across clear.
- **Delete progress showing raw English**: Progress steps ('firestore', 'local') now localized in all 5 languages.
- **Singleton anti-pattern in onboarding**: `AnalyticsService()` constructor replaced with `analyticsServiceProvider`.
- **Circular import risk**: `onboarding_screen.dart` no longer imports `app.dart` for the `kOnboardingCompleteKey` constant.

### Added
- **`onboardingCompleteProvider`**: Reactive `NotifierProvider<OnboardingNotifier, bool>` replacing stale boolean. AuthGate watches this to switch between OnboardingScreen and HomeScreen.
- **`AppPrefsKeys`**: Centralized SharedPreferences key constants (`lib/core/constants/app_prefs_keys.dart`), eliminating string literals scattered across 10+ files.
- **`UserProfileNotifier.resetGuestData()`**: Unified guest data reset (was 5-line manual assembly in settings).
- **`DeleteAccountFlow._localizeStep()`**: Maps deletion progress steps to L10N strings.
- **SyncEngine restart on deletion failure**: If account deletion fails, SyncEngine is restarted so the user can continue using the app.
- **3 L10N keys × 5 languages**: `deleteAccountStepCloud`, `deleteAccountStepLocal`, `deleteAccountStepDone`.
- **`logout_flow_test.dart` (5 tests)**: Covers `OnboardingNotifier` lifecycle and `AppPrefsKeys` uniqueness.

### Changed
- **`UserProfileNotifier.logout()`**: Now performs full cleanup — stop SyncEngine, clear auth cache (cachedUid, localGuestUid, dataHydrated, onboardingComplete), reset onboarding provider, then signOut.
- **`app_drawer.dart`**: `authBackendProvider.signOut()` → `userProfileNotifierProvider.notifier.logout()`.
- **`settings_screen.dart`**: 5-line manual guest reset → `notifier.resetGuestData()`.
- **`delete_account_flow.dart`**: Added onboarding reset + `popUntil(isFirst)` after successful deletion.
- **`sync_engine.dart`**: `_hydratedKey` → `AppPrefsKeys.dataHydrated`.
- **`account_deletion_service.dart`**: `_kDeletion*` constants → `AppPrefsKeys.*`.

### Removed
- **`kOnboardingCompleteKey`** constant from `app.dart` (moved to `AppPrefsKeys.onboardingComplete`).
- **`_onboardingComplete` stale boolean** from `_AuthGateState` (replaced by reactive provider).

## [2.24.0] - 2026-03-01

### Removed
- **`AuthService` (126 lines)**: Entire service deleted. All auth operations now go through `AuthBackend` abstraction (`authBackendProvider`), eliminating the parallel implementation that caused consistency drift.
- **Firebase `User` type leakage**: `firebase_auth` import removed from `auth_provider.dart` and `app.dart`. Firebase-specific types now confined to `firebase_auth_backend.dart` and `auth_error_mapper.dart` only.
- **`authServiceProvider`**: Deleted — all 7 consumer files migrated to `authBackendProvider`.
- **`DeferredInit` Google Sign-In**: Removed from static utility class; initialization moved to `_AuthGateState.initState()` where Provider context is available.

### Added
- **`AuthUser` / `AuthResult` value semantics**: `operator ==`, `hashCode`, and `toString()` implementations. Prevents unnecessary Riverpod rebuilds when auth state stream emits identical user data.
- **`auth_provider_test.dart` (17 tests)**: First auth regression test suite — covers `AuthUser`/`AuthResult` value semantics, `currentUidProvider` three-state fallback, and `isGuestProvider` scenario coverage.
- **Explicit `AuthUser?` type annotations**: Added to all 4 `authStateProvider` consumer sites for clarity and type safety.

### Changed
- **`authStateProvider`**: `StreamProvider<User?>` → `StreamProvider<AuthUser?>`, data source from `FirebaseAuth.instance.authStateChanges()` → `ref.watch(authBackendProvider).authStateChanges`.
- **`isAnonymousProvider` → `isGuestProvider`**: Renamed for clarity. Now derives guest status from `AuthUser.isAnonymous` when authenticated, falls back to `local_guest_uid` check when unauthenticated.
- **`UserProfileNotifier`**: `authServiceProvider` → `authBackendProvider` for `updateDisplayName()` and `signOut()`.
- **`email_auth_screen.dart` signUp path**: Eliminated temporal coupling — uses `result.uid` from return value instead of `authService.currentUser!.uid`.
- **Login/auth result access**: `result.user!.uid` → `result.uid`, `result.additionalUserInfo?.isNewUser` → `result.isNewUser` (flat `AuthResult` API).

## [2.23.0] - 2026-02-28

### Fixed
- **P0: Firestore checkIns permission-denied**: Added missing security rules for `checkIns/{dateId}` and `checkIns/{dateId}/entries/{entryId}` subcollections. Root cause: Firestore parent document rules don't cascade to subcollections.
- **SyncEngine race condition**: Added `syncEngineProvider.stop()` before account deletion and guest data reset to prevent concurrent writes during cleanup.
- **Raw error exposed to user**: Replaced `e.toString()` in deletion error handler with localized, human-friendly error messages via `_mapDeletionError()`.
- **Reauthentication only supported Google**: Added multi-provider reauthentication — Google, Email/Password, and anonymous (skip). Email users can now delete their accounts.
- **BuildContext stored as class field**: `DeleteAccountFlow` refactored from instance-based to pure static methods, eliminating retained `BuildContext` risk.

### Added
- **Declarative data topology**: `_userCollections` static registry replaces hardcoded per-collection deletion. New collections only need one line to register.
- **`DeletionPhase` enum**: Type-safe deletion progress tracking replacing magic numbers `0/1/2`.
- **Email reauthentication dialog**: Password input dialog for Email/Password provider users during account deletion.
- **Retained data compliance notice**: Data summary dialog now discloses which data cannot be deleted (analytics, crash reports).
- **Account deletion analytics**: 3 new events (`account_deletion_started`, `account_deletion_completed`, `account_deletion_failed`) for observability.
- **`AuthBackend` reauthentication API**: `providerIds`, `reauthenticateWithGoogle()`, `reauthenticateWithEmail()` added to abstract interface and Firebase implementation.
- **6 new L10N keys** across 5 languages (en, zh, zh-Hant, ja, ko): deletion error messages, reauth prompts, retained data notice.

### Changed
- **`AccountDeletionService` constructor injection**: Now accepts `LocalDatabaseService` and `NotificationService` via constructor, enabling unit testing with mocks.
- **`cleanLocalData()` split into 4 sub-functions**: `_cleanSqlite()`, `_cleanPreferences()`, `_cleanNotifications()`, `_cleanTimerState()` (each ≤15 lines).
- **`resumeIfNeeded()` instance method**: Changed from static to instance, accessed via `accountDeletionServiceProvider`.
- **`DeleteAccountFlow` static-only**: Progress tracking via `ValueNotifier` + `ValueListenableBuilder` replacing mutable `_onProgress` field.
- **Auth deletion moved to `DeleteAccountFlow`**: `deleteAccount()` + Google signout now called by the UI flow after data cleanup, not by the service.

## [2.22.0] - 2026-02-27

### Fixed
- **CRITICAL: Achievement evaluation context**: Filled 3 unassigned `AchievementEvalContext` fields (`lastSessionMinutes`, `hasCompletedGoalOnTime`, `hasCompletedGoalAhead`). Achievements `quest_marathon`, `goal_on_time`, and `goal_ahead` can now be unlocked.
- **9 unsafe `cast<String>()`**: Replaced `.cast<String>()` with `.whereType<String>().toList()` across sync, hydration, inventory, and profile providers. Prevents `TypeError` when Firestore returns non-string elements in lists.
- **3 fire-and-forget error swallows**: `UserProfileNotifier` `updateDisplayName/updateAvatar/updateTitle` now log errors via `ErrorHandler.record()` instead of silently ignoring sync failures.
- **Chat service error tracking**: `sendMessage()` catch block now records errors to Crashlytics instead of silently falling back.
- **Titles JSON decode crash**: `_decodeTitles()` in `user_profile_provider.dart` now wrapped in try-catch, returning empty list on malformed data.
- **Ledger deserialization safety**: New `LedgerAction.fromSqliteSafe()` factory with try-catch, used in `getUnsyncedActions()` to skip corrupted rows instead of crashing the sync loop.
- **Migration service sampling**: `checkNeedsMigration()` now samples 50 docs (was 5), reducing false negatives for accounts with many cats.

### Added
- **`SyncConstants` materialization keys**: 7 key constants (`keyCoins`, `keyLastCheckInDate`, `keyInventory`, `keyAvatarId`, `keyDisplayName`, `keyCurrentTitle`, `keyUnlockedTitles`) eliminating magic strings.
- **`ChipSelectorRow` reusable widget**: Shared chip selection UI extracted from `EditQuestSheet` and `AdoptionStep1Form`, removing ~80 lines of duplicated code.
- **Schema version history comments**: `LocalDatabaseService` now documents v1/v2/v3 schema changes inline.
- **Notification error isolation**: Each reminder in `scheduleReminders()` is now wrapped in individual try-catch, preventing one failed schedule from blocking subsequent reminders.

### Changed
- **Achievement evaluator**: 24-case switch replaced with static predicate map + persist fallback (3 branches total).
- **`hydrateFromFirestore()` refactored** (86 → ~10 lines): Extracted `_hydrateCollection()`, `_hydrateUserProfile()`, `_hydrateListField()` helpers with declarative field mapping.
- **`checkIn()` refactored** (120 → orchestrator + 3 helpers): `_loadMonthlyCheckIn()`, `_calculateRewards()`, `_persistCheckIn()`.
- **`getUserDataSummary()` refactored**: Manual for-loop replaced with SQL `COALESCE(SUM())` + `COUNT()` aggregates.
- **`getSessionHistory()` refactored**: Extracted `_buildHistoryQuery()` + `_parseMonthRange()` with month format validation.
- **`scheduleReminders()` split** (71 → 4 methods): `_scheduleByMode()`, `_scheduleDaily()`, `_scheduleWeekdays()`, `_scheduleSpecificDay()`.
- **`firebase_auth_backend.dart`**: Extracted `_getGoogleCredential()` shared by `signInWithGoogle()` and `linkWithGoogle()`.
- **`notification_service.dart`**: Extracted `_androidPlugin` getter eliminating platform-check duplication.
- **`timer_screen.dart`**: Split `_buildRunningButtons()` into `_buildCountdownRunningButton()` + `_buildStopwatchRunningButtons()`. Extracted `_updateHabitAndCatProgress()` from `_persistSession()`.

## [2.21.0] - 2026-02-27

### Fixed
- **P0: CoinService assert → runtime validation**: Replaced 4 `assert` statements (stripped in release mode) with `ArgumentError` throws for coin amount and accessory validation. Prevents silent acceptance of invalid values in production.
- **P0: Date parsing crash protection**: `int.parse()` in `LocalSessionRepository` replaced with `int.tryParse()` + range validation. Invalid dates now return empty results instead of crashing.
- **P0: SyncEngine error reporting**: 6 `debugPrint()` calls replaced with `ErrorHandler.record()` / `ErrorHandler.breadcrumb()` for production-grade error tracking via Crashlytics.
- **Account deletion transaction recovery**: Added SharedPreferences-based deletion progress markers with `resumeIfNeeded()` for automatic recovery if deletion is interrupted mid-process.
- **SyncEngine auto-hydration**: `start()` now calls `_autoHydrateIfNeeded()` to ensure data is pulled from Firestore before sync begins, preventing empty-state sync issues.
- **5 silent error swallows**: Replaced `debugPrint` / `catch(_)` in `AccountDeletionService` with `ErrorHandler.record` for proper error tracking.

### Added
- **Offline-first user profile updates**: Avatar, nickname, and title changes now write to local ledger + materialized_state first, then fire-and-forget sync to Firestore. Profile edits no longer silently lost when offline.
- **SQLite integrity check**: Database initialization now runs `PRAGMA integrity_check`. Corrupted databases are automatically rebuilt with re-hydration flag.
- **MigrationService timeout protection**: Firestore `.get()` calls wrapped with 5-second timeout to prevent migration hangs on poor connections.
- **Sync constants**: New `SyncConstants` class centralizing `syncDebounceInterval` and `syncBatchSize` (previously magic numbers).
- **Privacy policy & terms of service**: Draft templates in `docs/legal/` (EN + zh-CN) covering all data collection, third-party services, and user rights.
- **`totalCheckInDays` documentation**: Added missing field to data-model.md (EN + zh-CN).

### Changed
- **adoption_flow_screen.dart split** (983 → 344 lines): Extracted 3 step components (`AdoptionStep1Form`, `AdoptionStep2CatPreview`, `AdoptionStep3NameCat`).
- **timer_screen.dart refactored**: `build()` reduced from 277 → 45 lines via 6 private builder methods. Fixed `build()` side-effect by moving listener to `ref.listenManual` in `initState`.
- **edit_quest_sheet.dart**: Extracted dialog helpers to `quest_form_dialogs.dart`.
- **_createV2Tables() split** (147 → 8 lines): Orchestrator + 7 table-level methods in `LocalDatabaseService`.
- **purchaseAccessory() split**: Extracted `_executePurchaseTxn()` for cleaner transaction handling.
- **initializePlugins() split**: Extracted `_initNotificationPlugin()` + `_createNotificationChannels()`.
- **AchievementEvaluator refactored**: `_evaluate()` and `_buildContext()` split into 6 sub-methods + 2 private data classes (`_HabitData`, `_CatData`).
- **Riverpod Notifier migration**: 3 `StateNotifier` classes in `ai_provider.dart` migrated to modern `Notifier` pattern. Removed `legacy.dart` import.
- **chat_service.dart**: Magic number `50` replaced with named constant `recentMessagesFetchLimit`.
- **Accessibility improvements**: Removed `visualDensity: VisualDensity.compact` from IconButtons to ensure 48dp touch targets. Added `semanticLabel` to achievement icons, diary/chat chevrons. Wrapped decorative emojis in `ExcludeSemantics`.

## [2.20.0] - 2026-02-27

### Added
- **Multi-backend abstraction layer**: Strategy Pattern abstractions in `lib/core/backend/` (AuthBackend, SyncBackend, UserProfileBackend, AnalyticsBackend, CrashBackend, RemoteConfigBackend) with Firebase implementations in `lib/services/firebase/`. Enables future China (Tencent CloudBase) deployment from a single codebase.
- **BackendRegistry + region providers**: `backendRegionProvider`, `backendRegistryProvider`, and individual backend providers registered in `service_providers.dart`. Region switching UI is architecturally ready.
- **Auth error mapping**: `auth_error_mapper.dart` translates Firebase Auth error codes to localized, user-friendly messages. Added 8 L10N keys across all 5 languages (EN, zh, zh-Hant, ja, ko).
- **User title providers**: `currentTitleProvider` and `unlockedTitlesProvider` read from local materialized_state, completing local-first title management.
- **Logout consolidation**: `UserProfileNotifier.logout()` unifies SyncEngine stop + Auth signOut. Profile and Settings screens share one code path.
- **Title management**: `UserProfileNotifier.updateTitle()` writes to local ledger + fire-and-forget Firestore sync.

### Removed
- **CatFirestoreService** (135 lines): Dead code since local-first migration — zero runtime callers.
- **AchievementService** (193 lines): Entirely replaced by local `AchievementEvaluator` — zero callers.
- **AchievementTriggerHelper** (99 lines): Deprecated wrapper with zero callers.
- **FirestoreService** (590 lines): Legacy monolithic service deleted in prior cleanup.

### Changed
- **UserProfileService**: Refactored from direct Firestore access to delegate via `UserProfileBackend` constructor injection.
- **SyncEngine hydration**: Now pulls `currentTitle` and `unlockedTitles` from Firestore during hydration for pre-migration users.
- **Architecture docs**: Updated all 6 architecture docs (EN + zh-CN) — overview, folder-structure, state-management — to reflect backend abstraction layer, removed deleted services, added new providers.

## [2.19.11] - 2026-02-25

### Fixed
- **Account deletion permission-denied**: Authenticated users deleting their account would hit `permission-denied` on sessions and achievements subcollections. Split Firestore security rules to keep `update: if false` (immutability) while allowing `delete: if isOwner` for account cleanup.
- **Guest "Reset data" incomplete**: Previously only called `signOut()`, leaving SQLite, SharedPreferences, notifications, and timer state as orphaned data. Now properly cleans all local data and (for Firebase anonymous guests) deletes Firestore data and Auth account.

### Added
- **Achievement detail sheet**: Tap any achievement card to view full details — unlock date, reward coins, and description in a bottom sheet.
- **Cat info card**: Extracted cat information display into a reusable `CatInfoCard` component on the cat detail screen.
- **Stage milestone widget**: Reusable `StageMilestone` widget for displaying growth stage progress.

### Changed
- **AccountDeletionService refactored**: Extracted shared Firestore cleanup into `_deleteFirestoreData()`, exposed `cleanLocalData()` as public, added `deleteGuestData()` for guest-specific flow.
- **Achievement card**: Refactored to support tap-to-detail interaction.
- **Cat detail screen**: Decomposed into smaller components (`CatInfoCard`), removed heatmap legend section.
- **Adoption flow & quest edit**: Minor UI adjustments.

## [2.19.10] - 2026-02-25

### Fixed
- **Google sign-in admin-restricted-operation**: Removed `_ensureCurrentUser()` which called `signInAnonymously()` as fallback — fails when anonymous auth is disabled in Firebase Console. Link methods now gracefully degrade: if an anonymous user exists, link credentials; otherwise, sign in directly.
- **Achievement celebration transparent background**: Background gradient Container had no explicit sizing in Stack, causing unreliable rendering. Replaced with `Positioned.fill` + `DecoratedBox` for guaranteed full-screen coverage. Added proper alpha values (0.92/0.96) for near-opaque overlay.
- **Achievement celebration text invisible in light theme**: Text used `onSurface` colors (dark in light theme) against dark gradient background. Changed to white color scale (`Colors.white`, `Colors.white70`, `Colors.white54`) for reliable contrast.
- **Achievement icon invisible**: Glow icon used `colorScheme.primary` which blended into the gradient center. Changed to `Colors.white`.

## [2.19.9] - 2026-02-25

### Fixed
- **Guest Google sign-in stuck**: Guest users completing Google OAuth would see no response — the app silently failed because `_auth.currentUser` was null when anonymous sign-in hadn't finished yet. Added `_ensureCurrentUser()` guard that falls back to anonymous sign-in before credential linking.
- **Email link assertion crash**: `email_auth_screen.dart` linkMode branch used `authService.currentUser!.uid` which could crash; now captures the `linkWithEmail()` return value directly.
- **TOCTOU race in credential linking**: Both `linkWithGoogle()` and `linkWithEmail()` now capture a local `User` reference before the async credential operation, eliminating the check-then-use race condition.

## [2.19.8] - 2026-02-25

### Fixed
- **Guest visibility bug**: Guest users no longer see "Log out" and "Delete account" in Drawer and Settings menus
- **isGuestProvider SSOT**: Replaced `isAnonymousProvider` (which only checked Firebase anonymous auth) with reactive `isGuestProvider` that correctly detects both local guests and Firebase anonymous users
- **Reactivity**: Guest state provider now watches `authStateProvider` stream, automatically re-evaluating when auth state changes (login, link credentials, sign out)

### Removed
- Dead code `isLocalGuestProvider` (defined but never consumed)

## [2.19.7] - 2026-02-25

### Improved
- **Guest drawer redesign**: Replaced passive "Guest / Tap to sign in" header and redundant upgrade banner with a single CTA card featuring shield icon, subtitle, and sign-in button
- **Guest settings account area**: Guest users now see "Sign in" (primary) and "Reset all data" (error) instead of the misleading "Log out" and "Delete account"
- **Reset data confirmation**: Three-action dialog (Cancel / Link account / Reset) with warning icon, replacing the old guest logout flow
- **Drawer cleanup**: Account section (logout) is now hidden entirely for guest users, reducing visual noise

### Removed
- Guest upgrade banner card in drawer (consolidated into header CTA)
- `_confirmGuestLogout` method and 8 associated L10N keys (`drawerGuest`, `drawerGuestTapToLink`, `drawerLinkAccountHint`, `drawerLinkAccount`, `drawerGuestLogout*`)

### Fixed
- Scaffold background color now explicitly uses `colorScheme.surface` for consistency
- Drawer `openDrawer` callback simplified (tear-off instead of lambda)

## [2.19.6] - 2026-02-24

### Improved
- **Drawer navigation**: Drawer close animation now completes before navigating to the next page, eliminating visual interruption
- **Cat name Hero transition**: Cat names no longer flash ellipsis during Hero fly animation between CatHouse and CatDetail
- **Cat name length limit**: All cat name inputs (adoption, rename) now enforce a 20-character maximum
- **Particle overlay fade-in**: Floating particles on cat detail page now fade in after route transition completes, synchronized with mesh background
- **Cat pose persistence**: Tapping a cat to change its pose is now saved to local SQLite and restored on re-entry (DB v3 migration)
- **Achievement celebration full-screen**: Redesigned from a centered card to an immersive full-screen layout with radial gradient background, larger icon (96px), headline text, full-width button, and single-play confetti
- **Cat detail entry animation**: All content cards now use staggered fade+slide animations that wait for route transition to complete before playing, including tablet wide layout

### Changed
- `ParticleOverlay` converted from `ConsumerWidget` to `ConsumerStatefulWidget` with `fadeIn` parameter
- `StaggeredListItem` gains `waitForRoute` parameter to delay animation until route transition completes
- `TappableCatSprite` converted to `ConsumerStatefulWidget` for SQLite persistence via `LocalCatRepository.updateDisplayPose`
- Local database schema upgraded from v2 to v3 (`display_pose` column on `local_cats`)

## [2.19.5] - 2026-02-24

### Improved
- **Focus timer dial**: Duration picker now snaps to 5-minute increments instead of 1-minute, reducing dial clutter and making selection faster
- **Scroll conflict resolved**: Dragging the circular dial no longer causes the page to scroll simultaneously — scroll is disabled while touching the dial and restored on release
- **Cleaner layout**: Removed preset duration chips (5/10/20/30/45/60/90/120) to reduce visual noise; the dial alone provides sufficient control

### Changed
- Default focus duration rounds to nearest 5 minutes (range 5–120)
- `CircularDurationPicker` exposes `onDragStart`/`onDragEnd` callbacks for parent gesture coordination

## [2.19.4] - 2026-02-24

### Fixed
- **Offline-first auth**: First-time install no longer requires network — local guest UID generated synchronously after onboarding, Firebase sign-in moved to non-blocking background task
- **Error screen on first launch**: Removed the "something went wrong" error page that appeared when Firebase anonymous sign-in failed offline; app now enters main screen immediately
- **UID migration**: When Firebase auth completes later, local guest data is atomically migrated to the Firebase UID via `LedgerService.migrateUid`
- **SyncEngine guest guard**: SyncEngine and Firestore hydration skip entirely for local guest UIDs, preventing unnecessary network calls
- **Onboarding back button placement**: Moved back button from bottom bar to top-left corner IconButton for better discoverability and consistent navigation pattern
- **Achievement celebration width collapse**: Added `ConstrainedBox(minWidth: 280, maxWidth: 360)` to prevent card from collapsing on short achievement text

### Changed
- `currentUidProvider` now falls back to `local_guest_uid` in auth error/null states, ensuring all providers have a usable UID even fully offline
- Added `isLocalGuestProvider` for downstream components to check local guest status

## [2.19.3] - 2026-02-24

### Fixed
- **Onboarding navigation crash**: `late final` field in AuthGate was reassigned on "Let's go" tap, causing `LateInitializationError` that permanently blocked users on the onboarding screen
- **Anonymous sign-in failure**: Users stuck on infinite spinner when network unavailable during auto sign-in; now shows error screen with retry button
- **Onboarding async gap**: `_finish()` used raw `SharedPreferences.getInstance()` introducing unnecessary async delay; replaced with synchronous provider access
- **Android back key on onboarding**: No `PopScope` handling caused back key to exit the app; now navigates to previous onboarding page
- **No back navigation in onboarding**: Added back button and `_previous()` method so users can review earlier pages

## [2.19.2] - 2026-02-24

### Fixed
- **Cat rename**: CatDetailScreen and CatRoomScreen now write to local SQLite instead of Firestore, with `cat_update` ledger notification for instant UI refresh
- **Account deletion order**: Firestore cleanup now executes before Auth deletion, preventing `permission-denied` errors on orphaned data cleanup
- **Account deletion data summary**: `getUserDataSummary` reads from local SQLite first, with Firestore fallback
- **Avatar picker**: Writes to local `materialized_state` (SSOT) with best-effort Firestore sync
- **Nickname edit**: Writes to local `materialized_state` alongside Firebase Auth, Firestore becomes best-effort
- **Registration init**: New accounts initialize local `materialized_state` (coins, inventory, check-in date) immediately after profile creation
- **Avatar hydration**: `SyncEngine.hydrateFromFirestore` now pulls `avatarId` and `displayName` into local state
- **Avatar provider**: `avatarIdProvider` reads from local SQLite instead of Firestore Stream

### Changed
- `AchievementService` and `triggerAchievementEvaluation` marked `@Deprecated` — replaced by ledger-driven `AchievementEvaluator`

## [2.19.1] - 2026-02-24

### Fixed
- **Write path migration**: All data-mutating operations (create quest, timer completion, edit quest, reminders, delete, archive) now write to local SQLite instead of Firestore, completing the local-first architecture
- **Firestore hydration**: Existing users' data is automatically pulled from Firestore into SQLite on first launch after upgrade (`SyncEngine.hydrateFromFirestore`)
- **SyncEngine**: `_syncHabit` now reads full habit/cat data from SQLite and pushes to Firestore for `habitCreate` and `habitUpdate` actions
- **Timer rewards**: Focus session completion now correctly updates habit progress, cat progress, and coin balance locally
- **Heatmap data**: Activity heatmap reads from local SQLite sessions instead of Firestore
- **Achievement card overflow**: Grid item height increased from 100 to 116px; progress section spacing tightened to prevent layout overflow on two-line descriptions
- **Drawer button consistency**: CatRoom and Achievement screens now show menu button matching Today tab for consistent M3 navigation

### Added
- `CoinService.earnCoins()` for local coin increment (focus session rewards)
- `LocalSessionRepository.getDailyMinutesForHabit()` for per-habit heatmap queries
- `earnCoins` assertion tests in CoinService test suite

## [2.19.0] - 2026-02-24

### Added
- **Local-first architecture**: Action Ledger (`action_ledger` table) records all data-mutating operations as immutable events; `materialized_state` caches derived aggregates; 7 new SQLite tables mirror Firestore schema as runtime SSOT
- **Guest mode**: Auto anonymous sign-in on first launch; guest upgrade prompt in Drawer; account linking via `linkWithGoogle()` / `linkWithEmail()`
- **Sync Engine**: Background Firestore synchronization with debounced triggers (2s), exponential backoff retry, and 90-day ledger cleanup
- **Achievement Evaluator**: Event-driven achievement evaluation that listens to ledger changes, replacing manual trigger calls across screens
- **App Drawer**: M3 NavigationDrawer with guest upgrade banner, milestone card, session history, settings, and account management
- **AI teaser cards**: ShaderMask blur preview for guest users on CatDetailScreen, encouraging account upgrade
- Guest ID generator (`guest_id_generator.dart`) for secure 10-char short IDs
- `LedgerAction` and `ActionType` models for action ledger events
- `UnlockedAchievement` model for local achievement records
- `LedgerService` for ledger writes, broadcast stream, and materialized state CRUD
- `LocalHabitRepository`, `LocalCatRepository`, `LocalSessionRepository` for SQLite-backed domain CRUD
- `isAnonymousProvider` for guest mode detection across UI
- `newlyUnlockedProvider` for achievement celebration queue
- `syncEngineProvider` for background sync lifecycle management
- Login screen and email auth screen support `linkMode` for guest account linking
- 22 new L10N strings across 5 languages (EN, zh, zh-Hant, ja, ko) for Drawer, guest upgrade, and AI teaser

### Changed
- Navigation restructured: 4 Tab → 3 Tab (Today, CatRoom, Achievement) + Drawer; Profile moved to Drawer
- AuthGate auto-signs-in anonymously instead of showing LoginScreen for unauthenticated users
- `habitsProvider` now reads from `local_habits` SQLite table via `LedgerService.changes` stream
- `catsProvider` now reads from `local_cats` SQLite table via `LedgerService.changes` stream
- `coinBalanceProvider` now reads from `materialized_state` SQLite table
- `CoinService` and `InventoryService` now delegate to `LedgerService` for atomic SQLite transactions
- `LocalDatabaseService` upgraded from DB v1 to v2 with 7 new tables
- Models (`Habit`, `Cat`, `FocusSession`, `MonthlyCheckIn`) now include `toSqlite()` / `fromSqlite()` methods
- Architecture documentation updated across all 8 docs (EN + zh-CN) to reflect local-first architecture

### Removed
- SummaryItem triple from TodayTab (coin/cat/quest counts)
- Direct Firestore dependency for runtime data reads (now via SQLite local tables)

## [2.18.1] - 2026-02-23

### Removed
- Unused `assets/sprites/` and `assets/room/` declarations from pubspec.yaml (legacy placeholders never implemented)
- CI workaround that created empty asset directories during build

## [2.18.0] - 2026-02-23

### Added
- M3 tablet-responsive achievement page: adaptive grid (Feed Layout) and side-by-side stats dashboard (Supporting Pane Layout)
- OverviewTab sub-component extraction: `OverviewStatCard`, `OverviewWeeklyTrend`, `OverviewHeatmapCard`, `OverviewRecentSessions`
- Onboarding tablet layout: side-by-side illustration + content on expanded screens
- Login screen tablet adaptation with centered constrained width (480dp)
- Focus setup screen scrollable layout for tablet compatibility
- Development workflow documentation (EN + zh-CN) covering hot reload, build modes, and debugging
- Gradle build optimizations: parallel builds, build cache, UseParallelGC

### Changed
- Achievement grid uses `SliverGridDelegateWithMaxCrossAxisExtent` for auto-adapting columns (replaces fixed column count)
- OverviewTab: expanded layout shows 4×1 summary cards, side-by-side charts, 2-column habit progress
- Cat room navigation replaced `OpenContainer` with standard `MaterialPageRoute`
- Onboarding copy refreshed across all languages — removed outdated XP/streak references, aligned with cumulative time growth model
- `AchievementCard` margin reduced from 16dp to 8dp to work with grid cross-axis spacing

### Removed
- `ContentWidthConstraint` wrapper from `AchievementScreen` (root cause of tablet layout issues)

## [2.17.0] - 2026-02-23

### Added
- Hero flight animation for cat sprites and names during CatHouse → CatDetail transitions
- Tablet-optimized responsive layouts for CatDetail (2-column) and Achievement (adaptive grid) screens
- `AppIconSize` design token system for consistent icon sizing across the app
- `SegmentedButton` for quest mode selection in adoption and edit flows (replacing custom cards)
- `SharedAxisTransition` for same-level navigation routes (AI Settings, Test Chat, Session History)
- Comprehensive accessibility: `Semantics` labels, `semanticLabel` on icons, tooltips on all `IconButton`s
- `StaggeredListItem` stagger animations extended to Profile, Settings, and CatDetail screens

### Changed
- Onboarding copy refreshed: removed outdated XP/streak references, aligned with cumulative time growth model
- All hardcoded `Colors.*` in UI body areas replaced with `ColorScheme` semantic tokens (8 locations, 6 files)
- Bare `TextStyle()` constructors replaced with `textTheme.*` base styles (migration screen, accessory card)
- Chat bubble `BoxShadow` replaced with `Material(elevation:)` for M3 tonal elevation (2 chat screens)
- Component themes added: `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `Dialog` + global `MaterialTapTargetSize.padded`
- Quest mode toggle upgraded from custom `_ModeOption` cards to native M3 `SegmentedButton`
- CatDetail screen refactored with `LayoutBuilder` for phone (single column) and tablet (2-column) layouts
- Achievement grid columns adapt to screen width: 1 (compact), 2 (medium), 3 (expanded)

### Removed
- Custom `_ModeOption` widget class from adoption flow and edit quest sheet (replaced by `SegmentedButton`)

## [2.16.0] - 2026-02-23

### Added
- M3 design token system: `AppShape` (shape scale), `AppElevation` (elevation scale)
- `AppMotion` extended with `durationShimmer` and `durationParticle` special-purpose tokens
- `StaggeredListItem` reusable widget for fade+slide stagger animations on lists and grids
- Container Transform transitions (`OpenContainer`) for cat card → detail and featured card → focus navigation
- Onboarding uses `SharedAxisTransition` (horizontal) for proper M3 step-based flow
- Google Play Store distribution: CI now builds AAB and uploads to internal track via Workload Identity Federation
- `distribution/whatsnew/` for Google Play release notes
- Google Play setup guide (`docs/release/google-play-setup.md`, EN + zh-CN)

### Changed
- All hardcoded `BorderRadius.circular(N)` replaced with `AppShape` tokens across 29 files (49 replacements)
- All hardcoded `Duration(milliseconds:)` and `Curves.*` replaced with `AppMotion` tokens across 12 files
- All `showModalBottomSheet` calls now include `showDragHandle: true` (6 call sites)
- NavigationBar `labelBehavior` changed from `onlyShowSelected` to `alwaysShow` (M3 spec for ≤4 destinations)
- Achievement cards use Outlined Card variant; Profile Journey card uses Filled Card variant
- Profile `_StageChip` refactored to M3 `Chip` widget; `_StatBadge` wrapped with surface container
- `_CatHouseCard` Card wrapper removed — `OpenContainer` provides container styling
- `app_theme.dart` consumes `AppShape` and `AppElevation` tokens for card, dialog, and bottom sheet theming
- CI workflow updated: builds both APK and AAB, reports sizes for both, uploads to Google Play
- Release process docs updated for Google Play dual-channel distribution (EN + zh-CN)
- `auth_service.dart` null-safety improvement for `updateDisplayName`
- `firestore_service.dart` `updateUserProfile` now records errors via `ErrorHandler`

### Removed
- Redundant `Hero` tags on FeaturedCatCard and CatHouseCard (replaced by OpenContainer container transform)
- Manual drag handle bar in `reminder_picker_sheet.dart` (replaced by native `showDragHandle: true`)

## [2.15.0] - 2026-02-23
### Added
- Gemini 3 Flash as second AI provider — user-selectable in AI settings
- AI settings moved to dedicated sub-page with provider selection (MiniMax/Gemini)
- `SseParser` now supports pluggable token extractors via `SseTokenExtractor` typedef
- `AiProviderId` enum and `AiProviderSelectionNotifier` for persistent provider selection
- `.env.example` for local development API key management (`flutter run --dart-define-from-file=.env`)
- New L10N keys for provider selection across all 5 languages

### Changed
- MiniMax model upgraded from M2 to M2.5
- AI settings extracted from Settings main page into `/ai-settings` route (full-screen Scaffold)
- Settings main page now shows AI as a navigation ListTile with status subtitle
- `RadioListTile` migrated to `RadioGroup` pattern (Flutter 3.41 deprecation fix)
- `animated_mesh_background.dart` null-safety fix for `ModalRoute.animation`
- CI workflow updated to inject `GEMINI_API_KEY` secret during release builds

### Removed
- `ai_settings_section.dart` — logic migrated to `ai_settings_page.dart`

## [2.14.0] - 2026-02-23
### Changed
- AI system migrated from local LLM (Qwen-1.7B via llama_cpp_dart) to cloud-based MiniMax API
- Provider-agnostic architecture: abstract `AiProvider` interface with Strategy Pattern for future provider support
- AI availability simplified from 5-state to 3-state model (disabled/ready/error)
- Prompt format migrated from ChatML strings to structured `List<AiMessage>` (OpenAI messages format)
- Settings AI section rewritten: removed model download UI, added cloud badge, connection test, and privacy dialog
- Test chat screen simplified: removed model loading/corruption handling, validates cloud connection directly

### Added
- `AiProvider` abstract interface (`core/ai/`) — supports generate, generateStream, cancel, validateConnection
- `MiniMaxProvider` implementation with SSE streaming, MiniMax-specific error mapping, and dart:io HttpClient
- `SseParser` reusable SSE stream parser for all OpenAI-compatible providers
- `AiService` facade with Completer-based mutex for concurrency control
- Privacy disclosure dialog on first AI enable (persisted via SharedPreferences)
- `AiRequestConfig` with static presets (chat, diary, validation)
- `AiException` typed error hierarchy (network, auth, rate limit, balance, server, cancelled, unconfigured)
- New L10N keys for cloud AI UI across all 5 languages (EN/ZH/ZH-Hant/JA/KO)

### Removed
- `llama_cpp_dart` vendored package and all local model infrastructure
- `background_downloader` dependency (was used for model download)
- `LlmService`, `ModelManagerService`, `llm_constants.dart`, `llm_provider.dart`
- Model download progress UI, pause/resume/cancel buttons, model deletion dialog
- `scripts/setup_llm_vendor.sh` build script

## [2.13.0] - 2026-02-23
### Changed
- Quest creation and editing forms unified — identical field order, section headers, and component styles
- Edit Quest upgraded from bottom sheet to full-screen Scaffold page with AppBar
- Mode toggle in Edit Quest replaced from `SegmentedButton` to `_ModeOption` cards (matching creation flow)
- Note/memo field (formerly "motivation") now supports multiline input (maxLines: 4, minLines: 2)
- GrowthPathCard always fully expanded — removed `ExpansionTile` and `initiallyExpanded` parameter
- GrowthPathCard moved to bottom of form (after reminders) in both creation and editing flows
- Featured cat card on Today page upgraded to 3-line layout: cat name, quest name, and note/memo
- "Motivational quote" renamed to "Note/memo" across all 5 languages (EN/ZH/ZH-Hant/JA/KO)
- Dividers removed from adoption flow Step 1 — replaced with spacing for cleaner visual separation

### Added
- Reminder management in Edit Quest — add/remove reminders with persistence and notification rescheduling
- GrowthPathCard displayed in Edit Quest page (was only in creation flow)

### Fixed
- Documentation sync: `screens.md` and `data-model.md` updated to reflect current implementation (EN + zh-CN)
- `data-model.md` corrected stale `reminderTime` field to `reminders` list, `motivationText` max length 40 → 240

## [2.12.0] - 2026-02-23
### Added
- Multi-reminder system — each quest supports up to 5 independent reminders with 9 scheduling modes (daily, weekdays, individual days)
- Reminder picker bottom sheet with time and mode selection
- 4-step account deletion flow with data summary, DELETE confirmation, Google re-auth, and progress dialog
- Custom daily goal and target hours input dialogs in quest editing
- Motivation quote field expanded to 240 characters
- `ReminderConfig` model with localized descriptions and defensive Firestore parsing
- `AccountDeletionService` with auth-first deletion order (prevents orphaned accounts)
- 48 new L10N keys across 5 languages (EN/ZH/ZH-Hant/JA/KO) for reminders, account deletion, and achievements

### Changed
- Check-in banner redesigned: removed spinner, switched to manual check-in with explicit button
- Featured cat card redesigned with two-row layout
- Adoption flow Step 1 UI simplified — removed Card containers for cleaner look
- Keyboard auto-dismisses on step switch in adoption flow
- Notification text fully localized (was hardcoded English)
- `NotificationService` access unified through provider pattern across all screens and providers
- `NotificationSettingsDialog` converted from `StatefulWidget` to `ConsumerStatefulWidget`
- Notification ID space expanded from `%10000` to `%100000` to reduce collision probability

### Fixed
- Account deletion now deletes Auth account first — if Auth fails, user data is preserved
- 3 `use_build_context_synchronously` warnings resolved with mounted guards
- `_onProgress` callback in deletion dialog hardened with `ctx.mounted` guard
- `_pickDeadlineDate` missing mounted check after `showDatePicker` await
- Malformed Firestore reminder data no longer crashes — `tryFromMap` filters invalid entries

### Removed
- Redundant `_reminderDescription` switch statements in 3 files — consolidated into `ReminderConfig.localizedDescription()`

## [2.11.0] - 2026-02-22
### Changed
- Quest goal system redesigned: quests now support **unlimited mode** (no target, continuous accumulation) and **milestone mode** (target hours + optional deadline)
- Cat growth uses a fixed 4-stage time ladder (0h/20h/100h/200h) independent of quest target — all cats grow at the same pace
- Senior stage re-enabled as the 4th growth stage (200h milestone)
- Quest creation flow redesigned with mode toggle (unlimited/milestone), daily goal, and optional deadline picker
- Quest editing supports switching between unlimited and milestone modes
- Achievement celebration upgraded from SnackBar to full-screen animated overlay with confetti, coin display, and queue system
- Achievement screen reduced from 5 tabs to 4 (streak tab removed)
- Profile page stage breakdown expanded to 4 stages with responsive Wrap layout
- Architecture docs (data-model, cat-system) updated in both EN and zh-CN

### Added
- "Growth Path" card in quest creation flow — shows 4-stage milestones with research-backed tips (Josh Kaufman's 20-hour rule)
- `AchievementCelebrationLayer` — global overlay mounted at app root, supports multi-achievement queue with dismiss/skip-all
- Confetti particle effect and glowing icon animation for achievement celebrations
- 4 new achievements: `hours_100`, `hours_1000`, `goal_on_time`, `goal_ahead` with associated titles
- `deadlineDate` (optional) and `targetCompleted` (auto-conversion flag) fields on Habit model
- `isUnlimited` computed property on Habit model
- Haptic feedback on achievement unlock
- Firestore rules for new habit fields and senior stage validation
- 11 new L10N keys across 5 languages (EN/ZH/ZH-Hant/JA/KO)

### Removed
- **Streak system entirely removed** — `currentStreak`, `bestStreak` fields, `streak_utils.dart`, streak calculation logic, streak XP bonuses
- 8 streak-based achievements (`streak_3` through `streak_365`) and streak achievement category
- `targetMinutes` field from Cat model (replaced by fixed growth ladder)
- `logStreakAchieved()` analytics event
- Old SnackBar-based achievement notification in HomeScreen

## [2.10.0] - 2026-02-22
### Changed
- Cat growth system simplified from 4 stages to 3: kitten (<33%), adolescent (33%–66%), adult (>=66%)
- Equal stage distribution (33/33/34) replaces old uneven thresholds (20/25/30/25)
- Cat detail page shows 3 stage milestones instead of 4
- Profile page shows 3 stage count chips instead of 4
- "Elder Whiskers" achievement renamed to "Master Cat" — now triggers at 100% growth target completion
- LLM prompt stage names updated: 青年猫 (adolescent), 成熟猫 (adult)

### Added
- `highestStage` field on Cat model — prevents visual stage regression when users increase target hours
- `displayStage` computed property — returns the higher of computed stage and stored highest stage
- Legacy data compatibility: cats without `highestStage` use old thresholds to avoid visual regression
- Firestore security rules validation for `highestStage` field
- Atomic `highestStage` update in `logFocusSession` (only increases, never decreases)

### Removed
- Senior stage (was >=75%) — merged into adult stage
- Senior-specific scoring in Featured Cat selection algorithm

## [2.9.1] - 2026-02-22
### Added
- Motivational quote field on quests — set during creation with random locale-aware quotes, editable later
- "New quote" button to randomly swap motivation quotes across 5 languages (en/zh/zh-Hant/ja/ko)
- Motivation quote display on FocusSetupScreen (italic, below cat mood) and FocusStatsCard (single-line)
- Motivation quote editing in EditQuestSheet with clear/swap support

### Changed
- Adoption flow Step 1 refactored from flat list to 3 card-based sections (Basic info / Goals / Reminder)
- Firestore security rules updated to validate `motivationText` field (optional string, max 40 chars)

## [2.9.0] - 2026-02-22
### Added
- Achievement system with 163 achievements across 4 categories: Quest (8), Streak (8), Cat (9), Persist (138)
- Achievement evaluation engine triggered after focus sessions, habit creation, check-in, and accessory equip
- 8 unlockable titles tied to milestone achievements (e.g. Marathon Cat, Centurion, Four Seasons)
- Achievement screen with 5 tabs (Overview, Quest, Streak, Cat, Persist) replacing bottom nav Stats tab
- Achievement cards with progress bars, coin rewards, and unlock status
- Achievement summary header with progress ring showing unlocked/total count
- Title display on profile page with unlocked title count chip
- Bilingual achievement names and descriptions (EN + ZH) via static string maps
- Firestore `achievements/{id}` subcollection for unlock records (immutable, create-only)
- `totalCheckInDays` field on habits for persist achievement tracking
- `totalSessionCount` field on user document for session-based achievements
- Analytics event `achievement_unlocked` with achievement ID parameter
- Firestore security rules for achievements subcollection

### Changed
- Bottom navigation tab 2: Stats icon/label replaced with Achievements (emoji_events)
- Home screen now listens to `newlyUnlockedProvider` and shows unlock celebration SnackBar
- Overview tab extracted from former StatsScreen into reusable component

## [2.8.4] - 2026-02-22
### Fixed
- Focus timer: foreground service notification now dismissed before completion notification, preventing notification overlap
- Focus timer: notification text reordered to show time before habit name, with truncation at 20 characters
- Focus history: added error handling with retry UI when loading fails (was silently swallowed)
- Focus history: added 10-second timeout to cross-habit Firestore queries

### Added
- Focus history: month and habit filter via ActionChip + BottomSheet (replaces horizontal FilterChip list)
- Focus history: month-based date range filtering at Firestore query level for faster loads
- Focus timer: AlarmManager backup notification via `zonedSchedule()` for OS-killed foreground service

### Changed
- Docs: updated focus-completion.md with backup alarm spec and corrected completion flow (EN + zh-CN)

## [2.8.3] - 2026-02-22
### Changed
- Docs: updated design-system.md with unified Theme Color dialog and brightness-aware card theme (EN + zh-CN)
- Docs: updated cat-system.md with navigation vs interaction layer design rule (EN + zh-CN)
- Docs: updated release/process.md with CI monitoring, formatting checklist, and user-facing release body requirements (EN + zh-CN)
- Added .claude/memory/ and .claude/rules/12-workflow-release.md to version control for cross-device sync

## [2.8.2] - 2026-02-22
### Changed
- Settings: merged Material You toggle into Theme Color picker — "Dynamic" wallpaper option + 8 preset colors in a single dialog
- Settings: moved Pixel Cat Sprites CC BY-NC 4.0 attribution into Flutter license registry
- Theme: improved card visibility in dark mode (surfaceContainerHigh + subtle border) and light mode (surfaceContainerLow + elevation)
### Fixed
- Cat gesture conflict: tapping cats in album, home card, and cat room now navigates instead of switching poses
- Cat detail AppBar: replaced hardcoded white foreground with theme-aware colors

## [2.8.1] - 2026-02-22
### Fixed
- Cat detail page: cat sprite and personality text now correctly centered in AppBar
- AnimatedMeshBackground: internally enforces tight constraints, preventing layout drift in loose-constraint contexts

## [2.8.0] - 2026-02-21
### Added
- Redesigned stats page with weekly trend chart (fl_chart), summary cards, and session history with pagination
- Enhanced FocusSession model: status (completed/abandoned/interrupted), completionRatio, coinsEarned, HMAC checksum
- `logStatsViewed()` and `logHistoryViewed()` analytics events
### Fixed
- 13 dark mode brightness-aware color issues across 12+ files

## [2.7.0] - 2026-02-21
### Changed
- Optimized cold startup performance 6-8x via deferred initialization
- Improved cat detail UI layout and responsiveness

## [2.6.0] - 2026-02-21
### Added
- Firebase Crashlytics deep integration with non-fatal error reporting
- Firebase Performance monitoring with custom traces
- Enhanced GA4 analytics coverage across all screens

## [2.5.0] - 2026-02-21
### Fixed
- 11 tech debt issues in focus timer and notification system
- Timer notification action buttons (pause/resume/stop)
- LLM model load failure with corrupted file detection and auto-heal

## [2.4.0] - 2026-02-21
### Added
- Traditional Chinese (zh-Hant), Japanese, and Korean language support
- Fixed 65+ hardcoded strings migrated to ARB l10n

## [2.3.0] - 2026-02-20
### Fixed
- Comprehensive audit: 43 issues fixed across runtime, error handling, i18n, tests, and security
- CI pipeline: SDK licenses, sdkmanager paths, R8 dontwarn rules, NDK pinning, vendor setup ordering

## [2.2.0] - 2026-02-20
### Changed
- Cleanup: removed dead code paths, fixed golden tests for CI
- l10n helpers for CatPersonality display name and flavor text

## [2.0.0] - 2026-02-20
### Added
- Full i18n migration for cat system, appearance descriptions, and LLM prompts
- Bilingual LLM prompt system (EN/ZH)
### Changed
- Comprehensive codebase refactoring: DRY extraction across services and providers
- Expanded test coverage and consolidated duplicate logic

## [1.9.0] - 2026-02-19

### Added

- package_info_plus: runtime version display (no more hardcoding)
- Golden tests for SkeletonLoader, EmptyState, ErrorState
- Stricter lint rules (analysis_options.yaml)
- Pre-commit hook for version/tag consistency
- CHANGELOG.md

### Changed

- AppSpacing applied across all remaining files
- CLAUDE.md: expanded Commands section
- CI: version consistency check step + test step

### Fixed

- Version number in Settings was stuck at 1.8.0 (now reads from system)
- Fixed confetti_widget package name (→ confetti) and upgraded vibration to v3.x
- Fixed avoid_dynamic_calls violations in home_screen, cat_room_screen, pixel_cat_renderer
- Fixed extra argument in _buildAppearanceDetails call (cat_detail_screen)

## [1.8.0] - 2026-02-19

### Added

- Material You (dynamic_color) with settings toggle
- Accessibility: Semantics on all custom widgets
- FadeThrough tab transitions, Hero cat sprites, celebration animations
- SkeletonLoader, EmptyState, ErrorState reusable widgets
- AppSpacing and AppMotion token constants

### Changed

- Replaced hardcoded colors (onboarding, login, coin icon)
- design-system.md rewritten to match actual code

## [1.7.0] - 2026-02-18

### Changed

- Migrated to llama_cpp_dart, upgraded to Riverpod 3.x
