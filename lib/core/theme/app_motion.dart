// ---
// 📘 文件说明：
// AppMotion — M3 motion token 体系，统一全项目的动效时长和缓动曲线。
// 所有 AnimationController duration / Curve 应使用此处常量。
//
// 🧩 文件结构：
// - AppMotion：static 常量类；
//
// 🕒 创建时间：2026-02-19
// ---

import 'package:flutter/material.dart';

/// AppMotion — Material Design 3 duration and easing tokens.
///
/// Duration tokens follow M3 naming:
///   short1~4 (50~200ms) — micro-interactions
///   medium1~4 (250~400ms) — standard transitions
///   long1~2 (450~500ms) — emphasis transitions
///
/// Easing tokens:
///   emphasized — enter/exit with emphasis
///   standard — default in/out
///   legacy — for older widgets requiring Curves.easeInOut
class AppMotion {
  AppMotion._();

  // --- Duration tokens (M3 spec) ---
  static const Duration durationShort1 = Duration(milliseconds: 50);
  static const Duration durationShort2 = Duration(milliseconds: 100);
  static const Duration durationShort3 = Duration(milliseconds: 150);
  static const Duration durationShort4 = Duration(milliseconds: 200);

  static const Duration durationMedium1 = Duration(milliseconds: 250);
  static const Duration durationMedium2 = Duration(milliseconds: 300);
  static const Duration durationMedium3 = Duration(milliseconds: 350);
  static const Duration durationMedium4 = Duration(milliseconds: 400);

  static const Duration durationLong1 = Duration(milliseconds: 450);
  static const Duration durationLong2 = Duration(milliseconds: 500);

  // --- Easing tokens (M3 spec) ---
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  static const Curve standard = Curves.easeInOut;
  static const Curve standardDecelerate = Curves.easeOut;
  static const Curve standardAccelerate = Curves.easeIn;
}
