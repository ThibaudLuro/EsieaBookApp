import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/note.dart';
import 'package:esiea_book_app/src/views/widgets/add_note_dialog.dart';
import 'package:esiea_book_app/src/views/widgets/book_rating.dart';
import 'package:esiea_book_app/src/views/widgets/note.dart';
import 'package:flutter/material.dart';
import '../../models/database_helper.dart';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback onUpdate;
  final VoidCallback? onNoteUpdate;

  BookDetails({required this.book, required this.onUpdate, this.onNoteUpdate});

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  List<Map<String, dynamic>> notes = [];
  final TextEditingController _noteController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    notes = await noteHelper.getNotesForBook(widget.book['id'].toString());
    setState(() {});
  }

  void _addNote() async {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        bookId: widget.book['id'].toString(),
        onNoteSaved: (note) async {
          NoteHelper noteHelper = await dbHelper.noteHelper;
          noteHelper.addNote(widget.book['id'].toString(), note);
          _noteController.clear();
          _loadNotes();
          widget.onNoteUpdate?.call();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note ajoutée avec succès!')));
        },
      ),
    );
  }

  void _editNote(int noteId, String currentContent) {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        bookId: widget.book['id'].toString(),
        initialNote: currentContent,
        onNoteSaved: (updatedNote) async {
          NoteHelper noteHelper = await dbHelper.noteHelper;
          noteHelper.updateNote(noteId, updatedNote);
          _loadNotes();
          widget.onNoteUpdate?.call();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note mise à jour avec succès!')));
        },
      ),
    );
  }

  void _deleteNote(int noteId) async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    await noteHelper.deleteNote(noteId);
    _loadNotes();
    widget.onNoteUpdate?.call();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note supprimée avec succès!')));
  }

  void _deleteBook() async {
    BookHelper bookHelper = await dbHelper.bookHelper;
    await bookHelper.deleteBook(widget.book['id'].toString());
    widget.onUpdate();
    widget.onNoteUpdate?.call();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livre supprimé de la bibliothèque!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Titre: ${widget.book['title']}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Auteur: ${widget.book['authors']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Mes notes:", style: TextStyle(fontSize: 14)),
            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text("Aucune note pour le moment",
                          style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteItem(
                          note: notes[index],
                          onDelete: (int id) {
                            _deleteNote(id);
                          },
                          onTap: (int id, String content) {
                            _editNote(id, content);
                          },
                        );
                      },
                    ),
            ),
            const Text("Noter le livre:", style: TextStyle(fontSize: 18)),
            BookRating(
              bookId: widget.book['id'].toString(),
              initialRating: widget.book['rating']?.toDouble() ?? 0,
              onUpdate: () {
                widget.onUpdate();
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addNote,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Ajouter une note'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _deleteBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Supprimer le livre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
