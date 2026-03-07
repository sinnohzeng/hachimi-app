import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Resolves deterministic source UID for guest/anonymous to credentialed migration.
class IdentityTransitionResolver {
  final SharedPreferences _prefs;

  IdentityTransitionResolver({required SharedPreferences prefs})
    : _prefs = prefs;

  /// Priority:
  /// 1. `local_guest_uid` (stable source of local-first data)
  /// 2. caller-provided current uid fallback
  String? resolveMigrationSourceUid({required String? currentUid}) {
    return _prefs.getString(AppPrefsKeys.localGuestUid) ?? currentUid;
  }
}
