import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactsDB {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'contacts.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insert(String name, String phone) async {
    final dbClient = await db;
    return dbClient.insert('contacts', {
      'name': name,
      'phone': phone,
    });
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final dbClient = await db;
    return dbClient.query('contacts');
  }

  static Future<int> delete(int id) async {
    final dbClient = await db;
    return dbClient.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}