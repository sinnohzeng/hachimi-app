import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_button.dart';

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
  group('PixelButton', () {
    testWidgets('MD3 mode renders FilledButton', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: PixelButton(label: 'Test', onPressed: () {}),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('Retro mode does not render FilledButton', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: PixelButton(label: 'Test', onPressed: () {}),
        ),
      );
      expect(find.byType(FilledButton), findsNothing);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('disabled button in MD3 mode renders without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelButton(label: 'Disabled', onPressed: null),
        ),
      );
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('survives mode switch retro -> MD3', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: PixelButton(label: 'T', onPressed: () {}),
        ),
      );
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: PixelButton(label: 'T', onPressed: () {}),
        ),
      );
      await tester.pump();
      expect(find.byType(PixelButton), findsOneWidget);
    });
  });
}
