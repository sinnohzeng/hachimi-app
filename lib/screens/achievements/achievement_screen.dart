import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/screens/achievements/components/achievement_card.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';
import 'package:hachimi_app/screens/achievements/components/achievement_summary.dart';
import 'package:hachimi_app/screens/achievements/components/overview_tab.dart';

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

/// 成就列表 Tab — 按分类显示成就卡片列表。
class _AchievementListTab extends ConsumerWidget {
  final String category;

  const _AchievementListTab({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedIds = ref.watch(unlockedIdsProvider);
    final progressMap = ref.watch(achievementProgressProvider);
    final defs = AchievementDefinitions.byCategory(category);

    // 排序：已解锁在前，未解锁按 targetValue 排序
    final sorted = List<AchievementDef>.from(defs)
      ..sort((a, b) {
        final aUnlocked = unlockedIds.contains(a.id);
        final bUnlocked = unlockedIds.contains(b.id);
        if (aUnlocked != bUnlocked) return aUnlocked ? -1 : 1;
        return (a.targetValue ?? 0).compareTo(b.targetValue ?? 0);
      });

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: sorted.length + 1, // +1 for summary header
      itemBuilder: (context, index) {
        if (index == 0) return const AchievementSummary();

        final def = sorted[index - 1];
        return StaggeredListItem(
          index: index - 1,
          child: AchievementCard(
            def: def,
            isUnlocked: unlockedIds.contains(def.id),
            progress: progressMap[def.id],
          ),
        );
      },
    );
  }
}
