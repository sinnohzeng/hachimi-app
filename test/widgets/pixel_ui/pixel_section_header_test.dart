import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_section_header.dart';

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
  group('PixelSectionHeader', () {
    testWidgets('renders in MD3 mode with Divider', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelSectionHeader(title: 'Test'),
        ),
      );
      expect(find.byType(PixelSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders in Retro mode with CustomPaint', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: true,
          child: const PixelSectionHeader(title: 'Test'),
        ),
      );
      expect(find.byType(PixelSectionHeader), findsOneWidget);
      // 像素虚线使用 CustomPaint（左右各一条）
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
