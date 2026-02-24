import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/pixel_cat_generation_service.dart';

/// Pixel cat generation service — singleton.
final pixelCatGenerationServiceProvider = Provider<PixelCatGenerationService>(
  (ref) => PixelCatGenerationService(),
);

/// Active cats — SSOT from local SQLite.
/// 监听 LedgerService 变更事件自动刷新。
final catsProvider = StreamProvider<List<Cat>>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield [];
    return;
  }

  final catRepo = ref.watch(localCatRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  yield await catRepo.getActiveCats(uid);

  await for (final change in ledger.changes) {
    if (change.type.startsWith('habit_') ||
        change.type == 'cat_update' ||
        change.type == 'focus_complete' ||
        change.type == 'equip' ||
        change.type == 'unequip') {
      yield await catRepo.getActiveCats(uid);
    }
  }
});

/// All cats — includes graduated and dormant cats for Cat Album.
final allCatsProvider = StreamProvider<List<Cat>>((ref) async* {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) {
    yield [];
    return;
  }

  final catRepo = ref.watch(localCatRepositoryProvider);
  final ledger = ref.watch(ledgerServiceProvider);

  yield await catRepo.getAllCats(uid);

  await for (final change in ledger.changes) {
    if (change.type.startsWith('habit_') ||
        change.type == 'cat_update' ||
        change.type == 'focus_complete' ||
        change.type == 'equip' ||
        change.type == 'unequip') {
      yield await catRepo.getAllCats(uid);
    }
  }
});

/// Cat by habit ID — family provider for quick lookups.
final catByHabitProvider = Provider.family<Cat?, String>((ref, habitId) {
  final cats = ref.watch(catsProvider).value ?? [];
  try {
    return cats.firstWhere((c) => c.boundHabitId == habitId);
  } catch (_) {
    return null;
  }
});

/// Cat by ID — family provider.
final catByIdProvider = Provider.family<Cat?, String>((ref, catId) {
  final cats = ref.watch(allCatsProvider).value ?? [];
  try {
    return cats.firstWhere((c) => c.id == catId);
  } catch (_) {
    return null;
  }
});
