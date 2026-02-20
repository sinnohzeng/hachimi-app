// ---
// 📘 文件说明：
// 设置页面 — 外观（主题模式/主题色）、通知、语言、关于信息、账号操作。
//
// 🧩 文件结构：
// - SettingsScreen：主页面；
// - _SectionHeader：分组标题组件；
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/llm_provider.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeSettings = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

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
            onTap: () => _showNotificationSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(
              _localeName(locale),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSettings(context, ref),
          ),

          const SizedBox(height: 8),
          const Divider(),

          // Appearance section
          _SectionHeader(title: 'Appearance', colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme Mode'),
            subtitle: Text(
              _themeModeName(themeSettings.mode),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModeSettings(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme Color'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: themeSettings.seedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showThemeColorSettings(context, ref),
          ),

          const SizedBox(height: 8),
          const Divider(),

          // AI Model section
          _SectionHeader(title: 'AI Model', colorScheme: colorScheme),
          _AiModelSection(colorScheme: colorScheme, textTheme: textTheme),

          const SizedBox(height: 8),
          const Divider(),

          // About section
          _SectionHeader(title: 'About', colorScheme: colorScheme),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.2.0'),
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
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
                applicationVersion: '1.2.0',
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

  // --- Notification Settings ---

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const _NotificationSettingsDialog(),
    );
  }

  // --- Language Settings ---

  String _localeName(Locale? locale) {
    if (locale == null) return 'System default';
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return 'Chinese';
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageSettings(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => _LanguageDialog(currentLocale: currentLocale),
    ).then((result) {
      if (result != null) {
        if (result == 'system') {
          ref.read(localeProvider.notifier).setLocale(null);
        } else {
          ref.read(localeProvider.notifier).setLocale(Locale(result as String));
        }
      }
    });
  }

  // --- Theme Mode Settings ---

  String _themeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeModeSettings(BuildContext context, WidgetRef ref) {
    final currentMode = ref.read(themeProvider).mode;
    showDialog(
      context: context,
      builder: (ctx) => _ThemeModeDialog(currentMode: currentMode),
    ).then((result) {
      if (result != null) {
        ref.read(themeProvider.notifier).setMode(result as ThemeMode);
      }
    });
  }

  // --- Theme Color Settings ---

  void _showThemeColorSettings(BuildContext context, WidgetRef ref) {
    final currentColor = ref.read(themeProvider).seedColor;
    showDialog(
      context: context,
      builder: (ctx) => _ThemeColorDialog(currentColor: currentColor),
    ).then((result) {
      if (result != null) {
        ref.read(themeProvider.notifier).setSeedColor(result as Color);
      }
    });
  }

  // --- Account Actions ---

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

// --- Private Dialogs ---

/// Notification settings dialog with focus reminders toggle.
class _NotificationSettingsDialog extends StatefulWidget {
  const _NotificationSettingsDialog();

  @override
  State<_NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<_NotificationSettingsDialog> {
  static const _key = 'notifications_enabled';
  bool _enabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool(_key) ?? true;
      _loaded = true;
    });
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);

    if (!value) {
      await NotificationService().cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notifications'),
      content: _loaded
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Focus Reminders'),
                  subtitle: const Text(
                    'Receive daily reminders to stay on track',
                  ),
                  value: _enabled,
                  onChanged: _toggle,
                ),
              ],
            )
          : const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator()),
            ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

