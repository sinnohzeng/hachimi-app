import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/ledger_stream.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/pixel_cat_generation_service.dart';

/// Pixel cat generation service — singleton.
final pixelCatGenerationServiceProvider = Provider<PixelCatGenerationService>(
  (ref) => PixelCatGenerationService(),
);

bool _catChangeFilter(LedgerChange c) =>
    c.isGlobalRefresh ||
    c.type.startsWith('habit_') ||
    c.type == 'cat_update' ||
    c.type == 'focus_complete' ||
    c.type == 'equip' ||
    c.type == 'unequip';

/// Active cats — SSOT from local SQLite.
/// 监听 LedgerService 变更事件自动刷新。
final catsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<Cat>[]);

  final catRepo = ref.watch(localCatRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: _catChangeFilter,
    read: () => catRepo.getActiveCats(uid),
  );
});

/// All cats — includes graduated and dormant cats for Cat Album.
final allCatsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(<Cat>[]);

  final catRepo = ref.watch(localCatRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  return ledgerDrivenStream(
    ref: ref,
    ledger: ledger,
    filter: _catChangeFilter,
    read: () => catRepo.getAllCats(uid),
  );
});

/// Cat by habit ID — family provider for quick lookups.
final catByHabitProvider = Provider.family<Cat?, String>((ref, habitId) {
  final cats = ref.watch(catsProvider).value ?? [];
  return cats.where((c) => c.boundHabitId == habitId).firstOrNull;
});

/// Cat by ID — family provider.
final catByIdProvider = Provider.family<Cat?, String>((ref, catId) {
  final cats = ref.watch(allCatsProvider).value ?? [];
  return cats.where((c) => c.id == catId).firstOrNull;
});
