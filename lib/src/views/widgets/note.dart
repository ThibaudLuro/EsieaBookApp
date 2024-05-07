import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function(int) onDelete;
  final Function(int, String) onTap;

  const NoteItem({
    Key? key,
    required this.note,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete(note['id']);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(note['content']),
        subtitle: note['bookName'] != null ? Text(note['bookName']) : null,
        onTap: () => onTap(note['id'], note['content']),
      ),
    );
  }
}
