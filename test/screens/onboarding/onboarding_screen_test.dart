import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/screens/onboarding/onboarding_screen.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAnalyticsService extends Fake implements AnalyticsService {
  @override
  Future<void> logOnboardingCompleted() async {}
}

class _DisabledAnimationThemeNotifier extends ThemeNotifier {
  @override
  ThemeSettings build() {
    return const ThemeSettings(enableBackgroundAnimation: false);
  }
}

/// Build test app with animations disabled via builder.
Future<Widget> _buildTestApp({required VoidCallback onComplete}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      analyticsServiceProvider.overrideWithValue(_FakeAnalyticsService()),
      sharedPreferencesProvider.overrideWithValue(prefs),
      themeProvider.overrideWith(_DisabledAnimationThemeNotifier.new),
    ],
    child: MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: const Locale('en'),
      builder: (context, child) {
        // Disable system animations to prevent breathing animation loop
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        );
      },
      home: OnboardingScreen(onComplete: onComplete),
    ),
  );
}

/// Pump enough frames for transitions to complete (500ms covers all).
Future<void> _pumpSettled(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  group('OnboardingScreen', () {
    testWidgets('renders page 1 title on initial load', (tester) async {
      await tester.pumpWidget(await _buildTestApp(onComplete: () {}));
      await _pumpSettled(tester);

      expect(find.text('Meet Your Companion'), findsOneWidget);
    });

    testWidgets('navigates to page 2 on Next tap', (tester) async {
      await tester.pumpWidget(await _buildTestApp(onComplete: () {}));
      await _pumpSettled(tester);

      await tester.tap(find.text('Next'));
      await _pumpSettled(tester);

      expect(find.text('Focus, Grow, Evolve'), findsOneWidget);
    });

    testWidgets('skip button triggers onComplete', (tester) async {
      var completed = false;
      await tester.pumpWidget(
        await _buildTestApp(onComplete: () => completed = true),
      );
      await _pumpSettled(tester);

      await tester.tap(find.text('Skip'));
      await _pumpSettled(tester);

      expect(completed, isTrue);
    });

    testWidgets('lets go button on last page triggers onComplete', (
      tester,
    ) async {
      var completed = false;
      await tester.pumpWidget(
        await _buildTestApp(onComplete: () => completed = true),
      );
      await _pumpSettled(tester);

      // Go to page 2
      await tester.tap(find.text('Next'));
      await _pumpSettled(tester);

      // Go to page 3
      await tester.tap(find.text('Next'));
      await _pumpSettled(tester);

      // Tap "Let's Go!"
      await tester.tap(find.text("Let's Go!"));
      await _pumpSettled(tester);

      expect(completed, isTrue);
    });

    testWidgets('page indicator reflects current page', (tester) async {
      await tester.pumpWidget(await _buildTestApp(onComplete: () {}));
      await _pumpSettled(tester);

      // Page 1: title visible
      expect(find.text('Meet Your Companion'), findsOneWidget);
      expect(find.text('Focus, Grow, Evolve'), findsNothing);

      await tester.tap(find.text('Next'));
      await _pumpSettled(tester);

      // Page 2: new title visible, old one gone
      expect(find.text('Focus, Grow, Evolve'), findsOneWidget);
      expect(find.text('Meet Your Companion'), findsNothing);
    });

    testWidgets('back button navigates to previous page', (tester) async {
      await tester.pumpWidget(await _buildTestApp(onComplete: () {}));
      await _pumpSettled(tester);

      // Go to page 2
      await tester.tap(find.text('Next'));
      await _pumpSettled(tester);

      expect(find.text('Focus, Grow, Evolve'), findsOneWidget);

      // Back to page 1
      await tester.tap(find.byIcon(Icons.arrow_back));
      await _pumpSettled(tester);

      expect(find.text('Meet Your Companion'), findsOneWidget);
    });
  });
}
