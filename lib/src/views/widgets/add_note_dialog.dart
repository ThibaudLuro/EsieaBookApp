import 'package:flutter/material.dart';

class AddNoteDialog extends StatelessWidget {
  final String bookId;
  final Function(String) onNoteSaved;
  final String? initialNote;
  final TextEditingController _noteController;

  AddNoteDialog({
    required this.bookId,
    required this.onNoteSaved,
    this.initialNote,
  }) : _noteController = TextEditingController(text: initialNote);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(initialNote == null ? 'Ajouter une note' : 'Modifier la note'),
      content: TextField(
        controller: _noteController,
        decoration: InputDecoration(hintText: "Écrivez votre note ici"),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Enregistrer'),
          onPressed: () {
            if (_noteController.text.isNotEmpty) {
              onNoteSaved(_noteController.text);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
