import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/cat_room/cat_room_screen.dart';
import 'package:hachimi_app/screens/achievements/achievement_screen.dart';
import 'package:hachimi_app/widgets/app_drawer.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.compact) {
          return _buildMediumLayout(context);
        }
        return _buildCompactLayout(context);
      },
    );
  }

  // --- Compact: 手机竖屏 — NavigationBar（底部） ---

  Widget _buildCompactLayout(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: _buildBody(),
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _buildNavDestinations(context),
      ),
    );
  }

  // --- Medium/Expanded: 平板 — NavigationRail（侧边） ---

  Widget _buildMediumLayout(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            groupAlignment: -0.85,
            leading: _selectedIndex == 0 ? _buildFab(context) : null,
            destinations: _buildRailDestinations(context),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // --- 共享组件 ---

  Widget _buildBody() {
    return PageTransitionSwitcher(
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
    );
  }

  Widget? _buildFab(BuildContext context) {
    if (_selectedIndex != 0) return null;
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pushNamed(AppRouter.adoption),
      tooltip: context.l10n.todayNewQuest,
      child: const Icon(Icons.add),
    );
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  List<NavigationDestination> _buildNavDestinations(BuildContext context) {
    final l10n = context.l10n;
    return [
      NavigationDestination(
        icon: const Icon(Icons.today_outlined),
        selectedIcon: const Icon(Icons.today),
        label: l10n.homeTabToday,
      ),
      NavigationDestination(
        icon: const Icon(Icons.pets_outlined),
        selectedIcon: const Icon(Icons.pets),
        label: l10n.homeTabCatHouse,
      ),
      NavigationDestination(
        icon: const Icon(Icons.emoji_events_outlined),
        selectedIcon: const Icon(Icons.emoji_events),
        label: l10n.homeTabAchievements,
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(BuildContext context) {
    final l10n = context.l10n;
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.today_outlined),
        selectedIcon: const Icon(Icons.today),
        label: Text(l10n.homeTabToday),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.pets_outlined),
        selectedIcon: const Icon(Icons.pets),
        label: Text(l10n.homeTabCatHouse),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.emoji_events_outlined),
        selectedIcon: const Icon(Icons.emoji_events),
        label: Text(l10n.homeTabAchievements),
      ),
    ];
  }
}
