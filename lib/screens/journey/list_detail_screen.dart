import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/utils/app_feedback.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:uuid/uuid.dart';

/// 清单详情编辑器 — 书单/影单/自定义清单，10 条目 + 年度宝藏。
class ListDetailScreen extends ConsumerStatefulWidget {
  final ListType listType;
  final String? listId;

  const ListDetailScreen({super.key, required this.listType, this.listId});

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  static const _maxItems = 10;

  final _titleControllers = List.generate(
    _maxItems,
    (_) => TextEditingController(),
  );
  final _dateControllers = List.generate(
    _maxItems,
    (_) => TextEditingController(),
  );
  final _genreControllers = List.generate(
    _maxItems,
    (_) => TextEditingController(),
  );
  final _keywordControllers = List.generate(
    _maxItems,
    (_) => TextEditingController(),
  );
  final _ratings = List.filled(_maxItems, 3);
  final _yearPickController = TextEditingController();
  final _yearInsightController = TextEditingController();
  final _customTitleController = TextEditingController();

  bool _loaded = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    for (var i = 0; i < _maxItems; i++) {
      _titleControllers[i].dispose();
      _dateControllers[i].dispose();
      _genreControllers[i].dispose();
      _keywordControllers[i].dispose();
    }
    _yearPickController.dispose();
    _yearInsightController.dispose();
    _customTitleController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    if (_loaded) return;
    final uid = ref.read(currentUidProvider);
    if (uid == null || widget.listId == null) {
      _loaded = true;
      return;
    }

    final repo = ref.read(listHighlightRepositoryProvider);
    final list = await repo.getList(uid, widget.listId!);
    if (list == null || !mounted) {
      _loaded = true;
      return;
    }

    _loaded = true;
    _customTitleController.text = list.customTitle ?? '';
    _yearPickController.text = list.yearPick ?? '';
    _yearInsightController.text = list.yearInsight ?? '';
    for (var i = 0; i < list.items.length && i < _maxItems; i++) {
      _titleControllers[i].text = list.items[i].title;
      _dateControllers[i].text = list.items[i].date ?? '';
      _genreControllers[i].text = list.items[i].genre ?? '';
      _keywordControllers[i].text = list.items[i].keywords ?? '';
      _ratings[i] = list.items[i].rating;
    }
    setState(() {});
  }

  String _screenTitle(BuildContext context) {
    return switch (widget.listType) {
      ListType.book => context.l10n.listDetailBookTitle,
      ListType.movie => context.l10n.listDetailMovieTitle,
      ListType.custom => context.l10n.listDetailCustomTitle,
    };
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final items = <ListItem>[];
      for (var i = 0; i < _maxItems; i++) {
        final title = _titleControllers[i].text.trim();
        if (title.isNotEmpty) {
          items.add(
            ListItem(
              title: title,
              date: _trimOrNull(_dateControllers[i].text),
              genre: _trimOrNull(_genreControllers[i].text),
              rating: _ratings[i],
              keywords: _trimOrNull(_keywordControllers[i].text),
            ),
          );
        }
      }

      final now = DateTime.now();
      final list = UserList(
        id: widget.listId ?? const Uuid().v4(),
        year: now.year,
        type: widget.listType,
        customTitle: widget.listType == ListType.custom
            ? _trimOrNull(_customTitleController.text)
            : null,
        items: items,
        yearPick: _trimOrNull(_yearPickController.text),
        yearInsight: _trimOrNull(_yearInsightController.text),
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(listHighlightRepositoryProvider).saveList(uid, list);

      if (mounted) {
        AppFeedback.success(context, context.l10n.commonSaved);
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      debugPrint('[ListDetailScreen] Save failed: $e');
      if (mounted) AppFeedback.error(context, context.l10n.commonSaveError);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _trimOrNull(String text) {
    final t = text.trim();
    return t.isEmpty ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: Text(_screenTitle(context))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _save,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: Text(context.l10n.commonSave),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreenBodyFull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.listType == ListType.custom) ...[
              TextField(
                controller: _customTitleController,
                decoration: InputDecoration(
                  labelText: context.l10n.listDetailCustomNameLabel,
                  hintText: context.l10n.listDetailCustomNameHint,
                  border: OutlineInputBorder(
                    borderRadius: AppShape.borderSmall,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // 条目列表
            ...List.generate(
              _maxItems,
              (i) => _buildItemCard(i, textTheme, colorScheme),
            ),

            const SizedBox(height: AppSpacing.lg),

            // 年度宝藏
            _sectionTitle(
              textTheme,
              colorScheme,
              Icons.star_outline,
              context.l10n.listDetailYearTreasure,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _yearPickController,
              decoration: InputDecoration(
                labelText: context.l10n.listDetailYearPick,
                hintText: context.l10n.listDetailYearPickHint,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _yearInsightController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.listDetailInsight,
                hintText: context.l10n.listDetailInsightHint,
                border: OutlineInputBorder(borderRadius: AppShape.borderSmall),
              ),
            ),
            const SizedBox(height: 100), // FAB 间距
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(
    int index,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _titleControllers[index],
              decoration: InputDecoration(
                hintText: context.l10n.listDetailItemTitleHint,
                border: InputBorder.none,
                isDense: true,
              ),
              style: textTheme.bodyLarge,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateControllers[index],
                    decoration: InputDecoration(
                      hintText: context.l10n.listDetailItemDateHint,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _genreControllers[index],
                    decoration: InputDecoration(
                      hintText: context.l10n.listDetailItemGenreHint,
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            // 星级评分
            _StarRating(
              rating: _ratings[index],
              onChanged: (r) => setState(() => _ratings[index] = r),
            ),
            TextField(
              controller: _keywordControllers[index],
              decoration: InputDecoration(
                hintText: context.l10n.listDetailItemKeywordHint,
                border: InputBorder.none,
                isDense: true,
              ),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: textTheme.titleSmall),
      ],
    );
  }
}

/// 星级评分 — 1-5 星，点击切换。
class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarRating({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              filled ? Icons.star : Icons.star_border,
              size: 20,
              color: filled ? colorScheme.primary : colorScheme.outlineVariant,
            ),
          ),
        );
      }),
    );
  }
}
