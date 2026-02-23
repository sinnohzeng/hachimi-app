# 项目目录结构（SSOT）

> 本文档定义了 Hachimi 代码库的权威目录布局和命名规范。所有新文件必须严格遵循以下规范。

---

## 完整目录树

```
hachimi-app/
│
├── docs/                                   # DDD（文档驱动开发）：所有规范文档
│   ├── README.md                           # 文档索引
│   ├── CONTRIBUTING.md                     # 开发工作流 + 规范
│   ├── architecture/
│   │   ├── overview.md                     # 系统设计 + 依赖方向
│   │   ├── data-model.md                   # Firestore 模式（SSOT）
│   │   ├── cat-system.md                   # 猫咪游戏设计（SSOT）
│   │   ├── state-management.md             # Riverpod Provider 图谱（SSOT）
│   │   ├── folder-structure.md             # 本文件
│   │   ├── atomic-island.md               # vivo 原子岛通知规格说明
│   │   ├── focus-completion.md            # 专注完成庆祝流程规格说明
│   │   └── localization.md                 # i18n 方案 + ARB 工作流
│   ├── product/
│   │   ├── prd.md                          # PRD v3.0（SSOT）
│   │   └── user-stories.md                 # 用户故事 + 验收标准
│   ├── firebase/
│   │   ├── setup-guide.md                  # Firebase 分步设置指南
│   │   ├── analytics-events.md             # GA4 事件定义（SSOT）
│   │   ├── security-rules.md               # Firestore 安全规则规范
│   │   └── remote-config.md                # Remote Config 参数定义
│   ├── design/
│   │   ├── design-system.md                # Material 3 主题规范（SSOT）
│   │   └── screens.md                      # 逐屏 UI 规格说明
│   └── zh-CN/                              # 中文文档镜像
│       ├── README.md
│       ├── CONTRIBUTING.md
│       ├── architecture/ ...
│       ├── product/ ...
│       ├── firebase/ ...
│       └── design/ ...
│
├── lib/                                    # 应用源代码
│   ├── main.dart                           # 入口：Firebase + 前台服务初始化
│   ├── app.dart                            # 根组件：AuthGate + _FirstHabitGate + MaterialApp
│   │
│   ├── core/                               # 共享跨领域关注点
│   │   ├── constants/
│   │   │   ├── analytics_events.dart       # SSOT：所有 GA4 事件名 + 参数
│   │   │   ├── cat_constants.dart          # SSOT：阶段、心情、性格
│   │   │   ├── pixel_cat_constants.dart    # SSOT：pixel-cat-maker 外观参数值集
│   │   │   ├── ai_constants.dart          # SSOT：LLM 模型元数据、prompt 模板、推理参数
│   │   │   └── avatar_constants.dart     # SSOT：预设头像选项（id、图标、颜色）
│   │   ├── utils/
│   │   │   ├── appearance_descriptions.dart # 猫咪外观参数的人类可读描述
│   │   │   ├── date_utils.dart             # AppDateUtils — 统一日期字符串格式化
│   │   │   ├── streak_utils.dart           # StreakUtils — 连续打卡计算逻辑
│   │   │   └── background_color_utils.dart # 从猫咪阶段/毛色提取 mesh 渐变色
│   │   ├── router/
│   │   │   └── app_router.dart             # 命名路由注册表 + 路由常量
│   │   └── theme/
│   │       ├── app_theme.dart              # SSOT：Material 3 主题（种子色、排版）
│   │       ├── app_spacing.dart            # M3 间距 Token（xs/sm/md/base/lg/xl/xxl）
│   │       └── app_motion.dart             # M3 动效 Token（时长 + 缓动曲线）
│   │
│   ├── l10n/                               # 本地化 ARB 源文件
│   │   ├── app_en.arb                      # 英文字符串（主要）
│   │   └── app_zh.arb                      # 中文字符串
│   │
│   ├── models/                             # 数据模型（Dart 类，无 Flutter 依赖）
│   │   ├── cat.dart                        # 猫咪 —— Firestore 模型 + 计算属性（阶段、心情）
│   │   ├── cat_appearance.dart             # CatAppearance —— pixel-cat-maker 参数值对象
│   │   ├── habit.dart                      # 习惯 —— Firestore 模型
│   │   ├── focus_session.dart              # FocusSession（专注会话）—— 会话历史记录
│   │   ├── check_in.dart                   # CheckInEntry（打卡条目）—— 向后兼容
│   │   ├── diary_entry.dart                # DiaryEntry — 本地 SQLite 模型（AI 日记）
│   │   └── chat_message.dart               # ChatMessage — 本地 SQLite 模型（AI 聊天）
│   │
│   ├── services/                           # Firebase SDK 封装层（无 UI，无 BuildContext）
│   │   ├── analytics_service.dart          # Firebase Analytics（分析）封装 —— 记录事件
│   │   ├── auth_service.dart               # Firebase Auth（认证）封装 —— 登录/注销/注册
│   │   ├── cat_firestore_service.dart      # 猫咪专属 Firestore CRUD（watchCats、watchAllCats）
│   │   ├── coin_service.dart               # 金币余额 + 配饰购买操作
│   │   ├── firestore_service.dart          # 通用 Firestore CRUD + 原子批量操作
│   │   ├── atomic_island_service.dart      # vivo 原子岛富通知（MethodChannel 封装）
│   │   ├── focus_timer_service.dart        # Android 前台服务封装
│   │   ├── migration_service.dart          # 模式演进的数据迁移（如 breed -> appearance）
│   │   ├── notification_service.dart       # FCM + flutter_local_notifications
│   │   ├── pixel_cat_generation_service.dart # 随机猫咪生成 —— 外观 + 性格
│   │   ├── pixel_cat_renderer.dart         # 13 层精灵图合成器（pixel-cat-maker 引擎）
│   │   ├── remote_config_service.dart      # Remote Config（远程配置）—— 类型化 getter + 默认值
│   │   ├── xp_service.dart                 # XP 计算（纯 Dart，无 Firebase 依赖）
│   │   ├── ai/                             # AI 子模块
│   │   │   ├── minimax_provider.dart        # MiniMax M2.5 HTTP SSE 实现
│   │   │   ├── gemini_provider.dart        # Gemini 3 Flash HTTP SSE 实现
│   │   │   └── sse_parser.dart              # SSE 流解析工具（可插拔 token 提取器）
│   │   ├── diary_service.dart             # AI 日记生成 + SQLite 读写
│   │   ├── chat_service.dart              # AI 聊天 prompt + 流式生成 + SQLite 读写
│   │   └── local_database_service.dart    # SQLite 初始化（日记 + 聊天表）
│   │
│   ├── providers/                          # Riverpod Provider —— 各领域的响应式 SSOT
│   │   ├── app_info_provider.dart           # appInfoProvider（运行时从 package_info_plus 读取版本）
│   │   ├── auth_provider.dart              # authStateProvider、currentUidProvider（re-exports service_providers）
│   │   ├── service_providers.dart          # 非认证 Service 单例（Firestore、Analytics、Coin、XP 等）
│   │   ├── cat_provider.dart               # catsProvider、allCatsProvider、catByIdProvider (family)
│   │   ├── cat_sprite_provider.dart        # pixelCatRendererProvider、catSpriteImageProvider (family)
│   │   ├── accessory_provider.dart          # AccessoryInfo 数据类，用于商店和装备 UI
│   │   ├── coin_provider.dart              # coinServiceProvider、coinBalanceProvider、hasCheckedInTodayProvider
│   │   ├── connectivity_provider.dart      # connectivityProvider、isOfflineProvider
│   │   ├── focus_timer_provider.dart       # focusTimerProvider（有限状态机 + SharedPreferences 持久化）
│   │   ├── habits_provider.dart            # habitsProvider、todayCheckInsProvider
│   │   ├── locale_provider.dart            # localeProvider（应用语言覆盖）
│   │   ├── stats_provider.dart             # statsProvider（计算型 HabitStats）
│   │   ├── theme_provider.dart             # themeProvider（主题模式 + 种子色）
│   │   ├── user_profile_provider.dart     # avatarIdProvider（Firestore 用户头像）
│   │   ├── ai_provider.dart              # AI 提供商选择、功能开关、可用性、服务装配
│   │   ├── diary_provider.dart            # diaryEntriesProvider、todayDiaryProvider（family）
│   │   └── chat_provider.dart             # chatNotifierProvider（StateNotifier family）
│   │
│   ├── screens/                            # 全页界面（消费 Provider，无业务逻辑）
│   │   ├── auth/
│   │   │   └── login_screen.dart           # 登录 + 注册（邮箱/密码 + Google）
│   │   ├── cat_detail/
│   │   │   ├── cat_detail_screen.dart      # 猫咪信息、进度条、热力图、配饰
│   │   │   ├── cat_diary_screen.dart     # AI 生成日记列表页
│   │   │   ├── cat_chat_screen.dart      # 猫猫聊天页（流式回复）
│   │   │   └── components/              # CatDetailScreen 提取的子组件
│   │   │       ├── focus_stats_card.dart
│   │   │       ├── reminder_card.dart
│   │   │       ├── edit_quest_sheet.dart
│   │   │       ├── cat_info_card.dart
│   │   │       ├── diary_preview_card.dart
│   │   │       ├── chat_entry_card.dart
│   │   │       ├── habit_heatmap_card.dart
│   │   │       └── accessories_card.dart
│   │   ├── cat_room/
│   │   │   ├── cat_room_screen.dart        # 2 列 CatHouse 网格，像素风猫咪
│   │   │   └── accessory_shop_screen.dart  # 饰品商店：3 标签网格 + 购买流程
│   │   ├── habits/
│   │   │   └── adoption_flow_screen.dart   # 3 步习惯创建 + 3 猫选择领养
│   │   ├── home/
│   │   │   └── home_screen.dart            # 4 标签 NavigationBar 外壳 + 今日标签
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart      # 3 页引导走马灯
│   │   ├── profile/
│   │   │   ├── profile_screen.dart         # 用户信息、统计数据、设置入口
│   │   │   └── components/
│   │   │       ├── edit_name_dialog.dart    # 显示名称编辑 AlertDialog
│   │   │       └── avatar_picker_sheet.dart # 预设头像选择 BottomSheet
│   │   ├── settings/
│   │   │   ├── settings_screen.dart        # 通知、语言、关于、账号操作
│   │   │   ├── ai_settings_page.dart       # AI 设置子页面（提供商选择、开关、状态）
│   │   │   ├── model_test_chat_screen.dart # AI 测试聊天（验证云端 AI 连接）
│   │   │   └── components/              # SettingsScreen 提取的子组件
│   │   │       ├── notification_settings_dialog.dart
│   │   │       ├── language_dialog.dart
│   │   │       ├── theme_mode_dialog.dart
│   │   │       ├── theme_color_dialog.dart
│   │   │       ├── delete_account_flow.dart
│   │   │       └── section_header.dart
│   │   ├── stats/
│   │   │   └── stats_screen.dart           # 活动热力图 + 各习惯进度
│   │   └── timer/
│   │       ├── focus_setup_screen.dart     # 启动前的时长 + 模式选择
│   │       ├── focus_complete_screen.dart  # XP 动画 + 会话总结
│   │       └── timer_screen.dart           # 活跃计时器（含前台服务）
│   │
│   └── widgets/                            # 可复用 UI 组件（优先无状态）
│       ├── accessory_card.dart             # 可复用饰品卡片（名称、价格标签、已拥有徽章）
│       ├── accessory_shop_section.dart     # CatDetailScreen 中的配饰网格 + 购买流程
│       ├── cat_house_card.dart             # CatHouse 2 列网格中的单只猫咪卡片
│       ├── check_in_banner.dart            # HomeScreen 上的每日签到金币横幅
│       ├── offline_banner.dart             # 离线指示器：cloud_off 图标 + 同步提示
│       ├── pixel_cat_sprite.dart           # 像素风猫咪显示组件（从 Provider 渲染 ui.Image）
│       ├── tappable_cat_sprite.dart       # 点击切换姿势封装组件（弹跳 + 触觉 + 本地变体）
│       ├── progress_ring.dart              # 圆形进度指示器（计时器圆环）
│       ├── skeleton_loader.dart            # M3 微光骨架屏（SkeletonLoader、SkeletonCard、SkeletonGrid）
│       ├── empty_state.dart               # 统一空状态（图标 + 标题 + 副标题 + 可选 CTA）
│       ├── error_state.dart               # 统一错误状态（图标 + 消息 + 重试按钮）
│       ├── streak_heatmap.dart             # 91 天 GitHub 风格活动热力图
│       ├── streak_indicator.dart           # 展示当前连续记录天数的火焰徽章
│       ├── animated_mesh_background.dart  # 可复用动态 mesh 渐变背景（含开关支持）
│       └── particle_overlay.dart          # 浮动粒子覆盖层（萤火虫/浮尘预设）
│
├── assets/
│   ├── pixel_cat/                          # pixel-cat-maker 精灵图层
│   │   ├── body/                           # 按 peltType + variant 的基础身体精灵图
│   │   ├── pelt/                           # 毛色叠加层
│   │   ├── white/                          # 白色斑块图案
│   │   ├── white_tint/                     # 白斑色调叠加层
│   │   ├── points/                         # 重点色图案（暹罗猫等）
│   │   ├── vitiligo/                       # 白斑病叠加层
│   │   ├── tortie/                         # 玳瑁猫基础图层
│   │   ├── tortie_pattern/                 # 玳瑁猫花纹变体
│   │   ├── tortie_color/                   # 玳瑁猫颜色叠加层
│   │   ├── fur/                            # 毛发长度叠加层（长/短）
│   │   ├── eyes/                           # 眼睛颜色精灵图
│   │   ├── skin/                           # 皮肤（鼻/耳）颜色精灵图
│   │   ├── tint/                           # 整体色调叠加层
│   │   └── accessories/                    # 配饰叠加精灵图
│   └── room/
│       ├── room_day.png                    # 白天房间背景
│       └── room_night.png                  # 夜晚房间背景
│
├── l10n.yaml                               # Flutter gen-l10n 配置
│
├── test/                                   # 自动化测试
│   ├── widget_test.dart                   # 框架健全性检查
│   ├── dart_test.yaml                     # 测试配置（golden 标签排除）
│   ├── models/
│   │   └── habit_test.dart                # Habit 模型单元测试
│   ├── providers/
│   │   ├── stats_provider_test.dart       # HabitStats 计算属性测试
│   │   ├── focus_timer_provider_test.dart # FocusTimerState 计算属性测试
│   │   ├── chat_provider_test.dart        # ChatState 默认值 + copyWith 测试
│   │   └── ai_provider_test.dart         # AiAvailability + ModelDownloadState 测试
│   ├── services/
│   │   ├── chat_service_test.dart         # ChatRole + ChatMessage 序列化测试
│   │   └── diary_service_test.dart        # DiaryEntry toMap/fromMap 往返测试
│   └── widgets/
│       ├── empty_state_test.dart          # EmptyState 组件测试
│       ├── error_state_test.dart          # ErrorState 组件测试
│       └── skeleton_loader_test.dart      # SkeletonLoader 组件测试
│
├── android/                                # Android 平台项目
│   ├── app/
│   │   ├── google-services.json            # Firebase 配置（已 gitignore）
│   │   └── src/main/
│   │       ├── AndroidManifest.xml         # 权限 + 服务声明
│   │       └── kotlin/com/hachimi/hachimi_app/
│   │           ├── MainActivity.kt        # Flutter Activity + MethodChannel 注册
│   │           └── FocusNotificationHelper.kt # 富通知构建器（原子岛适配）
│   └── ...
│
├── .github/
│   └── workflows/
│       └── release.yml                    # CI/CD：tag 触发的 release APK 构建 + GitHub Release
│
├── packages/                              # 本地化 native 包（gitignore 排除，参见 scripts/）
│
├── scripts/
│   ├── setup-release-signing.sh           # 交互式配置：keystore 生成 + GitHub Secrets 输出
│
├── dart_test.yaml                         # 测试配置（排除 golden 标签）
├── firestore.rules                         # 已部署的 Firestore 安全规则
├── firebase.json                           # Firebase 项目配置
├── pubspec.yaml                            # Flutter 依赖
├── pubspec.lock                            # 依赖版本锁定
├── README.md                               # 英文项目概览（根目录）
└── README.zh-CN.md                         # 中文项目概览（根目录）
```

