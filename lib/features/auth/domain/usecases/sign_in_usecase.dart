import '../entities/rivet_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: Inicio de sesión con correo y contraseña.
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<RivetUser> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(
      email: email,
      password: password,
    );
  }
}

