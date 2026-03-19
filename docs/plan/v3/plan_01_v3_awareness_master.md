---
level: 1
file_id: plan_01
status: pending
created: 2026-03-19 22:00
children: [plan_02, plan_03, plan_04, plan_05, plan_06]
---

# 总体计划：LUMI 点亮内心宇宙

## 项目概述

### 项目背景

将 Hachimi APP 从"猫咪养成习惯应用"全面转型为 **LUMI（Light Up My Innerverse）韧性成长手册**——一本会陪你成长的电子手册。

灵感来源：张晓萌教授（长江商学院副院长）的实体书《点亮内心宇宙：韧性成长手册》。

理论框架：梁宁《真需求》（价值/共识/模式）× 张晓萌韧性心理学 × James Clear 习惯四定律。

### 核心设计原则

| 原则 | 表述 | 来源 |
|------|------|------|
| 低门槛 | 每天只需 5 分钟，在厌倦之前就收笔 | 张晓萌 |
| 弱者道之用 | 简单是所有工具之争的制高点 | 梁宁 |
| 不做匪兵甲 | 方法论内核（四法则/三件好事/烦恼外化）是护城河 | 梁宁 |
| 觉知为核心 | 品类第一性是"觉知"，不是"记录" | 第一性原理 |
| 不完美也没关系 | 中断不惩罚，少打卡也认可进步 | 张晓萌 |

### 前提条件

- 无真实用户，所有用户视为新用户
- 无数据库迁移，全新 Schema
- 猫咪系统降级为可选伴侣，不阻碍核心体验
- 习惯/计时退到月度规划子模块

---

## 全局架构变更

### 导航：4 Tab → 3 Tab

```
旧：觉知 | 习惯 | 猫咪 | 我的
新：✦ 今天 | 🗺 旅程 | 👤 我的
```

### 产品飞轮（LUMI 版）

```
                    ┌─────────────────┐
                    │   每日一点光     │  ← 30 秒，一句话 + 心情
                    │  （入口极简化）   │
                    └────────┬────────┘
                             │ 数据积累
                    ┌────────▼────────┐
                    │   时间维度旅程   │  ← 周/月/年规划与回顾
                    │  （渐进式展开）   │
                    └────────┬────────┘
                             │ 模式发现
                    ┌────────▼────────┐
                    │   觉知与成长     │  ← 星星累积 + 成长回望
                    │  （意义可视化）   │
                    └─────────────────┘
```

---

## 四阶段开发路线

### Phase 1: LUMI Core（MVP）

**目标**：新 Onboarding + 3-Tab 导航 + 每日一光 + 周计划/回顾 + 烦恼处理器

**关键交付物**：
1. `LumiOnboardingScreen`（4 页温暖提问）
2. `HomeScreen` 改为 3 Tab
3. `TodayScreen`（QuickLightCard + HabitSnapshot + InspirationCard）
4. `JourneyScreen` 周视图（WeeklyPlan + WeeklyReview + WorryJar）
5. `WeeklyPlan` 模型 + repository + provider
6. `ProfileScreen` 重组（LUMI 统计 + 猫咪入口降为二级）
7. `FeatureGateProvider` 渐进解锁
8. `_FirstHabitGate` 移除强制猫咪领养
9. Google Play 标题 + l10n
10. 全新 SQLite Schema（无迁移）

**完成标志**：用户可完成每日记录、周计划/回顾、烦恼处理的完整核心体验。

**详细任务**：见 [plan_02](plan_02_v3_track1_data_layer.md)（数据层）+ [plan_03](plan_03_v3_track2_core_ui.md)（UI 层）

### Phase 2: 月度与年度规划

**目标**：补全时间维度层级

**关键交付物**：
1. 月度视图（月历 + 月目标 + 小赢挑战 + 习惯追踪 + 心情追踪 + 月记忆）
2. 年度视图（年度寄语 + 成长计划 + 年历）
3. `MonthlyPlan`、`YearlyPlan` 模型
4. 灵感系统（静态常量 + 轮换 Provider）

