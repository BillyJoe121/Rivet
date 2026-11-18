import 'package:get_it/get_it.dart';

import 'features/agreements/agreements_module.dart';
import 'features/auth/data/auth_repository_factory.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/usecases.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/contractors/contractors_module.dart';
import 'features/home/contractor_home_bloc.dart';
import 'features/messaging/messaging_module.dart';
import 'features/projects/contractor/open_projects_bloc.dart';
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

/// Contenedor central de dependencias de la aplicación.
final GetIt sl = GetIt.instance;

/// Resuelve [T] desde [sl] cuando el contenedor está inicializado, o usa
/// [fallback] en entornos de prueba aislados.
T resolveBloc<T extends Object>(T Function() fallback) =>
    sl.isRegistered<T>() ? sl<T>() : fallback();

/// Registra repositorios, casos de uso y BLoCs de adentro hacia afuera.
///
/// Los parámetros opcionales permiten inyectar implementaciones en memoria en
/// pruebas automatizadas sin acoplar el grafo a Supabase.
Future<void> initDependencies({
  AuthRepository? authRepository,
  ProjectRepository? projectRepository,
  ProposalRepository? proposalRepository,
  CatalogRepository? catalogRepository,
  ContractorRepository? contractorRepository,
  AgreementRepository? agreementRepository,
  MessagingRepository? messagingRepository,
  ProjectDraftRepository? projectDraftRepository,
  bool reset = false,
}) async {
  if (reset) {
    await sl.reset();
  }
  if (sl.isRegistered<AuthRepository>()) {
    return;
  }

  // Repositorios (una única instancia compartida por toda la app)
  sl
    ..registerLazySingleton<AuthRepository>(
      () => authRepository ?? createAuthRepository(),
    )
    ..registerLazySingleton<ProjectRepository>(
      () => projectRepository ?? createProjectRepository(),
    )
    ..registerLazySingleton<ProposalRepository>(
      () => proposalRepository ?? createProposalRepository(),
    )
    ..registerLazySingleton<CatalogRepository>(
      () => catalogRepository ?? createCatalogRepository(),
    )
    ..registerLazySingleton<ContractorRepository>(
      () => contractorRepository ?? createContractorRepository(),
    )
    ..registerLazySingleton<AgreementRepository>(
      () => agreementRepository ?? createAgreementRepository(),
    )
    ..registerLazySingleton<MessagingRepository>(
      () => messagingRepository ?? createMessagingRepository(),
    )
    ..registerLazySingleton<ProjectDraftRepository>(
      () => projectDraftRepository ?? LocalProjectDraftRepository(),
    )
    // Casos de uso
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<GetMyProjectsUseCase>(
      () => GetMyProjectsUseCase(sl<ProjectRepository>()),
    )
    ..registerLazySingleton<GetOpenProjectsUseCase>(
      () => GetOpenProjectsUseCase(sl<ProjectRepository>()),
    )
    ..registerLazySingleton<GetProjectDetailUseCase>(
      () => GetProjectDetailUseCase(sl<ProjectRepository>()),
    )
    ..registerLazySingleton<CreateProjectUseCase>(
      () => CreateProjectUseCase(sl<ProjectRepository>()),
    )
    ..registerLazySingleton<UpdateProjectUseCase>(
      () => UpdateProjectUseCase(sl<ProjectRepository>()),
    )
    ..registerLazySingleton<GetReceivedProposalsUseCase>(
      () => GetReceivedProposalsUseCase(sl<ProposalRepository>()),
    )
    ..registerLazySingleton<AcceptProposalUseCase>(
      () => AcceptProposalUseCase(
        sl<ProposalRepository>(),
        sl<ProjectRepository>(),
      ),
    )
    ..registerLazySingleton<GetCatalogMaterialsUseCase>(
      () => GetCatalogMaterialsUseCase(sl<CatalogRepository>()),
    )
    ..registerLazySingleton<GetConversationsUseCase>(
      () => GetConversationsUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<SendChatMessageUseCase>(
      () => SendChatMessageUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<SendCounterOfferUseCase>(
      () => SendCounterOfferUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<RespondCounterOfferUseCase>(
      () => RespondCounterOfferUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<GetClientNotificationsUseCase>(
      () => GetClientNotificationsUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<MarkNotificationReadUseCase>(
      () => MarkNotificationReadUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<LoadOlderMessagesUseCase>(
      () => LoadOlderMessagesUseCase(sl<MessagingRepository>()),
    )
    // BLoCs (instancia nueva por pantalla o flujo)
    ..registerFactory<AuthBloc>(
      () => AuthBloc(sl<GetCurrentUserUseCase>(), sl<SignOutUseCase>()),
    )
    ..registerFactory<ProjectsBloc>(
      () => ProjectsBloc(
        sl<GetMyProjectsUseCase>(),
        sl<CreateProjectUseCase>(),
        sl<GetProjectDetailUseCase>(),
        sl<UpdateProjectUseCase>(),
      ),
    )
    ..registerFactory<ProposalsBloc>(
      () => ProposalsBloc(
        sl<GetReceivedProposalsUseCase>(),
        sl<AcceptProposalUseCase>(),
      ),
    )
    ..registerFactory<CatalogBloc>(
      () => CatalogBloc(sl<GetCatalogMaterialsUseCase>()),
    )
    ..registerFactory<ContractorsBloc>(
      () => ContractorsBloc.fromRepository(sl<ContractorRepository>()),
    )
    ..registerFactory<AgreementsBloc>(
      () => AgreementsBloc.fromRepository(sl<AgreementRepository>()),
    )
    ..registerFactory<ProgressBloc>(
      () => ProgressBloc.fromRepository(sl<AgreementRepository>()),
    )
    ..registerFactory<ClosureBloc>(
      () => ClosureBloc.fromRepository(sl<AgreementRepository>()),
    )
    ..registerFactory<PayoutAccountBloc>(
      () => PayoutAccountBloc.fromRepository(sl<AgreementRepository>()),
    )
    ..registerFactory<OpenProjectsBloc>(
      () => OpenProjectsBloc.fromRepository(sl<ProjectRepository>()),
    )
    ..registerFactory<ContractorHomeBloc>(
      () => ContractorHomeBloc.fromRepositories(
        sl<ProjectRepository>(),
        sl<ProposalRepository>(),
        agreementRepository: sl<AgreementRepository>(),
      ),
    )
    ..registerFactory<MessagingBloc>(
      () => MessagingBloc(
        sl<GetConversationsUseCase>(),
        sl<SendChatMessageUseCase>(),
        sl<SendCounterOfferUseCase>(),
        sl<RespondCounterOfferUseCase>(),
        sl<GetClientNotificationsUseCase>(),
        sl<MarkNotificationReadUseCase>(),
        sl<MessagingRepository>(),
        sl<LoadOlderMessagesUseCase>(),
      ),
    );
}
