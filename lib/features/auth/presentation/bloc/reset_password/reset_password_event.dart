/// Eventos del bloque de restablecimiento de contraseña.
sealed class ResetPasswordEvent {
  const ResetPasswordEvent();
}

/// Envío del formulario de nueva contraseña.
class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
  });

  final String password;
  final String confirmPassword;
}

/// Cierre manual o automático del mensaje de error.
class ResetPasswordErrorDismissed extends ResetPasswordEvent {
  const ResetPasswordErrorDismissed();
}

