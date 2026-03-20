import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/lumi_feature.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/providers/feature_gate_provider.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/journey/annual_calendar_card.dart';
import 'package:hachimi_app/widgets/journey/growth_plan_card.dart';
import 'package:hachimi_app/widgets/journey/habit_trackers_card.dart';
import 'package:hachimi_app/widgets/journey/lists_overview_card.dart';
import 'package:hachimi_app/widgets/journey/monthly_calendar_card.dart';
import 'package:hachimi_app/widgets/journey/monthly_goals_card.dart';
import 'package:hachimi_app/widgets/journey/monthly_memory_card.dart';
import 'package:hachimi_app/widgets/journey/mood_tracker_card.dart';
import 'package:hachimi_app/widgets/journey/small_win_challenge_card.dart';
import 'package:hachimi_app/widgets/journey/week_mood_dots.dart';
import 'package:hachimi_app/widgets/journey/weekly_plan_card.dart';
import 'package:hachimi_app/widgets/journey/weekly_review_card.dart';
import 'package:hachimi_app/widgets/journey/worry_jar_card.dart';
import 'package:hachimi_app/widgets/journey/yearly_messages_card.dart';
import 'package:hachimi_app/widgets/lumi/feature_locked_card.dart';

/// 旅程时间尺度枚举。
enum _JourneySegment { week, month, year, explore }

