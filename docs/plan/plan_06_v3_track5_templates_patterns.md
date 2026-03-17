---
level: 2
file_id: plan_06
parent: plan_01
status: pending
created: 2026-03-17 23:30
children: []
estimated_time: 360分钟
prerequisites: [plan_02, plan_05]
---

# 模块：模板库 + 模式发现基础（轨道五）

## 一、模块概述

### 模块目标

交付一个 **确定性、离线优先** 的内容生成系统——即「猫咪反应模板库」。这套模板库是整个觉知伴侣产品的「灵魂」：它为猫咪在各种场景下的文字反应提供温暖、多样、不重复的文案，**完全不依赖 AI 或网络**。

MVP 核心承诺：**零 AI 依赖**。所有原本需要 AI 生成的内容（猫咪反应、周总结、月度鼓励）均由本模板库通过占位符替换 + 随机选取实现。

### 在项目中的位置

```
轨道一（数据基础）──► 轨道五（模板库 + 模式发现）
轨道四（觉知统计）──► 轨道五（标签频率分析数据来源）

轨道五 ─ ─ ─► 轨道二（CatBedtimeAnimation 使用模板文案）
轨道五 ─ ─ ─► 轨道三（周总结、月度鼓励使用模板文案）
```

> 虚线表示：轨道二、三可先用少量种子模板启动开发，轨道五交付完整模板库后替换。

### 模块交付物

| 交付物 | 说明 |
|--------|------|
| 猫咪反应模板库（~150 条 ZH + ~150 条 EN） | 覆盖 12 个场景，每场景 10-20 条 |
| `getRandomCatResponse()` 函数 | 占位符替换 + 随机选取 |
| 本地标签频率分析 | `getTagFrequency()` / `getTagFrequencyByMood()` |
| GrowthInsightCard（成长洞察卡片） | 嵌入 CatDetailScreen，展示标签频率洞察 |
| `aiDiscoveryEligibleProvider` | 控制洞察卡片的显示资格 |

---

## 二、猫咪反应模板库

### 2.1 架构设计

**文件**：`lib/core/constants/cat_response_templates.dart`

```dart
import 'dart:math';

/// 猫咪反应场景枚举。
enum CatResponseScene {
  lightVeryHappy,   // 一点光保存后 — 很开心
  lightHappy,       // 一点光保存后 — 开心
  lightCalm,        // 一点光保存后 — 平静
  lightDown,        // 一点光保存后 — 低落
  lightVeryDown,    // 一点光保存后 — 很低落
  weeklySummary,    // 周回顾完成后
  worryResolved,    // 烦恼标记为已解决
  worryDisappeared, // 烦恼标记为消失
  monthlyStart,     // 月初仪式设定后
  monthlyProgress,  // 月度挑战进度鼓励
  monthlyComplete,  // 月度挑战完成
  gentleReturn,     // 用户多天未记录后回来
}

/// 获取随机猫咪反应文案。
///
/// 支持占位符：{catName}, {lightCount}, {weekCount},
///           {habitName}, {targetDays}, {completedDays}, {daysAway}
///
/// [locale] 传入 'zh' 或 'en'，默认 'zh'。
String getRandomCatResponse(
  CatResponseScene scene, {
  String locale = 'zh',
  Map<String, String> params = const {},
}) {
  final pool = locale == 'en'
      ? _templatesEn[scene]!
      : _templatesZh[scene]!;
  final template = pool[Random().nextInt(pool.length)];
  return _replacePlaceholders(template, params);
}

/// 占位符替换：将 {key} 替换为 params[key]。
String _replacePlaceholders(String template, Map<String, String> params) {
  var result = template;
  for (final entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value);
  }
  return result;
}
```

**设计要点**：

- 常量文件，编译期内联，零运行时开销
- `Random().nextInt()` 保证每次调用获得不同文案
- 占位符格式统一为 `{key}`，调用方传入 `Map<String, String>`
- 双语存储在同一文件，通过 `locale` 参数切换
- 未来 V3.1 单猫重构时，可新增 `{personality}` 维度，按性格过滤模板子集

### 2.2 中文模板内容

> **文案原则**：温暖、关怀、从不施压。猫咪第一人称视角（「本猫」「喵~」）。每条 ≤ 50 字，0-1 个 emoji。

#### lightVeryHappy — 一点光保存后（很开心）

```dart
const _lightVeryHappyZh = [
  '铲屎官今天好开心，{catName}也开心！🎉',
  '看到你这么开心，{catName}的尾巴都翘起来了~',
  '好棒好棒！{catName}要蹦蹦跳跳庆祝一下！',
  '今天的光好耀眼呀，{catName}眯起了眼睛~',
  '开心的日子就该被记住，{catName}帮你记着啦 ✨',
  '{catName}感受到了你的快乐，喵喵喵！',
  '这么开心的一天，{catName}决定多打几个滚~',
  '你笑起来的样子，{catName}最喜欢了 😸',
  '今天的快乐好满溢呀，{catName}接住了！',
  '铲屎官的开心就是{catName}的开心，永远都是~',
  '哇，今天是闪闪发光的一天呢！',
  '{catName}替你开心，尾巴摇啊摇~',
];
```

#### lightHappy — 一点光保存后（开心）

```dart
const _lightHappyZh = [
  '又记录了一束光，{catName}蹭蹭你 ✨',
  '今天也是有光的一天呢，真好~',
  '{catName}看到光了，轻轻地踩了踩你的手~',
  '一束新的光，{catName}帮你收好啦 🌟',
  '开心的事值得被记住，{catName}懂的~',
  '你的光照到{catName}了，暖暖的~',
  '今天的小确幸，{catName}陪你一起开心~',
  '嗯嗯，是温暖的一天呢，{catName}满足了 😺',
  '又是一束光呀，{catName}的心情也亮了~',
  '{catName}凑过来蹭了蹭你，嘿嘿~',
  '记录下来的光，以后翻看会更亮的 ✨',
  '今天辛苦啦，能记住好的就已经很棒了~',
];
```

