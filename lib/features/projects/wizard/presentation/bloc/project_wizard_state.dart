import '../../../../../core/models/models.dart';
import '../../domain/project_draft.dart';

enum ProjectWizardStatus { initial, editing, publishing, published, failure }

class ProjectWizardState {
  const ProjectWizardState({
    this.status = ProjectWizardStatus.initial,
    this.draft = const ProjectDraft(),
    this.initialProject,
    this.publishedProject,
    this.errorMessage,
  });

  final ProjectWizardStatus status;
  final ProjectDraft draft;
  final Project? initialProject;
  final Project? publishedProject;
  final String? errorMessage;

  static const List<String> stepLabels = [
    'Datos',
    'Medidas',
    'Fotos',
    'Materiales',
    'Presupuesto',
    'Publicar',
  ];

  bool get isPublishing => status == ProjectWizardStatus.publishing;
  bool get isPublished => status == ProjectWizardStatus.published;
  bool get isFailure => status == ProjectWizardStatus.failure;

  ProjectWizardState copyWith({
    ProjectWizardStatus? status,
    ProjectDraft? draft,
    Project? initialProject,
    Project? publishedProject,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProjectWizardState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      initialProject: initialProject ?? this.initialProject,
      publishedProject: publishedProject ?? this.publishedProject,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
