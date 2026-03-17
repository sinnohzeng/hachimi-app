import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/core/theme/app_icon_size.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/providers/diary_provider.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/screens/timer/components/stat_row.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
import 'package:hachimi_app/models/diary_generation_context.dart';
import 'package:hachimi_app/models/xp_result.dart';
import 'package:vibration/vibration.dart';

/// Focus complete celebration screen.
/// Shows minutes earned, XP breakdown, stage-up animation, confetti, and haptic feedback.
class FocusCompleteScreen extends ConsumerStatefulWidget {
  final String habitId;
  final int minutes;
  final XpResult xpResult;
  final StageUpResult? stageUp;
  final bool isAbandoned;
  final int coinsEarned;

  const FocusCompleteScreen({
    super.key,
    required this.habitId,
    required this.minutes,
    required this.xpResult,
    this.stageUp,
    this.isAbandoned = false,
    this.coinsEarned = 0,
  });

  @override
  ConsumerState<FocusCompleteScreen> createState() =>
      _FocusCompleteScreenState();
}

class _FocusCompleteScreenState extends ConsumerState<FocusCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _emojiController;
  late final AnimationController _contentController;
  late final AnimationController _statsController;

  late final CurvedAnimation _emojiScaleCurve;
  late final CurvedAnimation _contentOpacityCurve;
  late final CurvedAnimation _statsSlideCurve;
  late final CurvedAnimation _statsOpacityCurve;

  late final Animation<double> _emojiScale;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _statsSlide;
  late final Animation<double> _statsOpacity;

  late final ConfettiController _confettiController;

  bool _diaryTriggered = false;
  bool _diarySuccess = false;
  bool _diaryGenerating = false;
  bool _diaryError = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initAnimations();
    _startStaggeredAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerCelebration();
      final habits = ref.read(habitsProvider).value ?? [];
      final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
      final cat = habit?.catId != null
          ? ref.read(catByIdProvider(habit!.catId!))
          : null;
      _triggerDiaryGeneration(cat, habit);
    });
  }

  /// 创建动画控制器并绑定曲线。
  AnimationController _createController(Duration duration) {
    return AnimationController(vsync: this, duration: duration);
  }

  /// 初始化 3 组动画控制器与曲线。
  ///
  /// CurvedAnimation 存储为命名字段以确保 dispose 时正确释放。
  void _initAnimations() {
    _emojiController = _createController(AppMotion.durationMedium4);
    _emojiScaleCurve = CurvedAnimation(
      parent: _emojiController,
      curve: Curves.elasticOut,
    );
    _emojiScale = _emojiScaleCurve;

    _contentController = _createController(AppMotion.durationMedium2);
    _contentOpacityCurve = CurvedAnimation(
      parent: _contentController,
      curve: AppMotion.standardDecelerate,
    );
    _contentOpacity = _contentOpacityCurve;

    _statsController = _createController(AppMotion.durationMedium4);
    _statsSlideCurve = CurvedAnimation(
      parent: _statsController,
      curve: AppMotion.emphasized,
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_statsSlideCurve);
    _statsOpacityCurve = CurvedAnimation(
      parent: _statsController,
      curve: AppMotion.standardDecelerate,
    );
    _statsOpacity = _statsOpacityCurve;
  }

  /// 交错启动三组入场动画。
  void _startStaggeredAnimations() {
    _emojiController.forward();
    Future.delayed(AppMotion.durationShort3, () {
      if (mounted) _contentController.forward();
    });
    Future.delayed(AppMotion.durationMedium1, () {
      if (mounted) _statsController.forward();
    });

    // 无障碍播报完成摘要
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = context.l10n;
      final message = widget.isAbandoned
          ? l10n.focusCompleteItsOkay
          : l10n.focusCompleteFocusedFor(widget.minutes);
      SemanticsService.sendAnnouncement(
        View.of(context),
        message,
        Directionality.of(context),
      );
    });
  }

  /// Trigger vibration pattern + confetti based on completion status.
  Future<void> _triggerCelebration() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!widget.isAbandoned) {
      if (hasVibrator) {
        Vibration.vibrate(
          pattern: [0, 200, 100, 300],
          intensities: [0, 255, 0, 255],
        );
      }
      _confettiController.play();
    } else {
      if (hasVibrator) {
        Vibration.vibrate(duration: 100, amplitude: 128);
      }
    }
  }

  @override
  void dispose() {
    _emojiScaleCurve.dispose();
    _contentOpacityCurve.dispose();
    _statsSlideCurve.dispose();
    _statsOpacityCurve.dispose();
    _emojiController.dispose();
    _contentController.dispose();
    _statsController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  /// 异步触发日记生成 — fire-and-forget，不影响 UI。
  void _triggerDiaryGeneration(Cat? cat, Habit? habit) {
    if (_diaryTriggered) return;
    _diaryTriggered = true;

    if (cat == null || habit == null || widget.isAbandoned) return;
    if (ref.read(aiAvailabilityProvider) != AiAvailability.ready) return;

    _executeDiaryGeneration(cat, habit);
  }

  /// 执行日记生成请求，管理 generating/success 状态转换。
  Future<void> _executeDiaryGeneration(Cat cat, Habit habit) async {
    final locale = Localizations.localeOf(context);
    final ctx = DiaryGenerationContext(
      cat: cat,
      habit: habit,
      todayMinutes: widget.minutes,
      isZhLocale: locale.languageCode == 'zh',
    );

    setState(() => _diaryGenerating = true);
    try {
      await ref.read(diaryServiceProvider).generateTodayDiary(ctx);
      if (!mounted) return;
      // 立即刷新日记 Provider，用户返回详情页时无需等待
      ref.invalidate(todayDiaryProvider(cat.id));
      ref.invalidate(diaryEntriesProvider(cat.id));
      setState(() {
        _diaryGenerating = false;
        _diarySuccess = true;
      });
      ref.read(analyticsServiceProvider).logAiDiaryGenerated(catId: cat.id);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _diarySuccess = false);
      });
    } catch (e) {
      debugPrint('[DIARY] generation failed: $e');
      if (mounted) {
        setState(() {
          _diaryGenerating = false;
          _diaryError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit = habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    final didStageUp = widget.stageUp?.didStageUp ?? false;
    final catName = cat?.name ?? l10n.focusCompleteYourCat;

    return AppScaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: AppSpacing.paddingXl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Status emoji with scale-up animation
                    ExcludeSemantics(
                      child: ScaleTransition(
                        scale: _emojiScale,
                        child: Text(
                          widget.isAbandoned ? '🤗' : (didStageUp ? '🎉' : '✨'),
                          style: const TextStyle(fontSize: AppIconSize.emoji),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),

                    // Title + subtitle with fade-in
                    FadeTransition(
                      opacity: _contentOpacity,
                      child: Column(
                        children: [
                          Text(
                            widget.isAbandoned
                                ? l10n.focusCompleteItsOkay
                                : (didStageUp
                                      ? l10n.focusCompleteEvolved(catName)
                                      : l10n.focusCompleteGreatJob),
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            widget.isAbandoned
                                ? l10n.focusCompleteAbandonedMessage(catName)
                                : l10n.focusCompleteFocusedFor(widget.minutes),
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Cat display
                    FadeTransition(
                      opacity: _contentOpacity,
                      child: Column(
                        children: [
                          if (cat != null) ...[
                            TappableCatSprite(cat: cat, size: 120),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              cat.name,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (didStageUp)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: stageColor(widget.stageUp!.newStage)
                                        .withValues(
                                          alpha:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? 0.30
                                              : 0.15,
                                        ),
                                    borderRadius: AppShape.borderLarge,
                                  ),
                                  child: Text(
                                    l10n.focusCompleteEvolvedTo(
                                      widget.stageUp!.newStage[0]
                                              .toUpperCase() +
                                          widget.stageUp!.newStage.substring(1),
                                    ),
                                    style: textTheme.labelLarge?.copyWith(
                                      color: stageColor(
                                        widget.stageUp!.newStage,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Session stats breakdown
                    SlideTransition(
                      position: _statsSlide,
                      child: FadeTransition(
                        opacity: _statsOpacity,
                        child: Card(
                          child: Padding(
                            padding: AppSpacing.paddingBase,
                            child: Column(
                              children: [
                                StatRow(
                                  label: l10n.focusCompleteFocusTime,
                                  value: '+${widget.minutes} min',
                                  icon: Icons.timer_outlined,
                                ),
                                if (widget.coinsEarned > 0) ...[
                                  const Divider(height: 16),
                                  StatRow(
                                    label: l10n.focusCompleteCoinsEarned,
                                    value: '+${widget.coinsEarned}',
                                    icon: Icons.monetization_on,
                                  ),
                                ],
                                const Divider(height: 16),
                                StatRow(
                                  label: l10n.focusCompleteBaseXp,
                                  value: '+${widget.xpResult.baseXp} XP',
                                  icon: Icons.star_outline,
                                ),
                                if (widget.xpResult.fullHouseBonus > 0) ...[
                                  const Divider(height: 16),
                                  StatRow(
                                    label: l10n.focusCompleteFullHouseBonus,
                                    value:
                                        '+${widget.xpResult.fullHouseBonus} XP',
                                    icon: Icons.home,
                                  ),
                                ],
                                const Divider(height: 16),
                                StatRow(
                                  label: l10n.focusCompleteTotal,
                                  value: '+${widget.xpResult.totalXp} XP',
                                  icon: Icons.star,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Diary generation feedback
                    if (_diaryGenerating)
                      Padding(
                        padding: AppSpacing.paddingTopMd,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              l10n.focusCompleteDiaryWriting,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_diarySuccess)
                      Padding(
                        padding: AppSpacing.paddingTopMd,
                        child: AnimatedOpacity(
                          opacity: _diarySuccess ? 1.0 : 0.0,
                          duration: AppMotion.durationLong2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: StatusColors.onSuccess(
                                  Theme.of(context).brightness,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                l10n.focusCompleteDiaryWritten,
                                style: textTheme.bodySmall?.copyWith(
                                  color: StatusColors.onSuccess(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_diaryError)
                      Padding(
                        padding: AppSpacing.paddingTopMd,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              l10n.focusCompleteDiarySkipped,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Spacer(),
                    _buildDoneButton(colorScheme, textTheme, l10n),
                  ],
                ),
              ),
            ),
          ),
          _buildConfettiOverlay(colorScheme),
        ],
      ),
    );
  }

  Widget _buildDoneButton(
    ColorScheme colorScheme,
    TextTheme textTheme,
    S l10n,
  ) {
    return SlideTransition(
      position: _statsSlide,
      child: FadeTransition(
        opacity: _statsOpacity,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              l10n.focusCompleteDone,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiOverlay(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 30,
        maxBlastForce: 20,
        minBlastForce: 8,
        gravity: 0.1,
        colors: BrandColors.confetti(colorScheme),
      ),
    );
  }
}
