// ---
// 📘 文件说明：
// Cat 模型单元测试 — 验证序列化、计算属性、copyWith 等逻辑。
// 不依赖 Firebase — 通过 toFirestore() 输出 Map 进行验证。
//
// 🧩 文件结构：
// - toFirestore() 输出格式验证；
// - growthProgress 计算属性；
// - computedStage 阶段判定（3 阶段系统）；
// - displayStage 防回退保护；
// - copyWith() 字段覆盖；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// 创建一个测试用 Cat 实例。
Cat _createTestCat({
  int totalMinutes = 100,
  int targetMinutes = 1000,
  String personality = 'playful',
  String name = 'TestCat',
  String state = 'active',
  String? highestStage,
  DateTime? createdAt,
  DateTime? lastSessionAt,
}) {
  return Cat(
    id: 'test-cat-id',
    name: name,
    personality: personality,
    appearance: const CatAppearance(
      peltType: 'Tabby',
      peltColor: 'GINGER',
      tint: 'none',
      eyeColor: 'GREEN',
      whitePatchesTint: 'none',
      skinColor: 'PINK',
      isTortie: false,
      isLonghair: false,
      reverse: false,
      spriteVariant: 0,
    ),
    totalMinutes: totalMinutes,
    targetMinutes: targetMinutes,
    boundHabitId: 'habit-1',
    state: state,
    highestStage: highestStage,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
    lastSessionAt: lastSessionAt,
  );
}

