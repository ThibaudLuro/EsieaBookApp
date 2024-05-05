import 'package:sqflite/sqflite.dart';

class NoteHelper {
  final Database _database;

  NoteHelper(this._database);

  Future<List<Map<String, dynamic>>> getNotes() async {
    final List<Map<String, dynamic>> notes = await _database.query('notes');
    return notes;
  }

  Future<List<Map<String, dynamic>>> getNotesForBook(String bookId) async {
    final List<Map<String, dynamic>> notes = await _database.query(
      'notes',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
    return notes;
  }

  Future<void> addNote(String bookId, String content) async {
    await _database.insert(
      'notes',
      {
        'bookId': bookId,
        'content': content,
      },
    );
  }

  Future<void> updateNote(int noteId, String content) async {
    await _database.update(
      'notes',
      {'content': content},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<void> deleteNote(int noteId) async {
    await _database.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }
}
