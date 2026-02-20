// ---
// 📘 文件说明：
// 设置页面 — 外观（主题模式/主题色）、通知、语言、关于信息、账号操作。
//
// 🧩 文件结构：
// - SettingsScreen：主页面；
// - _SectionHeader：分组标题组件；
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/app_info_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/llm_provider.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/core/router/app_router.dart';
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

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // General section
          _SectionHeader(title: l10n.settingsGeneral, colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.settingsNotifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showNotificationSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(
              _localeName(locale, l10n),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSettings(context, ref),
          ),

          const SizedBox(height: AppSpacing.sm),
          const Divider(),

          // Appearance section
          _SectionHeader(title: l10n.settingsAppearance, colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.settingsThemeMode),
            subtitle: Text(
              _themeModeName(themeSettings.mode, l10n),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeModeSettings(context, ref),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wallpaper_outlined),
            title: Text(l10n.settingsMaterialYou),
            subtitle: Text(
              l10n.settingsMaterialYouSubtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            value: themeSettings.useDynamicColor,
            onChanged: (value) {
              ref.read(themeProvider.notifier).setDynamicColor(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.settingsThemeColor),
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
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showThemeColorSettings(context, ref),
          ),

          const SizedBox(height: AppSpacing.sm),
          const Divider(),

          // AI Model section
          _SectionHeader(title: l10n.settingsAiModel, colorScheme: colorScheme),
          _AiModelSection(colorScheme: colorScheme, textTheme: textTheme),

          const SizedBox(height: AppSpacing.sm),
          const Divider(),

          // About section
          _SectionHeader(title: l10n.settingsAbout, colorScheme: colorScheme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersion),
            subtitle: ref.watch(appInfoProvider).when(
              data: (info) => Text(info.version),
              loading: () => const Text('...'),
              error: (_, __) => const Text('?'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: Text(l10n.settingsPixelCatSprites),
            subtitle: Text(
              'by pixel-cat-maker (CC BY-NC 4.0)',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.settingsLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final version = ref.read(appInfoProvider).value?.version ?? '';
              showLicensePage(
                context: context,
                applicationName: 'Hachimi',
                applicationVersion: version,
              );
            },
          ),

          // Spacing to push account section to bottom
          const SizedBox(height: AppSpacing.xxl),
          const Divider(),

          // Account section (danger zone)
          _SectionHeader(title: l10n.settingsAccount, colorScheme: colorScheme),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              l10n.commonLogOut,
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () => _confirmLogout(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: colorScheme.error),
            title: Text(
              l10n.commonDeleteAccount,
              style: TextStyle(color: colorScheme.error),
            ),
            subtitle: Text(
              l10n.deleteAccountWarning,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () => _confirmDeleteAccount(context, ref),
          ),
          const SizedBox(height: AppSpacing.xl),
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

  String _localeName(Locale? locale, S l10n) {
    if (locale == null) return l10n.settingsLanguageSystem;
    switch (locale.languageCode) {
      case 'en':
        return l10n.settingsLanguageEnglish;
      case 'zh':
        return l10n.settingsLanguageChinese;
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

  String _themeModeName(ThemeMode mode, S l10n) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.settingsThemeModeSystem;
      case ThemeMode.light:
        return l10n.settingsThemeModeLight;
      case ThemeMode.dark:
        return l10n.settingsThemeModeDark;
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

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
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
            child: Text(l10n.commonDeleteAccount),
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
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsNotifications),
      content: _loaded
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsNotificationFocusReminders),
                  subtitle: Text(l10n.settingsNotificationSubtitle),
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
          child: Text(l10n.commonDone),
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

    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsLanguage),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<String>(
        groupValue: currentCode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageSystem),
              value: 'system',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageEnglish),
              value: 'en',
            ),
            RadioListTile<String>(
              title: Text(l10n.settingsLanguageChinese),
              value: 'zh',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
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
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsThemeMode),
      contentPadding: const EdgeInsets.only(top: 12),
      content: RadioGroup<ThemeMode>(
        groupValue: currentMode,
        onChanged: (value) => Navigator.of(context).pop(value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeSystem),
              value: ThemeMode.system,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeLight),
              value: ThemeMode.light,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeModeDark),
              value: ThemeMode.dark,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
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
      title: Text(context.l10n.settingsThemeColor),
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
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : null,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
      ],
    );
  }
}

