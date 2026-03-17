import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 像素风阶梯边框形状 — 可直接用于 ThemeData 的 component themes。
///
/// 通过 `ShapeBorder` 接口融入 Flutter 主题级联系统，使所有 Material
/// 组件（Card、Dialog、Chip、BottomSheet、FAB 等）在 Retro Pixel 模式下
/// 自动获得像素阶梯角，无需逐个组件替换。
///
/// 每个角切掉 `step × step`（step = borderWidth × 2）像素，
/// 形成 12 段折线的阶梯矩形路径。
class PixelBorderShape extends OutlinedBorder {
  PixelBorderShape({
    this.borderWidth = 2.0,
    this.borderColor = const Color(0xFF5C3A1E),
    super.side = BorderSide.none,
  });

  /// 像素边框宽度
  final double borderWidth;

  /// 像素边框颜色
  final Color borderColor;

  double get _step => borderWidth * 2;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderWidth);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return steppedPath(rect, _step);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return steppedPath(rect.deflate(borderWidth), _step);
  }

  /// Paint 对象缓存 — PixelBorderShape 是 immutable 的，
  /// late final 确保仅在首次访问时分配一次。
  late final Paint _strokePaint = Paint()
    ..color = borderColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth
    ..isAntiAlias = false;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPath(getOuterPath(rect), _strokePaint);
  }

  /// 生成阶梯角路径 — 每个角切掉 step×step 像素，形成 12 段折线。
  ///
  /// 公开供外部预览组件（如 [UiStyleDialog]）复用。
  static Path steppedPath(Rect rect, double step) {
    final l = rect.left;
    final t = rect.top;
    final r = rect.right;
    final b = rect.bottom;

    return Path()
      ..moveTo(l + step, t)
      ..lineTo(r - step, t) // 顶边
      ..lineTo(r - step, t + step) // 右上阶梯 ↓
      ..lineTo(r, t + step) // 右上阶梯 →
      ..lineTo(r, b - step) // 右边
      ..lineTo(r - step, b - step) // 右下阶梯 ←
      ..lineTo(r - step, b) // 右下阶梯 ↓
      ..lineTo(l + step, b) // 底边
      ..lineTo(l + step, b - step) // 左下阶梯 ↑
      ..lineTo(l, b - step) // 左下阶梯 ←
      ..lineTo(l, t + step) // 左边
      ..lineTo(l + step, t + step) // 左上阶梯 →
      ..close();
  }

  @override
  ShapeBorder scale(double t) {
    return PixelBorderShape(
      borderWidth: borderWidth * t,
      borderColor: borderColor,
      side: side.scale(t),
    );
  }

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return PixelBorderShape(
      borderWidth: borderWidth,
      borderColor: borderColor,
      side: side ?? this.side,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is PixelBorderShape) {
      return PixelBorderShape(
        borderWidth: lerpDouble(a.borderWidth, borderWidth, t) ?? borderWidth,
        borderColor: Color.lerp(a.borderColor, borderColor, t) ?? borderColor,
        side: BorderSide.lerp(a.side, side, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is PixelBorderShape) {
      return PixelBorderShape(
        borderWidth: lerpDouble(borderWidth, b.borderWidth, t) ?? borderWidth,
        borderColor: Color.lerp(borderColor, b.borderColor, t) ?? borderColor,
        side: BorderSide.lerp(side, b.side, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PixelBorderShape &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.side == side;
  }

  @override
  int get hashCode => Object.hash(borderWidth, borderColor, side);
}
