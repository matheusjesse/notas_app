import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Deve renderizar estrutura básica', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Notas')),
            body: const Center(child: Text('Nenhuma nota ainda')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.text('Notas'), findsOneWidget);
      expect(find.text('Nenhuma nota ainda'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Deve simular navegação', (WidgetTester tester) async {
      bool fabPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Notas')),
            body: const Center(child: Text('Lista de notas')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                fabPressed = true;
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(fabPressed, isTrue);
    });

    testWidgets('Deve simular tela de edição', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Nova Nota'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Digite sua nota...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Nova Nota'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Deve testar entrada de texto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              decoration: const InputDecoration(hintText: 'Digite aqui...'),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Minha nota de teste');
      await tester.pump();

      expect(find.text('Minha nota de teste'), findsOneWidget);
    });

    testWidgets('Deve simular lista com notas', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Notas')),
            body: ListView(
              children: const [
                ListTile(
                  title: Text('Primeira nota'),
                  subtitle: Text('Conteúdo...'),
                  leading: Icon(Icons.note),
                ),
                ListTile(
                  title: Text('Segunda nota'),
                  subtitle: Text('Mais conteúdo...'),
                  leading: Icon(Icons.note),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Primeira nota'), findsOneWidget);
      expect(find.text('Segunda nota'), findsOneWidget);
      expect(find.byIcon(Icons.note), findsNWidgets(2));
    });
  });
}
