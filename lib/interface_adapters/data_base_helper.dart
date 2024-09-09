import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'calendar.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            location TEXT,
            eventDate TEXT,
            eventTime TEXT,
            color TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db!.insert('events', event);
  }

  Future<List<Map<String, dynamic>>> getEventsForDate(String date) async {
    final db = await database;
    return await db!.query('events', where: 'eventDate = ?', whereArgs: [date]);
  }

  Future<int> updateEvent(int id, Map<String, dynamic> event) async {
    final db = await database;
    return await db!.update('events', event, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db!.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
