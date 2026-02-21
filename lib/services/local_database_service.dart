import 'package:hachimi_app/core/utils/error_handler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hachimi_app/core/utils/date_utils.dart';
import 'package:hachimi_app/models/diary_entry.dart';
import 'package:hachimi_app/models/chat_message.dart';

/// 本地 SQLite 数据库服务。
/// 管理 AI 日记和聊天数据的持久化存储。
class LocalDatabaseService {
  static const _dbName = 'hachimi_local.db';
  static const _dbVersion = 1;

  Database? _db;

  /// 获取数据库实例（懒初始化）。
  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
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
