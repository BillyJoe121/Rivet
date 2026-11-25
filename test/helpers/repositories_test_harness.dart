import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rivet/core/data/mock_data.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:rivet/features/contractors/contractors_module.dart';
import 'package:rivet/features/messaging/messaging_module.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/wizard/data/local_project_draft_repository.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft_repository.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';
import 'package:rivet/features/supplier/catalog_mock.dart';
import 'package:rivet/features/supplier/domain/repositories/catalog_repository.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';
import 'package:rivet/injection_container.dart';

import 'auth_test_harness.dart';

class _InMemoryProjectRepository implements ProjectRepository {
  final List<Project> _items = List<Project>.from(MockData.projects);

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async {
    if (status == null) return List<Project>.unmodifiable(_items);
    return _items.where((p) => p.status == status).toList();
  }

  @override
  Future<List<Project>> getOpenProjects() async =>
      _items.where((p) => p.status == ProjectStatus.published).toList();

  @override
  Future<Project> getProjectDetail(String projectId) async =>
      _items.firstWhere((p) => p.id == projectId);

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) async {
    final created = Project(
      id: 'proj-${_items.length + 1}',
      title: title,
      description: description,
      clientName: 'Cliente Demo',
      city: city,
      neighborhood: neighborhood,
      surfaces: surfaces,
      status: ProjectStatus.published,
      createdAt: DateTime.now(),
      budgetEstimateCop: budgetEstimateCop,
      imageAsset: imageAsset,
    );
    _items.insert(0, created);
    return created;
  }

  @override
  Future<Project> updateProject(Project project) async {
    final idx = _items.indexWhere((p) => p.id == project.id);
    if (idx != -1) _items[idx] = project;
    return project;
  }
}

class _InMemoryProposalRepository implements ProposalRepository {
  final List<Proposal> _items = List<Proposal>.from(MockData.proposals);

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async {
    if (projectId == null) return List<Proposal>.unmodifiable(_items);
    return _items.where((p) => p.projectId == projectId).toList();
  }

  @override
  Future<Proposal> getProposalDetail(String proposalId) async =>
      _items.firstWhere((p) => p.id == proposalId);

  @override
  Future<void> acceptProposal(String proposalId) =>
      updateProposalStatus(proposalId, ProposalStatus.accepted);

  @override
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {
    final idx = _items.indexWhere((p) => p.id == proposalId);
    if (idx == -1) return;
    _items[idx] = _items[idx].copyWith(status: status);
  }

  @override
  Future<List<Proposal>> getMyProposals() async =>
      List<Proposal>.unmodifiable(_items);

  @override
  Future<Proposal> saveProposal({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  }) async {
    final proposal = Proposal(
      id: proposalId ?? 'prop-${_items.length + 1}',
      projectId: projectId,
      contractor: MockData.contractors.first,
      laborCostCop: laborCostCop,
      materialsCostCop: materialsCostCop,
      estimatedDays: estimatedDays,
      status: status,
      observations: observations,
    );
    final idx = _items.indexWhere((p) => p.id == proposal.id);
    if (idx != -1) {
      _items[idx] = proposal;
    } else {
      _items.insert(0, proposal);
    }
    return proposal;
  }

  @override
  Future<void> withdrawProposal(String proposalId) async {
    final idx = _items.indexWhere((p) => p.id == proposalId);
    if (idx == -1) return;
    _items[idx] = _items[idx].copyWith(status: ProposalStatus.withdrawn);
  }
}

class _InMemoryCatalogRepository implements CatalogRepository {
  @override
  Future<List<MaterialProduct>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    return CatalogMock.products.where((p) {
      final matchesCategory =
          category == null || category == 'Todos' || p.category == category;
      final q = searchQuery?.trim().toLowerCase() ?? '';
      final matchesSearch =
          q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Future<MaterialProduct> getProductDetail(String productId) async =>
      CatalogMock.products.firstWhere((p) => p.id == productId);
}

/// Registra en GetIt los mismos repositorios que la raíz de la app inyecta,
/// todos en memoria (sin cliente de Supabase), y provee [AuthBloc].
///
/// Cada parámetro reemplaza el repositorio por defecto de ese módulo.
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
  configureDependencies(
    authRepository: auth ?? InMemoryAuthRepository(),
    projectRepository: projects ?? _InMemoryProjectRepository(),
    proposalRepository: proposals ?? _InMemoryProposalRepository(),
    catalogRepository: catalog ?? _InMemoryCatalogRepository(),
    contractorRepository: contractors ?? LocalContractorRepository(),
    agreementRepository: agreements ?? LocalAgreementRepository(),
    messagingRepository: messaging ?? LocalMessagingRepository(),
    projectDraftRepository: drafts ?? LocalProjectDraftRepository(),
    allowOverride: true,
  );
  return BlocProvider<AuthBloc>(
    create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
    child: child,
  );
}

/// Arma los Bloc compartidos de la raíz (proyectos, propuestas y Bodega) desde
/// GetIt; va dentro de [withRepositories].
///
/// Con [load] en `true` cada Bloc pide sus datos al crearse, como en la app.
Widget withAppBlocs(Widget child, {bool load = true}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ProjectsBloc>(
        create: (_) {
          final bloc = sl<ProjectsBloc>();
          if (load) bloc.add(const LoadProjects());
          return bloc;
        },
      ),
      BlocProvider<ProposalsBloc>(
        create: (_) {
          final bloc = sl<ProposalsBloc>();
          if (load) bloc.add(const LoadReceivedProposals());
          return bloc;
        },
      ),
      BlocProvider<CatalogBloc>(
        create: (_) {
          final bloc = sl<CatalogBloc>();
          if (load) bloc.add(const LoadCatalogProducts());
          return bloc;
        },
      ),
    ],
    child: child,
  );
}
