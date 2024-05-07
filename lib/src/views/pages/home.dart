import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/note.dart';
import 'package:esiea_book_app/src/views/pages/book_details.dart';
import 'package:esiea_book_app/src/views/widgets/add_note_dialog.dart';
import 'package:esiea_book_app/src/views/widgets/book_card.dart';
import 'package:esiea_book_app/src/views/widgets/note.dart';
import 'package:flutter/material.dart';
import '../../models/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> latestBooks = [];
  List<Map<String, dynamic>> latestNotes = [];

  @override
  void initState() {
    super.initState();
    _loadLatestBooks();
    _loadLatestNotes();
  }

  void _navigateToBookDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetails(
          book: latestBooks[index],
          onUpdate: _loadLatestBooks,
          onNoteUpdate: _loadLatestNotes,
        ),
      ),
    );
  }

  void _loadLatestBooks() async {
    BookHelper bookHelper = await dbHelper.bookHelper;
    List<Map<String, dynamic>> books = await bookHelper.getLatestBooks();
    setState(() {
      latestBooks = books;
    });
  }

  void _loadLatestNotes() async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    List<Map<String, dynamic>> notes = await noteHelper.getLatestNotes();
    setState(() {
      latestNotes = notes;
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
          _loadLatestNotes();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note mise à jour avec succès!')));
        },
      ),
    );
  }

  void _deleteNote(int noteId) async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    await noteHelper.deleteNote(noteId);
    _loadLatestNotes();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note supprimée avec succès!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Dernières lectures',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown)),
              const SizedBox(height: 10),
              latestBooks.isEmpty
                  ? const Center(
                      child: Text('Aucun livre pour le moment',
                          style: TextStyle(fontSize: 16)))
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: latestBooks.length,
                        itemBuilder: (context, index) {
                          return BookCard(
                            title: latestBooks[index]['title'],
                            authors: latestBooks[index]['authors'],
                            imageUrl:
                                'https://covers.openlibrary.org/b/id/${latestBooks[index]['coverId']}-L.jpg',
                            onTap: () => _navigateToBookDetails(context, index),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
              const Text('Dernières notes',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown)),
              latestNotes.isEmpty
                  ? const Center(
                      child: Text('Aucune note pour le moment',
                          style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: latestNotes.length,
                      itemBuilder: (context, index) {
                        return NoteItem(
                          note: latestNotes[index],
                          onDelete: (int id) {
                            _deleteNote(id);
                          },
                          onTap: (int id, String content) {
                            _editNote(id, content);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}