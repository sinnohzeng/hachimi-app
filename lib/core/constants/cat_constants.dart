import 'package:flutter/material.dart';

/// Cat Constants — Single Source of Truth for all cat metadata.
/// Defines breeds, patterns, personalities, growth stages, moods,
/// room slots, and random name pool.

// ─── Breed Color Config ───

class CatColorConfig {
  final Color base;
  final Color accent;

  const CatColorConfig({required this.base, required this.accent});
}

// ─── Breeds ───

class CatBreed {
  final String id;
  final String name;
  final String description;
  final int rarityWeight; // Higher = more common
  final String rarity; // common / uncommon / rare
  final CatColorConfig colors;
  final List<CatPattern> patterns;

  const CatBreed({
    required this.id,
    required this.name,
    required this.description,
    required this.rarityWeight,
    required this.rarity,
    required this.colors,
    required this.patterns,
  });
}

class CatPattern {
  final String id;
  final String description;

  const CatPattern({required this.id, required this.description});
}

const List<CatBreed> catBreeds = [
  CatBreed(
    id: 'orange_tabby',
    name: 'Orange Tabby',
    description: 'Classic striped orange',
    rarityWeight: 15,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFFF4A460),
      accent: Color(0xFFD2691E),
    ),
    patterns: [
      CatPattern(id: 'classic_stripe', description: 'Traditional M-forehead, wide swirl stripes'),
      CatPattern(id: 'mackerel', description: 'Thin parallel stripes'),
      CatPattern(id: 'spotted_tabby', description: 'Broken stripes forming spots'),
    ],
  ),
  CatBreed(
    id: 'tuxedo',
    name: 'Tuxedo',
    description: 'Black & white formal look',
    rarityWeight: 15,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFF2D2D2D),
      accent: Color(0xFFFFFFFF),
    ),
    patterns: [
      CatPattern(id: 'classic_tux', description: 'White chest and paws'),
      CatPattern(id: 'masked', description: 'White face with black mask'),
      CatPattern(id: 'mittens', description: 'White paws only'),
    ],
  ),
  CatBreed(
    id: 'calico',
    name: 'Calico',
    description: 'Tri-color patches',
    rarityWeight: 12,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFFF5F5DC),
      accent: Color(0xFFF4A460),
    ),
    patterns: [
      CatPattern(id: 'patched', description: 'Large orange and black patches'),
      CatPattern(id: 'dilute', description: 'Soft grey and cream patches'),
      CatPattern(id: 'tortie_point', description: 'Concentrated patches on extremities'),
    ],
  ),
  CatBreed(
    id: 'black',
    name: 'Black Cat',
    description: 'Solid black + yellow eyes',
    rarityWeight: 12,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFF1A1A1A),
      accent: Color(0xFFFFD700),
    ),
    patterns: [
      CatPattern(id: 'solid', description: 'Pure solid black'),
      CatPattern(id: 'smoke', description: 'Light undercoat showing through'),
      CatPattern(id: 'ghost_tabby', description: 'Faint stripes visible in sunlight'),
    ],
  ),
  CatBreed(
    id: 'white',
    name: 'White Cat',
    description: 'Solid white + blue eyes',
    rarityWeight: 10,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFFF5F5F5),
      accent: Color(0xFF87CEEB),
    ),
    patterns: [
      CatPattern(id: 'pure_white', description: 'Pristine solid white'),
      CatPattern(id: 'van', description: 'White with colored tail and head spots'),
      CatPattern(id: 'odd_eyed', description: 'White with heterochromia eyes'),
    ],
  ),
  CatBreed(
    id: 'grey_tabby',
    name: 'Grey Tabby',
    description: 'Silver-grey stripes',
    rarityWeight: 10,
    rarity: 'common',
    colors: CatColorConfig(
      base: Color(0xFFA0A0A0),
      accent: Color(0xFF696969),
    ),
    patterns: [
      CatPattern(id: 'silver_classic', description: 'Silver with bold swirl markings'),
      CatPattern(id: 'silver_mackerel', description: 'Silver with thin parallel stripes'),
      CatPattern(id: 'blue_tabby', description: 'Blue-grey with warm undertones'),
    ],
  ),
  CatBreed(
    id: 'siamese',
    name: 'Siamese',
    description: 'Cream body + dark points',
    rarityWeight: 8,
    rarity: 'uncommon',
    colors: CatColorConfig(
      base: Color(0xFFF5E6CA),
      accent: Color(0xFF8B7355),
    ),
    patterns: [
      CatPattern(id: 'seal_point', description: 'Dark brown face, ears, paws, tail'),
      CatPattern(id: 'blue_point', description: 'Grey-blue points on cream body'),
      CatPattern(id: 'chocolate_point', description: 'Warm chocolate brown points'),
    ],
  ),
  CatBreed(
    id: 'russian_blue',
    name: 'Russian Blue',
    description: 'Solid grey-blue + green eyes',
    rarityWeight: 7,
    rarity: 'uncommon',
    colors: CatColorConfig(
      base: Color(0xFF7B8FA1),
      accent: Color(0xFF4F6F52),
    ),
    patterns: [
      CatPattern(id: 'silver_tip', description: 'Silver-tipped blue-grey coat'),
      CatPattern(id: 'dense_blue', description: 'Deep uniform blue-grey'),
      CatPattern(id: 'light_blue', description: 'Light lavender-grey shade'),
    ],
  ),
  CatBreed(
    id: 'scottish_fold',
    name: 'Scottish Fold',
    description: 'Folded ears, round face',
    rarityWeight: 6,
    rarity: 'rare',
    colors: CatColorConfig(
      base: Color(0xFFD2B48C),
      accent: Color(0xFF8B7355),
    ),
    patterns: [
      CatPattern(id: 'cream_fold', description: 'Cream-colored with folded ears'),
      CatPattern(id: 'tabby_fold', description: 'Tabby markings with folded ears'),
      CatPattern(id: 'bicolor_fold', description: 'White and colored with folded ears'),
    ],
  ),
  CatBreed(
    id: 'ragdoll',
    name: 'Ragdoll',
    description: 'Fluffy, blue eyes, color-point',
    rarityWeight: 5,
    rarity: 'rare',
    colors: CatColorConfig(
      base: Color(0xFFE8DDD4),
      accent: Color(0xFF8B7355),
    ),
    patterns: [
      CatPattern(id: 'color_point', description: 'Dark face, ears, paws on light body'),
      CatPattern(id: 'mitted', description: 'Color-point with white mittens'),
      CatPattern(id: 'bicolor_rag', description: 'White inverted V on face, white legs'),
    ],
  ),
];