/// 旅程页 — Tab 1，SegmentedButton 切换周/月/年/探索视角。
class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  _JourneySegment _segment = _JourneySegment.week;

  @override
  Widget build(BuildContext context) {
    final gates = ref.watch(featureGateProvider);
    final showExplore = gates[LumiFeature.monthlyActivities] ?? false;
    final l10n = context.l10n;

    return ContentWidthConstraint(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(l10n.journeyTitle),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingHBase,
              child: SegmentedButton<_JourneySegment>(
                segments: [
                  ButtonSegment(
                    value: _JourneySegment.week,
                    label: Text(l10n.journeySegmentWeek),
                  ),
                  ButtonSegment(
                    value: _JourneySegment.month,
                    label: Text(l10n.journeySegmentMonth),
                  ),
                  ButtonSegment(
                    value: _JourneySegment.year,
                    label: Text(l10n.journeySegmentYear),
                  ),
                  if (showExplore)
                    ButtonSegment(
                      value: _JourneySegment.explore,
                      label: Text(l10n.journeySegmentExplore),
                    ),
                ],
                selected: {_segment},
                onSelectionChanged: (s) => setState(() => _segment = s.first),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          _buildSegmentContent(gates),
        ],
      ),
    );
  }

  Widget _buildSegmentContent(Map<LumiFeature, bool> gates) {
    final l10n = context.l10n;
    return switch (_segment) {
      _JourneySegment.week => _buildWeekContent(),
      _JourneySegment.month => _buildGatedContent(
        gates,
        LumiFeature.monthlyView,
        l10n.journeyMonthlyView,
        _buildMonthContent,
      ),
      _JourneySegment.year => _buildGatedContent(
        gates,
        LumiFeature.yearlyPlan,
        l10n.journeyYearlyView,
        _buildYearContent,
      ),
      _JourneySegment.explore => _buildGatedContent(
        gates,
        LumiFeature.monthlyActivities,
        l10n.journeyExploreActivities,
        _buildExploreContent,
      ),
    };
  }

  Widget _buildWeekContent() {
    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          WeeklyPlanCard(
            onTap: () => Navigator.of(context).pushNamed(AppRouter.weeklyPlan),
          ),
          const SizedBox(height: AppSpacing.sm),
          const WeeklyReviewCard(),
          const SizedBox(height: AppSpacing.sm),
          const WorryJarCard(),
          const SizedBox(height: AppSpacing.md),
          const WeekMoodDotsRow(),
          const SizedBox(height: AppSpacing.xxl),
        ]),
      ),
    );
  }

  Widget _buildMonthContent() {
    final l10n = context.l10n;
    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const MonthlyCalendarCard(),
          const SizedBox(height: AppSpacing.sm),
          const MonthlyGoalsCard(),
          const SizedBox(height: AppSpacing.sm),
          const SmallWinChallengeCard(),
          const SizedBox(height: AppSpacing.sm),
          const HabitTrackersCard(),
          const SizedBox(height: AppSpacing.sm),
          const MoodTrackerCard(),
          const SizedBox(height: AppSpacing.sm),
          const MonthlyMemoryCard(),
          const SizedBox(height: AppSpacing.md),
          // 编辑入口
          FilledButton.tonalIcon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.monthlyPlan),
            icon: const Icon(Icons.edit_outlined),
            label: Text(l10n.journeyEditMonthlyPlan),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ]),
      ),
    );
  }

  Widget _buildYearContent() {
    final l10n = context.l10n;
    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const YearlyMessagesCard(),
          const SizedBox(height: AppSpacing.sm),
          const GrowthPlanCard(),
          const SizedBox(height: AppSpacing.sm),
          const AnnualCalendarCard(),
          const SizedBox(height: AppSpacing.sm),
          const ListsOverviewCard(),
          const SizedBox(height: AppSpacing.md),
          // 编辑入口
          FilledButton.tonalIcon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRouter.yearlyPlan),
            icon: const Icon(Icons.edit_outlined),
            label: Text(l10n.journeyEditYearlyPlan),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ]),
      ),
    );
  }

  Widget _buildExploreContent() {
    final l10n = context.l10n;
    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // 高光时刻入口
          _ExploreActivityCard(
            icon: Icons.auto_awesome_outlined,
            title: l10n.exploreMyMoments,
            description: l10n.exploreMyMomentsDesc,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRouter.highlightMoments),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 6 个月度活动
          _ExploreActivityCard(
            icon: Icons.handshake_outlined,
            title: l10n.exploreHabitPact,
            description: l10n.exploreHabitPactDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.habitPact),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExploreActivityCard(
            icon: Icons.cloud_off_outlined,
            title: l10n.exploreWorryUnload,
            description: l10n.exploreWorryUnloadDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.worryUnload),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExploreActivityCard(
            icon: Icons.thumb_up_outlined,
            title: l10n.exploreSelfPraise,
            description: l10n.exploreSelfPraiseDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.selfPraise),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExploreActivityCard(
            icon: Icons.people_outline,
            title: l10n.exploreSupportMap,
            description: l10n.exploreSupportMapDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.supportMap),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExploreActivityCard(
            icon: Icons.remove_red_eye_outlined,
            title: l10n.exploreFutureSelf,
            description: l10n.exploreFutureSelfDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.futureSelf),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExploreActivityCard(
            icon: Icons.compare_outlined,
            title: l10n.exploreIdealVsReal,
            description: l10n.exploreIdealVsRealDesc,
            onTap: () => Navigator.of(context).pushNamed(AppRouter.idealVsReal),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ]),
      ),
    );
  }

  /// 带功能门控的内容 — 解锁时显示实际内容，未解锁时显示锁定卡片。
  Widget _buildGatedContent(
    Map<LumiFeature, bool> gates,
    LumiFeature feature,
    String name,
    Widget Function() contentBuilder,
  ) {
    final unlocked = gates[feature] ?? false;

    if (unlocked) return contentBuilder();

    final statsAsync = ref.watch(awarenessStatsProvider);
    final currentDays =
        statsAsync.whenData((s) => s['totalLightDays'] ?? 0).value ?? 0;

    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverToBoxAdapter(
        child: FeatureLockedCard(
          requiredDays: feature.requiredDays,
          currentDays: currentDays,
          featureName: name,
        ),
      ),
    );
  }
}

/// 探索活动卡片 — 标题 + 描述 + 图标，点击进入活动页。
class _ExploreActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExploreActivityCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShape.borderMedium,
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(icon, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.bodyLarge),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
