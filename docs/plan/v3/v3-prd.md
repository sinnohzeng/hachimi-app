# Hachimi V3.0 产品需求文档（PRD）

> **文档类型**：产品设计 · 顶层方案
> **会话日期**：2026-03-17
> **方法论**：梁宁《真需求》× Seligman 积极心理学 × James Clear 习惯四定律
> **现有版本**：v2.34.0（Flutter + Firebase，像素主题 + MD3 双皮肤）
> **核心限制**：保留现有 Forest 式专注计时功能

---

## 一、重新定位：从工具到觉知伴侣

### 1.1 问题诊断

**v2.x 定位**：养猫 + 专注计时的习惯打卡工具。

用梁宁的语言：这是一个「功能价值」产品——市场上 Finch、Habitica、Forest 都能做到。猫咪有情绪价值的潜力，但目前停留在「装饰」层面，没有和用户真实情感需求产生深度连接。

**根本缺口（来自播客分析）**：

| 维度 | v2.x | 缺口 |
|------|------|------|
| 功能价值 | 习惯打卡 + 专注计时 ✅ | ⬜ 习惯设计引导 |
| 情绪价值·保障感 | 几乎没有 | ⬜ 烦恼减负（焦虑外化） |
| 情绪价值·愉悦感 | 猫咪浅层陪伴 | ⬜ 每日一点光 + 模式发现 |
| 情绪价值·彰显性 | 无 | ⬜ 成长历程可视化 |
| 资产价值 | 无 | ⬜ 个人觉知档案 |

### 1.2 V3 定位

> **Hachimi 是一个帮你在每天 5 分钟里「觉知自己」的数字伴侣。**
>
> 猫咪不再只是习惯追踪的奖励机制，而是你内心宇宙里陪你一起成长的生命。
> 你照顾猫咪，猫咪照顾你。
> 每天记录一点光，日积月累，点亮内心宇宙。

### 1.3 产品飞轮（三层融合）

```
                    ┌─────────────────┐
                    │   专注计时       │  ← Forest 式计时，习惯成长燃料
                    │  （行为催化剂）   │
                    └────────┬────────┘
                             │ 完成触发
                    ┌────────▼────────┐
                    │   觉知记录       │  ← 每日一点光 + 周回顾 + 烦恼处理
                    │  （意义赋予层）   │
                    └────────┬────────┘
                             │ 反应驱动
                    ┌────────▼────────┐
                    │   猫咪伴侣       │  ← 成长 + 心情感应 + AI日记
                    │  （情感连接载体） │
                    └─────────────────┘
```

三者形成完整的**成长飞轮**：
- 专注计时 → 猫咪成长 + 触发反思入口
- 觉知记录 → 猫咪情感反应 + 数据积累
- 猫咪伴侣 → 驱动用户回来专注 + 回来记录

---

## 二、用户人设（梁宁第七章）

### 核心人设：「努力但容易自我怀疑的成年人」

| 维度 | 描述 |
|------|------|
| **年龄** | 25–45 岁 |
| **自我期待** | 想变得更好：更自律、更了解自己、内心丰盈 |
| **核心痛点** | 买过很多手账，写了几页就放一边。坚持不下去不是因为不想，而是门槛太高、反馈太慢 |
| **隐性需求** | 不知道「什么真正让自己开心」；烦恼压在心里，半夜翻来覆去 |
| **行为特征** | 手机重度用户；睡前刷手机；时间碎片化 |
| **情感特征** | 喜欢可爱的东西（猫、卡通），但不想被当小孩子看待 |

**人设公式**：
```
用户 = 自我期待（想成为有觉知、自律的人）
      + 外部压力（工作忙、时间碎片化）
      + 内在恐惧（害怕一直浑浑噩噩下去）
```

**产品切入点**：在「自我期待」和「外部压力」之间找到最小可行支点——**每天 5 分钟，足够简单到不会被外部压力挤掉，又足够有效到能触及自我期待。**

### 非目标用户
- 需要严格 GTD/OKR 时间管理系统的项目经理型用户
- 需要社交打卡、互相监督的外向型用户
- 只想玩养成游戏、不关心自我成长的用户

---

## 三、场景设计：三幕结构（来自播客）

完全对标韧性手册的三个时间节点：

### 第一幕：睡前一点光（每日，~2 分钟）

**触发**：用户设定的睡前提醒；或用户完成专注后自动弹出

| 模块 | 说明 | 最简路径 |
|------|------|---------|
| 心情选择 | 5 个 emoji（很开心→很低落） | 1 次点击 |
| 今日一点光 | 今天有什么让你微笑的事？ | 一句话（≤ 500 字，可为空） |
| 标签（可选） | #家人 #学习 #户外 等预设标签 | AI 模式发现的数据基础 |
| 时间轴（可选） | 回顾今天 3-5 件事 | 可跳过 |
| 习惯打卡 | 今天还没完成的习惯 | 快速勾选 |

