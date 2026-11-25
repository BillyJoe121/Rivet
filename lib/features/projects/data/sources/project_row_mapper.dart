import '../../../../core/models/models.dart';

/// Imagen de referencia que se muestra cuando el proyecto no tiene foto propia.
const kDefaultProjectImageAsset =
    'Fondos/Checklist, plantas y cajas sostenibles.png';

/// Convierte el estado de la base (`draft`, `open`, `in_progress`,
/// `completed`, `cancelled`) al estado del dominio.
ProjectStatus projectStatusFromDb(String? value) {
  return switch (value) {
    'draft' => ProjectStatus.draft,
    'in_progress' => ProjectStatus.inProgress,
    'completed' => ProjectStatus.completed,
    'cancelled' => ProjectStatus.cancelled,
    _ => ProjectStatus.published,
  };
}

/// Convierte el estado del dominio al valor que guarda la base.
String projectStatusToDb(ProjectStatus status) {
  return switch (status) {
    ProjectStatus.draft => 'draft',
    ProjectStatus.published ||
    ProjectStatus.underReview ||
    ProjectStatus.negotiating => 'open',
    ProjectStatus.agreed || ProjectStatus.inProgress => 'in_progress',
    ProjectStatus.completed => 'completed',
    ProjectStatus.cancelled => 'cancelled',
  };
}

/// Fila de `project_spaces` lista para insertar.
Map<String, dynamic> surfaceToRow(
  SurfaceItem surface, {
  required String projectId,
  required int position,
}) {
  return {
    'project_id': projectId,
    'position': position,
    'name': surface.name,
    'width_meters': surface.widthMeters,
    'height_meters': surface.heightMeters,
    'finish_type': surface.finishType,
    'has_defects': surface.hasDefects,
    'photo_url': surface.photoUrl,
  };
}

/// Fila de `project_materials` lista para insertar.
Map<String, dynamic> materialToRow(
  ProjectMaterial material, {
  required String projectId,
  required int position,
}) {
  return {
    'project_id': projectId,
    'product_id': material.productId,
    'position': position,
    'name': material.name,
    'unit': material.unit,
    'unit_price_cop': material.unitPriceCop,
    'quantity': material.quantity,
  };
}

/// Convierte una fila de `projects` (con `project_spaces`, `project_materials`
/// y el perfil público del cliente anidados) al modelo.
Project projectFromRow(Map<String, dynamic> row) {
  final client = row['client'] as Map<String, dynamic>? ?? const {};
  final spaces = [...(row['project_spaces'] as List? ?? const [])]
    ..sort(
      (a, b) => _toInt((a as Map)['position']).compareTo(
        _toInt((b as Map)['position']),
      ),
    );
  final rawMaterials = [...(row['project_materials'] as List? ?? const [])]
    ..sort(
      (a, b) => _toInt((a as Map)['position']).compareTo(
        _toInt((b as Map)['position']),
      ),
    );
  final rawPhotos = row['photo_paths'] as List? ?? const [];
  final photoAssets = [
    for (final path in rawPhotos)
      if (path != null && path.toString().isNotEmpty) path.toString(),
  ];

  return Project(
    id: row['id'].toString(),
    title: row['title'] as String? ?? '',
    clientName: client['full_name'] as String? ?? '',
    city: row['city'] as String? ?? '',
    neighborhood: row['neighborhood'] as String? ?? '',
    surfaces: [
      for (final space in spaces.cast<Map<String, dynamic>>())
        SurfaceItem(
          id: space['id'].toString(),
          name: space['name'] as String? ?? '',
          widthMeters: _toDouble(space['width_meters']),
          heightMeters: _toDouble(space['height_meters']),
          finishType: space['finish_type'] as String? ?? 'Vinilo Tipo 1',
          hasDefects: space['has_defects'] as bool? ?? false,
          photoUrl: space['photo_url'] as String?,
        ),
    ],
    materials: [
      for (final mat in rawMaterials.cast<Map<String, dynamic>>())
        ProjectMaterial(
          productId: mat['product_id']?.toString() ?? mat['id'].toString(),
          name: mat['name'] as String? ?? '',
          unit: mat['unit'] as String? ?? 'unidad',
          unitPriceCop: _toInt(mat['unit_price_cop']),
          quantity: _toInt(mat['quantity']),
        ),
    ],
    status: projectStatusFromDb(row['status'] as String?),
    createdAt:
        DateTime.tryParse(row['created_at']?.toString() ?? '') ??
        DateTime.now(),
    budgetEstimateCop: _toInt(row['budget_estimate_cop']),
    description: row['description'] as String? ?? '',
    imageAsset: photoAssets.isNotEmpty
        ? photoAssets.first
        : kDefaultProjectImageAsset,
    photoAssets: photoAssets,
    aiReviewAuthorized: row['ai_review_authorized'] as bool? ?? false,
  );
}

double _toDouble(Object? value) => switch (value) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s) ?? 0,
  _ => 0,
};

int _toInt(Object? value) => _toDouble(value).round();
