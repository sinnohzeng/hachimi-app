import 'package:flutter_test/flutter_test.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/services/identity_transition_resolver.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('IdentityTransitionResolver', () {
    test('prefers local_guest_uid when present', () async {
      SharedPreferences.setMockInitialValues({
        AppPrefsKeys.localGuestUid: 'guest_123',
      });
      final prefs = await SharedPreferences.getInstance();
      final resolver = IdentityTransitionResolver(prefs: prefs);

      final sourceUid = resolver.resolveMigrationSourceUid(
        currentUid: 'anon_abc',
      );

      expect(sourceUid, 'guest_123');
    });

    test('falls back to current uid when local_guest_uid missing', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final resolver = IdentityTransitionResolver(prefs: prefs);

      final sourceUid = resolver.resolveMigrationSourceUid(
        currentUid: 'anon_abc',
      );

      expect(sourceUid, 'anon_abc');
    });

    test('returns null when both sources missing', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final resolver = IdentityTransitionResolver(prefs: prefs);

      final sourceUid = resolver.resolveMigrationSourceUid(currentUid: null);

      expect(sourceUid, isNull);
    });
  });
}
