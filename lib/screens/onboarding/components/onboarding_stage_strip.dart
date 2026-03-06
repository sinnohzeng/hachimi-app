import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';

/// Page 2 视觉主角 — 同一只猫的 4 个成长阶段横向排列，尺寸递增。
class OnboardingStageStrip extends ConsumerWidget {
  final CatAppearance appearance;

  const OnboardingStageStrip({super.key, required this.appearance});

  static const _stages = [
    (stage: 'kitten', size: 48.0, hours: '0h'),
    (stage: 'adolescent', size: 64.0, hours: '20h'),
    (stage: 'adult', size: 80.0, hours: '100h'),
    (stage: 'senior', size: 96.0, hours: '200h'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final stageNames = {
      'kitten': l10n.stageKitten,
      'adolescent': l10n.stageAdolescent,
      'adult': l10n.stageAdult,
      'senior': l10n.stageSenior,
    };

    return Semantics(
      label: '4 growth stages: kitten, adolescent, adult, senior',
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < _stages.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              StaggeredListItem(
                index: i,
                child: _StageColumn(
                  appearance: appearance,
                  stage: _stages[i].stage,
                  size: _stages[i].size,
                  hours: _stages[i].hours,
                  label: stageNames[_stages[i].stage] ?? _stages[i].stage,
                  color: stageColor(_stages[i].stage),
                  textTheme: textTheme,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StageColumn extends StatelessWidget {
  final CatAppearance appearance;
  final String stage;
  final double size;
  final String hours;
  final String label;
  final Color color;
  final TextTheme textTheme;

  const _StageColumn({
    required this.appearance,
    required this.stage,
    required this.size,
    required this.hours,
    required this.label,
    required this.color,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 96,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PixelCatSprite(
              appearance: appearance,
              spriteIndex: computeSpriteIndex(
                stage: stage,
                variant: appearance.spriteVariant,
                isLonghair: appearance.isLonghair,
              ),
              size: size,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(hours, style: textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
