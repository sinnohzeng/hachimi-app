import 'dart:math';

import 'package:flutter/foundation.dart';

/// 猫咪反应场景枚举。
enum CatResponseScene {
  lightVeryHappy, // 一点光保存后 — 很开心
  lightHappy, // 一点光保存后 — 开心
  lightCalm, // 一点光保存后 — 平静
  lightDown, // 一点光保存后 — 低落
  lightVeryDown, // 一点光保存后 — 很低落
  weeklySummary, // 周回顾完成后
  worryResolved, // 烦恼标记为已解决
  worryDisappeared, // 烦恼标记为消失
  monthlyStart, // 月初仪式设定后
  monthlyProgress, // 月度挑战进度鼓励
  monthlyComplete, // 月度挑战完成
  gentleReturn, // 用户多天未记录后回来
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
  final pool = (locale == 'en' ? _templatesEn[scene] : _templatesZh[scene]);
  if (pool == null || pool.isEmpty) {
    debugPrint(
      '[CatResponse] Missing templates for scene=$scene locale=$locale',
    );
    return '';
  }
  final template = pool[Random().nextInt(pool.length)];
  return _replacePlaceholders(template, params);
}

/// 生成周总结文案。
///
/// 基于模板随机选取 + 占位符替换，如果用户填写了幸福时刻，
/// 则追加关键词引用。
String generateWeeklySummary({
  required String catName,
  required int lightCount,
  required int weekCount,
  required String locale,
  String? happyMoment1,
}) {
  final params = {
    'catName': catName,
    'lightCount': lightCount.toString(),
    'weekCount': weekCount.toString(),
  };

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
    final suffix = locale == 'en'
        ? '\nAbout "$keyword..." — $catName thinks that\'s wonderful~'
        : '\n说到「$keyword…」$catName 也觉得很棒呢~';
    return '$base$suffix';
  }

  return base;
}

/// 占位符替换：将 {key} 替换为 params[key]。
String _replacePlaceholders(String template, Map<String, String> params) {
  var result = template;
  for (final entry in params.entries) {
    result = result.replaceAll('{${entry.key}}', entry.value);
  }
  // 检测并清除未替换的占位符（避免用户看到 {key} 原文）
  final leftover = RegExp(r'\{\w+\}').hasMatch(result);
  if (leftover) {
    debugPrint('[CatResponse] Unreplaced placeholders in: $template');
    result = result.replaceAll(RegExp(r'\s*\{\w+\}'), '');
  }
  return result;
}

// ═══════════════════════════════════════════════════════════════════
// 中文模板
// ═══════════════════════════════════════════════════════════════════

// ── lightVeryHappy (ZH) ──

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

// ── lightHappy (ZH) ──

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

// ── lightCalm (ZH) ──

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

// ── lightDown (ZH) ──

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

// ── lightVeryDown (ZH) ──

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

// ── weeklySummary (ZH) ──

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

// ── worryResolved (ZH) ──

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

// ── worryDisappeared (ZH) ──

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

// ── monthlyStart (ZH) ──

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

// ── monthlyProgress (ZH) ──

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

// ── monthlyComplete (ZH) ──

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

// ── gentleReturn (ZH) ──

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

// ═══════════════════════════════════════════════════════════════════
// 英文模板
// ═══════════════════════════════════════════════════════════════════

// ── lightVeryHappy (EN) ──

const _lightVeryHappyEn = [
  "You're so happy today, {catName} is happy too! 🎉",
  "Seeing you this happy makes {catName}'s tail go up~",
  'Yay! {catName} wants to celebrate with you!',
  "Today's light is so bright, {catName} is squinting~",
  "Happy days deserve to be remembered. {catName}'s got it ✨",
  '{catName} can feel your joy — meow meow meow!',
  'What a wonderful day! {catName} rolls around happily~',
  "Your smile is {catName}'s favorite thing 😸",
  "Today's happiness is overflowing, {catName} caught it!",
  "Your joy is {catName}'s joy, always~",
  'Wow, what a glowing day!',
  '{catName} is happy for you, tail wagging away~',
];

// ── lightHappy (EN) ──

const _lightHappyEn = [
  'Another light recorded, {catName} nuzzles you ✨',
  'Another day with light — how lovely~',
  '{catName} saw the light and gently tapped your hand~',
  'A new light, safely stored by {catName} 🌟',
  'Happy moments deserve to be kept. {catName} knows~',
  'Your light reached {catName} — so warm~',
  "Today's little joy, {catName} shares it with you~",
  'A warm day indeed. {catName} is content 😺',
  "Another light! {catName}'s mood brightened too~",
  '{catName} comes over and nuzzles you, hehe~',
  'Lights you record will shine even brighter later ✨',
  'Good job today — remembering the good is enough~',
];

