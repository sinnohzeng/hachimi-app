import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/llm_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/llm_provider.dart';

/// AI Model settings section -- feature toggle + privacy badge + model info
/// + download/delete/test.
class AiModelSection extends ConsumerWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const AiModelSection({
    super.key,
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
        // AI feature toggle
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
          // Privacy badge
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

          // Feature card -- shown when model not downloaded
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
                      FeatureRow(
                        emoji: '\u{1F4D6}',
                        text: context.l10n.settingsAiFeatureDiary,
                        textTheme: textTheme,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      FeatureRow(
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

          // Enhanced model info row with status chip
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
                StatusChip(
                  availability: availability,
                  isDownloading: downloadState.isDownloading,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Download progress bar
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
                      final notifier = ref.read(modelDownloadProvider.notifier);
                      if (downloadState.isPaused) {
                        notifier.resume();
                      } else {
                        notifier.pause();
                      }
                    },
                    child: Text(
                      downloadState.isPaused
                          ? context.l10n.commonResume
                          : context.l10n.commonPause,
                    ),
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

          // Action buttons area
          if (!downloadState.isDownloading)
            Padding(
              padding: AppSpacing.paddingHBase,
              child: Column(
                children: [
                  // Error recovery -- retry when error and model downloaded
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

                  // Download button
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

                  // Ready state -- test + delete buttons
                  if (availability == LlmAvailability.ready) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRouter.modelTestChat);
                        },
                        icon: const Icon(Icons.chat_outlined),
                        label: Text(context.l10n.settingsTestModel),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDeleteModel(context, ref),
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                        ),
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

          // Download error message (when not availability error)
          if (downloadState.error != null &&
              availability != LlmAvailability.error)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                downloadState.error!,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
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

/// Status chip -- colored label for model availability state.
class StatusChip extends StatelessWidget {
  final LlmAvailability availability;
  final bool isDownloading;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const StatusChip({
    super.key,
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

/// Feature description row with emoji and text.
class FeatureRow extends StatelessWidget {
  final String emoji;
  final String text;
  final TextTheme textTheme;
  final Color color;

  const FeatureRow({
    super.key,
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