**最少路径**：选 emoji + 写一句话 = **30 秒完成**

**猫咪心情感应**（基于用户选择的情绪）：
| 用户心情 | 猫咪反应 | 文案 |
|---------|---------|------|
| 😄 很开心 | 猫咪蹦蹦跳跳 | 「铲屎官今天好开心，本猫也开心！🎉」 |
| 🙂 开心 | 猫咪蹭蹭你 | 「记录了今天的第 N 束光 ✨」 |
| 😌 平静 | 猫咪安静趴旁边 | 「平静的一天也很好呢 🍃」 |
| 😔 低落 | 猫咪轻轻靠过来 | 「不开心的日子，本猫陪着你 💛」 |
| 😢 很低落 | 猫咪蜷在你身边不走 | 「没事的，本猫哪都不去 🫂」 |

### 第二幕：周日复盘（每周日，~5 分钟）

**触发**：周日 20:00 推送；或用户主动进入周回顾

| 模块 | 说明 |
|------|------|
| 三个幸福时刻 | 本周三个值得记录的瞬间（可附标签） |
| 感恩 | 这周我想感谢谁 |
| 学到了什么 | 这周学到的一件事 |
| 烦恼处理器更新 | 对进行中的烦恼标记状态（消失/搞定/还在） |
| 新增烦恼（可选） | 烦恼 + 解法 |

**完成后**：猫咪 AI 周总结（1-2 句，引用铲屎官本周的真实记录）

### 第三幕：月初仪式（每月 1 日，~5 分钟）

MVP 极简版：在觉知首页检测到新月份时，显示「设置本月小赢挑战」提示卡片。

| 模块 | 说明 |
|------|------|
| 本月小赢挑战 | 选择一个习惯作为本月重点 |
| 30 天打卡格 | 每天完成后打勾 |
| 月度奖励 | 完成 30 天我就奖励自己 ___ |

---

## 四、KANO 属性分析与 MVP 边界

### 必备属性（MVP 必须保留）
- ✅ 离线可用（现有 SQLite SSOT 架构）
- ✅ 习惯打卡 + 专注计时（**Forest 式计时保留，不削减**）
- ✅ 猫咪基础互动（现有功能）
- ✅ 数据安全（现有备份机制）

### 期望属性（MVP 核心交付，有就满意）
- ✅ 睡前「一点光」（心情 emoji + 一句话 + 习惯打卡）
- ✅ 周回顾（三个幸福时刻 + 感恩 + 学习 + 烦恼更新）
- ✅ 烦恼处理器（列表 CRUD + 三种状态标记）
- ✅ 猫咪心情感应动画（5 种心情 × 对应反应）
- ✅ 月初小赢挑战（极简版）
- ✅ 专注完成 → 一点光快速触发（飞轮桥接）

### 魅力属性（v3.1+，有就惊喜）
- ⭐ AI 模式发现（30+ 天数据 → 「你幸福时刻 65% 和 #户外 有关」）
- ⭐ 觉知统计页（心情热力图、标签云、烦恼解决率）
- ⭐ 月度计划完整版（四法则引导 + 四象限周计划）
- ⭐ 年度成长报告
- ⭐ 主屏 Widget

### 反向属性（绝对不做）
- ❌ 催促式通知（「你今天还没打卡！」）
- ❌ 断连惩罚（连续天数中断显示红色警告）
- ❌ 社交分享/排行榜（觉知是私密的）
- ❌ 强制每日打开

---

## 五、V3 全局导航结构（重组 4 Tab）

用户选择：觉知升为主角，统计并入「我的」Tab。

```
底部 Tab（左→右）：
┌──────────────────────────────────────────┐
│  ✨觉知  │  📋习惯  │  🐱猫咪  │  👤我的  │
└──────────────────────────────────────────┘
```

### Tab 1：✨ 觉知（默认打开页）
首次打开 App 看到的第一个 Tab。三个子 Tab：

| 子 Tab | 内容 | 触发场景 |
|--------|------|---------|
| 今日 | 一点光记录状态 + 心情 + 月度挑战打卡 | 每日核心循环 |
| 本周 | 周回顾 + 烦恼处理器入口 | 每周日 |
| 历史 | 月历心情 emoji 图 + 周记录折叠列表 | 回顾过去 |

### Tab 2：📋 习惯（Forest 计时在此）
- 今日习惯列表 + 快速打卡
- 点击习惯 → 进入专注计时页（Forest 式，保留原有全部功能）
- 完成专注 → 完成庆祝页 + **自动弹出「一点光」快速录入**（飞轮桥接）
- 领养猫 / 新建习惯 / 习惯详情

