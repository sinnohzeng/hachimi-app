import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/theme/app_spacing.dart';
import 'package:hachimi_app/providers/auth_provider.dart';
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
    final prefs = ref.read(sharedPreferencesProvider);
    final userName = prefs.getString(AppPrefsKeys.lumiUserName) ?? '';
    final greeting = _buildGreeting(userName);
    final dateStr = DateFormat('M月d日 EEEE', 'zh_CN').format(DateTime.now());

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
  static String _buildGreeting(String name) {
    final hour = DateTime.now().hour;
    final suffix = name.isNotEmpty ? '，$name' : '';

    if (hour < 6) return '夜深了$suffix'; // TODO: l10n
    if (hour < 12) return '早安$suffix'; // TODO: l10n
    if (hour < 18) return '下午好$suffix'; // TODO: l10n
    return '晚上好$suffix'; // TODO: l10n
  }
}
