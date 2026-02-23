# 界面规范

> 各界面的 UI 规范。每个界面章节说明实现文件、布局结构、关键交互和触发的分析事件。

---

## 导航总览

```
OnboardingScreen（仅首次启动）
    ↓
LoginScreen
    ↓（已认证且有习惯）
HomeScreen ─ 4 标签 NavigationBar 外壳 ─┬─ 今日标签
                                         ├─ 猫咪房间标签 → CatRoomScreen
                                         ├─ 统计标签 → StatsScreen
                                         └─ 我的标签 → ProfileScreen

HomeScreen → FocusSetupScreen → TimerScreen → FocusCompleteScreen
HomeScreen → AdoptionFlowScreen（FAB 或首个习惯）
CatRoomScreen → CatDetailScreen（通过底部弹窗）
ProfileScreen → CatDetailScreen（通过猫咪相册）
```

---

## S1：引导界面
**文件：** `lib/screens/onboarding/onboarding_screen.dart`

### 布局
- 全屏 `PageView`，共 3 页
- 每页：居中 Emoji（96pt）+ 粗体标题 + 副标题正文
- 第 1 页：🐱「欢迎来到 Hachimi」/「养猫，养成习惯。每次专注，一步成长。」
- 第 2 页：⏱️「专注赚取 XP」/「每一分钟都算数，你的猫咪在每次会话中变得更强。」
- 第 3 页：✨「看着它们进化」/「从幼猫到闪光猫——猫咪的成长旅程映照着你自己。」
- 底部：页面指示点 + 「立即开始」`FilledButton`（仅最后一页显示）

### 行为
- 左右滑动翻页
- 「立即开始」→ 导航至 `LoginScreen`
- 完成后执行 `SharedPreferences.setBool('onboarding_complete', true)`
- 完成后不再显示

---

## S2：登录界面
**文件：** `lib/screens/auth/login_screen.dart`

### 布局
- 居中 `Column`，顶部显示猫咪 Emoji 🐱 + 应用名称「Hachimi」标题
- 副标题：「养猫，养成习惯。」
- 邮箱 `TextField` + 密码 `TextField`（含明文切换）
- 「登录」`FilledButton`
- 「使用 Google 登录」`OutlinedButton`（含 Google 图标）
- 切换：「还没有账号？去注册」`TextButton`

### 注册模式
- 布局相同，按钮变为「创建账号」

### 分析事件
- `sign_up`（`method`：`"email"` 或 `"google"`）注册成功时触发

---

## S3：主界面（4 标签外壳）
**文件：** `lib/screens/home/home_screen.dart`

### 导航
底部 4 目标 `NavigationBar`：

1. **今日**（home 图标）—— 习惯列表 + 精选猫咪
2. **猫咪房间**（pets 图标）—— 插画房间场景
3. **统计**（bar_chart 图标）—— 活动记录 + 进度
4. **我的**（person 图标）—— 设置 + 猫咪相册

### 今日标签

**精选猫咪卡片**（滚动顶部）—— 3 行头部 + 进度行：

- 第 1 行（头部）：猫咪精灵（56px）+ 右侧 3 行信息：
  - 第 1 行：猫咪名字（`titleMedium`，粗体）
  - 第 2 行：Quest 名称（`bodySmall`，最多 2 行）
  - 第 3 行：备忘（`bodySmall`，斜体，最多 2 行，仅有内容时显示）
- 第 2 行（进度）：成长进度条 + 时长/阶段标签 + 「专注」`FilledButton.tonal`
- 渐变背景以猫咪成长阶段颜色着色

**习惯列表**（精选卡片下方）：

- 每行：小型 `CatSprite`（约 40px）| 习惯名称 | 今日进度条 | 「开始」按钮
- 「开始」→ FocusSetupScreen(habitId)
- 今日进度条随分钟积累对比 `goalMinutes` 填充

**空状态**（无习惯）：

- 猫咪占位插图 + 「领养你的第一只猫咪！」 + 「开始」FilledButton → AdoptionFlowScreen

**FAB（悬浮操作按钮）：** `FloatingActionButton.extended` —— 「新建习惯」→ AdoptionFlowScreen

### 分析事件
- 切换至猫咪房间标签时触发 `cat_room_viewed`

---

## S4：领养流程界面（3 步习惯创建）
**文件：** `lib/screens/habits/adoption_flow_screen.dart`

