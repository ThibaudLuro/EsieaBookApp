import 'package:esiea_book_app/src/models/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/database_helper.dart';

class BookSearch extends StatefulWidget {
  final VoidCallback onUpdate;

  BookSearch({required this.onUpdate});

  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchBooks(String query) async {
    if (query.length >= 2) {
      final String urlString =
          'https://openlibrary.org/search.json?title=${Uri.encodeComponent(query)}&limit=5';
      final response = await http.get(Uri.parse(urlString));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['docs'];
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        print('Failed to load search results.');
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rechercher un livre"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Rechercher...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchBooks(value);
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var book = _searchResults[index];
          return ListTile(
            title: Text(book['title']),
            subtitle: Text(book['author_name']?.join(', ') ?? 'Unknown Author'),
            onTap: () async {
              Map<String, dynamic> bookData = {
                'title': book['title'],
                'coverId': book['cover_i'],
                'authors': book['author_name']?.join(', ') ?? 'Unknown Author',
              };
              BookHelper bookHelper = await _dbHelper.bookHelper;
              await bookHelper.insertBook(bookData);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Livre ajouté à la bibliothèque!')));
              widget.onUpdate();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
