import '../domain/project_draft.dart';
import '../domain/project_draft_repository.dart';

/// Almacén en memoria de sesión para borradores del asistente de proyectos.
///
/// La raíz de la app crea una sola instancia y la comparte por contexto.
class LocalProjectDraftRepository implements ProjectDraftRepository {
  LocalProjectDraftRepository();

  ProjectDraft? _newProjectDraft;
  final Map<String, ProjectDraft> _editDrafts = {};

  @override
  ProjectDraft? loadDraft({String? projectId}) {
    if (projectId != null) {
      return _editDrafts[projectId];
    }
    return _newProjectDraft;
  }

  @override
  void saveDraft(ProjectDraft draft) {
    final id = draft.existingProjectId;
    if (id != null) {
      _editDrafts[id] = draft;
    } else {
      _newProjectDraft = draft;
    }
  }

  @override
  void clearDraft({String? projectId}) {
    if (projectId != null) {
      _editDrafts.remove(projectId);
    } else {
      _newProjectDraft = null;
    }
  }
}

