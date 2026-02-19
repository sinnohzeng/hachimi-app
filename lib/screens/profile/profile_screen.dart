// ---
// 📘 文件说明：
// 用户个人资料页面 — 展示用户信息、统计数据、猫猫图鉴、设置与关于。
//
// 📋 程序整体伪代码（中文）：
// 1. 从 Provider 加载用户、统计和所有猫猫数据；
// 2. 展示用户头像和基本信息；
// 3. 统计卡片（总专注时长、猫猫数量、最长连续）；
// 4. 猫猫图鉴网格预览；
// 5. 设置（通知、语言）+ 关于（版本、归属声明）；
// 6. 危险区（登出、删除账号）；
//
// 🧩 文件结构：
// - ProfileScreen：主页面；
// - _StatBadge / _CatAlbumGrid / _CatAlbumTile / _SectionHeader：子组件；
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          const SizedBox(height: 24),

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
          const SizedBox(height: 12),

          // Display name
          Center(
            child: Text(
              user?.displayName ?? user?.email?.split('@').first ?? 'User',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),

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

          const SizedBox(height: 24),

          // Stats overview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Journey',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatBadge(
                          icon: Icons.timer_outlined,
                          value:
                              '${stats.totalHoursLogged}h ${stats.remainingMinutes}m',
                          label: 'Total Focus',
                          color: colorScheme.primary,
                        ),
                        _StatBadge(
                          icon: Icons.pets,
                          value: '${allCats.length}',
                          label: 'Total Cats',
                          color: colorScheme.tertiary,
                        ),
                        _StatBadge(
                          icon: Icons.local_fire_department,
                          value: '${stats.longestStreak}',
                          label: 'Best Streak',
                          color: colorScheme.error,
                        ),
                      ],
                    ),
                    if (allCats.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      // Stage breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StageChip(
                            label: 'Kitten',
                            count: stageCounts['kitten'] ?? 0,
                            color: stageColor('kitten'),
                          ),
                          _StageChip(
                            label: 'Adolescent',
                            count: stageCounts['adolescent'] ?? 0,
                            color: stageColor('adolescent'),
                          ),
                          _StageChip(
                            label: 'Adult',
                            count: stageCounts['adult'] ?? 0,
                            color: stageColor('adult'),
                          ),
                          _StageChip(
                            label: 'Senior',
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cat Album',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${allCats.length} cats',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Cat grid preview (max 6)
                      _CatAlbumGrid(cats: allCats.take(6).toList()),
                      if (allCats.length > 6) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showFullAlbum(context, allCats);
                            },
                            icon: const Icon(Icons.grid_view),
                            label: Text('See all ${allCats.length} cats'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),

          // Settings section
          _SectionHeader(title: 'Settings', colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),

          const SizedBox(height: 16),
          const Divider(),

          // About section
          _SectionHeader(title: 'About', colorScheme: colorScheme),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.1.0'),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Pixel Cat Sprites'),
            subtitle: Text(
              'by pixel-cat-maker (CC BY-NC 4.0)',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Extra spacing to push danger zone to the bottom
          const SizedBox(height: 48),
          const Divider(),

          // Danger zone — intentionally at the very bottom
          _SectionHeader(title: 'Account', colorScheme: colorScheme),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              'Log Out',
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _confirmLogout(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: colorScheme.error),
            title: Text(
              'Delete Account',
              style: TextStyle(color: colorScheme.error),
            ),
            subtitle: Text(
              'This action cannot be undone',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () => _confirmDeleteAccount(context, ref),
          ),
          const SizedBox(height: 32),
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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Cat Album',
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
                padding: const EdgeInsets.all(16),
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

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authServiceProvider).signOut();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This will permanently delete your account and all your data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(authServiceProvider).deleteAccount();
              } on Exception catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
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
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
        color: color.withValues(alpha: 0.12),
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
          const SizedBox(width: 4),
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
        Navigator.of(context).pushNamed(
          AppRouter.catDetail,
          arguments: cat.id,
        );
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
                child: Center(
                  child: PixelCatSprite.fromCat(cat: cat, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              cat.name,
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isGraduated)
              Text(
                'Graduated',
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;

  const _SectionHeader({required this.title, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
