import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/core/theme/app_shape.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';

/// CheckInBanner — 可视化签到卡片，放置于 HomeScreen 顶部。
/// 用户点击手动签到，不自动签到。
class CheckInBanner extends ConsumerStatefulWidget {
  const CheckInBanner({super.key});

  @override
  ConsumerState<CheckInBanner> createState() => _CheckInBannerState();
}

class _CheckInBannerState extends ConsumerState<CheckInBanner> {
  bool _isCheckingIn = false;

  Future<void> _tryCheckIn() async {
    if (_isCheckingIn) return;
    setState(() => _isCheckingIn = true);

    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) return;

      final coinService = ref.read(coinServiceProvider);
      final result = await coinService.checkIn(uid);

      if (result != null && mounted) {
        ErrorHandler.breadcrumb(
          'daily_checkin_completed: +${result.dailyCoins} coins',
        );
        final totalCoins = result.dailyCoins + result.milestoneBonus;
        ref
            .read(analyticsServiceProvider)
            .logCoinsEarned(amount: totalCoins, source: 'daily_checkin');
        ref.invalidate(hasCheckedInTodayProvider);
        ref.invalidate(monthlyCheckInProvider);

        HapticFeedback.mediumImpact();

        final l10n = context.l10n;
        String message = l10n.checkInBannerSuccess(result.dailyCoins);
        if (result.milestoneBonus > 0) {
          message += l10n.checkInBannerBonus(result.milestoneBonus);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(message)),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkedInAsync = ref.watch(hasCheckedInTodayProvider);
    final monthlyAsync = ref.watch(monthlyCheckInProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: context.l10n.checkInBannerSemantics,
      child: checkedInAsync.when(
        loading: () => _buildLoadingCard(colorScheme),
        error: (_, _) => const SizedBox.shrink(),
        data: (hasCheckedIn) {
          final monthly = monthlyAsync.value;
          if (hasCheckedIn) {
            return _buildCheckedInCard(context, colorScheme, theme, monthly);
          } else {
            return _buildNotCheckedInCard(colorScheme, theme);
          }
        },
      ),
    );
  }

  Widget _buildLoadingCard(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(context.l10n.checkInBannerLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotCheckedInCard(ColorScheme colorScheme, ThemeData theme) {
    final now = DateTime.now();
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final coins = isWeekend ? checkInCoinsWeekend : checkInCoinsWeekday;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: colorScheme.tertiaryContainer,
        child: InkWell(
          borderRadius: AppShape.borderMedium,
          onTap: _isCheckingIn ? null : _tryCheckIn,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.onTertiaryContainer,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    context.l10n.checkInBannerPrompt(coins),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_isCheckingIn)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  )
                else
                  Icon(
                    Icons.check_circle_outline,
                    color: colorScheme.onTertiaryContainer,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckedInCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    MonthlyCheckIn? monthly,
  ) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final checkedCount = monthly?.checkedCount ?? 0;
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    final todayCoins = isWeekend ? checkInCoinsWeekend : checkInCoinsWeekday;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: colorScheme.secondaryContainer,
        child: InkWell(
          borderRadius: AppShape.borderMedium,
          onTap: () => Navigator.of(context).pushNamed(AppRouter.checkIn),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: colorScheme.onSecondaryContainer,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    context.l10n.checkInBannerSummary(
                      checkedCount,
                      daysInMonth,
                      todayCoins,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSecondaryContainer,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
