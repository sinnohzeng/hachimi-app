import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/app.dart' show kOnboardingCompleteKey;

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  bool _isForward = true;

  List<_OnboardingPageData> _buildPages(BuildContext context) => [
    _OnboardingPageData(
      emoji: '🐱',
      title: context.l10n.onboardTitle1,
      subtitle: context.l10n.onboardSubtitle1,
      body: context.l10n.onboardBody1,
      colorRole: _ColorRole.primary,
    ),
    _OnboardingPageData(
      emoji: '⏱️',
      title: context.l10n.onboardTitle2,
      subtitle: context.l10n.onboardSubtitle2,
      body: context.l10n.onboardBody2,
      colorRole: _ColorRole.secondary,
    ),
    _OnboardingPageData(
      emoji: '✨',
      title: context.l10n.onboardTitle3,
      subtitle: context.l10n.onboardSubtitle3,
      body: context.l10n.onboardBody3,
      colorRole: _ColorRole.tertiary,
    ),
  ];

  static const _pageCount = 3;

  void _next() {
    if (_currentPage < _pageCount - 1) {
      setState(() {
        _isForward = true;
        _currentPage++;
      });
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompleteKey, true);
    AnalyticsService().logOnboardingCompleted();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final pages = _buildPages(context);
    final pageData = pages[_currentPage];
    final onColor = pageData.onColor(colorScheme);

    return Scaffold(
      body: Stack(
        children: [
          // Page content with shared axis transition
          PageTransitionSwitcher(
            duration: AppMotion.durationMedium2,
            reverse: !_isForward,
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child,
                ),
            child: KeyedSubtree(
              key: ValueKey<int>(_currentPage),
              child: _OnboardingPage(data: pages[_currentPage]),
            ),
          ),

          // Skip button (top right, hidden on last page)
          if (_currentPage < pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  context.l10n.onboardSkip,
                  style: textTheme.bodyLarge?.copyWith(
                    color: onColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: AppMotion.durationMedium2,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? onColor
                                : onColor.withValues(alpha: 0.38),
                            borderRadius: AppShape.borderExtraSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Next / Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: onColor,
                          foregroundColor: pageData
                              .gradientColors(colorScheme)
                              .first,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppShape.borderLarge,
                          ),
                        ),
                        child: Text(
                          _currentPage == pages.length - 1
                              ? context.l10n.onboardLetsGo
                              : context.l10n.onboardNext,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: pageData.gradientColors(colorScheme).first,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ColorRole { primary, secondary, tertiary }

class _OnboardingPageData {
  final String emoji;
  final String title;
  final String subtitle;
  final String body;
  final _ColorRole colorRole;

  const _OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.colorRole,
  });

  List<Color> gradientColors(ColorScheme colorScheme) {
    return switch (colorRole) {
      _ColorRole.primary => [
        colorScheme.primary,
        colorScheme.primary.withValues(alpha: 0.7),
      ],
      _ColorRole.secondary => [
        colorScheme.secondary,
        colorScheme.secondary.withValues(alpha: 0.7),
      ],
      _ColorRole.tertiary => [
        colorScheme.tertiary,
        colorScheme.tertiary.withValues(alpha: 0.7),
      ],
    };
  }

  Color onColor(ColorScheme colorScheme) {
    return switch (colorRole) {
      _ColorRole.primary => colorScheme.onPrimary,
      _ColorRole.secondary => colorScheme.onSecondary,
      _ColorRole.tertiary => colorScheme.onTertiary,
    };
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final onColor = data.onColor(colorScheme);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: data.gradientColors(colorScheme),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Subtitle
              Text(
                data.subtitle,
                style: textTheme.titleMedium?.copyWith(
                  color: onColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Title
              Text(
                data.title,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Emoji
              Text(data.emoji, style: const TextStyle(fontSize: 96)),
              const SizedBox(height: 40),

              // Body
              Text(
                data.body,
                style: textTheme.bodyLarge?.copyWith(
                  color: onColor.withValues(alpha: 0.85),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
