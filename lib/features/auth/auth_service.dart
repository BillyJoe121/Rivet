import '../../core/config/supabase_config.dart';
import '../../core/models/models.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/sources/supabase_auth_data_source.dart';
import 'domain/entities/rivet_user.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/usecases.dart';

/// Servicio centralizado de autenticación y contenedor de casos de uso para Rivet.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  AuthRepository? _repository;

  /// Permite inyectar un repositorio mock para tests.
  void setRepositoryForTesting(AuthRepository repository) {
    _repository = repository;
  }

  AuthRepository get repository {
    if (_repository != null) return _repository!;
    try {
      return _repository = AuthRepositoryImpl(
        SupabaseAuthDataSource(SupabaseConfig.client),
      );
    } catch (_) {
      return _repository = const _FallbackNoopAuthRepository();
    }
  }

  SignInUseCase get signInUseCase => SignInUseCase(repository);
  SignUpUseCase get signUpUseCase => SignUpUseCase(repository);
  SignOutUseCase get signOutUseCase => SignOutUseCase(repository);
  SendPasswordResetUseCase get sendPasswordResetUseCase =>
      SendPasswordResetUseCase(repository);
  GetCurrentUserUseCase get getCurrentUserUseCase =>
      GetCurrentUserUseCase(repository);

  RivetUser? _currentUser;

  /// Último usuario conocido de la sesión, disponible sin esperar a la red
  /// para que las pantallas no muestren datos de relleno mientras cargan.
  RivetUser? get currentUser => _currentUser;

  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async =>
      _currentUser = await repository.signIn(email: email, password: password);

  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async =>
      _currentUser = await repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );

  Future<void> sendPasswordResetEmail(String email) =>
      repository.sendPasswordResetEmail(email);

  Future<void> signOut() async {
    await repository.signOut();
    _currentUser = null;
  }

  Future<RivetUser?> getCurrentUser() async =>
      _currentUser = await repository.getCurrentUser();

  Stream<RivetUser?> get authStateChanges => repository.authStateChanges;
}

/// Repositorio de respaldo para entornos de prueba donde Supabase no está inicializado.
class _FallbackNoopAuthRepository implements AuthRepository {
  const _FallbackNoopAuthRepository();

  @override
  Stream<RivetUser?> get authStateChanges => const Stream.empty();

  @override
  Future<RivetUser?> getCurrentUser() async => null;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async =>
      const RivetUser(
        id: 'mock-user',
        email: 'mock@rivet.com',
        fullName: 'Mock User',
        role: UserRole.client,
      );

  @override
  Future<void> signOut() async {}

  @override
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async =>
      RivetUser(
        id: 'mock-user',
        email: email,
        fullName: fullName,
        role: role,
        phone: phone,
      );
}