#### lightCalm — 一点光保存后（平静）

```dart
const _lightCalmZh = [
  '平静的一天也很好呢 🍃',
  '{catName}安安静静趴在你身边~',
  '不需要每天都精彩，平静也是一种幸福~',
  '今天是安静的日子，{catName}陪你发呆~',
  '{catName}伸了个懒腰，靠着你睡着了~',
  '平平淡淡的，就很好了 🌿',
  '安安静静地，{catName}在这里~',
  '有些日子就是适合放空，{catName}也这么觉得~',
  '今天的节奏刚刚好，{catName}打了个小哈欠~',
  '什么都不用想也没关系，{catName}在呢~',
  '{catName}轻轻地闭上了眼睛，陪你安静一会儿~',
  '平静也是一束温柔的光呀 🕊️',
];
```

#### lightDown — 一点光保存后（低落）

```dart
const _lightDownZh = [
  '不开心的日子，{catName}陪着你 💛',
  '{catName}轻轻靠过来了，什么都不说~',
  '难过也没关系，{catName}在你身边呢~',
  '今天辛苦了，{catName}把最软的肚子给你靠~',
  '{catName}蹭了蹭你的手，想让你暖一点~',
  '低落的时候也愿意来记录，你已经很勇敢了~',
  '不开心可以不用笑，{catName}陪你就好~',
  '{catName}把尾巴轻轻搭在你手上~',
  '慢慢来，没有什么是一定要马上好起来的~',
  '今天不容易吧，{catName}给你暖暖的~',
  '{catName}缩在你身边，安静地陪着~',
  '能说出来就是一种勇敢，{catName}听到了 🫶',
];
```

#### lightVeryDown — 一点光保存后（很低落）

```dart
const _lightVeryDownZh = [
  '没事的，{catName}哪都不去 🫂',
  '{catName}蜷在你身边，不走了~',
  '不需要说什么，{catName}就在这里~',
  '抱抱你，今天真的辛苦了~',
  '{catName}把最暖的位置留给你~',
  '很难过对不对？{catName}懂的~',
  '什么时候都可以来找{catName}，好吗？',
  '{catName}轻轻地舔了舔你的手指~',
  '你不用假装没事，{catName}都知道的~',
  '难过的日子也会过去的，{catName}陪你等~',
  '就算世界很吵，{catName}的怀里很安静~',
  '{catName}不会催你好起来，就陪着你~',
  '能来记录的你，已经很了不起了 💛',
];
```

#### weeklySummary — 周回顾完成后

```dart
const _weeklySummaryZh = [
  '这周你记录了 {lightCount} 束光，{catName}都记在心里了 ✨',
  '第 {weekCount} 次周回顾完成！{catName}为你骄傲~',
  '{lightCount} 束光照亮了这一周，{catName}觉得好温暖~',
  '又完成了一次回顾，{catName}摇摇尾巴表示认可！',
  '这一周的光，{catName}帮你收好了 🌟',
  '回顾完成啦！{catName}伸了个满足的懒腰~',
  '这周有 {lightCount} 个发光的日子，{catName}都看到了~',
  '{weekCount} 次回顾了呢，你比自己想的更有毅力 ✨',
  '这周的故事，{catName}都听到了，很好很好~',
  '每一次回顾都是一次温柔的回望，{catName}喜欢~',
  '这周你做得很好，{catName}要给你颁个小奖章 🏅',
  '{catName}翻了翻这周的记录，嗯，你在发光呢~',
  '又一周过去了，{catName}陪你走过了每一天~',
  '{lightCount} 束光，{weekCount} 次回顾，都是你的宝藏 💎',
  '这周辛苦啦，{catName}给你揉揉肩~',
];
```

#### worryResolved — 烦恼标记为已解决

```dart
const _worryResolvedZh = [
  '搞定了一个烦恼！{catName}替你开心 🎉',
  '看吧，你比自己想的更厉害呢~',
  '又解决了一个！{catName}蹦蹦跳跳~',
  '烦恼被你打败啦，{catName}鼓掌 👏',
  '一个个来，你处理得很好~',
  '{catName}就知道你可以的！',
  '解决烦恼的你，闪闪发光 ✨',
  '少了一个烦恼，多了一份轻松~',
  '搞定！{catName}甩甩尾巴庆祝一下~',
  '{catName}记住了，你是能解决问题的人~',
  '这个烦恼再也不会打扰你啦~',
  '又轻松了一点点，感觉真好~',
];
```

#### worryDisappeared — 烦恼标记为消失

```dart
const _worryDisappearedZh = [
  '烦恼自己消失了，有时候就是这样呢~',
  '不是所有烦恼都需要解决，有些会自己走的 🍃',
  '{catName}目送这个烦恼离开了~',
  '消失就消失了，不用追究原因~',
  '有些事情，时间会帮忙处理的~',
  '烦恼走了，{catName}松了口气~',
  '看吧，没有什么是永远不变的~',
  '消失的烦恼就让它走吧，轻装前行 🌿',
  '{catName}挥了挥爪子，再见啦小烦恼~',
  '有时候不做什么，事情也会好起来~',
  '一个烦恼悄悄走了，感觉世界变轻了~',
  '不需要每个烦恼都有答案，消失了也很好~',
];
```

#### monthlyStart — 月初仪式设定后

```dart
const _monthlyStartZh = [
  '新的一月，{catName}陪你一起出发 🌱',
  '{habitName} {targetDays} 天，{catName}和你一起加油！',
  '小目标设好了！{catName}帮你记着呢~',
  '新月份新开始，{catName}的尾巴已经翘起来了~',
  '{targetDays} 天的约定，{catName}会一直陪着你 ✨',
  '不用完美，慢慢来就好，{catName}不着急~',
  '{habitName}，听起来就很棒！{catName}期待~',
  '月初的决心最闪亮，{catName}帮你守护它 🌟',
  '一步一步来，{catName}在旁边给你打气~',
  '{catName}伸了个懒腰，准备陪你度过这个月~',
  '新的一月，新的冒险，{catName}准备好了！',
  '目标不在于完美达成，在于每天都试试看 🍀',
];
```

