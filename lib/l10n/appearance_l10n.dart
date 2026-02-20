// ---
// 📘 文件说明：
// 外观描述的本地化扩展 — 将 CatAppearance 各字段 ID 映射为本地化展示文案。
// 替代原 appearance_descriptions.dart 中的硬编码英文函数。
//
// 🧩 文件结构：
// - AppearanceL10n on S：皮毛类型、皮毛颜色、眼色、皮肤色、毛长、白斑色调、摘要；
//
// 🕒 创建时间：2026-02-20
// ---

import 'package:hachimi_app/l10n/app_localizations.dart';
import 'package:hachimi_app/models/cat_appearance.dart';

/// 外观描述的本地化扩展。
extension AppearanceL10n on S {
  /// 皮毛图案类型 ID → 本地化描述
  String peltTypeName(String type) {
    switch (type) {
      case 'Tabby':
        return peltTypeTabby;
      case 'Ticked':
        return peltTypeTicked;
      case 'Mackerel':
        return peltTypeMackerel;
      case 'Classic':
        return peltTypeClassic;
      case 'Sokoke':
        return peltTypeSokoke;
      case 'Agouti':
        return peltTypeAgouti;
      case 'Speckled':
        return peltTypeSpeckled;
      case 'Rosette':
        return peltTypeRosette;
      case 'SingleColour':
        return peltTypeSingleColour;
      case 'TwoColour':
        return peltTypeTwoColour;
      case 'Smoke':
        return peltTypeSmoke;
      case 'Singlestripe':
        return peltTypeSinglestripe;
      case 'Bengal':
        return peltTypeBengal;
      case 'Marbled':
        return peltTypeMarbled;
      case 'Masked':
        return peltTypeMasked;
      default:
        return type;
    }
  }

  /// 皮毛颜色 ID → 本地化名称
  String peltColorName(String color) {
    switch (color) {
      case 'WHITE':
        return peltColorWhite;
      case 'PALEGREY':
        return peltColorPaleGrey;
      case 'SILVER':
        return peltColorSilver;
      case 'GREY':
        return peltColorGrey;
      case 'DARKGREY':
        return peltColorDarkGrey;
      case 'GHOST':
        return peltColorGhost;
      case 'BLACK':
        return peltColorBlack;
      case 'CREAM':
        return peltColorCream;
      case 'PALEGINGER':
        return peltColorPaleGinger;
      case 'GOLDEN':
        return peltColorGolden;
      case 'GINGER':
        return peltColorGinger;
      case 'DARKGINGER':
        return peltColorDarkGinger;
      case 'SIENNA':
        return peltColorSienna;
      case 'LIGHTBROWN':
        return peltColorLightBrown;
      case 'LILAC':
        return peltColorLilac;
      case 'BROWN':
        return peltColorBrown;
      case 'GOLDEN-BROWN':
        return peltColorGoldenBrown;
      case 'DARKBROWN':
        return peltColorDarkBrown;
      case 'CHOCOLATE':
        return peltColorChocolate;
      default:
        return color[0] + color.substring(1).toLowerCase();
    }
  }

  /// 眼色 ID → 本地化名称
  String eyeColorName(String color) {
    switch (color) {
      case 'YELLOW':
        return eyeColorYellow;
      case 'AMBER':
        return eyeColorAmber;
      case 'HAZEL':
        return eyeColorHazel;
      case 'PALEGREEN':
        return eyeColorPaleGreen;
      case 'GREEN':
        return eyeColorGreen;
      case 'BLUE':
        return eyeColorBlue;
      case 'DARKBLUE':
        return eyeColorDarkBlue;
      case 'BLUEYELLOW':
        return eyeColorBlueYellow;
      case 'BLUEGREEN':
        return eyeColorBlueGreen;
      case 'GREY':
        return eyeColorGrey;
      case 'CYAN':
        return eyeColorCyan;
      case 'EMERALD':
        return eyeColorEmerald;
      case 'HEATHERBLUE':
        return eyeColorHeatherBlue;
      case 'SUNLITICE':
        return eyeColorSunlitIce;
      case 'COPPER':
        return eyeColorCopper;
      case 'SAGE':
        return eyeColorSage;
      case 'COBALT':
        return eyeColorCobalt;
      case 'PALEBLUE':
        return eyeColorPaleBlue;
      case 'BRONZE':
        return eyeColorBronze;
      case 'SILVER':
        return eyeColorSilver;
      case 'PALEYELLOW':
        return eyeColorPaleYellow;
      default:
        return color[0] + color.substring(1).toLowerCase();
    }
  }

  /// 眼色描述（含异色瞳）
  String eyeDesc(String eyeColor, String? eyeColor2) {
    final primary = eyeColorName(eyeColor);
    if (eyeColor2 != null && eyeColor2.isNotEmpty && eyeColor2 != eyeColor) {
      return eyeDescHeterochromia(primary, eyeColorName(eyeColor2));
    }
    return eyeDescNormal(primary);
  }

  /// 皮肤色 ID → 本地化名称
  String skinColorName(String color) {
    switch (color) {
      case 'PINK':
        return skinColorPink;
      case 'RED':
        return skinColorRed;
      case 'BLACK':
        return skinColorBlack;
      case 'DARK':
        return skinColorDark;
      case 'DARKBROWN':
        return skinColorDarkBrown;
      case 'BROWN':
        return skinColorBrown;
      case 'LIGHTBROWN':
        return skinColorLightBrown;
      case 'DARKGREY':
        return skinColorDarkGrey;
      case 'GREY':
        return skinColorGrey;
      case 'DARKSALMON':
        return skinColorDarkSalmon;
      case 'SALMON':
        return skinColorSalmon;
      case 'PEACH':
        return skinColorPeach;
      default:
        return color[0] + color.substring(1).toLowerCase();
    }
  }

  /// 毛发长度描述
  String furLength(bool isLonghair) {
    return isLonghair ? furLengthLonghair : furLengthShorthair;
  }

  /// 白斑色调描述（null 表示无色调）
  String? whitePatchesTintName(String tint) {
    switch (tint) {
      case 'none':
        return null;
      case 'offwhite':
        return whiteTintOffwhite;
      case 'cream':
        return whiteTintCream;
      case 'darkcream':
        return whiteTintDarkCream;
      case 'gray':
        return whiteTintGray;
      case 'pink':
        return whiteTintPink;
      default:
        return null;
    }
  }

  /// 一行概要：如 "Ginger tabby, golden eyes, longhair"
  String fullAppearanceSummary(CatAppearance a) {
    final parts = <String>[];
    parts.add('${peltColorName(a.peltColor)} ${peltTypeName(a.peltType).toLowerCase()}');
    parts.add(eyeDesc(a.eyeColor, a.eyeColor2));
    parts.add(furLength(a.isLonghair).toLowerCase());
    return parts.join(', ');
  }
}
