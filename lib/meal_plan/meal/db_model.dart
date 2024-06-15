import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  static const String tableName = 'meal_foods';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'meal_foods.db');
    final db = await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          proteins INTEGER,
          calories INTEGER
        )
      ''');
    });
    return db;
  }

  Future<void> insertMealFood(String date, int proteins, int calories) async {
    final db = await database;
    await db.insert(tableName, {'date': date, 'proteins': proteins, 'calories': calories});
  }

  Future<List<Map<String, dynamic>>> getMealFoods() async {
    final db = await database;
    return db.query(tableName);
  }

  Future<void> deleteAllMealFoods() async {
    final db = await database;
    await db.delete(tableName);
  }
}
