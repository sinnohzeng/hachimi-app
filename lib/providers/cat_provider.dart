import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/pixel_cat_generation_service.dart';

/// Pixel cat generation service — singleton.
final pixelCatGenerationServiceProvider = Provider<PixelCatGenerationService>(
  (ref) => PixelCatGenerationService(),
);

/// Active cats — streams active cats from Firestore via CatFirestoreService.
final catsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(catFirestoreServiceProvider).watchCats(uid);
});

/// All cats — includes graduated and dormant cats for Cat Album.
final allCatsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(catFirestoreServiceProvider).watchAllCats(uid);
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
