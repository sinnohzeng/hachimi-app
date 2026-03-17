import 'package:flutter/material.dart';

import '../../core/theme/app_shape.dart';

/// MD3 模式公用构建函数 — 像素组件在 `!isRetro` 时复用。
///
/// 模块私有（`_` 前缀），仅供 `pixel_ui/` 内部使用。

/// 标准 MD3 容器 — 替代 PixelBorder 的阶梯角 CustomPaint。
Widget md3Container({
  required ColorScheme scheme,
  required Widget child,
  BorderRadius? borderRadius,
  EdgeInsetsGeometry? padding,
  Color? fillColor,
  Color? borderColor,
}) {
  return Container(
    padding: padding ?? const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: borderRadius ?? AppShape.borderMedium,
      color: fillColor ?? scheme.surfaceContainerLow,
      border: Border.all(color: borderColor ?? scheme.outlineVariant),
    ),
    child: child,
  );
}

/// 标准 MD3 分割线 — 替代像素虚线 CustomPaint。
Widget md3Divider({Color? color, double? indent}) {
  return Divider(height: 1, thickness: 0.5, color: color, indent: indent);
}
