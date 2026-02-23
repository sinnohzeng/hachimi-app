import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hachimi_app/core/constants/ai_constants.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/ai_provider.dart';

/// AI 设置区块 — 总开关 + 云端标识 + 状态 chip + 测试连接。
class AiSettingsSection extends ConsumerWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const AiSettingsSection({
    super.key,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiEnabled = ref.watch(aiFeatureEnabledProvider);
    final availability = ref.watch(aiAvailabilityProvider);

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
          onChanged: (value) => _handleToggle(context, ref, value),
        ),

        if (aiEnabled) ...[
          // 云端 AI 标识
          _buildCloudBadge(context),

          // 功能介绍卡片
          _buildFeatureCard(context),

          // 状态行：提供商名称 + 状态 chip
          _buildStatusRow(context, ref, availability),
          const SizedBox(height: AppSpacing.sm),

          // 操作按钮
          _buildActions(context, ref, availability),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }

  // ─── Private Widgets ───

  Widget _buildCloudBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.cloud_outlined, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.l10n.settingsAiCloudBadge,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    WidgetRef ref,
    AiAvailability availability,
  ) {
    final aiService = ref.watch(aiServiceProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.cloud_done_outlined, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aiService.providerName,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  context.l10n.aiRequiresNetwork,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _StatusChip(
            availability: availability,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    AiAvailability availability,
  ) {
    return Padding(
      padding: AppSpacing.paddingHBase,
      child: Column(
        children: [
          if (availability == AiAvailability.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                context.l10n.settingsConnectionFailed,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ),

          // 测试连接
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () async {
                final ok = await ref
                    .read(aiAvailabilityProvider.notifier)
                    .validateConnection();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? context.l10n.settingsConnectionSuccess
                          : context.l10n.settingsConnectionFailed,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.wifi_find),
              label: Text(context.l10n.settingsTestConnection),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // 测试聊天
          if (availability == AiAvailability.ready)
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.modelTestChat);
                },
                icon: const Icon(Icons.chat_outlined),
                label: Text(context.l10n.settingsTestModel),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Toggle + Privacy Dialog ───

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    if (value) {
      final prefs = await SharedPreferences.getInstance();
      final acknowledged =
          prefs.getBool(AiConstants.prefAiPrivacyAcknowledged) ?? false;

      if (!acknowledged) {
        if (!context.mounted) return;
        final accepted = await _showPrivacyDialog(context);
        if (accepted != true) return;
        await prefs.setBool(AiConstants.prefAiPrivacyAcknowledged, true);
      }
    }

    ref.read(aiFeatureEnabledProvider.notifier).setEnabled(value);
    ref.read(aiAvailabilityProvider.notifier).refresh();
  }

  Future<bool?> _showPrivacyDialog(BuildContext context) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.aiPrivacyTitle),
        content: Text(l10n.aiPrivacyMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.aiPrivacyAccept),
          ),
        ],
      ),
    );
  }
}

// ─── Extracted Widgets ───

/// 状态 chip — 3 态显示。
class _StatusChip extends StatelessWidget {
  final AiAvailability availability;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatusChip({
    required this.availability,
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
    switch (availability) {
      case AiAvailability.ready:
        final brightness = Theme.of(context).brightness;
        return (
          l10n.settingsStatusReady,
          StatusColors.successContainer(brightness),
          StatusColors.onSuccess(brightness),
        );
      case AiAvailability.error:
        return (
          l10n.settingsStatusError,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        );
      case AiAvailability.disabled:
        return (
          l10n.settingsStatusDisabled,
          colorScheme.surfaceContainerHighest,
          colorScheme.onSurfaceVariant,
        );
    }
  }
}

/// 功能描述行。
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
          child: Text(text, style: textTheme.bodySmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}