#### monthlyProgress — 月度挑战进度鼓励

```dart
const _monthlyProgressZh = [
  '已经坚持了 {completedDays} 天了，{catName}都看到了 ✨',
  '{completedDays}/{targetDays}，你在发光呢~',
  '每一天的努力，{catName}都记着~',
  '慢慢来，{completedDays} 天已经很棒了！',
  '{catName}偷偷看了进度，嗯，你很努力~',
  '继续保持！{catName}的尾巴为你摇 💪',
  '{completedDays} 天了呢，{catName}替你骄傲~',
  '一天一天累积起来的，都是你的成就~',
  '不完美也没关系，{completedDays} 天都算数 🌿',
  '{catName}给你比个小爪爪，加油~',
  '进度不重要，重要的是你还在坚持 ✨',
  '已经走了这么远了，{catName}陪你继续~',
];
```

#### monthlyComplete — 月度挑战完成

```dart
const _monthlyCompleteZh = [
  '月度挑战完成！！{catName}要疯狂庆祝！🎉🎉',
  '你做到了！{catName}骄傲得尾巴都炸毛了~',
  '{targetDays} 天，你真的做到了！太厉害了 ✨',
  '{catName}决定给你颁发本月最佳铲屎官奖！🏆',
  '完成啦！这个月的你，闪闪发光~',
  '坚持到最后的你，是{catName}最欣赏的人~',
  '恭喜恭喜！{catName}翻了个庆祝的跟头~',
  '{habitName}挑战达成！{catName}撒花 🌸',
  '这一个月的付出都值得，{catName}都看到了~',
  '完成了！给自己准备好的奖励领了吗？😸',
  '{catName}蹦蹦跳跳，这是属于你的荣耀时刻！',
  '一个月的约定，你信守了，{catName}也信守了 💛',
];
```

#### gentleReturn — 用户多天未记录后回来

```dart
const _gentleReturnZh = [
  '你回来啦，{catName}好开心 💛',
  '{catName}一直在这里等你呢，欢迎回来~',
  '好久不见！{catName}蹭了蹭你的脚~',
  '回来就好，什么时候都不晚 🌱',
  '{catName}打了个大大的哈欠，然后开心地看着你~',
  '不管隔了多久，{catName}都在这里~',
  '欢迎回来！{catName}给你留了最暖的位置~',
  '你来了，{catName}的世界又亮了 ✨',
  '没有什么「太晚」，现在就是最好的时候~',
  '{catName}假装不在意，但尾巴已经开始摇了~',
  '回来啦！不用解释，{catName}懂的~',
  '每一次回来都是新的开始，{catName}陪你 🍀',
  '你不在的日子，{catName}就安安静静等着~',
];
```

### 2.3 英文版模板

