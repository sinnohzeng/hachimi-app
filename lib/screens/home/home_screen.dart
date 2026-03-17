import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/awareness/awareness_screen.dart';
import 'package:hachimi_app/screens/cat_room/cat_room_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';
import 'package:hachimi_app/widgets/app_drawer.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';

import 'components/today_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    AwarenessScreen(), // Tab 0: 觉知（默认）
    TodayTab(), // Tab 1: 习惯
    CatRoomScreen(), // Tab 2: 猫咪
    ProfileScreen(), // Tab 3: 我的
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
    return AppScaffold(
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
    return AppScaffold(
      drawer: const AppDrawer(),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            groupAlignment: -0.85,
            leading: _selectedIndex == 1 ? _buildFab(context) : null,
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
    return IndexedStack(index: _selectedIndex, children: _screens);
  }

  Widget? _buildFab(BuildContext context) {
    if (_selectedIndex != 1) return null;
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
        icon: const Icon(Icons.auto_awesome_outlined),
        selectedIcon: const Icon(Icons.auto_awesome),
        label: l10n.homeTabAwareness,
      ),
      NavigationDestination(
        icon: const Icon(Icons.today_outlined),
        selectedIcon: const Icon(Icons.today),
        label: l10n.homeTabHabits,
      ),
      NavigationDestination(
        icon: const Icon(Icons.pets_outlined),
        selectedIcon: const Icon(Icons.pets),
        label: l10n.homeTabCatHouse,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.homeTabProfile,
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(BuildContext context) {
    final l10n = context.l10n;
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.auto_awesome_outlined),
        selectedIcon: const Icon(Icons.auto_awesome),
        label: Text(l10n.homeTabAwareness),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.today_outlined),
        selectedIcon: const Icon(Icons.today),
        label: Text(l10n.homeTabHabits),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.pets_outlined),
        selectedIcon: const Icon(Icons.pets),
        label: Text(l10n.homeTabCatHouse),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.homeTabProfile),
      ),
    ];
  }
}
