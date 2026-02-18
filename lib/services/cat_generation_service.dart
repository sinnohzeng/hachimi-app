import 'dart:math';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/models/cat.dart';

/// CatGenerationService — generates random cat candidates for the adoption draft.
/// Implements the weighted randomization algorithm from PRD Section 2.2.4.
class CatGenerationService {
  final Random _random = Random();

  /// Generate 3 cat candidates for the adoption draft.
  ///
  /// - At least 1 breed the user doesn't already own (if possible).
  /// - No duplicate breed+pattern combo in the same draft.
  /// - Weighted by breed rarity.
  List<Cat> generateDraft({
    required List<String> userOwnedBreeds,
    required String boundHabitId,
  }) {
    final candidates = <Cat>[];
    final usedCombos = <String>{};

    // First candidate: prefer a breed the user doesn't own yet
    final newBreeds =
        catBreeds.where((b) => !userOwnedBreeds.contains(b.id)).toList();
    final firstBreed = newBreeds.isNotEmpty
        ? _pickWeightedBreed(newBreeds)
        : _pickWeightedBreed(catBreeds);

    final first = _generateCat(firstBreed, boundHabitId);
    candidates.add(first);
    usedCombos.add('${first.breed}:${first.pattern}');

    // Remaining 2: fully random (may repeat breeds, but not breed+pattern)
    for (var i = 0; i < 2; i++) {
      Cat cat;
      var attempts = 0;
      do {
        final breed = _pickWeightedBreed(catBreeds);
        cat = _generateCat(breed, boundHabitId);
        attempts++;
      } while (usedCombos.contains('${cat.breed}:${cat.pattern}') &&
          attempts < 20);

      candidates.add(cat);
      usedCombos.add('${cat.breed}:${cat.pattern}');
    }

    return candidates;
  }

  /// Pick a breed using weighted randomization based on rarity.
  CatBreed _pickWeightedBreed(List<CatBreed> pool) {
    final totalWeight = pool.fold(0, (sum, b) => sum + b.rarityWeight);
    var roll = _random.nextInt(totalWeight);

    for (final breed in pool) {
      roll -= breed.rarityWeight;
      if (roll < 0) return breed;
    }
    return pool.last;
  }

  /// Generate a single cat with random pattern and personality.
  Cat _generateCat(CatBreed breed, String boundHabitId) {
    final pattern = breed.patterns[_random.nextInt(breed.patterns.length)];
    final personality =
        catPersonalities[_random.nextInt(catPersonalities.length)];
    final name = randomCatNames[_random.nextInt(randomCatNames.length)];

    return Cat(
      id: '', // Will be assigned by Firestore
      name: name,
      breed: breed.id,
      pattern: pattern.id,
      personality: personality.id,
      rarity: breed.rarity,
      xp: 0,
      stage: 1,
      mood: 'happy',
      roomSlot: personality.preferredRoomSlots.first,
      boundHabitId: boundHabitId,
      state: 'active',
      createdAt: DateTime.now(),
    );
  }

  /// Generate a random cat name from the pool.
  String randomName() {
    return randomCatNames[_random.nextInt(randomCatNames.length)];
  }
}
