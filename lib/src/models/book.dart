class Book {
  final String id;
  final String title;
  final String author;
  final double? rating;
  final String? notes;

  Book({required this.id, required this.title, required this.author, this.rating, this.notes});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['key'],
      title: json['title'],
      author: json['author_name']?.join(", ") ?? "Unknown",
      rating: json['rating']?.toDouble(),
      notes: json['notes'] ?? '',
    );
  }
}
