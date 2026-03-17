import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/worry.dart';

/// WorryItemCard — 烦恼记录卡片。
///
/// 显示烦恼描述、解决方案预览和三态切换按钮
/// （进行中 / 已解决 / 自然消失）。
class WorryItemCard extends StatelessWidget {
  /// 烦恼数据。
  final Worry worry;

  /// 状态变更回调。
  final ValueChanged<WorryStatus> onStatusChanged;

  /// 卡片点击回调（查看详情）。
  final VoidCallback? onTap;

  const WorryItemCard({
    super.key,
    required this.worry,
    required this.onStatusChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.paddingBase,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDescription(context),
              if (worry.solution != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildSolutionPreview(context),
              ],
              const SizedBox(height: AppSpacing.md),
              _buildStatusToggle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      worry.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
    );
  }

  Widget _buildSolutionPreview(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      worry.solution!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildStatusToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SegmentedButton<WorryStatus>(
      segments: [
        ButtonSegment(
          value: WorryStatus.ongoing,
          label: const Text('进行中'),
          icon: Icon(
            Icons.pending_outlined,
            color: colorScheme.tertiary,
            size: 16,
          ),
        ),
        ButtonSegment(
          value: WorryStatus.resolved,
          label: const Text('已解决'),
          icon: Icon(
            Icons.check_circle_outline,
            color: colorScheme.primary,
            size: 16,
          ),
        ),
        ButtonSegment(
          value: WorryStatus.disappeared,
          label: const Text('消失了'),
          icon: Icon(
            Icons.auto_awesome_outlined,
            color: colorScheme.outline,
            size: 16,
          ),
        ),
      ],
      selected: {worry.status},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) onStatusChanged(selected.first);
      },
      showSelectedIcon: false,
    );
  }
}
