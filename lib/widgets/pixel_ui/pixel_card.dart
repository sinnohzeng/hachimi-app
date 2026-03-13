import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pixel_border.dart';

/// 像素风卡片 — 取代猫咪屏幕中的 Material Card。
///
/// 内置 PixelBorder + InkWell + 按压缩放反馈。
class PixelCard extends StatefulWidget {
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
  State<PixelCard> createState() => _PixelCardState();
}

class _PixelCardState extends State<PixelCard>
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
      child: GestureDetector(
        onTap: _handleTap,
        onLongPress: widget.onLongPress,
        child: card,
      ),
    );
  }
}
