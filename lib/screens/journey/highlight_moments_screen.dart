import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/highlight_entry.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/list_highlight_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/widgets/journey/moment_card.dart';
import 'package:hachimi_app/widgets/journey/moment_edit_dialog.dart';

/// 高光时刻页 — 幸福时刻/高光时刻双 Tab 列表。
class HighlightMomentsScreen extends ConsumerWidget {
  const HighlightMomentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        appBar: AppBar(
          title: Text(context.l10n.highlightScreenTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.highlightTabHappy),
              Tab(text: context.l10n.highlightTabHighlight),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MomentListTab(type: HighlightType.happy),
            _MomentListTab(type: HighlightType.highlight),
          ],
        ),
      ),
    );
  }
}

class _MomentListTab extends ConsumerWidget {
  final HighlightType type;

  const _MomentListTab({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = type == HighlightType.happy
        ? ref.watch(happyMomentsProvider)
        : ref.watch(highlightMomentsProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        debugPrint('[HighlightMomentsScreen] Error: $e');
        return Center(
          child: Text(context.l10n.highlightLoadError(e.toString())),
        );
      },
      data: (entries) => _buildContent(context, ref, entries),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<HighlightEntry> entries,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        entries.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == HighlightType.happy
                          ? Icons.favorite_border
                          : Icons.auto_awesome_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      type == HighlightType.happy
                          ? context.l10n.highlightEmptyHappy
                          : context.l10n.highlightEmptyHighlight,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: AppSpacing.paddingScreenBodyFull,
                itemCount: entries.length,
                itemBuilder: (_, i) => MomentCard(
                  entry: entries[i],
                  onTap: () => _editEntry(context, ref, entries[i]),
                ),
              ),
        Positioned(
          right: AppSpacing.base,
          bottom: AppSpacing.lg,
          child: FloatingActionButton(
            heroTag: 'add_${type.value}',
            onPressed: entries.length >= 10
                ? null
                : () => _addEntry(context, ref),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> _addEntry(BuildContext context, WidgetRef ref) async {
    final result = await showMomentEditSheet(context, type: type);
    if (result == null || !context.mounted) return;
    await _saveEntry(context, ref, result);
  }

  Future<void> _editEntry(
    BuildContext context,
    WidgetRef ref,
    HighlightEntry existing,
  ) async {
    final result = await showMomentEditSheet(
      context,
      type: type,
      existing: existing,
    );
    if (result == null || !context.mounted) return;
    await _saveEntry(context, ref, result);
  }

  Future<void> _saveEntry(
    BuildContext context,
    WidgetRef ref,
    HighlightEntry entry,
  ) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    try {
      await ref.read(listHighlightRepositoryProvider).saveHighlight(uid, entry);
      if (context.mounted)
        AppFeedback.success(context, context.l10n.commonSaved);
    } on Exception catch (e) {
      debugPrint('[HighlightMomentsScreen] Save failed: $e');
      if (context.mounted)
        AppFeedback.error(context, context.l10n.commonSaveError);
    }
  }
}
