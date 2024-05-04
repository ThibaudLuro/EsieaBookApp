import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/note.dart';
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
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE books(
        id TEXT PRIMARY KEY,
        title TEXT,
        authors TEXT,
        rating REAL
      );
    ''');
      await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId TEXT,
        content TEXT,
        FOREIGN KEY(bookId) REFERENCES books(id) ON DELETE CASCADE
      );
    ''');
    });
  }

  Future<BookHelper> get bookHelper async {
    final db = await database;
    return BookHelper(db);
  }

  Future<NoteHelper> get noteHelper async {
    final db = await database;
    return NoteHelper(db);
  }
}
