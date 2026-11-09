import '../../../../core/models/models.dart';
import '../entities/rivet_user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: Registro de un nuevo usuario con credenciales y perfil de rol.
class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<RivetUser> call({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
      phone: phone,
    );
  }
}

