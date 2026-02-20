// ---
// 📘 文件说明：
// LLM 常量 — 模型下载地址、SHA-256 校验、prompt 模板、推理参数。
// 所有 AI 功能的配置集中管理于此。
//
// 🧩 文件结构：
// - LlmConstants：静态常量类；
// - DiaryPrompt：日记 prompt 构建器；
// - ChatPrompt：聊天 prompt 构建器；
//
// 🕒 创建时间：2026-02-19
// ---

/// LLM 模型与推理配置常量。
class LlmConstants {
  LlmConstants._();

  // ─── Model Metadata ───

  /// 模型版本标识（用于本地版本比对与升级检测）
  static const String modelVersion = 'qwen3-1.7b-q4km-v1';

  /// 模型显示名称
  static const String modelDisplayName = 'Qwen3-1.7B';

  /// GGUF 文件名
  static const String modelFileName = 'Qwen3-1.7B-Q4_K_M.gguf';

  /// 模型下载 URL（unsloth 社区量化，包含完整 Q4_K_M 版本）
  static const String modelDownloadUrl =
      'https://huggingface.co/unsloth/Qwen3-1.7B-GGUF/resolve/main/Qwen3-1.7B-Q4_K_M.gguf';

  /// 模型文件大小（字节），用于预检磁盘空间
  static const int modelFileSizeBytes = 1107409472; // ~1.03 GB

  /// 下载前要求的最小可用空间（模型 + 300 MB 缓冲）
  static const int minFreeSpaceBytes = 1420000000; // ~1.32 GB

  /// SHA-256 校验值。空字符串表示跳过校验（模型文件未固定版本时适用）。
  static const String modelSha256 = '';

  // ─── Inference Parameters ───

  /// 上下文窗口大小（tokens）
  static const int contextSize = 2048;

  /// 日记生成最大 token 数
  static const int diaryMaxTokens = 200;

  /// 聊天回复最大 token 数
  static const int chatMaxTokens = 150;

  /// 采样温度（创意性）
  static const double temperature = 0.7;

  /// Top-p 采样
  static const double topP = 0.9;

  /// 重复惩罚
  static const double repeatPenalty = 1.1;

  // ─── SharedPreferences Keys ───

  static const String prefAiEnabled = 'ai_features_enabled';
  static const String prefModelDownloaded = 'ai_model_downloaded';
  static const String prefModelFilePath = 'ai_model_file_path';
  static const String prefModelVersion = 'ai_model_version';
}

// ─── Prompt Metadata Lookup Tables ───
// LLM prompts use hardcoded EN/ZH lookup tables instead of the UI's ARB system,
// because prompts are a technical concern (not UI l10n) and services lack BuildContext.

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
  'senior': 'Senior',
};
const _stageNameZh = {
  'kitten': '幼猫',
  'adolescent': '少年猫',
  'adult': '成年猫',
  'senior': '长老猫',
};

/// 日记 prompt 构建器。
class DiaryPrompt {
  DiaryPrompt._();

  /// 构建日记生成的完整 prompt。参数使用 ID，内部查表获取本地化文案。
  static String build({
    required String catName,
    required String personalityId,
    required String moodId,
    required int hoursSinceLastSession,
    required String stageId,
    required int progressPercent,
    required String habitName,
    required int todayMinutes,
    required int goalMinutes,
    required int currentStreak,
    required int totalHours,
    required int totalMins,
    required int targetHours,
    required bool isZhLocale,
  }) {
    if (isZhLocale) {
      final pName = _personalityNameZh[personalityId] ?? '活泼';
      final pFlavor = _personalityFlavorZh[personalityId] ?? '';
      final mName = _moodNameZh[moodId] ?? '平静';
      final sName = _stageNameZh[stageId] ?? '幼猫';
      return '<|im_start|>system\n'
          '你是$catName，一只$pName性格的虚拟猫猫。你正在写今天的日记。\n'
          '\n'
          '关于你的情况：\n'
          '- 性格：$pName — $pFlavor\n'
          '- 当前心情：$mName（距离上次见到主人已经$hoursSinceLastSession小时）\n'
          '- 成长阶段：$sName（成长进度 $progressPercent%）\n'
          '- 主人的目标：$habitName\n'
          '- 今天的专注：$todayMinutes分钟（目标$goalMinutes分钟）\n'
          '- 连续打卡：$currentStreak天\n'
          '- 总进度：$totalHours小时$totalMins分 / $targetHours小时\n'
          '\n'
          '用第一人称写一篇短日记（2-4句话）。\n'
          '根据性格调整语气。如果主人今天完成了专注，表达开心；如果很久没来，根据心情表达想念。\n'
          '不要提到自己是AI。\n'
          '<|im_end|>\n'
          '<|im_start|>assistant\n'
          '亲爱的日记，\n\n';
    }
    final pName = _personalityNameEn[personalityId] ?? 'Playful';
    final pFlavor = _personalityFlavorEn[personalityId] ?? '';
    final mName = _moodNameEn[moodId] ?? 'Neutral';
    final sName = _stageNameEn[stageId] ?? 'Kitten';
    return '<|im_start|>system\n'
        'You are $catName, a virtual cat with a $pName personality. You are writing today\'s diary.\n'
        '\n'
        'About you:\n'
        '- Personality: $pName — $pFlavor\n'
        '- Current mood: $mName (last saw your owner ${hoursSinceLastSession}h ago)\n'
        '- Growth stage: $sName ($progressPercent% progress)\n'
        '- Owner\'s quest: $habitName\n'
        '- Today\'s focus: ${todayMinutes}min (goal: ${goalMinutes}min)\n'
        '- Current streak: ${currentStreak}d\n'
        '- Total progress: ${totalHours}h${totalMins}m / ${targetHours}h\n'
        '\n'
        'Write a short diary entry in first person (2-4 sentences).\n'
        'Adjust tone based on your personality. If the owner focused today, express happiness. If they haven\'t come in a while, express feelings based on your mood.\n'
        'Do not mention being an AI.\n'
        '<|im_end|>\n'
        '<|im_start|>assistant\n'
        'Dear diary,\n\n';
  }
}

