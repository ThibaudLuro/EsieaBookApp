import 'package:esiea_book_app/src/models/note.dart';
import 'package:esiea_book_app/src/views/widgets/add_note_dialog.dart';
import 'package:esiea_book_app/src/views/widgets/note.dart';
import 'package:flutter/material.dart';
import 'package:esiea_book_app/src/models/database_helper.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    List<Map<String, dynamic>> loadedNotes = await noteHelper
        .getNotesWithBookNames(); // Supposons que cette méthode existe
    setState(() {
      notes = loadedNotes;
    });
  }

  void _editNote(int noteId, String currentContent) {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
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
        title: const Text('Mes notes'),
      ),
      body: ListView.builder(
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
    );
  }
}
