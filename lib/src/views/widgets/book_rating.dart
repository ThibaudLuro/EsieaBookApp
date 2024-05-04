import 'package:esiea_book_app/src/models/book.dart';
import 'package:esiea_book_app/src/models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookRating extends StatelessWidget {
  final String bookId;
  final double initialRating;
  final VoidCallback onUpdate;
  
  BookRating({required this.bookId, required this.initialRating, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) async {
        DatabaseHelper databaseHelper = DatabaseHelper();
        BookHelper bookHelper = await databaseHelper.bookHelper;
        await bookHelper.updateBookRating(bookId, rating);
        onUpdate();
      },
    );
  }
}