import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final stats = ref.watch(statsProvider);
    final allCats = ref.watch(allCatsProvider).value ?? [];

    // Count cats by stage
    final stageCounts = <String, int>{};
    for (final cat in allCats) {
      final stage = cat.computedStage;
      stageCounts[stage] = (stageCounts[stage] ?? 0) + 1;
    }

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.lg),

          // User avatar
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                _initials(user?.displayName ?? user?.email),
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Display name
          Center(
            child: Text(
              user?.displayName ??
                  user?.email?.split('@').first ??
                  l10n.profileFallbackUser,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Email
          if (user?.email != null)
            Center(
              child: Text(
                user!.email!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.lg),

          // Stats overview
          Padding(
            padding: AppSpacing.paddingHBase,
            child: Card(
              child: Padding(
                padding: AppSpacing.paddingBase,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileYourJourney,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatBadge(
                          icon: Icons.timer_outlined,
                          value:
                              '${stats.totalHoursLogged}h ${stats.remainingMinutes}m',
                          label: l10n.profileTotalFocus,
                          color: colorScheme.primary,
                        ),
                        _StatBadge(
                          icon: Icons.pets,
                          value: '${allCats.length}',
                          label: l10n.profileTotalCats,
                          color: colorScheme.tertiary,
                        ),
                        _StatBadge(
                          icon: Icons.local_fire_department,
                          value: '${stats.longestStreak}',
                          label: l10n.profileBestStreak,
                          color: colorScheme.error,
                        ),
                      ],
                    ),
                    if (allCats.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.base),
                      const Divider(),
                      const SizedBox(height: AppSpacing.md),
                      // Stage breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StageChip(
                            label: l10n.stageName('kitten'),
                            count: stageCounts['kitten'] ?? 0,
                            color: stageColor('kitten'),
                          ),
                          _StageChip(
                            label: l10n.stageName('adolescent'),
                            count: stageCounts['adolescent'] ?? 0,
                            color: stageColor('adolescent'),
                          ),
                          _StageChip(
                            label: l10n.stageName('adult'),
                            count: stageCounts['adult'] ?? 0,
                            color: stageColor('adult'),
                          ),
                          _StageChip(
                            label: l10n.stageName('senior'),
                            count: stageCounts['senior'] ?? 0,
                            color: stageColor('senior'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Cat Album section
          if (allCats.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.base),
            Padding(
              padding: AppSpacing.paddingHBase,
              child: Card(
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.profileCatAlbum,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.profileCatAlbumCount(allCats.length),
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Cat grid preview (max 6)
                      _CatAlbumGrid(cats: allCats.take(6).toList()),
                      if (allCats.length > 6) ...[
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showFullAlbum(context, allCats);
                            },
                            icon: const Icon(Icons.grid_view),
                            label: Text(l10n.profileSeeAll(allCats.length)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.base),
          const Divider(),

          // Settings entry
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.profileSettings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.of(context).pushNamed(AppRouter.settingsPage),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  void _showFullAlbum(BuildContext context, List<Cat> allCats) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: AppSpacing.paddingBase,
              child: Row(
                children: [
                  Text(
                    ctx.l10n.profileCatAlbum,
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: scrollController,
                padding: AppSpacing.paddingBase,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: allCats.length,
                itemBuilder: (ctx, index) {
                  final cat = allCats[index];
                  return _CatAlbumTile(cat: cat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StageChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.12,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatAlbumGrid extends StatelessWidget {
  final List<Cat> cats;

  const _CatAlbumGrid({required this.cats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: cats.map((cat) => _CatAlbumTile(cat: cat)).toList(),
    );
  }
}

class _CatAlbumTile extends StatelessWidget {
  final Cat cat;

  const _CatAlbumTile({required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = cat.state == 'active';
    final isGraduated = cat.state == 'graduated';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRouter.catDetail, arguments: cat.id);
      },
      child: Opacity(
        opacity: isGraduated ? 0.5 : (isActive ? 1.0 : 0.7),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: TappableCatSprite(cat: cat, size: 48, enableTap: false)),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              cat.name,
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isGraduated)
              Text(
                context.l10n.profileGraduated,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
