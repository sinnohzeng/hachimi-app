import 'package:flutter/material.dart';
import 'package:hachimi_app/core/constants/app_prefs_keys.dart';
import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:hachimi_app/models/account_data_snapshot.dart';
import 'package:hachimi_app/services/account_merge_service.dart';
import 'package:hachimi_app/services/account_snapshot_service.dart';
import 'package:hachimi_app/widgets/archive_conflict_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 访客升级协调器：在账号切换后执行本地/云端冲突判定与合并。
class GuestUpgradeCoordinator {
  final AccountSnapshotService _snapshotService;
  final AccountMergeService _mergeService;
  final SharedPreferences _prefs;

  GuestUpgradeCoordinator({
    required AccountSnapshotService snapshotService,
    required AccountMergeService mergeService,
    required SharedPreferences prefs,
  }) : _snapshotService = snapshotService,
       _mergeService = mergeService,
       _prefs = prefs;

  Future<void> resolve({
    required BuildContext context,
    required String migrationSourceUid,
    required String newUid,
    required String email,
    String? displayName,
  }) async {
    if (migrationSourceUid == newUid) return;

    final expectedGuestUid = _prefs.getString(AppPrefsKeys.localGuestUid);
    if (expectedGuestUid != null && expectedGuestUid != migrationSourceUid) {
      await ErrorHandler.recordOperation(
        Exception('guest_merge_source_mismatch'),
        feature: 'GuestUpgradeCoordinator',
        operation: 'resolve',
        operationStage: 'account_merge',
        errorCode: 'guest_merge_source_mismatch',
      );
      return;
    }

    final local = await _snapshotService.readLocal(migrationSourceUid);

    // 空访客无数据 — 只清理标记，不执行合并
    if (local.isEmpty) {
      await _prefs.remove(AppPrefsKeys.localGuestUid);
      return;
    }

    // 云端快照读取 best-effort — 失败视为空（安全默认保留本地）
    final cloud = await _readCloudOrEmpty(newUid);

    if (!context.mounted) return;
    final choice = await _decide(context, local: local, cloud: cloud);

    if (choice == ArchiveConflictChoice.keepLocal) {
      await _mergeService.keepLocal(
        oldUid: migrationSourceUid,
        newUid: newUid,
        email: email,
        displayName: displayName,
      );
      return;
    }

    await _mergeService.keepCloud(oldUid: migrationSourceUid, newUid: newUid);
  }

  Future<AccountDataSnapshot> _readCloudOrEmpty(String uid) async {
    try {
      return await _snapshotService.readCloud(uid);
    } on Exception catch (e) {
      ErrorHandler.recordOperation(
        e,
        feature: 'GuestUpgradeCoordinator',
        operation: 'readCloudSnapshot',
        errorCode: 'cloud_snapshot_failed',
      );
      return const AccountDataSnapshot();
    }
  }

  Future<ArchiveConflictChoice> _decide(
    BuildContext context, {
    required AccountDataSnapshot local,
    required AccountDataSnapshot cloud,
  }) async {
    if (local.isEmpty && !cloud.isEmpty) {
      return ArchiveConflictChoice.keepCloud;
    }
    if (!local.isEmpty && cloud.isEmpty) {
      return ArchiveConflictChoice.keepLocal;
    }
    if (local.isEmpty && cloud.isEmpty) {
      return ArchiveConflictChoice.keepLocal;
    }

    final selected = await showArchiveConflictDialog(
      context: context,
      local: local,
      cloud: cloud,
    );
    return selected ?? ArchiveConflictChoice.keepCloud;
  }
}
