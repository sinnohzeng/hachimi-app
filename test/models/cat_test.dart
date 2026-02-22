// ---
// Cat 模型单元测试 — 验证序列化、计算属性、copyWith 等逻辑。
// 不依赖 Firebase — 通过 toFirestore() 输出 Map 进行验证。
//
// 🧩 文件结构：
// - toFirestore() 输出格式验证；
// - growthProgress 固定阶梯计算（200h = 12000min = 1.0）；
// - computedStage 阶段判定（4 阶段固定阶梯）；
// - displayStage 防回退保护；
// - copyWith() 字段覆盖；
// ---

import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// 创建一个测试用 Cat 实例。
Cat _createTestCat({
  int totalMinutes = 100,
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
      expect(map, containsPair('boundHabitId', 'habit-1'));
      expect(map, containsPair('state', 'active'));
      expect(map, contains('appearance'));
      expect(map, contains('createdAt'));
      expect(map, contains('accessories'));
    });

    test('round-trip: toFirestore map preserves data fidelity', () {
      final cat = _createTestCat(
        totalMinutes: 500,
        name: 'Mochi',
        personality: 'shy',
      );
      final map = cat.toFirestore();

      expect(map['name'], equals('Mochi'));
      expect(map['personality'], equals('shy'));
      expect(map['totalMinutes'], equals(500));

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

  group('Cat.growthProgress (fixed 200h ladder)', () {
    test('returns 0.0 when totalMinutes is 0', () {
      final cat = _createTestCat(totalMinutes: 0);
      expect(cat.growthProgress, equals(0.0));
    });

    test('returns correct ratio for normal values', () {
      // 1200 min / 12000 = 0.10
      final cat = _createTestCat(totalMinutes: 1200);
      expect(cat.growthProgress, closeTo(0.10, 0.001));
    });

    test('clamps to 1.0 when totalMinutes exceeds 12000', () {
      final cat = _createTestCat(totalMinutes: 15000);
      expect(cat.growthProgress, equals(1.0));
    });

    test('exactly 12000 minutes = 1.0', () {
      final cat = _createTestCat(totalMinutes: 12000);
      expect(cat.growthProgress, equals(1.0));
    });

    test('6000 minutes = 0.5', () {
      final cat = _createTestCat(totalMinutes: 6000);
      expect(cat.growthProgress, closeTo(0.5, 0.001));
    });
  });

  group('Cat.computedStage (4-stage fixed ladder)', () {
    test('kitten stage: < 20h (1200 min)', () {
      final cat = _createTestCat(totalMinutes: 500);
      expect(cat.computedStage, equals('kitten'));
    });

    test('adolescent stage: >= 20h (1200 min)', () {
      final cat = _createTestCat(totalMinutes: 1200);
      expect(cat.computedStage, equals('adolescent'));
    });

    test('adult stage: >= 100h (6000 min)', () {
      final cat = _createTestCat(totalMinutes: 6000);
      expect(cat.computedStage, equals('adult'));
    });

    test('senior stage: >= 200h (12000 min)', () {
      final cat = _createTestCat(totalMinutes: 12000);
      expect(cat.computedStage, equals('senior'));
    });

    test('boundary: exactly 1200 min = adolescent', () {
      final cat = _createTestCat(totalMinutes: 1200);
      expect(cat.computedStage, equals('adolescent'));
    });

    test('boundary: 1199 min = kitten', () {
      final cat = _createTestCat(totalMinutes: 1199);
      expect(cat.computedStage, equals('kitten'));
    });

    test('0 minutes = kitten', () {
      final cat = _createTestCat(totalMinutes: 0);
      expect(cat.computedStage, equals('kitten'));
    });
  });

  group('Cat.displayStage (highestStage protection)', () {
    test('returns computedStage when highestStage is null', () {
      final cat = _createTestCat(totalMinutes: 100);
      expect(cat.displayStage, equals('kitten'));
    });

    test('returns highestStage when computed stage regresses', () {
      final cat = _createTestCat(totalMinutes: 200, highestStage: 'adult');
      expect(cat.computedStage, equals('kitten'));
      expect(cat.displayStage, equals('adult'));
    });

    test('returns computedStage when it exceeds highestStage', () {
      final cat = _createTestCat(
        totalMinutes: 6000,
        highestStage: 'adolescent',
      );
      expect(cat.computedStage, equals('adult'));
      expect(cat.displayStage, equals('adult'));
    });

    test('returns highestStage when equal to computedStage', () {
      final cat = _createTestCat(
        totalMinutes: 1200,
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
        personality: 'curious',
        state: 'active',
        highestStage: 'adolescent',
      );
      final copied = cat.copyWith();

      expect(copied.id, equals(cat.id));
      expect(copied.name, equals(cat.name));
      expect(copied.personality, equals(cat.personality));
      expect(copied.totalMinutes, equals(cat.totalMinutes));
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
      expect(copied.personality, equals(cat.personality));
    });
  });
}
