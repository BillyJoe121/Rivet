import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

/// Fuente de datos de propuestas con soporte Supabase y fallback en memoria.
class SupabaseProposalDataSource {
  SupabaseProposalDataSource(this._client);

  final SupabaseClient? _client;

  final List<Proposal> _localProposals = List.from(MockData.proposals);
  bool _useLocalFastPath = false;

  /// Consulta las propuestas recibidas.
  Future<List<Proposal>> getReceivedProposals({String? projectId}) async {
    final client = _client;
    if (!_useLocalFastPath && client != null) {
      try {
        var query = client.from('proposals').select('*, contractor:public_profiles(*)');
        if (projectId != null) {
          query = query.eq('project_id', projectId);
        }
        final data = await query
            .order('created_at', ascending: false)
            .timeout(const Duration(milliseconds: 900));
        final list = (data as List).map((p) => _mapFromSupabase(p as Map<String, dynamic>)).toList();
        if (list.isNotEmpty) return list;
        _useLocalFastPath = true;
      } catch (_) {
        _useLocalFastPath = true;
      }
    }

    if (projectId != null) {
      return _localProposals.where((p) => p.projectId == projectId).toList();
    }
    return List.unmodifiable(_localProposals);
  }

  /// Consulta el detalle de una propuesta por ID.
  Future<Proposal> getProposalDetail(String proposalId) async {
    final client = _client;
    if (!_useLocalFastPath && client != null) {
      try {
        final data = await client
            .from('proposals')
            .select('*, contractor:public_profiles(*)')
            .eq('id', proposalId)
            .maybeSingle()
            .timeout(const Duration(milliseconds: 900));
        if (data != null) {
          return _mapFromSupabase(data);
        }
      } catch (_) {
        _useLocalFastPath = true;
      }
    }

    return _localProposals.firstWhere(
      (p) => p.id == proposalId,
      orElse: () => _localProposals.first,
    );
  }

  /// Marca una propuesta como aceptada.
  Future<void> acceptProposal(String proposalId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('proposals').update({'status': 'Aceptada'}).eq('id', proposalId);
      } catch (_) {}
    }

    final index = _localProposals.indexWhere((p) => p.id == proposalId);
    if (index != -1) {
      final old = _localProposals[index];
      _localProposals[index] = Proposal(
        id: old.id,
        projectId: old.projectId,
        contractor: old.contractor,
        laborCostCop: old.laborCostCop,
        materialsCostCop: old.materialsCostCop,
        estimatedDays: old.estimatedDays,
        status: 'Aceptada',
        observations: old.observations,
      );
    }
  }

  Proposal _mapFromSupabase(Map<String, dynamic> json) {
    final contractorData = json['contractor'] as Map<String, dynamic>? ?? {};

    final contractor = Contractor(
      id: contractorData['id'] as String? ?? 'c-1',
      name: contractorData['full_name'] as String? ?? 'Contratista Profesional',
      trade: contractorData['trade'] as String? ?? 'Pintor profesional',
      rating: (contractorData['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (contractorData['review_count'] as num?)?.toInt() ?? 15,
      completedJobs: (contractorData['completed_jobs'] as num?)?.toInt() ?? 20,
      zone: contractorData['zone'] as String? ?? 'Cali y alrededores',
      isVerified: contractorData['is_verified'] as bool? ?? true,
    );

    return Proposal(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      contractor: contractor,
      laborCostCop: (json['labor_cost_cop'] as num?)?.toInt() ?? 0,
      materialsCostCop: (json['materials_cost_cop'] as num?)?.toInt() ?? 0,
      estimatedDays: (json['estimated_days'] as num?)?.toInt() ?? 3,
      status: json['status'] as String? ?? 'Recibida',
      observations: json['observations'] as String? ?? '',
    );
  }
}

