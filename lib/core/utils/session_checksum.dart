import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 会话校验签名 — 使用 HMAC-SHA256 对关键字段进行签名，防止客户端篡改。
///
/// 密钥通过 `--dart-define=SESSION_HMAC_KEY=xxx` 注入。
/// 若未配置密钥，返回 null（开发环境下不强制签名）。
class SessionChecksum {
  SessionChecksum._();

  /// 编译时注入的 HMAC 密钥。
  static const String _key = String.fromEnvironment('SESSION_HMAC_KEY');

  /// 计算会话签名。
  /// 签名内容：`habitId|durationMinutes|coinsEarned|xpEarned|startedAtMs`
  ///
  /// 返回 hex 编码的 HMAC-SHA256 摘要，若密钥未配置则返回 null。
  static String? compute({
    required String habitId,
    required int durationMinutes,
    required int coinsEarned,
    required int xpEarned,
    required DateTime startedAt,
  }) {
    if (_key.isEmpty) return null;

    final payload =
        '$habitId|$durationMinutes|$coinsEarned|$xpEarned|${startedAt.millisecondsSinceEpoch}';
    final hmac = Hmac(sha256, utf8.encode(_key));
    final digest = hmac.convert(utf8.encode(payload));
    return digest.toString();
  }
}
