import 'package:hachimi_app/models/cat_appearance.dart';

/// 皮毛图案类型 → 人类可读描述。
String peltTypeDescription(String peltType) {
  switch (peltType) {
    case 'Tabby':
      return 'Classic tabby stripes';
    case 'Ticked':
      return 'Ticked agouti pattern';
    case 'Mackerel':
      return 'Mackerel tabby';
    case 'Classic':
      return 'Classic swirl pattern';
    case 'Sokoke':
      return 'Sokoke marble pattern';
    case 'Agouti':
      return 'Agouti ticked';
    case 'Speckled':
      return 'Speckled coat';
    case 'Rosette':
      return 'Rosette spotted';
    case 'SingleColour':
      return 'Solid color';
    case 'TwoColour':
      return 'Two-tone';
    case 'Smoke':
      return 'Smoke shading';
    case 'Singlestripe':
      return 'Single stripe';
    case 'Bengal':
      return 'Bengal pattern';
    case 'Marbled':
      return 'Marbled pattern';
    case 'Masked':
      return 'Masked face';
    default:
      return peltType;
  }
}

/// 皮毛颜色 ID → 人类可读名称。
String peltColorDescription(String color) {
  switch (color) {
    case 'WHITE':
      return 'White';
    case 'PALEGREY':
      return 'Pale grey';
    case 'SILVER':
      return 'Silver';
    case 'GREY':
      return 'Grey';
    case 'DARKGREY':
      return 'Dark grey';
    case 'GHOST':
      return 'Ghost grey';
    case 'BLACK':
      return 'Black';
    case 'CREAM':
      return 'Cream';
    case 'PALEGINGER':
      return 'Pale ginger';
    case 'GOLDEN':
      return 'Golden';
    case 'GINGER':
      return 'Ginger';
    case 'DARKGINGER':
      return 'Dark ginger';
    case 'SIENNA':
      return 'Sienna';
    case 'LIGHTBROWN':
      return 'Light brown';
    case 'LILAC':
      return 'Lilac';
    case 'BROWN':
      return 'Brown';
    case 'GOLDEN-BROWN':
      return 'Golden brown';
    case 'DARKBROWN':
      return 'Dark brown';
    case 'CHOCOLATE':
      return 'Chocolate';
    default:
      return color[0] + color.substring(1).toLowerCase();
  }
}

/// 眼色 ID → 人类可读名称。支持异色瞳。
String eyeDescription(String eyeColor, String? eyeColor2) {
  final primary = _eyeColorName(eyeColor);
  if (eyeColor2 != null && eyeColor2.isNotEmpty && eyeColor2 != eyeColor) {
    return 'Heterochromia ($primary / ${_eyeColorName(eyeColor2)})';
  }
  return '$primary eyes';
}

String _eyeColorName(String color) {
  switch (color) {
    case 'YELLOW':
      return 'Yellow';
    case 'AMBER':
      return 'Amber';
    case 'HAZEL':
      return 'Hazel';
    case 'PALEGREEN':
      return 'Pale green';
    case 'GREEN':
      return 'Green';
    case 'BLUE':
      return 'Blue';
    case 'DARKBLUE':
      return 'Dark blue';
    case 'BLUEYELLOW':
      return 'Blue-yellow';
    case 'BLUEGREEN':
      return 'Blue-green';
    case 'GREY':
      return 'Grey';
    case 'CYAN':
      return 'Cyan';
    case 'EMERALD':
      return 'Emerald';
    case 'HEATHERBLUE':
      return 'Heather blue';
    case 'SUNLITICE':
      return 'Sunlit ice';
    case 'COPPER':
      return 'Copper';
    case 'SAGE':
      return 'Sage';
    case 'COBALT':
      return 'Cobalt';
    case 'PALEBLUE':
      return 'Pale blue';
    case 'BRONZE':
      return 'Bronze';
    case 'SILVER':
      return 'Silver';
    case 'PALEYELLOW':
      return 'Pale yellow';
    default:
      return color[0] + color.substring(1).toLowerCase();
  }
}

/// 毛发长度描述。
String furLengthDescription(bool isLonghair) {
  return isLonghair ? 'Longhair' : 'Shorthair';
}

/// 白斑色调描述。
String? whitePatchesTintDescription(String tint) {
  switch (tint) {
    case 'none':
      return null;
    case 'offwhite':
      return 'Off-white tint';
    case 'cream':
      return 'Cream tint';
    case 'darkcream':
      return 'Dark cream tint';
    case 'gray':
      return 'Grey tint';
    case 'pink':
      return 'Pink tint';
    default:
      return null;
  }
}

/// 皮肤色描述。
String skinColorDescription(String skinColor) {
  switch (skinColor) {
    case 'PINK':
      return 'Pink';
    case 'RED':
      return 'Red';
    case 'BLACK':
      return 'Black';
    case 'DARK':
      return 'Dark';
    case 'DARKBROWN':
      return 'Dark brown';
    case 'BROWN':
      return 'Brown';
    case 'LIGHTBROWN':
      return 'Light brown';
    case 'DARKGREY':
      return 'Dark grey';
    case 'GREY':
      return 'Grey';
    case 'DARKSALMON':
      return 'Dark salmon';
    case 'SALMON':
      return 'Salmon';
    case 'PEACH':
      return 'Peach';
    default:
      return skinColor[0] + skinColor.substring(1).toLowerCase();
  }
}

/// 一行概要：如 "Ginger tabby, golden eyes, longhair"。
String fullSummary(CatAppearance a) {
  final parts = <String>[];

  // Color + pattern
  parts.add(
    '${peltColorDescription(a.peltColor)} ${peltTypeDescription(a.peltType).toLowerCase()}',
  );

  // Eyes
  parts.add(eyeDescription(a.eyeColor, a.eyeColor2));

  // Fur length
  parts.add(furLengthDescription(a.isLonghair).toLowerCase());

  return parts.join(', ');
}
