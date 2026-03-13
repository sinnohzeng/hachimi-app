import 'package:flutter/material.dart';

/// AppSpacing — Material Design 3 spacing tokens.
///
/// Usage:
/// ```dart
/// SizedBox(height: AppSpacing.md)
/// Padding(padding: AppSpacing.paddingBase)
/// ```
class AppSpacing {
  AppSpacing._();

  // --- Base scale ---
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // --- Common EdgeInsets ---
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingBase = EdgeInsets.all(base);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // --- Horizontal-only ---
  static const EdgeInsets paddingHBase = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);

  // --- Vertical-only ---
  static const EdgeInsets paddingVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVBase = EdgeInsets.symmetric(vertical: base);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVXl = EdgeInsets.symmetric(vertical: xl);

  // --- Single-side ---
  static const EdgeInsets paddingTopSm = EdgeInsets.only(top: sm);
  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets paddingTopBase = EdgeInsets.only(top: base);
  static const EdgeInsets paddingBottomSm = EdgeInsets.only(bottom: sm);
  static const EdgeInsets paddingBottomBase = EdgeInsets.only(bottom: base);
  static const EdgeInsets paddingBottomXl = EdgeInsets.only(bottom: xl);

  // --- Single-side horizontal ---
  static const EdgeInsets paddingLeftBase = EdgeInsets.only(left: base);
  static const EdgeInsets paddingRightBase = EdgeInsets.only(right: base);

  // --- Common mixed patterns ---
  static const EdgeInsets paddingListTile = EdgeInsets.symmetric(
    horizontal: base,
    vertical: xs,
  );
  static const EdgeInsets paddingSection = EdgeInsets.fromLTRB(
    base,
    lg,
    base,
    sm,
  );
  static const EdgeInsets paddingCard = EdgeInsets.symmetric(
    horizontal: base,
    vertical: xs,
  );

  /// 屏幕内容区 — 水平 base + 顶部 sm。
  static const EdgeInsets paddingScreenBody = EdgeInsets.fromLTRB(
    base,
    sm,
    base,
    0,
  );

  /// 屏幕内容区（带底部安全间距）。
  static const EdgeInsets paddingScreenBodyFull = EdgeInsets.fromLTRB(
    base,
    sm,
    base,
    base,
  );

  /// 紧凑屏幕内容区 — 水平 base + 顶部 xs。
  static const EdgeInsets paddingScreenBodyCompact = EdgeInsets.fromLTRB(
    base,
    xs,
    base,
    0,
  );

  /// 宽松屏幕内容区 — 水平 lg + 顶部 base。
  static const EdgeInsets paddingScreenBodyWide = EdgeInsets.fromLTRB(
    lg,
    base,
    lg,
    base,
  );

  /// 对话框/Sheet 内容区。
  static const EdgeInsets paddingDialog = EdgeInsets.all(lg);

  /// 紧凑对话框内容区。
  static const EdgeInsets paddingDialogCompact = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: base,
  );
}
