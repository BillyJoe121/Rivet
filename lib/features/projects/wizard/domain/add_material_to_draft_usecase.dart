import '../../../../core/models/models.dart';
import 'project_draft_repository.dart';

/// Agrega un material de la Bodega al borrador del proyecto en curso.
///
/// Si el material ya está en el borrador, suma la cantidad nueva a la que
/// había. Devuelve `false` cuando no hay borrador abierto y no guarda nada.
class AddMaterialToDraftUseCase {
  const AddMaterialToDraftUseCase(this._repository);

  final ProjectDraftRepository _repository;

  bool call(ProjectMaterial item) {
    final draft = _repository.loadDraft();
    if (draft == null) return false;

    final next = [...draft.materials];
    final index = next.indexWhere((m) => m.productId == item.productId);
    if (index >= 0) {
      next[index] = next[index].withQuantity(
        next[index].quantity + item.quantity,
      );
    } else {
      next.add(item);
    }
    _repository.saveDraft(draft.copyWith(materials: next));
    return true;
  }
}
