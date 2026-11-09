/// Error del dominio de autenticación con mensaje legible para el usuario.
class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

