import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_progress_bar.dart';

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
  group('PixelProgressBar', () {
    testWidgets('renders in MD3 mode with LinearProgressIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          isRetro: false,
          child: const PixelProgressBar(value: 0.5),
        ),
      );
      expect(find.byType(PixelProgressBar), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders in Retro mode with CustomPaint', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(isRetro: true, child: const PixelProgressBar(value: 0.5)),
      );
      expect(find.byType(PixelProgressBar), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
