import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/widgets/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(icon: Icons.add_task, title: 'No quests yet'),
          ),
        ),
      );

      expect(find.byIcon(Icons.add_task), findsOneWidget);
      expect(find.text('No quests yet'), findsOneWidget);
    });

    testWidgets('renders optional subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.add_task,
              title: 'No quests yet',
              subtitle: 'Start your journey!',
            ),
          ),
        ),
      );

      expect(find.text('Start your journey!'), findsOneWidget);
    });

    testWidgets('hides subtitle when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(icon: Icons.add_task, title: 'No quests yet'),
          ),
        ),
      );

      // Only title text, no subtitle
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders CTA button when actionLabel and onAction provided', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.add,
              title: 'Empty',
              actionLabel: 'Add Item',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      await tester.tap(find.text('Add Item'));
      expect(tapped, isTrue);
    });

    testWidgets('hides CTA when actionLabel is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(icon: Icons.add, title: 'Empty'),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets(
      'golden — EmptyState with subtitle and action',
      tags: ['golden'],
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(colorSchemeSeed: Colors.blue),
            home: Scaffold(
              body: EmptyState(
                icon: Icons.pets_outlined,
                title: 'No cats here',
                subtitle: 'Adopt a cat to get started',
                actionLabel: 'Adopt',
                onAction: () {},
              ),
            ),
          ),
        );

        await expectLater(
          find.byType(EmptyState),
          matchesGoldenFile('goldens/empty_state_full.png'),
        );
      },
    );

    testWidgets('golden — EmptyState minimal', tags: ['golden'], (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: const Scaffold(
            body: EmptyState(icon: Icons.inbox_outlined, title: 'Nothing here'),
          ),
        ),
      );

      await expectLater(
        find.byType(EmptyState),
        matchesGoldenFile('goldens/empty_state_minimal.png'),
      );
    });
  });
}
