import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_diary_entry.dart';

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
  group('PixelDiaryEntry', () {
    const entry = PixelDiaryEntry(
      date: 'Mar 13',
      content: 'Test diary content',
    );

    testWidgets('MD3 mode renders Divider', (tester) async {
      await tester.pumpWidget(buildTestApp(isRetro: false, child: entry));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('Retro mode renders without Divider', (tester) async {
      await tester.pumpWidget(buildTestApp(isRetro: true, child: entry));
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('displays date and content text', (tester) async {
      await tester.pumpWidget(buildTestApp(isRetro: false, child: entry));
      expect(find.text('Mar 13'), findsOneWidget);
      expect(find.text('Test diary content'), findsOneWidget);
    });
  });
}
