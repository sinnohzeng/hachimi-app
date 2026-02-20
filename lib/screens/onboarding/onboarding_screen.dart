import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/app.dart' show kOnboardingCompleteKey;

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPageData(
      emoji: '🐱',
      title: 'Welcome to Hachimi',
      subtitle: 'Raise cats, complete quests',
      body: 'Every quest you start comes with a kitten.\n'
          'Focus on your goals and watch them grow\n'
          'from tiny kittens into shiny cats!',
      gradientColors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
    ),
    _OnboardingPageData(
      emoji: '⏱️',
      title: 'Focus & Earn XP',
      subtitle: 'Time fuels growth',
      body: 'Start a focus session and your cat earns XP.\n'
          'Build streaks for bonus rewards.\n'
          'Every minute counts toward evolution!',
      gradientColors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
    ),
    _OnboardingPageData(
      emoji: '✨',
      title: 'Watch Them Evolve',
      subtitle: 'Kitten → Shiny',
      body: 'Cats evolve through 4 stages as they grow.\n'
          'Collect different breeds, unlock rare cats,\n'
          'and fill your cozy cat room!',
      gradientColors: [Color(0xFFEF5350), Color(0xFFC62828)],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboardingCompleteKey, true);
    widget.onComplete();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                _OnboardingPage(data: _pages[index]),
          ),

          // Skip button (top right, hidden on last page)
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
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
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Next / Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _pages[_currentPage]
                              .gradientColors
                              .first,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? "Let's Go!"
                              : 'Next',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _pages[_currentPage].gradientColors.first,
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

class _OnboardingPageData {
  final String emoji;
  final String title;
  final String subtitle;
  final String body;
  final List<Color> gradientColors;

  const _OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.gradientColors,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: data.gradientColors,
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
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                data.title,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Emoji
              Text(
                data.emoji,
                style: const TextStyle(fontSize: 96),
              ),
              const SizedBox(height: 40),

              // Body
              Text(
                data.body,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
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
