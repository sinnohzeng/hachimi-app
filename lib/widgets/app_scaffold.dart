import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/core/theme/app_theme.dart';
import 'package:hachimi_app/providers/theme_provider.dart';
import 'package:hachimi_app/widgets/pixel_ui/retro_tiled_background.dart';

/// 应用级 Scaffold — 在 Retro Pixel 模式下自动叠加复古背景图案。
///
/// 替代标准 [Scaffold]，作为 [RetroTiledBackground] 的唯一集成点，
/// 避免在 25+ 个屏幕中逐一添加条件判断。
class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.pattern = PatternType.dots,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final PatternType pattern;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRetro =
        ref.watch(themeProvider.select((s) => s.uiStyle)) ==
        AppUiStyle.retroPixel;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: isRetro
          ? RetroTiledBackground(pattern: pattern, child: body)
          : body,
    );
  }
}
