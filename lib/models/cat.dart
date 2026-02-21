import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// Cat 数据模型 — 每只猫绑定一个习惯。
/// 成长阶段基于 totalMinutes / targetMinutes 百分比计算。
class Cat {
  final String id;
  final String name;
  final String personality;
  final CatAppearance appearance;
  final int totalMinutes;
  final int targetMinutes;
  final List<String> accessories;
  final String? equippedAccessory;
  final String boundHabitId;
  final String state; // 'active' / 'graduated' / 'dormant'
  final DateTime createdAt;
  final DateTime? lastSessionAt;

  const Cat({
    required this.id,
    required this.name,
    required this.personality,
    required this.appearance,
    this.totalMinutes = 0,
    required this.targetMinutes,
    this.accessories = const [],
    this.equippedAccessory,
    required this.boundHabitId,
    this.state = 'active',
    required this.createdAt,
    this.lastSessionAt,
  });

  /// 成长进度 (0.0 - 1.0)
  double get growthProgress {
    if (targetMinutes <= 0) return 0.0;
    return (totalMinutes / targetMinutes).clamp(0.0, 1.0);
  }

  /// 当前成长阶段：kitten / adolescent / adult / senior
  String get computedStage => stageForProgress(growthProgress);

  /// 当前阶段内的进度 (0.0 - 1.0)
  double get stageProgress => stageProgressInRange(growthProgress);

  /// 当前 sprite 索引（根据阶段 + 变体 + 长毛）
  int get spriteIndex => computeSpriteIndex(
    stage: computedStage,
    variant: appearance.spriteVariant,
    isLonghair: appearance.isLonghair,
  );

  /// 心情（基于 lastSessionAt 计算）
  String get computedMood => calculateMood(lastSessionAt);

  /// 心情元数据
  CatMood get moodData => moodById(computedMood);

  /// 性格元数据
  CatPersonality? get personalityData => personalityMap[personality];

  factory Cat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final appearanceMap = data['appearance'] as Map<String, dynamic>?;

    return Cat(
      id: doc.id,
      name: data['name'] as String? ?? '',
      personality: data['personality'] as String? ?? 'playful',
      appearance: appearanceMap != null
          ? CatAppearance.fromMap(appearanceMap)
          : const CatAppearance(
              peltType: 'SingleColour',
              peltColor: 'WHITE',
              tint: 'none',
              eyeColor: 'YELLOW',
              whitePatchesTint: 'none',
              skinColor: 'PINK',
              isTortie: false,
              isLonghair: false,
              reverse: false,
              spriteVariant: 0,
            ),
      totalMinutes: data['totalMinutes'] as int? ?? 0,
      targetMinutes: data['targetMinutes'] as int? ?? 6000,
      accessories:
          (data['accessories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equippedAccessory: data['equippedAccessory'] as String?,
      boundHabitId: data['boundHabitId'] as String? ?? '',
      state: data['state'] as String? ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSessionAt: (data['lastSessionAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'personality': personality,
      'appearance': appearance.toMap(),
      'totalMinutes': totalMinutes,
      'targetMinutes': targetMinutes,
      'accessories': accessories,
      'equippedAccessory': equippedAccessory,
      'boundHabitId': boundHabitId,
      'state': state,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSessionAt': lastSessionAt != null
          ? Timestamp.fromDate(lastSessionAt!)
          : null,
    };
  }

  Cat copyWith({
    String? id,
    String? name,
    String? personality,
    CatAppearance? appearance,
    int? totalMinutes,
    int? targetMinutes,
    List<String>? accessories,
    String? equippedAccessory,
    String? boundHabitId,
    String? state,
    DateTime? createdAt,
    DateTime? lastSessionAt,
  }) {
    return Cat(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      appearance: appearance ?? this.appearance,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      accessories: accessories ?? this.accessories,
      equippedAccessory: equippedAccessory ?? this.equippedAccessory,
      boundHabitId: boundHabitId ?? this.boundHabitId,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }
}