### Tab 3：🐱 猫咪
- 猫舍（所有猫咪）
- 猫咪详情：大图 + 成长进度 + AI 日记 + 聊天 + 热力图 + 配饰
- 配饰商城

### Tab 4：👤 我的
- 用户信息 + 成就
- **统计区（吸收原 Stats Tab）**：习惯热力图、专注历史、觉知统计
- 设置：提醒时间 / 主题 / 数据管理
- 签到日历（原 check-in 功能保留）

---

## 六、核心 UX 流程

### 6.1 Onboarding（更新文案）

```
首次打开
    ↓
3 页引导（更新文案）：
  页 1: 「认识哈奇米 — 你的内心宇宙伴侣」
  页 2: 「每天 5 分钟，记录你的一点光」
  页 3: 「猫咪陪你觉知自己，慢慢变好」
    ↓
领养第一只猫（现有 3 步流程，不变）
    ↓
进入主页（✨觉知 Tab）→ 引导气泡：「记录今天的第一点光 ✨」
    ↓
完成第一次一点光 → 猫咪互动动画 → 「第一束光」成就
```

**Aha 时刻**：首次完成一点光并看到猫咪温暖反应，在首次使用 60 秒内可达。

### 6.2 专注 → 觉知 飞轮桥接

```
习惯 Tab → 点击习惯 → 专注计时（Forest 式）
    ↓
计时完成 → 完成庆祝页（XP、金币、猫咪成长 —— 现有）
    ↓
顶部出现轻量 Banner：「今天有什么让你微笑的事？✨」[记录] [跳过]
    ↓
[记录] → 打开一点光快速录入（底部抽屉，不打断流程）
[跳过] → 正常返回
    ↓
完成录入 → 猫咪给出额外一个小反应（区别于普通专注完成）
```

### 6.3 周日复盘流程

```
周日 20:00 通知：「这周辛苦啦，来回顾一下吧 🐱」
    ↓
进入觉知 Tab → 本周子 Tab → 周回顾页面
    ↓
Step 1：三个幸福时刻（3 个编号卡片，可只填 1-2 个）
Step 2：感恩（单行）
Step 3：学到了什么（单行）
Step 4：更新烦恼状态（消失/搞定/还在）
[可选] Step 5：新增本周烦恼
    ↓
完成 → 猫咪 AI 周总结（引用铲屎官真实的幸福时刻内容）
```

---

## 七、数据模型（新增表）

### SQLite 新增表

```sql
-- 每日一点光
CREATE TABLE daily_lights (
    id TEXT PRIMARY KEY,
    date TEXT NOT NULL UNIQUE,              -- 'YYYY-MM-DD'
    mood INTEGER NOT NULL,                  -- 0=veryHappy...4=veryDown
    lightText TEXT,                         -- 可为空
    tags TEXT,                              -- JSON 数组 '["家人","学习"]'
    timelineEvents TEXT,                    -- JSON 数组（可选）
    habitCompletions TEXT,                  -- JSON 对象（可选）
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
);

-- 周回顾
CREATE TABLE weekly_reviews (
    id TEXT PRIMARY KEY,
    weekId TEXT NOT NULL UNIQUE,            -- 'YYYY-WNN'
    weekStartDate TEXT NOT NULL,
    weekEndDate TEXT NOT NULL,
    happyMoment1 TEXT,
    happyMoment1Tags TEXT,                  -- JSON 数组
    happyMoment2 TEXT,
    happyMoment2Tags TEXT,
    happyMoment3 TEXT,
    happyMoment3Tags TEXT,
    gratitude TEXT,
    learning TEXT,
    catWeeklySummary TEXT,                  -- AI 生成
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
);

-- 烦恼处理器
CREATE TABLE worries (
    id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    solution TEXT,
    status TEXT NOT NULL DEFAULT 'ongoing', -- 'ongoing'|'resolved'|'disappeared'
    resolvedAt TEXT,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
);

-- 觉知统计（单行）
CREATE TABLE awareness_streaks (
    id TEXT PRIMARY KEY DEFAULT 'singleton',
    currentLightStreak INTEGER NOT NULL DEFAULT 0,
    longestLightStreak INTEGER NOT NULL DEFAULT 0,
    totalLightDays INTEGER NOT NULL DEFAULT 0,
    totalWeeklyReviews INTEGER NOT NULL DEFAULT 0,
    totalWorriesResolved INTEGER NOT NULL DEFAULT 0,
    lastLightDate TEXT,
    updatedAt TEXT NOT NULL
);
```

### Firestore 新增集合

```
users/{uid}/
├── dailyLights/{YYYY-MM-DD}
├── weeklyReviews/{YYYY-WNN}
└── worries/{worryId}
```

