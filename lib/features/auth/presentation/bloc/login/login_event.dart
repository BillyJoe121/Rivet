/// Eventos del bloque de inicio de sesión.
sealed class LoginEvent {
  const LoginEvent();
}

/// Envío de credenciales para autenticación.
final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

/// Descarta el mensaje de error activo en pantalla.
final class LoginErrorDismissed extends LoginEvent {
  const LoginErrorDismissed();
}

