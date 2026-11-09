/// Eventos del bloque de recuperación de contraseña.
sealed class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

/// Envío de solicitud de recuperación por correo.
final class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted(this.email);

  final String email;
}

/// Permite editar nuevamente el correo volviendo al formulario.
final class ForgotPasswordEditRequested extends ForgotPasswordEvent {
  const ForgotPasswordEditRequested();
}

/// Descarta cualquier mensaje de error activo.
final class ForgotPasswordErrorDismissed extends ForgotPasswordEvent {
  const ForgotPasswordErrorDismissed();
}

