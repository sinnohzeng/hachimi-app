import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 实时道具箱内容（未装备的配饰 ID 列表）— 从 SQLite materialized_state 读取。
final inventoryProvider = StreamProvider<List<String>>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield const [];
    return;
  }

  final ledger = ref.watch(ledgerServiceProvider);

  yield await _readInventory(ledger, uid);

  await for (final change in ledger.changes) {
    if (change.type == 'purchase' ||
        change.type == 'equip' ||
        change.type == 'unequip') {
      yield await _readInventory(ledger, uid);
    }
  }
});

Future<List<String>> _readInventory(LedgerService ledger, String uid) async {
  final raw = await ledger.getMaterialized(uid, 'inventory');
  if (raw == null) return const [];
  final decoded = jsonDecode(raw);
  if (decoded is List) return decoded.whereType<String>().toList();
  return const [];
}
