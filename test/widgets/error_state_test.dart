import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/widgets/error_state.dart';

void main() {
  group('ErrorState', () {
    testWidgets('renders error icon and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorState(message: 'Something went wrong')),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('renders retry button when onRetry provided', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Failed to load',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retried, isTrue);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ErrorState(message: 'Error occurred')),
        ),
      );

      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('golden — ErrorState with retry', tags: ['golden'], (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: Scaffold(
            body: ErrorState(message: 'Failed to load data', onRetry: () {}),
          ),
        ),
      );

      await expectLater(
        find.byType(ErrorState),
        matchesGoldenFile('goldens/error_state_with_retry.png'),
      );
    });

    testWidgets('golden — ErrorState without retry', tags: ['golden'], (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(body: ErrorState(message: 'Network error')),
        ),
      );

      await expectLater(
        find.byType(ErrorState),
        matchesGoldenFile('goldens/error_state_no_retry.png'),
      );
    });
  });
}
