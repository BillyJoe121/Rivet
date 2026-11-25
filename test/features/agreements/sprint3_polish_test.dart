import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/home/contractor_home_bloc.dart';
import 'package:rivet/features/messaging/messaging_screens.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';

import '../../helpers/local_agreement_repository.dart';
import '../../helpers/repositories_test_harness.dart';

class _StubProjectRepo implements ProjectRepository {
  _StubProjectRepo(this.project);
  final Project project;

  @override
  Future<List<Project>> getOpenProjects() async => [project];

  @override
  Future<Project> getProjectDetail(String projectId) async => project;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async => [project];

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
  Future<Project> updateProject(Project project) async => project;
}

class _StubProposalRepo implements ProposalRepository {
  _StubProposalRepo(this.proposal);
  final Proposal proposal;

  @override
  Future<List<Proposal>> getMyProposals() async => [proposal];

  @override
  Future<Proposal> getProposalDetail(String proposalId) async => proposal;

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async =>
      [proposal];

  @override
  Future<void> acceptProposal(String proposalId) async {}

  @override
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {}

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

void main() {
  test('ProgressBloc, ClosureBloc y PayoutAccountBloc manejan estado de UI en BLoC', () async {
    final repo = LocalAgreementRepository();

    final progressBloc = ProgressBloc.fromRepository(repo);
    progressBloc.add(const ProgressPercentChanged(75));
    progressBloc.add(const ProgressMilestoneSelected('m-1'));
    await Future<void>.delayed(Duration.zero);
    expect(progressBloc.state.draftPercent, 75);
    expect(progressBloc.state.selectedMilestoneId, 'm-1');
    await progressBloc.close();

    final closureBloc = ClosureBloc.fromRepository(repo);
    closureBloc.add(const ClosureStarsChanged(4));
    await Future<void>.delayed(Duration.zero);
    expect(closureBloc.state.selectedStars, 4);
    await closureBloc.close();

    final payoutBloc = PayoutAccountBloc.fromRepository(repo);
    payoutBloc.add(const PayoutAccountTypeChanged('corriente'));
    await Future<void>.delayed(Duration.zero);
    expect(payoutBloc.state.selectedAccountType, 'corriente');
    await payoutBloc.close();
  });

  test('ContractorHomeBloc carga título real del proyecto y progreso de hitos', () async {
    final project = Project(
      id: 'proj-real-1',
      title: 'Apartamento Granada',
      clientName: 'Laura',
      city: 'Cali',
      neighborhood: 'Granada',
      surfaces: const [],
      status: ProjectStatus.inProgress,
      createdAt: DateTime(2026, 11, 1),
    );
    const proposal = Proposal(
      id: 'prop-real-1',
      projectId: 'proj-real-1',
      contractor: Contractor(
        id: 'c-1',
        name: 'Carlos',
        trade: 'Pintor',
        rating: 4.9,
        reviewCount: 10,
        completedJobs: 15,
        zone: 'Cali',
      ),
      laborCostCop: 500000,
      materialsCostCop: 200000,
      estimatedDays: 4,
      status: ProposalStatus.accepted,
      observations: 'Listo',
    );
    final agreements = LocalAgreementRepository();
    final agr = await agreements.prepareAgreement(
      projectId: project.id,
      projectTitle: project.title,
      proposal: proposal,
    );
    await agreements.confirmMilestone(
      milestoneId: agr.milestoneItems.first.id,
      asClient: false,
    );
    await agreements.confirmMilestone(
      milestoneId: agr.milestoneItems.first.id,
      asClient: true,
    );

    final bloc = ContractorHomeBloc.fromRepositories(
      _StubProjectRepo(project),
      _StubProposalRepo(proposal),
      agreementRepository: agreements,
    );
    bloc.add(const LoadContractorHome());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.activeProject?.title, 'Apartamento Granada');
    expect(bloc.state.activeStagesDone, 1);
    expect(bloc.state.activeStagesTotal, 3);
    expect(bloc.state.activeProgress, closeTo(1 / 3, 0.01));
    await bloc.close();
  });

  testWidgets('ConversationsListScreen oculta botón volver cuando es raíz', (tester) async {
    await tester.pumpWidget(
      withRepositories(
        MaterialApp(home: ConversationsListScreen.withBloc()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mensajes'), findsOneWidget);
    expect(find.byTooltip('Volver'), findsNothing);
  });
}
