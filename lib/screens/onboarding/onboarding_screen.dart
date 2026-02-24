import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/services/analytics_service.dart';
import 'package:hachimi_app/app.dart' show kOnboardingCompleteKey;

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentPage = 0;
  bool _isForward = true;

  static const _pageCount = 3;

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

  void _previous() {
    if (_currentPage > 0) {
      setState(() {
        _isForward = false;
        _currentPage--;
      });
    }
  }

  void _skip() => _finish();

  void _finish() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool(kOnboardingCompleteKey, true);
    AnalyticsService().logOnboardingCompleted();
    widget.onComplete();
  }

  // Shared page transition switcher used by both layouts.
  Widget _buildPageSwitcher(
    List<_OnboardingPageData> pages,
    Widget Function(_OnboardingPageData) builder,
  ) {
    return PageTransitionSwitcher(
      duration: AppMotion.durationMedium2,
      reverse: !_isForward,
      transitionBuilder: (child, primary, secondary) => SharedAxisTransition(
        animation: primary,
        secondaryAnimation: secondary,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      ),
      child: KeyedSubtree(
        key: ValueKey<int>(_currentPage),
        child: builder(pages[_currentPage]),
      ),
    );
  }

  Widget _buildPageIndicator(Color activeColor, Color inactiveColor) {
    return Semantics(
      label: 'Page ${_currentPage + 1} of $_pageCount',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pageCount,
          (i) => ExcludeSemantics(
            child: AnimatedContainer(
              duration: AppMotion.durationMedium2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i ? activeColor : inactiveColor,
                borderRadius: AppShape.borderExtraSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilledButton({
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _next,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: AppShape.borderLarge),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages(context);
    return Semantics(
      label: 'Page ${_currentPage + 1} of $_pageCount',
      child: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth >= AppBreakpoints.compact
            ? _buildTabletLayout(context, pages)
            : _buildCompactLayout(context, pages),
      ),
    );
  }

  // ── Compact (phone) layout ────────────────────────────────────────────────

  Widget _buildCompactLayout(
    BuildContext context,
    List<_OnboardingPageData> pages,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final pageData = pages[_currentPage];
    final onColor = pageData.onColor(colorScheme);

    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _previous();
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildPageSwitcher(pages, (d) => _CompactOnboardingPage(data: d)),
            if (_currentPage > 0) _buildCompactBackButton(context, onColor),
            if (_currentPage < pages.length - 1)
              _buildCompactSkipButton(context, onColor),
            _buildCompactBottomBar(
              context,
              pages,
              pageData,
              onColor,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactBackButton(BuildContext context, Color onColor) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: IconButton(
        onPressed: _previous,
        icon: Icon(Icons.arrow_back, color: onColor.withValues(alpha: 0.7)),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
    );
  }

  Widget _buildCompactSkipButton(BuildContext context, Color onColor) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 8,
      child: TextButton(
        onPressed: _skip,
        child: Text(
          context.l10n.onboardSkip,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: onColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactBottomBar(
    BuildContext context,
    List<_OnboardingPageData> pages,
    _OnboardingPageData pageData,
    Color onColor,
    ColorScheme colorScheme,
  ) {
    final isLast = _currentPage == pages.length - 1;
    final label = isLast
        ? context.l10n.onboardLetsGo
        : context.l10n.onboardNext;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageIndicator(onColor, onColor.withValues(alpha: 0.38)),
              const SizedBox(height: AppSpacing.lg),
              _buildFilledButton(
                label: label,
                backgroundColor: onColor,
                foregroundColor: pageData.gradientColors(colorScheme).first,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tablet (≥ 600dp) layout — M3 supporting-pane canonical layout ─────────

  Widget _buildTabletLayout(
    BuildContext context,
    List<_OnboardingPageData> pages,
  ) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _previous();
      },
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildPageSwitcher(pages, (d) => _TabletLeftPane(data: d)),
            ),
            Expanded(flex: 3, child: _buildTabletRightPane(context, pages)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletRightPane(
    BuildContext context,
    List<_OnboardingPageData> pages,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final pageData = pages[_currentPage];
    final mainColor = pageData.gradientColors(colorScheme).first;
    final onColor = pageData.onColor(colorScheme);
    final isLast = _currentPage == pages.length - 1;
    final label = isLast
        ? context.l10n.onboardLetsGo
        : context.l10n.onboardNext;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabletNavRow(context, pages),
              Expanded(
                child: _buildPageSwitcher(
                  pages,
                  (d) => _TabletRightContent(data: d),
                ),
              ),
              _buildPageIndicator(
                mainColor,
                colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildFilledButton(
                label: label,
                backgroundColor: mainColor,
                foregroundColor: onColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletNavRow(
    BuildContext context,
    List<_OnboardingPageData> pages,
  ) {
    return Row(
      children: [
        if (_currentPage > 0)
          IconButton(
            onPressed: _previous,
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          )
        else
          const SizedBox(width: 48),
        const Spacer(),
        if (_currentPage < pages.length - 1)
          TextButton(onPressed: _skip, child: Text(context.l10n.onboardSkip))
        else
          const SizedBox(height: 48),
      ],
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

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

  List<Color> gradientColors(ColorScheme cs) => switch (colorRole) {
    _ColorRole.primary => [cs.primary, cs.primary.withValues(alpha: 0.7)],
    _ColorRole.secondary => [cs.secondary, cs.secondary.withValues(alpha: 0.7)],
    _ColorRole.tertiary => [cs.tertiary, cs.tertiary.withValues(alpha: 0.7)],
  };

  Color onColor(ColorScheme cs) => switch (colorRole) {
    _ColorRole.primary => cs.onPrimary,
    _ColorRole.secondary => cs.onSecondary,
    _ColorRole.tertiary => cs.onTertiary,
  };
}

// ── Page widgets ─────────────────────────────────────────────────────────────

/// Phone layout: full-screen gradient page.
/// Wrapped in [SizedBox.expand] to fill parent even under loose Stack constraints.
class _CompactOnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _CompactOnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onColor = data.onColor(colorScheme);

    return SizedBox.expand(
      child: Container(
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
                Text(
                  data.subtitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: onColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  data.title,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: onColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Text(data.emoji, style: const TextStyle(fontSize: 96)),
                const SizedBox(height: 40),
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
      ),
    );
  }
}

/// Tablet left decorative pane: gradient background with oversized emoji.
/// Wrapped in [SizedBox.expand] to fill the [Expanded] flex column.
class _TabletLeftPane extends StatelessWidget {
  final _OnboardingPageData data;

  const _TabletLeftPane({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onColor = data.onColor(colorScheme);

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: data.gradientColors(colorScheme),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.emoji, style: const TextStyle(fontSize: 120)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Hachimi',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tablet right content pane: text content that transitions per page.
class _TabletRightContent extends StatelessWidget {
  final _OnboardingPageData data;

  const _TabletRightContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.subtitle,
          style: textTheme.titleMedium?.copyWith(
            color: onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          data.title,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          data.body,
          style: textTheme.bodyLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.85),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
