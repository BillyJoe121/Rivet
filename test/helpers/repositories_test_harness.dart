import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/contractors/contractors_module.dart';
import 'package:rivet/features/messaging/messaging_module.dart';
import 'package:rivet/features/projects/data/repositories/project_repository_impl.dart';
import 'package:rivet/features/projects/data/sources/supabase_project_data_source.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/domain/usecases/usecases.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/wizard/data/local_project_draft_repository.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft_repository.dart';
import 'package:rivet/features/proposals/data/repositories/proposal_repository_impl.dart';
import 'package:rivet/features/proposals/data/sources/supabase_proposal_data_source.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'package:rivet/features/proposals/domain/usecases/get_received_proposals_usecase.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';
import 'package:rivet/features/supplier/data/repositories/catalog_repository_impl.dart';
import 'package:rivet/features/supplier/data/sources/supabase_catalog_data_source.dart';
import 'package:rivet/features/supplier/domain/repositories/catalog_repository.dart';
import 'package:rivet/features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';

import 'auth_test_harness.dart';

/// Envuelve [child] con los mismos repositorios que la raíz de la app
/// inyecta, todos en memoria (sin cliente de Supabase).
///
/// Cada parámetro reemplaza el repositorio por defecto de ese módulo. También
/// incluye el repositorio de autenticación y el `AuthBloc` mediante
/// [withAuth].
Widget withRepositories(
  Widget child, {
  AuthRepository? auth,
  ProjectRepository? projects,
  ProposalRepository? proposals,
  CatalogRepository? catalog,
  ContractorRepository? contractors,
  AgreementRepository? agreements,
  MessagingRepository? messaging,
  ProjectDraftRepository? drafts,
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ProjectRepository>.value(
        value:
            projects ?? ProjectRepositoryImpl(SupabaseProjectDataSource(null)),
      ),
      RepositoryProvider<ProposalRepository>.value(
        value:
            proposals ??
            ProposalRepositoryImpl(SupabaseProposalDataSource(null)),
      ),
      RepositoryProvider<CatalogRepository>.value(
        value:
            catalog ?? CatalogRepositoryImpl(SupabaseCatalogDataSource(null)),
      ),
      RepositoryProvider<ContractorRepository>.value(
        value: contractors ?? LocalContractorRepository(),
      ),
      RepositoryProvider<AgreementRepository>.value(
        value: agreements ?? LocalAgreementRepository(),
      ),
      RepositoryProvider<MessagingRepository>.value(
        value: messaging ?? LocalMessagingRepository(),
      ),
      RepositoryProvider<ProjectDraftRepository>.value(
        value: drafts ?? LocalProjectDraftRepository(),
      ),
    ],
    child: withAuth(child, repository: auth),
  );
}

/// Arma los Bloc compartidos de la raíz (proyectos, propuestas y Bodega) con
/// los repositorios del contexto; va dentro de [withRepositories].
///
/// Con [load] en `true` cada Bloc pide sus datos al crearse, como en la app.
Widget withAppBlocs(Widget child, {bool load = true}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ProjectsBloc>(
        create: (context) {
          final repository = context.read<ProjectRepository>();
          final bloc = ProjectsBloc(
            GetMyProjectsUseCase(repository),
            CreateProjectUseCase(repository),
            GetProjectDetailUseCase(repository),
            UpdateProjectUseCase(repository),
          );
          if (load) bloc.add(const LoadProjects());
          return bloc;
        },
      ),
      BlocProvider<ProposalsBloc>(
        create: (context) {
          final repository = context.read<ProposalRepository>();
          final bloc = ProposalsBloc(
            GetReceivedProposalsUseCase(repository),
            AcceptProposalUseCase(repository),
          );
          if (load) bloc.add(const LoadReceivedProposals());
          return bloc;
        },
      ),
      BlocProvider<CatalogBloc>(
        create: (context) {
          final bloc = CatalogBloc(
            GetCatalogMaterialsUseCase(context.read<CatalogRepository>()),
          );
          if (load) bloc.add(const LoadCatalogProducts());
          return bloc;
        },
      ),
    ],
    child: child,
  );
}
