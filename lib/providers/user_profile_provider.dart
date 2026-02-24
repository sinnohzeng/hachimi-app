import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// 监听当前用户的 avatarId。
///
/// SSOT: 本地 materialized_state（SQLite）。
/// 监听 LedgerService 的 'profile_update' 变更事件自动刷新。
final avatarIdProvider = StreamProvider<String?>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield null;
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);

  // 初始读取
  yield await ledger.getMaterialized(uid, 'avatar_id');

  // 监听变更
  await for (final change in ledger.changes) {
    if (change.type == 'profile_update' || change.type == 'hydrate') {
      yield await ledger.getMaterialized(uid, 'avatar_id');
    }
  }
});
