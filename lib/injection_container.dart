import 'package:get_it/get_it.dart';

import 'core/models/models.dart';
import 'features/agreements/agreements_module.dart';
import 'features/auth/data/auth_repository_factory.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/usecases.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'features/contractors/contractors_module.dart';
import 'features/home/client_home_bloc.dart';
import 'features/home/contractor_home_bloc.dart';
import 'features/messaging/messaging_module.dart';
import 'features/projects/contractor/open_projects_bloc.dart';
import 'features/projects/data/project_repository_factory.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/usecases.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/wizard/data/local_project_draft_repository.dart';
import 'features/projects/wizard/domain/add_material_to_draft_usecase.dart';
import 'features/projects/wizard/domain/estimate_materials_usecase.dart';
import 'features/projects/wizard/domain/project_draft_repository.dart';
import 'features/projects/wizard/domain/publish_project_wizard_usecase.dart';
import 'features/projects/wizard/presentation/bloc/project_wizard_bloc.dart';
import 'features/proposals/contractor/create_proposal_bloc.dart';
import 'features/proposals/contractor/my_proposals_bloc.dart';
import 'features/proposals/data/proposal_repository_factory.dart';
import 'features/proposals/domain/repositories/proposal_repository.dart';
import 'features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'features/proposals/domain/usecases/get_my_proposals_usecase.dart';
import 'features/proposals/domain/usecases/get_received_proposals_usecase.dart';
import 'features/proposals/domain/usecases/save_proposal_usecase.dart';
import 'features/proposals/domain/usecases/withdraw_proposal_usecase.dart';
import 'features/proposals/presentation/bloc/proposals_bloc.dart';
import 'features/supplier/data/catalog_repository_factory.dart';
import 'features/supplier/domain/repositories/catalog_repository.dart';
import 'features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'features/supplier/presentation/bloc/catalog_bloc.dart';

/// Contenedor central de dependencias de la aplicación.
final GetIt sl = GetIt.instance;

