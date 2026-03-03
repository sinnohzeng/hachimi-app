import 'package:hachimi_app/models/cat_appearance.dart';

/// 皮毛图案类型 → 人类可读描述。
String peltTypeDescription(String peltType) =>
    _peltTypeDescriptions[peltType] ?? peltType;

/// 皮毛颜色 ID → 人类可读名称。
String peltColorDescription(String color) =>
    _peltColorDescriptions[color] ?? _titleCaseToken(color);

/// 眼色 ID → 人类可读名称。支持异色瞳。
String eyeDescription(String eyeColor, String? eyeColor2) {
  final primary = _eyeColorName(eyeColor);
  if (eyeColor2 != null && eyeColor2.isNotEmpty && eyeColor2 != eyeColor) {
    return 'Heterochromia ($primary / ${_eyeColorName(eyeColor2)})';
  }
  return '$primary eyes';
}

String _eyeColorName(String color) =>
    _eyeColorDescriptions[color] ?? _titleCaseToken(color);

/// 毛发长度描述。
String furLengthDescription(bool isLonghair) {
  return isLonghair ? 'Longhair' : 'Shorthair';
}

/// 白斑色调描述。
String? whitePatchesTintDescription(String tint) => _whitePatchesTint[tint];

/// 皮肤色描述。
String skinColorDescription(String skinColor) =>
    _skinColorDescriptions[skinColor] ?? _titleCaseToken(skinColor);

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

String _titleCaseToken(String input) {
  if (input.isEmpty) return input;
  return input[0] + input.substring(1).toLowerCase();
}

const Map<String, String> _peltTypeDescriptions = {
  'Tabby': 'Classic tabby stripes',
  'Ticked': 'Ticked agouti pattern',
  'Mackerel': 'Mackerel tabby',
  'Classic': 'Classic swirl pattern',
  'Sokoke': 'Sokoke marble pattern',
  'Agouti': 'Agouti ticked',
  'Speckled': 'Speckled coat',
  'Rosette': 'Rosette spotted',
  'SingleColour': 'Solid color',
  'TwoColour': 'Two-tone',
  'Smoke': 'Smoke shading',
  'Singlestripe': 'Single stripe',
  'Bengal': 'Bengal pattern',
  'Marbled': 'Marbled pattern',
  'Masked': 'Masked face',
};

const Map<String, String> _peltColorDescriptions = {
  'WHITE': 'White',
  'PALEGREY': 'Pale grey',
  'SILVER': 'Silver',
  'GREY': 'Grey',
  'DARKGREY': 'Dark grey',
  'GHOST': 'Ghost grey',
  'BLACK': 'Black',
  'CREAM': 'Cream',
  'PALEGINGER': 'Pale ginger',
  'GOLDEN': 'Golden',
  'GINGER': 'Ginger',
  'DARKGINGER': 'Dark ginger',
  'SIENNA': 'Sienna',
  'LIGHTBROWN': 'Light brown',
  'LILAC': 'Lilac',
  'BROWN': 'Brown',
  'GOLDEN-BROWN': 'Golden brown',
  'DARKBROWN': 'Dark brown',
  'CHOCOLATE': 'Chocolate',
};

const Map<String, String> _eyeColorDescriptions = {
  'YELLOW': 'Yellow',
  'AMBER': 'Amber',
  'HAZEL': 'Hazel',
  'PALEGREEN': 'Pale green',
  'GREEN': 'Green',
  'BLUE': 'Blue',
  'DARKBLUE': 'Dark blue',
  'BLUEYELLOW': 'Blue-yellow',
  'BLUEGREEN': 'Blue-green',
  'GREY': 'Grey',
  'CYAN': 'Cyan',
  'EMERALD': 'Emerald',
  'HEATHERBLUE': 'Heather blue',
  'SUNLITICE': 'Sunlit ice',
  'COPPER': 'Copper',
  'SAGE': 'Sage',
  'COBALT': 'Cobalt',
  'PALEBLUE': 'Pale blue',
  'BRONZE': 'Bronze',
  'SILVER': 'Silver',
  'PALEYELLOW': 'Pale yellow',
};

const Map<String, String?> _whitePatchesTint = {
  'none': null,
  'offwhite': 'Off-white tint',
  'cream': 'Cream tint',
  'darkcream': 'Dark cream tint',
  'gray': 'Grey tint',
  'pink': 'Pink tint',
};

const Map<String, String> _skinColorDescriptions = {
  'PINK': 'Pink',
  'RED': 'Red',
  'BLACK': 'Black',
  'DARK': 'Dark',
  'DARKBROWN': 'Dark brown',
  'BROWN': 'Brown',
  'LIGHTBROWN': 'Light brown',
  'DARKGREY': 'Dark grey',
  'GREY': 'Grey',
  'DARKSALMON': 'Dark salmon',
  'SALMON': 'Salmon',
  'PEACH': 'Peach',
};
