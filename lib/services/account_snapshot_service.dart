import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hachimi_app/models/account_data_snapshot.dart';
import 'package:hachimi_app/services/local_database_service.dart';

/// 存档快照服务：用于本地与云端冲突对比。
class AccountSnapshotService {
  final LocalDatabaseService _localDb;
  final FirebaseFirestore _db;

  AccountSnapshotService({
    required LocalDatabaseService localDb,
    FirebaseFirestore? db,
  }) : _localDb = localDb,
       _db = db ?? FirebaseFirestore.instance;

  Future<AccountDataSnapshot> readLocal(String uid) async {
    final db = await _localDb.database;
    final habits = await db.rawQuery(
      'SELECT COUNT(*) AS count, COALESCE(SUM(total_minutes), 0) AS minutes '
      'FROM local_habits WHERE uid = ?',
      [uid],
    );
    final cats = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM local_cats WHERE uid = ?',
      [uid],
    );
    final achievements = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM local_achievements '
      'WHERE uid = ? AND unlocked_at IS NOT NULL',
      [uid],
    );
    final coins = await db.query(
      'materialized_state',
      columns: ['value'],
      where: 'uid = ? AND key = ?',
      whereArgs: [uid, 'coins'],
      limit: 1,
    );

    return AccountDataSnapshot(
      focusMinutes: _toInt(habits.first['minutes']),
      habits: _toInt(habits.first['count']),
      cats: _toInt(cats.first['count']),
      achievements: _toInt(achievements.first['count']),
      coins: coins.isEmpty ? 0 : int.tryParse('${coins.first['value']}') ?? 0,
    );
  }

  Future<AccountDataSnapshot> readCloud(String uid) async {
    final userRef = _db.collection('users').doc(uid);
    final userDoc = await userRef.get();
    if (!userDoc.exists) return const AccountDataSnapshot();

    final habits = await userRef.collection('habits').get();
    final cats = await userRef.collection('cats').get();
    final achievements = await userRef.collection('achievements').get();

    var minutes = 0;
    for (final doc in habits.docs) {
      minutes += (doc.data()['totalMinutes'] as int?) ?? 0;
    }

    return AccountDataSnapshot(
      focusMinutes: minutes,
      habits: habits.docs.length,
      cats: cats.docs.length,
      achievements: achievements.docs.length,
      coins: (userDoc.data()?['coins'] as int?) ?? 0,
    );
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }
}
