import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/l10n/l10n_ext.dart';
import 'package:hachimi_app/providers/lumi_user_provider.dart';
import 'package:hachimi_app/widgets/content_width_constraint.dart';
import 'package:hachimi_app/widgets/today/quick_light_card.dart';
import 'package:hachimi_app/widgets/today/habit_snapshot_card.dart';
import 'package:hachimi_app/widgets/today/inspiration_card.dart';
import 'package:intl/intl.dart';

/// 今天页 — Tab 0，显示问候、快捷一光、习惯速览、灵感提示。
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(lumiUserNameProvider);
    final greeting = _buildGreeting(context, userName);
    final locale = Localizations.localeOf(context).toString();
    final dateStr = DateFormat.yMMMEd(locale).format(DateTime.now());

    return ContentWidthConstraint(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            toolbarHeight: 72,
          ),
          SliverPadding(
            padding: AppSpacing.paddingScreenBody,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const QuickLightCard(),
                const SizedBox(height: AppSpacing.md),
                const HabitSnapshotCard(),
                const SizedBox(height: AppSpacing.md),
                const InspirationCard(),
                const SizedBox(height: AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// 根据时间段和用户名生成问候语。
  static String _buildGreeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    final l10n = context.l10n;

    if (name.isNotEmpty) {
      if (hour < 6) return l10n.greetingLateNight(name);
      if (hour < 12) return l10n.greetingMorning(name);
      if (hour < 18) return l10n.greetingAfternoon(name);
      return l10n.greetingEvening(name);
    }

    if (hour < 6) return l10n.greetingLateNightNoName;
    if (hour < 12) return l10n.greetingMorningNoName;
    if (hour < 18) return l10n.greetingAfternoonNoName;
    return l10n.greetingEveningNoName;
  }
}