```dart
// ── lightVeryHappy (EN) ──

const _lightVeryHappyEn = [
  "You're so happy today, {catName} is happy too! 🎉",
  "Seeing you this happy makes {catName}'s tail go up~",
  "Yay! {catName} wants to celebrate with you!",
  "Today's light is so bright, {catName} is squinting~",
  "Happy days deserve to be remembered. {catName}'s got it ✨",
  "{catName} can feel your joy — meow meow meow!",
  "What a wonderful day! {catName} rolls around happily~",
  "Your smile is {catName}'s favorite thing 😸",
  "Today's happiness is overflowing, {catName} caught it!",
  "Your joy is {catName}'s joy, always~",
  "Wow, what a glowing day!",
  "{catName} is happy for you, tail wagging away~",
];

// ── lightHappy (EN) ──

const _lightHappyEn = [
  "Another light recorded, {catName} nuzzles you ✨",
  "Another day with light — how lovely~",
  "{catName} saw the light and gently tapped your hand~",
  "A new light, safely stored by {catName} 🌟",
  "Happy moments deserve to be kept. {catName} knows~",
  "Your light reached {catName} — so warm~",
  "Today's little joy, {catName} shares it with you~",
  "A warm day indeed. {catName} is content 😺",
  "Another light! {catName}'s mood brightened too~",
  "{catName} comes over and nuzzles you, hehe~",
  "Lights you record will shine even brighter later ✨",
  "Good job today — remembering the good is enough~",
];

// ── lightCalm (EN) ──

const _lightCalmEn = [
  "A calm day is a good day too 🍃",
  "{catName} lies quietly beside you~",
  "Not every day needs to be exciting — calm is happiness too~",
  "A quiet day. {catName} keeps you company~",
  "{catName} stretches and falls asleep next to you~",
  "Simple and peaceful — that's just right 🌿",
  "Quietly here, {catName} stays~",
  "Some days are meant for drifting. {catName} agrees~",
  "Today's pace is just right. {catName} yawns softly~",
  "It's okay to think about nothing. {catName} is here~",
  "{catName} gently closes its eyes, keeping you company~",
  "Calm is also a gentle kind of light 🕊️",
];

// ── lightDown (EN) ──

const _lightDownEn = [
  "On tough days, {catName} stays with you 💛",
  "{catName} quietly leans closer, saying nothing~",
  "It's okay to feel down. {catName} is right here~",
  "You've had a hard day. {catName} offers its soft belly~",
  "{catName} nuzzles your hand, hoping to warm you up~",
  "Coming to record even when you're down — that's brave~",
  "You don't have to smile. {catName} just wants to be here~",
  "{catName} gently rests its tail on your hand~",
  "Take your time. Nothing has to be okay right away~",
  "Today wasn't easy, was it? {catName} is here for you~",
  "{catName} curls up beside you, quiet company~",
  "Speaking up is a kind of courage. {catName} heard you 🫶",
];

// ── lightVeryDown (EN) ──

const _lightVeryDownEn = [
  "It's okay. {catName} isn't going anywhere 🫂",
  "{catName} curls up beside you and stays~",
  "You don't need to say anything. {catName} is here~",
  "Hugs. Today was really hard~",
  "{catName} saves the warmest spot for you~",
  "Feeling really down, right? {catName} understands~",
  "You can come find {catName} anytime, okay?",
  "{catName} gently licks your fingertips~",
  "You don't have to pretend you're fine. {catName} knows~",
  "Hard days will pass too. {catName} waits with you~",
  "Even when the world is loud, it's quiet in {catName}'s arms~",
  "{catName} won't rush you to feel better. Just staying~",
  "The fact that you're here is already amazing 💛",
];

// ── weeklySummary (EN) ──

const _weeklySummaryEn = [
  "You recorded {lightCount} lights this week. {catName} remembers every one ✨",
  "Weekly review #{weekCount} done! {catName} is proud of you~",
  "{lightCount} lights brightened this week. {catName} feels warm~",
  "Another review completed! {catName} wags its tail in approval!",
  "This week's lights — {catName} kept them safe 🌟",
  "Review done! {catName} stretches with satisfaction~",
  "{lightCount} shining days this week. {catName} saw them all~",
  "{weekCount} reviews now! You're more persistent than you think ✨",
  "This week's stories — {catName} heard them all. Very good~",
  "Every review is a gentle look back. {catName} loves that~",
  "You did great this week! {catName} gives you a little medal 🏅",
  "{catName} flipped through this week's records — yep, you're glowing~",
  "Another week gone by. {catName} walked through every day with you~",
  "{lightCount} lights, {weekCount} reviews — all your treasures 💎",
  "Hard work this week! {catName} gives you a shoulder rub~",
];

// ── worryResolved (EN) ──

const _worryResolvedEn = [
  "You solved a worry! {catName} is happy for you 🎉",
  "See? You're stronger than you think~",
  "Another one down! {catName} bounces around~",
  "Worry defeated! {catName} claps its paws 👏",
  "One by one — you're handling them so well~",
  "{catName} knew you could do it!",
  "You, solving worries — absolutely radiant ✨",
  "One less worry, one more breath of relief~",
  "Done! {catName} swishes its tail in celebration~",
  "{catName} remembers — you're someone who solves things~",
  "That worry won't bother you anymore~",
  "A little lighter now. Feels good, right?",
];

// ── worryDisappeared (EN) ──

const _worryDisappearedEn = [
  "The worry disappeared on its own. Sometimes it goes that way~",
  "Not all worries need solving. Some just leave 🍃",
  "{catName} watched this worry walk away~",
  "Gone is gone — no need to figure out why~",
  "Some things, time takes care of~",
  "Worry's gone. {catName} breathes a sigh of relief~",
  "See? Nothing stays the same forever~",
  "Let the vanished worry go. Travel light 🌿",
  "{catName} waves a paw — bye bye, little worry~",
  "Sometimes doing nothing still makes things better~",
  "A worry quietly left. The world feels lighter~",
  "Not every worry needs an answer. Disappearing is fine too~",
];

// ── monthlyStart (EN) ──

const _monthlyStartEn = [
  "New month! {catName} sets off with you 🌱",
  "{habitName} for {targetDays} days — {catName} cheers you on!",
  "Goal set! {catName} is keeping track~",
  "New month, fresh start. {catName}'s tail is already up~",
  "{targetDays}-day promise. {catName} will be here the whole time ✨",
  "No need to be perfect. Take it slow. {catName} is patient~",
  "{habitName} — sounds great! {catName} can't wait~",
  "First-of-month determination shines brightest. {catName} guards it 🌟",
  "Step by step. {catName} cheers from the sideline~",
  "{catName} stretches, ready to spend this month with you~",
  "New month, new adventure. {catName} is ready!",
  "The goal isn't perfection — it's trying every day 🍀",
];

// ── monthlyProgress (EN) ──

const _monthlyProgressEn = [
  "{completedDays} days so far. {catName} sees every one ✨",
  "{completedDays}/{targetDays} — you're glowing~",
  "Every day of effort, {catName} remembers~",
  "Take it easy. {completedDays} days is already amazing!",
  "{catName} peeked at the progress — yep, you're working hard~",
  "Keep it up! {catName}'s tail wags for you 💪",
  "{completedDays} days! {catName} is proud~",
  "Day by day, it all adds up to something great~",
  "Not perfect? That's fine. {completedDays} days all count 🌿",
  "{catName} gives you a little paw bump — keep going~",
  "Progress doesn't matter. What matters is you're still here ✨",
  "You've come so far. {catName} walks on with you~",
];

// ── monthlyComplete (EN) ──

const _monthlyCompleteEn = [
  "Monthly challenge complete!! {catName} celebrates wildly! 🎉🎉",
  "You did it! {catName} is so proud its tail is all puffed up~",
  "{targetDays} days — you actually did it! Amazing ✨",
  "{catName} awards you Best Human of the Month! 🏆",
  "Done! You were absolutely glowing this month~",
  "You finished it! {catName} admires you the most~",
  "Congratulations! {catName} does a celebration flip~",
  "{habitName} challenge achieved! {catName} throws confetti 🌸",
  "This whole month of effort was worth it. {catName} saw it all~",
  "You did it! Ready to claim your reward? 😸",
  "{catName} bounces around — this is your moment of glory!",
  "A month-long promise kept. By you, and by {catName} 💛",
];

// ── gentleReturn (EN) ──

const _gentleReturnEn = [
  "You're back! {catName} is so happy 💛",
  "{catName} was right here waiting. Welcome back~",
  "Long time no see! {catName} nuzzles your feet~",
  "Coming back is all that matters. It's never too late 🌱",
  "{catName} yawns big, then looks at you with joy~",
  "No matter how long it's been, {catName} is here~",
  "Welcome back! {catName} saved you the warmest spot~",
  "You're here. {catName}'s world just lit up ✨",
  "There's no such thing as 'too late.' Now is perfect~",
  "{catName} pretends not to care, but its tail is already wagging~",
  "You're back! No explanation needed. {catName} understands~",
  "Every return is a new beginning. {catName} is with you 🍀",
  "While you were away, {catName} just waited quietly~",
];
```

