import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme.dart';
import '../home/app_shell.dart';
import '../onboarding/welcome_screen.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

/// Primera pantalla de la app: decide el destino según la sesión guardada.
///
/// Mientras [AuthBloc] verifica la sesión muestra un estado de carga; con
/// sesión abre el shell del rol del usuario y sin ella la bienvenida.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      // El cierre de sesión pasa por loading; no se reconstruye el shell.
      buildWhen: (_, current) => current.status != AuthStatus.loading,
      builder: (context, state) {
        final user = state.user;
        if (state.status == AuthStatus.authenticated && user != null) {
          return AppShell(key: ValueKey(user.id), initialRole: user.role);
        }
        if (state.status == AuthStatus.unauthenticated) {
          return const WelcomeScreen();
        }
        return const _SessionLoading();
      },
    );
  }
}

class _SessionLoading extends StatelessWidget {
  const _SessionLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.paper100,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.brand700,
          semanticsLabel: 'Cargando tu sesión',
        ),
      ),
    );
  }
}
