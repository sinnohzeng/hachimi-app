import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_icon_size.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/pixel_theme_extension.dart';
import 'package:hachimi_app/l10n/appearance_l10n.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_card.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_milestone.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_progress_bar.dart';
import 'package:hachimi_app/widgets/pixel_ui/pixel_section_header.dart';

/// About card — personality, appearance summary, expandable details, status.
class EnhancedCatInfoCard extends StatelessWidget {
  final Cat cat;

  const EnhancedCatInfoCard({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final personality = personalityMap[cat.personality];
    final a = cat.appearance;
    final summary = l10n.fullAppearanceSummary(a);

    return PixelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PixelSectionHeader(
            title: context.l10n.catDetailAbout(cat.name),
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Growth progress
          _GrowthSection(cat: cat),
          const Divider(height: 24),

          // Personality
          if (personality != null) ...[
            Row(
              children: [
                Text(
                  '${personality.emoji} ',
                  style: const TextStyle(fontSize: AppIconSize.emojiSmall),
                ),
                Text(
                  l10n.personalityName(personality.id),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.personalityFlavor(personality.id),
              style: textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Summary line
          Container(
            width: double.infinity,
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: AppShape.borderSmall,
            ),
            child: Text(summary, style: textTheme.bodyMedium),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Expandable appearance details
          Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                context.l10n.catDetailAppearanceDetails,
                style: textTheme.labelLarge,
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              children: _buildAppearanceDetails(context, a),
            ),
          ),

          const Divider(height: 24),
          InfoRow(
            label: context.l10n.catDetailStatus,
            value: cat.state[0].toUpperCase() + cat.state.substring(1),
          ),
          InfoRow(
            label: context.l10n.catDetailAdopted,
            value: _formatDate(cat.createdAt),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppearanceDetails(BuildContext context, CatAppearance a) {
    final l10n = context.l10n;
    final details = <Widget>[
      InfoRow(
        label: l10n.catDetailFurPattern,
        value: l10n.peltTypeName(a.peltType),
      ),
      InfoRow(
        label: l10n.catDetailFurColor,
        value: l10n.peltColorName(a.peltColor),
      ),
      InfoRow(
        label: l10n.catDetailFurLength,
        value: l10n.furLength(a.isLonghair),
      ),
      InfoRow(
        label: l10n.catDetailEyes,
        value: l10n.eyeDesc(a.eyeColor, a.eyeColor2),
      ),
    ];

    if (a.whitePatches != null) {
      details.add(
        InfoRow(label: l10n.catDetailWhitePatches, value: a.whitePatches!),
      );
    }
    final patchesTint = l10n.whitePatchesTintName(a.whitePatchesTint);
    if (patchesTint != null) {
      details.add(
        InfoRow(label: l10n.catDetailPatchesTint, value: patchesTint),
      );
    }
    if (a.tint != 'none') {
      details.add(
        InfoRow(
          label: l10n.catDetailTint,
          value: a.tint[0].toUpperCase() + a.tint.substring(1),
        ),
      );
    }
    if (a.points != null) {
      details.add(InfoRow(label: l10n.catDetailPoints, value: a.points!));
    }
    if (a.vitiligo != null) {
      details.add(InfoRow(label: l10n.catDetailVitiligo, value: a.vitiligo!));
    }
    if (a.isTortie) {
      details.add(
        InfoRow(label: l10n.catDetailTortoiseshell, value: l10n.commonYes),
      );
      if (a.tortiePattern != null) {
        details.add(
          InfoRow(label: l10n.catDetailTortiePattern, value: a.tortiePattern!),
        );
      }
      if (a.tortieColor != null) {
        details.add(
          InfoRow(
            label: l10n.catDetailTortieColor,
            value: l10n.peltColorName(a.tortieColor!),
          ),
        );
      }
    }
    details.add(
      InfoRow(
        label: l10n.catDetailSkin,
        value: l10n.skinColorName(a.skinColor),
      ),
    );

    return details;
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

/// A label-value row for displaying cat info details.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.paddingVXs,
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// 成长进度区块 — 嵌入「关于猫猫」卡片中。
class _GrowthSection extends StatelessWidget {
  final Cat cat;

  const _GrowthSection({required this.cat});

  @override
  Widget build(BuildContext context) {
    final stageClr = stageColor(cat.displayStage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressHeader(context, stageClr),
        const SizedBox(height: AppSpacing.sm),
        _buildStatsRow(context),
        const SizedBox(height: AppSpacing.md),
        _buildMilestones(context),
      ],
    );
  }

  Widget _buildProgressHeader(BuildContext context, Color stageClr) {
    final pixel = context.pixel;

    return Column(
      children: [
        Row(
          children: [
            Text(
              context.l10n.catDetailGrowthTitle,
              style: pixel.pixelHeading.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              context.l10n.stageName(cat.displayStage),
              style: pixel.pixelLabel.copyWith(
                color: stageClr,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        PixelProgressBar(
          value: cat.growthProgress,
          segments: 20,
          filledColor: stageClr,
          height: 12,
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${cat.totalMinutes ~/ 60}h ${cat.totalMinutes % 60}m',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          '200h',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestones(BuildContext context) {
    return PixelMilestone(
      stages: [
        context.l10n.stageKitten,
        context.l10n.stageAdolescent,
        context.l10n.stageAdult,
        context.l10n.stageSenior,
      ],
      currentIndex: stageOrder(cat.displayStage),
      stageColors: [
        stageColor('kitten'),
        stageColor('adolescent'),
        stageColor('adult'),
        stageColor('senior'),
      ],
    );
  }
}
