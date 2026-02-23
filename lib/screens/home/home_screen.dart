import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/cat_room/cat_room_screen.dart';
import 'package:hachimi_app/screens/achievements/achievement_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';

import 'components/today_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    TodayTab(),
    CatRoomScreen(),
    AchievementScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 成就庆祝已移至全局 AchievementCelebrationLayer（app.dart）

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: AppMotion.durationMedium2,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRouter.adoption),
              tooltip: context.l10n.todayNewQuest,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: context.l10n.homeTabToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pets_outlined),
            selectedIcon: const Icon(Icons.pets),
            label: context.l10n.homeTabCatHouse,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: context.l10n.homeTabAchievements,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: context.l10n.homeTabProfile,
          ),
        ],
      ),
    );
  }
}