---

## 八、技术架构（兼容现有代码库）

### 8.1 架构原则

**遵循现有项目分层架构**（CLAUDE.md 规范）：

```
lib/screens/awareness/        ← 新增觉知相关屏幕（非 features/ 目录）
lib/models/                   ← 新增 daily_light.dart, weekly_review.dart, worry.dart
lib/services/                 ← 新增 awareness_service.dart, worry_service.dart
lib/providers/                ← 新增 awareness_providers.dart
lib/widgets/awareness/        ← 新增觉知专用 Widget
```

**不采用** `lib/features/awareness/` 的 feature-first 结构，保持与现有代码库一致性。

### 8.2 新增屏幕清单

| 屏幕文件 | 功能 |
|---------|------|
| `lib/screens/awareness/awareness_screen.dart` | 觉知 Tab 主页面（含今日/本周/历史子 Tab） |
| `lib/screens/awareness/daily_light_screen.dart` | 一点光记录页 |
| `lib/screens/awareness/weekly_review_screen.dart` | 周回顾页 |
| `lib/screens/awareness/worry_processor_screen.dart` | 烦恼处理器主页 |
| `lib/screens/awareness/worry_edit_screen.dart` | 烦恼编辑页 |
| `lib/screens/awareness/awareness_history_screen.dart` | 觉知历史（月历 + 周记录） |
| `lib/screens/awareness/daily_detail_screen.dart` | 某天详情页 |

### 8.3 新增 Widget 清单

| Widget 文件 | 功能 |
|------------|------|
| `lib/widgets/awareness/mood_selector.dart` | 5 个心情 emoji 选择器 |
| `lib/widgets/awareness/light_input_card.dart` | 一点光输入卡片 |
| `lib/widgets/awareness/timeline_editor.dart` | 今日时间轴编辑器 |
| `lib/widgets/awareness/happy_moment_card.dart` | 幸福时刻卡片 |
| `lib/widgets/awareness/worry_item_card.dart` | 烦恼条目卡片 |
| `lib/widgets/awareness/cat_bedtime_animation.dart` | 猫咪睡前互动动画（心情感应） |
| `lib/widgets/awareness/tag_selector.dart` | 标签选择器 |
| `lib/widgets/awareness/mood_calendar.dart` | 月历心情热力图 |
| `lib/widgets/awareness/awareness_empty_state.dart` | 空状态组件 |

### 8.4 导航改动

```dart
// lib/screens/home_screen.dart 改动：
// 4 Tab 重组：
// - Tab 0: ✨ 觉知 (AwarenessScreen) — 新增，作为首页
// - Tab 1: 📋 习惯 (TodayTab → 重命名为 HabitsTab) — 原 Tab 0 内容
// - Tab 2: 🐱 猫咪 (CatHouseScreen) — 原 Tab 1
// - Tab 3: 👤 我的 (ProfileScreen) — 合并原 Stats + Profile

// 移除 Tab: StatsScreen (统计内容移入我的 Tab 下的统计子页面)
```

### 8.5 专注完成 → 觉知 桥接改动

```dart
// lib/screens/focus_complete_screen.dart 改动：
// 在完成庆祝页底部添加轻量 Banner：
//   条件：当日未记录一点光
//   UI：一行提示 + [记录] 按钮 + [跳过] 按钮
//   点击 [记录] → showModalBottomSheet(DailyLightScreen 的快速录入模式)
```

### 8.6 AI 周总结 Prompt 设计

```
System: 你是一只名叫 {catName} 的猫咪，性格是 {personality}。
        铲屎官刚完成本周回顾。请用猫咪语气写 1-2 句周总结。
        要求：第一人称、提及具体幸福时刻、温暖鼓励、≤50字、可用1个emoji。

User:   幸福时刻：
        1. {happyMoment1}
        2. {happyMoment2}
        3. {happyMoment3}
        感恩：{gratitude}
        学习：{learning}
```

---

## 九、新增成就

在现有 163 个成就基础上新增 8 个觉知成就：

| ID | 名称 | 条件 | 奖励 |
|----|------|------|------|
| `light_first` | 第一束光 | 首次记录一点光 | 50 金币 |
| `light_7` | 连续七日光 | 连续 7 天记录 | 100 金币 |
| `light_30` | 月光满盈 | 连续 30 天记录 | 300 金币 |
| `light_100` | 百日之光 | 连续 100 天记录 | 500 金币 |
| `review_first` | 第一次回顾 | 首次完成周回顾 | 50 金币 |
| `review_4` | 月度回顾者 | 完成 4 次周回顾 | 200 金币 |
| `worry_resolved_1` | 解忧第一步 | 解决第 1 个烦恼 | 50 金币 |
| `worry_resolved_10` | 解忧达人 | 解决 10 个烦恼 | 200 金币 |

