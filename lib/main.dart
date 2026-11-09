import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/http_overrides.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/projects_service.dart';
import 'features/proposals/presentation/bloc/proposals_bloc.dart';
import 'features/proposals/proposals_service.dart';
import 'features/supplier/catalog_service.dart';
import 'features/supplier/presentation/bloc/catalog_bloc.dart';

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
        BlocProvider<ProjectsBloc>(
          create: (_) => ProjectsBloc(
            ProjectsService.instance.getMyProjectsUseCase,
            ProjectsService.instance.createProjectUseCase,
            ProjectsService.instance.getProjectDetailUseCase,
          )..add(const LoadProjects()),
        ),
        BlocProvider<ProposalsBloc>(
          create: (_) => ProposalsBloc(
            ProposalsService.instance.getReceivedProposalsUseCase,
            ProposalsService.instance.acceptProposalUseCase,
          )..add(const LoadReceivedProposals()),
        ),
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc(
            CatalogService.instance.getCatalogMaterialsUseCase,
          )..add(const LoadCatalogProducts()),
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
