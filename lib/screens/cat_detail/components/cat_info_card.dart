// ---
// 📘 文件说明：
// Enhanced Cat Info Card — 增强版猫猫信息卡片组件。
// 展示性格、外观摘要、可展开的外观详情和状态信息。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 Cat 数据；
// 2. 渲染性格 emoji + 名称 + 风味文字；
// 3. 渲染外观摘要文字块；
// 4. 渲染可展开的外观详情列表（InfoRow）；
// 5. 渲染状态和领养日期；
//
// 🧩 文件结构：
// - EnhancedCatInfoCard：增强版猫猫信息卡片 StatelessWidget；
// - InfoRow：信息行辅助 Widget；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/appearance_l10n.dart';
import 'package:hachimi_app/l10n/cat_l10n.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

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

    return Card(
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.catDetailAbout(cat.name),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Personality
            if (personality != null) ...[
              Row(
                children: [
                  Text(
                    '${personality.emoji} ',
                    style: const TextStyle(fontSize: 20),
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
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
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