---

## 十、「不完美也没关系」设计原则

来自播客：「打了一半的卡，有半个月不熬夜也是进步。」

| 场景 | 现有/常规做法 | V3 做法 |
|------|------------|---------|
| 连续天数中断 | 红色警告 / 归零 | 「中断了也没关系，今天又是新的开始 🌱」 |
| 周回顾不完整 | 不允许保存 | 幸福时刻可只填 1-2 个，随时保存 |
| 月度打卡未满 | 显示「未完成」 | 「这个月打了 X/30 天，每一天都算数 ✨」 |
| 烦恼未解决 | ❌ 负面标记 | 🟡「还在的小烦恼——慢慢来」 |

---

## 十一、通知策略

| 类型 | 触发 | 时间 | 文案 |
|------|------|------|------|
| 睡前一点光 | 用户设定时间 | 每晚 | 「猫咪在等你说晚安 🐱」 |
| 周日复盘 | 每周日 | 20:00 | 「这周辛苦啦，来回顾一下吧 ✨」 |
| 月初仪式 | 每月 1 日 | 10:00 | 「新的一月，设个小目标？🌱」 |
| 温柔提醒 | 连续 3 天未记录 | 第 3 天 20:00 | 「猫咪有点想你了…… 🥺」（最多每周 1 次） |

**绝对不做的通知**：
- ❌ 「你今天还没打卡！」（催促式）
- ❌ 「你的连续天数即将中断！」（恐吓式）

---

## 十二、空状态设计

| 页面 | 文案 | 插图方案 |
|------|------|---------|
| 今日一点光（未记录） | 「今天还没有记录光哦，什么时候都可以来 ✨」 | 猫咪趴窗台看月亮 |
| 周回顾（未回顾） | 「慢慢来，等你准备好了再回顾 🐱」 | 猫咪翻开小本子 |
| 觉知历史（无记录） | 「每一天的光都值得被记住」 | 猫咪仰望星空 |
| 烦恼处理器（无烦恼） | 「没有烦恼？太好了！🎉」 | 猫咪开心打滚 |

所有空状态插图使用现有 `PixelCatSprite` 渲染，无需新增资源。

---

## 十三、分阶段实施计划

### Phase 1（v2.35.0）：数据基础 + 核心 UI（预计 1-2 周）

**数据层**：
- [ ] SQLite 新增 4 张表 + migration
- [ ] Dart 模型类：`DailyLight`, `WeeklyReview`, `Worry`, `Mood`, `TimelineEvent`
- [ ] `AwarenessService` + `WorryService`
- [ ] Riverpod providers
- [ ] Firestore 集合支持 + SyncEngine 更新

**UI 层**：
- [ ] `AwarenessScreen`（3 子 Tab：今日/本周/历史）
- [ ] `MoodSelector` widget
- [ ] `DailyLightScreen`（心情 + 一点光 + 时间轴 + 习惯打卡）
- [ ] `WeeklyReviewScreen`（三个幸福时刻 + 感恩 + 学习 + 烦恼更新）
- [ ] `WorryProcessorScreen` + `WorryEditScreen`
- [ ] `CatBedtimeAnimation`（心情感应，5 种）
- [ ] 空状态组件

**集成**：
- [ ] 底部导航重组（4 Tab：觉知/习惯/猫咪/我的）
- [ ] 专注完成页新增一点光快速录入 Banner
- [ ] Onboarding 文案更新
- [ ] 新增 8 个觉知成就

### Phase 2（v2.36.0）：历史视图 + 月度挑战（预计 1 周）

- [ ] `AwarenessHistoryScreen`（月历 + 周回顾折叠列表）
- [ ] `DailyDetailScreen`（某天详情）
- [ ] 月初小赢挑战（极简版）
- [ ] 觉知统计子页面（并入我的 Tab）

### Phase 3（v2.37.0+）：AI 模式发现

- [ ] 标签分析系统（30+ 天数据触发）
- [ ] AI 欢乐地图（幸福时刻模式洞察）

---

## 十四、SSOT 文档更新清单（DDD 原则，编码前更新）

| 优先级 | 文件 | 改动 |
|--------|------|------|
| 1 | `docs/architecture/data-model.md` | 新增 4 张 SQLite 表 + 3 个 Firestore 集合 |
| 2 | `docs/product/prd.md` | 更新为 V3 定位 + 新增觉知模块规格 |
| 3 | `docs/architecture/state-management.md` | 新增 awareness/worry providers |
| 4 | `docs/architecture/folder-structure.md` | 新增 `screens/awareness/`, `widgets/awareness/` |
| 5 | `docs/design/screens.md` | 新增觉知相关屏幕布局规格 |
| 6 | `docs/firebase/analytics-events.md` | 新增事件：`light_recorded`, `weekly_review_completed`, `worry_created`, `worry_resolved` |
| — | 所有对应 zh-CN 镜像 | 同步更新 |

