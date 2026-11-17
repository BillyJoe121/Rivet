import '../../../../core/models/models.dart';
import '../../../projects/domain/repositories/project_repository.dart';
import '../errors/proposal_failure.dart';
import '../repositories/proposal_repository.dart';

/// Caso de uso: Aceptación formal de una cotización.
///
/// Acepta la propuesta elegida, rechaza las demás propuestas enviadas para el
/// mismo proyecto y pasa el proyecto a estado [ProjectStatus.inProgress].
/// Si algún paso falla, revierte los cambios previos e informa con [ProposalFailure].
class AcceptProposalUseCase {
  const AcceptProposalUseCase(
    this._repository, [
    this._projectRepository,
  ]);

  final ProposalRepository _repository;
  final ProjectRepository? _projectRepository;

  Future<void> call(String proposalId) async {
    final target = await _repository.getProposalDetail(proposalId);
    if (target.status != ProposalStatus.sent) {
      throw const ProposalFailure(
        'Solo es posible aceptar propuestas que estén en estado recibida.',
      );
    }

    final projectRepo = _projectRepository;
    final previousProject = projectRepo != null
        ? await projectRepo.getProjectDetail(target.projectId)
        : null;

    final siblings = await _repository.getReceivedProposals(
      projectId: target.projectId,
    );
    final toReject = [
      for (final p in siblings)
        if (p.id != proposalId && p.status == ProposalStatus.sent) p.id,
    ];

    await _repository.acceptProposal(proposalId);

    final rejectedIds = <String>[];
    try {
      for (final otherId in toReject) {
        await _repository.updateProposalStatus(otherId, ProposalStatus.rejected);
        rejectedIds.add(otherId);
      }
      if (projectRepo != null && previousProject != null) {
        await projectRepo.updateProject(
          previousProject.copyWith(status: ProjectStatus.inProgress),
        );
      }
    } catch (error) {
      await _rollback(proposalId, rejectedIds);
      if (error is ProposalFailure) rethrow;
      throw const ProposalFailure(
        'No se pudo completar la aceptación de la propuesta. Se revirtieron los cambios.',
      );
    }
  }

  Future<void> _rollback(String acceptedId, List<String> rejectedIds) async {
    final rollbackErrors = <Object>[];
    for (final id in rejectedIds.reversed) {
      try {
        await _repository.updateProposalStatus(id, ProposalStatus.sent);
      } catch (e) {
        rollbackErrors.add(e);
      }
    }
    try {
      await _repository.updateProposalStatus(acceptedId, ProposalStatus.sent);
    } catch (e) {
      rollbackErrors.add(e);
    }
    if (rollbackErrors.isNotEmpty) {
      throw const ProposalFailure(
        'Falló la aceptación y no fue posible revertir automáticamente todas las propuestas. Revisa el estado del proyecto.',
      );
    }
  }
}
