import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/proposals/contractor/create_proposal_bloc.dart';
import 'package:rivet/features/proposals/domain/errors/proposal_failure.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/save_proposal_usecase.dart';

class _FakeProposalRepo implements ProposalRepository {
  Object? error;
  Proposal? lastSaved;

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
    if (error != null) throw error!;
    final saved = Proposal(
      id: proposalId ?? 'prop-1',
      projectId: projectId,
      contractor: const Contractor(
        id: 'c-1',
        name: 'Carlos',
        trade: 'Pintor',
        rating: 5,
        reviewCount: 1,
        completedJobs: 1,
        zone: 'Cali',
      ),
      laborCostCop: laborCostCop,
      materialsCostCop: materialsCostCop,
      estimatedDays: estimatedDays,
      status: status,
      observations: observations,
    );
    lastSaved = saved;
    return saved;
  }

  @override
  Future<void> acceptProposal(String proposalId) async {}

  @override
  Future<void> updateProposalStatus(
    String proposalId,
    ProposalStatus status,
  ) async {}

  @override
  Future<List<Proposal>> getMyProposals() async => [];

  @override
  Future<Proposal> getProposalDetail(String proposalId) =>
      throw UnimplementedError();

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async => [];

  @override
  Future<void> withdrawProposal(String proposalId) async {}
}

void main() {
  test('CreateProposalBloc guarda borrador [loading, success]', () async {
    final repo = _FakeProposalRepo();
    final bloc = CreateProposalBloc(
      SaveProposalUseCase(repo),
      projectId: 'proj-1',
    );
    addTearDown(bloc.close);

    bloc.add(const SaveProposalSubmitted(ProposalStatus.draft));
    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CreateProposalState>()
            .having((s) => s.status, 'status', CreateProposalStatus.loading),
        isA<CreateProposalState>()
            .having((s) => s.status, 'status', CreateProposalStatus.success)
            .having((s) => s.savedProposal?.status, 'status', ProposalStatus.draft),
      ]),
    );
  });

  test('CreateProposalBloc valida mano de obra al enviar y emite failure', () async {
    final repo = _FakeProposalRepo();
    final bloc = CreateProposalBloc(
      SaveProposalUseCase(repo),
      projectId: 'proj-1',
    );
    addTearDown(bloc.close);

    bloc.add(const SaveProposalSubmitted(ProposalStatus.sent));
    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CreateProposalState>()
            .having((s) => s.status, 'status', CreateProposalStatus.loading),
        isA<CreateProposalState>()
            .having((s) => s.status, 'status', CreateProposalStatus.failure)
            .having((s) => s.errorMessage, 'error', isNotEmpty),
      ]),
    );
  });

  test('CreateProposalBloc propaga fallo del repositorio', () async {
    final repo = _FakeProposalRepo()
      ..error = const ProposalFailure('Error de red');
    final bloc = CreateProposalBloc(
      SaveProposalUseCase(repo),
      projectId: 'proj-1',
    );
    addTearDown(bloc.close);

    bloc
      ..add(const CreateProposalLaborChanged(500000))
      ..add(const SaveProposalSubmitted(ProposalStatus.sent));

    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CreateProposalState>()
            .having((s) => s.status, 'status', CreateProposalStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Error de red'),
      ),
    );
  });
}
