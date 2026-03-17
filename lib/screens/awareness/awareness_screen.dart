import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/daily_light.dart';
import 'package:hachimi_app/models/weekly_review.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/awareness/worry_item_card.dart';
import 'package:hachimi_app/widgets/awareness/monthly_ritual_card.dart';
import 'package:hachimi_app/widgets/error_state.dart';
import 'package:hachimi_app/screens/awareness/awareness_history_screen.dart';

/// 觉知主页 — 三子标签（今天 / 本周 / 回顾）。
class AwarenessScreen extends ConsumerStatefulWidget {
  const AwarenessScreen({super.key});

  @override
  ConsumerState<AwarenessScreen> createState() => _AwarenessScreenState();
}

class _AwarenessScreenState extends ConsumerState<AwarenessScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(l10n.awarenessTitle),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.awarenessTabToday),
                Tab(text: l10n.awarenessTabThisWeek),
                Tab(text: l10n.awarenessTabReview),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            _TodaySubTab(),
            _ThisWeekSubTab(),
            AwarenessHistoryScreen(),
          ],
        ),
      ),
    );
  }
}

// ─── 今天 ───

/// 今天子标签 — 今日一光状态 + 习惯速览。
class _TodaySubTab extends ConsumerWidget {
  const _TodaySubTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLight = ref.watch(todayLightProvider);

    return ListView(
      padding: AppSpacing.paddingScreenBody,
      children: [
        todayLight.when(
          data: (light) => light != null
              ? _LightStatusCard(light: light)
              : _AwarenessEmptyState(
                  title: context.l10n.awarenessEmptyLightTitle,
                  subtitle: context.l10n.awarenessEmptyLightSubtitle,
                  actionLabel: context.l10n.awarenessEmptyLightAction,
                  onAction: () =>
                      Navigator.of(context).pushNamed(AppRouter.dailyLight),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(todayLightProvider),
          ),
        ),
        // 月度仪式卡片
        const SizedBox(height: AppSpacing.md),
        const MonthlyRitualCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildHabitsSection(context, ref),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.paddingVSm,
          child: Text(
            l10n.awarenessHabitsSection,
            style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
          ),
        ),
        habitsAsync.when(
          data: (habits) {
            if (habits.isEmpty) {
              return Padding(
                padding: AppSpacing.paddingVBase,
                child: Text(
                  l10n.awarenessHabitsEmpty,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return Column(
              children: habits
                  .map(
                    (h) => ListTile(
                      title: Text(h.name),
                      subtitle: Text(
                        '${h.goalMinutes} min',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      leading: Icon(Icons.pets, color: colorScheme.primary),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRouter.habitDetail, arguments: h.id),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(habitsProvider),
          ),
        ),
      ],
    );
  }
}

// ─── 本周 ───

/// 本周子标签 — 周回顾状态 + 烦恼列表。
class _ThisWeekSubTab extends ConsumerWidget {
  const _ThisWeekSubTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekReview = ref.watch(currentWeekReviewProvider);
    final worriesAsync = ref.watch(activeWorriesProvider);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: AppSpacing.paddingScreenBody,
      children: [
        // 周回顾
        weekReview.when(
          data: (review) => review != null
              ? _WeeklyReviewSummaryCard(review: review)
              : _AwarenessEmptyState(
                  title: l10n.awarenessEmptyReviewTitle,
                  subtitle: l10n.awarenessEmptyReviewSubtitle,
                  actionLabel: l10n.awarenessEmptyReviewAction,
                  onAction: () =>
                      Navigator.of(context).pushNamed(AppRouter.weeklyReview),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(currentWeekReviewProvider),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // 烦恼区域
        Padding(
          padding: AppSpacing.paddingVSm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.worryProcessorTitle,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.worryProcessor),
                child: Text(l10n.worryManageAll),
              ),
            ],
          ),
        ),
        worriesAsync.when(
          data: (worries) {
            if (worries.isEmpty) {
              return Padding(
                padding: AppSpacing.paddingVBase,
                child: Column(
                  children: [
                    Text(
                      l10n.awarenessEmptyWorriesTitle,
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      l10n.awarenessEmptyWorriesSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: worries
                  .map((w) => _buildWorryCard(context, ref, w))
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(activeWorriesProvider),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(AppRouter.worryEdit),
          icon: const Icon(Icons.add),
          label: Text(l10n.worryAdd),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildWorryCard(BuildContext context, WidgetRef ref, Worry worry) {
    return Padding(
      padding: AppSpacing.paddingVXs,
      child: WorryItemCard(
        worry: worry,
        onStatusChanged: (status) =>
            _resolveWorry(ref, context, worry.id, status),
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRouter.worryEdit, arguments: worry.id),
      ),
    );
  }

  Future<void> _resolveWorry(
    WidgetRef ref,
    BuildContext context,
    String worryId,
    WorryStatus status,
  ) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    try {
      await ref.read(worryRepositoryProvider).resolve(uid, worryId, status);
    } on Exception catch (e) {
      debugPrint('[Awareness] Resolve worry failed: $e');
      if (context.mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    }
  }
}

// ─── 共享组件 ───

/// 今日一光状态卡 — 显示已记录的心情和文本预览。
class _LightStatusCard extends StatelessWidget {
  final DailyLight light;

  const _LightStatusCard({required this.light});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Row(
          children: [
            Text(light.mood.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                light.lightText ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRouter.dailyLight,
                arguments: <String, dynamic>{'quickMode': false},
              ),
              tooltip: context.l10n.awarenessLightEdit,
            ),
          ],
        ),
      ),
    );
  }
}

/// 周回顾摘要卡 — 显示已填写的幸福时刻和完成状态。
class _WeeklyReviewSummaryCard extends StatelessWidget {
  final WeeklyReview review;

  const _WeeklyReviewSummaryCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed(AppRouter.weeklyReview),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    review.isComplete
                        ? Icons.check_circle
                        : Icons.pending_outlined,
                    color: review.isComplete
                        ? colorScheme.primary
                        : colorScheme.outline,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n.weeklyReviewTitle,
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${review.filledMomentCount}/3',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 觉知空状态 — 标题 + 描述 + 操作按钮。
class _AwarenessEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _AwarenessEmptyState({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
