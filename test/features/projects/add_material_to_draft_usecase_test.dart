import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/projects/wizard/domain/add_material_to_draft_usecase.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft_repository.dart';

/// Repositorio de borradores falso que registra cada guardado.
class FakeProjectDraftRepository implements ProjectDraftRepository {
  FakeProjectDraftRepository([this.draft]);

  ProjectDraft? draft;
  int saves = 0;

  @override
  ProjectDraft? loadDraft({String? projectId}) => draft;

  @override
  void saveDraft(ProjectDraft draft) {
    saves++;
    this.draft = draft;
  }

  @override
  void clearDraft({String? projectId}) => draft = null;
}

const _paint = ProjectMaterial(
  productId: 'pintura-1',
  name: 'Pintura Tipo 1',
  unit: 'galón',
  unitPriceCop: 60000,
  quantity: 2,
);

void main() {
  test('agrega un material nuevo al borrador en curso', () {
    final repository = FakeProjectDraftRepository(const ProjectDraft());

    final added = AddMaterialToDraftUseCase(repository)(_paint);

    expect(added, isTrue);
    expect(repository.saves, 1);
    expect(repository.draft!.materials, hasLength(1));
    expect(repository.draft!.materials.single.quantity, 2);
  });

  test('suma la cantidad cuando el material ya estaba en el borrador', () {
    final repository = FakeProjectDraftRepository(
      const ProjectDraft(materials: [_paint]),
    );

    AddMaterialToDraftUseCase(repository)(_paint.withQuantity(3));

    expect(repository.draft!.materials, hasLength(1));
    expect(repository.draft!.materials.single.quantity, 5);
  });

  test('sin borrador abierto no guarda nada y avisa con false', () {
    final repository = FakeProjectDraftRepository();

    final added = AddMaterialToDraftUseCase(repository)(_paint);

    expect(added, isFalse);
    expect(repository.saves, 0);
    expect(repository.draft, isNull);
  });
}
