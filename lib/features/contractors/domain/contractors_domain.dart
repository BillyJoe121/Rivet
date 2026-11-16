import '../../../core/models/models.dart';

/// Solicitud de visita técnica a un contratista (P-021, P-022).
class VisitRequest {
  const VisitRequest({
    required this.id,
    required this.contractorId,
    required this.contractorName,
    required this.projectId,
    required this.address,
    required this.preferredDate,
    required this.timeSlot,
    required this.notes,
    required this.feeCop,
    required this.createdAt,
    this.simulatedPaid = true,
  });

  final String id;
  final String contractorId;
  final String contractorName;
  final String projectId;
  final String address;
  final String preferredDate;
  final String timeSlot;
  final String notes;
  final int feeCop;
  final DateTime createdAt;
  final bool simulatedPaid;
}

class ContractorFailure implements Exception {
  const ContractorFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract interface class ContractorRepository {
  Future<List<Contractor>> getContractors();

  Future<VisitRequest> requestVisit({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  });
}

class GetContractorsUseCase {
  const GetContractorsUseCase(this._repository);
  final ContractorRepository _repository;

  Future<List<Contractor>> call() => _repository.getContractors();
}

class RequestContractorVisitUseCase {
  const RequestContractorVisitUseCase(this._repository);
  final ContractorRepository _repository;

  Future<VisitRequest> call({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  }) async {
    if (address.trim().isEmpty) {
      throw const ContractorFailure(
        'Ingresa la dirección donde se realizará la visita técnica.',
      );
    }
    if (preferredDate.trim().isEmpty) {
      throw const ContractorFailure(
        'Selecciona una fecha preferida para la visita.',
      );
    }
    if (timeSlot.trim().isEmpty) {
      throw const ContractorFailure('Elige una franja horaria.');
    }
    return _repository.requestVisit(
      contractorId: contractorId,
      contractorName: contractorName,
      projectId: projectId,
      address: address.trim(),
      preferredDate: preferredDate.trim(),
      timeSlot: timeSlot.trim(),
      notes: notes.trim(),
      feeCop: feeCop,
    );
  }
}