---

## 附录 A：关键设计原则速查

| 原则 | 来源 | 在产品中的体现 |
|------|------|-------------|
| 每天只要 5 分钟 | 播客 | 核心交互 ≤ 60 秒可完成 |
| 门槛低到不需要「坚持」 | 播客 | 最少操作 = 1 次心情选择 + 1 句话 |
| 功能价值是工具，情绪价值是玩具 | 梁宁 | 猫咪从装饰升级为情感连接载体 |
| 关怀而非操纵 | 梁宁 | AI 不催促，猫咪不惩罚 |
| 没有强场景就是爬虫子 | 梁宁 | 三幕结构嵌入月初/周日/睡前 |
| 不完美也没关系 | 播客 | 中断不惩罚，少打卡也认可进步 |
| 需要→喜欢→认同→归属 | 梁宁 | 功能→情感→价值观→资产沉淀 |

## 附录 B：对参考 PRD 的批判性采纳说明

参考 PRD（其他大模型生成）质量较高，本方案批判性采纳如下：

**采纳**：
- 梁宁《真需求》框架（功能/情绪/资产价值公式）
- 三幕结构设计（精准对标播客三场景）
- KANO 属性分析（优先级判断准确）
- 用户人设（「努力但容易自我怀疑」）
- 两轮 PDCA 迭代内容（8 项改进全部采纳）
- 心情感应猫咪互动设计
- 「不完美也没关系」原则
- 数据模型（SQL + Firestore）
- Widget 级别规格（Mood、Timeline 等）
- 通知策略（4 种 + 反向列表）
- 空状态设计

**修改**：
- 架构：改用现有分层结构（`screens/awareness/`）而非 `features/`（CLAUDE.md 规范）
- 导航：4 Tab 重组（觉知为主角）而非 5 Tab（用户决策）
- Forest 计时：明确保留，并作为觉知飞轮的触发入口强化集成

**不采纳**：
- Feature-first 目录（与现有项目结构冲突）
- MVP 阶段数据导出功能（复杂度/价值比不合适）
- 5 Tab 导航方案（已采用 4 Tab 重组）

---

## 十五、Git 分支策略

### 15.1 为什么单独开分支？

V3.0 涉及三类高风险改动：
- **导航重组**：修改 `home_screen.dart`（4 Tab 新结构，blast radius 极高）
- **新目录结构**：`lib/screens/awareness/`（7 个新文件）+ `lib/widgets/awareness/`（9 个新文件）
- **飞轮桥接**：修改 `focus_complete_screen.dart`（核心用户路径）

如果在 `main` 上直接开发，每次推送都会让 CI 构建出「功能不完整」的 App，破坏日常可发布性。**行业最佳实践**：长生命周期 Feature Branch + 阶段性 PR 合并回 main。

### 15.2 分支结构

```
main
  └── feat/v3-awareness          ← V3 主开发分支（贯穿 v2.35 – v2.37）
       ├── feat/v3-data-layer    ← 数据层子分支（可选，完成后合回 feat/v3）
       ├── feat/v3-core-ui       ← 核心 UI 子分支（可选）
       └── feat/v3-nav-bridge    ← 导航重组 + 飞轮桥接（高风险，最后合并）
```

**操作命令**：
```bash
git checkout main && git pull
git checkout -b feat/v3-awareness
git push -u origin feat/v3-awareness
```

### 15.3 合并节奏

| 时机 | 操作 | 合并条件 |
|------|------|---------|
| 各子分支完成 | 合回 `feat/v3-awareness` | `dart analyze` 通过 + 单元测试通过 |
| v2.35.0 就绪 | PR: `feat/v3-awareness → main` | 觉知飞轮核心闭环可完整演示 |
| v2.36.0 就绪 | PR: `feat/v3-awareness → main` | 历史视图 + 月度挑战完整 |
| v2.37.0 就绪 | PR: `feat/v3-awareness → main` | AI 功能稳定，数据积累足够 |

---

## 十六、综合开发路线图

> 覆盖 v2.35.0 → v2.37.0 全路径，按「开发轨道」而非简单时间顺序组织。每个轨道必须满足完成标志才能开始下一个轨道。

### 轨道一：数据基础（最高优先级，所有轨道的前置条件）

**目标**：所有新数据结构就位，零 UI 变化，风险最低。

