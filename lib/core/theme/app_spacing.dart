// ---
// 📘 文件说明：
// AppSpacing — M3 spacing token 体系，消除全项目 magic numbers。
// 所有间距、内边距、外边距应使用此处常量代替硬编码字面量。
//
// 🧩 文件结构：
// - AppSpacing：static 常量类，包含 EdgeInsets 快捷方法；
//
// 🕒 创建时间：2026-02-19
// ---

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
}
