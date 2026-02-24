import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart'
    show computeSpriteIndex;
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// TappableCatSprite — 交互式像素猫组件。
///
/// 点击切换 3 种动作姿势，带弹跳动画和触觉反馈。
/// 姿势会持久化到本地 SQLite（display_pose 列）。
/// [enableTap] 为 false 时退化为静态 PixelCatSprite。
class TappableCatSprite extends ConsumerStatefulWidget {
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
  ConsumerState<TappableCatSprite> createState() => _TappableCatSpriteState();
}

class _TappableCatSpriteState extends ConsumerState<TappableCatSprite>
    with SingleTickerProviderStateMixin {
  /// 本次会话内的临时姿势（尚未写入 DB 前的即时反馈）。
  int? _displayVariant;

  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
    _bounceAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _bounceController,
            curve: AppMotion.standardDecelerate,
          ),
        );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _cyclePose() {
    final cat = widget.cat;
    final current =
        _displayVariant ?? cat.displayPose ?? cat.appearance.spriteVariant;
    final newPose = (current + 1) % 3;
    setState(() => _displayVariant = newPose);
    HapticFeedback.lightImpact();
    _bounceController.forward(from: 0);

    // 持久化到 SQLite
    ref.read(localCatRepositoryProvider).updateDisplayPose(cat.id, newPose);
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.cat;
    final displayVariant =
        _displayVariant ?? cat.displayPose ?? cat.appearance.spriteVariant;
    final spriteIndex = computeSpriteIndex(
      stage: cat.displayStage,
      variant: displayVariant,
      isLonghair: cat.appearance.isLonghair,
    );

    final sprite = PixelCatSprite(
      appearance: cat.appearance,
      spriteIndex: spriteIndex,
      accessoryId: cat.equippedAccessory,
      size: widget.size,
    );

    if (!widget.enableTap) {
      return Semantics(label: '${cat.name} cat', image: true, child: sprite);
    }

    return Semantics(
      label: '${cat.name}, tap to interact',
      button: true,
      child: GestureDetector(
        onTap: _cyclePose,
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) =>
              Transform.scale(scale: _bounceAnimation.value, child: child),
          child: sprite,
        ),
      ),
    );
  }
}
