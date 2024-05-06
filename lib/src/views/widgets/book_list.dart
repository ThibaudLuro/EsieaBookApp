import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final Function(Map<String, dynamic>) onTapBook;

  BookList({
    Key? key,
    required this.books,
    required this.onTapBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        String coverUrl =
            'https://covers.openlibrary.org/b/id/${books[index]['coverId']}-M.jpg';

        return InkWell(
          onTap: () => onTapBook(books[index]),
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(books[index]['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(books[index]['authors'], style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
