import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'water.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Tạo bảng
  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS History (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       ml INTEGER,
       datetime TEXT,unit TEXT
      )
    """);
    await db.execute("""
      CREATE TABLE IF NOT EXISTS Reminder (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       title TEXT,
       datetime TEXT,
       isOn INTEGER
      )
    """);
  }

  // Chèn một bản ghi mới
  Future<int> insertHistory(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('History', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query('History');
  }

  Future<List<Map<String, dynamic>>> queryAllToDay() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final db = await database;
    return await db.query(
      'History',
      where: "datetime LIKE ?",
      whereArgs: ["$formattedDate%"],
    );
  }

  Future<List<Map<String, dynamic>>> queryByDay(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final db = await database;
    return await db.query(
      'History',
      where: "datetime LIKE ?",
      whereArgs: ["$formattedDate%"],
    );
  }

  Future<List<Map<String, dynamic>>> queryByMonth(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM').format(date);
    final db = await database;
    return await db.query(
      'History',
      where: "datetime LIKE ?",
      whereArgs: ["$formattedDate%"],
    );
  }

  Future<int> updateHistory(Map<String, dynamic> row) async {
    final db = await database;
    final id = row['id'];
    return await db.update('History', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete('History', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertReminder(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Reminder', row);
  }

  Future<List<Map<String, dynamic>>> queryAllReminders() async {
    final db = await database;
    return await db.query('Reminder');
  }

  Future<int> updateReminder(Map<String, dynamic> row) async {
    final db = await database;
    final id = row['id'];
    return await db.update('Reminder', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete('Reminder', where: 'id = ?', whereArgs: [id]);
  }
}
