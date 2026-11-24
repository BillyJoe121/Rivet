import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/data/mock_data.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/home/client_home_bloc.dart';
import 'package:rivet/features/projects/domain/errors/project_failure.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/proposals/all_proposals_screen.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';

import '../../helpers/repositories_test_harness.dart';

class _FailingProposalsRepository implements ProposalRepository {
  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async {
    throw Exception('error secundario');
  }

  @override
  Future<void> acceptProposal(String proposalId) async {}

  @override
  Future<List<Proposal>> getMyProposals() async => const [];

  @override
  Future<Proposal> getProposalDetail(String proposalId) =>
      throw UnimplementedError();

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
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {}

  @override
  Future<void> withdrawProposal(String proposalId) async {}
}

class _FailingProjectRepository implements ProjectRepository {
  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async {
    throw const ProjectFailure('Sin conexión al servidor');
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
  Future<List<Project>> getOpenProjects() => throw UnimplementedError();

  @override
  Future<Project> getProjectDetail(String projectId) =>
      throw UnimplementedError();

  @override
  Future<Project> updateProject(Project project) => throw UnimplementedError();
}

class _StubProjectRepository implements ProjectRepository {
  _StubProjectRepository(this.projects);
  final List<Project> projects;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async => projects;

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
  Future<List<Project>> getOpenProjects() async => projects;

  @override
  Future<Project> getProjectDetail(String projectId) async =>
      projects.firstWhere((p) => p.id == projectId);

  @override
  Future<Project> updateProject(Project project) async => project;
}

class _StubProposalRepository implements ProposalRepository {
  _StubProposalRepository(this.proposals);
  final List<Proposal> proposals;

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async =>
      proposals;

  @override
  Future<void> acceptProposal(String proposalId) async {}

  @override
  Future<List<Proposal>> getMyProposals() async => proposals;

  @override
  Future<Proposal> getProposalDetail(String proposalId) async =>
      proposals.firstWhere((p) => p.id == proposalId);

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
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {}

  @override
  Future<void> withdrawProposal(String proposalId) async {}
}

void main() {
  test(
    'ClientHomeBloc carga proyectos reales y conteo de propuestas aunque falle propuestas',
    () async {
      final proposal = MockData.proposals.first;
      final project = MockData.projects.firstWhere(
        (p) => p.id == proposal.projectId,
      );

      final blocOk = ClientHomeBloc.fromRepositories(
        _StubProjectRepository([project]),
        _StubProposalRepository([proposal]),
      );
      blocOk.add(const LoadClientHome());
      await Future<void>.delayed(Duration.zero);

      expect(blocOk.state.status, ClientHomeStatus.success);
      expect(blocOk.state.featuredProjects, hasLength(1));
      expect(blocOk.state.proposalCountFor(project.id), 1);
      await blocOk.close();

      final blocTolerant = ClientHomeBloc.fromRepositories(
        _StubProjectRepository([project]),
        _FailingProposalsRepository(),
      );
      blocTolerant.add(const LoadClientHome());
      await Future<void>.delayed(Duration.zero);

      expect(blocTolerant.state.status, ClientHomeStatus.success);
      expect(blocTolerant.state.projects, hasLength(1));
      expect(blocTolerant.state.proposals, isEmpty);
      await blocTolerant.close();

      final blocError = ClientHomeBloc.fromRepositories(
        _FailingProjectRepository(),
        _StubProposalRepository(const []),
      );
      blocError.add(const LoadClientHome());
      await Future<void>.delayed(Duration.zero);

      expect(blocError.state.status, ClientHomeStatus.failure);
      expect(blocError.state.errorMessage, 'Sin conexión al servidor');
      await blocError.close();
    },
  );

  testWidgets(
    'AllProposalsScreen muestra títulos reales de proyecto en lugar del UUID',
    (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final proposal = MockData.proposals.first;
      final project = MockData.projects.firstWhere(
        (p) => p.id == proposal.projectId,
      );

      await tester.pumpWidget(
        withRepositories(
          projects: _StubProjectRepository([project]),
          proposals: _StubProposalRepository([proposal]),
          MaterialApp(home: AllProposalsScreen.withBloc()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(project.title), findsOneWidget);
    },
  );
}