| 任务 | 文件 | 前置条件 |
|------|------|---------|
| 更新 SSOT 文档 `data-model.md` | `docs/architecture/data-model.md` + zh-CN 镜像 | — |
| Dart 模型 `DailyLight` + `Mood` 枚举 | `lib/models/daily_light.dart` | 文档更新后 |
| Dart 模型 `WeeklyReview` | `lib/models/weekly_review.dart` | 文档更新后 |
| Dart 模型 `Worry` | `lib/models/worry.dart` | 文档更新后 |
| SQLite migration（4 张新表） | `lib/services/database_service.dart` | 模型完成 |
| `AwarenessService`（CRUD + 统计） | `lib/services/awareness_service.dart` | migration 完成 |
| `WorryService`（CRUD + 状态更新） | `lib/services/worry_service.dart` | migration 完成 |
| Riverpod providers | `lib/providers/awareness_providers.dart` | 服务完成 |
| Firestore 集合支持 + SyncEngine 更新 | 相关 firebase 服务文件 | providers 完成 |
| 更新 SSOT 文档 `state-management.md` | `docs/architecture/state-management.md` + zh-CN | providers 完成 |

**完成标志**：`flutter test test/models/ test/services/ test/providers/` 全部通过

---

### 轨道二：觉知核心 UI（依赖轨道一）

**目标**：觉知 Tab 主框架 + 一点光录入 + 周回顾页面可完整使用。

| 任务 | 文件 | 备注 |
|------|------|------|
| 更新 SSOT 文档（screens.md + folder-structure.md） | docs 对应文件 + zh-CN | 编码前 |
| `MoodSelector` widget | `lib/widgets/awareness/mood_selector.dart` | 5 种心情 emoji，单击选中 |
| `LightInputCard` widget | `lib/widgets/awareness/light_input_card.dart` | ≤ 500 字输入 + 实时字数 |
| `TagSelector` widget | `lib/widgets/awareness/tag_selector.dart` | 预设标签 + 自定义 |
| `HappyMomentCard` widget | `lib/widgets/awareness/happy_moment_card.dart` | 周回顾幸福时刻录入 |
| `WorryItemCard` widget | `lib/widgets/awareness/worry_item_card.dart` | 三状态切换交互 |
| `AwarenessEmptyState` widget | `lib/widgets/awareness/awareness_empty_state.dart` | 复用 PixelCatSprite |
| `DailyLightScreen` | `lib/screens/awareness/daily_light_screen.dart` | 心情 + 一点光 + 时间轴 + 习惯快速打卡 |
| `WeeklyReviewScreen` | `lib/screens/awareness/weekly_review_screen.dart` | 3 幸福时刻 + 感恩 + 学习 + 烦恼更新 |
| `WorryProcessorScreen` | `lib/screens/awareness/worry_processor_screen.dart` | 烦恼列表 CRUD |
| `WorryEditScreen` | `lib/screens/awareness/worry_edit_screen.dart` | 新建 / 编辑烦恼 |
| `AwarenessScreen`（3 子 Tab 骨架） | `lib/screens/awareness/awareness_screen.dart` | 今日 / 本周 / 历史框架 |
| 路由注册 | `lib/core/router/app_router.dart` | 新增 7 个路由 |

**完成标志**：新增 Widget golden tests 通过；DailyLight 完整录入流程可手动演示（今日 Tab 访问）

---

### 轨道三：飞轮桥接 + 导航重组（依赖轨道二，高风险，最后做）

> **blast radius 最高**，对 `home_screen.dart` 和 `focus_complete_screen.dart` 同时动刀。确保前两个轨道完全稳定后再启动。

| 任务 | 文件 | 备注 |
|------|------|------|
| `focus_complete_screen.dart` 修改 | 现有文件 | 添加 Banner + Bottom Sheet 快速录入（条件：当日未记录光） |
| `CatBedtimeAnimation` widget | `lib/widgets/awareness/cat_bedtime_animation.dart` | 5 种心情感应动画，复用现有猫咪 sprite |
| `home_screen.dart` Tab 重组 | 现有文件 | 4 Tab 重排（觉知首位），移除 StatsTab |
| Onboarding 文案更新 | `lib/screens/onboarding/` 相关文件 | 3 页引导更新（觉知伴侣定位） |
| 新增 8 个觉知成就 | `lib/core/constants/` 成就常量文件 | 触发条件见第九节 |
| 通知新增（3 种） | 通知调度服务 | 睡前一点光 / 周日复盘 / 月初仪式 |
| L10n 新增 Key（全部新文案） | `lib/l10n/app_en.arb` + 5 个语言 ARB | 含猫咪反应文案、空状态文案 |
| Analytics 新增事件 | `lib/core/constants/analytics_events.dart` | `light_recorded` / `weekly_review_completed` / `worry_created` / `worry_resolved` |

