import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/screens/achievements/components/achievement_card.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';
import 'package:hachimi_app/screens/achievements/components/achievement_summary.dart';
import 'package:hachimi_app/screens/achievements/components/overview_tab.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';

/// 成就页面 — 底部导航 Tab 2，替代原 StatsScreen。
/// 包含 4 个 Tab：概览、任务、猫咪、坚持。
class AchievementScreen extends ConsumerStatefulWidget {
  const AchievementScreen({super.key});

  @override
  ConsumerState<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends ConsumerState<AchievementScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(l10n.achievementTitle),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.sessionHistory),
                tooltip: l10n.historyTitle,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: l10n.achievementTabOverview),
                Tab(text: l10n.achievementTabQuest),
                Tab(text: l10n.achievementTabCat),
                Tab(text: l10n.achievementTabPersist),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            OverviewTab(),
            _AchievementListTab(category: AchievementCategory.quest),
            _AchievementListTab(category: AchievementCategory.cat),
            _AchievementListTab(category: AchievementCategory.persist),
          ],
        ),
      ),
    );
  }
}

/// 成就列表 Tab — 按分类显示成就卡片网格。
/// M3 Feed Layout：使用 maxCrossAxisExtent 自适应列数。
class _AchievementListTab extends ConsumerWidget {
  final String category;

  const _AchievementListTab({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedIdsProvider);
    final progressMap = ref.watch(achievementProgressProvider);
    final sorted = _sortedDefs(category, unlockedIds);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isExpanded = constraints.maxWidth >= AppBreakpoints.expanded;
        final margin = isExpanded ? AppSpacing.lg : 0.0;

        return CustomScrollView(
          slivers: [
            // Summary card — 宽屏居中约束，保持可读性
            const SliverToBoxAdapter(
              child: ContentWidthConstraint(child: AchievementSummary()),
            ),
            // Achievement grid — 使用全宽，列数自适应
            SliverPadding(
              padding: EdgeInsets.fromLTRB(margin, 8, margin, 80),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisExtent: 100,
                  crossAxisSpacing: isExpanded ? 16 : 0,
                  mainAxisSpacing: 0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => StaggeredListItem(
                    index: index,
                    child: AchievementCard(
                      def: sorted[index],
                      isUnlocked: unlockedIds.contains(sorted[index].id),
                      progress: progressMap[sorted[index].id],
                    ),
                  ),
                  childCount: sorted.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static List<AchievementDef> _sortedDefs(
    String category,
    Set<String> unlockedIds,
  ) {
    return List<AchievementDef>.from(
      AchievementDefinitions.byCategory(category),
    )..sort((a, b) {
      final aUnlocked = unlockedIds.contains(a.id);
      final bUnlocked = unlockedIds.contains(b.id);
      if (aUnlocked != bUnlocked) return aUnlocked ? -1 : 1;
      return (a.targetValue ?? 0).compareTo(b.targetValue ?? 0);
    });
  }
}
