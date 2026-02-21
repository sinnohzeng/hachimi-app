import 'package:cloud_firestore/cloud_firestore.dart';

/// Focus session model — maps to Firestore `users/{uid}/habits/{habitId}/sessions/{sessionId}`.
/// Records each focus session with duration, rewards, and completion status.
///
/// 会话记录一旦创建即不可修改（审计日志）。
class FocusSession {
  final String id;
  final String habitId;
  final String catId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMinutes; // 实际专注分钟数
  final int targetDurationMinutes; // 计划时长（倒计时目标；正计时为 0）
  final int pausedSeconds; // 累计暂停秒数
  final String status; // 'completed' / 'abandoned' / 'interrupted'
  final double completionRatio; // actual / target（正计时为 1.0）
  final int xpEarned;
  final int coinsEarned; // durationMinutes × 10
  final String mode; // 'countdown' / 'stopwatch'
  final String? checksum; // HMAC-SHA256 签名
  final String clientVersion; // 客户端版本号

  const FocusSession({
    required this.id,
    required this.habitId,
    required this.catId,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    this.targetDurationMinutes = 0,
    this.pausedSeconds = 0,
    required this.status,
    this.completionRatio = 1.0,
    required this.xpEarned,
    this.coinsEarned = 0,
    required this.mode,
    this.checksum,
    this.clientVersion = '',
  });

  /// 会话是否正常完成。
  bool get isCompleted => status == 'completed';

  /// 会话是否被放弃。
  bool get isAbandoned => status == 'abandoned';

  factory FocusSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FocusSession(
      id: doc.id,
      habitId: data['habitId'] as String? ?? '',
      catId: data['catId'] as String? ?? '',
      startedAt:
          (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMinutes: data['durationMinutes'] as int? ?? 0,
      targetDurationMinutes: data['targetDurationMinutes'] as int? ?? 0,
      pausedSeconds: data['pausedSeconds'] as int? ?? 0,
      status: data['status'] as String? ?? 'completed',
      completionRatio: (data['completionRatio'] as num?)?.toDouble() ?? 1.0,
      xpEarned: data['xpEarned'] as int? ?? 0,
      coinsEarned: data['coinsEarned'] as int? ?? 0,
      mode: data['mode'] as String? ?? 'countdown',
      checksum: data['checksum'] as String?,
      clientVersion: data['clientVersion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'catId': catId,
      'startedAt': Timestamp.fromDate(startedAt),
      'endedAt': Timestamp.fromDate(endedAt),
      'durationMinutes': durationMinutes,
      'targetDurationMinutes': targetDurationMinutes,
      'pausedSeconds': pausedSeconds,
      'status': status,
      'completionRatio': completionRatio,
      'xpEarned': xpEarned,
      'coinsEarned': coinsEarned,
      'mode': mode,
      if (checksum != null) 'checksum': checksum,
      'clientVersion': clientVersion,
    };
  }
}
