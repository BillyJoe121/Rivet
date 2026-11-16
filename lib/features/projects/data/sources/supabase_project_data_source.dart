import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/models.dart';
import '../../domain/errors/project_failure.dart';
import 'project_row_mapper.dart';

/// Fuente de datos de proyectos en Supabase.
///
/// Cualquier fallo de red, de sesión o de la base se convierte en
/// [ProjectFailure] con un mensaje listo para mostrar.
class SupabaseProjectDataSource {
  SupabaseProjectDataSource(this._client);

  final SupabaseClient? _client;

  static const _select =
      '*, project_spaces(*), client:public_profiles(full_name)';

  static const noConnectionMessage =
      'No pudimos conectarnos con Rivet. Revisa tu conexión e inténtalo de nuevo.';
  static const expiredSessionMessage =
      'Tu sesión venció. Inicia sesión de nuevo.';
  static const loadListMessage =
      'No pudimos cargar tus proyectos. Inténtalo de nuevo.';
  static const loadDetailMessage =
      'No pudimos cargar el proyecto. Inténtalo de nuevo.';
  static const notFoundMessage = 'No encontramos este proyecto.';
  static const createMessage =
      'No pudimos guardar tu proyecto. Inténtalo de nuevo.';
  static const updateMessage =
      'No pudimos guardar los cambios. Inténtalo de nuevo.';

  /// Obtiene los proyectos del cliente con sesión activa.
  Future<List<Project>> getMyProjects({ProjectStatus? status}) {
    return _guard(loadListMessage, () async {
      final client = _requireClient();
      final user = _requireUser(client);

      var query = client.from('projects').select(_select).eq('client_id', user.id);
      if (status != null) {
        query = query.eq('status', projectStatusToDb(status));
      }

      final rows = await query.order('created_at', ascending: false);
      return [
        for (final row in rows) projectFromRow(row),
      ];
    });
  }

  /// Consulta el detalle de un proyecto por ID.
  Future<Project> getProjectDetail(String projectId) {
    return _guard(loadDetailMessage, () async {
      final client = _requireClient();
      _requireUser(client);

      final row = await client
          .from('projects')
          .select(_select)
          .eq('id', projectId)
          .maybeSingle();
      if (row == null) throw const ProjectFailure(notFoundMessage);
      return projectFromRow(row);
    });
  }

  /// Crea un proyecto publicado con sus superficies.
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) {
    return _guard(createMessage, () async {
      final client = _requireClient();
      final user = _requireUser(client);

      final row = await client
          .from('projects')
          .insert({
            'client_id': user.id,
            'title': title,
            'description': description,
            'city': city,
            'neighborhood': neighborhood,
            'status': projectStatusToDb(ProjectStatus.published),
            'budget_estimate_cop': budgetEstimateCop,
          })
          .select(_select)
          .single();

      final projectId = row['id'].toString();
      final spaces = await _insertSurfaces(client, projectId, surfaces);

      final created = projectFromRow({...row, 'project_spaces': spaces});
      return created.copyWith(imageAsset: imageAsset);
    });
  }

  /// Guarda los datos del proyecto y reemplaza sus superficies.
  ///
  /// La lista de materiales y las fotos todavía no tienen tabla propia: se
  /// conservan en el objeto devuelto, pero no se guardan en la base.
  Future<Project> updateProject(Project project) {
    return _guard(updateMessage, () async {
      final client = _requireClient();
      _requireUser(client);

      await client
          .from('projects')
          .update({
            'title': project.title,
            'description': project.description,
            'city': project.city,
            'neighborhood': project.neighborhood,
            'status': projectStatusToDb(project.status),
            'budget_estimate_cop': project.budgetEstimateCop,
            'ai_review_authorized': project.aiReviewAuthorized,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', project.id)
          .select('id')
          .single();

      await client.from('project_spaces').delete().eq('project_id', project.id);
      final spaces = await _insertSurfaces(client, project.id, project.surfaces);

      final saved = projectFromRow({'project_spaces': spaces, 'id': project.id});
      return project.copyWith(surfaces: saved.surfaces);
    });
  }

  Future<List<Map<String, dynamic>>> _insertSurfaces(
    SupabaseClient client,
    String projectId,
    List<SurfaceItem> surfaces,
  ) async {
    if (surfaces.isEmpty) return const [];
    final rows = [
      for (var i = 0; i < surfaces.length; i++)
        surfaceToRow(surfaces[i], projectId: projectId, position: i),
    ];
    return client.from('project_spaces').insert(rows).select();
  }

  SupabaseClient _requireClient() {
    final client = _client;
    if (client == null) throw const ProjectFailure(noConnectionMessage);
    return client;
  }

  User _requireUser(SupabaseClient client) {
    final user = client.auth.currentUser;
    if (user == null) throw const ProjectFailure(expiredSessionMessage);
    return user;
  }

  Future<T> _guard<T>(String message, Future<T> Function() run) async {
    try {
      return await run();
    } on ProjectFailure {
      rethrow;
    } catch (_) {
      throw ProjectFailure(message);
    }
  }
}
