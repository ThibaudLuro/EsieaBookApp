import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/views/widgets/book.dart';
import 'package:flutter/material.dart';
import 'book_search.dart';
import 'book_details.dart';
import '../../models/database_helper.dart';

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
    BookHelper bookHelper = await dbHelper.bookHelper;
    List<Map<String, dynamic>> loadedBooks = await bookHelper.getBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  void onTapBook(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetails(book: book, onUpdate: _loadBooks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma bibliothèque"),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          String coverUrl =
              'https://covers.openlibrary.org/b/id/${books[index]['coverId']}-M.jpg';

          return BookItem(
            book: books[index],
            coverUrl: coverUrl,
            onTap: () =>
                onTapBook(books[index]),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
