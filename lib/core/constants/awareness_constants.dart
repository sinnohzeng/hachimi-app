import 'package:hachimi_app/models/mood.dart';

/// 觉知模块常量。
class AwarenessConstants {
  AwarenessConstants._();

  /// 预设情绪标签。
  ///
  /// 注意：标签值直接存储在 SQLite 中作为数据标识符，
  /// 因此不能通过 l10n 翻译（否则会导致已存储数据不匹配）。
  /// 未来国际化需要 tag ID → display name 映射层。
  static const List<String> presetTags = ['家人', '朋友', '学习', '户外', '工作'];

  /// 猫咪睡前反应种子文案（按 Mood 枚举索引）。
  static const Map<Mood, String> seedCatResponses = {
    Mood.veryHappy: '铲屎官今天好开心，本猫也开心！',
    Mood.happy: '记录了今天的光，真棒',
    Mood.calm: '平静的一天也很好呢',
    Mood.down: '不开心的日子，本猫陪着你',
    Mood.veryDown: '没事的，本猫哪都不去',
  };
}
