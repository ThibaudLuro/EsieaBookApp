import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, authors TEXT);
      ''');
    });
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> books = await db.query('books');
    return books;
  }

  Future<void> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    await db.insert('books', book,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}