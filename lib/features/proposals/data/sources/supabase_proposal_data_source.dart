import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/models.dart';
import '../../domain/errors/proposal_failure.dart';

/// Fuente de datos de propuestas en Supabase.
///
/// Cualquier fallo de red, de sesión o de la base se convierte en
/// [ProposalFailure] con un mensaje listo para mostrar.
class SupabaseProposalDataSource {
  SupabaseProposalDataSource(this._client);

  final SupabaseClient? _client;

  static const _select = '*, contractor:public_profiles(*)';

  static const noConnectionMessage =
      'No pudimos conectarnos con Rivet. Revisa tu conexión e inténtalo de nuevo.';
  static const expiredSessionMessage =
      'Tu sesión venció. Inicia sesión de nuevo.';
  static const loadListMessage =
      'No pudimos cargar las propuestas. Inténtalo de nuevo.';
  static const loadDetailMessage =
      'No pudimos cargar la propuesta. Inténtalo de nuevo.';
  static const notFoundMessage = 'No encontramos esta propuesta.';
  static const acceptMessage =
      'No pudimos aceptar la propuesta. Inténtalo de nuevo.';
  static const saveMessage =
      'No pudimos guardar tu propuesta. Inténtalo de nuevo.';
  static const withdrawMessage =
      'No pudimos retirar la propuesta. Inténtalo de nuevo.';

  /// Consulta las propuestas recibidas, opcionalmente de un solo proyecto.
  Future<List<Proposal>> getReceivedProposals({String? projectId}) {
    return _guard(loadListMessage, () async {
      final client = _requireSession();
      var query = client.from('proposals').select(_select);
      if (projectId != null) query = query.eq('project_id', projectId);

      final rows = await query.order('created_at', ascending: false);
      final ratings = await _ratingsFor(client, rows);
      return [for (final row in rows) proposalFromRow(row, ratings: ratings)];
    });
  }

  /// Consulta el detalle de una propuesta por ID.
  Future<Proposal> getProposalDetail(String proposalId) {
    return _guard(loadDetailMessage, () async {
      final client = _requireSession();
      final row = await client
          .from('proposals')
          .select(_select)
          .eq('id', proposalId)
          .maybeSingle();
      if (row == null) throw const ProposalFailure(notFoundMessage);
      final ratings = await _ratingsFor(client, [row]);
      return proposalFromRow(row, ratings: ratings);
    });
  }

  /// Marca una propuesta como aceptada; falla si la base no la actualiza.
  Future<void> acceptProposal(String proposalId) =>
      updateProposalStatus(proposalId, ProposalStatus.accepted);

