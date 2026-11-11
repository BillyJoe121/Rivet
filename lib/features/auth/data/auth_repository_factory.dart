import '../../../core/config/supabase_config.dart';
import '../../../core/models/models.dart';
import '../domain/entities/rivet_user.dart';
import '../domain/repositories/auth_repository.dart';
import 'repositories/auth_repository_impl.dart';
import 'sources/supabase_auth_data_source.dart';

/// Arma el repositorio de autenticación que la raíz de la app inyecta.
///
/// Si Supabase no quedó inicializado (sin `.env`), usa un repositorio local
/// sin red para que la app siga abriendo.
AuthRepository createAuthRepository() {
  try {
    return AuthRepositoryImpl(SupabaseAuthDataSource(SupabaseConfig.client));
  } catch (_) {
    return const _OfflineAuthRepository();
  }
}

class _OfflineAuthRepository implements AuthRepository {
  const _OfflineAuthRepository();

  @override
  Stream<RivetUser?> get authStateChanges => const Stream.empty();

  @override
  Stream<void> get onPasswordRecovery => const Stream.empty();

  @override
  Future<RivetUser?> getCurrentUser() async => null;

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async => const RivetUser(
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
  }) async => RivetUser(
    id: 'mock-user',
    email: email,
    fullName: fullName,
    role: role,
    phone: phone,
  );
}
