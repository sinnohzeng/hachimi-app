import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/screens/onboarding/components/onboarding_cat_cluster.dart';
import 'package:hachimi_app/screens/onboarding/components/onboarding_cat_hero.dart';
import 'package:hachimi_app/screens/onboarding/components/onboarding_stage_strip.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/widgets/particle_overlay.dart';

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

  late final CatAppearance _heroCat;
  late final List<CatAppearance> _clusterCats;

  @override
  void initState() {
    super.initState();
    final gen = ref.read(pixelCatGenerationServiceProvider);
    _heroCat = gen.generateRandomAppearance();
    _clusterCats = List.generate(3, (_) => gen.generateRandomAppearance());
  }

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
    ref.read(analyticsServiceProvider).logOnboardingCompleted();
    widget.onComplete();
  }

  Widget _buildHero(int page) => switch (page) {
    0 => OnboardingCatHero(appearance: _heroCat),
    1 => OnboardingStageStrip(appearance: _heroCat),
    2 => OnboardingCatCluster(appearances: _clusterCats),
    _ => const SizedBox.shrink(),
  };

  String _title(int page, BuildContext context) => switch (page) {
    0 => context.l10n.onboardTitle1,
    1 => context.l10n.onboardTitle2,
    2 => context.l10n.onboardTitle3,
    _ => '',
  };

  String _subtitle(int page, BuildContext context) => switch (page) {
    0 => context.l10n.onboardSubtitle1,
    1 => context.l10n.onboardSubtitle2,
    2 => context.l10n.onboardSubtitle3,
    _ => '',
  };

  String _body(int page, BuildContext context) => switch (page) {
    0 => context.l10n.onboardBody1,
    1 => context.l10n.onboardBody2,
    2 => context.l10n.onboardBody3,
    _ => '',
  };

  Widget _buildPageSwitcher(Widget Function(int) builder) {
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
        child: builder(_currentPage),
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

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${_currentPage + 1} of $_pageCount',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet =
              constraints.maxWidth >= AppBreakpoints.compact &&
              constraints.maxHeight >= 500;
          return isTablet
              ? _buildTabletLayout(context)
              : _buildCompactLayout(context);
        },
      ),
    );
  }

  // -- Compact (phone) layout ------------------------------------------------

  Widget _buildCompactLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _previous();
      },
      child: AppScaffold(
        body: Stack(
          children: [
            const ParticleOverlay(
              mode: ParticleMode.firefly,
              child: SizedBox.expand(),
            ),
            _buildPageSwitcher(
              (page) => _CompactPage(
                hero: _buildHero(page),
                title: _title(page, context),
                subtitle: _subtitle(page, context),
                body: _body(page, context),
              ),
            ),
            if (_currentPage > 0) _buildBackButton(context),
            if (_currentPage < _pageCount - 1) _buildSkipButton(context),
            _buildCompactBottomBar(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8,
      left: 8,
      child: IconButton(
        onPressed: _previous,
        icon: Icon(Icons.arrow_back, color: color.withValues(alpha: 0.7)),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8,
      right: 8,
      child: TextButton(
        onPressed: _skip,
        child: Text(
          context.l10n.onboardSkip,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: color.withValues(alpha: 0.7)),
        ),
      ),
    );
  }

  Widget _buildCompactBottomBar(BuildContext context, ColorScheme colorScheme) {
    final isLast = _currentPage == _pageCount - 1;
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
              _buildPageIndicator(
                colorScheme.primary,
                colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildCtaButton(label, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCtaButton(String label, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _next,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppShape.borderLarge),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  // -- Tablet (>= 600dp width + >= 500dp height) layout ---------------------

  Widget _buildTabletLayout(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _previous();
      },
      child: AppScaffold(
        body: Row(
          children: [
            Expanded(flex: 2, child: _buildTabletLeftPane(context)),
            Expanded(flex: 3, child: _buildTabletRightPane(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLeftPane(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        SizedBox.expand(
          child: ColoredBox(color: colorScheme.surfaceContainerLow),
        ),
        const ParticleOverlay(
          mode: ParticleMode.firefly,
          child: SizedBox.expand(),
        ),
        Center(child: _buildPageSwitcher(_buildHero)),
      ],
    );
  }

  Widget _buildTabletRightPane(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = _currentPage == _pageCount - 1;
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
              _buildTabletNavRow(context),
              Expanded(
                child: _buildPageSwitcher(
                  (page) => _TabletTextContent(
                    title: _title(page, context),
                    subtitle: _subtitle(page, context),
                    body: _body(page, context),
                  ),
                ),
              ),
              _buildPageIndicator(
                colorScheme.primary,
                colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildCtaButton(label, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletNavRow(BuildContext context) {
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
        if (_currentPage < _pageCount - 1)
          TextButton(onPressed: _skip, child: Text(context.l10n.onboardSkip))
        else
          const SizedBox(height: 48),
      ],
    );
  }
}

// -- Compact page content widget ---------------------------------------------

class _CompactPage extends StatelessWidget {
  final Widget hero;
  final String title;
  final String subtitle;
  final String body;

  const _CompactPage({
    required this.hero,
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Flexible(flex: 4, child: Center(child: hero)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                subtitle,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              Flexible(
                flex: 2,
                child: Text(
                  body,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

// -- Tablet text content widget ----------------------------------------------

class _TabletTextContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String body;

  const _TabletTextContent({
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: textTheme.titleMedium?.copyWith(
            color: onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          body,
          style: textTheme.bodyLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.85),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
