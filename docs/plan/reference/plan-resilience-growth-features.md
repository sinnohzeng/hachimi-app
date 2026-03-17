# 韧性成长功能迭代 — 灵感来源「点亮内心宇宙」

**创建时间**：2026-03-17
**状态**：待开发

## 背景

本计划源自对《得到精选》播客内容的产品分析——张晓萌教授联合得到图书推出的《点亮内心宇宙：韧性成长手册》。该产品实现了两个经科学验证的心理韧性核心机制：

1. **马丁·塞利格曼积极心理干预（每日三件好事）**：每天记录一件好事，6 个月实验结果：幸福感 +5%、抑郁指数 −20%。神经机制是训练大脑主动搜索正向信号，对抗进化遗留的「负面偏差」本能。

2. **James Clear 习惯四定律**：看得见（Obvious）→ 想去做（Attractive）→ 易上手（Easy）→ 有奖励（Rewarding）。习惯不靠意志力，靠系统设计。

3. **情绪外化「烦恼处理器」**：把烦恼写下来，从大脑「工作记忆」卸载，减少认知占用，同时触发主动解决动力。

**与 Hachimi 现状的差距分析**：

| 维度 | Hachimi 现状 | 韧性手册 | 差距 |
|------|------------|---------|------|
| 日常正面情绪追踪 | 猫咪 AI 日记（猫的视角） | 用户手写「今日一光」 | **缺失用户主观书写** |
| 每周回顾/反思 | 无 | 三个幸福时刻 + 感恩 + 学到什么 | **完全缺失** |
| 情绪减负 | 无 | 烦恼处理器 | **完全缺失** |
| 习惯设计引导 | 仅填写名称/时长/目标 | 四定律设计问卷 | **缺少设计思维引导** |
| 习惯结果模式洞察 | 无 | 回顾「什么真正让我开心」 | **完全缺失** |
| 月度规划 | 无 | 月度挑战清单 + 月历 | **缺失月维度** |

Hachimi 的「有奖励」层面已经非常完善（金币、成就、猫咪成长），但完全缺失**用户主观情绪书写**和**反思闭环**两个核心维度。这是提升用户留存和心理价值的关键机会。

---

## 模块 A：「今日一光」— 每日正面时刻记录 ⭐ 优先级最高

**设计思路**：每天睡前，用一句话记录「今天的一点光」。门槛极低（强制最低：一句话），但积累后可以形成自我觉知数据。

**集成点**：
- 专注完成庆祝页（`focus_complete_screen.dart`）：可选卡片「今天有什么让你开心的事？」
- Home 今日 Tab：「今日一光」入口卡片（每天只提示一次，未填写时展示）
- 可选夜间提醒

**新增数据模型**：`DailyMoment`
```
DailyMoment {
  uid: String
  date: String (YYYY-MM-DD)
  content: String (max 200 chars)
  emoji: String? (可选正面情绪 emoji)
  createdAt: DateTime
}
```

**UI**：极简输入框 + 可选 5 个正面情绪 emoji 选择器。与猫咪 AI 日记并排展示（用户视角卡片 + 猫咪视角卡片）。

**Firestore**：`users/{uid}/dailyMoments/{date}`
**SQLite**：`local_daily_moments (date, content, emoji, synced_at)`

---

## 模块 B：「每周脉搏」— 结构化周回顾 ⭐ 优先级高

**设计思路**：每周日晚，触发一张周回顾卡片，引导用户回答 3 个问题：
1. 本周三个幸福时刻
2. 这周我想感谢谁
3. 这一周我学到了什么

**集成点**：
- 每周日在 Home 屏幕顶部展示「本周回顾」Banner（周一消失）
- 展示本周数据快照（专注时长、连击天数）

**新增数据模型**：`WeeklyReview`
```
WeeklyReview {
  uid: String
  weekId: String (YYYY-WNN，ISO 周号)
  happyMoments: List<String> (最多 3 条)
  gratitude: String?
  learned: String?
  focusMinutes: int (数据快照)
  streakDays: int (数据快照)
  createdAt: DateTime
}
```

**Firestore**：`users/{uid}/weeklyReviews/{weekId}`
**SQLite**：`local_weekly_reviews (week_id, content_json, synced_at)`

---

## 模块 C：「烦恼处理器」— 情绪减负工具 ⭐ 优先级中

**设计思路**：用户把烦恼写下来，填写解法，追踪状态。核心价值是「外化」——把焦虑从工作记忆卸载到 App。

**三种状态**：
- 🌱 自然消失
- ✅ 我搞定了
- ⏳ 还在路上

**集成点**：
- 独立入口（从 Profile / 设置菜单访问）
- 习惯创建流程末尾可选「有什么担心？」引导
- 每周回顾卡片展示本周新增 + 解决的烦恼数量

**新增数据模型**：`Worry`
```
Worry {
  uid: String
  id: String
  content: String
  solution: String?
  status: 'active' | 'dissolved' | 'solved'
  createdAt: DateTime
  resolvedAt: DateTime?
}
```

