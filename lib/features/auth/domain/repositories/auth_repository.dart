import '../../../../core/models/models.dart';
import '../entities/rivet_user.dart';

/// Contrato del repositorio de autenticación y gestión de perfil.
abstract interface class AuthRepository {
  /// Registra un nuevo usuario con credenciales y datos de perfil.
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  });

  /// Inicia sesión con correo y contraseña.
  Future<RivetUser> signIn({
    required String email,
    required String password,
  });

  /// Envía un correo transaccional de recuperación de contraseña.
  Future<void> sendPasswordResetEmail(String email);

  /// Cierra la sesión activa.
  Future<void> signOut();

  /// Obtiene el usuario autenticado actualmente y su perfil.
  Future<RivetUser?> getCurrentUser();

  /// Flujo reactivo de cambios en el estado de autenticación.
  Stream<RivetUser?> get authStateChanges;
}
