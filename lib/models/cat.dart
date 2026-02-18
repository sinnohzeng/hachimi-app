import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';

/// Cat data model — maps to Firestore `users/{uid}/cats/{catId}`.
/// Each cat is bound to exactly one habit via [boundHabitId].
class Cat {
  final String id;
  final String name;
  final String breed; // e.g. 'orange_tabby'
  final String pattern; // e.g. 'mackerel'
  final String personality; // e.g. 'playful'
  final String rarity; // 'common' / 'uncommon' / 'rare'
  final int xp;
  final int stage; // 1=kitten, 2=young, 3=adult, 4=shiny
  final String mood; // 'happy' / 'neutral' / 'lonely' / 'missing'
  final String? roomSlot; // e.g. 'sofa', assigned based on personality
  final String boundHabitId;
  final String state; // 'active' / 'graduated' / 'dormant'
  final DateTime createdAt;
  final DateTime? lastSessionAt;

  const Cat({
    required this.id,
    required this.name,
    required this.breed,
    required this.pattern,
    required this.personality,
    required this.rarity,
    this.xp = 0,
    this.stage = 1,
    this.mood = 'happy',
    this.roomSlot,
    required this.boundHabitId,
    this.state = 'active',
    required this.createdAt,
    this.lastSessionAt,
  });

  /// Current growth stage computed from XP.
  int get computedStage => stageForXp(xp);

  /// Current mood computed from last session time.
  String get computedMood => calculateMood(lastSessionAt);

  /// XP remaining to reach the next stage, or null if max.
  int? get xpToNext => xpToNextStage(xp);

  /// XP progress within the current stage (0.0 - 1.0).
  double get stageProgress {
    final current = catStages[computedStage - 1].xpThreshold;
    if (computedStage >= 4) {
      // Max stage: show progress relative to last threshold
      return 1.0;
    }
    final next = catStages[computedStage].xpThreshold;
    final range = next - current;
    if (range <= 0) return 1.0;
    return ((xp - current) / range).clamp(0.0, 1.0);
  }

  /// The breed metadata for this cat.
  CatBreed? get breedData => breedMap[breed];

  /// The personality metadata for this cat.
  CatPersonality? get personalityData => personalityMap[personality];

  /// The mood metadata for this cat.
  CatMood get moodData => moodById(computedMood);

  /// Stage name for display.
  String get stageName => stageNameForLevel(computedStage);

  /// Speech bubble message based on personality × mood.
  String get speechMessage {
    final key = '$personality:$computedMood';
    return moodMessages[key] ?? 'Meow~';
  }

  factory Cat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cat(
      id: doc.id,
      name: data['name'] as String? ?? '',
      breed: data['breed'] as String? ?? 'orange_tabby',
      pattern: data['pattern'] as String? ?? 'classic_stripe',
      personality: data['personality'] as String? ?? 'playful',
      rarity: data['rarity'] as String? ?? 'common',
      xp: data['xp'] as int? ?? 0,
      stage: data['stage'] as int? ?? 1,
      mood: data['mood'] as String? ?? 'happy',
      roomSlot: data['roomSlot'] as String?,
      boundHabitId: data['boundHabitId'] as String? ?? '',
      state: data['state'] as String? ?? 'active',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSessionAt: (data['lastSessionAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'breed': breed,
      'pattern': pattern,
      'personality': personality,
      'rarity': rarity,
      'xp': xp,
      'stage': stage,
      'mood': mood,
      'roomSlot': roomSlot,
      'boundHabitId': boundHabitId,
      'state': state,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSessionAt':
          lastSessionAt != null ? Timestamp.fromDate(lastSessionAt!) : null,
    };
  }

  Cat copyWith({
    String? id,
    String? name,
    String? breed,
    String? pattern,
    String? personality,
    String? rarity,
    int? xp,
    int? stage,
    String? mood,
    String? roomSlot,
    String? boundHabitId,
    String? state,
    DateTime? createdAt,
    DateTime? lastSessionAt,
  }) {
    return Cat(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      pattern: pattern ?? this.pattern,
      personality: personality ?? this.personality,
      rarity: rarity ?? this.rarity,
      xp: xp ?? this.xp,
      stage: stage ?? this.stage,
      mood: mood ?? this.mood,
      roomSlot: roomSlot ?? this.roomSlot,
      boundHabitId: boundHabitId ?? this.boundHabitId,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }
}
