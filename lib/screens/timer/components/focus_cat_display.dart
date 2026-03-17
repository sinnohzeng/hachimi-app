import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/xp_result.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// 专注完成页的猫咪展示区：sprite + 名字 + 阶段进化标签。
class FocusCatDisplay extends StatelessWidget {
  final Cat cat;
  final StageUpResult? stageUp;

  const FocusCatDisplay({super.key, required this.cat, this.stageUp});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final didStageUp = stageUp?.didStageUp ?? false;

    return Column(
      children: [
        TappableCatSprite(cat: cat, size: 120),
        const SizedBox(height: 12),
        Text(
          cat.name,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (didStageUp) _buildStageUpBadge(context, textTheme),
      ],
    );
  }

  Widget _buildStageUpBadge(BuildContext context, TextTheme textTheme) {
    final l10n = context.l10n;
    final newStage = stageUp!.newStage;
    final color = stageColor(newStage);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.30 : 0.15),
          borderRadius: AppShape.borderLarge,
        ),
        child: Text(
          l10n.focusCompleteEvolvedTo(
            newStage[0].toUpperCase() + newStage.substring(1),
          ),
          style: textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
