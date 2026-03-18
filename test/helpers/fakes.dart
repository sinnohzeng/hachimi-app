// ---
// 共享 Fake 实现 — 提取自各测试文件中重复的 Fake 模式。
// 遵循项目规范：手写 Fakes + noSuchMethod 兜底，无 Mockito。
// ---

import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 记录方法调用的 LedgerService fake。
///
/// 实现 notifyChange / changes 用于验证变更广播。
/// 其他方法由 noSuchMethod 兜底。
class FakeLedgerService implements LedgerService {
  final List<String> callLog = [];
  final List<LedgerChange> notifiedChanges = [];
  bool migrateUidCalled = false;
  String? migrateOldUid;
  String? migrateNewUid;

  @override
  Future<void> migrateUid(String oldUid, String newUid) async {
    callLog.add('migrateUid');
    migrateUidCalled = true;
    migrateOldUid = oldUid;
    migrateNewUid = newUid;
  }

  @override
  Future<void> deleteUidData(String uid) async {
    callLog.add('deleteUidData');
  }

  @override
  void notifyChange(LedgerChange change) {
    callLog.add('notifyChange');
    notifiedChanges.add(change);
  }

  @override
  Stream<LedgerChange> get changes => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// 无操作 AnalyticsService fake — 记录事件名称用于验证。
class FakeAnalyticsService implements AnalyticsService {
  final List<String> events = [];

  @override
  Future<void> logFocusSessionCompleted({
    required String habitId,
    required int actualMinutes,
    required int xpEarned,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) async {
    events.add('focus_completed:$habitId:${actualMinutes}min');
  }

  @override
  Future<void> logFocusSessionAbandoned({
    required String habitId,
    required int minutesCompleted,
    required String reason,
    int? targetDurationMinutes,
    int? pausedSeconds,
    double? completionRatio,
  }) async {
    events.add('focus_abandoned:$habitId:${minutesCompleted}min');
  }

  @override
  Future<void> logCoinsEarned({
    required int amount,
    required String source,
  }) async {
    events.add('coins_earned:$amount:$source');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
