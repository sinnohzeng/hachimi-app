import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/core/constants/achievement_strings.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';

/// 全局成就庆祝层 — 挂在 MaterialApp.builder 中，
/// 监听 newlyUnlockedProvider，逐个弹出庆祝卡片。
class AchievementCelebrationLayer extends ConsumerStatefulWidget {
  final Widget child;

  const AchievementCelebrationLayer({super.key, required this.child});

  @override
  ConsumerState<AchievementCelebrationLayer> createState() =>
      _AchievementCelebrationLayerState();
}

class _AchievementCelebrationLayerState
    extends ConsumerState<AchievementCelebrationLayer> {
  /// 待展示的成就 ID 队列。
  final List<AchievementDef> _queue = [];

  /// 当前正在展示的索引（-1 = 无展示）。
  int _currentIndex = -1;

  /// 总共有多少个成就（用于队列计数器）。
  int _totalCount = 0;

  @override
  Widget build(BuildContext context) {
    // 监听新解锁成就
    ref.listen<List<String>>(newlyUnlockedProvider, (prev, next) {
      if (next.isEmpty) return;
      _enqueue(next);
      ref.read(newlyUnlockedProvider.notifier).clear();
    });

    return Stack(
      children: [
        widget.child,
        if (_currentIndex >= 0 && _currentIndex < _queue.length)
          _CelebrationOverlay(
            def: _queue[_currentIndex],
            currentNumber: _currentIndex + 1,
            totalCount: _totalCount,
            onDismiss: _showNext,
            onSkipAll: _skipAll,
          ),
      ],
    );
  }

  void _enqueue(List<String> ids) {
    final defs = ids
        .map(AchievementDefinitions.byId)
        .whereType<AchievementDef>()
        .toList();
    // 按 coinReward 升序（简单成就先展示）
    defs.sort((a, b) => a.coinReward.compareTo(b.coinReward));

    _queue.addAll(defs);
    _totalCount = _queue.length;

    // 如果当前没在展示，启动队列
    if (_currentIndex < 0) {
      setState(() => _currentIndex = 0);
    }
  }

  void _showNext() {
    final next = _currentIndex + 1;
    if (next < _queue.length) {
      setState(() => _currentIndex = next);
    } else {
      _clear();
    }
  }

  void _skipAll() => _clear();

  void _clear() {
    setState(() {
      _queue.clear();
      _currentIndex = -1;
      _totalCount = 0;
    });
  }
}

/// 单个成就庆祝覆盖层（半透明遮罩 + 弹入卡片 + 粒子效果）。
class _CelebrationOverlay extends StatefulWidget {
  final AchievementDef def;
  final int currentNumber;
  final int totalCount;
  final VoidCallback onDismiss;
  final VoidCallback onSkipAll;

  const _CelebrationOverlay({
    required this.def,
    required this.currentNumber,
    required this.totalCount,
    required this.onDismiss,
    required this.onSkipAll,
  });

  @override
  State<_CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<_CelebrationOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _cardController;
  late final AnimationController _particleController;
  late final Animation<double> _bgFade;
  late final Animation<double> _cardScale;
  late final Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();

    // 背景渐入
    _bgController = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
    _bgFade = CurvedAnimation(
      parent: _bgController,
      curve: AppMotion.standardDecelerate,
    );

    // 卡片弹入
    _cardController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium4,
    );
    _cardScale = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut, // 庆祝弹性效果，M3 无等价物
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _cardController,
            curve: AppMotion.emphasizedDecelerate,
          ),
        );

    // 粒子持续动画
    _particleController = AnimationController(
      vsync: this,
      duration: AppMotion.durationParticle,
    )..repeat();

    // 启动动画序列 + 震动
    _bgController.forward().then((_) {
      _cardController.forward();
    });
    HapticFeedback.heavyImpact();
  }

  @override
  void didUpdateWidget(covariant _CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.def.id != widget.def.id) {
      // 新成就：重播动画
      _cardController.reset();
      _bgController.reset();
      _bgController.forward().then((_) {
        _cardController.forward();
      });
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();

    final def = widget.def;
    final name = AchievementStrings.name(def.id, locale);
    final desc = AchievementStrings.desc(def.id, locale);
    final hasTitle = def.titleReward != null;
    final titleName = hasTitle
        ? AchievementStrings.titleName(def.titleReward!, locale)
        : null;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // 半透明遮罩
          FadeTransition(
            opacity: _bgFade,
            child: Semantics(
              button: true,
              label: 'Dismiss',
              child: GestureDetector(
                onTap: widget.onDismiss,
                child: Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.54),
                ),
              ),
            ),
          ),

          // 粒子效果
          FadeTransition(
            opacity: _bgFade,
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                size: MediaQuery.sizeOf(context),
                painter: _ConfettiPainter(
                  progress: _particleController.value,
                  seed: def.id.hashCode,
                ),
              ),
            ),
          ),

          // 主卡片
          Center(
            child: SlideTransition(
              position: _cardSlide,
              child: ScaleTransition(
                scale: _cardScale,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: AppShape.borderExtraLarge,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 成就图标（带光环）
                      _GlowingIcon(
                        icon: def.icon,
                        color: colorScheme.primary,
                        animation: _particleController,
                      ),
                      const SizedBox(height: 16),

                      // 成就名称
                      Text(
                        name,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          desc,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),

                      // 金币奖励
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: AppShape.borderLarge,
                        ),
                        child: Text(
                          l10n.achievementCelebrationCoins(def.coinReward),
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // 称号（如有）
                      if (hasTitle && titleName != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: AppShape.borderMedium,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.military_tech,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.achievementCelebrationTitle(titleName),
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // 确认按钮
                      FilledButton(
                        onPressed: widget.onDismiss,
                        child: Text(l10n.achievementCelebrationDismiss),
                      ),

                      // 跳过全部（队列 > 1 时显示）
                      if (widget.totalCount > 1) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: widget.onSkipAll,
                          child: Text(l10n.achievementCelebrationSkipAll),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.achievementCelebrationCounter(
                            widget.currentNumber,
                            widget.totalCount,
                          ),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 成就图标 + 脉冲光环效果。
class _GlowingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Animation<double> animation;

  const _GlowingIcon({
    required this.icon,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulse = 0.8 + 0.2 * sin(animation.value * 2 * pi);
        return Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3 * pulse),
                blurRadius: 20 * pulse,
                spreadRadius: 4 * pulse,
              ),
            ],
          ),
          child: Icon(icon, size: 36, color: color),
        );
      },
    );
  }
}

/// 简单的 confetti 粒子画笔。
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final int seed;

  _ConfettiPainter({required this.progress, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    const count = 40;
    final colors = [
      Colors.amber,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];

    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height * 0.3;
      final speed = 0.5 + random.nextDouble() * 1.5;
      final y = baseY + progress * size.height * speed;

      if (y > size.height) continue;

      final color = colors[i % colors.length];
      final opacity = (1.0 - (y / size.height)).clamp(0.0, 0.8);
      final paint = Paint()..color = color.withValues(alpha: opacity);

      final w = 4.0 + random.nextDouble() * 6;
      final h = 3.0 + random.nextDouble() * 4;
      final angle = progress * pi * 2 * (random.nextBool() ? 1 : -1);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
