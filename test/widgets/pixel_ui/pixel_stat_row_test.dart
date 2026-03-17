import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_stat_row.dart';

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
  group('PixelStatRow', () {
    testWidgets('renders in MD3 mode', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelStatRow(label: 'Test', value: '42'),
        ),
      );
      expect(find.byType(PixelStatRow), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('renders in Retro mode', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: true,
          child: const PixelStatRow(label: 'Test', value: '42'),
        ),
      );
      expect(find.byType(PixelStatRow), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });
  });
}
