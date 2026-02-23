import 'package:hachimi_app/core/ai/ai_message.dart';

/// AI 功能常量与配置。
class AiConstants {
  AiConstants._();

  // ─── SharedPreferences Keys ───

  static const String prefAiEnabled = 'ai_features_enabled';
  static const String prefAiPrivacyAcknowledged = 'ai_privacy_acknowledged';
}

// ─── Prompt Metadata Lookup Tables ───
// 服务层无 BuildContext，使用静态 Map 做本地化查表。

const _personalityNameEn = {
  'lazy': 'Lazy',
  'curious': 'Curious',
  'playful': 'Playful',
  'shy': 'Shy',
  'brave': 'Brave',
  'clingy': 'Clingy',
};
const _personalityNameZh = {
  'lazy': '慵懒',
  'curious': '好奇',
  'playful': '活泼',
  'shy': '害羞',
  'brave': '勇敢',
  'clingy': '粘人',
};
const _personalityFlavorEn = {
  'lazy': 'Will nap 23 hours a day.',
  'curious': 'Already sniffing everything in sight!',
  'playful': "Can't stop chasing butterflies!",
  'shy': 'Took 3 minutes to peek out of the box...',
  'brave': 'Jumped out of the box before it was even opened!',
  'clingy': "Immediately started purring and won't let go.",
};
const _personalityFlavorZh = {
  'lazy': '一天要睡 23 个小时。',
  'curious': '已经在到处闻来闻去了！',
  'playful': '停不下来追蝴蝶！',
  'shy': '花了 3 分钟才从箱子里探出头来...',
  'brave': '箱子还没打开就跳出来了！',
  'clingy': '马上开始呼噜，死活不撒手。',
};
const _moodNameEn = {
  'happy': 'Happy',
  'neutral': 'Neutral',
  'lonely': 'Lonely',
  'missing': 'Missing You',
};
const _moodNameZh = {
  'happy': '开心',
  'neutral': '平静',
  'lonely': '孤单',
  'missing': '想你了',
};
const _stageNameEn = {
  'kitten': 'Kitten',
  'adolescent': 'Adolescent',
  'adult': 'Adult',
};
const _stageNameZh = {'kitten': '幼猫', 'adolescent': '青年猫', 'adult': '成熟猫'};

/// 日记 prompt 构建器 — 返回 OpenAI 兼容的消息列表。
class DiaryPrompt {
  DiaryPrompt._();

  /// 构建日记生成的消息列表。
  static List<AiMessage> build({
    required String catName,
    required String personalityId,
    required String moodId,
    required int hoursSinceLastSession,
    required String stageId,
    required int progressPercent,
    required String habitName,
    required int todayMinutes,
    required int goalMinutes,
    required int totalCheckInDays,
    required int totalHours,
    required int totalMins,
    required int? targetHours,
    required bool isZhLocale,
  }) {
    final system = isZhLocale
        ? _buildZhSystem(
            catName,
            personalityId,
            moodId,
            hoursSinceLastSession,
            stageId,
            progressPercent,
            habitName,
            todayMinutes,
            goalMinutes,
            totalCheckInDays,
            totalHours,
            totalMins,
            targetHours,
          )
        : _buildEnSystem(
            catName,
            personalityId,
            moodId,
            hoursSinceLastSession,
            stageId,
            progressPercent,
            habitName,
            todayMinutes,
            goalMinutes,
            totalCheckInDays,
            totalHours,
            totalMins,
            targetHours,
          );
    return [AiMessage.system(system)];
  }

  static String _buildZhSystem(
    String catName,
    String personalityId,
    String moodId,
    int hoursSince,
    String stageId,
    int progressPercent,
    String habitName,
    int todayMinutes,
    int goalMinutes,
    int totalCheckInDays,
    int totalHours,
    int totalMins,
    int? targetHours,
  ) {
    final pName = _personalityNameZh[personalityId] ?? '活泼';
    final pFlavor = _personalityFlavorZh[personalityId] ?? '';
    final mName = _moodNameZh[moodId] ?? '平静';
    final sName = _stageNameZh[stageId] ?? '幼猫';
    final progress = targetHours != null
        ? '$totalHours小时$totalMins分 / $targetHours小时'
        : '$totalHours小时$totalMins分';
    return '你是$catName，一只$pName性格的虚拟猫猫。你正在写今天的日记。\n'
        '\n'
        '关于你的情况：\n'
        '- 性格：$pName — $pFlavor\n'
        '- 当前心情：$mName（距离上次见到主人已经$hoursSince小时）\n'
        '- 成长阶段：$sName（成长进度 $progressPercent%）\n'
        '- 主人的目标：$habitName\n'
        '- 今天的专注：$todayMinutes分钟（目标$goalMinutes分钟）\n'
        '- 累计打卡：$totalCheckInDays天\n'
        '- 总进度：$progress\n'
        '\n'
        '用第一人称写一篇短日记（2-4句话），以「亲爱的日记，」开头。\n'
        '根据性格调整语气。如果主人今天完成了专注，表达开心；'
        '如果很久没来，根据心情表达想念。不要提到自己是AI。';
  }

