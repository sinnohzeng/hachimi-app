import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/constants/achievement_strings.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';

/// 成就卡片 Widget — 显示单个成就的状态、进度、奖励。
class AchievementCard extends StatelessWidget {
  final AchievementDef def;
  final bool isUnlocked;
  final AchievementProgress? progress;

  const AchievementCard({
    super.key,
    required this.def,
    required this.isUnlocked,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;

    // 隐藏成就且未解锁时显示为问号
    final isHiddenLocked = def.isHidden && !isUnlocked;

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppShape.borderMedium,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 成就图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: AppShape.borderMedium,
              ),
              child: Icon(icon, color: iconColor, size: 24),
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
                  // 进度条（有 targetValue 且未解锁时显示）
                  if (!isUnlocked &&
                      !isHiddenLocked &&
                      progress != null &&
                      def.targetValue != null &&
                      def.targetValue! > 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: progress!.percent,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
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
              Icon(Icons.check_circle, color: colorScheme.primary, size: 24)
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  String _resolveDesc(BuildContext context, String locale) {
    if (def.category == AchievementCategory.persist) {
      return context.l10n.achievementPersistDesc(def.targetValue ?? 0);
    }
    return AchievementStrings.desc(def.id, locale);
  }
}
