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

  RivetUser? _currentUser;

  /// Último usuario conocido de la sesión, disponible sin esperar a la red
  /// para que las pantallas no muestren datos de relleno mientras cargan.
  RivetUser? get currentUser => _currentUser;

  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async =>
      _currentUser = await _repo.signIn(email: email, password: password);

  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async =>
      _currentUser = await _repo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );

  Future<void> sendPasswordResetEmail(String email) =>
      _repo.sendPasswordResetEmail(email);

  Future<void> signOut() async {
    await _repo.signOut();
    _currentUser = null;
  }

  Future<RivetUser?> getCurrentUser() async =>
      _currentUser = await _repo.getCurrentUser();

  Stream<RivetUser?> get authStateChanges => _repo.authStateChanges;
}
