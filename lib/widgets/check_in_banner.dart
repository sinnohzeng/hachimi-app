// ---
// 📘 文件说明：
// 每日签到横幅组件 — 自动检测签到状态，未签到时弹出「+50 金币」浮层。
//
// 📋 程序整体伪代码（中文）：
// 1. 检查今日是否已签到；
// 2. 若未签到 → 自动执行签到 → 显示 SnackBar 提示；
// 3. 组件本身不渲染可视内容（仅触发副作用）；
// ---

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/providers/auth_provider.dart';

/// CheckInBanner — placed in widget tree to auto-trigger daily check-in.
/// Renders nothing visually; shows a SnackBar when check-in succeeds.
class CheckInBanner extends ConsumerStatefulWidget {
  const CheckInBanner({super.key});

  @override
  ConsumerState<CheckInBanner> createState() => _CheckInBannerState();
}

class _CheckInBannerState extends ConsumerState<CheckInBanner> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    // Run check-in after first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tryCheckIn();
    });
  }

  Future<void> _tryCheckIn() async {
    if (_checked) return;
    _checked = true;

    final uid = ref.read(currentUidProvider);
    if (uid == null) return;

    final coinService = ref.read(coinServiceProvider);
    final alreadyDone = await coinService.hasCheckedInToday(uid);
    if (alreadyDone) return;

    final success = await coinService.checkIn(uid);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.monetization_on, color: Color(0xFFFFD700), size: 20),
              SizedBox(width: 8),
              Text('+50 coins! Daily check-in complete'),
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
    // Invisible widget — side-effect only
    return const SizedBox.shrink();
  }
}