### 2.4 模板注册表

```dart
/// 中文模板注册表。
const Map<CatResponseScene, List<String>> _templatesZh = {
  CatResponseScene.lightVeryHappy: _lightVeryHappyZh,
  CatResponseScene.lightHappy: _lightHappyZh,
  CatResponseScene.lightCalm: _lightCalmZh,
  CatResponseScene.lightDown: _lightDownZh,
  CatResponseScene.lightVeryDown: _lightVeryDownZh,
  CatResponseScene.weeklySummary: _weeklySummaryZh,
  CatResponseScene.worryResolved: _worryResolvedZh,
  CatResponseScene.worryDisappeared: _worryDisappearedZh,
  CatResponseScene.monthlyStart: _monthlyStartZh,
  CatResponseScene.monthlyProgress: _monthlyProgressZh,
  CatResponseScene.monthlyComplete: _monthlyCompleteZh,
  CatResponseScene.gentleReturn: _gentleReturnZh,
};

/// 英文模板注册表。
const Map<CatResponseScene, List<String>> _templatesEn = {
  CatResponseScene.lightVeryHappy: _lightVeryHappyEn,
  CatResponseScene.lightHappy: _lightHappyEn,
  CatResponseScene.lightCalm: _lightCalmEn,
  CatResponseScene.lightDown: _lightDownEn,
  CatResponseScene.lightVeryDown: _lightVeryDownEn,
  CatResponseScene.weeklySummary: _weeklySummaryEn,
  CatResponseScene.worryResolved: _worryResolvedEn,
  CatResponseScene.worryDisappeared: _worryDisappearedEn,
  CatResponseScene.monthlyStart: _monthlyStartEn,
  CatResponseScene.monthlyProgress: _monthlyProgressEn,
  CatResponseScene.monthlyComplete: _monthlyCompleteEn,
  CatResponseScene.gentleReturn: _gentleReturnEn,
};
```

### 2.5 占位符速查表

| 占位符 | 类型 | 使用场景 | 来源 |
|--------|------|---------|------|
| `{catName}` | String | 所有场景 | 当前活跃猫咪的 `name` 字段 |
| `{lightCount}` | String (数字) | weeklySummary | 本周 daily_lights 记录数 |
| `{weekCount}` | String (数字) | weeklySummary | 用户累计周回顾次数（awareness_streaks.totalWeeklyReviews） |
| `{habitName}` | String | monthlyStart, monthlyComplete | 月度挑战选择的习惯名称 |
| `{targetDays}` | String (数字) | monthlyStart, monthlyComplete | 目标天数（用户设定，默认 20，范围 10-30） |
| `{completedDays}` | String (数字) | monthlyProgress | 本月已完成天数 |
| `{daysAway}` | String (数字) | gentleReturn（预留） | 用户距上次记录的天数 |

---

## 三、周总结模板生成逻辑

### 3.1 调用时机

```
用户完成周回顾 → 点击「保存」
    ↓
WeeklyReviewScreen.onSave()
    ↓
1. 保存 WeeklyReview 到 SQLite
2. 调用 getRandomCatResponse(CatResponseScene.weeklySummary, params)
3. 将结果写入 WeeklyReview.catWeeklySummary 字段
4. 更新 UI 显示猫咪周总结卡片
```

### 3.2 参数构建

```dart
Future<String> generateWeeklySummary({
  required String catName,
  required int lightCount,
  required int weekCount,
  required String locale,
  String? happyMoment1,
}) async {
  final params = {
    'catName': catName,
    'lightCount': lightCount.toString(),
    'weekCount': weekCount.toString(),
  };

  // 如果用户填写了幸福时刻，尝试提取关键词追加到文案末尾
  final base = getRandomCatResponse(
    CatResponseScene.weeklySummary,
    locale: locale,
    params: params,
  );

  // 简单策略：取幸福时刻前 4 个字符作为关键词引用
  if (happyMoment1 != null && happyMoment1.length >= 2) {
    final keyword = happyMoment1.substring(
      0,
      happyMoment1.length > 4 ? 4 : happyMoment1.length,
    );
    return '$base\n说到「$keyword…」$catName 也觉得很棒呢~';
  }

  return base;
}
```

### 3.3 显示方式

保存成功后，在 WeeklyReviewScreen 底部弹出一个卡片：

```
┌─────────────────────────────────┐
│  🐱 {catName} 的周总结          │
│                                 │
│  「这周你记录了 5 束光，         │
│   哈奇米都记在心里了 ✨          │
│   说到「和朋…」哈奇米也觉得      │
│   很棒呢~」                     │
│                                 │
│  ─ 搭配当前猫咪 PixelCatSprite  │
└─────────────────────────────────┘
```

### 3.4 存储

- 字段：`weekly_reviews.catWeeklySummary`（TEXT，已在轨道一的 schema 中定义）
- 生成后写入 SQLite，随 SyncEngine（Sync Engine）同步到 Firestore（Cloud Firestore）
- 下次打开周回顾详情时直接从本地读取，不再重新生成

---

## 四、标签频率分析（本地计算）

### 4.1 方法签名

```dart
/// 文件：lib/services/awareness_repository.dart（已有文件，新增方法）

/// 获取标签频率分布。
///
/// 当带标签的记录数 < [minRecords] 时返回空 Map，
/// 表示数据量不足以产生有意义的洞察。
Future<Map<String, int>> getTagFrequency(
  String uid, {
  int minRecords = 30,
});

/// 按心情维度获取标签频率。
///
/// 返回 Map<Mood, Map<String, int>>，
/// 其中 Mood 为 0-4 对应 veryHappy-veryDown。
Future<Map<int, Map<String, int>>> getTagFrequencyByMood(
  String uid, {
  int minRecords = 30,
});
```

### 4.2 SQL 实现逻辑

#### `getTagFrequency()`

