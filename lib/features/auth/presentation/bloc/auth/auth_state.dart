import '../../../domain/entities/rivet_user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

/// Estado del bloque de autenticación global.
class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.authenticated(RivetUser user)
      : this(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final RivetUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isLoading => status == AuthStatus.loading;
}

