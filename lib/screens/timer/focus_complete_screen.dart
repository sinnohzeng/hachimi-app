import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/color_utils.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/models/cat.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/ai_provider.dart';
import 'package:hachimi_app/providers/service_providers.dart';
import 'package:hachimi_app/screens/timer/components/stat_row.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';
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

    // Confetti controller (2s blast, only plays on success)
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

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
    _statsSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _statsController,
            curve: AppMotion.emphasized,
          ),
        );
    _statsOpacity = CurvedAnimation(
      parent: _statsController,
      curve: AppMotion.standardDecelerate,
    );

    // Staggered start
    _emojiController.forward();
    Future.delayed(AppMotion.durationShort3, () {
      if (mounted) _contentController.forward();
    });
    Future.delayed(AppMotion.durationMedium1, () {
      if (mounted) _statsController.forward();
    });

    // Haptic feedback + confetti
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerCelebration();
    });
  }

  /// Trigger vibration pattern + confetti based on completion status.
  Future<void> _triggerCelebration() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!widget.isAbandoned) {
      // Completion: strong double-pulse vibration + confetti
      if (hasVibrator) {
        Vibration.vibrate(
          pattern: [0, 200, 100, 300],
          intensities: [0, 255, 0, 255],
        );
      }
      _confettiController.play();
    } else {
      // Abandoned: single light vibration, no confetti
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
  void _triggerDiaryGeneration(dynamic cat, dynamic habit) {
    if (_diaryTriggered) return;
    _diaryTriggered = true;

    if (cat == null || habit == null) return;
    if (widget.isAbandoned) return;

    final availability = ref.read(aiAvailabilityProvider);
    if (availability != AiAvailability.ready) return;

    final locale = Localizations.localeOf(context);
    final diaryService = ref.read(diaryServiceProvider);
    final catId = (cat as Cat).id;
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
            // Analytics: log AI diary generated
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

                    // Status emoji with scale-up animation
                    ScaleTransition(
                      scale: _emojiScale,
                      child: Text(
                        widget.isAbandoned ? '🤗' : (didStageUp ? '🎉' : '✨'),
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                    ),
                    const SizedBox(height: 32),

                    // Cat display
                    FadeTransition(
                      opacity: _contentOpacity,
                      child: Column(
                        children: [
                          if (cat != null) ...[
                            TappableCatSprite(cat: cat, size: 120),
                            const SizedBox(height: 12),
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
                                    borderRadius: BorderRadius.circular(16),
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
                    const SizedBox(height: 32),

                    // Session stats breakdown
                    SlideTransition(
                      position: _statsSlide,
                      child: FadeTransition(
                        opacity: _statsOpacity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                        padding: const EdgeInsets.only(top: 12),
                        child: AnimatedOpacity(
                          opacity: _diarySuccess ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
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
                              const SizedBox(width: 8),
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

                    const Spacer(),

                    // Done button
                    SlideTransition(
                      position: _statsSlide,
                      child: FadeTransition(
                        opacity: _statsOpacity,
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
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
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Confetti overlay
          Align(
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
          ),
        ],
      ),
    );
  }
}