/// Quick lookup map: breedId → CatBreed
final Map<String, CatBreed> breedMap = {
  for (final breed in catBreeds) breed.id: breed,
};

/// Total rarity weight for weighted random selection
final int totalRarityWeight =
    catBreeds.fold(0, (sum, breed) => sum + breed.rarityWeight);

// ─── Personalities ───

class CatPersonality {
  final String id;
  final String name;
  final String emoji;
  final String flavorText;
  final List<String> preferredRoomSlots;

  const CatPersonality({
    required this.id,
    required this.name,
    required this.emoji,
    required this.flavorText,
    required this.preferredRoomSlots,
  });
}

const List<CatPersonality> catPersonalities = [
  CatPersonality(
    id: 'lazy',
    name: 'Lazy',
    emoji: '😴',
    flavorText: 'Will nap 23 hours a day. The other hour? Also napping.',
    preferredRoomSlots: ['sofa', 'bed'],
  ),
  CatPersonality(
    id: 'curious',
    name: 'Curious',
    emoji: '🔍',
    flavorText: 'Already sniffing everything in sight!',
    preferredRoomSlots: ['shelf', 'windowsill'],
  ),
  CatPersonality(
    id: 'playful',
    name: 'Playful',
    emoji: '🎯',
    flavorText: "Can't stop chasing butterflies!",
    preferredRoomSlots: ['rug', 'desk'],
  ),
  CatPersonality(
    id: 'shy',
    name: 'Shy',
    emoji: '🙈',
    flavorText: 'Took 3 minutes to peek out of the box...',
    preferredRoomSlots: ['box', 'behind_furniture'],
  ),
  CatPersonality(
    id: 'brave',
    name: 'Brave',
    emoji: '🦁',
    flavorText: 'Jumped out of the box before it was even opened!',
    preferredRoomSlots: ['door', 'chair'],
  ),
  CatPersonality(
    id: 'clingy',
    name: 'Clingy',
    emoji: '🥺',
    flavorText: "Immediately started purring and won't let go.",
    preferredRoomSlots: ['food_bowl', 'rug'],
  ),
];