// ── lightCalm (EN) ──

const _lightCalmEn = [
  'A calm day is a good day too 🍃',
  '{catName} lies quietly beside you~',
  'Not every day needs to be exciting — calm is happiness too~',
  'A quiet day. {catName} keeps you company~',
  '{catName} stretches and falls asleep next to you~',
  "Simple and peaceful — that's just right 🌿",
  'Quietly here, {catName} stays~',
  'Some days are meant for drifting. {catName} agrees~',
  "Today's pace is just right. {catName} yawns softly~",
  "It's okay to think about nothing. {catName} is here~",
  '{catName} gently closes its eyes, keeping you company~',
  'Calm is also a gentle kind of light 🕊️',
];

// ── lightDown (EN) ──

const _lightDownEn = [
  'On tough days, {catName} stays with you 💛',
  '{catName} quietly leans closer, saying nothing~',
  "It's okay to feel down. {catName} is right here~",
  "You've had a hard day. {catName} offers its soft belly~",
  '{catName} nuzzles your hand, hoping to warm you up~',
  "Coming to record even when you're down — that's brave~",
  "You don't have to smile. {catName} just wants to be here~",
  '{catName} gently rests its tail on your hand~',
  'Take your time. Nothing has to be okay right away~',
  "Today wasn't easy, was it? {catName} is here for you~",
  '{catName} curls up beside you, quiet company~',
  'Speaking up is a kind of courage. {catName} heard you 🫶',
];

// ── lightVeryDown (EN) ──

const _lightVeryDownEn = [
  "It's okay. {catName} isn't going anywhere 🫂",
  '{catName} curls up beside you and stays~',
  "You don't need to say anything. {catName} is here~",
  'Hugs. Today was really hard~',
  '{catName} saves the warmest spot for you~',
  'Feeling really down, right? {catName} understands~',
  'You can come find {catName} anytime, okay?',
  '{catName} gently licks your fingertips~',
  "You don't have to pretend you're fine. {catName} knows~",
  'Hard days will pass too. {catName} waits with you~',
  "Even when the world is loud, it's quiet in {catName}'s arms~",
  "{catName} won't rush you to feel better. Just staying~",
  "The fact that you're here is already amazing 💛",
];

// ── weeklySummary (EN) ──

const _weeklySummaryEn = [
  'You recorded {lightCount} lights this week. {catName} remembers every one ✨',
  'Weekly review #{weekCount} done! {catName} is proud of you~',
  '{lightCount} lights brightened this week. {catName} feels warm~',
  'Another review completed! {catName} wags its tail in approval!',
  "This week's lights — {catName} kept them safe 🌟",
  'Review done! {catName} stretches with satisfaction~',
  '{lightCount} shining days this week. {catName} saw them all~',
  "{weekCount} reviews now! You're more persistent than you think ✨",
  "This week's stories — {catName} heard them all. Very good~",
  'Every review is a gentle look back. {catName} loves that~',
  'You did great this week! {catName} gives you a little medal 🏅',
  "{catName} flipped through this week's records — yep, you're glowing~",
  'Another week gone by. {catName} walked through every day with you~',
  '{lightCount} lights, {weekCount} reviews — all your treasures 💎',
  'Hard work this week! {catName} gives you a shoulder rub~',
];

// ── worryResolved (EN) ──

const _worryResolvedEn = [
  'You solved a worry! {catName} is happy for you 🎉',
  "See? You're stronger than you think~",
  'Another one down! {catName} bounces around~',
  'Worry defeated! {catName} claps its paws 👏',
  "One by one — you're handling them so well~",
  '{catName} knew you could do it!',
  'You, solving worries — absolutely radiant ✨',
  'One less worry, one more breath of relief~',
  'Done! {catName} swishes its tail in celebration~',
  "{catName} remembers — you're someone who solves things~",
  "That worry won't bother you anymore~",
  'A little lighter now. Feels good, right?',
];

// ── worryDisappeared (EN) ──

const _worryDisappearedEn = [
  'The worry disappeared on its own. Sometimes it goes that way~',
  'Not all worries need solving. Some just leave 🍃',
  '{catName} watched this worry walk away~',
  'Gone is gone — no need to figure out why~',
  'Some things, time takes care of~',
  "Worry's gone. {catName} breathes a sigh of relief~",
  'See? Nothing stays the same forever~',
  'Let the vanished worry go. Travel light 🌿',
  '{catName} waves a paw — bye bye, little worry~',
  'Sometimes doing nothing still makes things better~',
  'A worry quietly left. The world feels lighter~',
  'Not every worry needs an answer. Disappearing is fine too~',
];

// ── monthlyStart (EN) ──

