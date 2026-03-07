import 'package:hachimi_app/core/backend/account_lifecycle_backend.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/observability/operation_context.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
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

  /// 保留本地存档：先迁移本地 UID，再 best-effort 清理云端孤立数据。
  ///
  /// 操作顺序：本地迁移（原子，SQLite 事务）→ 更新缓存 → 启动同步 → 云端清理。
  /// 云端清理失败不影响用户数据，孤立数据可后续清理。
  Future<void> keepLocal({
    required String oldUid,
    required String newUid,
    required String email,
    String? displayName,
  }) async {
    _syncEngine.stop();

    // 1. 关键：本地 UID 迁移（SQLite 事务，原子操作）
    if (oldUid != newUid) {
      await _ledger.migrateUid(oldUid, newUid);
    }

    // 2. 确保 Firestore 用户文档存在
    await _profileService.ensureProfile(
      uid: newUid,
      email: email,
      displayName: displayName,
    );

    // 3. 更新本地认证缓存
    await _prefs.remove(AppPrefsKeys.localGuestUid);
    await _prefs.setString(AppPrefsKeys.cachedUid, newUid);
    await _prefs.setBool(AppPrefsKeys.dataHydrated, true);

    // 4. 恢复同步 + 通知 UI
    _syncEngine.start(newUid);
    _ledger.notifyChange(const LedgerChange(type: 'hydrate'));

    // 5. Best-effort: 清理旧账号云端孤立数据
    _wipeCloudBestEffort();
  }

  /// 云端清理 fire-and-forget — 失败仅记录，不影响用户体验。
  void _wipeCloudBestEffort() {
    _lifecycleBackend
        .wipeUserData(
          context: OperationContext.capture(operationStage: 'account_merge'),
        )
        .catchError((Object e, StackTrace stack) {
          ErrorHandler.recordOperation(
            e,
            stackTrace: stack,
            feature: 'AccountMergeService',
            operation: 'keepLocal_wipeCloud',
            errorCode: 'wipe_cloud_best_effort',
          );
        });
  }
}
