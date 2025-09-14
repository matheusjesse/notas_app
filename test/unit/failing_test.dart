import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Teste que vai falhar propositalmente', () {
    test('Este teste sempre falha', () {
      // Teste que sempre vai falhar
      expect(2 + 2, equals(5)); // 2 + 2 nunca será 5
    });

    test('Este teste vai dar erro', () {
      // Teste que vai dar erro
      throw Exception('Erro proposital para testar CI');
    });
  });
}
