import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

/// Fuente de datos de proyectos conectada a Supabase con memoria transaccional de respaldo.
class SupabaseProjectDataSource {
  SupabaseProjectDataSource(this._client);

  final SupabaseClient? _client;

  // Almacén en memoria para permitir persistencia local en pruebas y sesión actual
  final List<Project> _localProjects = List.from(MockData.projects);
  bool _useLocalFastPath = false;

  /// Obtiene los proyectos del cliente.
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async {
    final client = _client;
    final currentUserId = client?.auth.currentUser?.id;

    if (!_useLocalFastPath && client != null && currentUserId != null) {
      try {
        var query = client
            .from('projects')
            .select('*, project_spaces(*)')
            .eq('client_id', currentUserId);

        if (status != null) {
          query = query.eq('status', status.name);
        }

        final data = await query
            .order('created_at', ascending: false)
            .timeout(const Duration(milliseconds: 900));
        final list = (data as List)
            .map((item) => _mapFromSupabase(item as Map<String, dynamic>))
            .toList();

        if (list.isNotEmpty) return list;
        _useLocalFastPath = true;
      } catch (_) {
        // Fallback a almacenamiento local si la tabla aún no existe o está offline
        _useLocalFastPath = true;
      }
    }

    if (status != null) {
      return _localProjects.where((p) => p.status == status).toList();
    }
    return List.unmodifiable(_localProjects);
  }

  /// Consulta el detalle de un proyecto por ID.
  Future<Project> getProjectDetail(String projectId) async {
    final client = _client;
    if (!_useLocalFastPath && client != null) {
      try {
        final data = await client
            .from('projects')
            .select('*, project_spaces(*)')
            .eq('id', projectId)
            .maybeSingle()
            .timeout(const Duration(milliseconds: 900));

        if (data != null) {
          return _mapFromSupabase(data);
        }
      } catch (_) {
        _useLocalFastPath = true;
      }
    }

    final local = _localProjects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => _localProjects.first,
    );
    return local;
  }

  /// Crea un nuevo proyecto.
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) async {
    final client = _client;
    final currentUserId = client?.auth.currentUser?.id ?? 'client-local';

    final newProject = Project(
      id: 'proj-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      clientName: client?.auth.currentUser?.userMetadata?['full_name'] as String? ?? 'Cliente Rivet',
      city: city,
      neighborhood: neighborhood,
      surfaces: surfaces,
      status: ProjectStatus.published,
      createdAt: DateTime.now(),
      budgetEstimateCop: budgetEstimateCop,
      description: description,
      imageAsset: imageAsset ?? 'Fondos/Checklist, plantas y cajas sostenibles.png',
    );

    if (client != null && client.auth.currentUser != null) {
      try {
        await client.from('projects').insert({
          'id': newProject.id,
          'client_id': currentUserId,
          'title': title,
          'description': description,
          'city': city,
          'neighborhood': neighborhood,
          'status': 'published',
          'budget_estimate_cop': budgetEstimateCop,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      } catch (_) {}
    }

    _localProjects.insert(0, newProject);
    return newProject;
  }

  /// Guarda los cambios de un proyecto en la memoria de la sesión.
  Future<Project> updateProject(Project project) async {
    final index = _localProjects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      _localProjects[index] = project;
    } else {
      _localProjects.insert(0, project);
    }
    return project;
  }

  Project _mapFromSupabase(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'published';
    final status = ProjectStatus.values.firstWhere(
      (s) => s.name == statusStr,
      orElse: () => ProjectStatus.published,
    );

    final spacesData = json['project_spaces'] as List? ?? [];
    final surfaces = spacesData.map((s) {
      final sMap = s as Map<String, dynamic>;
      return SurfaceItem(
        id: sMap['id']?.toString() ?? 'space-1',
        name: sMap['name'] as String? ?? 'Pared',
        widthMeters: (sMap['width_meters'] as num?)?.toDouble() ?? 3.0,
        heightMeters: (sMap['height_meters'] as num?)?.toDouble() ?? 2.5,
        finishType: sMap['finish_type'] as String? ?? 'Vinilo Tipo 1',
      );
    }).toList();

    return Project(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Proyecto',
      clientName: json['client_name'] as String? ?? 'Cliente',
      city: json['city'] as String? ?? 'Cali',
      neighborhood: json['neighborhood'] as String? ?? '',
      surfaces: surfaces.isEmpty
          ? [const SurfaceItem(id: 's-1', name: 'Área general', widthMeters: 4.0, heightMeters: 2.5)]
          : surfaces,
      status: status,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      budgetEstimateCop: (json['budget_estimate_cop'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      imageAsset: 'Fondos/Checklist, plantas y cajas sostenibles.png',
    );
  }
}