```sql
-- Step 1：统计带标签的记录总数
SELECT COUNT(*) AS tagged_count
FROM local_daily_lights
WHERE uid = ? AND tags IS NOT NULL AND tags != '[]';
-- whereArgs: [uid]

-- 如果 tagged_count < minRecords → 返回空 Map

-- Step 2：查询所有带标签的记录
SELECT tags FROM local_daily_lights
WHERE uid = ? AND tags IS NOT NULL AND tags != '[]';
-- whereArgs: [uid]
```

Dart 侧处理：

```dart
Future<Map<String, int>> getTagFrequency(
  String uid, {
  int minRecords = 30,
}) async {
  final db = await _getDb();

  // Step 1：检查数据量
  final countResult = await db.rawQuery(
    "SELECT COUNT(*) AS c FROM local_daily_lights "
    "WHERE uid = ? AND tags IS NOT NULL AND tags != '[]'",
    [uid],
  );
  final taggedCount = countResult.first['c'] as int;
  if (taggedCount < minRecords) return {};

  // Step 2：聚合标签
  final rows = await db.rawQuery(
    "SELECT tags FROM local_daily_lights "
    "WHERE uid = ? AND tags IS NOT NULL AND tags != '[]'",
    [uid],
  );

  final freq = <String, int>{};
  for (final row in rows) {
    final tags = jsonDecode(row['tags'] as String) as List;
    for (final tag in tags) {
      freq[tag as String] = (freq[tag] ?? 0) + 1;
    }
  }

  // Step 3：按频率降序排序
  final sorted = Map.fromEntries(
    freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
  return sorted;
}
```

#### `getTagFrequencyByMood()`

```dart
Future<Map<int, Map<String, int>>> getTagFrequencyByMood(
  String uid, {
  int minRecords = 30,
}) async {
  final db = await _getDb();

  final countResult = await db.rawQuery(
    "SELECT COUNT(*) AS c FROM local_daily_lights "
    "WHERE uid = ? AND tags IS NOT NULL AND tags != '[]'",
    [uid],
  );
  final taggedCount = countResult.first['c'] as int;
  if (taggedCount < minRecords) return {};

  final rows = await db.rawQuery(
    "SELECT mood, tags FROM local_daily_lights "
    "WHERE uid = ? AND tags IS NOT NULL AND tags != '[]'",
    [uid],
  );

  final result = <int, Map<String, int>>{};
  for (final row in rows) {
    final mood = row['mood'] as int;
    final tags = jsonDecode(row['tags'] as String) as List;
    result.putIfAbsent(mood, () => <String, int>{});
    for (final tag in tags) {
      result[mood]![tag as String] =
          (result[mood]![tag as String] ?? 0) + 1;
    }
  }

  // 每个 mood 内部按频率降序排序
  return result.map((mood, freq) => MapEntry(
    mood,
    Map.fromEntries(
      freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    ),
  ));
}
```

### 4.3 展示位置

在轨道四的 `AwarenessStatsCard`（嵌入 ProfileScreen 统计区域）中展示 **Top 3 标签频率条**：

```
┌──────────────────────────────┐
│  你的标签画像                 │
│                              │
│  #户外  ████████████  42%    │
│  #家人  ████████     28%     │
│  #学习  █████        17%     │
│                              │
│  基于你的 47 条记录           │
└──────────────────────────────┘
```

### 4.4 资格检查与物化状态

**触发条件**：`daily_lights` 表中 `tags IS NOT NULL AND tags != '[]'` 的记录数 >= 30。

**物化状态键**（materialized_state 表）：

| Key | 值 | 说明 |
|-----|-----|------|
| `ai_discovery_eligible` | `'true'` / `'false'` | 标签分析是否已达门槛 |
| `growth_insight` | 文本 | 缓存的洞察文案 |
| `growth_insight_at` | ISO 8601 时间戳 | 洞察生成时间 |

**资格更新时机**：每次保存 DailyLight（Daily Light，每日一点光） 时，如果包含标签，检查一次：

```dart
Future<void> _checkDiscoveryEligibility(String uid) async {
  final freq = await getTagFrequency(uid);
  final eligible = freq.isNotEmpty; // freq 为空说明 < 30 条
  await _materializedStateService.set(
    uid,
    'ai_discovery_eligible',
    eligible.toString(),
  );
}
```

---

## 五、GrowthInsightCard（成长洞察卡片）

### 5.1 文件位置

`lib/screens/cat_detail/components/growth_insight_card.dart`

### 5.2 组件定义

```dart
class GrowthInsightCard extends ConsumerWidget {
  final String catId;
  const GrowthInsightCard({super.key, required this.catId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligible = ref.watch(aiDiscoveryEligibleProvider);

    return eligible.when(
      data: (isEligible) {
        if (!isEligible) return const SizedBox.shrink();
        return _InsightContent(catId: catId);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

### 5.3 行为逻辑

```
1. 读取 materialized_state['ai_discovery_eligible']
   ├── false → 不显示（SizedBox.shrink）
   └── true → 继续
2. 读取 materialized_state['growth_insight'] 和 ['growth_insight_at']
   ├── 缓存存在且 < 7 天 → 直接显示缓存文案
   └── 缓存不存在或 > 7 天 → 重新计算
3. 重新计算：
   a. 调用 getTagFrequency(uid)
   b. 取 Top 1 标签和占比
   c. 生成洞察文案（模板）
   d. 写入 materialized_state 缓存
   e. 显示
