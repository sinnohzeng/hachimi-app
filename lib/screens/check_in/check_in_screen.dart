import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/models/monthly_check_in.dart';
import 'package:hachimi_app/providers/coin_provider.dart';
import 'package:hachimi_app/screens/check_in/components/calendar_grid.dart';
import 'package:hachimi_app/screens/check_in/components/milestones_card.dart';
import 'package:hachimi_app/screens/check_in/components/reward_schedule_card.dart';
import 'package:hachimi_app/screens/check_in/components/stats_card.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyCheckInProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.checkInTitle)),
      body: monthlyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(context.l10n.commonErrorWithDetail('$e'))),
        data: (monthly) {
          final data = monthly ?? MonthlyCheckIn.empty('');
          return SingleChildScrollView(
            padding: AppSpacing.paddingBase,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatsCard(monthly: data, theme: theme),
                const SizedBox(height: AppSpacing.base),
                CalendarGrid(monthly: data, theme: theme),
                const SizedBox(height: AppSpacing.base),
                MilestonesCard(monthly: data, theme: theme),
                const SizedBox(height: AppSpacing.base),
                RewardScheduleCard(theme: theme),
              ],
            ),
          );
        },
      ),
    );
  }
}
