import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_response_templates.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/mood.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/widgets/pixel_cat_sprite.dart';

/// CatBedtimeAnimation — 猫咪睡前反应动画。
///
/// 根据心情等级播放不同动画效果，并叠加文字气泡。
/// 文字在动画开始 300ms 后淡入，3 秒后自动消失，
/// 也可点击提前关闭。
class CatBedtimeAnimation extends ConsumerStatefulWidget {
  /// 当前心情。
  final Mood mood;

  const CatBedtimeAnimation({super.key, required this.mood});

  @override
  ConsumerState<CatBedtimeAnimation> createState() =>
      _CatBedtimeAnimationState();
}

class _CatBedtimeAnimationState extends ConsumerState<CatBedtimeAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _spriteController;
  late final AnimationController _textController;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _spriteController = AnimationController(
      vsync: this,
      duration: AppMotion.durationLong2,
    );
    _textController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium2,
    );
    _startSequence();
  }

  void _startSequence() {
    _spriteController.forward();
    // 文字延迟 300ms 后淡入。
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _textController.forward();
      // 3 秒后自动消失。
      _dismissTimer = Timer(const Duration(seconds: 3), _dismiss);
    });
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    if (!mounted) return;
    _textController.reverse();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _spriteController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 装饰性动画：加载中/错误时显示空占位即可，无需阻断用户流程。
    final cats = ref.watch(catsProvider).value ?? [];
    final cat = cats.isNotEmpty ? cats.first : null;
    final catName = cat?.name ?? 'Hachimi';
    final locale = Localizations.localeOf(context).languageCode;
    final scene = switch (widget.mood) {
      Mood.veryHappy => CatResponseScene.lightVeryHappy,
      Mood.happy => CatResponseScene.lightHappy,
      Mood.calm => CatResponseScene.lightCalm,
      Mood.down => CatResponseScene.lightDown,
      Mood.veryDown => CatResponseScene.lightVeryDown,
    };
    final responseText = getRandomCatResponse(
      scene,
      locale: locale,
      params: {'catName': catName},
    );

    return GestureDetector(
      onTap: _dismiss,
      child: SizedBox(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildSpriteAnimation(cat),
            Positioned(
              top: AppSpacing.sm,
              child: _buildTextBubble(context, responseText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpriteAnimation(Cat? cat) {
    final animation = _buildMoodAnimation();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _moodOffset(animation.value),
          child: Transform.scale(
            scale: _moodScale(animation.value),
            child: child,
          ),
        );
      },
      child: cat != null
          ? PixelCatSprite.fromCat(cat: cat, size: 120)
          : const SizedBox(width: 120, height: 120),
    );
  }

  Widget _buildTextBubble(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FadeTransition(
      opacity: _textController,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }

  /// 根据心情等级构建 sprite 动画曲线。
  Animation<double> _buildMoodAnimation() {
    final curve = switch (widget.mood) {
      Mood.veryHappy => Curves.bounceOut,
      Mood.happy => Curves.easeOutBack,
      Mood.calm => Curves.easeInOut,
      Mood.down => Curves.easeInOutSine,
      Mood.veryDown => Curves.easeInCubic,
    };
    return CurvedAnimation(parent: _spriteController, curve: curve);
  }

  /// 根据心情等级计算位移偏移。
  Offset _moodOffset(double t) {
    return switch (widget.mood) {
      Mood.veryHappy => Offset(0, -20 * (1 - t)), // 弹跳（bounce）
      Mood.happy => Offset(8 * (1 - t), 0), // 轻推（nudge）
      Mood.calm => Offset.zero, // 呼吸（breathe，仅缩放）
      Mood.down => Offset(-6 * (1 - t), 4 * t), // 靠近（lean-in）
      Mood.veryDown => Offset(0, 8 * t), // 蜷缩（curl-up）
    };
  }

  /// 根据心情等级计算缩放比例。
  double _moodScale(double t) {
    return switch (widget.mood) {
      Mood.veryHappy => 1.0 + 0.1 * t, // 弹跳略放大
      Mood.calm => 1.0 + 0.05 * (1 - (2 * t - 1).abs()), // 呼吸效果
      Mood.veryDown => 1.0 - 0.05 * t, // 蜷缩略缩小
      _ => 1.0,
    };
  }
}
