import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/awareness/worry_item_card.dart';
import 'package:hachimi_app/widgets/error_state.dart';

/// 烦恼处理器 — 查看、管理所有进行中和已终结的烦恼。
class WorryProcessorScreen extends ConsumerWidget {
  const WorryProcessorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeAsync = ref.watch(activeWorriesProvider);
    final resolvedAsync = ref.watch(resolvedWorriesProvider);

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.worryProcessorTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRouter.worryEdit),
        tooltip: l10n.worryAdd,
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // 进行中
          activeAsync.when(
            data: (worries) => _buildActiveSection(context, ref, worries),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(activeWorriesProvider),
              ),
            ),
          ),
          // 分割线
          const SliverToBoxAdapter(child: Divider(height: AppSpacing.xl)),
          // 已终结
          resolvedAsync.when(
            data: (worries) => _buildResolvedSection(context, ref, worries),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  context.l10n.awarenessLoadFailed,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
          // 底部安全间距
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }

  Widget _buildActiveSection(
    BuildContext context,
    WidgetRef ref,
    List<Worry> worries,
  ) {
    if (worries.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(context));
    }

    return SliverPadding(
      padding: AppSpacing.paddingHBase,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: AppSpacing.paddingVXs,
            child: WorryItemCard(
              worry: worries[index],
              onStatusChanged: (status) =>
                  _resolveWorry(ref, context, worries[index].id, status),
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRouter.worryEdit, arguments: worries[index].id),
            ),
          ),
          childCount: worries.length,
        ),
      ),
    );
  }

  Widget _buildResolvedSection(
    BuildContext context,
    WidgetRef ref,
    List<Worry> worries,
  ) {
    if (worries.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: AppSpacing.paddingHBase,
        child: ExpansionTile(
          title: Text(context.l10n.worryResolvedSection),
          initiallyExpanded: false,
          children: worries
              .map(
                (w) => Padding(
                  padding: AppSpacing.paddingVXs,
                  child: WorryItemCard(
                    worry: w,
                    onStatusChanged: (status) =>
                        _resolveWorry(ref, context, w.id, status),
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRouter.worryEdit, arguments: w.id),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: AppSpacing.paddingXl,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_satisfied_alt,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.awarenessEmptyWorriesTitle,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.awarenessEmptyWorriesSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    if (uid == null) {
      debugPrint('[Awareness] resolveWorry called with null uid');
      return;
    }
    try {
      await ref.read(worryRepositoryProvider).resolve(uid, worryId, status);
    } on Exception catch (e) {
      debugPrint('[WorryProcessor] Resolve worry failed: $e');
      if (context.mounted) {
        AppFeedback.error(context, context.l10n.awarenessSaveFailed);
      }
    }
  }
}
