import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/models/habit.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/screens/timer/components/focus_cat_display.dart';
import 'package:hachimi_app/screens/timer/components/focus_session_stats_card.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/xp_service.dart';
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

  late final Animation<double> _emojiScale;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _statsSlide;
  late final Animation<double> _statsOpacity;

  late final ConfettiController _confettiController;

  bool _diaryTriggered = false;
  bool _diarySuccess = false;
  bool _diaryGenerating = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initAnimations();
    _startStaggeredAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerCelebration());
  }

  /// 初始化 3 组动画控制器与曲线。
  void _initAnimations() {
    // Emoji scale-up: 0 → 1 with overshoot
    _emojiController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium4,
    );
    _emojiScale = CurvedAnimation(
      parent: _emojiController,
      curve: Curves.elasticOut,
    );

    // Content (title, subtitle, cat) fade-in
    _contentController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium2,
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: AppMotion.standardDecelerate,
    );

    // Stats card slide-up + fade-in
    _statsController = AnimationController(
      vsync: this,
      duration: AppMotion.durationMedium4,
    );
    _statsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _statsController, curve: AppMotion.emphasized),
    );
    _statsOpacity = CurvedAnimation(
      parent: _statsController,
      curve: AppMotion.standardDecelerate,
    );
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

    if (cat == null || habit == null) return;
    if (widget.isAbandoned) return;

    final availability = ref.read(aiAvailabilityProvider);
    if (availability != AiAvailability.ready) return;

    final locale = Localizations.localeOf(context);
    final diaryService = ref.read(diaryServiceProvider);
    final catId = cat.id;
    final ctx = DiaryGenerationContext(
      cat: cat,
      habit: habit,
      todayMinutes: widget.minutes,
      isZhLocale: locale.languageCode == 'zh',
    );

    setState(() => _diaryGenerating = true);
    diaryService
        .generateTodayDiary(ctx)
        .then((_) {
          if (mounted) {
            setState(() {
              _diaryGenerating = false;
              _diarySuccess = true;
            });
            ref
                .read(analyticsServiceProvider)
                .logAiDiaryGenerated(catId: catId);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => _diarySuccess = false);
            });
          }
        })
        .catchError((_) {
          if (mounted) setState(() => _diaryGenerating = false);
        });
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

    // Trigger diary generation once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerDiaryGeneration(cat, habit);
    });

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    _buildStatusEmoji(didStageUp),
                    const SizedBox(height: 16),
                    _buildHeadline(textTheme, colorScheme, l10n, didStageUp, catName),
                    const SizedBox(height: 32),
                    _buildCatSection(cat),
                    const SizedBox(height: 32),
                    _buildStatsSection(),
                    _buildDiaryFeedback(colorScheme, textTheme),
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

  Widget _buildStatusEmoji(bool didStageUp) {
    return ScaleTransition(
      scale: _emojiScale,
      child: Text(
        widget.isAbandoned ? '\u{1F917}' : (didStageUp ? '\u{1F389}' : '\u{2728}'),
        style: const TextStyle(fontSize: 48),
      ),
    );
  }

  Widget _buildHeadline(
    TextTheme textTheme,
    ColorScheme colorScheme,
    dynamic l10n,
    bool didStageUp,
    String catName,
  ) {
    return FadeTransition(
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
          const SizedBox(height: 8),
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
    );
  }

  Widget _buildCatSection(Cat? cat) {
    return FadeTransition(
      opacity: _contentOpacity,
      child: cat != null
          ? FocusCatDisplay(cat: cat, stageUp: widget.stageUp)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildStatsSection() {
    return SlideTransition(
      position: _statsSlide,
      child: FadeTransition(
        opacity: _statsOpacity,
        child: FocusSessionStatsCard(
          minutes: widget.minutes,
          coinsEarned: widget.coinsEarned,
          xpResult: widget.xpResult,
        ),
      ),
    );
  }

  Widget _buildDiaryFeedback(ColorScheme colorScheme, TextTheme textTheme) {
    if (_diaryGenerating) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
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
            const SizedBox(width: 8),
            Text(
              context.l10n.focusCompleteDiaryWriting,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    if (_diarySuccess) {
      final successColor = StatusColors.onSuccess(
        Theme.of(context).brightness,
      );
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: AppMotion.durationLong2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 14, color: successColor),
              const SizedBox(width: 8),
              Text(
                context.l10n.focusCompleteDiaryWritten,
                style: textTheme.bodySmall?.copyWith(color: successColor),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDoneButton(
    ColorScheme colorScheme,
    TextTheme textTheme,
    dynamic l10n,
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
        colors: [
          colorScheme.primary,
          colorScheme.tertiary,
          colorScheme.secondary,
          Colors.amber,
          Colors.pink,
        ],
      ),
    );
  }
}
