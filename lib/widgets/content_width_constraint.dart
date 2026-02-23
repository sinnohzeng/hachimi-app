import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_breakpoints.dart';

/// 在大屏幕上居中约束内容宽度，手机上无感 passthrough。
///
/// 用于单列布局（TodayTab、ProfileScreen 等），防止内容在平板上拉伸到全屏宽度。
/// 网格布局（CatRoomScreen）不需要此约束 — 使用 maxCrossAxisExtent 自适应。
class ContentWidthConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ContentWidthConstraint({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
