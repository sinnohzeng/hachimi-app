// ---
// 📘 文件说明：
// 设置页面 — 通知、语言、关于信息、账号操作（登出/删除账号）。
// 从 Profile 页面拆分出来，隔离敏感操作。
//
// 🧩 文件结构：
// - SettingsScreen：主页面；
// - _SectionHeader：分组标题组件；
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // General section
          _SectionHeader(title: 'General', colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to language settings
            },
          ),

          const SizedBox(height: 8),
          const Divider(),

          // About section
          _SectionHeader(title: 'About', colorScheme: colorScheme),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.1.1'),
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
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Hachimi',
                applicationVersion: '1.1.1',
              );
            },
          ),

          // Spacing to push account section to bottom
          const SizedBox(height: 48),
          const Divider(),

          // Account section (danger zone)
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