**完成标志**：完整日→周→月→年时间层级可用。

### Phase 3: 丰富度功能

**目标**：匹配实体书全部内容

**关键交付物**：
1. 清单系统（书单/影单/自定义 + 年度精选）
2. 幸福时刻 + 高光时刻
3. 100 天小赢挑战（里程碑 + 奖励）
4. 旅行与活动
5. 月度活动 6 主题（习惯约定/烦恼减负/夸夸群/身边的人/未来照见我/理想 vs 现在）
6. 成长回望

**完成标志**：完整 LUMI 体验，覆盖原书所有内容。

### Phase 4: 视觉打磨与上架

**目标**：还原原书视觉温度 + 上架优化

**关键交付物**：
1. 星星累积动画（四角星主题贯穿）
2. 书中配色作为可选主题
3. 猫咪伴侣回应优化
4. Google Play 截图和描述更新
5. AI 模式发现（30+ 天数据触发）

**完成标志**：视觉品质达到上架标准。

---

## 轨道与 Phase 的映射

| 轨道 | 对应 Phase | 详细计划文件 |
|------|-----------|-----------|
| 轨道一：数据基础 | Phase 1 | [plan_02](plan_02_v3_track1_data_layer.md) |
| 轨道二：核心 UI + 导航 | Phase 1 | [plan_03](plan_03_v3_track2_core_ui.md) |
| 轨道三：集成（Onboarding + 通知 + 成就）| Phase 1 | [plan_04](plan_04_v3_track3_integration.md) |
| 轨道四：月度/年度 + 历史 | Phase 2 | [plan_05](plan_05_v3_track4_history_stats.md) |
| 轨道五：丰富度 + 灵感 + 活动 | Phase 3 | [plan_06](plan_06_v3_track5_templates_patterns.md) |
| 轨道六：视觉打磨 + AI | Phase 4 | （Phase 4 轻量，可直接在 PRD 中执行）|

---

## 技术栈（不变）

- Flutter 3.41.x + Dart 3.11.x
- Firebase（Firestore + Auth + Analytics + Crashlytics）
- SQLite（本地 SSOT）+ Firestore（云备份）
- Riverpod 3.x 状态管理
- GoRouter 导航
- Material 3 + 可选像素主题

---

## 验收标准

### Phase 1 完成后：
1. `dart analyze lib/` 零 error
2. `flutter test` 全部通过
3. 全新安装 → LUMI onboarding 4 页 → 进入 TodayScreen（无猫咪领养）
4. 记录一条每日一光 → 切换到旅程 Tab → 看到本周视图
5. 填写周计划（四象限 + 一句话）→ 填写周回顾（3 幸福时刻 + 感恩 + 学到了）
6. 添加/管理烦恼 → 分类烦恼状态
7. 点击"我的"Tab → 看到 LUMI 统计 + 猫咪伴侣入口（二级）
8. 真机验证（`scripts/adb-debug.sh install` + `errors`）

---

## 风险评估

| 风险 | 缓解措施 |
|------|---------|
| 范围膨胀——原书内容量巨大 | 分 4 个 Phase，MVP 只含日/周核心循环 |
| 100 天挑战网格性能 | `CustomPaint` + 缓存渲染，不用 100 个独立 Widget |
| 猫咪系统残留代码影响新导航 | Phase 1 先隔离猫咪入口，不急删代码 |
| 灵感清单 i18n 工作量 | 灵感内容作为静态常量，逐步翻译 |

---

## Changelog

| 日期 | 变更 |
|------|------|
| 2026-03-17 | v3 觉知伴侣初始版本 |
| 2026-03-19 | LUMI 战略转型：3-Tab、猫咪降级、完整原书电子化、4 阶段路线 |
