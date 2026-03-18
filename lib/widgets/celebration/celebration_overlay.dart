import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hachimi_app/core/constants/achievement_strings.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/widgets/celebration/celebration_confetti_painter.dart';
import 'package:hachimi_app/widgets/celebration/celebration_glow_icon.dart';
import 'package:hachimi_app/widgets/celebration/celebration_reward_badges.dart';
import 'package:hachimi_app/widgets/celebration/celebration_tier.dart';
import 'package:vibration/vibration.dart';

/// 单个成就庆祝覆盖层 — 三阶段入场 + 退场动画。
class CelebrationOverlay extends StatefulWidget {
  final AchievementDef def;
  final int currentNumber;
  final int totalCount;
  final void Function({required bool skippedAll}) onComplete;

  const CelebrationOverlay({
    super.key,
    required this.def,
    required this.currentNumber,
    required this.totalCount,
    required this.onComplete,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late final CelebrationConfig _config;
  late final CelebrationTier _tier;

  // 入场动画控制器
  late final AnimationController _bgController;
  late final AnimationController _headlineController;
  late final AnimationController _iconController;
  late final AnimationController _textController;
  late final AnimationController _rewardController;
  late final AnimationController _particleController;
  late final AnimationController _burstController;

  // 退场动画控制器
  late final AnimationController _exitContentController;
  late final AnimationController _exitBgController;

  bool _isExiting = false;

  // 入场曲线动画
  late final CurvedAnimation _bgFade;
  late final CurvedAnimation _confettiFade;
  late final CurvedAnimation _headlineFade;
  late final CurvedAnimation _iconScaleCurve;
  late final CurvedAnimation _iconFade;
  late final CurvedAnimation _textFade;
  late final CurvedAnimation _textSlideCurve;
  late final CurvedAnimation _rewardFade;
  late final CurvedAnimation _burstCurve;

  // 退场曲线动画
  late final CurvedAnimation _exitBgFadeCurve;
  late final CurvedAnimation _exitContentScaleCurve;
  late final CurvedAnimation _exitContentFadeCurve;

  // Tween 驱动动画 — 在 _initAnimations 中创建，避免 build() 中分配
  late final Animation<double> _exitBgFade;
  late final Animation<double> _exitContentScale;
  late final Animation<double> _exitContentFade;
  late final Animation<double> _iconScale;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _config = CelebrationConfig.fromDef(widget.def);
    _tier = CelebrationConfig.tierFromDef(widget.def);
    _initControllers();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startEntrance();
      _announceForAccessibility();
    });
  }

  void _initControllers() {
    _bgController = AnimationController(
      vsync: this,
      duration: _config.bgFadeDuration,
    );
    _headlineController = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
    _iconController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium2,
    );
    _textController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium1,
    );
    _rewardController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium2,
    );
    _particleController = AnimationController(
      vsync: this,
      duration: AppMotion.durationParticle,
    );
    _burstController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium4,
    );
    _exitContentController = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
    _exitBgController = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
  }

  void _initAnimations() {
    _bgFade = CurvedAnimation(
      parent: _bgController,
      curve: AppMotion.standardDecelerate,
    );
    _confettiFade = CurvedAnimation(
      parent: _bgController,
      curve: AppMotion.standardDecelerate,
    );
    _headlineFade = CurvedAnimation(
      parent: _headlineController,
      curve: AppMotion.standardDecelerate,
    );
    _iconScaleCurve = CurvedAnimation(
      parent: _iconController,
      curve: AppMotion.celebrationSpring,
    );
    _iconFade = CurvedAnimation(
      parent: _iconController,
      curve: AppMotion.standardDecelerate,
    );
    _textFade = CurvedAnimation(
      parent: _textController,
      curve: AppMotion.standardDecelerate,
    );
    _textSlideCurve = CurvedAnimation(
      parent: _textController,
      curve: AppMotion.emphasizedDecelerate,
    );
    _rewardFade = CurvedAnimation(
      parent: _rewardController,
      curve: AppMotion.standardDecelerate,
    );
    _burstCurve = CurvedAnimation(
      parent: _burstController,
      curve: AppMotion.emphasizedDecelerate,
    );
    _exitBgFadeCurve = CurvedAnimation(
      parent: _exitBgController,
      curve: AppMotion.standardDecelerate,
    );
    _exitContentScaleCurve = CurvedAnimation(
      parent: _exitContentController,
      curve: AppMotion.standardAccelerate,
    );
    _exitContentFadeCurve = CurvedAnimation(
      parent: _exitContentController,
      curve: AppMotion.standardAccelerate,
    );

    // Tween 驱动动画 — 在此创建避免 build()/buildContent() 中每帧分配
    _exitBgFade = Tween<double>(begin: 1.0, end: 0.0).animate(_exitBgFadeCurve);
    _exitContentScale = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(_exitContentScaleCurve);
    _exitContentFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_exitContentFadeCurve);
    _iconScale = Tween<double>(
      begin: _config.iconScaleFrom,
      end: 1.0,
    ).animate(_iconScaleCurve);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(_textSlideCurve);
  }

  void _startEntrance() {
    final reduceMotion = _shouldReduceMotion;

    if (reduceMotion) {
      _bgController.value = 1.0;
      _headlineController.value = 1.0;
      _iconController.value = 1.0;
      _textController.value = 1.0;
      _rewardController.value = 1.0;
      return;
    }

    _particleController.forward();
    _bgController.forward().then((_) {
      _headlineController.forward();
      Future.delayed(_config.iconRevealDelay - _config.bgFadeDuration, () {
        if (!mounted || _isExiting) return;
        _iconController.forward();
        _burstController.forward();
        _triggerHaptic();
      });
      Future.delayed(_config.textRevealDelay - _config.bgFadeDuration, () {
        if (!mounted || _isExiting) return;
        _textController.forward();
      });
      Future.delayed(_config.rewardRevealDelay - _config.bgFadeDuration, () {
        if (!mounted || _isExiting) return;
        _rewardController.forward();
      });
    });
  }

  void _announceForAccessibility() {
    final locale = Localizations.localeOf(context).toString();
    final name = AchievementStrings.name(widget.def.id, locale);
    final l10n = context.l10n;
    SemanticsService.sendAnnouncement(
      View.of(context),
      l10n.a11yAchievementUnlocked(name),
      Directionality.of(context),
    );
  }

  bool get _shouldReduceMotion {
    final mq = MediaQuery.maybeOf(context);
    return mq?.disableAnimations ?? false;
  }

  void _triggerHaptic() {
    switch (_tier) {
      case CelebrationTier.standard:
        break; // 触觉稀缺原则
      case CelebrationTier.notable:
        HapticFeedback.mediumImpact();
      case CelebrationTier.epic:
        _triggerEpicHaptic();
    }
  }

  Future<void> _triggerEpicHaptic() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (!hasVibrator) return;
      await Vibration.vibrate(
        pattern: [0, 80, 120, 120, 100, 200],
        intensities: [0, 128, 0, 180, 0, 255],
      );
    } catch (e) {
      // 设备不支持自定义振动
      debugPrint('[CelebrationOverlay] Haptic failed: $e');
    }
  }

  void _handleDismiss() {
    if (_isExiting) return;
    _startExit(skippedAll: false);
  }

  void _handleSkipAll() {
    if (_isExiting) return;
    _startExit(skippedAll: true);
  }

  void _stopEntranceControllers() {
    _bgController.stop();
    _headlineController.stop();
    _iconController.stop();
    _textController.stop();
    _rewardController.stop();
    _particleController.stop();
    _burstController.stop();
  }

  void _startExit({required bool skippedAll}) {
    _isExiting = true;
    _stopEntranceControllers();

    if (_shouldReduceMotion) {
      widget.onComplete(skippedAll: skippedAll);
      return;
    }

    _exitContentController.forward().then((_) {
      _exitBgController.forward().then((_) {
        widget.onComplete(skippedAll: skippedAll);
      });
    });
  }

  @override
  void dispose() {
    _bgFade.dispose();
    _confettiFade.dispose();
    _headlineFade.dispose();
    _iconScaleCurve.dispose();
    _iconFade.dispose();
    _textFade.dispose();
    _textSlideCurve.dispose();
    _rewardFade.dispose();
    _burstCurve.dispose();
    _exitBgFadeCurve.dispose();
    _exitContentScaleCurve.dispose();
    _exitContentFadeCurve.dispose();
    _bgController.dispose();
    _headlineController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _rewardController.dispose();
    _particleController.dispose();
    _burstController.dispose();
    _exitContentController.dispose();
    _exitBgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final screenSize = MediaQuery.sizeOf(context);

    final def = widget.def;
    final name = AchievementStrings.name(def.id, locale);
    final desc = AchievementStrings.desc(def.id, locale);
    final hasTitle = def.titleReward != null;
    final titleName = hasTitle
        ? AchievementStrings.titleName(def.titleReward!, locale)
        : null;

    final confettiColors = BrandColors.confetti(colorScheme);

    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _exitBgFade,
        child: Stack(
          children: [
            // 全屏渐变背景 — 100% 不透明
            _buildBackground(colorScheme),

            // 纸屑粒子
            RepaintBoundary(
              child: FadeTransition(
                opacity: _confettiFade,
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, _) => CustomPaint(
                    size: screenSize,
                    painter: CelebrationConfettiPainter(
                      progress: _particleController.value,
                      config: _config,
                      seed: def.id.hashCode,
                      screenSize: screenSize,
                      colors: confettiColors,
                    ),
                  ),
                ),
              ),
            ),

            // 内容
            SafeArea(
              child: FadeTransition(
                opacity: _exitContentFade,
                child: ScaleTransition(
                  scale: _exitContentScale,
                  child: _buildContent(
                    colorScheme,
                    textTheme,
                    l10n,
                    def,
                    name,
                    desc,
                    hasTitle,
                    titleName,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(ColorScheme colorScheme) {
    final spotlightCenter = _tier == CelebrationTier.epic
        ? Color.lerp(colorScheme.primary, CelebrationColors.onOverlay, 0.15)!
        : colorScheme.primary;

    return Positioned.fill(
      child: FadeTransition(
        opacity: _bgFade,
        child: GestureDetector(
          onTap: _handleDismiss,
          behavior: HitTestBehavior.opaque,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.0,
                colors: [
                  spotlightCenter,
                  colorScheme.primary,
                  colorScheme.scrim,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ColorScheme colorScheme,
    TextTheme textTheme,
    S l10n,
    AchievementDef def,
    String name,
    String desc,
    bool hasTitle,
    String? titleName,
  ) {
    final headline = _resolveHeadline(l10n);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // 庆祝标题
        FadeTransition(
          opacity: _headlineFade,
          child: Padding(
            padding: AppSpacing.paddingHXl,
            child: Text(
              headline,
              style: textTheme.labelLarge?.copyWith(
                color: CelebrationColors.onOverlayMedium,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // 成就图标（带光环）
        FadeTransition(
          opacity: _iconFade,
          child: ScaleTransition(
            scale: _iconScale,
            child: CelebrationGlowIcon(
              icon: def.icon,
              tier: _tier,
              burstAnimation: _burstCurve,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // 成就名称
        SlideTransition(
          position: _textSlide,
          child: FadeTransition(
            opacity: _textFade,
            child: Padding(
              padding: AppSpacing.paddingHXl,
              child: Text(
                name,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CelebrationColors.onOverlay,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: Padding(
                padding: AppSpacing.paddingHXl,
                child: Text(
                  desc,
                  style: textTheme.bodyLarge?.copyWith(
                    color: CelebrationColors.onOverlayMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),

        // 金币奖励
        FadeTransition(
          opacity: _rewardFade,
          child: CoinRewardBadge(coinReward: def.coinReward, l10n: l10n),
        ),

        // 称号（如有）
        if (hasTitle && titleName != null) ...[
          const SizedBox(height: AppSpacing.md),
          FadeTransition(
            opacity: _rewardFade,
            child: TitleRewardBadge(titleName: titleName, l10n: l10n),
          ),
        ],

        const Spacer(flex: 3),

        // 确认按钮
        FadeTransition(
          opacity: _rewardFade,
          child: Padding(
            padding: AppSpacing.paddingHXl,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _handleDismiss,
                child: Text(l10n.achievementCelebrationDismiss),
              ),
            ),
          ),
        ),

        // 跳过全部（队列 > 1 时显示）
        if (widget.totalCount > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _handleSkipAll,
            child: Text(l10n.achievementCelebrationSkipAll),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.achievementCelebrationCounter(
              widget.currentNumber,
              widget.totalCount,
            ),
            style: textTheme.labelSmall?.copyWith(
              color: CelebrationColors.onOverlayDim,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  String _resolveHeadline(S l10n) => switch (_config.celebrationHeadlineKey) {
    CelebrationHeadline.achievementAwesome => l10n.achievementAwesome,
    CelebrationHeadline.achievementIncredible => l10n.achievementIncredible,
    CelebrationHeadline.achievementUnlocked => l10n.achievementUnlocked,
  };
}