void main() {
  group('Cat.toFirestore()', () {
    test('output map contains all expected keys', () {
      final cat = _createTestCat();
      final map = cat.toFirestore();

      expect(map, containsPair('name', 'TestCat'));
      expect(map, containsPair('personality', 'playful'));
      expect(map, containsPair('totalMinutes', 100));
      expect(map, containsPair('targetMinutes', 1000));
      expect(map, containsPair('boundHabitId', 'habit-1'));
      expect(map, containsPair('state', 'active'));
      expect(map, contains('appearance'));
      expect(map, contains('createdAt'));
      expect(map, contains('accessories'));
    });

    test('round-trip: toFirestore map preserves data fidelity', () {
      final cat = _createTestCat(
        totalMinutes: 500,
        targetMinutes: 2000,
        name: 'Mochi',
        personality: 'shy',
      );
      final map = cat.toFirestore();

      // 验证核心字段
      expect(map['name'], equals('Mochi'));
      expect(map['personality'], equals('shy'));
      expect(map['totalMinutes'], equals(500));
      expect(map['targetMinutes'], equals(2000));

      // 验证 appearance 子 map 完整性
      final appearanceMap = map['appearance'] as Map<String, dynamic>;
      expect(appearanceMap['peltType'], equals('Tabby'));
      expect(appearanceMap['peltColor'], equals('GINGER'));
      expect(appearanceMap['eyeColor'], equals('GREEN'));
      expect(appearanceMap['isLonghair'], isFalse);
    });

    test('toFirestore includes highestStage', () {
      final cat = _createTestCat(highestStage: 'adult');
      final map = cat.toFirestore();
      expect(map['highestStage'], equals('adult'));
    });

    test('toFirestore includes null highestStage for legacy cats', () {
      final cat = _createTestCat();
      final map = cat.toFirestore();
      expect(map['highestStage'], isNull);
    });
  });

  group('Cat.growthProgress', () {
    test('returns 0.0 when targetMinutes == 0', () {
      final cat = _createTestCat(totalMinutes: 100, targetMinutes: 0);
      expect(cat.growthProgress, equals(0.0));
    });

    test('returns correct ratio for normal values', () {
      final cat = _createTestCat(totalMinutes: 250, targetMinutes: 1000);
      expect(cat.growthProgress, closeTo(0.25, 0.001));
    });

    test('clamps to 1.0 when totalMinutes exceeds targetMinutes', () {
      final cat = _createTestCat(totalMinutes: 1500, targetMinutes: 1000);
      expect(cat.growthProgress, equals(1.0));
    });

    test('returns 0.0 when totalMinutes is 0', () {
      final cat = _createTestCat(totalMinutes: 0, targetMinutes: 1000);
      expect(cat.growthProgress, equals(0.0));
    });
  });

  group('Cat.computedStage (3-stage system)', () {
    test('kitten stage: progress < 0.33', () {
      // 200 / 1000 = 0.20 -> kitten
      final cat = _createTestCat(totalMinutes: 200, targetMinutes: 1000);
      expect(cat.computedStage, equals('kitten'));
    });

    test('adolescent stage: 0.33 <= progress < 0.66', () {
      // 400 / 1000 = 0.40 -> adolescent
      final cat = _createTestCat(totalMinutes: 400, targetMinutes: 1000);
      expect(cat.computedStage, equals('adolescent'));
    });

    test('adult stage: progress >= 0.66', () {
      // 700 / 1000 = 0.70 -> adult
      final cat = _createTestCat(totalMinutes: 700, targetMinutes: 1000);
      expect(cat.computedStage, equals('adult'));
    });

    test('boundary: exactly 0.33 is adolescent', () {
      // 330 / 1000 = 0.33 -> adolescent
      final cat = _createTestCat(totalMinutes: 330, targetMinutes: 1000);
      expect(cat.computedStage, equals('adolescent'));
    });

    test('boundary: exactly 0.66 is adult', () {
      // 660 / 1000 = 0.66 -> adult
      final cat = _createTestCat(totalMinutes: 660, targetMinutes: 1000);
      expect(cat.computedStage, equals('adult'));
    });

    test('targetMinutes == 0 -> defaults to kitten (progress = 0.0)', () {
      final cat = _createTestCat(totalMinutes: 500, targetMinutes: 0);
      expect(cat.computedStage, equals('kitten'));
    });
  });

  group('Cat.displayStage (highestStage protection)', () {
    test(
      'returns computedStage when highestStage is null (legacy, low progress)',
      () {
        // 100 / 1000 = 0.10 -> kitten (both old and new thresholds)
        final cat = _createTestCat(totalMinutes: 100, targetMinutes: 1000);
        expect(cat.displayStage, equals('kitten'));
      },
    );

    test('legacy cat: uses old thresholds to prevent regression (20%-33%)', () {
      // 250 / 1000 = 0.25 -> new: kitten (<33%), old: adolescent (>=20%)
      // displayStage should use old threshold -> adolescent
      final cat = _createTestCat(totalMinutes: 250, targetMinutes: 1000);
      expect(cat.computedStage, equals('kitten'));
      expect(cat.displayStage, equals('adolescent'));
    });

    test('legacy cat: uses old thresholds to prevent regression (45%-66%)', () {
      // 500 / 1000 = 0.50 -> new: adolescent (<66%), old: adult (>=45%)
      // displayStage should use old threshold -> adult
      final cat = _createTestCat(totalMinutes: 500, targetMinutes: 1000);
      expect(cat.computedStage, equals('adolescent'));
      expect(cat.displayStage, equals('adult'));
    });

    test('legacy cat: high progress works correctly', () {
      // 800 / 1000 = 0.80 -> new: adult (>=66%), old: also adult (was senior)
      final cat = _createTestCat(totalMinutes: 800, targetMinutes: 1000);
      expect(cat.computedStage, equals('adult'));
      expect(cat.displayStage, equals('adult'));
    });

    test('returns highestStage when computed stage regresses', () {
      // Progress < 33% but was previously adult
      final cat = _createTestCat(
        totalMinutes: 200,
        targetMinutes: 1000,
        highestStage: 'adult',
      );
      expect(cat.computedStage, equals('kitten'));
      expect(cat.displayStage, equals('adult'));
    });

    test('returns computedStage when it exceeds highestStage', () {
      final cat = _createTestCat(
        totalMinutes: 700,
        targetMinutes: 1000,
        highestStage: 'adolescent',
      );
      expect(cat.computedStage, equals('adult'));
      expect(cat.displayStage, equals('adult'));
    });

    test('returns highestStage when equal to computedStage', () {
      final cat = _createTestCat(
        totalMinutes: 400,
        targetMinutes: 1000,
        highestStage: 'adolescent',
      );
      expect(cat.computedStage, equals('adolescent'));
      expect(cat.displayStage, equals('adolescent'));
    });
  });

  group('Cat.copyWith', () {
    test('correctly overrides name', () {
      final cat = _createTestCat(name: 'Original');
      final copied = cat.copyWith(name: 'NewName');

      expect(copied.name, equals('NewName'));
      expect(copied.id, equals(cat.id));
      expect(copied.totalMinutes, equals(cat.totalMinutes));
    });

    test('correctly overrides totalMinutes', () {
      final cat = _createTestCat(totalMinutes: 100);
      final copied = cat.copyWith(totalMinutes: 999);

      expect(copied.totalMinutes, equals(999));
      expect(copied.name, equals(cat.name));
    });

    test('correctly overrides state', () {
      final cat = _createTestCat(state: 'active');
      final copied = cat.copyWith(state: 'graduated');

      expect(copied.state, equals('graduated'));
    });

    test('correctly overrides highestStage', () {
      final cat = _createTestCat(highestStage: 'kitten');
      final copied = cat.copyWith(highestStage: 'adult');

      expect(copied.highestStage, equals('adult'));
    });

    test('preserves all fields when no overrides given', () {
      final cat = _createTestCat(
        name: 'Mochi',
        totalMinutes: 500,
        targetMinutes: 2000,
        personality: 'curious',
        state: 'active',
        highestStage: 'adolescent',
      );
      final copied = cat.copyWith();

      expect(copied.id, equals(cat.id));
      expect(copied.name, equals(cat.name));
      expect(copied.personality, equals(cat.personality));
      expect(copied.totalMinutes, equals(cat.totalMinutes));
      expect(copied.targetMinutes, equals(cat.targetMinutes));
      expect(copied.state, equals(cat.state));
      expect(copied.highestStage, equals(cat.highestStage));
      expect(copied.boundHabitId, equals(cat.boundHabitId));
    });

    test('correctly overrides multiple fields simultaneously', () {
      final cat = _createTestCat();
      final copied = cat.copyWith(
        name: 'Luna',
        totalMinutes: 777,
        state: 'dormant',
      );

      expect(copied.name, equals('Luna'));
      expect(copied.totalMinutes, equals(777));
      expect(copied.state, equals('dormant'));
      // 未覆盖字段保留原值
      expect(copied.personality, equals(cat.personality));
      expect(copied.targetMinutes, equals(cat.targetMinutes));
    });
  });
}
