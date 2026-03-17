import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_milestone.dart';

Widget buildTestApp({required bool isRetro, required Widget child}) {
  final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  final pixelExt = isRetro
      ? PixelThemeExtension.light(scheme)
      : PixelThemeExtension.fallback();
  return MaterialApp(
    theme: ThemeData(colorScheme: scheme, extensions: [pixelExt]),
    home: Scaffold(body: child),
  );
}

void main() {
  group('PixelMilestone', () {
    const milestone = PixelMilestone(stages: ['A', 'B', 'C'], currentIndex: 1);

    testWidgets('MD3 mode renders all stage labels', (tester) async {
      await tester.pumpWidget(buildTestApp(isRetro: false, child: milestone));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('Retro mode renders all stage labels', (tester) async {
      await tester.pumpWidget(buildTestApp(isRetro: true, child: milestone));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('renders without error with currentIndex at boundary', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelMilestone(stages: ['A', 'B', 'C'], currentIndex: 0),
        ),
      );
      expect(find.byType(PixelMilestone), findsOneWidget);
    });
  });
}
