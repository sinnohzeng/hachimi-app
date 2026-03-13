import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// Page 1 视觉主角 — 单只 kitten 像素猫 + 呼吸动画 + 圆角平台。
class OnboardingCatHero extends ConsumerStatefulWidget {
  final CatAppearance appearance;
  final double size;

  const OnboardingCatHero({
    super.key,
    required this.appearance,
    this.size = 160,
  });

  @override
  ConsumerState<OnboardingCatHero> createState() => _OnboardingCatHeroState();
}

class _OnboardingCatHeroState extends ConsumerState<OnboardingCatHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppMotion.durationParticle,
    );
    _breathScale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathController, curve: AppMotion.standard),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) {
      _breathController.stop();
    } else if (!_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final disable = MediaQuery.disableAnimationsOf(context);

    final sprite = PixelCatSprite(
      appearance: widget.appearance,
      spriteIndex: computeSpriteIndex(
        stage: 'kitten',
        variant: widget.appearance.spriteVariant,
        isLonghair: widget.appearance.isLonghair,
      ),
      size: widget.size,
    );

    final cat = disable
        ? sprite
        : ScaleTransition(scale: _breathScale, child: sprite);

    return Semantics(
      label: 'A pixel cat kitten',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cat,
          const SizedBox(height: AppSpacing.sm),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppShape.borderExtraLarge,
            ),
            child: SizedBox(width: widget.size * 1.2, height: AppSpacing.sm),
          ),
        ],
      ),
    );
  }
}
