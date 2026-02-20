// ---
// 📘 文件说明：
// TappableCatSprite — 可点击切换动作的像素猫交互组件。
// 包裹 PixelCatSprite，提供 tap-to-cycle pose + bounce animation + haptic feedback。
// 所有展示猫猫形象的页面应使用此组件代替裸 PixelCatSprite。
//
// 📋 程序整体伪代码：
// 1. 接收 cat + size + enableTap 参数；
// 2. 维护本地 _displayVariant 状态（不持久化）；
// 3. 点击时循环切换 variant (0→1→2→0)，触发弹跳动画和触觉反馈；
// 4. 使用 computeSpriteIndex 计算当前 sprite；
// 5. 通过 GestureDetector + AnimatedBuilder + Transform.scale 实现弹跳；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show computeSpriteIndex;
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// TappableCatSprite — 交互式像素猫组件。
///
/// 点击切换 3 种动作姿势，带弹跳动画和触觉反馈。
/// [enableTap] 为 false 时退化为静态 PixelCatSprite。
class TappableCatSprite extends StatefulWidget {
  final Cat cat;
  final double size;
  final bool enableTap;

  const TappableCatSprite({
    super.key,
    required this.cat,
    this.size = 100,
    this.enableTap = true,
  });

  @override
  State<TappableCatSprite> createState() => _TappableCatSpriteState();
}

class _TappableCatSpriteState extends State<TappableCatSprite>
    with SingleTickerProviderStateMixin {
  /// Local-only display variant for pose cycling (not persisted).
  int? _displayVariant;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _cyclePose() {
    final current = _displayVariant ?? widget.cat.appearance.spriteVariant;
    setState(() {
      _displayVariant = (current + 1) % 3;
    });
    HapticFeedback.lightImpact();
    _bounceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.cat;
    final displayVariant = _displayVariant ?? cat.appearance.spriteVariant;
    final spriteIndex = computeSpriteIndex(
      stage: cat.computedStage,
      variant: displayVariant,
      isLonghair: cat.appearance.isLonghair,
    );

    final sprite = PixelCatSprite(
      appearance: cat.appearance,
      spriteIndex: spriteIndex,
      accessoryId: cat.equippedAccessory,
      size: widget.size,
    );

    if (!widget.enableTap) return sprite;

    return GestureDetector(
      onTap: _cyclePose,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) => Transform.scale(
          scale: _bounceAnimation.value,
          child: child,
        ),
        child: sprite,
      ),
    );
  }
}
