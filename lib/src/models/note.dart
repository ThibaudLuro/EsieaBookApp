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

  Future<List<Map<String, dynamic>>> getNotesWithBookNames() async {
    const String sql = '''
      SELECT notes.id, notes.content, books.title AS bookName
      FROM notes
      JOIN books ON notes.bookId = books.id
   ''';
    final List<Map<String, dynamic>> notesWithBooks =
        await _database.rawQuery(sql);
    return notesWithBooks;
  }

  Future<List<Map<String, dynamic>>> getLatestNotes() async {
    const String sql = '''
      SELECT notes.id, notes.content, books.title AS bookName
      FROM notes
      JOIN books ON notes.bookId = books.id
      ORDER BY notes.id DESC
      LIMIT 5
   ''';
    final List<Map<String, dynamic>> notesWithBooks =
        await _database.rawQuery(sql);
    return notesWithBooks;
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
