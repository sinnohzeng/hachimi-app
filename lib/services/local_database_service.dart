import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/models/chat_message.dart';

/// 本地 SQLite 数据库服务。
/// 管理 AI 日记/聊天 + 行为台账 + 领域表的持久化存储。
class LocalDatabaseService {
  static const _dbName = 'hachimi_local.db';
  static const _dbVersion = 3;

  Database? _db;

  /// 获取数据库实例（懒初始化）。
  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ─── Schema ───

  Future<void> _onCreate(Database db, int version) async {
    await _createV1Tables(db);
    if (version >= 2) {
      await _createV2Tables(db);
    }
    if (version >= 3) {
      await _createV3Columns(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      await _createV2Tables(db);
    }
    if (oldV < 3) {
      await _createV3Columns(db);
    }
  }

  /// v1 表：日记 + 聊天。
  Future<void> _createV1Tables(Database db) async {
    await db.execute('''
      CREATE TABLE diary_entries (
        id TEXT PRIMARY KEY,
        cat_id TEXT NOT NULL,
        habit_id TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        personality TEXT NOT NULL,
        mood TEXT NOT NULL,
        stage TEXT NOT NULL,
        total_minutes INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        UNIQUE(cat_id, date)
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        cat_id TEXT NOT NULL,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_diary_cat_date ON diary_entries(cat_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_chat_cat ON chat_messages(cat_id, created_at)',
    );
  }

  /// v2 表：行为台账 + 6 张领域表。
  Future<void> _createV2Tables(Database db) async {
    // 行为台账：不可变事件日志
    await db.execute('''
      CREATE TABLE action_ledger (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        uid TEXT NOT NULL,
        started_at INTEGER NOT NULL,
        ended_at INTEGER,
        payload TEXT NOT NULL DEFAULT '{}',
        result TEXT NOT NULL DEFAULT '{}',
        synced INTEGER NOT NULL DEFAULT 0,
        synced_at INTEGER,
        sync_attempts INTEGER NOT NULL DEFAULT 0,
        sync_error TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_ledger_unsynced '
      'ON action_ledger(synced) WHERE synced = 0',
    );
    await db.execute(
      'CREATE INDEX idx_ledger_uid_type '
      'ON action_ledger(uid, type, started_at)',
    );

    // 习惯表
    await db.execute('''
      CREATE TABLE local_habits (
        id TEXT PRIMARY KEY,
        uid TEXT NOT NULL,
        name TEXT NOT NULL,
        target_hours INTEGER,
        goal_minutes INTEGER NOT NULL DEFAULT 25,
        reminders TEXT NOT NULL DEFAULT '[]',
        motivation_text TEXT,
        cat_id TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        total_minutes INTEGER NOT NULL DEFAULT 0,
        last_check_in_date TEXT,
        total_check_in_days INTEGER NOT NULL DEFAULT 0,
        deadline_date INTEGER,
        target_completed INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_habits_uid ON local_habits(uid, is_active)',
    );

    // 猫表
    await db.execute('''
      CREATE TABLE local_cats (
        id TEXT PRIMARY KEY,
        uid TEXT NOT NULL,
        name TEXT NOT NULL,
        personality TEXT NOT NULL,
        appearance TEXT NOT NULL,
        total_minutes INTEGER NOT NULL DEFAULT 0,
        equipped_accessory TEXT,
        bound_habit_id TEXT NOT NULL,
        state TEXT NOT NULL DEFAULT 'active',
        highest_stage TEXT,
        last_session_at INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_cats_uid ON local_cats(uid, state)');

    // 会话表
    await db.execute('''
      CREATE TABLE local_sessions (
        id TEXT PRIMARY KEY,
        uid TEXT NOT NULL,
        habit_id TEXT NOT NULL,
        cat_id TEXT NOT NULL,
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        target_duration_minutes INTEGER NOT NULL DEFAULT 0,
        paused_seconds INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL,
        completion_ratio REAL NOT NULL DEFAULT 1.0,
        xp_earned INTEGER NOT NULL DEFAULT 0,
        coins_earned INTEGER NOT NULL DEFAULT 0,
        mode TEXT NOT NULL,
        checksum TEXT,
        client_version TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_sessions_uid_habit '
      'ON local_sessions(uid, habit_id, started_at)',
    );
    await db.execute(
      'CREATE INDEX idx_sessions_date '
      'ON local_sessions(uid, started_at)',
    );

    // 月度签到表
    await db.execute('''
      CREATE TABLE local_monthly_checkins (
        uid TEXT NOT NULL,
        month TEXT NOT NULL,
        checked_days TEXT NOT NULL DEFAULT '[]',
        total_coins INTEGER NOT NULL DEFAULT 0,
        milestones_claimed TEXT NOT NULL DEFAULT '[]',
        PRIMARY KEY (uid, month)
      )
    ''');

    // 标量状态表（key-value 物化存储）
    await db.execute('''
      CREATE TABLE materialized_state (
        uid TEXT NOT NULL,
        key TEXT NOT NULL,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL,
        PRIMARY KEY (uid, key)
      )
    ''');

    // 本地成就表
    await db.execute('''
      CREATE TABLE local_achievements (
        id TEXT PRIMARY KEY,
        uid TEXT NOT NULL,
        unlocked_at INTEGER,
        reward_coins INTEGER NOT NULL DEFAULT 0,
        reward_claimed INTEGER NOT NULL DEFAULT 0,
        reward_claimed_at INTEGER,
        title_reward TEXT,
        trigger_action_id TEXT,
        context TEXT DEFAULT '{}'
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_achievements_uid '
      'ON local_achievements(uid, unlocked_at)',
    );
  }

  /// v3: 猫姿势偏好列（纯本地，不同步到 Firestore）。
  Future<void> _createV3Columns(Database db) async {
    await db.execute('ALTER TABLE local_cats ADD COLUMN display_pose INTEGER');
  }

  // ─── Diary CRUD ───

  /// 插入日记条目。如果当天已存在则忽略（UNIQUE 约束）。
  Future<bool> insertDiaryEntry(DiaryEntry entry) async {
    final db = await database;
    try {
      await db.insert(
        'diary_entries',
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return true;
    } catch (e, stack) {
      ErrorHandler.record(
        e,
        stackTrace: stack,
        source: 'LocalDatabaseService',
        operation: 'insertDiaryEntry',
      );
      return false;
    }
  }

  /// 获取指定猫猫的所有日记（按日期倒序）。
  Future<List<DiaryEntry>> getDiaryEntries(String catId) async {
    final db = await database;
    final maps = await db.query(
      'diary_entries',
      where: 'cat_id = ?',
      whereArgs: [catId],
      orderBy: 'date DESC',
    );
    return maps.map(DiaryEntry.fromMap).toList();
  }

  /// 获取指定猫猫当天的日记。
  Future<DiaryEntry?> getTodayDiary(String catId) async {
    final db = await database;
    final today = AppDateUtils.todayString();
    final maps = await db.query(
      'diary_entries',
      where: 'cat_id = ? AND date = ?',
      whereArgs: [catId, today],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return DiaryEntry.fromMap(maps.first);
  }

  // ─── Chat CRUD ───

  /// 插入聊天消息。
  Future<void> insertChatMessage(ChatMessage message) async {
    final db = await database;
    await db.insert('chat_messages', message.toMap());
  }

  /// 获取指定猫猫的最近聊天消息（按时间正序，限制条数）。
  Future<List<ChatMessage>> getRecentMessages(
    String catId, {
    int limit = 20,
  }) async {
    final db = await database;
    final maps = await db.query(
      'chat_messages',
      where: 'cat_id = ?',
      whereArgs: [catId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map(ChatMessage.fromMap).toList().reversed.toList();
  }

  /// 获取指定猫猫的所有聊天消息数量。
  Future<int> getChatMessageCount(String catId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM chat_messages WHERE cat_id = ?',
      [catId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// 删除指定猫猫的所有聊天记录。
  Future<void> clearChatHistory(String catId) async {
    final db = await database;
    await db.delete('chat_messages', where: 'cat_id = ?', whereArgs: [catId]);
  }

  /// 关闭数据库连接。
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