  /// Actualiza el estado de una propuesta en Supabase; falla si no existe o RLS bloquea.
  Future<void> updateProposalStatus(String proposalId, ProposalStatus status) {
    return _guard(acceptMessage, () async {
      final client = _requireSession();
      await client
          .from('proposals')
          .update({
            'status': proposalStatusToDb(status),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', proposalId)
          .select('id')
          .single();
    });
  }

  /// Consulta las propuestas del contratista con sesión activa.
  Future<List<Proposal>> getMyProposals() {
    return _guard(loadListMessage, () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final rows = await client
          .from('proposals')
          .select(_select)
          .eq('contractor_id', userId)
          .order('created_at', ascending: false);
      final ratings = await _ratingsFor(client, rows);
      return [for (final row in rows) proposalFromRow(row, ratings: ratings)];
    });
  }

  /// Inserta o actualiza una propuesta del contratista actual.
  Future<Proposal> saveProposal({
    String? proposalId,
    required String projectId,
    required int laborCostCop,
    required int materialsCostCop,
    required int estimatedDays,
    required String observations,
    required ProposalStatus status,
  }) {
    return _guard(saveMessage, () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final payload = {
        'project_id': projectId,
        'contractor_id': userId,
        'labor_cost_cop': laborCostCop,
        'materials_cost_cop': materialsCostCop,
        'estimated_days': estimatedDays,
        'observations': observations,
        'status': proposalStatusToDb(status),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      final Map<String, dynamic> row;
      if (proposalId != null && proposalId.isNotEmpty) {
        row = await client
            .from('proposals')
            .update(payload)
            .eq('id', proposalId)
            .eq('contractor_id', userId)
            .select(_select)
            .single();
      } else {
        row = await client
            .from('proposals')
            .insert(payload)
            .select(_select)
            .single();
      }
      final ratings = await _ratingsFor(client, [row]);
      return proposalFromRow(row, ratings: ratings);
    });
  }

  /// Marca una propuesta del contratista como retirada.
  Future<void> withdrawProposal(String proposalId) {
    return _guard(withdrawMessage, () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      await client
          .from('proposals')
          .update({
            'status': proposalStatusToDb(ProposalStatus.withdrawn),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', proposalId)
          .eq('contractor_id', userId)
          .select('id')
          .single();
    });
  }

  /// Resumen de calificaciones (`avg_stars`, `review_count`) de cada
  /// contratista presente en [rows], vía `get_contractor_rating_summary`.
  Future<Map<String, Map<String, dynamic>>> _ratingsFor(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    final ids = {
      for (final row in rows)
        if (row['contractor_id'] != null) row['contractor_id'].toString(),
    };
    final summaries = await Future.wait([
      for (final id in ids)
        client.rpc<dynamic>(
          'get_contractor_rating_summary',
          params: {'p_contractor': id},
        ),
    ]);
    return {
      for (final summary in summaries)
        for (final item in (summary as List? ?? const []))
          (item as Map<String, dynamic>)['contractor_id'].toString(): item,
    };
  }

  SupabaseClient _requireSession() {
    final client = _client;
    if (client == null) throw const ProposalFailure(noConnectionMessage);
    if (client.auth.currentUser == null) {
      throw const ProposalFailure(expiredSessionMessage);
    }
    return client;
  }

  Future<T> _guard<T>(String message, Future<T> Function() run) async {
    try {
      return await run();
    } on ProposalFailure {
      rethrow;
    } catch (_) {
      throw ProposalFailure(message);
    }
  }
}

/// Convierte el estado de la base al del dominio. `Aceptada` es el valor
/// heredado de versiones anteriores y equivale a `accepted`.
ProposalStatus proposalStatusFromDb(String? value) {
  return switch (value) {
    'draft' => ProposalStatus.draft,
    'accepted' || 'Aceptada' => ProposalStatus.accepted,
    'rejected' => ProposalStatus.rejected,
    'withdrawn' => ProposalStatus.withdrawn,
    _ => ProposalStatus.sent,
  };
}

/// Convierte el estado del dominio al valor que guarda la base.
String proposalStatusToDb(ProposalStatus status) => status.name;

/// Convierte una fila de `proposals` (con `contractor` anidado) al modelo.
///
/// [ratings] trae el resumen de calificaciones por `contractor_id`.
Proposal proposalFromRow(
  Map<String, dynamic> row, {
  Map<String, Map<String, dynamic>> ratings = const {},
}) {
  final contractor = row['contractor'] as Map<String, dynamic>? ?? const {};
  final rating = ratings[row['contractor_id']?.toString()] ?? const {};

  return Proposal(
    id: row['id'].toString(),
    projectId: row['project_id'].toString(),
    contractor: Contractor(
      id: contractor['id']?.toString() ?? row['contractor_id']?.toString() ?? '',
      name: contractor['full_name'] as String? ?? '',
      trade: contractor['trade'] as String? ?? '',
      rating: _toNum(rating['avg_stars']).toDouble(),
      reviewCount: _toNum(rating['review_count']).round(),
      completedJobs: _toNum(contractor['completed_jobs']).round(),
      zone: contractor['zone'] as String? ?? '',
      isVerified: contractor['is_verified'] as bool? ?? false,
    ),
    laborCostCop: _toNum(row['labor_cost_cop']).round(),
    materialsCostCop: _toNum(row['materials_cost_cop']).round(),
    estimatedDays: _toNum(row['estimated_days']).round(),
    status: proposalStatusFromDb(row['status'] as String?),
    observations: row['observations'] as String? ?? '',
  );
}

num _toNum(Object? value) => switch (value) {
  final num n => n,
  final String s => num.tryParse(s) ?? 0,
  _ => 0,
};