/// 模型测试 prompt 构建器 — 无猫猫角色，纯验证用途。
class TestPrompt {
  TestPrompt._();

  /// 构建测试聊天的完整 prompt。
  static String buildPrompt(String userMessage) {
    return '<|im_start|>system\n'
        'You are a helpful AI assistant. Respond concisely in 1-2 sentences.\n'
        '<|im_end|>\n'
        '<|im_start|>user\n$userMessage<|im_end|>\n'
        '<|im_start|>assistant\n';
  }
}

/// 聊天 prompt 构建器。
class ChatPrompt {
  ChatPrompt._();

  /// 构建聊天的 system prompt。参数使用 ID，内部查表获取本地化文案。
  static String buildSystem({
    required String catName,
    required String personalityId,
    required String moodId,
    required String stageId,
    required String habitName,
    required bool isZhLocale,
  }) {
    if (isZhLocale) {
      final pName = _personalityNameZh[personalityId] ?? '活泼';
      final pFlavor = _personalityFlavorZh[personalityId] ?? '';
      final mName = _moodNameZh[moodId] ?? '平静';
      final sName = _stageNameZh[stageId] ?? '幼猫';
      return '<|im_start|>system\n'
          '你是$catName，一只$pName性格的猫猫，正在和你的主人聊天。\n'
          '性格特点：$pFlavor\n'
          '当前心情：$mName。成长阶段：$sName。\n'
          '主人的目标：$habitName。\n'
          '\n'
          '规则：\n'
          '- 保持猫猫角色，不要出戏\n'
          '- 回复简短（1-3句话）\n'
          '- 偶尔用猫咪拟声词（喵~、呼噜噜、nya~）\n'
          '- 鼓励主人完成习惯目标\n'
          '- 不要提到自己是AI\n'
          '<|im_end|>\n';
    }
    final pName = _personalityNameEn[personalityId] ?? 'Playful';
    final pFlavor = _personalityFlavorEn[personalityId] ?? '';
    final mName = _moodNameEn[moodId] ?? 'Neutral';
    final sName = _stageNameEn[stageId] ?? 'Kitten';
    return '<|im_start|>system\n'
        'You are $catName, a cat with a $pName personality, chatting with your owner.\n'
        'Personality: $pFlavor\n'
        'Current mood: $mName. Growth stage: $sName.\n'
        'Owner\'s quest: $habitName.\n'
        '\n'
        'Rules:\n'
        '- Stay in character as a cat\n'
        '- Keep replies short (1-3 sentences)\n'
        '- Occasionally use cat sounds (meow~, purr~, nya~)\n'
        '- Encourage your owner to complete their habit goals\n'
        '- Do not mention being an AI\n'
        '<|im_end|>\n';
  }

  /// 格式化用户消息。
  static String formatUserMessage(String content) {
    return '<|im_start|>user\n$content<|im_end|>\n';
  }

  /// 格式化助手消息。
  static String formatAssistantMessage(String content) {
    return '<|im_start|>assistant\n$content<|im_end|>\n';
  }

  /// 格式化助手消息的起始标记（用于流式生成）。
  static String get assistantPrefix => '<|im_start|>assistant\n';
}