/// Language selection dialog.
class _LanguageDialog extends StatelessWidget {
  final Locale? currentLocale;
  const _LanguageDialog({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final currentCode = currentLocale?.languageCode ?? 'system';

    return AlertDialog(
      title: const Text('Language'),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<String>(
        groupValue: currentCode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('System default'),
              value: 'system',
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
            ),
            RadioListTile<String>(
              title: const Text('Chinese'),
              value: 'zh',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Theme mode selection dialog.
class _ThemeModeDialog extends StatelessWidget {
  final ThemeMode currentMode;
  const _ThemeModeDialog({required this.currentMode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Theme Mode'),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<ThemeMode>(
        groupValue: currentMode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Theme color selection dialog with 8-color grid.
class _ThemeColorDialog extends StatelessWidget {
  final Color currentColor;
  const _ThemeColorDialog({required this.currentColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Theme Color'),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AppTheme.presetColors.map((color) {
          final isSelected = color.toARGB32() == currentColor.toARGB32();
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(color),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: colorScheme.onSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// AI Model 设置区块 — 功能开关 + 模型下载/删除。
class _AiModelSection extends ConsumerWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _AiModelSection({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiEnabled = ref.watch(aiFeatureEnabledProvider);
    final availability = ref.watch(llmAvailabilityProvider);
    final downloadState = ref.watch(modelDownloadProvider);

    return Column(
      children: [
        // AI 功能总开关
        SwitchListTile(
          secondary: const Icon(Icons.smart_toy_outlined),
          title: const Text('AI Features'),
          subtitle: Text(
            'Enable cat diary and chat powered by on-device AI',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          value: aiEnabled,
          onChanged: (value) {
            ref.read(aiFeatureEnabledProvider.notifier).setEnabled(value);
            ref.read(llmAvailabilityProvider.notifier).refresh();
          },
        ),

        if (aiEnabled) ...[
          // 模型信息
          ListTile(
            leading: const Icon(Icons.memory),
            title: const Text(LlmConstants.modelDisplayName),
            subtitle: Text(
              _statusText(availability, downloadState),
              style: textTheme.bodySmall?.copyWith(
                color: _statusColor(availability, colorScheme),
              ),
            ),
          ),

          // 下载进度条
          if (downloadState.isDownloading) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: downloadState.progress > 0
                        ? downloadState.progress
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(downloadState.progress * 100).toStringAsFixed(0)}%',
                        style: textTheme.labelSmall,
                      ),
                      Text(
                        _formatBytes(downloadState.downloadedBytes),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 暂停/恢复/取消按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final notifier =
                          ref.read(modelDownloadProvider.notifier);
                      if (downloadState.isPaused) {
                        notifier.resume();
                      } else {
                        notifier.pause();
                      }
                    },
                    child: Text(
                        downloadState.isPaused ? 'Resume' : 'Pause'),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(modelDownloadProvider.notifier).cancel();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 下载/删除按钮
          if (!downloadState.isDownloading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: availability == LlmAvailability.modelNotDownloaded ||
                        availability == LlmAvailability.error
                    ? FilledButton.tonalIcon(
                        onPressed: () {
                          ref
                              .read(modelDownloadProvider.notifier)
                              .startDownload();
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Model (1.2 GB)'),
                      )
                    : availability == LlmAvailability.ready
                        ? OutlinedButton.icon(
                            onPressed: () =>
                                _confirmDeleteModel(context, ref),
                            icon: Icon(Icons.delete_outline,
                                color: colorScheme.error),
                            label: Text(
                              'Delete Model',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ),

          // 错误信息
          if (downloadState.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                downloadState.error!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
        ],
      ],
    );
  }

  String _statusText(
    LlmAvailability availability,
    ModelDownloadState downloadState,
  ) {
    if (downloadState.isDownloading) return 'Downloading...';
    switch (availability) {
      case LlmAvailability.featureDisabled:
        return 'Disabled';
      case LlmAvailability.modelNotDownloaded:
        return 'Not downloaded';
      case LlmAvailability.modelLoading:
        return 'Loading model...';
      case LlmAvailability.ready:
        return 'Ready';
      case LlmAvailability.error:
        return 'Error';
    }
  }

  Color _statusColor(LlmAvailability availability, ColorScheme colorScheme) {
    switch (availability) {
      case LlmAvailability.ready:
        return Colors.green;
      case LlmAvailability.error:
        return colorScheme.error;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  void _confirmDeleteModel(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete model?'),
        content: const Text(
          'This will delete the downloaded AI model (1.2 GB). '
          'You can download it again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(modelManagerProvider).deleteModel();
              ref.read(llmAvailabilityProvider.notifier).refresh();
            },
            child: const Text('Delete'),
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