### 第 1 步 —— 定义 Quest
- 顶部 AppBar（标题 + 返回按钮）
- 步骤进度指示器（3 步中的第 1 步）
- **基础信息** 分区标题：
  - Quest 名称 `TextFormField`（必填，prefixIcon：edit_outlined）
  - 备忘 `TextFormField`（maxLength：240，maxLines：4，minLines：2，带随机填充刷新按钮）
- **目标设置** 分区标题：
  - 成长阶梯说明文字
  - 模式切换：`_ModeOption` 卡片（永续模式 / 里程碑模式）
  - 【里程碑】目标小时数片段 `[50h] [100h] [200h] [500h] [自定义]` + 截止日期选择器
  - 每日目标片段 `[15min] [25min] [40min] [60min] [自定义]`
- **提醒** 分区标题：
  - 提醒列表（上限 5 个）+ 删除按钮 + 「添加提醒」按钮 → `showReminderPickerSheet`
- **成长之路** 卡片（始终完整展示，无折叠）—— 展示 4 阶段成长阶梯 + 研究 tip
- 「下一步」`FilledButton`（验证名称非空）

### 第 2 步 —— 领养猫咪
- 「一只小猫咪在等着你！」标题
- 并排 3 张 `CatPreviewCard` 组件
- 每张卡片：精灵占位图 + 品种名称 + 性格徽章 + 性格语录
- 点击选择（未选中卡片淡化至 40% 不透明度并播放动画）
- 「下一步」`FilledButton`（验证已选择猫咪）

### 第 3 步 —— 给猫咪命名
- 居中展示已选猫咪（大图）
- 「你想叫它什么名字？」标签
- 猫咪名称 `TextField`，预填来自 `catNames` 池的随机名字
- 「领养」`FilledButton` → 批量写入 → 导航至主界面
- 领养成功时播放彩纸动画

### 分析事件
- 第 3 步完成时触发 `cat_adopted`（breed、pattern、personality、rarity、is_first_habit）

---

## S5：专注设置界面
**文件：** `lib/screens/timer/focus_setup_screen.dart`

### 布局
- 顶部显示习惯名称 + 连续记录徽章
- 居中大型 `CatSprite`（约 160px），播放待机动画
- 时长片段：`[15] [25] [40] [60] [自定义]`，默认为习惯的 `goalMinutes`
- 模式切换：`SegmentedButton`（「倒计时」/「正计时」）
- 「开始专注」`FilledButton.extended`

### 分析事件
- 触发 `focus_session_started`（habit_id、timer_mode、target_minutes）

---

## S6：计时器界面（专注进行中）
**文件：** `lib/screens/timer/timer_screen.dart`

### 布局
- 全屏，柔和渐变背景（品种颜色 → 深色）
- 顶栏：习惯名称 + 当前连续记录（火焰徽章 + 数字）
- 居中：`CatSprite` 位于圆形进度环（`ProgressRing` 组件）内
- 进度环：正计时模式填充，倒计时模式消耗
- 大字计时器显示（`displayLarge` 文字样式）：`MM:SS` 或 `HH:MM:SS`
- 底部：「放弃」`TextButton`（较小，左下角）

### 行为
- 计时器在进入界面时立即启动
- Android 前台服务在应用最小化时保持计时器运行
- 持久通知：猫咪 Emoji + 习惯名称 + 剩余/已用时间
- 「放弃」：**长按**（600ms）确认 —— 防止误操作
- 应用生命周期处理：
  - 后台 < 15 秒：正常继续
  - 后台 15 秒至 5 分钟：自动暂停
  - 后台 > 5 分钟：自动结束（保存至后台时刻的会话）

### 倒计时归零时
- 播放成功音效 / 震动反馈
- 导航至 FocusCompleteScreen

---

## S7：专注完成界面
**文件：** `lib/screens/timer/focus_complete_screen.dart`

### 布局
- `CatSprite`（大图）播放弹跳/庆祝动画
- 「+{xp} XP」浮动文字从猫咪处向上飘出
- 若阶段进化：`AnimatedSwitcher` 切换至新阶段精灵，附带光芒效果
- 今日完成所有习惯时显示「全家福！」横幅
- 统计摘要卡片：
  - 专注时长
  - 获得 XP
  - 当前连续记录（火焰徽章）
  - 猫咪累计总 XP
- 「完成」`FilledButton` → 返回 HomeScreen

### 分析事件
- `focus_session_completed`（habit_id、actual_minutes、xp_earned、streak_days）
- `cat_level_up`（如适用）
- `streak_achieved`（如达到里程碑）
- `all_habits_done`（如全家福）

