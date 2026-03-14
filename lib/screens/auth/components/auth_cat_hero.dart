import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hachimi_app/models/cat_appearance.dart';
import 'package:hachimi_app/providers/cat_provider.dart';
import 'package:hachimi_app/screens/onboarding/components/onboarding_cat_hero.dart';

/// 登录/注册页的像素猫主视觉 — 随机生成外观，委托 OnboardingCatHero 渲染。
class AuthCatHero extends ConsumerStatefulWidget {
  final double size;

  const AuthCatHero({super.key, this.size = 120});

  @override
  ConsumerState<AuthCatHero> createState() => _AuthCatHeroState();
}

class _AuthCatHeroState extends ConsumerState<AuthCatHero> {
  late final CatAppearance _appearance;

  @override
  void initState() {
    super.initState();
    final gen = ref.read(pixelCatGenerationServiceProvider);
    _appearance = gen.generateRandomAppearance();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingCatHero(appearance: _appearance, size: widget.size);
  }
}
