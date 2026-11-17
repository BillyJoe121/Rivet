import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/agreements_domain.dart';
import '../domain/closure_domain.dart';
import '../domain/progress_domain.dart';

/// Fuente de datos de cierre, calificaciones, pagos y cancelaciones en Supabase.
class SupabaseClosureDataSource {
  SupabaseClosureDataSource(this._client);

  final SupabaseClient? _client;
  static const _cancelBucket = 'cancellation-photos';

  SupabaseClient _requireSession() {
    final client = _client;
    if (client == null) {
      throw const AgreementFailure(
        'No hay conexión configurada con el servidor. Intenta más tarde.',
      );
    }
    if (client.auth.currentUser == null) {
      throw const AgreementFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    }
    return client;
  }

  Future<T> _guard<T>(String fallback, Future<T> Function() run) async {
    try {
      return await run();
    } on AgreementFailure {
      rethrow;
    } on AuthException {
      throw const AgreementFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    } on StorageException catch (e) {
      throw AgreementFailure(
        e.message.isNotEmpty
            ? e.message
            : 'No pudimos subir la evidencia fotográfica.',
      );
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw const AgreementFailure(
          'No tienes permisos para realizar esta acción.',
          isPermissionDenied: true,
        );
      }
      if (e.code == '23514' || e.code == '23505') {
        throw AgreementFailure(e.message.isNotEmpty ? e.message : fallback);
      }
      throw AgreementFailure(e.message.isNotEmpty ? e.message : fallback);
    } catch (_) {
      throw AgreementFailure(fallback);
    }
  }

  Future<List<AgreementRating>> getRatings(String agreementId) {
    return _guard('No pudimos cargar las calificaciones.', () async {
      final client = _requireSession();
      final rows = await client
          .from('ratings')
          .select()
          .eq('agreement_id', agreementId)
          .order('created_at', ascending: false);
      return [for (final r in rows) _ratingFromRow(r)];
    });
  }

  Future<AgreementRating> submitRating({
    required String agreementId,
    required String rateeId,
    required int stars,
    required String review,
  }) {
    return _guard('No pudimos guardar tu calificación.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final row = await client
          .from('ratings')
          .insert({
            'agreement_id': agreementId,
            'rater_id': userId,
            'ratee_id': rateeId,
            'stars': stars,
            'review': review,
          })
          .select()
          .single();
      return _ratingFromRow(row);
    });
  }

  Future<List<AgreementCancellation>> getCancellations(String agreementId) {
    return _guard('No pudimos consultar las cancelaciones.', () async {
      final client = _requireSession();
      final rows = await client
          .from('cancellations')
          .select()
          .eq('agreement_id', agreementId)
          .order('created_at', ascending: false);
      return [for (final r in rows) _cancellationFromRow(r)];
    });
  }

  Future<AgreementCancellation> requestCancellation({
    required String agreementId,
    required String reason,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
  }) {
    return _guard('No pudimos registrar la solicitud de cancelación.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;

      final uploadedPaths = <String>[];
      final stamp = DateTime.now().millisecondsSinceEpoch;
      for (var i = 0; i < photos.length; i++) {
        final photo = photos[i];
        final safeName = photo.fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        final path = '$agreementId/${stamp}_${i}_$safeName';
        await client.storage.from(_cancelBucket).uploadBinary(
              path,
              photo.bytes,
              fileOptions: FileOptions(
                contentType: photo.mimeType,
                upsert: false,
              ),
            );
        uploadedPaths.add(path);
      }

      final row = await client
          .from('cancellations')
          .insert({
            'agreement_id': agreementId,
            'requested_by': userId,
            'reason': reason,
            'description': description,
            'photo_paths': uploadedPaths,
          })
          .select()
          .single();
      return _cancellationFromRow(row);
    });
  }

  Future<AgreementCancellation> resolveCancellation({
    required String cancellationId,
    required bool approved,
  }) {
    return _guard('No pudimos resolver la solicitud de cancelación.', () async {
      final client = _requireSession();
      final row = await client
          .from('cancellations')
          .update({'status': approved ? 'approved' : 'rejected'})
          .eq('id', cancellationId)
          .select()
          .single();
      return _cancellationFromRow(row);
    });
  }

  Future<List<PaymentRecord>> getPayments(String agreementId) {
    return _guard('No pudimos consultar los pagos del acuerdo.', () async {
      final client = _requireSession();
      final rows = await client
          .from('payments')
          .select()
          .eq('agreement_id', agreementId)
          .order('created_at', ascending: false);
      return [for (final r in rows) _paymentFromRow(r)];
    });
  }

  Future<PaymentRecord> releasePayment(String paymentId) {
    return _guard('No pudimos registrar la liberación del pago.', () async {
      final client = _requireSession();
      final row = await client
          .from('payments')
          .update({'status': 'released'})
          .eq('id', paymentId)
          .select()
          .single();
      return _paymentFromRow(row);
    });
  }

  AgreementRating _ratingFromRow(Map<String, dynamic> row) {
    return AgreementRating(
      id: row['id'] as String,
      agreementId: row['agreement_id'] as String,
      raterId: row['rater_id'] as String,
      rateeId: row['ratee_id'] as String,
      stars: (row['stars'] as num).toInt(),
      review: row['review'] as String? ?? '',
      createdAt: _parseDate(row['created_at']) ?? DateTime.now(),
    );
  }

  AgreementCancellation _cancellationFromRow(Map<String, dynamic> row) {
    final rawPaths = row['photo_paths'];
    final status = switch (row['status'] as String?) {
      'approved' => CancellationStatus.approved,
      'rejected' => CancellationStatus.rejected,
      'refunded' => CancellationStatus.refunded,
      _ => CancellationStatus.requested,
    };
    return AgreementCancellation(
      id: row['id'] as String,
      agreementId: row['agreement_id'] as String,
      requestedBy: row['requested_by'] as String,
      reason: row['reason'] as String,
      description: row['description'] as String? ?? '',
      photoPaths: rawPaths is List
          ? [for (final p in rawPaths) p.toString()]
          : const [],
      status: status,
      resolvedAt: _parseDate(row['resolved_at']),
      createdAt: _parseDate(row['created_at']) ?? DateTime.now(),
    );
  }

  PaymentRecord _paymentFromRow(Map<String, dynamic> row) {
    final status = switch (row['status'] as String?) {
      'approved' => SimulatedPaymentStatus.approved,
      'rejected' => SimulatedPaymentStatus.rejected,
      'held' => SimulatedPaymentStatus.held,
      'released' => SimulatedPaymentStatus.released,
      'refunded' => SimulatedPaymentStatus.refunded,
      _ => SimulatedPaymentStatus.pending,
    };
    return PaymentRecord(
      id: row['id'] as String,
      agreementId: row['agreement_id'] as String,
      kind: row['kind'] as String? ?? 'advance',
      amountCop: (row['amount'] as num?)?.round() ?? 0,
      status: status,
      cardBrand: row['card_brand'] as String?,
      cardLast4: row['card_last4'] as String?,
      releasedAt: _parseDate(row['released_at']),
      createdAt: _parseDate(row['created_at']) ?? DateTime.now(),
    );
  }

  DateTime? _parseDate(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