/// Configura repositorios, casos de uso y BLoCs de adentro hacia afuera.
///
/// Los parámetros opcionales permiten inyectar implementaciones en memoria en
/// pruebas automatizadas sin acoplar el grafo a Supabase. Con [allowOverride]
/// en `true`, reemplaza los repositorios indicados y reconstruye los registros
/// de casos de uso y BLoCs para evitar referencias obsoletas.
void configureDependencies({
  AuthRepository? authRepository,
  ProjectRepository? projectRepository,
  ProposalRepository? proposalRepository,
  CatalogRepository? catalogRepository,
  ContractorRepository? contractorRepository,
  AgreementRepository? agreementRepository,
  MessagingRepository? messagingRepository,
  ProjectDraftRepository? projectDraftRepository,
  bool allowOverride = false,
}) {
  if (!allowOverride && sl.isRegistered<AuthRepository>()) {
    return;
  }

  sl.allowReassignment = true;

  // Repositorios (una única instancia compartida por toda la app)
  if (authRepository != null || !sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => authRepository ?? createAuthRepository(),
    );
  }
  if (projectRepository != null || !sl.isRegistered<ProjectRepository>()) {
    sl.registerLazySingleton<ProjectRepository>(
      () => projectRepository ?? createProjectRepository(),
    );
  }
  if (proposalRepository != null || !sl.isRegistered<ProposalRepository>()) {
    sl.registerLazySingleton<ProposalRepository>(
      () => proposalRepository ?? createProposalRepository(),
    );
  }
  if (catalogRepository != null || !sl.isRegistered<CatalogRepository>()) {
    sl.registerLazySingleton<CatalogRepository>(
      () => catalogRepository ?? createCatalogRepository(),
    );
  }
  if (contractorRepository != null || !sl.isRegistered<ContractorRepository>()) {
    sl.registerLazySingleton<ContractorRepository>(
      () => contractorRepository ?? createContractorRepository(),
    );
  }
  if (agreementRepository != null || !sl.isRegistered<AgreementRepository>()) {
    sl.registerLazySingleton<AgreementRepository>(
      () => agreementRepository ?? createAgreementRepository(),
    );
  }
  if (messagingRepository != null || !sl.isRegistered<MessagingRepository>()) {
    sl.registerLazySingleton<MessagingRepository>(
      () => messagingRepository ?? createMessagingRepository(),
    );
  }
  if (projectDraftRepository != null ||
      !sl.isRegistered<ProjectDraftRepository>()) {
    sl.registerLazySingleton<ProjectDraftRepository>(
      () => projectDraftRepository ?? LocalProjectDraftRepository(),
    );
  }

  sl
    // Casos de uso
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<SendPasswordResetUseCase>(
      () => SendPasswordResetUseCase(sl<AuthRepository>()),
    )
    ..registerLazySingleton<UpdatePasswordUseCase>(
      () => UpdatePasswordUseCase(sl<AuthRepository>()),
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
    ..registerLazySingleton<EstimateMaterialsUseCase>(
      () => const EstimateMaterialsUseCase(),
    )
    ..registerLazySingleton<PublishProjectWizardUseCase>(
      () => PublishProjectWizardUseCase(
        createProjectUseCase: sl<CreateProjectUseCase>(),
        updateProjectUseCase: sl<UpdateProjectUseCase>(),
        draftRepository: sl<ProjectDraftRepository>(),
      ),
    )
    ..registerLazySingleton<AddMaterialToDraftUseCase>(
      () => AddMaterialToDraftUseCase(sl<ProjectDraftRepository>()),
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
    ..registerLazySingleton<GetMyProposalsUseCase>(
      () => GetMyProposalsUseCase(sl<ProposalRepository>()),
    )
    ..registerLazySingleton<SaveProposalUseCase>(
      () => SaveProposalUseCase(sl<ProposalRepository>()),
    )
    ..registerLazySingleton<WithdrawProposalUseCase>(
      () => WithdrawProposalUseCase(sl<ProposalRepository>()),
    )
    ..registerLazySingleton<GetCatalogMaterialsUseCase>(
      () => GetCatalogMaterialsUseCase(sl<CatalogRepository>()),
    )
    ..registerLazySingleton<GetContractorsUseCase>(
      () => GetContractorsUseCase(sl<ContractorRepository>()),
    )
    ..registerLazySingleton<RequestContractorVisitUseCase>(
      () => RequestContractorVisitUseCase(sl<ContractorRepository>()),
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
    ..registerLazySingleton<EnsureConversationUseCase>(
      () => EnsureConversationUseCase(sl<MessagingRepository>()),
    )
    ..registerLazySingleton<PrepareAgreementUseCase>(
      () => PrepareAgreementUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<AcceptAgreementUseCase>(
      () => AcceptAgreementUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<ProcessSimulatedPaymentUseCase>(
      () => ProcessSimulatedPaymentUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<ConfirmWorkCompletionUseCase>(
      () => ConfirmWorkCompletionUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<GetProgressUpdatesUseCase>(
      () => GetProgressUpdatesUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<ConfirmMilestoneUseCase>(
      () => ConfirmMilestoneUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<SubmitProgressUpdateUseCase>(
      () => SubmitProgressUpdateUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<SubmitRatingUseCase>(
      () => SubmitRatingUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<RequestCancellationUseCase>(
      () => RequestCancellationUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<ResolveCancellationUseCase>(
      () => ResolveCancellationUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<GetPayoutAccountUseCase>(
      () => GetPayoutAccountUseCase(sl<AgreementRepository>()),
    )
    ..registerLazySingleton<SavePayoutAccountUseCase>(
      () => SavePayoutAccountUseCase(sl<AgreementRepository>()),
    )
    // BLoCs (instancia nueva por pantalla o flujo)
    ..registerFactory<AuthBloc>(
      () => AuthBloc(sl<GetCurrentUserUseCase>(), sl<SignOutUseCase>()),
    )
    ..registerFactory<LoginBloc>(() => LoginBloc(sl<SignInUseCase>()))
    ..registerFactoryParam<SignUpBloc, UserRole, void>(
      (initialRole, _) =>
          SignUpBloc(sl<SignUpUseCase>(), initialRole: initialRole),
    )
    ..registerFactory<ForgotPasswordBloc>(
      () => ForgotPasswordBloc(sl<SendPasswordResetUseCase>()),
    )
    ..registerFactory<ResetPasswordBloc>(
      () => ResetPasswordBloc(sl<UpdatePasswordUseCase>()),
    )
    ..registerFactory<ClientHomeBloc>(
      () => ClientHomeBloc(
        sl<GetMyProjectsUseCase>(),
        sl<GetReceivedProposalsUseCase>(),
      ),
    )
    ..registerFactory<ProjectsBloc>(
      () => ProjectsBloc(
        sl<GetMyProjectsUseCase>(),
        sl<CreateProjectUseCase>(),
        sl<GetProjectDetailUseCase>(),
        sl<UpdateProjectUseCase>(),
      ),
    )
    ..registerFactory<ProjectWizardBloc>(
      () => ProjectWizardBloc(
        draftRepository: sl<ProjectDraftRepository>(),
        estimateMaterialsUseCase: sl<EstimateMaterialsUseCase>(),
        publishProjectWizardUseCase: sl<PublishProjectWizardUseCase>(),
      ),
    )
    ..registerFactory<ProposalsBloc>(
      () => ProposalsBloc(
        sl<GetReceivedProposalsUseCase>(),
        sl<AcceptProposalUseCase>(),
        sl<GetMyProjectsUseCase>(),
      ),
    )
    ..registerFactoryParam<CreateProposalBloc, String, Proposal?>(
      (projectId, initialProposal) => CreateProposalBloc(
        sl<SaveProposalUseCase>(),
        projectId: projectId,
        initialProposal: initialProposal,
      ),
    )
    ..registerFactoryParam<MyProposalsBloc, int, void>(
      (initialTab, _) => MyProposalsBloc(
        sl<GetMyProposalsUseCase>(),
        sl<GetOpenProjectsUseCase>(),
        sl<WithdrawProposalUseCase>(),
        initialTab: initialTab,
      ),
    )
    ..registerFactory<CatalogBloc>(
      () => CatalogBloc(sl<GetCatalogMaterialsUseCase>()),
    )
    ..registerFactory<ContractorsBloc>(
      () => ContractorsBloc(
        sl<GetContractorsUseCase>(),
        sl<RequestContractorVisitUseCase>(),
      ),
    )
    ..registerFactory<AgreementsBloc>(
      () => AgreementsBloc(
        sl<PrepareAgreementUseCase>(),
        sl<AcceptAgreementUseCase>(),
        sl<ProcessSimulatedPaymentUseCase>(),
        sl<ConfirmWorkCompletionUseCase>(),
        sl<AgreementRepository>(),
      ),
    )
    ..registerFactory<ProgressBloc>(
      () => ProgressBloc(
        sl<AgreementRepository>(),
        sl<GetProgressUpdatesUseCase>(),
        sl<ConfirmMilestoneUseCase>(),
        sl<SubmitProgressUpdateUseCase>(),
      ),
    )
    ..registerFactory<ClosureBloc>(
      () => ClosureBloc(
        sl<AgreementRepository>(),
        sl<SubmitRatingUseCase>(),
        sl<RequestCancellationUseCase>(),
        sl<ResolveCancellationUseCase>(),
      ),
    )
    ..registerFactory<PayoutAccountBloc>(
      () => PayoutAccountBloc(
        sl<GetPayoutAccountUseCase>(),
        sl<SavePayoutAccountUseCase>(),
      ),
    )
    ..registerFactory<OpenProjectsBloc>(
      () => OpenProjectsBloc(sl<GetOpenProjectsUseCase>()),
    )
    ..registerFactory<ContractorHomeBloc>(
      () => ContractorHomeBloc(
        sl<GetOpenProjectsUseCase>(),
        sl<GetMyProposalsUseCase>(),
        sl<ProjectRepository>(),
        sl<AgreementRepository>(),
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
        sl<EnsureConversationUseCase>(),
      ),
    );
}

/// Inicializa o reinicia el contenedor [sl] de forma asíncrona.
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
  configureDependencies(
    authRepository: authRepository,
    projectRepository: projectRepository,
    proposalRepository: proposalRepository,
    catalogRepository: catalogRepository,
    contractorRepository: contractorRepository,
    agreementRepository: agreementRepository,
    messagingRepository: messagingRepository,
    projectDraftRepository: projectDraftRepository,
    allowOverride: reset,
  );
}
