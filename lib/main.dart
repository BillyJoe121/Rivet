import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/http_overrides.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_page_route.dart';
import 'core/widgets/keyboard_dismisser.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/projects_service.dart';
import 'features/proposals/presentation/bloc/proposals_bloc.dart';
import 'features/proposals/proposals_service.dart';
import 'features/supplier/catalog_service.dart';
import 'features/supplier/presentation/bloc/catalog_bloc.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupHttpOverrides();
  await SupabaseConfig.initialize();
  runApp(const RivetApp());
}

/// Aplicación principal Rivet configurada con el tema global y tokens de marca.
class RivetApp extends StatefulWidget {
  const RivetApp({super.key});

  @override
  State<RivetApp> createState() => _RivetAppState();
}

class _RivetAppState extends State<RivetApp> {
  StreamSubscription<void>? _recoverySubscription;

  @override
  void initState() {
    super.initState();
    _recoverySubscription = AuthService.instance.onPasswordRecovery.listen((_) {
      rootNavigatorKey.currentState?.push(
        RivetPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) return;
      const heroAssets = [
        ...AppHeroImages.all,
        'Fondos/Sala minimalista con plantas y luz suave.png',
      ];
      for (final asset in heroAssets) {
        precacheImage(
          ResizeImage(AssetImage(asset), width: 824),
          ctx,
          onError: (_, _) {},
        );
      }
      const catalogThumbs = [
        'Fondos/pro-pintura-rivet.jpg',
        'Fondos/pro-estuco-corona.jpg',
        'Fondos/pro-cinta-enmascarar.jpg',
      ];
      for (final thumb in catalogThumbs) {
        precacheImage(
          ResizeImage(AssetImage(thumb), width: 160),
          ctx,
          onError: (_, _) {},
        );
      }
    });
  }

  @override
  void dispose() {
    _recoverySubscription?.cancel();
    super.dispose();
  }

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
            ProjectsService.instance.updateProjectUseCase,
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
        navigatorKey: rootNavigatorKey,
        title: 'Rivet · Cotizaciones para tu obra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scrollBehavior: const RivetScrollBehavior(),
        builder: (context, child) =>
            KeyboardDismisser(child: child ?? const SizedBox.shrink()),
        home: const WelcomeScreen(),
      ),
    );
  }
}
