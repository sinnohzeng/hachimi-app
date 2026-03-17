import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_shape.dart';
import '../../core/theme/pixel_theme_extension.dart';
import 'pixel_border.dart';

/// 自适应卡片 — MD3 / Retro Pixel 双模式。
///
/// - MD3：Card + InkWell 涟漪反馈（非交互时退化为 PixelBorder 自适应容器）
/// - Retro：阶梯角边框 + 按压缩放动画 + 触觉反馈
class PixelCard extends StatelessWidget {
  const PixelCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderColor,
    this.fillColor,
    this.borderWidth = 2,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? borderColor;
  final Color? fillColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (!context.pixel.isRetro) return _buildMaterial(context);
    return _RetroPixelCard(
      onTap: onTap,
      onLongPress: onLongPress,
      borderColor: borderColor,
      fillColor: fillColor,
      borderWidth: borderWidth,
      padding: padding,
      child: child,
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final interactive = onTap != null || onLongPress != null;

    // 非交互卡片 — 委托给 PixelBorder（已自适应 MD3 圆角容器）
    if (!interactive) {
      return PixelBorder(
        borderColor: borderColor,
        fillColor: fillColor,
        borderWidth: borderWidth,
        padding: padding,
        child: child,
      );
    }

    return Card(
      color: fillColor,
      child: InkWell(
        borderRadius: AppShape.borderMedium,
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap!();
              },
        onLongPress: onLongPress,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Retro Pixel 渲染 — 阶梯角边框 + 按压缩放动画 + 触觉反馈
// ---------------------------------------------------------------------------

class _RetroPixelCard extends StatefulWidget {
  const _RetroPixelCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderColor,
    this.fillColor,
    this.borderWidth = 2,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? borderColor;
  final Color? fillColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  @override
  State<_RetroPixelCard> createState() => _RetroPixelCardState();
}

class _RetroPixelCardState extends State<_RetroPixelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.97), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.97, end: 1.0), weight: 50),
      ],
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    HapticFeedback.lightImpact();
    _scaleController.forward(from: 0);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null || widget.onLongPress != null;

    final card = PixelBorder(
      borderColor: widget.borderColor,
      fillColor: widget.fillColor,
      borderWidth: widget.borderWidth,
      padding: widget.padding,
      child: widget.child,
    );

    if (!interactive) return card;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Semantics(
        button: true,
        child: GestureDetector(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          child: card,
        ),
      ),
    );
  }
}
