import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/app_info_provider.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/locale_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/guest_upgrade_prompt.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';

import 'components/delete_account_flow.dart';
import 'components/notification_settings_dialog.dart';
import 'components/language_dialog.dart';
import 'components/theme_mode_dialog.dart';
import 'components/theme_color_dialog.dart';
import 'components/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final themeSettings = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final isGuest = ref.watch(isAnonymousProvider);

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ContentWidthConstraint(
        child: ListView(
          children: [
            // General section
            StaggeredListItem(
              index: 0,
              child: SectionHeader(
                title: l10n.settingsGeneral,
                colorScheme: colorScheme,
              ),
            ),
            StaggeredListItem(
              index: 1,
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(l10n.settingsNotifications),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showNotificationSettings(context),
              ),
            ),
            StaggeredListItem(
              index: 2,
              child: ListTile(
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
            ),

            const SizedBox(height: AppSpacing.sm),
            const Divider(),

            // Appearance section
            StaggeredListItem(
              index: 3,
              child: SectionHeader(
                title: l10n.settingsAppearance,
                colorScheme: colorScheme,
              ),
            ),
            StaggeredListItem(
              index: 4,
              child: ListTile(
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
            ),
            StaggeredListItem(
              index: 5,
              child: ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.settingsThemeColor),
                subtitle: themeSettings.useDynamicColor
                    ? Text(
                        l10n.settingsThemeColorDynamic,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (themeSettings.useDynamicColor)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Color(0xFF4285F4),
                              Color(0xFF34A853),
                              Color(0xFFFBBC05),
                              Color(0xFFEA4335),
                              Color(0xFF4285F4),
                            ],
                          ),
                        ),
                      )
                    else
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
                onTap: () => _showThemeColorSettings(context),
              ),
            ),
            StaggeredListItem(
              index: 6,
              child: SwitchListTile(
                secondary: const Icon(Icons.auto_awesome_outlined),
                title: Text(l10n.settingsBackgroundAnimation),
                subtitle: Text(
                  l10n.settingsBackgroundAnimationSubtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                value: themeSettings.enableBackgroundAnimation,
                onChanged: (value) {
                  ref
                      .read(themeProvider.notifier)
                      .setBackgroundAnimation(value);
                },
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
            const Divider(),

            // AI Model section
            StaggeredListItem(
              index: 7,
              child: SectionHeader(
                title: l10n.settingsAiModel,
                colorScheme: colorScheme,
              ),
            ),
            StaggeredListItem(
              index: 8,
              child: _buildAiListTile(
                context,
                ref,
                l10n,
                colorScheme,
                textTheme,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),
            const Divider(),

            // About section
            StaggeredListItem(
              index: 9,
              child: SectionHeader(
                title: l10n.settingsAbout,
                colorScheme: colorScheme,
              ),
            ),
            StaggeredListItem(
              index: 10,
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.settingsVersion),
                subtitle: ref
                    .watch(appInfoProvider)
                    .when(
                      data: (info) => Text(info.version),
                      loading: () => const Text('...'),
                      error: (_, _) => const Text('?'),
                    ),
              ),
            ),
            StaggeredListItem(
              index: 11,
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.settingsLicenses),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final version =
                      ref.read(appInfoProvider).value?.version ?? '';
                  showLicensePage(
                    context: context,
                    applicationName: 'Hachimi',
                    applicationVersion: version,
                  );
                },
              ),
            ),

            // Spacing to push account section to bottom
            const SizedBox(height: AppSpacing.xxl),
            const Divider(),

            // Account section
            StaggeredListItem(
              index: 12,
              child: SectionHeader(
                title: l10n.settingsAccount,
                colorScheme: colorScheme,
              ),
            ),
            if (isGuest) ...[
              // 访客：登录入口 + 清除数据
              StaggeredListItem(
                index: 13,
                child: ListTile(
                  leading: Icon(Icons.login, color: colorScheme.primary),
                  title: Text(
                    l10n.drawerGuestSignIn,
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showGuestUpgradePrompt(context, ref),
                ),
              ),
              StaggeredListItem(
                index: 14,
                child: ListTile(
                  leading: Icon(
                    Icons.delete_sweep_outlined,
                    color: colorScheme.error,
                  ),
                  title: Text(
                    l10n.settingsResetData,
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: () => _confirmResetData(context, ref),
                ),
              ),
            ] else ...[
              // 已登录：退出 + 删除账号
              StaggeredListItem(
                index: 13,
                child: ListTile(
                  leading: Icon(Icons.logout, color: colorScheme.error),
                  title: Text(
                    l10n.commonLogOut,
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: () => _confirmLogout(context, ref),
                ),
              ),
              StaggeredListItem(
                index: 14,
                child: ListTile(
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
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // --- AI Settings Navigation ---

  Widget _buildAiListTile(
    BuildContext context,
    WidgetRef ref,
    S l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final aiEnabled = ref.watch(aiFeatureEnabledProvider);
    final availability = ref.watch(aiAvailabilityProvider);
    final aiService = ref.watch(aiServiceProvider);

    final subtitle = aiEnabled
        ? '${aiService.providerName} · ${_availabilityLabel(availability, l10n)}'
        : l10n.settingsStatusDisabled;

    return ListTile(
      leading: const Icon(Icons.smart_toy_outlined),
      title: Text(l10n.settingsAiFeatures),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).pushNamed(AppRouter.aiSettings),
    );
  }

  String _availabilityLabel(AiAvailability availability, S l10n) {
    return switch (availability) {
      AiAvailability.ready => l10n.settingsStatusReady,
      AiAvailability.error => l10n.settingsStatusError,
      AiAvailability.disabled => l10n.settingsStatusDisabled,
    };
  }

  // --- Notification Settings ---

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const NotificationSettingsDialog(),
    );
  }

  // --- Language Settings ---

  String _localeName(Locale? locale, S l10n) {
    if (locale == null) return l10n.settingsLanguageSystem;
    // 繁体中文需要检查 scriptCode
    if (locale.languageCode == 'zh' && locale.scriptCode == 'Hant') {
      return l10n.settingsLanguageTraditionalChinese;
    }
    switch (locale.languageCode) {
      case 'en':
        return l10n.settingsLanguageEnglish;
      case 'zh':
        return l10n.settingsLanguageChinese;
      case 'ja':
        return l10n.settingsLanguageJapanese;
      case 'ko':
        return l10n.settingsLanguageKorean;
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageSettings(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => LanguageDialog(currentLocale: currentLocale),
    ).then((result) {
      if (result != null) {
        if (result == 'system') {
          ref.read(localeProvider.notifier).setLocale(null);
        } else if (result == 'zh_Hant') {
          ref
              .read(localeProvider.notifier)
              .setLocale(
                const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant',
                ),
              );
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
      builder: (ctx) => ThemeModeDialog(currentMode: currentMode),
    ).then((result) {
      if (result != null) {
        ref.read(themeProvider.notifier).setMode(result as ThemeMode);
      }
    });
  }

  // --- Theme Color Settings ---

  void _showThemeColorSettings(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const ThemeColorDialog());
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

  void _confirmResetData(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: Theme.of(ctx).colorScheme.error,
          size: 32,
        ),
        title: Text(l10n.settingsResetDataTitle),
        content: Text(l10n.settingsResetDataMessage),
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
            child: Text(l10n.guestUpgradeLinkButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authServiceProvider).signOut();
            },
            child: Text(
              l10n.settingsResetData,
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    DeleteAccountFlow(context: context, ref: ref).start();
  }
}
