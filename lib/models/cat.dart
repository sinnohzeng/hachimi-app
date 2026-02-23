import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// Cat 数据模型 — 每只猫绑定一个习惯。
/// 成长阶段基于固定时长阶梯（0/20/100/200h）计算，不依赖目标小时数。
class Cat {
  final String id;
  final String name;
  final String personality;
  final CatAppearance appearance;
  final int totalMinutes;
  final List<String> accessories;
  final String? equippedAccessory;
  final String boundHabitId;
  final String state; // 'active' / 'graduated' / 'dormant'
  final String? highestStage; // 曾达到的最高阶段（单调递增）
  final DateTime createdAt;
  final DateTime? lastSessionAt;

  const Cat({
    required this.id,
    required this.name,
    required this.personality,
    required this.appearance,
    this.totalMinutes = 0,
    this.accessories = const [],
    this.equippedAccessory,
    required this.boundHabitId,
    this.state = 'active',
    this.highestStage,
    required this.createdAt,
    this.lastSessionAt,
  });

  /// 成长进度 (0.0 - 1.0)，基于固定阶梯：200h (12000min) = 1.0
  double get growthProgress {
    return (totalMinutes / 12000.0).clamp(0.0, 1.0);
  }

  /// 当前成长阶段：kitten / adolescent / adult / senior
  String get computedStage => stageForProgress(growthProgress);

  /// 展示用阶段（取 computedStage 与 highestStage 的较高者，防止回退）
  String get displayStage {
    final computed = computedStage;
    if (highestStage != null) {
      return stageOrder(highestStage!) > stageOrder(computed)
          ? highestStage!
          : computed;
    }
    return computed;
  }

  /// 当前阶段内的进度 (0.0 - 1.0)
  double get stageProgress => stageProgressInRange(growthProgress);

  /// 当前 sprite 索引（根据阶段 + 变体 + 长毛）
  int get spriteIndex => computeSpriteIndex(
    stage: displayStage,
    variant: appearance.spriteVariant,
    isLonghair: appearance.isLonghair,
  );

  /// 心情（基于 lastSessionAt 计算，新猫 24h 内默认 happy）
  String get computedMood => calculateMood(lastSessionAt, createdAt: createdAt);

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
      accessories:
          (data['accessories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      equippedAccessory: data['equippedAccessory'] as String?,
      boundHabitId: data['boundHabitId'] as String? ?? '',
      state: data['state'] as String? ?? 'active',
      highestStage: data['highestStage'] as String?,
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
      'accessories': accessories,
      'equippedAccessory': equippedAccessory,
      'boundHabitId': boundHabitId,
      'state': state,
      'highestStage': highestStage,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSessionAt': lastSessionAt != null
          ? Timestamp.fromDate(lastSessionAt!)
          : null,
    };
  }

  /// SQLite 序列化 — 对应 local_cats 表。
  Map<String, dynamic> toSqlite(String uid) {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'personality': personality,
      'appearance': jsonEncode(appearance.toMap()),
      'total_minutes': totalMinutes,
      'equipped_accessory': equippedAccessory,
      'bound_habit_id': boundHabitId,
      'state': state,
      'highest_stage': highestStage,
      'last_session_at': lastSessionAt?.millisecondsSinceEpoch,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// 从 SQLite 行反序列化。
  factory Cat.fromSqlite(Map<String, dynamic> map) {
    final rawAppearance = map['appearance'] as String? ?? '{}';
    final appearanceMap =
        jsonDecode(rawAppearance) as Map<String, dynamic>? ?? {};

    return Cat(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      personality: map['personality'] as String? ?? 'playful',
      appearance: appearanceMap.isNotEmpty
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
      totalMinutes: map['total_minutes'] as int? ?? 0,
      accessories: const [], // 配饰列表从 materialized_state 管理
      equippedAccessory: map['equipped_accessory'] as String?,
      boundHabitId: map['bound_habit_id'] as String? ?? '',
      state: map['state'] as String? ?? 'active',
      highestStage: map['highest_stage'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      lastSessionAt: map['last_session_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_session_at'] as int)
          : null,
    );
  }

  Cat copyWith({
    String? id,
    String? name,
    String? personality,
    CatAppearance? appearance,
    int? totalMinutes,
    List<String>? accessories,
    String? equippedAccessory,
    String? boundHabitId,
    String? state,
    String? highestStage,
    DateTime? createdAt,
    DateTime? lastSessionAt,
  }) {
    return Cat(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      appearance: appearance ?? this.appearance,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      accessories: accessories ?? this.accessories,
      equippedAccessory: equippedAccessory ?? this.equippedAccessory,
      boundHabitId: boundHabitId ?? this.boundHabitId,
      state: state ?? this.state,
      highestStage: highestStage ?? this.highestStage,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
    );
  }
}