---

## 命名规范

| 类别 | 规范 | 示例 |
|------|------|------|
| Dart 文件 | `snake_case.dart` | `pixel_cat_renderer.dart` |
| 类名 | `PascalCase` | `PixelCatRenderer` |
| 常量 | `camelCase`（变量），`kConstantName`（编译期常量） | `catPersonalities`、`kMaxCoins` |
| Provider | `camelCase` + `Provider` 后缀 | `catsProvider`、`coinBalanceProvider` |
| Screen | `PascalCase` + `Screen` 后缀 | `CatRoomScreen` |
| Widget | `PascalCase` 描述性名词 | `PixelCatSprite`、`CatHouseCard` |
| Service | `PascalCase` + `Service` 后缀 | `CatFirestoreService`、`CoinService` |
| 模型 | `PascalCase` 名词 | `Cat`、`CatAppearance`、`Habit` |
| 资源文件 | `snake_case` | `body_tabby_0.png`、`room_day.png` |
| 文档文件 | `kebab-case.md` | `data-model.md`、`cat-system.md` |
| ARB 键 | `screenName` + 用途（camelCase） | `homeTabToday`、`adoptionConfirmButton` |

---

## 层级规则

| 层级 | 允许导入 | 禁止导入 |
|------|---------|---------|
| `models/` | Dart 核心库 + `cloud_firestore`（用于 Timestamp） | Flutter、Service、Provider |
| `services/` | Models、Firebase SDK、Dart 核心库 | Flutter Widget、Provider、Screen |
| `providers/` | Service、Models、Riverpod | Flutter Widget、Screen |
| `screens/` | Provider、Widget、Models（只读）、Router | Service（绝不直接导入） |
| `widgets/` | Models（只读）、Theme | Service、Provider |
| `core/` | Dart 核心库 | 其他所有 |
| `l10n/` | （生成的）Dart 核心库 | 其他所有 |

**执行原则：** 若 Screen 需要调用 Service，必须通过 Provider 方法进行，不得直接导入 Service。这保证了依赖图无环且可测试。

---

## 每文件一个类原则

每个 Dart 文件包含且仅包含一个公共类（或一个公共顶层函数，用于工具方法）。支持该公共类的小型私有辅助类（以 `_` 前缀）可与公共类同文件存放。

**正确：** `cat_room_screen.dart` 包含 `CatRoomScreen` 和私有辅助类 `_CatHouseGridDelegate`

**错误：** `screens.dart` 同时包含 `CatRoomScreen`、`CatDetailScreen` 和 `TimerScreen`
