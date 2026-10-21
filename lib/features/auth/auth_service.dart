import '../../core/config/supabase_config.dart';
import '../../core/models/models.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/sources/supabase_auth_data_source.dart';
import 'domain/entities/rivet_user.dart';
import 'domain/repositories/auth_repository.dart';

/// Servicio centralizado de autenticación para la UI de Rivet.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  AuthRepository? _repository;

  /// Permite inyectar un repositorio mock para tests.
  void setRepositoryForTesting(AuthRepository repository) {
    _repository = repository;
  }

  AuthRepository get _repo {
    return _repository ??= AuthRepositoryImpl(
      SupabaseAuthDataSource(SupabaseConfig.client),
    );
  }

  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) =>
      _repo.signIn(email: email, password: password);

  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) =>
      _repo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );

  Future<void> sendPasswordResetEmail(String email) =>
      _repo.sendPasswordResetEmail(email);

  Future<void> signOut() => _repo.signOut();

  Future<RivetUser?> getCurrentUser() => _repo.getCurrentUser();

  Stream<RivetUser?> get authStateChanges => _repo.authStateChanges;
}
