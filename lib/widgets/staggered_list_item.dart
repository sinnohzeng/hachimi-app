import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';

/// StaggeredListItem — 列表项交错入场动画包装器。
///
/// 根据 [index] 自动计算延迟，首次构建时播放 fade + slideY 入场动画。
/// 仅在首次出现时动画，后续 rebuild 不重播。
///
/// ```dart
/// itemBuilder: (context, index) => StaggeredListItem(
///   index: index,
///   child: MyCard(...),
/// ),
/// ```
class StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.durationShort4,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.standardDecelerate,
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppMotion.standardDecelerate,
          ),
        );

    // 延迟 = index * 50ms，上限 300ms
    final delayMs = (widget.index * 50).clamp(0, 300);
    _delayTimer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
