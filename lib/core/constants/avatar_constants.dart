import 'package:flutter/material.dart';

/// 预设头像选项，用于用户资料头像。
class AvatarOption {
  final String id;
  final IconData icon;
  final Color color;

  const AvatarOption({
    required this.id,
    required this.icon,
    required this.color,
  });
}

/// 预设头像列表。用户选择后存储 [AvatarOption.id] 到 Firestore。
class AvatarConstants {
  AvatarConstants._();

  static const List<AvatarOption> avatars = [
    AvatarOption(id: 'cat_orange', icon: Icons.pets, color: Color(0xFFFF9800)),
    AvatarOption(id: 'cat_black', icon: Icons.pets, color: Color(0xFF424242)),
    AvatarOption(id: 'cat_white', icon: Icons.pets, color: Color(0xFFBDBDBD)),
    AvatarOption(
      id: 'paw',
      icon: Icons.catching_pokemon,
      color: Color(0xFF8BC34A),
    ),
    AvatarOption(id: 'star', icon: Icons.star, color: Color(0xFFFFC107)),
    AvatarOption(id: 'heart', icon: Icons.favorite, color: Color(0xFFE91E63)),
    AvatarOption(
      id: 'book',
      icon: Icons.auto_stories,
      color: Color(0xFF2196F3),
    ),
    AvatarOption(id: 'music', icon: Icons.music_note, color: Color(0xFF9C27B0)),
    AvatarOption(id: 'nature', icon: Icons.eco, color: Color(0xFF4CAF50)),
    AvatarOption(id: 'coffee', icon: Icons.coffee, color: Color(0xFF795548)),
    AvatarOption(
      id: 'moon',
      icon: Icons.nightlight_round,
      color: Color(0xFF3F51B5),
    ),
    AvatarOption(id: 'sun', icon: Icons.wb_sunny, color: Color(0xFFFF5722)),
  ];

  /// 根据 ID 查找头像。未找到返回 null。
  static AvatarOption? byId(String id) {
    return avatars.where((a) => a.id == id).firstOrNull;
  }
}
