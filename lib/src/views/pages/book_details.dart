import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/note.dart';
import 'package:esiea_book_app/src/views/widgets/add_note_dialog.dart';
import 'package:esiea_book_app/src/views/widgets/book_rating.dart';
import 'package:flutter/material.dart';
import '../../models/database_helper.dart';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback onUpdate;

  BookDetails({required this.book, required this.onUpdate});

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
    notes = await noteHelper.getNotesForBook(widget.book['id']);
    setState(() {});
  }

  void _addNote() async {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        bookId: widget.book['id'],
        onNoteSaved: (note) async {
          NoteHelper noteHelper = await dbHelper.noteHelper;
          noteHelper.addNote(widget.book['id'], note);
          _noteController.clear();
          _loadNotes();
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
        bookId: widget.book['id'],
        initialNote: currentContent,
        onNoteSaved: (updatedNote) async {
          NoteHelper noteHelper = await dbHelper.noteHelper;
          noteHelper.updateNote(noteId, updatedNote);
          _loadNotes();
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
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note supprimée avec succès!')));
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
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notes[index]['id'].toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteNote(notes[index]['id']);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(notes[index]['content']),
                      onTap: () => _editNote(
                          notes[index]['id'], notes[index]['content']),
                    ),
                  );
                },
              ),
            ),
            const Text("Noter le livre:", style: TextStyle(fontSize: 18)),
            BookRating(
              bookId: widget.book['id'],
              initialRating: widget.book['rating']?.toDouble() ?? 0,
              onUpdate: () {
                widget.onUpdate();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Note mise à jour à ${widget.book['rating']} étoiles!')));
              },
            ),
            const SizedBox(height: 20),
            Container(
              width: double
                  .infinity,
              child: ElevatedButton(
                onPressed: _addNote,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5),
                  ),
                ),
                child: const Text('Ajouter une note'),
              ),
            ),
            SizedBox(
              width: double
                  .infinity,
              child: ElevatedButton(
                onPressed: () async {
                  BookHelper bookHelper = await dbHelper.bookHelper;
                  await bookHelper.deleteBook(widget.book['id']);
                  widget.onUpdate();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Livre supprimé de la bibliothèque!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5),
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
