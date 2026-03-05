import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/models/ledger_action.dart';
import 'package:hachimi_app/services/ledger_service.dart';
import 'package:hachimi_app/services/sync_engine.dart';
import 'package:hachimi_app/services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 访客升级后本地/云端存档合并执行器。
class AccountMergeService {
  final LedgerService _ledger;
  final SyncEngine _syncEngine;
  final UserProfileService _profileService;
  final AccountLifecycleBackend _lifecycleBackend;
  final SharedPreferences _prefs;

  AccountMergeService({
    required LedgerService ledger,
    required SyncEngine syncEngine,
    required UserProfileService profileService,
    required AccountLifecycleBackend lifecycleBackend,
    required SharedPreferences prefs,
  }) : _ledger = ledger,
       _syncEngine = syncEngine,
       _profileService = profileService,
       _lifecycleBackend = lifecycleBackend,
       _prefs = prefs;

  /// 保留云端存档：清理本地旧访客数据并水化云端。
  Future<void> keepCloud({
    required String oldUid,
    required String newUid,
  }) async {
    _syncEngine.stop();

    if (oldUid != newUid) {
      await _ledger.deleteUidData(oldUid);
    }

    await _prefs.remove(AppPrefsKeys.localGuestUid);
    await _prefs.setString(AppPrefsKeys.cachedUid, newUid);
    await _prefs.setBool(AppPrefsKeys.dataHydrated, false);

    await _syncEngine.hydrateFromFirestore(newUid);
    _syncEngine.start(newUid);
  }

  /// 保留本地存档：清空云端后把本地 UID 迁移到新账号并回推。
  Future<void> keepLocal({
    required String oldUid,
    required String newUid,
    required String email,
    String? displayName,
  }) async {
    _syncEngine.stop();

    await _lifecycleBackend.wipeUserData(
      context: OperationContext.capture(operationStage: 'account_merge'),
    );

    if (oldUid != newUid) {
      await _ledger.migrateUid(oldUid, newUid);
    }

    await _profileService.ensureProfile(
      uid: newUid,
      email: email,
      displayName: displayName,
    );

    await _prefs.remove(AppPrefsKeys.localGuestUid);
    await _prefs.setString(AppPrefsKeys.cachedUid, newUid);
    await _prefs.setBool(AppPrefsKeys.dataHydrated, true);

    _syncEngine.start(newUid);
    _ledger.notifyChange(const LedgerChange(type: 'hydrate'));
  }
}
