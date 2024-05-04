import 'package:sqflite/sqflite.dart';

class BookHelper {
  final Database _database;

  BookHelper(this._database);

  Future<List<Map<String, dynamic>>> getBooks() async {
    final List<Map<String, dynamic>> books = await _database.query('books');
    return books;
  }

  Future<void> insertBook(Map<String, dynamic> book) async {
    await _database.insert('books', book,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateBookRating(String id, double rating) async {
    await _database.update(
      'books',
      {'rating': rating},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteBook(String id) async {
    await _database.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
