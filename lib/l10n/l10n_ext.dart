import 'package:flutter/widgets.dart';
import 'package:hachimi_app/l10n/app_localizations.dart';

extension L10nExt on BuildContext {
  S get l10n => S.of(this);
}
