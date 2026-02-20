// ---
// 📘 文件说明：
// 专注完成庆祝页面 — 展示本次专注的时长、XP 奖励明细、猫猫阶段跃迁提示。
// 带入场动画：emoji scale-up、标题/副标题 fade-in、stats 卡片 slide-up。
//
// 📋 程序整体伪代码（中文）：
// 1. 接收 habitId、分钟数、XpResult、StageUpResult 参数；
// 2. 从 Provider 加载关联的 habit 和 cat 数据；
// 3. initState 中启动 staggered 入场动画；
// 4. 显示像素猫 sprite + 阶段跃迁标签（若有）；
// 5. XP 明细卡片（slide-up + fade-in）；
// 6. Done 按钮返回首页；
//
// 🧩 文件结构：
// - FocusCompleteScreen：主页面 ConsumerStatefulWidget；
// - _StatRow：XP 明细行组件；
// ---

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/cat_constants.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/providers/habits_provider.dart';
import 'package:hachimi_app/providers/llm_provider.dart';
import 'package:hachimi_app/services/diary_service.dart';
import 'package:hachimi_app/services/xp_service.dart';
import 'package:hachimi_app/widgets/tappable_cat_sprite.dart';

/// Focus complete celebration screen.
/// Shows minutes earned, XP breakdown, stage-up animation, and session stats.
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

  bool _diaryTriggered = false;

  @override
  void initState() {
    super.initState();

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
    ).animate(CurvedAnimation(
      parent: _statsController,
      curve: AppMotion.emphasized,
    ));
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

    // Haptic feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.heavyImpact();
    });
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _contentController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  /// 异步触发日记生成 — fire-and-forget，不影响 UI。
  void _triggerDiaryGeneration(dynamic cat, dynamic habit) {
    if (_diaryTriggered) return;
    _diaryTriggered = true;

    if (cat == null || habit == null) return;
    if (widget.isAbandoned) return;

    final availability = ref.read(llmAvailabilityProvider);
    if (availability != LlmAvailability.ready) return;

    final diaryService = ref.read(diaryServiceProvider);
    final ctx = DiaryGenerationContext(
      cat: cat,
      habit: habit,
      todayMinutes: widget.minutes,
      isZhLocale: false,
    );

    diaryService.generateTodayDiary(ctx);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final habits = ref.watch(habitsProvider).value ?? [];
    final habit =
        habits.where((h) => h.id == widget.habitId).firstOrNull;
    final cat = habit?.catId != null
        ? ref.watch(catByIdProvider(habit!.catId!))
        : null;

    final didStageUp = widget.stageUp?.didStageUp ?? false;

    // Trigger diary generation once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerDiaryGeneration(cat, habit);
    });

    return Scaffold(
      body: SafeArea(
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
                    widget.isAbandoned
                        ? '🤗'
                        : (didStageUp ? '🎉' : '✨'),
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
                            ? "It's okay!"
                            : (didStageUp
                                ? '${cat?.name ?? "Your cat"} evolved!'
                                : 'Great job!'),
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isAbandoned
                            ? "${cat?.name ?? 'Your cat'} says: \"We'll try again!\""
                            : 'You focused for ${widget.minutes} minutes',
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
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Evolved to ${widget.stageUp!.newStage[0].toUpperCase()}${widget.stageUp!.newStage.substring(1)}!',
                                style: textTheme.labelLarge?.copyWith(
                                  color:
                                      stageColor(widget.stageUp!.newStage),
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

                // Session stats breakdown with slide-up + fade-in
                SlideTransition(
                  position: _statsSlide,
                  child: FadeTransition(
                    opacity: _statsOpacity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _StatRow(
                              label: 'Focus time',
                              value: '+${widget.minutes} min',
                              icon: Icons.timer_outlined,
                            ),
                            if (widget.coinsEarned > 0) ...[
                              const Divider(height: 16),
                              _StatRow(
                                label: 'Coins earned',
                                value: '+${widget.coinsEarned}',
                                icon: Icons.monetization_on,
                              ),
                            ],
                            const Divider(height: 16),
                            _StatRow(
                              label: 'Base XP',
                              value:
                                  '+${widget.xpResult.baseXp} XP',
                              icon: Icons.star_outline,
                            ),
                            if (widget.xpResult.streakBonus > 0) ...[
                              const Divider(height: 16),
                              _StatRow(
                                label: 'Streak bonus',
                                value:
                                    '+${widget.xpResult.streakBonus} XP',
                                icon: Icons.local_fire_department,
                              ),
                            ],
                            if (widget.xpResult.milestoneBonus >
                                0) ...[
                              const Divider(height: 16),
                              _StatRow(
                                label: 'Milestone bonus',
                                value:
                                    '+${widget.xpResult.milestoneBonus} XP',
                                icon: Icons.emoji_events,
                              ),
                            ],
                            if (widget.xpResult.fullHouseBonus >
                                0) ...[
                              const Divider(height: 16),
                              _StatRow(
                                label: 'Full house bonus',
                                value:
                                    '+${widget.xpResult.fullHouseBonus} XP',
                                icon: Icons.home,
                              ),
                            ],
                            const Divider(height: 16),
                            _StatRow(
                              label: 'Total',
                              value:
                                  '+${widget.xpResult.totalXp} XP',
                              icon: Icons.star,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
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
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          'Done',
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
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isBold;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: (isBold ? textTheme.titleSmall : textTheme.bodyMedium)
              ?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
