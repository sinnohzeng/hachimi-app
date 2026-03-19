import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/user_list.dart';
import 'package:hachimi_app/providers/list_highlight_providers.dart';

/// 清单概览卡片 — 展示书单/影单/自定义清单的条目数，点击进入编辑。
class ListsOverviewCard extends ConsumerWidget {
  const ListsOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(currentYearListsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final lists = listsAsync.value ?? [];

    int countByType(ListType type) => lists
        .where((l) => l.type == type)
        .fold(0, (s, l) => s + l.items.length);

    String? idByType(ListType type) {
      final match = lists.where((l) => l.type == type);
      return match.isEmpty ? null : match.first.id;
    }

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('我的清单', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ListTypeTile(
              icon: Icons.menu_book_outlined,
              title: '书单',
              count: countByType(ListType.book),
              onTap: () => Navigator.of(context).pushNamed(
                AppRouter.listDetail,
                arguments: {
                  'type': ListType.book,
                  'listId': idByType(ListType.book),
                },
              ),
            ),
            _ListTypeTile(
              icon: Icons.movie_outlined,
              title: '影单',
              count: countByType(ListType.movie),
              onTap: () => Navigator.of(context).pushNamed(
                AppRouter.listDetail,
                arguments: {
                  'type': ListType.movie,
                  'listId': idByType(ListType.movie),
                },
              ),
            ),
            _ListTypeTile(
              icon: Icons.playlist_add_outlined,
              title: '自定义清单',
              count: countByType(ListType.custom),
              onTap: () => Navigator.of(context).pushNamed(
                AppRouter.listDetail,
                arguments: {
                  'type': ListType.custom,
                  'listId': idByType(ListType.custom),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  const _ListTypeTile({
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: AppShape.borderSmall,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(title, style: textTheme.bodyMedium)),
            Text(
              '$count 条',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
