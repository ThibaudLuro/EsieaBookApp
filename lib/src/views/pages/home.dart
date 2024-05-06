import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/note.dart';
import 'package:esiea_book_app/src/views/pages/book_details.dart';
import 'package:esiea_book_app/src/views/widgets/add_note_dialog.dart';
import 'package:flutter/material.dart';
import '../../models/database_helper.dart';

class HomePage extends StatefulWidget {
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
              SnackBar(content: Text('Note mise à jour avec succès!')));
        },
      ),
    );
  }

  void _deleteNote(int noteId) async {
    NoteHelper noteHelper = await dbHelper.noteHelper;
    await noteHelper.deleteNote(noteId);
    _loadLatestNotes();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Note supprimée avec succès!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[50],
        title: Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text('Dernières lectures',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown)),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: latestBooks.length,
                  itemBuilder: (context, index) {
                    String imageUrl =
                        'https://covers.openlibrary.org/b/id/${latestBooks[index]['coverId']}-L.jpg';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetails(
                              book: latestBooks[index],
                              onUpdate: _loadLatestBooks,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text(
                                    latestBooks[index]['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(150, 0, 0, 0),
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 8.0,
                                          color: Color.fromARGB(150, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    latestBooks[index]['authors'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(150, 0, 0, 0),
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 8.0,
                                          color: Color.fromARGB(150, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Dernières notes',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: latestNotes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(latestNotes[index]['id'].toString()),
                    background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white)),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteNote(latestNotes[index]['id']);
                    },
                    child: ListTile(
                      title: Text(latestNotes[index]['content']),
                      onTap: () => _editNote(latestNotes[index]['id'],
                          latestNotes[index]['content']),
                    ),
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
