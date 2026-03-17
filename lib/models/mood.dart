/// 心情等级 — 5 级量表。
///
/// 存储在 SQLite 中使用 [value]（整型），UI 层使用 [emoji] 展示。
/// 覆盖从积极到消极的完整情绪光谱。
enum Mood {
  veryHappy(0, '😄'),
  happy(1, '🙂'),
  calm(2, '😌'),
  down(3, '😔'),
  veryDown(4, '😢');

  const Mood(this.value, this.emoji);

  /// SQLite 存储值。
  final int value;

  /// UI 展示用 emoji。
  final String emoji;

  /// 从整型值反序列化。无效值抛出 [ArgumentError]。
  static Mood fromValue(int value) {
    return Mood.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown Mood value: $value'),
    );
  }
}
