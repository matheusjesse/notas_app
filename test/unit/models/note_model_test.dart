import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/features/notes/data/models/note_model.dart';

void main() {
  group('NoteModel Tests', () {
    // Dados de teste reutilizáveis
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(
        2024,
        1,
        15,
        10,
        30,
        0,
      ); // Data fixa para testes consistentes
    });

    group('Constructor Tests', () {
      test('Deve criar NoteModel com todos os campos', () {
        // Act
        final note = NoteModel(
          id: 1,
          title: 'Título de Teste',
          content: 'Conteúdo de teste',
          createdAt: testDateTime,
        );

        // Assert
        expect(note.id, equals(1));
        expect(note.title, equals('Título de Teste'));
        expect(note.content, equals('Conteúdo de teste'));
        expect(note.createdAt, equals(testDateTime));
      });

      test('Deve criar NoteModel sem ID (para inserção)', () {
        // Act
        final note = NoteModel(
          title: 'Nova Nota',
          content: 'Novo conteúdo',
          createdAt: testDateTime,
        );

        // Assert
        expect(note.id, isNull);
        expect(note.title, equals('Nova Nota'));
        expect(note.content, equals('Novo conteúdo'));
        expect(note.createdAt, equals(testDateTime));
      });
    });

    group('Serialization Tests', () {
      test('Deve converter NoteModel para Map corretamente', () {
        // Arrange
        final note = NoteModel(
          id: 1,
          title: 'Teste',
          content: 'Conteúdo',
          createdAt: testDateTime,
        );

        // Act
        final map = note.toMap();

        // Assert
        expect(map['id'], equals(1));
        expect(map['title'], equals('Teste'));
        expect(map['content'], equals('Conteúdo'));
        expect(map['createdAt'], equals(testDateTime.toIso8601String()));
        expect(map.keys.length, equals(4)); // Verifica se não há campos extras
      });

      test('Deve converter NoteModel sem ID para Map corretamente', () {
        // Arrange
        final note = NoteModel(
          title: 'Sem ID',
          content: 'Conteúdo sem ID',
          createdAt: testDateTime,
        );

        // Act
        final map = note.toMap();

        // Assert
        expect(map['id'], isNull);
        expect(map['title'], equals('Sem ID'));
        expect(map['content'], equals('Conteúdo sem ID'));
        expect(map['createdAt'], equals(testDateTime.toIso8601String()));
      });
    });

    group('Deserialization Tests', () {
      test('Deve criar NoteModel a partir de Map corretamente', () {
        // Arrange
        final map = {
          'id': 1,
          'title': 'Teste do Map',
          'content': 'Conteúdo do Map',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(map);

        // Assert
        expect(note.id, equals(1));
        expect(note.title, equals('Teste do Map'));
        expect(note.content, equals('Conteúdo do Map'));
        expect(note.createdAt, equals(testDateTime));
      });

      test('Deve criar NoteModel sem ID a partir de Map', () {
        // Arrange
        final map = {
          'title': 'Sem ID',
          'content': 'Conteúdo sem ID',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(map);

        // Assert
        expect(note.id, isNull);
        expect(note.title, equals('Sem ID'));
        expect(note.content, equals('Conteúdo sem ID'));
        expect(note.createdAt, equals(testDateTime));
      });

      test('Deve lidar com Map contendo campos extras', () {
        // Arrange
        final map = {
          'id': 1,
          'title': 'Teste',
          'content': 'Conteúdo',
          'createdAt': testDateTime.toIso8601String(),
          'extraField': 'valor extra', // Campo que não existe no modelo
        };

        // Act
        final note = NoteModel.fromMap(map);

        // Assert
        expect(note.id, equals(1));
        expect(note.title, equals('Teste'));
        expect(note.content, equals('Conteúdo'));
        expect(note.createdAt, equals(testDateTime));
        // O campo extra é ignorado sem problemas
      });
    });

    group('Edge Cases Tests', () {
      test('Deve lidar com strings vazias', () {
        // Act
        final note = NoteModel(title: '', content: '', createdAt: testDateTime);

        // Assert
        expect(note.title, equals(''));
        expect(note.content, equals(''));
        expect(note.createdAt, equals(testDateTime));
      });

      test('Deve lidar com strings com caracteres especiais', () {
        // Arrange
        const specialTitle = 'Título com àçêntos e émojis 🎉';
        const specialContent = 'Conteúdo\ncom\nquebras\tde\tlinha e "aspas"';

        // Act
        final note = NoteModel(
          id: 1,
          title: specialTitle,
          content: specialContent,
          createdAt: testDateTime,
        );

        // Assert
        expect(note.title, equals(specialTitle));
        expect(note.content, equals(specialContent));
      });

      test('Deve lidar com strings muito longas', () {
        // Arrange
        final longTitle = 'A' * 1000;
        final longContent = 'B' * 10000;

        // Act
        final note = NoteModel(
          id: 1,
          title: longTitle,
          content: longContent,
          createdAt: testDateTime,
        );

        // Assert
        expect(note.title, equals(longTitle));
        expect(note.content, equals(longContent));
        expect(note.title.length, equals(1000));
        expect(note.content.length, equals(10000));
      });

      test('Deve lidar com diferentes tipos de ID válidos', () {
        // Testa ID zero
        final noteZero = NoteModel(
          id: 0,
          title: 'Teste ID Zero',
          content: 'Conteúdo',
          createdAt: testDateTime,
        );
        expect(noteZero.id, equals(0));

        // Testa ID grande
        final noteBig = NoteModel(
          id: 999999,
          title: 'Teste ID Grande',
          content: 'Conteúdo',
          createdAt: testDateTime,
        );
        expect(noteBig.id, equals(999999));
      });
    });

    group('DateTime Handling Tests', () {
      test('Deve preservar precisão do DateTime na serialização', () {
        // Arrange
        final preciseDateTime = DateTime(2024, 1, 15, 10, 30, 45, 123, 456);
        final note = NoteModel(
          id: 1,
          title: 'Teste Precisão',
          content: 'Conteúdo',
          createdAt: preciseDateTime,
        );

        // Act
        final map = note.toMap();
        final reconstructedNote = NoteModel.fromMap(map);

        // Assert - DateTime.parse pode perder microssegundos, então testamos até milissegundos
        expect(
          reconstructedNote.createdAt.millisecondsSinceEpoch,
          equals(preciseDateTime.millisecondsSinceEpoch),
        );
      });

      test('Deve lidar com diferentes fusos horários', () {
        // Arrange - Cria DateTime em UTC
        final utcDateTime = DateTime.utc(2024, 1, 15, 10, 30, 0);
        final note = NoteModel(
          id: 1,
          title: 'Teste UTC',
          content: 'Conteúdo',
          createdAt: utcDateTime,
        );

        // Act
        final map = note.toMap();
        final reconstructedNote = NoteModel.fromMap(map);

        // Assert
        expect(reconstructedNote.createdAt, equals(utcDateTime));
        expect(
          map['createdAt'],
          contains('Z'),
        ); // String ISO deve ter indicador UTC
      });
    });

    group('Round-trip Tests', () {
      test('Conversão Map -> NoteModel -> Map deve ser consistente com ID', () {
        // Arrange
        final originalMap = {
          'id': 42,
          'title': 'Título Original',
          'content': 'Conteúdo Original',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(originalMap);
        final resultMap = note.toMap();

        // Assert
        expect(resultMap, equals(originalMap));
      });

      test('Conversão Map -> NoteModel -> Map deve ser consistente sem ID', () {
        // Arrange
        final originalMap = {
          'title': 'Título sem ID',
          'content': 'Conteúdo sem ID',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(originalMap);
        final resultMap = note.toMap();

        // Assert
        expect(resultMap['id'], isNull);
        expect(resultMap['title'], equals(originalMap['title']));
        expect(resultMap['content'], equals(originalMap['content']));
        expect(resultMap['createdAt'], equals(originalMap['createdAt']));
      });

      test('Múltiplas conversões devem manter consistência', () {
        // Arrange
        final originalNote = NoteModel(
          id: 123,
          title: 'Teste Múltiplo',
          content: 'Conteúdo múltiplo',
          createdAt: testDateTime,
        );

        // Act - Faz várias conversões
        final map1 = originalNote.toMap();
        final note1 = NoteModel.fromMap(map1);
        final map2 = note1.toMap();
        final note2 = NoteModel.fromMap(map2);
        final finalMap = note2.toMap();

        // Assert
        expect(finalMap, equals(map1));
        expect(note2.id, equals(originalNote.id));
        expect(note2.title, equals(originalNote.title));
        expect(note2.content, equals(originalNote.content));
        expect(note2.createdAt, equals(originalNote.createdAt));
      });
    });

    group('Error Handling Tests', () {
      test('Deve lançar exceção quando title está ausente', () {
        // Arrange
        final invalidMap = {
          'id': 1,
          'content': 'Conteúdo',
          'createdAt': testDateTime.toIso8601String(),
          // title ausente
        };

        // Act & Assert
        expect(
          () => NoteModel.fromMap(invalidMap),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('Deve lançar exceção quando content está ausente', () {
        // Arrange
        final invalidMap = {
          'id': 1,
          'title': 'Título',
          'createdAt': testDateTime.toIso8601String(),
          // content ausente
        };

        // Act & Assert
        expect(
          () => NoteModel.fromMap(invalidMap),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('Deve lançar exceção quando createdAt está ausente', () {
        // Arrange
        final invalidMap = {
          'id': 1,
          'title': 'Título',
          'content': 'Conteúdo',
          // createdAt ausente
        };

        // Act & Assert
        expect(
          () => NoteModel.fromMap(invalidMap),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'Deve lançar exceção com mensagem específica para title ausente',
        () {
          // Arrange
          final invalidMap = {
            'id': 1,
            'content': 'Conteúdo',
            'createdAt': testDateTime.toIso8601String(),
          };

          // Act & Assert
          expect(
            () => NoteModel.fromMap(invalidMap),
            throwsA(
              predicate(
                (e) =>
                    e is ArgumentError &&
                    e.message == 'Campo title é obrigatório',
              ),
            ),
          );
        },
      );

      test(
        'Deve lançar exceção com mensagem específica para content ausente',
        () {
          // Arrange
          final invalidMap = {
            'id': 1,
            'title': 'Título',
            'createdAt': testDateTime.toIso8601String(),
          };

          // Act & Assert
          expect(
            () => NoteModel.fromMap(invalidMap),
            throwsA(
              predicate(
                (e) =>
                    e is ArgumentError &&
                    e.message == 'Campo content é obrigatório',
              ),
            ),
          );
        },
      );

      test(
        'Deve lançar exceção com mensagem específica para createdAt ausente',
        () {
          // Arrange
          final invalidMap = {
            'id': 1,
            'title': 'Título',
            'content': 'Conteúdo',
          };

          // Act & Assert
          expect(
            () => NoteModel.fromMap(invalidMap),
            throwsA(
              predicate(
                (e) =>
                    e is ArgumentError &&
                    e.message == 'Campo createdAt é obrigatório',
              ),
            ),
          );
        },
      );

      test('Deve lançar exceção com formato de data inválido', () {
        // Arrange
        final invalidMap = {
          'id': 1,
          'title': 'Título',
          'content': 'Conteúdo',
          'createdAt': 'data-inválida',
        };

        // Act & Assert
        expect(
          () => NoteModel.fromMap(invalidMap),
          throwsA(isA<FormatException>()),
        );
      });

      test('Deve aceitar null como ID válido', () {
        // Arrange
        final mapWithNullId = {
          'id': null,
          'title': 'Título',
          'content': 'Conteúdo',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(mapWithNullId);

        // Assert
        expect(note.id, isNull);
        expect(note.title, equals('Título'));
        expect(note.content, equals('Conteúdo'));
      });

      test('Deve aceitar Map vazio exceto campos obrigatórios', () {
        // Arrange
        final minimalMap = {
          'title': 'Mínimo',
          'content': 'Conteúdo mínimo',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(minimalMap);

        // Assert
        expect(note.id, isNull);
        expect(note.title, equals('Mínimo'));
        expect(note.content, equals('Conteúdo mínimo'));
        expect(note.createdAt, equals(testDateTime));
      });
    });

    group('Type Safety Tests', () {
      test('Deve aceitar diferentes tipos numéricos para ID', () {
        // Testa int
        final mapWithInt = {
          'id': 42,
          'title': 'Int ID',
          'content': 'Conteúdo',
          'createdAt': testDateTime.toIso8601String(),
        };

        final noteInt = NoteModel.fromMap(mapWithInt);
        expect(noteInt.id, equals(42));
        expect(noteInt.id, isA<int>());
      });

      test('Campos String devem aceitar qualquer string válida', () {
        // Arrange
        final specialChars = {
          'id': 1,
          'title': '🔥 Special Title with émojis and àccents! @#\$%^&*()',
          'content': '''Multi-line content
          with tabs\t\tand newlines
          and "quotes" and 'apostrophes'
          and unicode: 🎉🚀💻''',
          'createdAt': testDateTime.toIso8601String(),
        };

        // Act
        final note = NoteModel.fromMap(specialChars);

        // Assert
        expect(
          note.title,
          equals('🔥 Special Title with émojis and àccents! @#\$%^&*()'),
        );
        expect(note.content, contains('Multi-line'));
        expect(note.content, contains('🎉🚀💻'));
      });
    });
  });
}