const _monthlyStartEn = [
  'New month! {catName} sets off with you 🌱',
  '{habitName} for {targetDays} days — {catName} cheers you on!',
  'Goal set! {catName} is keeping track~',
  "New month, fresh start. {catName}'s tail is already up~",
  '{targetDays}-day promise. {catName} will be here the whole time ✨',
  'No need to be perfect. Take it slow. {catName} is patient~',
  "{habitName} — sounds great! {catName} can't wait~",
  'First-of-month determination shines brightest. {catName} guards it 🌟',
  'Step by step. {catName} cheers from the sideline~',
  '{catName} stretches, ready to spend this month with you~',
  'New month, new adventure. {catName} is ready!',
  "The goal isn't perfection — it's trying every day 🍀",
];

// ── monthlyProgress (EN) ──

const _monthlyProgressEn = [
  '{completedDays} days so far. {catName} sees every one ✨',
  "{completedDays}/{targetDays} — you're glowing~",
  'Every day of effort, {catName} remembers~',
  'Take it easy. {completedDays} days is already amazing!',
  "{catName} peeked at the progress — yep, you're working hard~",
  "Keep it up! {catName}'s tail wags for you 💪",
  '{completedDays} days! {catName} is proud~',
  'Day by day, it all adds up to something great~',
  "Not perfect? That's fine. {completedDays} days all count 🌿",
  '{catName} gives you a little paw bump — keep going~',
  "Progress doesn't matter. What matters is you're still here ✨",
  "You've come so far. {catName} walks on with you~",
];

// ── monthlyComplete (EN) ──

const _monthlyCompleteEn = [
  'Monthly challenge complete!! {catName} celebrates wildly! 🎉🎉',
  'You did it! {catName} is so proud its tail is all puffed up~',
  '{targetDays} days — you actually did it! Amazing ✨',
  '{catName} awards you Best Human of the Month! 🏆',
  'Done! You were absolutely glowing this month~',
  'You finished it! {catName} admires you the most~',
  'Congratulations! {catName} does a celebration flip~',
  '{habitName} challenge achieved! {catName} throws confetti 🌸',
  'This whole month of effort was worth it. {catName} saw it all~',
  'You did it! Ready to claim your reward? 😸',
  '{catName} bounces around — this is your moment of glory!',
  'A month-long promise kept. By you, and by {catName} 💛',
];

// ── gentleReturn (EN) ──

const _gentleReturnEn = [
  "You're back! {catName} is so happy 💛",
  '{catName} was right here waiting. Welcome back~',
  'Long time no see! {catName} nuzzles your feet~',
  "Coming back is all that matters. It's never too late 🌱",
  '{catName} yawns big, then looks at you with joy~',
  "No matter how long it's been, {catName} is here~",
  'Welcome back! {catName} saved you the warmest spot~',
  "You're here. {catName}'s world just lit up ✨",
  "There's no such thing as 'too late.' Now is perfect~",
  '{catName} pretends not to care, but its tail is already wagging~',
  "You're back! No explanation needed. {catName} understands~",
  'Every return is a new beginning. {catName} is with you 🍀',
  'While you were away, {catName} just waited quietly~',
];

// ═══════════════════════════════════════════════════════════════════
// 模板注册表
// ═══════════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════════
// 成长洞察模板（GrowthInsightCard 专用，非 CatResponseScene）
// ═══════════════════════════════════════════════════════════════════

/// 中文洞察模板。
const insightTemplatesZh = [
  '你的幸福 {topTagPercent}% 和 #{topTag} 有关 🌿',
  '最近让你开心的事，{topTagPercent}% 都和 #{topTag} 有关呢~',
  '#{topTag} 似乎是你的快乐源泉，占了 {topTagPercent}% ✨',
  '{catName}发现了一个秘密：#{topTag} 让你最开心~',
  '你知道吗？你的光 {topTagPercent}% 都和 #{topTag} 有关 🌟',
];

/// 英文洞察模板。
const insightTemplatesEn = [
  '{topTagPercent}% of your happiness is linked to #{topTag} 🌿',
  'Lately, {topTagPercent}% of your joy involves #{topTag}~',
  '#{topTag} seems to be your happiness source — {topTagPercent}% ✨',
  '{catName} discovered a secret: #{topTag} makes you happiest~',
  'Did you know? {topTagPercent}% of your lights involve #{topTag} 🌟',
];

/// 获取随机洞察文案。
String getRandomInsight({
  required String topTag,
  required int topTagPercent,
  required String catName,
  String locale = 'zh',
}) {
  final pool = locale == 'en' ? insightTemplatesEn : insightTemplatesZh;
  final template = pool[Random().nextInt(pool.length)];
  return _replacePlaceholders(template, {
    'topTag': topTag,
    'topTagPercent': topTagPercent.toString(),
    'catName': catName,
  });
}
