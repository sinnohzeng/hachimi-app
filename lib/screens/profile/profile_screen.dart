import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/avatar_constants.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/providers/user_profile_provider.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';

import 'components/edit_name_dialog.dart';
import 'components/avatar_picker_sheet.dart';

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
    final avatarId = ref.watch(avatarIdProvider).value;
    final l10n = context.l10n;

    // 按阶段统计猫数量
    final stageCounts = <String, int>{};
    for (final cat in allCats) {
      final stage = cat.displayStage;
      stageCounts[stage] = (stageCounts[stage] ?? 0) + 1;
    }

    final displayName =
        user?.displayName ??
        user?.email?.split('@').first ??
        l10n.profileFallbackUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 可折叠头部：头像 + 名称 + 邮箱 + 成就称号
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            title: Text(l10n.profileTitle),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight + 8),
                  child: _ProfileHeader(
                    displayName: displayName,
                    email: user?.email,
                    avatarId: avatarId,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onEditAvatar: () => showAvatarPickerSheet(context, ref),
                    onEditName: () => showEditNameDialog(context, ref),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: AppSpacing.paddingBase,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 成就称号 chip
                _AchievementChip(ref: ref, l10n: l10n),

                const SizedBox(height: AppSpacing.lg),

                // 统计卡片
                _JourneyCard(
                  stats: stats,
                  allCatsCount: allCats.length,
                  stageCounts: stageCounts,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  l10n: l10n,
                ),

                const SizedBox(height: AppSpacing.lg),
                const Divider(),

                // 设置入口
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.profileSettings),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRouter.settingsPage),
                ),

                // 登出
                ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text(
                    l10n.commonLogOut,
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: () => _confirmLogout(context, ref),
                ),

                const SizedBox(height: AppSpacing.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authServiceProvider).signOut();
            },
            child: Text(l10n.commonLogOut),
          ),
        ],
      ),
    );
  }
}

// ─── 头部区域 ───

class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String? email;
  final String? avatarId;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onEditAvatar;
  final VoidCallback onEditName;

  const _ProfileHeader({
    required this.displayName,
    this.email,
    this.avatarId,
    required this.colorScheme,
    required this.textTheme,
    required this.onEditAvatar,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = avatarId != null ? AvatarConstants.byId(avatarId!) : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 可编辑头像
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onEditAvatar();
          },
          child: Stack(
            children: [
              avatar != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: avatar.color.withValues(alpha: 0.2),
                      child: Icon(avatar.icon, size: 36, color: avatar.color),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        _initials(displayName),
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              // 编辑图标（MD3 filledTonal）
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.secondaryContainer,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 14,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 可编辑名称
        GestureDetector(
          onTap: onEditName,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  displayName,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // 邮箱
        if (email != null)
          Text(
            email!,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}

// ─── 成就称号 ───

class _AchievementChip extends StatelessWidget {
  final WidgetRef ref;
  final S l10n;

  const _AchievementChip({required this.ref, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final unlockedIds = ref.watch(unlockedIdsProvider);
    final titleCount = unlockedIds.where((id) {
      final def = AchievementDefinitions.byId(id);
      return def?.titleReward != null;
    }).length;

    if (titleCount == 0) return const SizedBox.shrink();

    return Center(
      child: Chip(
        avatar: Icon(Icons.military_tech, size: 16, color: colorScheme.primary),
        label: Text(
          l10n.achievementTitleCount(titleCount),
          style: textTheme.labelSmall,
        ),
        side: BorderSide.none,
        backgroundColor: colorScheme.primaryContainer,
      ),
    );
  }
}

// ─── 统计卡片 ───

class _JourneyCard extends StatelessWidget {
  final HabitStats stats;
  final int allCatsCount;
  final Map<String, int> stageCounts;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final S l10n;

  const _JourneyCard({
    required this.stats,
    required this.allCatsCount,
    required this.stageCounts,
    required this.colorScheme,
    required this.textTheme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  value: '$allCatsCount',
                  label: l10n.profileTotalCats,
                  color: colorScheme.tertiary,
                ),
                _StatBadge(
                  icon: Icons.flag,
                  value: '${stats.totalHabits}',
                  label: l10n.profileTotalQuests,
                  color: colorScheme.error,
                ),
              ],
            ),
            if (allCatsCount > 0) ...[
              const SizedBox(height: AppSpacing.base),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              _StageBreakdown(stageCounts: stageCounts, l10n: l10n),
            ],
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

class _StageBreakdown extends StatelessWidget {
  final Map<String, int> stageCounts;
  final S l10n;

  const _StageBreakdown({required this.stageCounts, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8,
      runSpacing: 4,
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
