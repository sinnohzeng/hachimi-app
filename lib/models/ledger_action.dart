import 'dart:convert';

/// 行为台账 — 行为类型枚举。
/// 每个用户操作都映射到一个 ActionType，写入 action_ledger 表。
enum ActionType {
  checkIn('check_in'),
  focusComplete('focus_complete'),
  focusAbandon('focus_abandon'),
  purchase('purchase'),
  equip('equip'),
  unequip('unequip'),
  habitCreate('habit_create'),
  habitUpdate('habit_update'),
  habitDelete('habit_delete'),
  accountCreated('account_created'),
  accountLinked('account_linked'),
  achievementUnlocked('achievement_unlocked'),
  achievementClaimed('achievement_claimed'),
  profileUpdate('profile_update');

  const ActionType(this.value);
  final String value;

  static ActionType fromValue(String value) {
    return ActionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown ActionType: $value'),
    );
  }
}

/// 行为台账记录 — 不可变事件日志。
/// 每条记录包含完整的时间线、输入（payload）和产出（result）。
class LedgerAction {
  final String id;
  final ActionType type;
  final String uid;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> result;
  final int synced; // 0=待同步 1=已同步 2=永久失败
  final DateTime? syncedAt;
  final int syncAttempts;
  final String? syncError;
  final DateTime createdAt;

  const LedgerAction({
    required this.id,
    required this.type,
    required this.uid,
    required this.startedAt,
    this.endedAt,
    this.payload = const {},
    this.result = const {},
    this.synced = 0,
    this.syncedAt,
    this.syncAttempts = 0,
    this.syncError,
    required this.createdAt,
  });

  Map<String, dynamic> toSqlite() {
    return {
      'id': id,
      'type': type.value,
      'uid': uid,
      'started_at': startedAt.millisecondsSinceEpoch,
      'ended_at': endedAt?.millisecondsSinceEpoch,
      'payload': jsonEncode(payload),
      'result': jsonEncode(result),
      'synced': synced,
      'synced_at': syncedAt?.millisecondsSinceEpoch,
      'sync_attempts': syncAttempts,
      'sync_error': syncError,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory LedgerAction.fromSqlite(Map<String, dynamic> map) {
    return LedgerAction(
      id: map['id'] as String,
      type: ActionType.fromValue(map['type'] as String),
      uid: map['uid'] as String,
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at'] as int),
      endedAt: map['ended_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ended_at'] as int)
          : null,
      payload: _decodeJson(map['payload']),
      result: _decodeJson(map['result']),
      synced: map['synced'] as int? ?? 0,
      syncedAt: map['synced_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['synced_at'] as int)
          : null,
      syncAttempts: map['sync_attempts'] as int? ?? 0,
      syncError: map['sync_error'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  static Map<String, dynamic> _decodeJson(dynamic raw) {
    if (raw is String) {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : {};
    }
    return {};
  }
}

/// 台账变更事件 — LedgerService 广播用。
class LedgerChange {
  final String type;
  final List<String> affectedIds;

  const LedgerChange({required this.type, this.affectedIds = const []});
}
