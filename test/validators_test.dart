import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/utils/validators.dart';

void main() {
  group('Validators - Email', () {
    test('valida correos correctos', () {
      expect(Validators.email('usuario@ejemplo.com'), isNull);
      expect(Validators.email('cliente.obra@rivet.com.co'), isNull);
      expect(Validators.email('contratista+test@gmail.com'), isNull);
    });

    test('rechaza correos inválidos o vacíos', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('    '), isNotNull);
      expect(Validators.email('correo-sin-arroba.com'), isNotNull);
      expect(Validators.email('@sin-usuario.com'), isNotNull);
      expect(Validators.email('usuario@.com'), isNotNull);
    });
  });

  group('Validators - Password', () {
    test('acepta contraseñas robustas', () {
      expect(Validators.password('Rivet2026!'), isNull);
      expect(Validators.password('ObraSegura#123'), isNull);
      expect(Validators.password('Clave*9876A'), isNull);
    });

    test('rechaza contraseñas débiles', () {
      expect(Validators.password('1234567'), isNotNull); // menos de 8
      expect(Validators.password('solominusculas1!'), isNotNull); // sin mayúscula
      expect(Validators.password('SOLOMAYUSCULAS1!'), isNull); // tiene mayus, num y especial
      expect(Validators.password('SinNumeroNiEspecial'), isNotNull); // sin numero ni especial
      expect(Validators.password('ConNumero12345'), isNotNull); // sin especial
      expect(Validators.password('ConEspecial!@#'), isNotNull); // sin número
    });
  });

  group('Validators - Colombia Phone', () {
    test('acepta números colombianos de 10 dígitos iniciando en 3', () {
      expect(Validators.phone('3001234567'), isNull);
      expect(Validators.phone('3159876543'), isNull);
      expect(Validators.phone('+57 320 456 7890'), isNull);
      expect(Validators.phone('573101234567'), isNull);
    });

    test('rechaza números no válidos', () {
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('1234567890'), isNotNull); // no inicia en 3
      expect(Validators.phone('30012345'), isNotNull); // muy corto
      expect(Validators.phone('300123456789'), isNotNull); // muy largo
      expect(Validators.phone('abcdefghij'), isNotNull);
    });
  });
}
