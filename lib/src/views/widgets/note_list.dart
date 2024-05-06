import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final Function(int) onDelete;
  final Function(int, String) onNoteTap;

  const NoteList({
    Key? key,
    required this.notes,
    required this.onDelete,
    required this.onNoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(notes[index]['id'].toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onDelete(notes[index]['id']);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            title: Text(notes[index]['content']),
            subtitle: Text(notes[index]['bookName'] ?? 'No book associated'),
            onTap: () => onNoteTap(notes[index]['id'], notes[index]['content']),
          ),
        );
      },
    );
  }
}
