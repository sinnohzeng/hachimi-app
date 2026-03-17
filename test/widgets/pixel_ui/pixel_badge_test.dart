import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_badge.dart';

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
  group('PixelBadge', () {
    testWidgets('renders in MD3 mode with Container', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(isRetro: false, child: const PixelBadge(text: 'Test')),
      );
      expect(find.byType(PixelBadge), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders in Retro mode with CustomPaint', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(isRetro: true, child: const PixelBadge(text: 'Test')),
      );
      expect(find.byType(PixelBadge), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('animate=true in MD3 mode does not crash', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelBadge(text: 'Test', animate: true),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PixelBadge), findsOneWidget);
    });

    testWidgets('Retro mode with animate=true does not crash', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: true,
          child: const PixelBadge(text: 'Test', animate: true),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('survives mode switch retro -> MD3', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(isRetro: true, child: const PixelBadge(text: 'Test')),
      );
      await tester.pumpWidget(
        _buildTestApp(isRetro: false, child: const PixelBadge(text: 'Test')),
      );
      await tester.pump();
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
