import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/lumi_user_provider.dart';
import 'package:hachimi_app/widgets/app_scaffold.dart';
import 'package:intl/intl.dart';

/// LUMI 引导页 — 4 页暖心问题，收集用户名、生日、旅程开始日期。
class LumiOnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const LumiOnboardingScreen({super.key, required this.onComplete});

  @override
  ConsumerState<LumiOnboardingScreen> createState() =>
      _LumiOnboardingScreenState();
}

class _LumiOnboardingScreenState extends ConsumerState<LumiOnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  static const _pageCount = 4;

  // Page 2 数据
  final _nameController = TextEditingController();
  int _birthMonth = DateTime.now().month;
  int _birthDay = DateTime.now().day;

  // Page 3 数据
  late DateTime _startDate;

  // 星星动画
  late final AnimationController _starAnimController;
  late final Animation<double> _starScale;
  late final Animation<double> _starOpacity;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();

    _starAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _starScale = Tween(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _starAnimController, curve: Curves.easeInOut),
    );
    _starOpacity = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _starAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _starAnimController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pageCount - 1) {
      setState(() => _currentPage++);
    } else {
      _finish();
    }
  }

  void _previous() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  Future<void> _finish() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final name = _nameController.text.trim();

    if (name.isNotEmpty) {
      await prefs.setString(AppPrefsKeys.lumiUserName, name);
      ref.read(lumiUserNameProvider.notifier).update(name);
    }

    final birthday =
        '${_birthMonth.toString().padLeft(2, '0')}-${_birthDay.toString().padLeft(2, '0')}';
    await prefs.setString(AppPrefsKeys.lumiBirthday, birthday);

    final startDateStr = DateFormat('yyyy-MM-dd').format(_startDate);
    await prefs.setString(AppPrefsKeys.lumiStartDate, startDateStr);

    await prefs.setInt(AppPrefsKeys.lumiOnboardingVersion, 2);

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _previous();
      },
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              // 顶部导航
              _buildTopNav(context),
              // 页面内容
              Expanded(child: _buildPage(context)),
              // 底部指示器 + 按钮
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          if (_currentPage > 0)
            IconButton(
              onPressed: _previous,
              icon: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            )
          else
            const SizedBox(width: 48),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_currentPage) {
        0 => _WelcomePage(
          key: const ValueKey(0),
          starScale: _starScale,
          starOpacity: _starOpacity,
        ),
        1 => _NameBirthdayPage(
          key: const ValueKey(1),
          nameController: _nameController,
          birthMonth: _birthMonth,
          birthDay: _birthDay,
          onMonthChanged: (m) => setState(() => _birthMonth = m),
          onDayChanged: (d) => setState(() => _birthDay = d),
        ),
        2 => _StartDatePage(
          key: const ValueKey(2),
          startDate: _startDate,
          onDateChanged: (d) {
            if (mounted) setState(() => _startDate = d);
          },
        ),
        3 => const _QuickTourPage(key: ValueKey(3)),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final labels = [
      l10n.onboardingContinue,
      l10n.onboardingNext,
      l10n.onboardingNext,
      l10n.onboardingStart,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPageIndicator(colorScheme),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _next,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: AppShape.borderLarge,
                ),
              ),
              child: Text(
                labels[_currentPage],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pageCount,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == i ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == i
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.38),
            borderRadius: AppShape.borderExtraSmall,
          ),
        ),
      ),
    );
  }
}

// ─── Page 1: Welcome ───

class _WelcomePage extends StatelessWidget {
  final Animation<double> starScale;
  final Animation<double> starOpacity;

  const _WelcomePage({
    super.key,
    required this.starScale,
    required this.starOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 星星动画
          AnimatedBuilder(
            animation: starScale,
            builder: (context, child) {
              return Opacity(
                opacity: starOpacity.value,
                child: Transform.scale(scale: starScale.value, child: child),
              );
            },
            child: _StarCluster(color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            context.l10n.onboardingWelcome,
            style: textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.onboardingLumiIntro,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.onboardingSlogan,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 简单的星星装饰组合。
class _StarCluster extends StatelessWidget {
  final Color color;

  const _StarCluster({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            left: 20,
            child: _star(18, color.withValues(alpha: 0.6)),
          ),
          _star(40, color),
          Positioned(
            bottom: 15,
            right: 15,
            child: _star(24, color.withValues(alpha: 0.8)),
          ),
          Positioned(
            top: 30,
            right: 25,
            child: _star(14, color.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _star(double size, Color c) {
    return Icon(Icons.auto_awesome, size: size, color: c);
  }
}

// ─── Page 2: Name + Birthday ───

class _NameBirthdayPage extends StatelessWidget {
  final TextEditingController nameController;
  final int birthMonth;
  final int birthDay;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onDayChanged;

  const _NameBirthdayPage({
    super.key,
    required this.nameController,
    required this.birthMonth,
    required this.birthDay,
    required this.onMonthChanged,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(
            context.l10n.onboardingNamePrompt,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.base),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: context.l10n.onboardingNameHint,
              border: OutlineInputBorder(borderRadius: AppShape.borderMedium),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.onboardingBirthdayPrompt,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              Expanded(
                child: _NumberPicker(
                  label: context.l10n.onboardingBirthdayMonth,
                  value: birthMonth,
                  minValue: 1,
                  maxValue: 12,
                  onChanged: onMonthChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: _NumberPicker(
                  label: context.l10n.onboardingBirthdayDay,
                  value: birthDay,
                  minValue: 1,
                  maxValue: _daysInMonth(birthMonth),
                  onChanged: onDayChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static int _daysInMonth(int month) {
    // 使用非闰年，因为不收集年份
    return DateTime(2024, month + 1, 0).day;
  }
}

/// 简单数字选择器 — 左右箭头 + 数字显示。
class _NumberPicker extends StatelessWidget {
  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _NumberPicker({
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: AppSpacing.paddingSm,
        child: Column(
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: value > minValue
                      ? () => onChanged(value - 1)
                      : null,
                  icon: const Icon(Icons.remove, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: value < maxValue
                      ? () => onChanged(value + 1)
                      : null,
                  icon: const Icon(Icons.add, size: 20),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page 3: Start Date ───

class _StartDatePage extends StatelessWidget {
  final DateTime startDate;
  final ValueChanged<DateTime> onDateChanged;

  const _StartDatePage({
    super.key,
    required this.startDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateStr = DateFormat('yyyy-MM-dd').format(startDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.l10n.onboardingStartDatePrompt,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.tonal(
            onPressed: () => _pickDate(context),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: AppShape.borderMedium,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  dateStr,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }
}

// ─── Page 4: Quick Tour ───

class _QuickTourPage extends StatelessWidget {
  const _QuickTourPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.onboardingThreeThings,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _TourCard(
            icon: Icons.auto_awesome,
            title: context.l10n.onboardingDailyLight,
            subtitle: context.l10n.onboardingDailyLightSub,
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          _TourCard(
            icon: Icons.favorite_outline,
            title: context.l10n.onboardingWeeklyReview,
            subtitle: context.l10n.onboardingWeeklyReviewSub,
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          _TourCard(
            icon: Icons.cloud_outlined,
            title: context.l10n.onboardingWorryJar,
            subtitle: context.l10n.onboardingWorryJarSub,
            color: colorScheme.secondary,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _TourCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: AppShape.borderMedium,
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: AppSpacing.paddingBase,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
