import 'dart:math';
import 'dart:ui';

/// 激励语库 — 每种语言 20+ 条，覆盖 en / zh / zh-Hant / ja / ko。
/// 遵循 achievement_strings.dart 的静态 Map 模式，游戏内容 i18n 独立于 ARB。
const Map<String, List<String>> _quotes = {
  'en': [
    'Small steps lead to big changes.',
    'Every minute counts.',
    'Progress, not perfection.',
    'You are stronger than you think.',
    'One day at a time.',
    'The secret of getting ahead is getting started.',
    'Discipline is choosing what you want most.',
    'Focus on the journey, not the destination.',
    'Believe you can and you are halfway there.',
    'A little progress each day adds up.',
    'Your future self will thank you.',
    'Start where you are, use what you have.',
    'Consistency beats intensity.',
    'The best time to start is now.',
    'Great things take time.',
    'Keep going, you are doing great.',
    'Build habits, build a life.',
    'Success is the sum of small efforts.',
    'Make today count.',
    'Stay focused, stay determined.',
    'Do it for the cat!',
    'Be patient with yourself.',
    'Dream big, start small, act now.',
  ],
  'zh': [
    '日月逝矣，时不我待。',
    '千里之行，始于足下。',
    '积少成多，聚沙成塔。',
    '坚持就是胜利。',
    '今日事，今日毕。',
    '不积跬步，无以至千里。',
    '每一分钟都有意义。',
    '做更好的自己。',
    '星星之火，可以燎原。',
    '天道酬勤。',
    '进步比完美更重要。',
    '滴水穿石，非一日之功。',
    '自律即自由。',
    '你比想象中更强大。',
    '好习惯成就好人生。',
    '今天也要加油呀！',
    '慢慢来，比较快。',
    '专注当下，不负时光。',
    '成功是每个小努力的总和。',
    '相信过程，静待花开。',
    '为了猫猫，冲！',
    '一步一个脚印。',
    '耐心是最好的捷径。',
  ],
  'zh-Hant': [
    '日月逝矣，時不我待。',
    '千里之行，始於足下。',
    '積少成多，聚沙成塔。',
    '堅持就是勝利。',
    '今日事，今日畢。',
    '不積跬步，無以至千里。',
    '每一分鐘都有意義。',
    '做更好的自己。',
    '星星之火，可以燎原。',
    '天道酬勤。',
    '進步比完美更重要。',
    '滴水穿石，非一日之功。',
    '自律即自由。',
    '你比想像中更強大。',
    '好習慣成就好人生。',
    '今天也要加油呀！',
    '慢慢來，比較快。',
    '專注當下，不負時光。',
    '成功是每個小努力的總和。',
    '相信過程，靜待花開。',
    '為了貓貓，衝！',
    '一步一個腳印。',
    '耐心是最好的捷徑。',
  ],
  'ja': [
    '千里の道も一歩から。',
    '継続は力なり。',
    '今日も一歩前へ。',
    '小さな積み重ねが大きな成果に。',
    '自分を信じて。',
    '一日一日を大切に。',
    '努力は裏切らない。',
    '焦らず、一歩ずつ。',
    '今できることに集中しよう。',
    '昨日より今日の自分。',
    '完璧より前進を。',
    '習慣が人生を変える。',
    '自分のペースでいい。',
    '未来の自分が感謝する。',
    '今日が最高の始まり。',
    '夢は大きく、始まりは小さく。',
    '集中力が未来を作る。',
    '毎分が大切な時間。',
    '諦めなければ、負けない。',
    'にゃんこのために頑張ろう！',
    '一歩一歩、確実に。',
    '変化は小さな行動から。',
    '今この瞬間を楽しもう。',
  ],
  'ko': [
    '천리 길도 한 걸음부터.',
    '꾸준함이 최고의 능력이다.',
    '오늘도 한 걸음 더.',
    '작은 노력이 큰 변화를 만든다.',
    '나를 믿자.',
    '하루하루가 소중하다.',
    '노력은 배신하지 않는다.',
    '조급해하지 말고 한 걸음씩.',
    '지금 할 수 있는 것에 집중하자.',
    '어제보다 나은 오늘.',
    '완벽보다 성장이 중요하다.',
    '습관이 인생을 바꾼다.',
    '나만의 속도로 괜찮아.',
    '미래의 내가 고마워할 거야.',
    '오늘이 최고의 시작이다.',
    '크게 꿈꾸고 작게 시작하자.',
    '집중이 미래를 만든다.',
    '매 순간이 소중한 시간.',
    '포기하지 않으면 진 게 아니다.',
    '고양이를 위해 파이팅!',
    '한 걸음 한 걸음 확실하게.',
    '변화는 작은 행동에서 시작된다.',
    '지금 이 순간을 즐기자.',
  ],
};

/// 根据 locale 获取激励语列表，fallback 到英文。
List<String> _quotesForLocale(Locale locale) {
  // 优先匹配 languageCode-scriptCode（如 zh-Hant）
  if (locale.scriptCode != null) {
    final key = '${locale.languageCode}-${locale.scriptCode}';
    if (_quotes.containsKey(key)) return _quotes[key]!;
  }
  return _quotes[locale.languageCode] ?? _quotes['en']!;
}

final _random = Random();

/// 随机获取一条激励语，避免连续重复。
String randomMotivationQuote(Locale locale, {String? exclude}) {
  final pool = _quotesForLocale(locale);
  final filtered = exclude != null
      ? pool.where((q) => q != exclude).toList()
      : pool;
  return filtered[_random.nextInt(filtered.length)];
}
