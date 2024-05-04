import 'package:flutter/material.dart';
import 'book_search.dart';
import 'book_details.dart';
import '../../models/database_helper.dart'; // Assurez-vous d'importer votre classe helper

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> loadedBooks = await dbHelper.getBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma bibliothèque"),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index]['title']),
            subtitle: Text(books[index]['authors']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetails(
                    book: books[index],
                    onUpdate: _loadBooks,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookSearch(onUpdate: _loadBooks),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
