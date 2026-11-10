import '../../../../core/models/models.dart';

/// Borrador del asistente de 6 pasos para crear o editar un proyecto (P-008..P-015).
class ProjectDraft {
  const ProjectDraft({
    this.existingProjectId,
    this.title = '',
    this.description = '',
    this.city = 'Cali',
    this.neighborhood = '',
    this.surfaces = const [
      SurfaceItem(
        id: 's-init',
        name: 'Pared principal sala',
        widthMeters: 4.0,
        heightMeters: 2.5,
        finishType: 'Vinilo Tipo 1',
      ),
    ],
    this.photoAssets = const [
      'assets/hero/hero_living_room.jpg',
    ],
    this.aiReviewAuthorized = false,
    this.materials = const [],
    this.materialsBudgetCop,
    this.laborBudgetCop,
    this.budgetEstimateCop = 0,
    this.currentStep = 0,
  });

  factory ProjectDraft.fromProject(Project project) {
    final matsTotal = project.materialsTotalCop;
    final initialLabor = project.budgetEstimateCop > matsTotal
        ? project.budgetEstimateCop - matsTotal
        : null;
    return ProjectDraft(
      existingProjectId: project.id,
      title: project.title,
      description: project.description,
      city: project.city,
      neighborhood: project.neighborhood,
      surfaces: project.surfaces.isEmpty
          ? const [
              SurfaceItem(
                id: 's-init',
                name: 'Pared principal sala',
                widthMeters: 4.0,
                heightMeters: 2.5,
                finishType: 'Vinilo Tipo 1',
              ),
            ]
          : project.surfaces,
      photoAssets: project.photoAssets.isNotEmpty
          ? project.photoAssets
          : [
              project.imageAsset ?? 'assets/hero/hero_living_room.jpg',
            ],
      aiReviewAuthorized: project.aiReviewAuthorized,
      materials: project.materials,
      materialsBudgetCop: matsTotal > 0 ? matsTotal : null,
      laborBudgetCop: initialLabor,
      budgetEstimateCop: project.budgetEstimateCop,
      currentStep: 0,
    );
  }

  final String? existingProjectId;
  final String title;
  final String description;
  final String city;
  final String neighborhood;
  final List<SurfaceItem> surfaces;
  final List<String> photoAssets;
  final bool aiReviewAuthorized;
  final List<ProjectMaterial> materials;
  final int? materialsBudgetCop;
  final int? laborBudgetCop;
  final int budgetEstimateCop;
  final int currentStep;

  bool get isEditing => existingProjectId != null;

  double get totalAreaM2 =>
      surfaces.fold<double>(0, (sum, item) => sum + item.areaM2);

  int get materialsTotalCop =>
      materials.fold<int>(0, (sum, item) => sum + item.subtotalCop);

  int get recommendedLaborCop => (totalAreaM2 * 22000).round();

  int get effectiveMaterialsBudgetCop =>
      materialsBudgetCop ?? materialsTotalCop;

  int get effectiveLaborBudgetCop => laborBudgetCop ?? recommendedLaborCop;

  int get totalBudgetCop =>
      effectiveMaterialsBudgetCop + effectiveLaborBudgetCop;

  int get recommendedTotalBudgetCop => totalBudgetCop;

  ProjectDraft copyWith({
    String? existingProjectId,
    String? title,
    String? description,
    String? city,
    String? neighborhood,
    List<SurfaceItem>? surfaces,
    List<String>? photoAssets,
    bool? aiReviewAuthorized,
    List<ProjectMaterial>? materials,
    int? materialsBudgetCop,
    int? laborBudgetCop,
    int? budgetEstimateCop,
    int? currentStep,
  }) {
    return ProjectDraft(
      existingProjectId: existingProjectId ?? this.existingProjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      surfaces: surfaces ?? this.surfaces,
      photoAssets: photoAssets ?? this.photoAssets,
      aiReviewAuthorized: aiReviewAuthorized ?? this.aiReviewAuthorized,
      materials: materials ?? this.materials,
      materialsBudgetCop: materialsBudgetCop ?? this.materialsBudgetCop,
      laborBudgetCop: laborBudgetCop ?? this.laborBudgetCop,
      budgetEstimateCop: budgetEstimateCop ?? this.budgetEstimateCop,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
