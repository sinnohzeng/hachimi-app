import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/widgets/skeleton_loader.dart';

void main() {
  group('SkeletonLoader', () {
    testWidgets('renders with specified dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: SkeletonLoader(width: 120, height: 20)),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 120);
      expect(container.constraints?.maxHeight, 20);
    });

    testWidgets('renders with default height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: SkeletonLoader())),
        ),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('golden — SkeletonLoader default', tags: ['golden'], (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: SkeletonLoader(width: 120, height: 16),
              ),
            ),
          ),
        ),
      );

      // Let animation start
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(SkeletonLoader),
        matchesGoldenFile('goldens/skeleton_loader_default.png'),
      );
    });
  });

  group('SkeletonCard', () {
    testWidgets('renders avatar + text placeholders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(body: SkeletonCard()),
        ),
      );

      // SkeletonCard contains multiple SkeletonLoader children
      expect(find.byType(SkeletonLoader), findsWidgets);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('golden — SkeletonCard', tags: ['golden'], (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(body: Center(child: SkeletonCard())),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(SkeletonCard),
        matchesGoldenFile('goldens/skeleton_card.png'),
      );
    });
  });

  group('SkeletonGrid', () {
    testWidgets('renders default 4 items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(body: SkeletonGrid()),
        ),
      );

      // 4 cards, each with multiple skeleton loaders
      expect(find.byType(Card), findsNWidgets(4));
    });

    testWidgets('renders custom count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(body: SkeletonGrid(count: 2)),
        ),
      );

      expect(find.byType(Card), findsNWidgets(2));
    });
  });
}
