import '../../../domain/entities/rivet_user.dart';

/// Eventos del bloque de autenticación global de la aplicación.
sealed class AuthEvent {
  const AuthEvent();
}

/// Verificación del estado de sesión al iniciar la aplicación.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Notificación reactiva de cambio en el usuario autenticado.
final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final RivetUser? user;
}

/// Solicitud de cierre de sesión global.
final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

