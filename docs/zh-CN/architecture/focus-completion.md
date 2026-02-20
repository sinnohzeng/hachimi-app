# 专注完成体验

> 专注完成后的庆祝流程规格说明：通知、触觉反馈、撒花特效和 L10N。

**状态：** 活跃
**证据来源：** `lib/screens/timer/focus_complete_screen.dart`、`lib/screens/timer/timer_screen.dart`、`lib/services/notification_service.dart`
**相关文档：** [state-management.md](./state-management.md)、[cat-system.md](./cat-system.md)

---

## 概述

当专注会话结束时（倒计时完成或秒表模式点击「完成」），应用会提供多感官的庆祝体验：

1. **系统通知** —— 在通知栏显示 XP 摘要
2. **触觉反馈** —— 平台震动模式（完成时强震，放弃时轻震）
3. **撒花特效** —— 庆祝页面全屏粒子效果
4. **动画数据卡片** —— XP 明细，带交错入场动画

---

## 完成流程

```
TimerScreen._saveSession()
  ├── FocusTimerService.stop()          // 停止前台服务
  ├── 计算 XP、金币、阶段跃迁
  ├── 保存 FocusSession 到 Firestore
  ├── NotificationService.showFocusComplete()  // 系统通知（仅成功完成时）
  └── Navigator → FocusCompleteScreen
        ├── ConfettiController.play()   // 2 秒爆发（非放弃时）
        ├── Vibration.vibrate(pattern)  // 强震动模式（放弃时轻震）
        ├── 交错动画                     // emoji → 内容 → 数据卡片
        └── DiaryService.generateTodayDiary()  // 异步 AI 日记生成
```

---

## 通知

| 字段 | 值 |
|------|-----|
| 通知渠道 | `hachimi_focus`（重要性 HIGH） |
| ID | `300000`（固定值 —— 新通知覆盖旧通知） |
| 标题 | L10N `focusCompleteNotifTitle`（"任务完成！"） |
| 正文 | L10N `focusCompleteNotifBody`（"{catName} 通过 {minutes} 分钟专注获得了 +{xp} XP"） |
| 触发条件 | 仅在成功完成时（`isCompleted == true`） |

---

## 触觉反馈

| 场景 | 模式 |
|------|------|
| 完成 | `[0, 200, 100, 300]` 毫秒，最大强度（255） |
| 放弃 | 单次 100 毫秒震动，半强度（128） |

使用 `vibration` 包支持自定义震动模式（替换 `HapticFeedback.heavyImpact()`）。

---

## 撒花特效

使用 `confetti_widget` 包。仅在成功完成时播放（放弃时不播放）。

| 参数 | 值 |
|------|-----|
| 持续时间 | 2 秒 |
| 方向 | `BlastDirectionality.explosive`（中心爆发） |
| 粒子数量 | 30 |
| 爆发力 | 8–20 |
| 重力 | 0.1 |
| 颜色 | `primary`、`tertiary`、`secondary`、`amber`、`pink` |

---

## L10N 键名（ARB）

`focus_complete_screen.dart` 中所有硬编码字符串均替换为 ARB 键名：

| 键名 | EN | ZH |
|------|----|----|
| `focusCompleteItsOkay` | It's okay! | 没关系！ |
| `focusCompleteEvolved` | {catName} evolved! | {catName} 进化了！ |
| `focusCompleteFocusedFor` | You focused for {minutes} minutes | 你专注了 {minutes} 分钟 |
| `focusCompleteAbandonedMessage` | {catName} says: "We'll try again!" | {catName} 说："我们下次再来！" |
| `focusCompleteFocusTime` | Focus time | 专注时长 |
| `focusCompleteCoinsEarned` | Coins earned | 获得金币 |
| `focusCompleteBaseXp` | Base XP | 基础 XP |
| `focusCompleteStreakBonus` | Streak bonus | 连续奖励 |
| `focusCompleteMilestoneBonus` | Milestone bonus | 里程碑奖励 |
| `focusCompleteFullHouseBonus` | Full house bonus | 全勤奖励 |
| `focusCompleteTotal` | Total | 总计 |
| `focusCompleteEvolvedTo` | Evolved to {stage}! | 进化到 {stage}！ |
| `focusCompleteDiaryWriting` | Writing diary... | 正在写日记... |
| `focusCompleteDiaryWritten` | Diary written! | 日记已写好！ |
| `focusCompleteNotifTitle` | Quest complete! | 任务完成！ |
| `focusCompleteNotifBody` | {catName} earned +{xp} XP from {minutes}min of focus | {catName} 通过 {minutes} 分钟专注获得了 +{xp} XP |

---

## 更新日志

| 日期 | 变更 |
|------|------|
| 2026-02-19 | 初始规格 —— 通知、震动、撒花、L10N |
