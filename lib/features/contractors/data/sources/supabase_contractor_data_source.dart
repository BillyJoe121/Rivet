import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/models.dart';
import '../../domain/contractors_domain.dart';

/// Fuente de datos del directorio de contratistas y visitas técnicas en Supabase.
///
/// Propaga cualquier fallo de conexión, sesión o base de datos como
/// [ContractorFailure] sin recurrir a listas de ejemplo.
class SupabaseContractorDataSource {
  SupabaseContractorDataSource(this._client);

  final SupabaseClient? _client;

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static const noConnectionMessage =
      'No pudimos conectarnos con Rivet. Revisa tu conexión e inténtalo de nuevo.';
  static const expiredSessionMessage =
      'Tu sesión venció. Inicia sesión de nuevo.';
  static const loadContractorsMessage =
      'No pudimos cargar el directorio de contratistas. Inténtalo de nuevo.';
  static const requestVisitMessage =
      'No pudimos registrar la solicitud de visita técnica. Inténtalo de nuevo.';

  /// Consulta los contratistas registrados en `public_profiles` con su resumen
  /// de calificaciones.
  Future<List<Contractor>> getContractors() {
    return _guard(loadContractorsMessage, () async {
      final client = _requireSession();
      final rows = await client
          .from('public_profiles')
          .select()
          .eq('role', 'contractor')
          .order('completed_jobs', ascending: false);

      final ratings = await _ratingsFor(client, rows);
      return [
        for (final row in rows) contractorFromProfileRow(row, ratings: ratings),
      ];
    });
  }

  /// Persiste la solicitud de visita técnica en `visit_requests`.
  Future<VisitRequest> requestVisit({
    required String contractorId,
    required String contractorName,
    required String projectId,
    required String address,
    required String preferredDate,
    required String timeSlot,
    required String notes,
    required int feeCop,
  }) {
    return _guard(requestVisitMessage, () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final row = await client
          .from('visit_requests')
          .insert({
            'client_id': userId,
            'contractor_id': contractorId,
            if (_uuidPattern.hasMatch(projectId)) 'project_id': projectId,
            'address': address,
            'preferred_date': preferredDate,
            'time_slot': timeSlot,
            'notes': notes,
            'fee_cop': feeCop,
            'simulated_paid': true,
            'status': 'requested',
          })
          .select()
          .single();

      return visitRequestFromRow(
        row,
        contractorName: contractorName,
        fallbackProjectId: projectId,
      );
    });
  }

  Future<Map<String, Map<String, dynamic>>> _ratingsFor(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  ) async {
    final ids = {
      for (final row in rows)
        if (row['id'] != null) row['id'].toString(),
    };
    if (ids.isEmpty) return const {};

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
    if (client == null) throw const ContractorFailure(noConnectionMessage);
    if (client.auth.currentUser == null) {
      throw const ContractorFailure(expiredSessionMessage);
    }
    return client;
  }

  Future<T> _guard<T>(String fallback, Future<T> Function() run) async {
    try {
      return await run();
    } on ContractorFailure {
      rethrow;
    } on AuthException {
      throw const ContractorFailure(expiredSessionMessage);
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw const ContractorFailure(
          'No tienes permisos para completar esta operación.',
        );
      }
      throw ContractorFailure(e.message.isNotEmpty ? e.message : fallback);
    } catch (_) {
      throw ContractorFailure(fallback);
    }
  }
}

/// Convierte una fila de `public_profiles` (con calificaciones opcionales) al
/// modelo [Contractor].
Contractor contractorFromProfileRow(
  Map<String, dynamic> row, {
  Map<String, Map<String, dynamic>> ratings = const {},
}) {
  final id = row['id']?.toString() ?? '';
  final rating = ratings[id] ?? const {};
  final rawPortfolio = row['portfolio_images'];
  final portfolio = rawPortfolio is List
      ? [for (final item in rawPortfolio) item.toString()]
      : const <String>[];

  return Contractor(
    id: id,
    name: row['full_name'] as String? ?? '',
    trade: row['trade'] as String? ?? '',
    rating: _toNum(rating['avg_stars']).toDouble(),
    reviewCount: _toNum(rating['review_count']).round(),
    completedJobs: _toNum(row['completed_jobs']).round(),
    zone: row['zone'] as String? ?? '',
    isVerified: row['is_verified'] as bool? ?? false,
    portfolioImages: portfolio,
    bio: row['bio'] as String? ?? '',
  );
}

/// Convierte una fila de `visit_requests` al modelo [VisitRequest].
VisitRequest visitRequestFromRow(
  Map<String, dynamic> row, {
  required String contractorName,
  String fallbackProjectId = '',
}) {
  return VisitRequest(
    id: row['id']?.toString() ?? '',
    contractorId: row['contractor_id']?.toString() ?? '',
    contractorName: contractorName,
    projectId: row['project_id']?.toString() ?? fallbackProjectId,
    address: row['address'] as String? ?? '',
    preferredDate: row['preferred_date'] as String? ?? '',
    timeSlot: row['time_slot'] as String? ?? '',
    notes: row['notes'] as String? ?? '',
    feeCop: _toNum(row['fee_cop']).round(),
    createdAt:
        DateTime.tryParse(row['created_at']?.toString() ?? '') ??
        DateTime.now(),
    simulatedPaid: row['simulated_paid'] as bool? ?? true,
  );
}

num _toNum(Object? value) => switch (value) {
  final num n => n,
  final String s => num.tryParse(s) ?? 0,
  _ => 0,
};