/// Quick lookup map: personalityId → CatPersonality
final Map<String, CatPersonality> personalityMap = {
  for (final p in catPersonalities) p.id: p,
};

// ─── Growth Stages ───

class CatStage {
  final int level; // 1-4
  final String name;
  final String emoji;
  final int xpThreshold;

  const CatStage({
    required this.level,
    required this.name,
    required this.emoji,
    required this.xpThreshold,
  });
}

const List<CatStage> catStages = [
  CatStage(level: 1, name: 'Kitten', emoji: '🐱', xpThreshold: 0),
  CatStage(level: 2, name: 'Young Cat', emoji: '🐈', xpThreshold: 100),
  CatStage(level: 3, name: 'Adult Cat', emoji: '🐈\u200D⬛', xpThreshold: 300),
  CatStage(level: 4, name: 'Shiny Cat', emoji: '✨', xpThreshold: 600),
];

/// Returns the stage (1-4) for a given XP total.
int stageForXp(int xp) {
  for (int i = catStages.length - 1; i >= 0; i--) {
    if (xp >= catStages[i].xpThreshold) return catStages[i].level;
  }
  return 1;
}

/// Returns the stage name for a given stage level.
String stageNameForLevel(int level) {
  return catStages.firstWhere((s) => s.level == level, orElse: () => catStages[0]).name;
}

/// XP required to reach the next stage from current XP, or null if max.
int? xpToNextStage(int xp) {
  final currentStage = stageForXp(xp);
  if (currentStage >= 4) return null;
  return catStages[currentStage].xpThreshold - xp; // next stage is at index currentStage
}

// ─── Moods ───

class CatMood {
  final String id;
  final String name;
  final String emoji;
  final String spriteKey; // maps to sprite file: happy, neutral, sad

  const CatMood({
    required this.id,
    required this.name,
    required this.emoji,
    required this.spriteKey,
  });
}

const CatMood moodHappy = CatMood(id: 'happy', name: 'Happy', emoji: '😸', spriteKey: 'happy');
const CatMood moodNeutral = CatMood(id: 'neutral', name: 'Neutral', emoji: '😺', spriteKey: 'neutral');
const CatMood moodLonely = CatMood(id: 'lonely', name: 'Lonely', emoji: '🥺', spriteKey: 'sad');
const CatMood moodMissing = CatMood(id: 'missing', name: 'Missing You', emoji: '😿', spriteKey: 'sad');

/// Mood messages per personality × mood combination.
/// Key: '$personalityId:$moodId'
const Map<String, String> moodMessages = {
  // Happy
  'lazy:happy': 'Nya~! Time for a well-deserved nap...',
  'curious:happy': 'What are we exploring today?',
  'playful:happy': 'Nya~! Ready to work!',
  'shy:happy': '...I-I\'m glad you\'re here.',
  'brave:happy': 'Let\'s conquer today together!',
  'clingy:happy': 'Yay! You\'re back! Don\'t leave again!',
  // Neutral
  'lazy:neutral': '*yawn* Oh, hey...',
  'curious:neutral': 'Hmm, what\'s that over there?',
  'playful:neutral': 'Wanna play? Maybe later...',
  'shy:neutral': '*peeks out slowly*',
  'brave:neutral': 'Standing guard, as always.',
  'clingy:neutral': 'I\'ve been waiting for you...',
  // Lonely
  'lazy:lonely': 'Even napping feels lonely...',
  'curious:lonely': 'I wonder when you\'ll come back...',
  'playful:lonely': 'The toys aren\'t fun without you...',
  'shy:lonely': '*curls up quietly*',
  'brave:lonely': 'I\'ll keep waiting. I\'m brave.',
  'clingy:lonely': 'Where did you go... 🥺',
  // Missing
  'lazy:missing': '*opens one eye hopefully*',
  'curious:missing': 'Did something happen...?',
  'playful:missing': 'I saved your favorite toy...',
  'shy:missing': '*hiding, but watching the door*',
  'brave:missing': 'I know you\'ll come back. I believe.',
  'clingy:missing': 'I miss you so much... please come back.',
};

