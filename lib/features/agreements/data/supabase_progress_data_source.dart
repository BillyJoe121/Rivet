import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/agreements_domain.dart';
import '../domain/progress_domain.dart';

/// Fuente de datos de avances y checklist mutuo en Supabase + Storage.
class SupabaseProgressDataSource {
  SupabaseProgressDataSource(this._client);

  final SupabaseClient? _client;
  static const _bucket = 'progress-photos';

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
            : 'No pudimos subir las fotos del avance.',
      );
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw const AgreementFailure(
          'No tienes permisos para registrar o confirmar avances en este acuerdo.',
          isPermissionDenied: true,
        );
      }
      throw AgreementFailure(e.message.isNotEmpty ? e.message : fallback);
    } catch (_) {
      throw AgreementFailure(fallback);
    }
  }

  Future<List<ProgressUpdate>> getProgressUpdates(String agreementId) {
    return _guard('No pudimos cargar el historial de avances.', () async {
      final client = _requireSession();
      final rows = await client
          .from('progress_updates')
          .select()
          .eq('agreement_id', agreementId)
          .order('created_at', ascending: false);

      return [for (final r in rows) _fromRow(r)];
    });
  }

  Future<AgreementMilestone> confirmMilestone({
    required String milestoneId,
    required bool asClient,
  }) {
    return _guard('No pudimos confirmar el hito del checklist.', () async {
      final client = _requireSession();
      final nowIso = DateTime.now().toUtc().toIso8601String();
      final row = await client
          .from('agreement_milestones')
          .update({
            if (asClient) 'client_confirmed_at': nowIso,
            if (!asClient) 'contractor_confirmed_at': nowIso,
          })
          .eq('id', milestoneId)
          .select()
          .single();

      return AgreementMilestone(
        id: row['id'] as String,
        agreementId: row['agreement_id'] as String,
        position: (row['position'] as num).toInt(),
        title: row['title'] as String,
        isDone: row['status'] == 'done',
        clientConfirmedAt: _parseDate(row['client_confirmed_at']),
        contractorConfirmedAt: _parseDate(row['contractor_confirmed_at']),
      );
    });
  }

  Future<ProgressUpdate> submitProgressUpdate({
    required String agreementId,
    String? milestoneId,
    required int percent,
    required String description,
    List<ProgressPhotoUpload> photos = const [],
    bool asDraft = false,
  }) {
    return _guard('No pudimos guardar el avance de la obra.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;

      final uploadedPaths = <String>[];
      final stamp = DateTime.now().millisecondsSinceEpoch;
      for (var i = 0; i < photos.length; i++) {
        final photo = photos[i];
        final safeName = photo.fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        final path = '$agreementId/${stamp}_${i}_$safeName';
        await client.storage.from(_bucket).uploadBinary(
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
          .from('progress_updates')
          .insert({
            'agreement_id': agreementId,
            'milestone_id': ?milestoneId,
            'author_id': userId,
            'percent': percent,
            'description': description,
            'photo_paths': uploadedPaths,
            'status': asDraft ? 'draft' : 'sent',
          })
          .select()
          .single();

      return _fromRow(row);
    });
  }

  ProgressUpdate _fromRow(Map<String, dynamic> row) {
    final rawPaths = row['photo_paths'];
    return ProgressUpdate(
      id: row['id'] as String,
      agreementId: row['agreement_id'] as String,
      milestoneId: row['milestone_id'] as String?,
      authorId: row['author_id'] as String,
      percent: (row['percent'] as num).toInt(),
      description: row['description'] as String? ?? '',
      photoPaths: rawPaths is List
          ? [for (final p in rawPaths) p.toString()]
          : const [],
      status: row['status'] as String? ?? 'sent',
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
