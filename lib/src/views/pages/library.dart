import 'package:esiea_book_app/src/models/book.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ma bibliothèque"),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          String coverUrl =
              'https://covers.openlibrary.org/b/id/${books[index]['coverId']}-M.jpg';

          return InkWell(
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
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    coverUrl,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(books[index]['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(books[index]['authors'],
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
