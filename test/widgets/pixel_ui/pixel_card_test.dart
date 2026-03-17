import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_card.dart';

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
  group('PixelCard', () {
    testWidgets('MD3 non-interactive renders without InkWell', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelCard(child: Text('test')),
        ),
      );
      expect(find.text('test'), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('MD3 interactive renders with InkWell', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: PixelCard(child: const Text('test'), onTap: () {}),
        ),
      );
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('Retro non-interactive renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: const PixelCard(child: Text('test')),
        ),
      );
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('Retro interactive renders GestureDetector', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: PixelCard(child: const Text('test'), onTap: () {}),
        ),
      );
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('survives mode switch retro -> MD3', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: PixelCard(child: const Text('test'), onTap: () {}),
        ),
      );
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: PixelCard(child: const Text('test'), onTap: () {}),
        ),
      );
      await tester.pump();
      expect(find.byType(PixelCard), findsOneWidget);
    });
  });
}
