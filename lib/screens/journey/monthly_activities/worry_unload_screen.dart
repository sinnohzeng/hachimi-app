import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/worry.dart';
import 'package:hachimi_app/providers/awareness_providers.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';

/// 烦恼减负日 — 对进行中的烦恼进行分类：放下/行动/接受。
class WorryUnloadScreen extends ConsumerStatefulWidget {
  const WorryUnloadScreen({super.key});

  @override
  ConsumerState<WorryUnloadScreen> createState() => _WorryUnloadScreenState();
}

class _WorryUnloadScreenState extends ConsumerState<WorryUnloadScreen> {
  // key: worry id, value: category
  final _categories = <String, String>{};

  static const _categoryOptions = ['可以放下', '可以行动', '暂时接受'];
  static const _categoryIcons = [
    Icons.cloud_off_outlined,
    Icons.directions_run_outlined,
    Icons.spa_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final worriesAsync = ref.watch(activeWorriesProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('烦恼减负日')),
      body: worriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          debugPrint('[WorryUnloadScreen] Error: $e');
          return Center(child: Text('加载失败: $e'));
        },
        data: (worries) =>
            _buildContent(context, worries, textTheme, colorScheme),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Worry> worries,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    if (worries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_satisfied_alt,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('没有进行中的烦恼', style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '太棒了！今天是轻松的一天',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // 统计
    final letGo = _categories.values.where((v) => v == '可以放下').length;
    final action = _categories.values.where((v) => v == '可以行动').length;
    final accept = _categories.values.where((v) => v == '暂时接受').length;

    return ListView(
      padding: AppSpacing.paddingScreenBodyFull,
      children: [
        Text(
          '看看你的烦恼，为它们分个类吧',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        ...worries.map(
          (worry) => _buildWorryTile(worry, textTheme, colorScheme),
        ),

        const SizedBox(height: AppSpacing.lg),

        // 统计摘要
        if (_categories.isNotEmpty) ...[
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Text('减负结果', style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _summaryRow(colorScheme, textTheme, '可以放下', letGo, Colors.green),
          _summaryRow(colorScheme, textTheme, '可以行动', action, Colors.blue),
          _summaryRow(colorScheme, textTheme, '暂时接受', accept, Colors.orange),
          const SizedBox(height: AppSpacing.md),
          Text(
            '每一个分类都是前进的一步。',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildWorryTile(
    Worry worry,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final selected = _categories[worry.id];
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(worry.description, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: List.generate(3, (i) {
                final isSelected = selected == _categoryOptions[i];
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    avatar: Icon(_categoryIcons[i], size: 16),
                    label: Text(_categoryOptions[i]),
                    selected: isSelected,
                    onSelected: (v) {
                      setState(() {
                        if (v) {
                          _categories[worry.id] = _categoryOptions[i];
                        } else {
                          _categories.remove(worry.id);
                        }
                      });
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String label,
    int count,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('$label: $count 个', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