```

### 5.4 洞察文案模板

中文：
```dart
const _insightTemplatesZh = [
  '你的幸福 {topTagPercent}% 和 #{topTag} 有关 🌿',
  '最近让你开心的事，{topTagPercent}% 都和 #{topTag} 有关呢~',
  '#{topTag} 似乎是你的快乐源泉，占了 {topTagPercent}% ✨',
  '{catName}发现了一个秘密：#{topTag} 让你最开心~',
  '你知道吗？你的光 {topTagPercent}% 都和 #{topTag} 有关 🌟',
];
```

英文：
```dart
const _insightTemplatesEn = [
  '{topTagPercent}% of your happiness is linked to #{topTag} 🌿',
  'Lately, {topTagPercent}% of your joy involves #{topTag}~',
  '#{topTag} seems to be your happiness source — {topTagPercent}% ✨',
  '{catName} discovered a secret: #{topTag} makes you happiest~',
  'Did you know? {topTagPercent}% of your lights involve #{topTag} 🌟',
];
```

### 5.5 卡片 UI（UI，用户界面）

```
┌──────────────────────────────────┐
│  🌿 {catName} 的小发现           │
│                                  │
│  你的幸福 42% 和 #户外 有关       │
│                                  │
│  3 天前刷新                      │
└──────────────────────────────────┘
```

- 使用 `Card` + `Theme.of(context)` 颜色，双主题兼容
- 副标题显示「X 天前刷新」，基于 `growth_insight_at` 计算
- 整体嵌入 `CatDetailScreen` 的信息区域，位于成长进度条下方

---

## 六、新 Provider（Provider，状态提供者）

### 6.1 aiDiscoveryEligibleProvider

```dart
/// 文件：lib/providers/awareness_provider.dart（已有文件，新增 provider）

