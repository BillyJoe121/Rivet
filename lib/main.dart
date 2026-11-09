import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/http_overrides.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/onboarding/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupHttpOverrides();
  await SupabaseConfig.initialize();
  runApp(const RivetApp());
}

/// Aplicación principal Rivet configurada con el tema global y tokens de marca.
class RivetApp extends StatelessWidget {
  const RivetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            AuthService.instance.getCurrentUserUseCase,
            AuthService.instance.signOutUseCase,
          )..add(const AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Rivet · Cotizaciones para tu obra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scrollBehavior: const RivetScrollBehavior(),
        home: const WelcomeScreen(),
      ),
    );
  }
}
