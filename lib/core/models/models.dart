/// Enumerador de roles de usuario en Rivet.
enum UserRole {
  client(
    label: 'Cliente',
    description: 'Describe tu espacio con fotos y medidas para recibir ofertas claras.',
  ),
  contractor(
    label: 'Contratista',
    description: 'Postula ofertas separando tu mano de obra del costo de materiales.',
  ),
  supplier(
    label: 'Proveedor / Ferretería',
    description: 'Publica tu catálogo de materiales y administra tarifas para profesionales.',
  );

  const UserRole({required this.label, required this.description});
  final String label;
  final String description;
}

/// Estado de un proyecto en su ciclo de vida.
enum ProjectStatus {
  draft('Borrador'),
  published('Publicado'),
  underReview('En revisión'),
  negotiating('En negociación'),
  agreed('Acuerdo fijado'),
  inProgress('En ejecución'),
  completed('Finalizado');

  const ProjectStatus(this.label);
  final String label;
}

/// Medidas y especificación de una superficie individual.
class SurfaceItem {
  const SurfaceItem({
    required this.id,
    required this.name,
    required this.widthMeters,
    required this.heightMeters,
    this.finishType = 'Vinilo Tipo 1',
    this.hasDefects = false,
    this.photoUrl,
  });

  final String id;
  final String name;
  final double widthMeters;
  final double heightMeters;
  final String finishType;
  final bool hasDefects;
  final String? photoUrl;

  double get areaM2 => widthMeters * heightMeters;
}

/// Renglón de la lista de materiales de un proyecto.
class ProjectMaterial {
  const ProjectMaterial({
    required this.productId,
    required this.name,
    required this.unit,
    required this.unitPriceCop,
    required this.quantity,
  });

  final String productId;
  final String name;
  final String unit;
  final int unitPriceCop;
  final int quantity;

  int get subtotalCop => unitPriceCop * quantity;

  ProjectMaterial withQuantity(int value) => ProjectMaterial(
        productId: productId,
        name: name,
        unit: unit,
        unitPriceCop: unitPriceCop,
        quantity: value,
      );
}

/// Proyecto de pintura o estuco.
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.clientName,
    required this.city,
    required this.neighborhood,
    required this.surfaces,
    required this.status,
    required this.createdAt,
    this.budgetEstimateCop = 0,
    this.description = '',
    this.imageAsset,
    this.photoAssets = const [],
    this.materials = const [],
    this.aiReviewAuthorized = false,
  });

  final String id;
  final String title;
  final String clientName;
  final String city;
  final String neighborhood;
  final List<SurfaceItem> surfaces;
  final ProjectStatus status;
  final DateTime createdAt;
  final int budgetEstimateCop;
  final String description;

  /// Foto de referencia del espacio (asset de `Fondos/`).
  final String? imageAsset;

  /// Fotos del espacio aportadas por el cliente.
  final List<String> photoAssets;

  /// Lista de materiales del proyecto (estimada o armada desde la Bodega).
  final List<ProjectMaterial> materials;

  /// El cliente autorizó la revisión asistida de sus fotos.
  final bool aiReviewAuthorized;

  double get totalAreaM2 => surfaces.fold(0.0, (acc, s) => acc + s.areaM2);

  int get materialsTotalCop =>
      materials.fold(0, (acc, m) => acc + m.subtotalCop);

  Project copyWith({
    String? title,
    String? city,
    String? neighborhood,
    List<SurfaceItem>? surfaces,
    ProjectStatus? status,
    int? budgetEstimateCop,
    String? description,
    String? imageAsset,
    List<String>? photoAssets,
    List<ProjectMaterial>? materials,
    bool? aiReviewAuthorized,
  }) {
    return Project(
      id: id,
      title: title ?? this.title,
      clientName: clientName,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      surfaces: surfaces ?? this.surfaces,
      status: status ?? this.status,
      createdAt: createdAt,
      budgetEstimateCop: budgetEstimateCop ?? this.budgetEstimateCop,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      photoAssets: photoAssets ?? this.photoAssets,
      materials: materials ?? this.materials,
      aiReviewAuthorized: aiReviewAuthorized ?? this.aiReviewAuthorized,
    );
  }
}

/// Perfil de contratista profesional.
class Contractor {
  const Contractor({
    required this.id,
    required this.name,
    required this.trade,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    required this.zone,
    this.isVerified = true,
    this.portfolioImages = const [],
    this.bio = '',
  });

  final String id;
  final String name;
  final String trade;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final String zone;
  final bool isVerified;
  final List<String> portfolioImages;
  final String bio;
}

/// Propuesta o cotización formal sobre un proyecto.
class Proposal {
  const Proposal({
    required this.id,
    required this.projectId,
    required this.contractor,
    required this.laborCostCop,
    required this.materialsCostCop,
    required this.estimatedDays,
    required this.status,
    this.observations = '',
  });

  final String id;
  final String projectId;
  final Contractor contractor;
  final int laborCostCop;
  final int materialsCostCop;
  final int estimatedDays;
  final String status; // 'Recibida', 'Aceptada', 'En revisión'
  final String observations;

  int get totalCostCop => laborCostCop + materialsCostCop;
}

/// Material de la Bodega Rivet. Tiene un precio para clientes y otro, menor,
/// para contratistas verificados.
class MaterialProduct {
  const MaterialProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.unit,
    required this.clientPriceCop,
    required this.proPriceCop,
    this.finish,
    this.inStock = true,
    this.imageAsset,
    this.presentation,
    this.description = '',
    this.coverageM2,
  });

  final String id;
  final String name;
  final String brand;
  final String category;

  /// Unidad de venta en minúsculas, por ejemplo "galón" o "m²".
  final String unit;
  final int clientPriceCop;
  final int proPriceCop;

  /// Tipo de acabado (mate, satinado…); null cuando no aplica al material.
  final String? finish;
  final bool inStock;
  final String? imageAsset;

  /// Presentación comercial, por ejemplo "Galón 3,78 L" o "Bulto 25 kg".
  final String? presentation;
  final String description;

  /// Rendimiento aproximado por unidad a una mano; null cuando no aplica.
  final double? coverageM2;
}