/// 标签分析资格检查。
///
/// 当 daily_lights 表中带标签的记录 >= 30 条时返回 true。
final aiDiscoveryEligibleProvider = FutureProvider<bool>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return false;
  final repo = ref.watch(awarenessRepositoryProvider);
  final freq = await repo.getTagFrequency(uid);
  return freq.isNotEmpty;
});
```

### 6.2 growthInsightProvider（可选，如需缓存层）

```dart
/// 成长洞察文案 Provider，带 7 天缓存。
final growthInsightProvider = FutureProvider<String?>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return null;

  final eligible = await ref.watch(aiDiscoveryEligibleProvider.future);
  if (!eligible) return null;

  final stateService = ref.watch(materializedStateServiceProvider);

  // 检查缓存
  final cachedInsight = await stateService.get(uid, 'growth_insight');
  final cachedAt = await stateService.get(uid, 'growth_insight_at');
  if (cachedInsight != null && cachedAt != null) {
    final age = DateTime.now().difference(DateTime.parse(cachedAt));
    if (age.inDays < 7) return cachedInsight;
  }

  // 重新计算
  final repo = ref.watch(awarenessRepositoryProvider);
  final freq = await repo.getTagFrequency(uid);
  if (freq.isEmpty) return null;

  final topTag = freq.keys.first;
  final total = freq.values.reduce((a, b) => a + b);
  final percent = (freq[topTag]! / total * 100).round();

  // 使用专用的洞察模板列表（非 CatResponseScene）
  final insightTemplates = [
    '你的幸福 {topTagPercent}% 和 #{topTag} 有关 🌿',
    '最近记录最多的是 #{topTag}，占了 {topTagPercent}% ✨',
    '#{topTag} 是你最大的快乐来源（{topTagPercent}%）🌟',
    '{catName} 发现你特别喜欢和 #{topTag} 相关的事情~',
    '过去一个月，#{topTag} 出现了 {topTagPercent}% 的时间 💛',
  ];
  final template = insightTemplates[Random().nextInt(insightTemplates.length)];
  final insight = _replacePlaceholders(template, {
    'topTag': topTag,
    'topTagPercent': percent.toString(),
    'catName': catName,
  });

  await stateService.set(uid, 'growth_insight', insight);
  await stateService.set(
    uid,
    'growth_insight_at',
    DateTime.now().toIso8601String(),
  );

  return insight;
});
```

> **注**：growthInsightProvider 中洞察文案的生成应使用第五节定义的 `_insightTemplatesZh` / `_insightTemplatesEn`，而非 `CatResponseScene`。上方伪代码仅展示缓存逻辑框架。

---

## 七、文件操作清单

### 需要创建的文件

| 文件 | 用途 | 预估行数 |
|------|------|---------|
| `lib/core/constants/cat_response_templates.dart` | 猫咪反应模板库（12 场景 × 10-15 条 × ZH/EN） | ~600 行 |
| `lib/screens/cat_detail/components/growth_insight_card.dart` | 成长洞察卡片 Widget | ~120 行 |

### 需要修改的文件

| 文件 | 改动内容 | 预估改动量 |
|------|---------|-----------|
| `lib/services/awareness_repository.dart` | 新增 `getTagFrequency()`、`getTagFrequencyByMood()`、`_checkDiscoveryEligibility()` | +80 行 |
| `lib/providers/awareness_provider.dart` | 新增 `aiDiscoveryEligibleProvider`、`growthInsightProvider` | +40 行 |
| `lib/screens/cat_detail/cat_detail_screen.dart` | 在信息区域添加 `GrowthInsightCard` | +5 行 |
| `lib/screens/awareness/weekly_review_screen.dart` | 集成 `generateWeeklySummary()`，保存后显示猫咪周总结卡片 | +30 行 |

### 需要读取的文件（实现参考）

| 文件 | 参考内容 |
|------|---------|
| `lib/core/constants/cat_constants.dart` | 现有常量文件组织方式 |
| `lib/services/local_database_service.dart` | SQLite 查询模式 |
| `lib/models/cat.dart` | `materializedState` 字段使用方式 |
| `lib/providers/user_profile_provider.dart` | `currentUidProvider` 引用方式 |

---

## 八、依赖关系

### 前置条件

| 依赖项 | 来源 | 具体内容 |
|--------|------|---------|
| `daily_lights` 表 | 轨道一（plan_02） | 表结构已创建，`tags` 字段可用 |
| `weekly_reviews` 表 | 轨道一（plan_02） | `catWeeklySummary` 字段可用 |
| `materialized_state` 表 | 现有架构 | 已存在，可直接使用 |
| `AwarenessRepository` | 轨道一（plan_02） | 基础 CRUD 已实现 |
| `AwarenessStatsCard` | 轨道四（plan_05） | 标签频率条在此组件中展示 |

### 对后续的影响

| 影响项 | 说明 |
|--------|------|
| 轨道二 CatBedtimeAnimation | 调用 `getRandomCatResponse()` 获取心情反应文案 |
| 轨道三 WeeklyReviewScreen | 调用 `generateWeeklySummary()` 生成猫咪周总结 |
| 轨道三 MonthlyRitualCard | 调用 `getRandomCatResponse(monthlyStart/Progress/Complete)` |
| 轨道四 AwarenessStatsCard | 调用 `getTagFrequency()` 展示标签频率条 |
| V3.1 单猫重构 | 猫咪性格作为模板维度（新增 `personality` 过滤） |

---

## 九、技术方案细节

### 9.1 模板扩展策略

当前模板库为 **静态常量**，未来扩展路径：

| 阶段 | 方案 | 说明 |
|------|------|------|
| V3 MVP | 常量文件 | 零依赖，编译内联 |
| V3.1 | 常量 + 性格过滤 | 按猫咪性格 ID 过滤子集 |
| V4 | 常量 + Remote Config | Firebase Remote Config（远程配置）热更新模板 |

### 9.2 随机性保障

为避免用户感到重复：

1. **每场景至少 10 条模板**（当前设计 12-15 条）
2. **不使用 `Random()` 的默认种子**——每次调用创建新实例
3. **未来可选**：维护一个「最近 N 条」的排除列表（基于 SharedPreferences），确保连续调用不重复

### 9.3 L10n（Localization，本地化）集成

模板库 **不使用 ARB 文件**（Application Resource Bundle，应用资源包），原因：

- ARB 适合 UI 固定文案，不适合大量同义替换文案
- 模板需要随机选取，ARB 的 key-value 结构无法满足
- 保持为 Dart 常量，编译期类型安全

Locale（区域设置）传入方式：
```dart
final locale = Localizations.localeOf(context).languageCode; // 'zh' 或 'en'
final text = getRandomCatResponse(scene, locale: locale, params: {...});
```

---

## 十、验收标准

### 功能验收

- [ ] 12 个场景全部有对应的模板池（ZH + EN 各 ≥ 10 条）
- [ ] `getRandomCatResponse()` 每次调用返回不同文案（概率上，多次调用覆盖至少 3 种不同结果）
- [ ] 占位符替换正确：`{catName}` 被替换为实际猫咪名称
- [ ] 周总结在保存后生成并存储到 `catWeeklySummary` 字段
- [ ] 周总结卡片在 WeeklyReviewScreen 保存后正确显示
- [ ] `getTagFrequency()` 在记录数 < 30 时返回空 Map
- [ ] `getTagFrequency()` 在记录数 >= 30 时返回正确的降序频率 Map
- [ ] GrowthInsightCard 在不满足条件时不显示（SizedBox.shrink）
- [ ] GrowthInsightCard 在满足条件时显示洞察文案
- [ ] GrowthInsightCard 的 7 天缓存机制正常工作

### 质量验收

- [ ] `dart analyze lib/` 零 warning/error
- [ ] 模板文案风格一致：温暖、关怀、从不施压
- [ ] 无硬编码颜色，使用 `Theme.of(context)` 保证双主题兼容
- [ ] `cat_response_templates.dart` 文件行数 ≤ 800 行
- [ ] 所有新增函数 ≤ 30 行

### 手动测试（真机）

- [ ] 记录不同心情的一点光，猫咪反应文案与心情匹配
- [ ] 多次记录同一心情，文案有变化（不总是同一条）
- [ ] 完成周回顾后看到猫咪周总结卡片
- [ ] 切换到英文 locale，模板显示为英文
- [ ] 在 Retro Pixel（复古像素）主题下，GrowthInsightCard 正确渲染

---

## 十一、风险与挑战

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 模板文案风格不一致 | 用户感受割裂 | 所有模板统一审阅，遵循「温暖/关怀/不施压」三原则 |
| 模板数量不足导致重复感 | 用户失去新鲜感 | 每场景 ≥ 12 条，V3.1 可通过性格维度再翻倍 |
| 标签频率分析性能 | 数据量大时 SQL 查询慢 | minRecords 门槛控制；30 条数据量级下 SQLite 查询 < 10ms |
| 占位符遗漏 | 显示原始 `{catName}` 文本 | 单元测试覆盖所有场景的占位符替换 |
| 单文件 600 行接近 800 行红线 | 后续扩展受限 | 如超限，按场景拆分为 `_light_templates.dart` 等子文件 |

---

## 十二、实施建议与执行顺序

```
Step 1：创建 cat_response_templates.dart
        ├── 定义 CatResponseScene 枚举
        ├── 实现 getRandomCatResponse() + _replacePlaceholders()
        ├── 写入全部 ZH 模板（~150 条）
        └── 写入全部 EN 模板（~150 条）

Step 2：集成周总结生成
        ├── 实现 generateWeeklySummary()
        ├── 修改 WeeklyReviewScreen.onSave()
        └── 添加周总结卡片 UI

Step 3：实现标签频率分析
        ├── 在 AwarenessRepository 添加 getTagFrequency()
        ├── 添加 getTagFrequencyByMood()
        └── 添加 _checkDiscoveryEligibility()

Step 4：实现 GrowthInsightCard
        ├── 创建 growth_insight_card.dart
        ├── 添加 aiDiscoveryEligibleProvider
        ├── 添加 growthInsightProvider
        └── 嵌入 CatDetailScreen

Step 5：验证与测试
        ├── dart analyze lib/
        ├── 真机端到端测试
        └── 双主题验证
```

**预估总耗时**：360 分钟（6 小时）

| 步骤 | 预估耗时 |
|------|---------|
| Step 1：模板库 | 120 分钟 |
| Step 2：周总结集成 | 60 分钟 |
| Step 3：标签频率分析 | 90 分钟 |
| Step 4：GrowthInsightCard | 60 分钟 |
| Step 5：测试验证 | 30 分钟 |
