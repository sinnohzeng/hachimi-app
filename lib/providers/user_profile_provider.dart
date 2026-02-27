import 'dart:convert';

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

/// 监听当前用户佩戴的称号 ID。
///
/// SSOT: 本地 materialized_state（SQLite）。
final currentTitleProvider = StreamProvider<String?>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield null;
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  yield await ledger.getMaterialized(uid, 'current_title');

  await for (final change in ledger.changes) {
    if (change.type == 'profile_update' || change.type == 'hydrate') {
      yield await ledger.getMaterialized(uid, 'current_title');
    }
  }
});

/// 监听当前用户已解锁的称号 ID 列表。
///
/// SSOT: 本地 materialized_state（SQLite）。
final unlockedTitlesProvider = StreamProvider<List<String>>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield [];
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);
  yield _decodeTitles(await ledger.getMaterialized(uid, 'unlocked_titles'));

  await for (final change in ledger.changes) {
    if (change.type == 'profile_update' ||
        change.type == 'hydrate' ||
        change.type == 'achievement_unlocked') {
      yield _decodeTitles(await ledger.getMaterialized(uid, 'unlocked_titles'));
    }
  }
});

List<String> _decodeTitles(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw);
  if (decoded is List) return decoded.cast<String>();
  return [];
}
