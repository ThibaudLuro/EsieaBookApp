import 'package:flutter/material.dart';
import '../../models/database_helper.dart';

class BookDetails extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback onUpdate;

  BookDetails({required this.book, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Title: ${book['title']}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Authors: ${book['authors']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DatabaseHelper dbHelper = DatabaseHelper();
                await dbHelper.deleteBook(book['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Livre supprimé de la bibliothèque!')));
                onUpdate();
                Navigator.pop(context);
              },
              child: Text('Supprimer le livre'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
