import 'package:flutter/material.dart';

/// AppShape — Material Design 3 shape tokens.
///
/// M3 Shape Scale:
///   none (0dp) — 全屏容器
///   extraSmall (4dp) — Chip、小按钮
///   small (8dp) — SnackBar、TextField
///   medium (12dp) — Card、Dialog
///   large (16dp) — FAB、BottomSheet
///   extraLarge (28dp) — 大型 Sheet、Modal
///   full (圆形) — Avatar、Badge
class AppShape {
  AppShape._();

  // --- M3 Shape Scale (dp) ---
  static const double none = 0;
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 28;
  static const double full = 1000;

  // --- BorderRadius ---
  static final BorderRadius borderNone = BorderRadius.circular(none);
  static final BorderRadius borderExtraSmall = BorderRadius.circular(
    extraSmall,
  );
  static final BorderRadius borderSmall = BorderRadius.circular(small);
  static final BorderRadius borderMedium = BorderRadius.circular(medium);
  static final BorderRadius borderLarge = BorderRadius.circular(large);
  static final BorderRadius borderExtraLarge = BorderRadius.circular(
    extraLarge,
  );
  static final BorderRadius borderFull = BorderRadius.circular(full);

  // --- RoundedRectangleBorder ---
  static final RoundedRectangleBorder shapeNone = RoundedRectangleBorder(
    borderRadius: borderNone,
  );
  static final RoundedRectangleBorder shapeExtraSmall = RoundedRectangleBorder(
    borderRadius: borderExtraSmall,
  );
  static final RoundedRectangleBorder shapeSmall = RoundedRectangleBorder(
    borderRadius: borderSmall,
  );
  static final RoundedRectangleBorder shapeMedium = RoundedRectangleBorder(
    borderRadius: borderMedium,
  );
  static final RoundedRectangleBorder shapeLarge = RoundedRectangleBorder(
    borderRadius: borderLarge,
  );
  static final RoundedRectangleBorder shapeExtraLarge = RoundedRectangleBorder(
    borderRadius: borderExtraLarge,
  );
}
