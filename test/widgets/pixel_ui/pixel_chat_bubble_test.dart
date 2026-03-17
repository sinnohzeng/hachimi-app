import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_chat_bubble.dart';

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
  group('PixelChatBubble', () {
    testWidgets('MD3 user message renders text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelChatBubble(text: 'Hello', isUser: true),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('MD3 cat message renders text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelChatBubble(text: 'Meow', isUser: false),
        ),
      );
      expect(find.text('Meow'), findsOneWidget);
    });

    testWidgets('Retro user message renders', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: const PixelChatBubble(text: 'Hello', isUser: true),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
      expect(find.byType(PixelChatBubble), findsOneWidget);
    });

    testWidgets('Retro cat message renders', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: true,
          child: const PixelChatBubble(text: 'Meow', isUser: false),
        ),
      );
      expect(find.text('Meow'), findsOneWidget);
    });

    testWidgets('MD3 streaming mode does not crash', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          isRetro: false,
          child: const PixelChatBubble(
            text: 'Streaming...',
            isUser: true,
            isStreaming: true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(PixelChatBubble), findsOneWidget);
    });
  });
}
