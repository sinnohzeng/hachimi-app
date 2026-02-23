import 'dart:convert';

/// 本地成就记录 — 对应 local_achievements 表。
/// 与 Firestore 版 UnlockedAchievement（achievement.dart）独立，
/// 专为 SQLite 序列化和本地优先架构设计。
class LocalAchievement {
  final String id;
  final String uid;
  final DateTime? unlockedAt;
  final int rewardCoins;
  final bool rewardClaimed;
  final DateTime? rewardClaimedAt;
  final String? titleReward;
  final String? triggerActionId;
  final Map<String, dynamic> context;

  const LocalAchievement({
    required this.id,
    required this.uid,
    this.unlockedAt,
    this.rewardCoins = 0,
    this.rewardClaimed = false,
    this.rewardClaimedAt,
    this.titleReward,
    this.triggerActionId,
    this.context = const {},
  });

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'uid': uid,
      'unlocked_at': unlockedAt?.millisecondsSinceEpoch,
      'reward_coins': rewardCoins,
      'reward_claimed': rewardClaimed ? 1 : 0,
      'reward_claimed_at': rewardClaimedAt?.millisecondsSinceEpoch,
      'title_reward': titleReward,
      'trigger_action_id': triggerActionId,
      'context': jsonEncode(context),
    };
  }

  factory LocalAchievement.fromSqlite(Map<String, dynamic> map) {
    return LocalAchievement(
      id: map['id'] as String,
      uid: map['uid'] as String,
      unlockedAt: map['unlocked_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlocked_at'] as int)
          : null,
      rewardCoins: map['reward_coins'] as int? ?? 0,
      rewardClaimed: (map['reward_claimed'] as int? ?? 0) == 1,
      rewardClaimedAt: map['reward_claimed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reward_claimed_at'] as int)
          : null,
      titleReward: map['title_reward'] as String?,
      triggerActionId: map['trigger_action_id'] as String?,
      context: _decodeContext(map['context']),
    );
  }

  static Map<String, dynamic> _decodeContext(dynamic raw) {
    if (raw is String && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : {};
    }
    return {};
  }
}
