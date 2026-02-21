// ---
// 📘 文件说明：
// 每日签到横幅组件 — 可视化卡片，展示月度签到进度。
// 未签到时自动触发签到 + 显示奖励反馈；已签到时展示进度摘要。
//
// 📋 程序整体伪代码：
// 1. 监听 hasCheckedInTodayProvider + monthlyCheckInProvider；
// 2. 未签到 → 显示"签到领金币"卡片 + 自动执行签到；
// 3. 已签到 → 显示"X/N 天 · +Y 金币"摘要，点击进入月度详情；
//
// 🕒 创建时间：2026-02-18
// 🔄 更新：2026-02-19 — 从 SizedBox.shrink() 重构为可视卡片
// ---

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/pixel_cat_constants.dart';
import 'package:hachimi_app/core/router/app_router.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
import 'package:hachimi_app/providers/coin_provider.dart';

/// CheckInBanner — 可视化签到卡片，放置于 HomeScreen 顶部。
class CheckInBanner extends ConsumerStatefulWidget {
  const CheckInBanner({super.key});

  @override
  ConsumerState<CheckInBanner> createState() => _CheckInBannerState();
}

class _CheckInBannerState extends ConsumerState<CheckInBanner> {
  bool _checkInAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryCheckIn();
    });
  }

  Future<void> _tryCheckIn() async {
    if (_checkInAttempted) return;
    _checkInAttempted = true;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final coinService = ref.read(coinServiceProvider);
    final result = await coinService.checkIn(uid);

    if (result != null && mounted) {
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
        error: (_, __) => const SizedBox.shrink(),
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
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
            ],
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
          borderRadius: BorderRadius.circular(12),
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
