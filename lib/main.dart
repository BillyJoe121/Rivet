import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/http_overrides.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_page_route.dart';
import 'core/widgets/keyboard_dismisser.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/data/auth_repository_factory.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/usecases.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/agreements/agreements_module.dart';
import 'features/contractors/contractors_module.dart';
import 'features/messaging/messaging_module.dart';
import 'features/projects/data/project_repository_factory.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/usecases.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/wizard/data/local_project_draft_repository.dart';
import 'features/projects/wizard/domain/project_draft_repository.dart';
import 'features/proposals/data/proposal_repository_factory.dart';
import 'features/proposals/domain/repositories/proposal_repository.dart';
import 'features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'features/proposals/domain/usecases/get_received_proposals_usecase.dart';
import 'features/proposals/presentation/bloc/proposals_bloc.dart';
import 'features/supplier/data/catalog_repository_factory.dart';
import 'features/supplier/domain/repositories/catalog_repository.dart';
import 'features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'features/supplier/presentation/bloc/catalog_bloc.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupHttpOverrides();
  await SupabaseConfig.initialize();
  runApp(
    RivetApp(
      authRepository: createAuthRepository(),
      projectRepository: createProjectRepository(),
      proposalRepository: createProposalRepository(),
      catalogRepository: createCatalogRepository(),
      contractorRepository: LocalContractorRepository(),
      agreementRepository: LocalAgreementRepository(),
      messagingRepository: LocalMessagingRepository(),
      projectDraftRepository: LocalProjectDraftRepository(),
    ),
  );
}

/// Aplicación principal Rivet configurada con el tema global y tokens de marca.
///
/// Recibe los repositorios ya armados y los comparte por contexto; los que no
/// llegan se crean una sola vez al montar la app.
class RivetApp extends StatefulWidget {
  const RivetApp({
    super.key,
    required this.authRepository,
    this.projectRepository,
    this.proposalRepository,
    this.catalogRepository,
    this.contractorRepository,
    this.agreementRepository,
    this.messagingRepository,
    this.projectDraftRepository,
  });

  /// Repositorio de autenticación compartido por toda la app.
  final AuthRepository authRepository;
  final ProjectRepository? projectRepository;
  final ProposalRepository? proposalRepository;
  final CatalogRepository? catalogRepository;
  final ContractorRepository? contractorRepository;
  final AgreementRepository? agreementRepository;
  final MessagingRepository? messagingRepository;
  final ProjectDraftRepository? projectDraftRepository;

  @override
  State<RivetApp> createState() => _RivetAppState();
}

class _RivetAppState extends State<RivetApp> {
  StreamSubscription<void>? _recoverySubscription;

  late final ProjectRepository _projectRepository =
      widget.projectRepository ?? createProjectRepository();
  late final ProposalRepository _proposalRepository =
      widget.proposalRepository ?? createProposalRepository();
  late final CatalogRepository _catalogRepository =
      widget.catalogRepository ?? createCatalogRepository();
  late final ContractorRepository _contractorRepository =
      widget.contractorRepository ?? LocalContractorRepository();
  late final AgreementRepository _agreementRepository =
      widget.agreementRepository ?? LocalAgreementRepository();
  late final MessagingRepository _messagingRepository =
      widget.messagingRepository ?? LocalMessagingRepository();
  late final ProjectDraftRepository _projectDraftRepository =
      widget.projectDraftRepository ?? LocalProjectDraftRepository();

  @override
  void initState() {
    super.initState();
    _recoverySubscription = widget.authRepository.onPasswordRecovery.listen((_) {
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
    final authRepository = widget.authRepository;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ProjectRepository>.value(value: _projectRepository),
        RepositoryProvider<ProposalRepository>.value(
          value: _proposalRepository,
        ),
        RepositoryProvider<CatalogRepository>.value(value: _catalogRepository),
        RepositoryProvider<ContractorRepository>.value(
          value: _contractorRepository,
        ),
        RepositoryProvider<AgreementRepository>.value(
          value: _agreementRepository,
        ),
        RepositoryProvider<MessagingRepository>.value(
          value: _messagingRepository,
        ),
        RepositoryProvider<ProjectDraftRepository>.value(
          value: _projectDraftRepository,
        ),
      ],
      child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            GetCurrentUserUseCase(authRepository),
            SignOutUseCase(authRepository),
          )..add(const AuthCheckRequested()),
        ),
        BlocProvider<ProjectsBloc>(
          create: (_) => ProjectsBloc(
            GetMyProjectsUseCase(_projectRepository),
            CreateProjectUseCase(_projectRepository),
            GetProjectDetailUseCase(_projectRepository),
            UpdateProjectUseCase(_projectRepository),
          )..add(const LoadProjects()),
        ),
        BlocProvider<ProposalsBloc>(
          create: (_) => ProposalsBloc(
            GetReceivedProposalsUseCase(_proposalRepository),
            AcceptProposalUseCase(_proposalRepository),
          )..add(const LoadReceivedProposals()),
        ),
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc(
            GetCatalogMaterialsUseCase(_catalogRepository),
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
        home: const AuthGate(),
      ),
      ),
    );
  }
}