/// Calculate mood based on last session timestamp.
String calculateMood(DateTime? lastSessionAt) {
  if (lastSessionAt == null) return moodMissing.id;
  final now = DateTime.now();
  final diff = now.difference(lastSessionAt);
  if (diff.inHours < 24) return moodHappy.id;
  if (diff.inDays < 3) return moodNeutral.id;
  if (diff.inDays < 7) return moodLonely.id;
  return moodMissing.id;
}

/// Quick lookup for mood object by id.
CatMood moodById(String id) {
  switch (id) {
    case 'happy':
      return moodHappy;
    case 'neutral':
      return moodNeutral;
    case 'lonely':
      return moodLonely;
    case 'missing':
      return moodMissing;
    default:
      return moodNeutral;
  }
}

// ─── Room Slots ───

class RoomSlot {
  final String id;
  final String name;
  final double xPercent; // 0.0 - 1.0 position relative to room width
  final double yPercent; // 0.0 - 1.0 position relative to room height

  const RoomSlot({
    required this.id,
    required this.name,
    required this.xPercent,
    required this.yPercent,
  });
}

const List<RoomSlot> roomSlots = [
  RoomSlot(id: 'sofa', name: 'Sofa', xPercent: 0.65, yPercent: 0.45),
  RoomSlot(id: 'shelf', name: 'Bookshelf', xPercent: 0.15, yPercent: 0.25),
  RoomSlot(id: 'rug', name: 'Rug', xPercent: 0.40, yPercent: 0.65),
  RoomSlot(id: 'box', name: 'Box', xPercent: 0.75, yPercent: 0.70),
  RoomSlot(id: 'windowsill', name: 'Windowsill', xPercent: 0.80, yPercent: 0.20),
  RoomSlot(id: 'door', name: 'By the Door', xPercent: 0.10, yPercent: 0.55),
  RoomSlot(id: 'bed', name: 'Bed', xPercent: 0.25, yPercent: 0.50),
  RoomSlot(id: 'chair', name: 'Chair', xPercent: 0.55, yPercent: 0.35),
  RoomSlot(id: 'food_bowl', name: 'Food Bowl', xPercent: 0.15, yPercent: 0.75),
  RoomSlot(id: 'desk', name: 'Desk', xPercent: 0.50, yPercent: 0.20),
  RoomSlot(id: 'behind_furniture', name: 'Behind Furniture', xPercent: 0.85, yPercent: 0.55),
];

/// Quick lookup map: slotId → RoomSlot
final Map<String, RoomSlot> roomSlotMap = {
  for (final slot in roomSlots) slot.id: slot,
};

// ─── Random Cat Names ───

const List<String> randomCatNames = [
  'Mochi', 'Luna', 'Milo', 'Nori', 'Tofu',
  'Boba', 'Kiki', 'Suki', 'Taro', 'Yuki',
  'Coco', 'Mango', 'Peach', 'Daisy', 'Olive',
  'Pumpkin', 'Ginger', 'Pepper', 'Maple', 'Willow',
  'Clover', 'Hazel', 'Jasper', 'Felix', 'Oscar',
  'Simba', 'Nala', 'Bella', 'Chloe', 'Leo',
  'Loki', 'Thor', 'Miso', 'Ramen', 'Soba',
  'Pudding', 'Cookie', 'Waffle', 'Mocha', 'Latte',
  'Caramel', 'Biscuit', 'Sesame', 'Matcha', 'Azuki',
  'Hachi', 'Sakura', 'Hinata', 'Sora', 'Ren',
];
