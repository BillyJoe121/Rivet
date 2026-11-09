import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'package:rivet/features/proposals/domain/usecases/get_received_proposals_usecase.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';

class FakeProposalRepository implements ProposalRepository {
  List<Proposal> proposals = [];

  @override
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async {
    if (projectId != null) {
      return proposals.where((p) => p.projectId == projectId).toList();
    }
    return proposals;
  }

  @override
  Future<Proposal> getProposalDetail(String proposalId) async {
    return proposals.firstWhere((p) => p.id == proposalId);
  }

  @override
  Future<void> acceptProposal(String proposalId) async {
    final idx = proposals.indexWhere((p) => p.id == proposalId);
    if (idx != -1) {
      final p = proposals[idx];
      proposals[idx] = Proposal(
        id: p.id,
        projectId: p.projectId,
        contractor: p.contractor,
        laborCostCop: p.laborCostCop,
        materialsCostCop: p.materialsCostCop,
        estimatedDays: p.estimatedDays,
        status: 'Aceptada',
        observations: p.observations,
      );
    }
  }
}

void main() {
  late FakeProposalRepository repo;
  late ProposalsBloc bloc;

  final sampleContractor = const Contractor(
    id: 'c-1',
    name: 'Carlos Mendoza',
    trade: 'Pintor',
    rating: 4.9,
    reviewCount: 20,
    completedJobs: 30,
    zone: 'Cali',
  );

  final sampleProposal = Proposal(
    id: 'prop-1',
    projectId: 'proj-1',
    contractor: sampleContractor,
    laborCostCop: 500000,
    materialsCostCop: 300000,
    estimatedDays: 3,
    status: 'Recibida',
  );

  setUp(() {
    repo = FakeProposalRepository();
    repo.proposals = [sampleProposal];
    bloc = ProposalsBloc(
      GetReceivedProposalsUseCase(repo),
      AcceptProposalUseCase(repo),
    );
  });

  tearDown(() => bloc.close());

  test('estado inicial de ProposalsBloc', () {
    expect(bloc.state.status, ProposalsStatus.initial);
    expect(bloc.state.proposals, isEmpty);
  });

  test('LoadReceivedProposals emite [loading, success] con propuestas', () async {
    bloc.add(const LoadReceivedProposals());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProposalsState>().having((s) => s.status, 'status', ProposalsStatus.loading),
        isA<ProposalsState>()
            .having((s) => s.status, 'status', ProposalsStatus.success)
            .having((s) => s.proposals.length, 'count', 1),
      ]),
    );
  });

  test('AcceptProposalSubmitted actualiza el estado a Aceptada', () async {
    bloc.add(const LoadReceivedProposals());
    await expectLater(bloc.stream, emitsThrough(isA<ProposalsState>().having((s) => s.status, 'status', ProposalsStatus.success)));

    bloc.add(const AcceptProposalSubmitted('prop-1'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProposalsState>().having((s) => s.status, 'status', ProposalsStatus.loading),
        isA<ProposalsState>()
            .having((s) => s.status, 'status', ProposalsStatus.success)
            .having((s) => s.acceptedProposalId, 'id', 'prop-1'),
      ]),
    );
  });
}

