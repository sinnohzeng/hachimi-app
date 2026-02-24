import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hachimi_app/core/theme/app_motion.dart';

/// StaggeredListItem — 列表项交错入场动画包装器。
///
/// 根据 [index] 自动计算延迟，首次构建时播放 fade + slideY 入场动画。
/// 仅在首次出现时动画，后续 rebuild 不重播。
///
/// 启用 [waitForRoute] 后，动画会等待路由转场完成才开始播放，
/// 避免与 Hero 动画重叠。
///
/// ```dart
/// itemBuilder: (context, index) => StaggeredListItem(
///   index: index,
///   waitForRoute: true,
///   child: MyCard(...),
/// ),
/// ```
class StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;

  /// 是否等待路由转场完成后再启动动画（默认 false）。
  final bool waitForRoute;

  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.waitForRoute = false,
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

  /// 缓存路由动画引用，确保 dispose 时移除的是同一个对象。
  Animation<double>? _routeAnimation;
  bool _started = false;

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

    if (!widget.waitForRoute) {
      _startDelayedAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.waitForRoute || _started || _routeAnimation != null) return;

    final route = ModalRoute.of(context);
    if (route == null) {
      _startDelayedAnimation();
      return;
    }

    final animation = route.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      _startDelayedAnimation();
    } else {
      _routeAnimation = animation;
      animation.addStatusListener(_onRouteAnimationStatus);
    }
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted && !_started) {
      _startDelayedAnimation();
    }
  }

  void _startDelayedAnimation() {
    _started = true;
    final delayMs = (widget.index * 50).clamp(0, 300);
    _delayTimer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
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
