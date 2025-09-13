import 'package:flutter/material.dart';
import 'features/notes/data/models/note_model.dart';
import 'features/notes/data/repositories/note_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = NoteRepository();

  // Inserir uma nota de teste
  await repository.insertNote(
    NoteModel(
      title: 'Primeira Nota',
      content: 'Essa é minha primeira nota!',
      createdAt: DateTime.now(),
    ),
  );

  // Recuperar notas
  final notes = await repository.getNotes();
  for (var note in notes) {
    print('Nota: ${note.title} - ${note.content}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Notas App')),
        body: const Center(child: Text('SQLite configurados!')),
      ),
    );
  }
}
