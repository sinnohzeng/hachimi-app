import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/constants/cat_response_templates.dart';

void main() {
  group('CatResponseTemplates', () {
    test('every CatResponseScene has entries in both zh and en', () {
      for (final scene in CatResponseScene.values) {
        final zhResult = getRandomCatResponse(scene, locale: 'zh');
        final enResult = getRandomCatResponse(scene, locale: 'en');
        expect(
          zhResult.isNotEmpty,
          isTrue,
          reason: 'ZH template missing for $scene',
        );
        expect(
          enResult.isNotEmpty,
          isTrue,
          reason: 'EN template missing for $scene',
        );
      }
    });

    test('placeholder replacement works for {catName}', () {
      final result = getRandomCatResponse(
        CatResponseScene.lightVeryHappy,
        locale: 'zh',
        params: {'catName': 'Mochi'},
      );
      expect(result, isNot(contains('{catName}')));
      // 模板大多包含 catName，检查替换后至少包含 Mochi 或不含占位符
      // （有些模板可能不使用 catName，但不会留下 {catName}）
    });

    test('locale switching returns different text', () {
      // 使用固定 seed 无法控制 Random，但中英文模板集合不同，
      // 多次采样至少能证明两组池子不完全相同。
      final zhResults = <String>{};
      final enResults = <String>{};
      for (var i = 0; i < 20; i++) {
        zhResults.add(
          getRandomCatResponse(
            CatResponseScene.lightCalm,
            locale: 'zh',
            params: {'catName': 'Test'},
          ),
        );
        enResults.add(
          getRandomCatResponse(
            CatResponseScene.lightCalm,
            locale: 'en',
            params: {'catName': 'Test'},
          ),
        );
      }
      // 中英文结果集合应不完全重叠
      expect(zhResults.difference(enResults), isNotEmpty);
    });

    group('generateWeeklySummary', () {
      test('with null happyMoment1 returns base template only', () {
        final result = generateWeeklySummary(
          catName: 'Mochi',
          lightCount: 5,
          weekCount: 3,
          locale: 'zh',
          happyMoment1: null,
        );
        expect(result, isNotEmpty);
        expect(result, isNot(contains('说到')));
        expect(result, isNot(contains('About')));
      });

      test('with short happyMoment1 (< 2 chars) returns base only', () {
        final result = generateWeeklySummary(
          catName: 'Mochi',
          lightCount: 5,
          weekCount: 3,
          locale: 'zh',
          happyMoment1: 'A',
        );
        expect(result, isNotEmpty);
        expect(result, isNot(contains('说到')));
      });

      test('with long happyMoment1 truncates to 4 chars', () {
        final result = generateWeeklySummary(
          catName: 'Mochi',
          lightCount: 5,
          weekCount: 3,
          locale: 'zh',
          happyMoment1: '和家人一起吃饭',
        );
        expect(result, contains('和家人一'));
        expect(result, isNot(contains('和家人一起吃饭')));
      });

      test('en locale uses English suffix', () {
        final result = generateWeeklySummary(
          catName: 'Mochi',
          lightCount: 5,
          weekCount: 3,
          locale: 'en',
          happyMoment1: 'Playing games',
        );
        expect(result, contains('About'));
        expect(result, contains('Mochi'));
      });
    });
  });
}
