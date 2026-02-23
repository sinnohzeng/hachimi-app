import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:hachimi_app/core/constants/avatar_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/stats_provider.dart';
import 'package:hachimi_app/providers/user_profile_provider.dart';
import 'package:hachimi_app/screens/profile/components/avatar_picker_sheet.dart';
import 'package:hachimi_app/screens/profile/components/edit_name_dialog.dart';
import 'package:hachimi_app/widgets/guest_upgrade_prompt.dart';

/// M3 Drawer — 替代原 Profile Tab，提供身份、里程碑、设置和账号管理。
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final isGuest = ref.watch(isAnonymousProvider);
    final avatarId = ref.watch(avatarIdProvider).value;
    final stats = ref.watch(statsProvider);
    final allCats = ref.watch(allCatsProvider).value ?? [];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    final displayName = isGuest
        ? l10n.drawerGuest
        : (user?.displayName ??
              user?.email?.split('@').first ??
              l10n.profileFallbackUser);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ─── 头像 + 用户信息 ───
            _DrawerHeader(
              displayName: displayName,
              email: isGuest ? null : user?.email,
              avatarId: avatarId,
              isGuest: isGuest,
              onEditAvatar: () => showAvatarPickerSheet(context, ref),
              onEditName: () => showEditNameDialog(context, ref),
            ),

            // ─── 访客升级横幅 ───
            if (isGuest)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Card(
                  color: colorScheme.primaryContainer,
                  child: InkWell(
                    borderRadius: AppShape.borderMedium,
                    onTap: () => showGuestUpgradePrompt(context, ref),
                    child: Padding(
                      padding: AppSpacing.paddingBase,
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              l10n.drawerLinkAccountHint,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          FilledButton(
                            onPressed: () =>
                                showGuestUpgradePrompt(context, ref),
                            child: Text(l10n.drawerLinkAccount),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // ─── 里程碑 ───
            _SectionHeader(label: l10n.drawerMilestones),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHigh,
                child: Padding(
                  padding: AppSpacing.paddingBase,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MilestoneRow(
                        icon: Icons.timer_outlined,
                        text: l10n.drawerMilestoneFocus(
                          stats.totalHoursLogged,
                          stats.remainingMinutes,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _MilestoneRow(
                        icon: Icons.pets,
                        text: l10n.drawerMilestoneCats(allCats.length),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _MilestoneRow(
                        icon: Icons.flag,
                        text: l10n.drawerMilestoneQuests(stats.totalHabits),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ─── 我的 ───
            _SectionHeader(label: l10n.drawerMySection),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: Text(l10n.drawerSessionHistory),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRouter.sessionHistory);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text(l10n.drawerCheckInCalendar),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRouter.checkIn);
              },
            ),

            const Divider(indent: 16, endIndent: 16),

            // ─── 设置 ───
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.profileSettings),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRouter.settingsPage);
              },
            ),

            const Divider(indent: 16, endIndent: 16),

            // ─── 账号 ───
            _SectionHeader(label: l10n.drawerAccountSection),
            if (isGuest)
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
                title: Text(
                  l10n.drawerGuestLogout,
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () => _confirmGuestLogout(context, ref),
              )
            else
              ListTile(
                leading: Icon(Icons.logout, color: colorScheme.error),
                title: Text(
                  l10n.commonLogOut,
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () => _confirmLogout(context, ref),
              ),

            const SizedBox(height: AppSpacing.lg),

            // ─── 底部版本信息 ───
            _DrawerFooter(uid: user?.uid),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Navigator.of(context).pop(); // 关闭 Drawer
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

  void _confirmGuestLogout(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Navigator.of(context).pop(); // 关闭 Drawer
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: Theme.of(ctx).colorScheme.error,
          size: 32,
        ),
        title: Text(l10n.drawerGuestLogoutTitle),
        content: Text(l10n.drawerGuestLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              showGuestUpgradePrompt(context, ref);
            },
            child: Text(l10n.drawerLinkAccount),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authServiceProvider).signOut();
            },
            child: Text(
              l10n.drawerGuestLogoutConfirm,
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 头部区域 ───

class _DrawerHeader extends StatelessWidget {
  final String displayName;
  final String? email;
  final String? avatarId;
  final bool isGuest;
  final VoidCallback onEditAvatar;
  final VoidCallback onEditName;

  const _DrawerHeader({
    required this.displayName,
    this.email,
    this.avatarId,
    required this.isGuest,
    required this.onEditAvatar,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final avatar = avatarId != null ? AvatarConstants.byId(avatarId!) : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: isGuest ? null : onEditAvatar,
            child: _buildAvatar(avatar, colorScheme, textTheme),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: isGuest ? null : onEditName,
                  child: Text(
                    displayName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (email != null)
                  Text(
                    email!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    AvatarOption? avatar,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (avatar != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: avatar.color.withValues(alpha: 0.2),
        child: Icon(avatar.icon, size: 24, color: avatar.color),
      );
    }
    if (isGuest) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.secondaryContainer,
        child: Icon(
          Icons.person_outline,
          size: 24,
          color: colorScheme.onSecondaryContainer,
        ),
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        _initials(displayName),
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
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

// ─── 分区标题 ───

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ─── 里程碑行 ───

class _MilestoneRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MilestoneRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 底部信息 ───

class _DrawerFooter extends StatelessWidget {
  final String? uid;
  const _DrawerFooter({this.uid});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (_, snapshot) {
              final version = snapshot.data?.version ?? '';
              return Text('v$version', style: style);
            },
          ),
          if (uid != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ID: ${uid!.substring(0, uid!.length.clamp(0, 10))}',
                    style: style,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 14),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: uid!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID copied'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  tooltip: 'Copy ID',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
