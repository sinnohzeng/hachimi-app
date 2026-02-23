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
      startedAt: (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
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

  /// SQLite 序列化 — 对应 local_sessions 表。
  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'habit_id': habitId,
      'cat_id': catId,
      'started_at': startedAt.millisecondsSinceEpoch,
      'ended_at': endedAt.millisecondsSinceEpoch,
      'duration_minutes': durationMinutes,
      'target_duration_minutes': targetDurationMinutes,
      'paused_seconds': pausedSeconds,
      'status': status,
      'completion_ratio': completionRatio,
      'xp_earned': xpEarned,
      'coins_earned': coinsEarned,
      'mode': mode,
      'checksum': checksum,
      'client_version': clientVersion,
    };
  }

  /// 从 SQLite 行反序列化。
  factory FocusSession.fromSqlite(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'] as String,
      habitId: map['habit_id'] as String? ?? '',
      catId: map['cat_id'] as String? ?? '',
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int),
      endedAt: DateTime.fromMillisecondsSinceEpoch(map['ended_at'] as int),
      durationMinutes: map['duration_minutes'] as int? ?? 0,
      targetDurationMinutes: map['target_duration_minutes'] as int? ?? 0,
      pausedSeconds: map['paused_seconds'] as int? ?? 0,
      status: map['status'] as String? ?? 'completed',
      completionRatio: (map['completion_ratio'] as num?)?.toDouble() ?? 1.0,
      xpEarned: map['xp_earned'] as int? ?? 0,
      coinsEarned: map['coins_earned'] as int? ?? 0,
      mode: map['mode'] as String? ?? 'countdown',
      checksum: map['checksum'] as String?,
      clientVersion: map['client_version'] as String? ?? '',
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
