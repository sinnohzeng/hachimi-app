import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';
import 'package:hachimi_app/widgets/staggered_list_item.dart';

/// Page 3 视觉主角 — 3 只不同外观的猫组成的群组展示。
class OnboardingCatCluster extends ConsumerWidget {
  final List<CatAppearance> appearances;

  const OnboardingCatCluster({super.key, required this.appearances});

  static const _configs = [
    (stage: 'kitten', size: 80.0),
    (stage: 'adult', size: 120.0),
    (stage: 'adolescent', size: 100.0),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExcludeSemantics(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (
              int i = 0;
              i < _configs.length && i < appearances.length;
              i++
            ) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              StaggeredListItem(
                index: i,
                child: PixelCatSprite(
                  appearance: appearances[i],
                  spriteIndex: computeSpriteIndex(
                    stage: _configs[i].stage,
                    variant: appearances[i].spriteVariant,
                    isLonghair: appearances[i].isLonghair,
                  ),
                  size: _configs[i].size,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
