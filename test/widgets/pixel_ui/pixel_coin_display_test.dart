import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_coin_display.dart';

Widget _buildTestApp({required bool isRetro, required Widget child}) {
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
  group('PixelCoinDisplay', () {
    testWidgets('renders in MD3 mode with monetization icon', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelCoinDisplay(amount: 100),
        ),
      );
      expect(find.byType(PixelCoinDisplay), findsOneWidget);
      expect(find.byIcon(Icons.monetization_on), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('renders in Retro mode with CustomPaint coin', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: true,
          child: const PixelCoinDisplay(amount: 100),
        ),
      );
      expect(find.byType(PixelCoinDisplay), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('100'), findsOneWidget);
    });
  });
}