---

## S8：猫咪房间界面
**文件：** `lib/screens/cat_room/cat_room_screen.dart`

### 布局
- 全屏 `Stack`
- **第 1 层**：房间背景图（白天：6:00-19:59，夜晚：20:00-5:59）
- **第 2 层**：按槽位坐标 `Positioned` 放置的猫咪精灵
- **第 3 层**：对话气泡叠层（点击时显示）

### 猫咪点击交互
1. 出现对话气泡（性格 × 心情文案），持续 3 秒
2. 底部弹窗向上滑出：
   - 猫咪名字 + 品种 + 性格
   - 「开始专注」→ FocusSetupScreen
   - 「查看详情」→ CatDetailScreen

### 分析事件
- 界面挂载时触发 `cat_room_viewed`（cat_count）
- 每次交互触发 `cat_tapped`（cat_id、action）

---

## S9：猫咪详情界面
**文件：** `lib/screens/cat_detail/cat_detail_screen.dart`

### 布局（可滚动）
1. **主角区域**：大型 `CatSprite`（居中，约 180px）+ 阶段标签，闪光猫阶段附带光芒效果
2. **身份信息卡片**：猫咪名字 | 品种 | 稀有度片段 | 性格徽章 + Emoji
3. **XP 进度卡片**：当前 XP / 下一阶段阈值 + `LinearProgressIndicator` + 「阶段 X → 阶段 Y」标签
4. **专注统计卡片**：Quest 名称 + 备忘 + 2 列统计网格 + 「编辑」+ 「开始专注」按钮
5. **提醒卡片**：提醒列表，支持添加/删除操作
6. **活动热力图卡片**：`StreakHeatmap` 组件 —— 91 天 GitHub 风格网格 + 统计行

### 编辑 Quest（全屏页面）
**文件：** `lib/screens/cat_detail/components/edit_quest_sheet.dart`

通过专注统计卡片中的「编辑」按钮以 `Navigator.push` 导航。布局与 AdoptionFlowScreen 第 1 步统一：

- `Scaffold` + `AppBar`（标题：编辑 Quest，返回按钮）
- **基础信息** 分区：Quest 名称 + 备忘（多行输入）
- **目标设置** 分区：模式切换（`_ModeOption` 卡片）+ 目标小时数 + 截止日期 + 每日目标
- **提醒** 分区：提醒列表，支持添加/删除（保存时持久化）
- **成长之路** 卡片（始终完整展示）
- 底部：固定位置「保存」`FilledButton`

---

## S10：统计界面
**文件：** `lib/screens/stats/stats_screen.dart`

### 布局（可滚动）
1. **今日摘要行**：今日总专注分钟数 | 猫咪数量 | 活跃连续记录数
2. **各习惯板块**：每个习惯显示：
   - Emoji 图标 + 习惯名称
   - 今日进度 `LinearProgressIndicator`（分钟数 / goalMinutes）
   - 已记录时长 / targetHours（累计目标）
   - 连续记录火焰徽章

---

## S11：我的界面
**文件：** `lib/screens/profile/profile_screen.dart`

### 布局（可滚动）
1. **旅程卡片**：总专注时长（格式如 「Xh Ym」）| 总猫咪数 | 最长连续记录
2. **稀有度分布行**：普通（n）| 不普通（n）| 稀有（n）片段
3. **猫咪相册板块**：前 6 只猫咪的 3 列网格预览 + 「查看全部 {n} 只 →」按钮
4. **账号板块**：显示名称 + 邮箱
5. **设置**：通知偏好（未来功能）| 退出登录按钮

### 完整猫咪相册弹窗
- 全屏猫咪网格，按 `createdAt` 降序排列
- 活跃猫咪：全色显示；休眠猫咪：70% 不透明度；已毕业猫咪：50% 不透明度 + 「已毕业」标签
- 点击任意猫咪 → CatDetailScreen

---

## 空状态

| 界面 | 触发条件 | 提示文案 |
|------|---------|---------|
| 今日标签 | 无习惯 | 「领养你的第一只猫咪！」+ CTA 按钮 |
| 猫咪房间 | 无活跃猫咪 | 「你还没有猫咪，创建一个习惯来领养吧。」 |
| 统计界面 | 无习惯 | 「完成第一次专注会话后即可查看统计数据。」 |
| 猫咪相册 | 无猫咪 | 「相册空空如也——开始领养吧！」 |
