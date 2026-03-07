import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/constants/achievement_constants.dart';
import 'package:hachimi_app/models/achievement.dart';
import 'package:hachimi_app/providers/achievement_provider.dart';
import 'package:hachimi_app/widgets/celebration/celebration_overlay.dart';

/// 全局成就庆祝层 — 使用 OverlayPortal 渲染在 Navigator Overlay 上。
/// 监听 newlyUnlockedProvider，逐个弹出庆祝卡片。
class AchievementCelebrationLayer extends ConsumerStatefulWidget {
  final Widget child;

  const AchievementCelebrationLayer({super.key, required this.child});

  @override
  ConsumerState<AchievementCelebrationLayer> createState() =>
      _AchievementCelebrationLayerState();
}

class _AchievementCelebrationLayerState
    extends ConsumerState<AchievementCelebrationLayer> {
  final _overlayController = OverlayPortalController();
  final List<AchievementDef> _queue = [];
  int _currentIndex = -1;
  int _totalCount = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen<List<String>>(newlyUnlockedProvider, (prev, next) {
      if (next.isEmpty) return;
      _enqueue(next);
      ref.read(newlyUnlockedProvider.notifier).clear();
    });

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (_) {
        if (_currentIndex < 0 || _currentIndex >= _queue.length) {
          return const SizedBox.shrink();
        }
        return CelebrationOverlay(
          key: ValueKey(_queue[_currentIndex].id),
          def: _queue[_currentIndex],
          currentNumber: _currentIndex + 1,
          totalCount: _totalCount,
          onComplete: _onCelebrationComplete,
        );
      },
      child: widget.child,
    );
  }

  void _enqueue(List<String> ids) {
    final defs = ids
        .map(AchievementDefinitions.byId)
        .whereType<AchievementDef>()
        .toList();
    defs.sort((a, b) => a.coinReward.compareTo(b.coinReward));

    _queue.addAll(defs);
    _totalCount = _queue.length;

    if (_currentIndex < 0) {
      setState(() => _currentIndex = 0);
      _overlayController.show();
    }
  }

  void _onCelebrationComplete({required bool skippedAll}) {
    if (skippedAll) {
      _overlayController.hide();
      _clear();
      return;
    }
    final next = _currentIndex + 1;
    if (next < _queue.length) {
      setState(() => _currentIndex = next);
    } else {
      _overlayController.hide();
      _clear();
    }
  }

  void _clear() {
    setState(() {
      _queue.clear();
      _currentIndex = -1;
      _totalCount = 0;
    });
  }
}
