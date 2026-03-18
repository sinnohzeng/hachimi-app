import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/json_helpers.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';
import 'package:hachimi_app/services/ledger_service.dart';

/// 实时道具箱内容（未装备的配饰 ID 列表）— 从 SQLite materialized_state 读取。
final inventoryProvider = StreamProvider<List<String>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const <String>[]);

  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: (c) =>
        c.isGlobalRefresh ||
        c.type == ActionType.purchase ||
        c.type == ActionType.equip ||
        c.type == ActionType.unequip,
    read: () => _readInventory(ledger, uid),
  );
});

Future<List<String>> _readInventory(LedgerService ledger, String uid) async {
  final raw = await ledger.getMaterialized(uid, 'inventory');
  return decodeJsonStringList(raw);
}