/// AI Model 设置区块 — 功能开关 + 隐私徽章 + 模型信息 + 下载/删除/测试。
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
          title: Text(context.l10n.settingsAiFeatures),
          subtitle: Text(
            context.l10n.settingsAiSubtitle,
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
          // 隐私徽章
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    context.l10n.settingsAiPrivacyBadge,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 功能说明卡片 — 模型未下载时显示
          if (availability == LlmAvailability.modelNotDownloaded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: colorScheme.secondaryContainer,
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.settingsAiWhatYouGet,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _FeatureRow(
                        emoji: '\u{1F4D6}',
                        text: context.l10n.settingsAiFeatureDiary,
                        textTheme: textTheme,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _FeatureRow(
                        emoji: '\u{1F4AC}',
                        text: context.l10n.settingsAiFeatureChat,
                        textTheme: textTheme,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 增强模型信息行 — 带状态 Chip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.memory, size: 20),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LlmConstants.modelDisplayName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '1.2 GB \u00B7 Q4_K_M',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(
                  availability: availability,
                  isDownloading: downloadState.isDownloading,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // 下载进度条
          if (downloadState.isDownloading) ...[
            Padding(
              padding: AppSpacing.paddingHBase,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: downloadState.progress > 0
                        ? downloadState.progress
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.xs),
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
            Padding(
              padding: AppSpacing.paddingHBase,
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
                        downloadState.isPaused ? context.l10n.commonResume : context.l10n.commonPause),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(modelDownloadProvider.notifier).cancel();
                    },
                    child: Text(
                      context.l10n.commonCancel,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 操作按钮区域
          if (!downloadState.isDownloading)
            Padding(
              padding: AppSpacing.paddingHBase,
              child: Column(
                children: [
                  // 错误恢复 — error 且模型已下载时显示 Retry
                  if (availability == LlmAvailability.error) ...[
                    if (downloadState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          downloadState.error!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                ref
                                    .read(llmAvailabilityProvider.notifier)
                                    .refresh();
                              },
                              icon: const Icon(Icons.refresh),
                              label: Text(context.l10n.commonRetry),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                ref
                                    .read(modelDownloadProvider.notifier)
                                    .startDownload();
                              },
                              icon: const Icon(Icons.download),
                              label: Text(context.l10n.settingsRedownload),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 下载按钮
                  if (availability == LlmAvailability.modelNotDownloaded)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          ref
                              .read(modelDownloadProvider.notifier)
                              .startDownload();
                        },
                        icon: const Icon(Icons.download),
                        label: Text(context.l10n.settingsDownloadModel),
                      ),
                    ),

                  // Ready 状态 — 测试 + 删除按钮
                  if (availability == LlmAvailability.ready) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRouter.modelTestChat);
                        },
                        icon: const Icon(Icons.chat_outlined),
                        label: Text(context.l10n.settingsTestModel),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _confirmDeleteModel(context, ref),
                        icon: Icon(Icons.delete_outline,
                            color: colorScheme.error),
                        label: Text(
                          context.l10n.settingsDeleteModel,
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // 下载错误信息（非 availability error 时）
          if (downloadState.error != null &&
              availability != LlmAvailability.error)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                downloadState.error!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
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
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsDeleteModelTitle),
        content: Text(l10n.settingsDeleteModelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(modelManagerProvider).deleteModel();
              ref.read(llmAvailabilityProvider.notifier).refresh();
            },
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
  }
}

/// 状态 Chip — 模型可用性的彩色标签。
class _StatusChip extends StatelessWidget {
  final LlmAvailability availability;
  final bool isDownloading;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatusChip({
    required this.availability,
    required this.isDownloading,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final (String label, Color bg, Color fg) = _chipData(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color, Color) _chipData(BuildContext context) {
    final l10n = context.l10n;
    if (isDownloading) {
      return (
        l10n.settingsStatusDownloading,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      );
    }
    switch (availability) {
      case LlmAvailability.ready:
        return (
          l10n.settingsStatusReady,
          Colors.green.withValues(alpha: 0.15),
          Colors.green,
        );
      case LlmAvailability.error:
        return (
          l10n.settingsStatusError,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        );
      case LlmAvailability.modelLoading:
        return (
          l10n.settingsStatusLoading,
          colorScheme.primaryContainer,
          colorScheme.onPrimaryContainer,
        );
      case LlmAvailability.modelNotDownloaded:
        return (
          l10n.settingsStatusNotDownloaded,
          colorScheme.surfaceContainerHighest,
          colorScheme.onSurfaceVariant,
        );
      case LlmAvailability.featureDisabled:
        return (
          l10n.settingsStatusDisabled,
          colorScheme.surfaceContainerHighest,
          colorScheme.onSurfaceVariant,
        );
    }
  }
}

/// 功能说明行。
class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String text;
  final TextTheme textTheme;
  final Color color;

  const _FeatureRow({
    required this.emoji,
    required this.text,
    required this.textTheme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
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
