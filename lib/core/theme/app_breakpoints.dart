import 'package:flutter/material.dart';

/// Material Design 3 Window Size Classes — 响应式布局断点。
///
/// 参考: https://m3.material.io/foundations/layout/applying-layout/window-size-classes
///
/// 断点:
///   compact  — width < 600dp  (手机竖屏)
///   medium   — 600dp <= width < 840dp  (7 寸平板、折叠屏、手机横屏)
///   expanded — width >= 840dp  (10 寸平板)
class AppBreakpoints {
  AppBreakpoints._();

  // M3 官方断点
  static const double compact = 600;
  static const double expanded = 840;

  // 内容约束
  static const double maxContentWidth = 640;
  static const double maxSheetWidth = 640;
}

/// M3 Window Size Class 枚举。
enum WindowSizeClass { compact, medium, expanded }

/// BuildContext 扩展 — 快速获取当前 Window Size Class。
extension WindowSizeExt on BuildContext {
  WindowSizeClass get windowSizeClass {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppBreakpoints.expanded) return WindowSizeClass.expanded;
    if (width >= AppBreakpoints.compact) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }

  bool get isCompact => windowSizeClass == WindowSizeClass.compact;
}