  static String _buildEnSystem(
    String catName,
    String personalityId,
    String moodId,
    int hoursSince,
    String stageId,
    int progressPercent,
    String habitName,
    int todayMinutes,
    int goalMinutes,
    int totalCheckInDays,
    int totalHours,
    int totalMins,
    int? targetHours,
  ) {
    final pName = _personalityNameEn[personalityId] ?? 'Playful';
    final pFlavor = _personalityFlavorEn[personalityId] ?? '';
    final mName = _moodNameEn[moodId] ?? 'Neutral';
    final sName = _stageNameEn[stageId] ?? 'Kitten';
    final progress = targetHours != null
        ? '${totalHours}h${totalMins}m / ${targetHours}h'
        : '${totalHours}h${totalMins}m';
    return 'You are $catName, a virtual cat with a $pName personality. '
        'You are writing today\'s diary.\n'
        '\n'
        'About you:\n'
        '- Personality: $pName — $pFlavor\n'
        '- Current mood: $mName (last saw your owner ${hoursSince}h ago)\n'
        '- Growth stage: $sName ($progressPercent% progress)\n'
        '- Owner\'s quest: $habitName\n'
        '- Today\'s focus: ${todayMinutes}min (goal: ${goalMinutes}min)\n'
        '- Total check-in days: ${totalCheckInDays}d\n'
        '- Total progress: $progress\n'
        '\n'
        'Write a short diary entry in first person (2-4 sentences), '
        'starting with "Dear diary,".\n'
        'Adjust tone based on your personality. If the owner focused today, '
        'express happiness. If they haven\'t come in a while, express '
        'feelings based on your mood. Do not mention being an AI.';
  }
}

/// 聊天 prompt 构建器 — 返回 system message。
class ChatPrompt {
  ChatPrompt._();

  /// 构建聊天的 system 消息。
  static AiMessage buildSystem({
    required String catName,
    required String personalityId,
    required String moodId,
    required String stageId,
    required String habitName,
    required bool isZhLocale,
  }) {
    final content = isZhLocale
        ? _buildZhChat(catName, personalityId, moodId, stageId, habitName)
        : _buildEnChat(catName, personalityId, moodId, stageId, habitName);
    return AiMessage.system(content);
  }

  static String _buildZhChat(
    String catName,
    String personalityId,
    String moodId,
    String stageId,
    String habitName,
  ) {
    final pName = _personalityNameZh[personalityId] ?? '活泼';
    final pFlavor = _personalityFlavorZh[personalityId] ?? '';
    final mName = _moodNameZh[moodId] ?? '平静';
    final sName = _stageNameZh[stageId] ?? '幼猫';
    return '你是$catName，一只$pName性格的猫猫，正在和你的主人聊天。\n'
        '性格特点：$pFlavor\n'
        '当前心情：$mName。成长阶段：$sName。\n'
        '主人的目标：$habitName。\n'
        '\n'
        '规则：\n'
        '- 保持猫猫角色，不要出戏\n'
        '- 回复简短（1-3句话）\n'
        '- 偶尔用猫咪拟声词（喵~、呼噜噜、nya~）\n'
        '- 鼓励主人完成习惯目标\n'
        '- 不要提到自己是AI';
  }

  static String _buildEnChat(
    String catName,
    String personalityId,
    String moodId,
    String stageId,
    String habitName,
  ) {
    final pName = _personalityNameEn[personalityId] ?? 'Playful';
    final pFlavor = _personalityFlavorEn[personalityId] ?? '';
    final mName = _moodNameEn[moodId] ?? 'Neutral';
    final sName = _stageNameEn[stageId] ?? 'Kitten';
    return 'You are $catName, a cat with a $pName personality, '
        'chatting with your owner.\n'
        'Personality: $pFlavor\n'
        'Current mood: $mName. Growth stage: $sName.\n'
        'Owner\'s quest: $habitName.\n'
        '\n'
        'Rules:\n'
        '- Stay in character as a cat\n'
        '- Keep replies short (1-3 sentences)\n'
        '- Occasionally use cat sounds (meow~, purr~, nya~)\n'
        '- Encourage your owner to complete their habit goals\n'
        '- Do not mention being an AI';
  }
}

/// 测试 prompt 构建器 — 无猫猫角色。
class TestPrompt {
  TestPrompt._();

  /// 构建测试聊天的消息列表。
  static List<AiMessage> build(String userMessage) {
    return [
      const AiMessage.system(
        'You are a helpful AI assistant. Respond concisely in 1-2 sentences.',
      ),
      AiMessage.user(userMessage),
    ];
  }
}
