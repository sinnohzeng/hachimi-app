import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:hachimi_app/core/constants/avatar_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
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
    final isGuest = ref.watch(isGuestProvider);
    final avatarId = ref.watch(avatarIdProvider).value;
    final stats = ref.watch(statsProvider);
    final allCats = ref.watch(allCatsProvider).value ?? [];
    final l10n = context.l10n;

    final displayName = isGuest
        ? null
        : (user?.displayName ??
              user?.email?.split('@').first ??
              l10n.profileFallbackUser);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ─── 头部区域：访客 CTA / 已登录用户信息 ───
            if (isGuest)
              _GuestLoginHeader(
                onSignIn: () => showGuestUpgradePrompt(context, ref),
              )
            else
              _DrawerHeader(
                displayName: displayName!,
                email: user?.email,
                avatarId: avatarId,
                onEditAvatar: () => showAvatarPickerSheet(context, ref),
                onEditName: () => showEditNameDialog(context, ref),
              ),

            // ─── 里程碑 ───
            _SectionHeader(label: l10n.drawerMilestones),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
              onTap: () =>
                  _navigateAfterClose(context, AppRouter.sessionHistory),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: Text(l10n.drawerCheckInCalendar),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _navigateAfterClose(context, AppRouter.checkIn),
            ),

            const Divider(indent: 16, endIndent: 16),

            // ─── 设置 ───
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.profileSettings),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => _navigateAfterClose(context, AppRouter.settingsPage),
            ),

            // ─── 账号（仅已登录用户） ───
            if (!isGuest) ...[
              const Divider(indent: 16, endIndent: 16),
              _SectionHeader(label: l10n.drawerAccountSection),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  l10n.commonLogOut,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => _confirmLogout(context, ref),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            // ─── 底部版本信息 ───
            _DrawerFooter(uid: user?.uid),
          ],
        ),
      ),
    );
  }

  /// 关闭 Drawer 后等待关闭动画完成再导航到新页面。
  void _navigateAfterClose(BuildContext context, String route) {
    Navigator.of(context).pop();
    Future.delayed(AppMotion.durationMedium1, () {
      if (context.mounted) Navigator.of(context).pushNamed(route);
    });
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Navigator.of(context).pop(); // 关闭 Drawer
    Future.delayed(AppMotion.durationMedium1, () {
      if (!context.mounted) return;
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
    });
  }
}

// ─── 访客登录引导卡片 ───

class _GuestLoginHeader extends StatelessWidget {
  final VoidCallback onSignIn;

  const _GuestLoginHeader({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Card(
        color: colorScheme.primaryContainer,
        child: InkWell(
          borderRadius: AppShape.borderMedium,
          onTap: onSignIn,
          child: Padding(
            padding: AppSpacing.paddingBase,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.guestUpgradeTitle,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            l10n.drawerGuestLoginSubtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onSignIn,
                    icon: const Icon(Icons.login),
                    label: Text(l10n.drawerGuestSignIn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 已登录用户头部区域 ───

class _DrawerHeader extends StatelessWidget {
  final String displayName;
  final String? email;
  final String? avatarId;
  final VoidCallback onEditAvatar;
  final VoidCallback onEditName;

  const _DrawerHeader({
    required this.displayName,
    this.email,
    this.avatarId,
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
            onTap: onEditAvatar,
            child: _buildAvatar(avatar, colorScheme, textTheme),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onEditName,
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
