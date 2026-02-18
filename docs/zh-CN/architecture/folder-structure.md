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
│   ├── architecture/                       # 技术架构
│   ├── product/                            # 产品需求
│   ├── firebase/                           # Firebase 配置
│   ├── design/                             # UI/UX 设计
│   └── zh-CN/                              # 中文文档镜像
│
├── lib/                                    # 应用源代码
│   ├── main.dart                           # 入口：Firebase + 前台服务初始化
│   ├── app.dart                            # 根组件：AuthGate + _FirstHabitGate + MaterialApp
│   │
│   ├── core/                               # 共享跨领域关注点
│   │   ├── constants/
│   │   │   ├── analytics_events.dart       # SSOT：所有 GA4 事件名 + 参数
│   │   │   └── cat_constants.dart          # SSOT：品种、阶段、心情、房间槽位
│   │   ├── router/
│   │   │   └── app_router.dart             # 命名路由注册表 + 路由常量
│   │   └── theme/
│   │       └── app_theme.dart              # SSOT：Material 3 主题（种子色、排版）
│   │
│   ├── models/                             # 数据模型（Dart 类，无 Flutter 依赖）
│   │   ├── cat.dart                        # 猫咪 —— Firestore 模型 + 计算属性（阶段、心情）
│   │   ├── habit.dart                      # 习惯 —— Firestore 模型
│   │   ├── focus_session.dart              # FocusSession（专注会话）—— 会话历史记录
│   │   └── check_in.dart                   # CheckInEntry（打卡条目）—— 向后兼容
│   │
│   ├── services/                           # Firebase SDK 封装层（无 UI，无 BuildContext）
│   │   ├── analytics_service.dart          # Firebase Analytics（分析）封装 —— 记录事件
│   │   ├── auth_service.dart               # Firebase Auth（认证）封装 —— 登录/注销/注册
│   │   ├── cat_generation_service.dart     # 抽卡算法 —— 加权品种选择
│   │   ├── firestore_service.dart          # Firestore CRUD + 原子批量操作
│   │   ├── focus_timer_service.dart        # Android 前台服务封装
│   │   ├── notification_service.dart       # FCM + flutter_local_notifications
│   │   ├── remote_config_service.dart      # Remote Config（远程配置）—— 类型化 getter + 默认值
│   │   └── xp_service.dart                 # XP 计算（纯 Dart，无 Firebase 依赖）
│   │
│   ├── providers/                          # Riverpod Provider —— 各领域的响应式 SSOT
│   │   ├── auth_provider.dart              # authStateProvider、currentUidProvider
│   │   ├── cat_provider.dart               # catsProvider、allCatsProvider、catByIdProvider (family)
│   │   ├── focus_timer_provider.dart       # focusTimerProvider（有限状态机）
│   │   ├── habits_provider.dart            # habitsProvider、todayCheckInsProvider
│   │   └── stats_provider.dart             # statsProvider（计算型 HabitStats）
│   │
│   ├── screens/                            # 全页界面（消费 Provider，无业务逻辑）
│   │   ├── auth/
│   │   │   └── login_screen.dart           # 登录 + 注册（邮箱/密码 + Google）
│   │   ├── cat_detail/
│   │   │   └── cat_detail_screen.dart      # 猫咪信息、XP 进度条、热力图、里程碑
│   │   ├── cat_room/
│   │   │   └── cat_room_screen.dart        # 插画房间场景，猫咪分布其中
│   │   ├── habits/
│   │   │   └── adoption_flow_screen.dart   # 3 步习惯创建 + 猫咪领养
│   │   ├── home/
│   │   │   └── home_screen.dart            # 4 标签 NavigationBar 外壳 + 今日标签
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart      # 3 页引导走马灯
│   │   ├── profile/
│   │   │   └── profile_screen.dart         # 统计数据、猫咪相册、设置
│   │   ├── stats/
│   │   │   └── stats_screen.dart           # 活动热力图 + 各习惯进度
│   │   └── timer/
│   │       ├── focus_setup_screen.dart     # 启动前的时长 + 模式选择
│   │       ├── focus_complete_screen.dart  # XP 动画 + 会话总结
│   │       └── timer_screen.dart           # 活跃计时器（含前台服务）
│   │
│   └── widgets/                            # 可复用 UI 组件（优先无状态）
│       ├── cat_preview_card.dart           # 领养第 2 步中的猫咪候选卡片
│       ├── cat_sprite.dart                 # 猫咪显示：品种着色 + 阶段/心情选择
│       ├── emoji_picker.dart               # 约 30 个 Emoji 的精选网格（用于习惯图标）
│       ├── progress_ring.dart              # 圆形进度指示器（计时器圆环）
│       ├── streak_heatmap.dart             # 91 天 GitHub 风格活动热力图
│       └── streak_indicator.dart           # 展示当前连续记录天数的火焰徽章
│
├── assets/
│   ├── sprites/                            # 猫咪精灵图 PNG：cat_{stage}_{mood}.png
│   └── room/                               # 房间背景图
│       ├── room_day.png                    # 白天房间背景
│       └── room_night.png                  # 夜晚房间背景
│
├── android/                                # Android 平台项目
│   ├── app/
│   │   ├── google-services.json            # Firebase 配置（已 gitignore）
│   │   └── src/main/
│   │       └── AndroidManifest.xml         # 权限 + 服务声明
│   └── ...
│
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
| Dart 文件 | `snake_case.dart` | `cat_generation_service.dart` |
| 类名 | `PascalCase` | `CatGenerationService` |
| 常量 | `camelCase`（变量），`kConstantName`（编译期常量） | `catBreeds`、`kMaxRoomCats` |
| Provider | `camelCase` + `Provider` 后缀 | `catsProvider`、`focusTimerProvider` |
| Screen | `PascalCase` + `Screen` 后缀 | `CatRoomScreen` |
| Widget | `PascalCase` 描述性名词 | `CatSprite`、`StreakHeatmap` |
| Service | `PascalCase` + `Service` 后缀 | `FirestoreService` |
| 模型 | `PascalCase` 名词 | `Cat`、`Habit`、`FocusSession` |
| 资源文件 | `snake_case` | `cat_kitten_happy.png`、`room_day.png` |
| 文档文件 | `kebab-case.md` | `data-model.md`、`cat-system.md` |

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

**执行原则：** 若 Screen 需要调用 Service，必须通过 Provider 方法进行，不得直接导入 Service。这保证了依赖图无环且可测试。

---

## 每文件一个类原则

每个 Dart 文件包含且仅包含一个公共类（或一个公共顶层函数，用于工具方法）。支持该公共类的小型私有辅助类（以 `_` 前缀）可与公共类同文件存放。

**正确：** `cat_room_screen.dart` 包含 `CatRoomScreen` 和私有辅助类 `_SpeechBubble`

**错误：** `screens.dart` 同时包含 `CatRoomScreen`、`CatDetailScreen` 和 `TimerScreen`
