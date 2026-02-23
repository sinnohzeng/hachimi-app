import 'dart:math';

/// 生成 10 字符短 ID（用于访客身份展示）。
/// 格式：大写字母 + 数字，如 HKXM47NB2R。
String generateGuestShortId() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // 去掉易混淆字符 I/O/0/1
  final rng = Random.secure();
  return String.fromCharCodes(
    Iterable.generate(10, (_) => chars.codeUnitAt(rng.nextInt(chars.length))),
  );
}
