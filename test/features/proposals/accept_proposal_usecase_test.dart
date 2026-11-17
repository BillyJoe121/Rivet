import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/proposals/domain/errors/proposal_failure.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/accept_proposal_usecase.dart';

class _FakeProposalRepo implements ProposalRepository {
  _FakeProposalRepo(this.items);
  final List<Proposal> items;
  String? failOnStatusForId;

  @override
  Future<Proposal> getProposalDetail(String proposalId) async =>
      items.firstWhere((p) => p.id == proposalId);

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async =>
      items.where((p) => projectId == null || p.projectId == projectId).toList();

  @override
  Future<void> acceptProposal(String proposalId) =>
      updateProposalStatus(proposalId, ProposalStatus.accepted);

  @override
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {
    if (failOnStatusForId == proposalId) {
      throw const ProposalFailure('Error simulado en propuesta');
    }
    final idx = items.indexWhere((p) => p.id == proposalId);
    if (idx != -1) {
      items[idx] = items[idx].copyWith(status: status);
    }
  }

  @override
  Future<List<Proposal>> getMyProposals() async => items;

  @override
  Future<Proposal> saveProposal({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  }) => throw UnimplementedError();

  @override
  Future<void> withdrawProposal(String proposalId) async {}
}

class _FakeProjectRepo implements ProjectRepository {
  _FakeProjectRepo(this.project);
  Project project;
  bool failOnUpdate = false;

  @override
  Future<Project> getProjectDetail(String projectId) async => project;

  @override
  Future<Project> updateProject(Project updated) async {
    if (failOnUpdate) {
      throw Exception('Fallo actualizando proyecto');
    }
    project = updated;
    return project;
  }

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) => throw UnimplementedError();

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async => [project];

  @override
  Future<List<Project>> getOpenProjects() async => [project];
}

Proposal _proposal(String id, ProposalStatus status) => Proposal(
      id: id,
      projectId: 'proj-1',
      contractor: const Contractor(
        id: 'c-1',
        name: 'Carlos',
        trade: 'Pintor',
        rating: 4.8,
        reviewCount: 10,
        completedJobs: 12,
        zone: 'Cali',
      ),
      laborCostCop: 500000,
      materialsCostCop: 300000,
      estimatedDays: 4,
      status: status,
      observations: 'Incluye materiales',
    );

Project _project() => Project(
      id: 'proj-1',
      title: 'Sala principal',
      clientName: 'Ana',
      city: 'Cali',
      neighborhood: 'Granada',
      surfaces: const [],
      status: ProjectStatus.published,
      createdAt: DateTime(2026, 10, 1),
    );

void main() {
  test('AcceptProposalUseCase acepta una, rechaza otras y pasa proyecto a inProgress', () async {
    final propRepo = _FakeProposalRepo([
      _proposal('p-1', ProposalStatus.sent),
      _proposal('p-2', ProposalStatus.sent),
      _proposal('p-3', ProposalStatus.draft),
    ]);
    final projRepo = _FakeProjectRepo(_project());
    final useCase = AcceptProposalUseCase(propRepo, projRepo);

    await useCase('p-1');

    expect(propRepo.items[0].status, ProposalStatus.accepted);
    expect(propRepo.items[1].status, ProposalStatus.rejected);
    expect(propRepo.items[2].status, ProposalStatus.draft);
    expect(projRepo.project.status, ProjectStatus.inProgress);
  });

  test('AcceptProposalUseCase revierte propuestas si falla actualizar el proyecto', () async {
    final propRepo = _FakeProposalRepo([
      _proposal('p-1', ProposalStatus.sent),
      _proposal('p-2', ProposalStatus.sent),
    ]);
    final projRepo = _FakeProjectRepo(_project())..failOnUpdate = true;
    final useCase = AcceptProposalUseCase(propRepo, projRepo);

    await expectLater(useCase('p-1'), throwsA(isA<ProposalFailure>()));
    expect(propRepo.items[0].status, ProposalStatus.sent);
    expect(propRepo.items[1].status, ProposalStatus.sent);
    expect(projRepo.project.status, ProjectStatus.published);
  });

  test('AcceptProposalUseCase revierte si falla rechazar otra propuesta', () async {
    final propRepo = _FakeProposalRepo([
      _proposal('p-1', ProposalStatus.sent),
      _proposal('p-2', ProposalStatus.sent),
    ])..failOnStatusForId = 'p-2';
    final projRepo = _FakeProjectRepo(_project());
    final useCase = AcceptProposalUseCase(propRepo, projRepo);

    await expectLater(useCase('p-1'), throwsA(isA<ProposalFailure>()));
    expect(propRepo.items[0].status, ProposalStatus.sent);
    expect(propRepo.items[1].status, ProposalStatus.sent);
  });
}
