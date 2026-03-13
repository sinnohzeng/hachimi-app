import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:intl/intl.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/constants/achievement_strings.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/models/unlocked_achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';

/// 显示单个成就详情的底部弹窗。
void showAchievementDetailSheet(
  BuildContext context, {
  required AchievementDef def,
  required bool isUnlocked,
  AchievementProgress? progress,
  LocalAchievement? localAchievement,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxSheetWidth),
    builder: (_) => _DetailContent(
      def: def,
      isUnlocked: isUnlocked,
      progress: progress,
      localAchievement: localAchievement,
      locale: Localizations.localeOf(context).toString(),
    ),
  );
}

class _DetailContent extends StatelessWidget {
  final AchievementDef def;
  final bool isUnlocked;
  final AchievementProgress? progress;
  final LocalAchievement? localAchievement;
  final String locale;

  const _DetailContent({
    required this.def,
    required this.isUnlocked,
    this.progress,
    this.localAchievement,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tier = CelebrationConfig.tierFromDef(def);

    final name = AchievementStrings.name(def.id, locale);
    final desc = _resolveDesc(context);

    return SafeArea(
      child: Padding(
        padding: AppSpacing.paddingHBase,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(colorScheme, tier),
            const SizedBox(height: AppSpacing.md),
            Text(
              name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              desc,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            _TierChip(tier: tier, colorScheme: colorScheme),
            const Divider(height: 24),
            if (isUnlocked)
              _buildUnlockedInfo(context, colorScheme, textTheme)
            else
              _buildLockedInfo(context, colorScheme, textTheme),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme, CelebrationTier tier) {
    final bgColor = isUnlocked
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final iconColor = isUnlocked
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.4);

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(def.icon, color: iconColor, size: 32),
    );
  }

  Widget _buildUnlockedInfo(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = context.l10n;
    final unlockedAt = localAchievement?.unlockedAt;
    final dateStr = _formatUnlockedDate(context, unlockedAt);

    return Column(
      children: [
        _InfoRow(
          icon: Icons.check_circle,
          iconColor: colorScheme.primary,
          text: l10n.achievementUnlockedAt(dateStr),
        ),
        _InfoRow(
          icon: Icons.monetization_on,
          iconColor: BrandColors.achievementStar,
          text: l10n.achievementRewardCoins(def.coinReward),
        ),
        if (def.titleReward != null)
          _InfoRow(
            icon: Icons.military_tech,
            iconColor: colorScheme.primary,
            text: AchievementStrings.titleName(def.titleReward!, locale),
          ),
      ],
    );
  }

  Widget _buildLockedInfo(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final l10n = context.l10n;
    final showProgress =
        progress != null && def.targetValue != null && def.targetValue! > 1;

    return Column(
      children: [
        _InfoRow(
          icon: Icons.lock_outline,
          iconColor: colorScheme.onSurfaceVariant,
          text: l10n.achievementLocked,
        ),
        if (showProgress) ...[
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: AppSpacing.paddingHBase,
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress!.percent,
                  minHeight: 6,
                  borderRadius: AppShape.borderExtraSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${progress!.current}/${progress!.target}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
        _InfoRow(
          icon: Icons.monetization_on,
          iconColor: BrandColors.achievementStar,
          text: l10n.achievementRewardCoins(def.coinReward),
        ),
      ],
    );
  }

  String _resolveDesc(BuildContext context) {
    if (def.category == AchievementCategory.persist) {
      return context.l10n.achievementPersistDesc(def.targetValue ?? 0);
    }
    return AchievementStrings.desc(def.id, locale);
  }

  String _formatUnlockedDate(BuildContext context, DateTime? unlockedAt) {
    if (unlockedAt == null) return '—';
    final loc = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(loc).format(unlockedAt);
    final time = DateFormat.Hm().format(unlockedAt);
    return '$date $time';
  }
}

/// 层级标签 — 显示成就的稀有度层级。
class _TierChip extends StatelessWidget {
  final CelebrationTier tier;
  final ColorScheme colorScheme;

  const _TierChip({required this.tier, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final (label, bgColor) = switch (tier) {
      CelebrationTier.epic => ('Epic', colorScheme.primaryContainer),
      CelebrationTier.notable => ('Notable', colorScheme.tertiaryContainer),
      CelebrationTier.standard => (
        'Standard',
        colorScheme.surfaceContainerHighest,
      ),
    };

    return Chip(
      label: Text(label),
      backgroundColor: bgColor,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// 单行信息展示：图标 + 文字。
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor, semanticLabel: text),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
