import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/constants/achievement_strings.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';

/// 成就卡片 Widget — 显示单个成就的状态、进度、奖励。
/// 支持层级感知的视觉差异（tier accent stripe + icon glow）。
class AchievementCard extends StatelessWidget {
  final AchievementDef def;
  final bool isUnlocked;
  final AchievementProgress? progress;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.def,
    required this.isUnlocked,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    final isHiddenLocked = def.isHidden && !isUnlocked;
    final tier = CelebrationConfig.tierFromDef(def);

    final icon = isHiddenLocked ? Icons.help_outline : def.icon;
    final iconColor = isUnlocked
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    final iconBgColor = isUnlocked
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final name = isHiddenLocked
        ? l10n.achievementHidden
        : AchievementStrings.name(def.id, locale);
    final desc = isHiddenLocked
        ? l10n.achievementHiddenDesc
        : _resolveDesc(context, locale);

    // 层级色条 — 仅解锁时显示
    final accentColor = isUnlocked ? _tierAccentColor(tier, colorScheme) : null;

    return Card(
      margin: AppSpacing.paddingCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppShape.borderMedium,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      color: isUnlocked
          ? colorScheme.primaryContainer.withValues(alpha: 0.08)
          : colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShape.borderMedium,
        child: Container(
          decoration: accentColor != null
              ? BoxDecoration(
                  borderRadius: AppShape.borderMedium,
                  border: Border(
                    left: BorderSide(color: accentColor, width: 3),
                  ),
                )
              : null,
          padding: AppSpacing.paddingMd,
          child: Row(
            children: [
              // 成就图标 — 圆形
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  boxShadow: isUnlocked && tier == CelebrationTier.epic
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                  semanticLabel: isHiddenLocked ? l10n.achievementHidden : name,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // 名称 + 描述 + 进度条
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isUnlocked
                            ? null
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isUnlocked &&
                        !isHiddenLocked &&
                        progress != null &&
                        def.targetValue != null &&
                        def.targetValue! > 1) ...[
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress!.percent,
                        minHeight: 4,
                        borderRadius: AppShape.borderExtraSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${progress!.current}/${progress!.target}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 奖励/状态
              const SizedBox(width: AppSpacing.sm),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: AppShape.borderSmall,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: 14,
                        semanticLabel: context.l10n.a11yUnlocked,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '+${def.coinReward}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppShape.borderMedium,
                  ),
                  child: Text(
                    '+${def.coinReward}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _tierAccentColor(CelebrationTier tier, ColorScheme colorScheme) {
    switch (tier) {
      case CelebrationTier.epic:
        return colorScheme.primary;
      case CelebrationTier.notable:
        return colorScheme.tertiary;
      case CelebrationTier.standard:
        return colorScheme.outlineVariant;
    }
  }

  String _resolveDesc(BuildContext context, String locale) {
    if (def.category == AchievementCategory.persist) {
      return context.l10n.achievementPersistDesc(def.targetValue ?? 0);
    }
    return AchievementStrings.desc(def.id, locale);
  }
}
