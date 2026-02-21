import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show peltColorToMaterial;

/// 为猫猫详情页生成 4 色 mesh 渐变色列表。
///
/// 色彩策略：基于毛色和阶段色混合，保持鲜明但柔和。
List<Color> catMeshColors(
  String stage,
  String peltColor,
  ColorScheme colorScheme,
) {
  final peltClr = peltColorToMaterial(peltColor);
  final stageClr = stageColor(stage);

  return [
    Color.lerp(peltClr, colorScheme.surface, 0.6)!,
    Color.lerp(stageClr, colorScheme.surface, 0.5)!,
    Color.lerp(peltClr, stageClr, 0.4)!.withValues(alpha: 0.3),
    colorScheme.surface,
  ];
}

/// 为计时页生成 4 色 mesh 渐变色列表。
///
/// 色彩策略：极低饱和度，不分散注意力，仅提供微妙的环境感。
List<Color> timerMeshColors(Color stageClr, ColorScheme colorScheme) {
  return [
    Color.lerp(stageClr, colorScheme.surface, 0.85)!,
    Color.lerp(stageClr, colorScheme.surface, 0.90)!,
    Color.lerp(stageClr, colorScheme.surface, 0.95)!,
    colorScheme.surface,
  ];
}
