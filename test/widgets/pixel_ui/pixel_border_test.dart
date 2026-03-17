import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_border.dart';

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
  group('PixelBorder', () {
    testWidgets('renders in MD3 mode with BoxDecoration', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelBorder(child: Text('test')),
        ),
      );
      expect(find.byType(PixelBorder), findsOneWidget);
      // MD3 模式使用 Container + BoxDecoration
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders in Retro mode with CustomPaint', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: true,
          child: const PixelBorder(child: Text('test')),
        ),
      );
      expect(find.byType(PixelBorder), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
