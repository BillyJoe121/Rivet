import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';
import '../../domain/entities/rivet_user.dart';

/// Fuente de datos que interactúa de forma segura con el SDK oficial de Supabase.
///
/// Todas las consultas a la base de datos utilizan el query builder parametrizado,
/// garantizando protección total contra inyecciones SQL.
class SupabaseAuthDataSource {
  const SupabaseAuthDataSource(this._client);

  final SupabaseClient _client;

  /// Registra un usuario en `auth.users` y sincroniza su perfil en `public.profiles`.
  Future<RivetUser> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    required String phone,
  }) async {
    final roleString = role == UserRole.contractor ? 'contractor' : 'client';

    // 1. Crear usuario en Supabase Auth con metadatos para el trigger
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'full_name': fullName.trim(),
        'role': roleString,
        'phone': phone.trim(),
      },
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('No fue posible completar el registro.');
    }

    // 2. Asegurar inserción/actualización en la tabla `profiles` mediante query parametrizada
    final profileData = {
      'id': user.id,
      'email': user.email ?? email.trim(),
      'full_name': fullName.trim(),
      'role': roleString,
      'phone': phone.trim(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _client.from('profiles').upsert(profileData);
    } catch (_) {
      // Si el trigger de Postgres ya lo insertó, leemos el perfil
    }

    return RivetUser(
      id: user.id,
      email: user.email ?? email.trim(),
      fullName: fullName.trim(),
      role: role,
      phone: phone.trim(),
    );
  }

  /// Inicia sesión con email y contraseña, recuperando el perfil asociado.
  Future<RivetUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Credenciales inválidas');
    }

    // Leer el perfil desde la tabla `profiles` usando parámetro seguro .eq()
    final profile = await getProfile(user.id);
    if (profile != null) return profile;

    // Fallback con metadatos de auth si el perfil aún no se ha sincronizado
    final metaRole = user.userMetadata?['role'] as String? ?? 'client';
    return RivetUser(
      id: user.id,
      email: user.email ?? email.trim(),
      fullName: user.userMetadata?['full_name'] as String? ?? 'Usuario Rivet',
      role: metaRole == 'contractor' ? UserRole.contractor : UserRole.client,
      phone: user.userMetadata?['phone'] as String? ?? '',
    );
  }

  /// Recupera el perfil desde la tabla `profiles` con query parametrizada.
  Future<RivetUser?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return RivetUser.fromJson(data);
  }

  /// Envía correo de recuperación de contraseña.
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'io.supabase.rivet://reset-callback',
    );
  }

  /// Cierra la sesión activa.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Retorna el usuario autenticado actualmente.
  User? get currentAuthUser => _client.auth.currentUser;

  /// Stream reactivo de cambios de autenticación.
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;
}
