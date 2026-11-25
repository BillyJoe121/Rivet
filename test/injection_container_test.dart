import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/usecases.dart';
import 'package:rivet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:rivet/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:rivet/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:rivet/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:rivet/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:rivet/features/contractors/contractors_module.dart';
import 'package:rivet/features/home/client_home_bloc.dart';
import 'package:rivet/features/home/contractor_home_bloc.dart';
import 'package:rivet/features/messaging/messaging_module.dart';
import 'package:rivet/features/projects/contractor/open_projects_bloc.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/domain/usecases/usecases.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/wizard/domain/add_material_to_draft_usecase.dart';
import 'package:rivet/features/projects/wizard/domain/estimate_materials_usecase.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft_repository.dart';
import 'package:rivet/features/projects/wizard/domain/publish_project_wizard_usecase.dart';
import 'package:rivet/features/projects/wizard/presentation/bloc/project_wizard_bloc.dart';
import 'package:rivet/features/proposals/contractor/create_proposal_bloc.dart';
import 'package:rivet/features/proposals/contractor/my_proposals_bloc.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'package:rivet/features/proposals/domain/usecases/get_my_proposals_usecase.dart';
import 'package:rivet/features/proposals/domain/usecases/save_proposal_usecase.dart';
import 'package:rivet/features/proposals/domain/usecases/withdraw_proposal_usecase.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';
import 'package:rivet/features/supplier/domain/repositories/catalog_repository.dart';
import 'package:rivet/features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';
import 'package:rivet/injection_container.dart';

void main() {
  tearDown(() async {
    await sl.reset();
  });

  test(
    'initDependencies registra singletons de repositorios/casos de uso y factories de los 20 BLoCs',
    () async {
      await initDependencies(reset: true);

      expect(identical(sl<AuthRepository>(), sl<AuthRepository>()), isTrue);
      expect(
        identical(sl<ProjectRepository>(), sl<ProjectRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ProposalRepository>(), sl<ProposalRepository>()),
        isTrue,
      );
      expect(
        identical(sl<CatalogRepository>(), sl<CatalogRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ContractorRepository>(), sl<ContractorRepository>()),
        isTrue,
      );
      expect(
        identical(sl<AgreementRepository>(), sl<AgreementRepository>()),
        isTrue,
      );
      expect(
        identical(sl<MessagingRepository>(), sl<MessagingRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ProjectDraftRepository>(), sl<ProjectDraftRepository>()),
        isTrue,
      );

      expect(
        identical(sl<GetCurrentUserUseCase>(), sl<GetCurrentUserUseCase>()),
        isTrue,
      );
      expect(identical(sl<SignInUseCase>(), sl<SignInUseCase>()), isTrue);
      expect(identical(sl<SignUpUseCase>(), sl<SignUpUseCase>()), isTrue);
      expect(
        identical(
          sl<SendPasswordResetUseCase>(),
          sl<SendPasswordResetUseCase>(),
        ),
        isTrue,
      );
      expect(
        identical(sl<UpdatePasswordUseCase>(), sl<UpdatePasswordUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<GetMyProjectsUseCase>(), sl<GetMyProjectsUseCase>()),
        isTrue,
      );
      expect(
        identical(
          sl<EstimateMaterialsUseCase>(),
          sl<EstimateMaterialsUseCase>(),
        ),
        isTrue,
      );
      expect(
        identical(
          sl<PublishProjectWizardUseCase>(),
          sl<PublishProjectWizardUseCase>(),
        ),
        isTrue,
      );
      expect(
        identical(
          sl<AddMaterialToDraftUseCase>(),
          sl<AddMaterialToDraftUseCase>(),
        ),
        isTrue,
      );
      expect(
        identical(
          sl<LoadOlderMessagesUseCase>(),
          sl<LoadOlderMessagesUseCase>(),
        ),
        isTrue,
      );
      expect(
        identical(sl<AcceptProposalUseCase>(), sl<AcceptProposalUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<GetMyProposalsUseCase>(), sl<GetMyProposalsUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<SaveProposalUseCase>(), sl<SaveProposalUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<WithdrawProposalUseCase>(), sl<WithdrawProposalUseCase>()),
        isTrue,
      );
      expect(
        identical(
          sl<GetCatalogMaterialsUseCase>(),
          sl<GetCatalogMaterialsUseCase>(),
        ),
        isTrue,
      );

      final authBloc1 = sl<AuthBloc>();
      final authBloc2 = sl<AuthBloc>();
      final loginBloc = sl<LoginBloc>();
      final signUpBloc = sl<SignUpBloc>(param1: UserRole.contractor);
      final forgotBloc = sl<ForgotPasswordBloc>();
      final resetBloc = sl<ResetPasswordBloc>();
      final clientHomeBloc = sl<ClientHomeBloc>();
      final projectsBloc1 = sl<ProjectsBloc>();
      final projectsBloc2 = sl<ProjectsBloc>();
      final wizardBloc = sl<ProjectWizardBloc>();
      final proposalsBloc = sl<ProposalsBloc>();
      final createProposalBloc = sl<CreateProposalBloc>(
        param1: 'proj-1',
        param2: null,
      );
      final myProposalsBloc = sl<MyProposalsBloc>(param1: 1);
      final catalogBloc = sl<CatalogBloc>();
      final contractorsBloc = sl<ContractorsBloc>();
      final agreementsBloc = sl<AgreementsBloc>();
      final progressBloc = sl<ProgressBloc>();
      final closureBloc = sl<ClosureBloc>();
      final payoutBloc = sl<PayoutAccountBloc>();
      final openProjectsBloc = sl<OpenProjectsBloc>();
      final contractorHomeBloc = sl<ContractorHomeBloc>();
      final messagingBloc = sl<MessagingBloc>();

      expect(identical(authBloc1, authBloc2), isFalse);
      expect(identical(projectsBloc1, projectsBloc2), isFalse);
      expect(signUpBloc.state.role, UserRole.contractor);
      expect(createProposalBloc.state.projectId, 'proj-1');
      expect(myProposalsBloc.state.tabIndex, 1);
      expect(catalogBloc, isA<CatalogBloc>());
      expect(
        identical(sl<GetContractorsUseCase>(), sl<GetContractorsUseCase>()),
        isTrue,
      );
      expect(
        identical(
          sl<RequestContractorVisitUseCase>(),
          sl<RequestContractorVisitUseCase>(),
        ),
        isTrue,
      );

      for (final bloc in [
        authBloc1,
        authBloc2,
        loginBloc,
        signUpBloc,
        forgotBloc,
        resetBloc,
        clientHomeBloc,
        projectsBloc1,
        projectsBloc2,
        wizardBloc,
        proposalsBloc,
        createProposalBloc,
        myProposalsBloc,
        catalogBloc,
        contractorsBloc,
        agreementsBloc,
        progressBloc,
        closureBloc,
        payoutBloc,
        openProjectsBloc,
        contractorHomeBloc,
        messagingBloc,
      ]) {
        await bloc.close();
      }
    },
  );

  test('ningún archivo de domain/ importa archivos de data/', () {
    final featuresDir = Directory('lib/features');
    final violations = <String>[];
    for (final entity in featuresDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/domain/')) continue;
      final content = entity.readAsStringSync();
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('import ') && trimmed.contains('data/')) {
          violations.add('$normalized: $trimmed');
        }
      }
    }
    expect(violations, isEmpty);
  });
}
