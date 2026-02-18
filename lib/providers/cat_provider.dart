import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/cat_generation_service.dart';

/// Cat generation service — singleton.
final catGenerationServiceProvider =
    Provider<CatGenerationService>((ref) => CatGenerationService());

/// Active cats — streams active cats from Firestore.
final catsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).watchCats(uid);
});

/// All cats — includes graduated and dormant cats for Cat Album.
final allCatsProvider = StreamProvider<List<Cat>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).watchAllCats(uid);
});

/// Cat by habit ID — family provider for quick lookups.
final catByHabitProvider =
    Provider.family<Cat?, String>((ref, habitId) {
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

/// Owned breeds — for the draft algorithm to ensure variety.
final ownedBreedsProvider = Provider<List<String>>((ref) {
  final cats = ref.watch(allCatsProvider).value ?? [];
  return cats.map((c) => c.breed).toSet().toList();
});
