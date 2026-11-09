import '../../../../../core/models/models.dart';

/// Eventos del bloque de registro de usuario.
sealed class SignUpEvent {
  const SignUpEvent();
}

/// Cambio del rol seleccionado (cliente o contratista).
final class SignUpRoleChanged extends SignUpEvent {
  const SignUpRoleChanged(this.role);

  final UserRole role;
}

/// Envío del formulario de registro.
final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final UserRole role;
}

/// Descarta el error mostrado en pantalla.
final class SignUpErrorDismissed extends SignUpEvent {
  const SignUpErrorDismissed();
}