**完成标志**：完整「专注 → 完成 → 一点光 Banner → 快速录入 → 猫咪反应」飞轮可端到端演示 → **触发 v2.35.0 PR**

---

### 轨道四：历史视图 + 月度挑战（v2.36.0 范围）

| 任务 | 文件 | 备注 |
|------|------|------|
| `MoodCalendar` widget | `lib/widgets/awareness/mood_calendar.dart` | 月历心情热力图 |
| `TimelineEditor` widget | `lib/widgets/awareness/timeline_editor.dart` | 今日时间轴编辑器（可选步骤） |
| `AwarenessHistoryScreen` | `lib/screens/awareness/awareness_history_screen.dart` | 月历 + 周回顾折叠列表 |
| `DailyDetailScreen` | `lib/screens/awareness/daily_detail_screen.dart` | 某天详情查看（只读） |
| 月初小赢挑战（极简版） | 融入 `AwarenessScreen` 今日 Tab | 选定一个习惯 + 30 天打卡格 |
| 觉知统计子页面 | 并入 `lib/screens/profile/` | 心情分布、连续天数、解忧率 |

**完成标志**：历史视图月历可翻月查看，周回顾列表可折叠 → **触发 v2.36.0 PR**

---

### 轨道五：AI 模式发现（v2.37.0+，需真实数据积累）

> 需要用户已积累 30+ 条 DailyLight 记录后才有意义。可在 v2.36.0 上线后约 1 个月再启动。

| 任务 | 文件 | 备注 |
|------|------|------|
| 标签频率分析 | `lib/services/awareness_service.dart` 扩展 | 触发条件：记录数 ≥ 30 |
| 猫咪 AI 周总结（已在周回顾中） | 复用 AiProvider 接口 | Prompt 见第八节 8.6 |
| AI 欢乐地图 Prompt | `lib/core/constants/ai_constants.dart` | 分析标签 + 生成一句洞察 |
| 猫咪详情页「成长洞察」卡 | `lib/screens/cat_detail/cat_detail_screen.dart` | 每 7 天刷新一次 |

---

## 十七、文档持久化计划

> 本 PRD 是会话计划文件，需要在开始编码前持久化到项目 `docs/` 目录。

### 17.1 第一步：保存 V3 PRD 到项目文档

| 操作 | 目标文件 |
|------|---------|
| 将本 PRD 另存为独立文件 | `docs/product/prd-v3.md` |
| 同步中文版 | `docs/zh-CN/product/prd-v3.md` |

### 17.2 第二步：编码启动前按优先级更新 SSOT 文档

| 优先级 | 文件 | 改动内容 |
|--------|------|---------|
| 1 | `docs/architecture/data-model.md` | 新增 4 张 SQLite 表完整 schema + 3 个 Firestore 集合 |
| 2 | `docs/product/prd.md` | 追加 V3 定位 + 觉知模块规格 |
| 3 | `docs/architecture/state-management.md` | 声明 `awareness_providers.dart` 中所有 provider |
| 4 | `docs/architecture/folder-structure.md` | 新增 `screens/awareness/` + `widgets/awareness/` 树形图 |
| 5 | `docs/design/screens.md` | 新增 7 个屏幕布局规格 |
| 6 | `docs/firebase/analytics-events.md` | 新增 4 个分析事件 |
| — | 所有 zh-CN 镜像 | 同步更新 |

---

## 十八、质量门禁与 PR 策略

### 18.1 每次合并到 main 前必须全部通过

```bash
dart analyze lib/              # 零 warning / error
flutter test                   # 全绿（含 golden tests）
dart format lib/ test/ --set-exit-if-changed  # 零格式问题
```

手动验证：完整觉知飞轮端到端（专注 → Banner → 一点光 → 猫咪反应 → Firestore 写入确认）

### 18.2 PR 结构

| PR | 源分支 → 目标 | 包含内容 | 版本标签 |
|----|-------------|---------|---------|
| PR #A | feat/v3-data-layer → feat/v3-awareness | 轨道一：数据基础 | — |
| PR #B | feat/v3-core-ui → feat/v3-awareness | 轨道二：觉知核心 UI | — |
| PR #C | feat/v3-nav-bridge → feat/v3-awareness | 轨道三：飞轮桥接 + 导航重组 | — |
| **PR #D** | **feat/v3-awareness → main** | **v2.35.0 发布（轨道一 + 二 + 三）** | **v2.35.0** |
| PR #E | feat/v3-awareness | 轨道四：历史视图 + 月度挑战 | — |
| **PR #F** | **feat/v3-awareness → main** | **v2.36.0 发布（轨道四）** | **v2.36.0** |
| **PR #G** | **feat/v3-awareness → main** | **v2.37.0 发布（轨道五 AI 功能）** | **v2.37.0** |
