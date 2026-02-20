// ---
// 📘 文件说明：
// 猫系统的本地化扩展 — 集中管理所有猫相关的 ID → 展示文案映射。
// 数据模型只持有 ID，展示文案全部由本扩展提供。
//
// 🧩 文件结构：
// - CatL10n on S：性格名、性格风味文案、心情名、心情语录、阶段名；
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:hachimi_app/l10n/app_localizations.dart';

/// 猫系统的本地化扩展。
extension CatL10n on S {
  /// 性格 ID → 本地化名称
  String personalityName(String id) {
    switch (id) {
      case 'lazy':
        return personalityLazy;
      case 'curious':
        return personalityCurious;
      case 'playful':
        return personalityPlayful;
      case 'shy':
        return personalityShy;
      case 'brave':
        return personalityBrave;
      case 'clingy':
        return personalityClingy;
      default:
        return id;
    }
  }

  /// 性格 ID → 本地化风味文案
  String personalityFlavor(String id) {
    switch (id) {
      case 'lazy':
        return personalityFlavorLazy;
      case 'curious':
        return personalityFlavorCurious;
      case 'playful':
        return personalityFlavorPlayful;
      case 'shy':
        return personalityFlavorShy;
      case 'brave':
        return personalityFlavorBrave;
      case 'clingy':
        return personalityFlavorClingy;
      default:
        return '';
    }
  }

  /// 心情 ID → 本地化名称
  String moodName(String id) {
    switch (id) {
      case 'happy':
        return moodHappy;
      case 'neutral':
        return moodNeutral;
      case 'lonely':
        return moodLonely;
      case 'missing':
        return moodMissing;
      default:
        return id;
    }
  }

  /// personality:mood → 本地化语录
  String moodMessage(String personalityId, String moodId) {
    final key = '$personalityId:$moodId';
    switch (key) {
      // Happy
      case 'lazy:happy':
        return moodMsgLazyHappy;
      case 'curious:happy':
        return moodMsgCuriousHappy;
      case 'playful:happy':
        return moodMsgPlayfulHappy;
      case 'shy:happy':
        return moodMsgShyHappy;
      case 'brave:happy':
        return moodMsgBraveHappy;
      case 'clingy:happy':
        return moodMsgClingyHappy;
      // Neutral
      case 'lazy:neutral':
        return moodMsgLazyNeutral;
      case 'curious:neutral':
        return moodMsgCuriousNeutral;
      case 'playful:neutral':
        return moodMsgPlayfulNeutral;
      case 'shy:neutral':
        return moodMsgShyNeutral;
      case 'brave:neutral':
        return moodMsgBraveNeutral;
      case 'clingy:neutral':
        return moodMsgClingyNeutral;
      // Lonely
      case 'lazy:lonely':
        return moodMsgLazyLonely;
      case 'curious:lonely':
        return moodMsgCuriousLonely;
      case 'playful:lonely':
        return moodMsgPlayfulLonely;
      case 'shy:lonely':
        return moodMsgShyLonely;
      case 'brave:lonely':
        return moodMsgBraveLonely;
      case 'clingy:lonely':
        return moodMsgClingyLonely;
      // Missing
      case 'lazy:missing':
        return moodMsgLazyMissing;
      case 'curious:missing':
        return moodMsgCuriousMissing;
      case 'playful:missing':
        return moodMsgPlayfulMissing;
      case 'shy:missing':
        return moodMsgShyMissing;
      case 'brave:missing':
        return moodMsgBraveMissing;
      case 'clingy:missing':
        return moodMsgClingyMissing;
      default:
        return 'Meow~';
    }
  }

  /// 阶段 ID → 本地化名称
  String stageName(String stageId) {
    switch (stageId) {
      case 'kitten':
        return stageKitten;
      case 'adolescent':
        return stageAdolescent;
      case 'adult':
        return stageAdult;
      case 'senior':
        return stageSenior;
      default:
        return stageId;
    }
  }
}