**Firestore**：`users/{uid}/worries/{worryId}`
**SQLite**：`local_worries (worry_id, content, solution, status, created_at, resolved_at, synced_at)`

---

## 模块 D：「习惯设计师」— 四定律引导 ⭐ 优先级中

**设计思路**：在习惯创建流程（`adoption_flow_screen.dart`）末尾添加可选的「习惯设计」步骤，引导用户用四定律思考自己的习惯设置。

**四个引导问题**（可跳过）：
1. **看得见**：「你会把什么放在显眼处来提醒自己？」
2. **想去做**：「什么场景会让你自然想去做这件事？」
3. **易上手**：「最小的起步版本是什么（1 分钟能完成）？」
4. **有奖励**：「完成后你会给自己什么小奖励？」

**存储**：作为 `Habit` 模型的可选字段扩展（`habitDesignNotes: Map<String, String>?`）

---

## 模块 E：「欢乐地图」— AI 模式洞察 ⭐ 优先级低（需数据积累）

**设计思路**：当用户积累了 30+ 条「今日一光」记录后，AI 分析条目中的模式，生成一句洞察：「你记录最多的是和家人的时刻，其次是学到新技能的成就感。」

**技术路径**：
- 触发条件：`DailyMoment` 记录 ≥ 30 条
- AI Provider：复用现有 `AiProvider` 接口
- 展示位置：猫咪详情页「成长洞察」卡片（与猫咪 AI 日记并列）
- 刷新频率：每 7 天最多触发一次新洞察

---

## 文件清单

### 新增文件

| 操作 | 文件 |
|------|------|
| 创建 | `lib/models/daily_moment.dart` |
| 创建 | `lib/models/weekly_review.dart` |
| 创建 | `lib/models/worry.dart` |
| 创建 | `lib/screens/reflection/daily_moment_screen.dart` |
| 创建 | `lib/screens/reflection/weekly_review_screen.dart` |
| 创建 | `lib/screens/reflection/worry_list_screen.dart` |
| 创建 | `lib/screens/reflection/worry_detail_screen.dart` |

### 修改文件

| 操作 | 文件 | 改动内容 |
|------|------|---------|
| 修改 | `lib/screens/focus_complete_screen.dart` | 添加「今日一光」可选卡片 |
| 修改 | `lib/screens/home/today_tab.dart` | 添加反思入口卡片 |
| 修改 | `lib/screens/adoption_flow_screen.dart` | 添加可选四定律步骤 |
| 修改 | `lib/screens/cat_detail/cat_detail_screen.dart` | 添加「欢乐地图」洞察卡片（模块 E） |
| 修改 | `lib/core/router/app_router.dart` | 新增 4 条路由 |
| 修改 | `lib/l10n/app_en.arb` | 新增本地化 key |
| 修改 | `lib/l10n/app_zh.arb` | 新增本地化 key |

### SSOT 文档更新（DDD 原则 — 编码前先更新）

| 优先级 | 文件 | 改动内容 |
|--------|------|---------|
| 1 | `docs/architecture/data-model.md` | 添加 3 个新 Firestore 集合 + SQLite 表 |
| 2 | `docs/product/prd.md` | 添加韧性功能模块规格 |
| 3 | `docs/architecture/state-management.md` | 声明新 Provider |
| 4 | `docs/architecture/folder-structure.md` | 添加 `screens/reflection/` 目录 |
| 5 | `docs/design/screens.md` | 添加新屏幕布局规格 |
| 6 | `docs/firebase/analytics-events.md` | 添加新分析事件 |
| — | 所有 zh-CN 镜像 | 同步中文版本 |

---

## 分阶段发布

### Phase 1 — v2.35.0：「今日一光」+「每周脉搏」
模块 A + B。新增 2 个模型、2 个屏幕。改动：完成庆祝页、Home 今日 Tab。

### Phase 2 — v2.36.0：「烦恼处理器」+「习惯设计师」
模块 C + D。新增 1 个模型、2 个屏幕。改动：习惯领养流程。

### Phase 3 — v2.37.0+：「欢乐地图」
模块 E。需 Phase 1 数据积累。需要 AI Prompt 工程。

---

## 验证方法

### 模块 A
1. 完成一次专注 → 完成页出现「今日一光」可选卡片
2. 输入内容 → 猫咪详情页并排显示猫咪 AI 日记 + 用户今日一光
3. Firestore 验证：`users/{uid}/dailyMoments/{date}` 文档已创建

### 模块 B
1. 周日打开 App → Home 顶部出现「本周回顾」Banner
2. 填写三个问题提交 → 本地 + 云端均持久化
3. 周一打开 → Banner 消失

### 模块 C
1. 进入烦恼处理器 → 创建一条烦恼
2. 标记为「我搞定了」→ 状态更新，已解决数量展示
3. 每周回顾卡片展示本周烦恼统计

### 模块 D
1. 领养新猫（创建习惯）→ 最后步骤出现可选「习惯设计」
2. 跳过 → 正常创建习惯
3. 填写 → 数据保存至 `Habit.habitDesignNotes`
