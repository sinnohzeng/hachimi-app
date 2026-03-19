import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/screens/today/today_screen.dart';
import 'package:hachimi_app/screens/journey/journey_screen.dart';
import 'package:hachimi_app/screens/profile/profile_screen.dart';
import 'package:hachimi_app/widgets/app_drawer.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    TodayScreen(), // Tab 0: 今天
    JourneyScreen(), // Tab 1: 旅程
    ProfileScreen(), // Tab 2: 我的
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
    return IndexedStack(index: _selectedIndex, children: _screens);
  }

  Widget? _buildFab(BuildContext context) {
    // FAB 仅在「今天」Tab 显示，用于快速新建习惯
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
        icon: const Icon(Icons.star_outline),
        selectedIcon: const Icon(Icons.star),
        label: l10n.homeTabToday,
      ),
      NavigationDestination(
        icon: const Icon(Icons.explore_outlined),
        selectedIcon: const Icon(Icons.explore),
        label: l10n.tabJourney,
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.tabProfile,
      ),
    ];
  }

  List<NavigationRailDestination> _buildRailDestinations(BuildContext context) {
    final l10n = context.l10n;
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.star_outline),
        selectedIcon: const Icon(Icons.star),
        label: Text(l10n.homeTabToday),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.explore_outlined),
        selectedIcon: const Icon(Icons.explore),
        label: Text(l10n.tabJourney),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: Text(l10n.tabProfile),
      ),
    ];
  }
}
