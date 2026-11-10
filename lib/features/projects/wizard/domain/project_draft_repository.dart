import 'project_draft.dart';

/// Repositorio en memoria para persistir el borrador del asistente entre pasos.
abstract class ProjectDraftRepository {
  ProjectDraft? loadDraft({String? projectId});

  void saveDraft(ProjectDraft draft);

  void clearDraft({String? projectId});
}

