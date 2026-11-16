import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/projects/contractor/open_projects_bloc.dart';
import 'package:rivet/features/projects/domain/errors/project_failure.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/domain/usecases/get_open_projects_usecase.dart';

class _FakeOpenProjectRepo implements ProjectRepository {
  List<Project> openProjects = [];
  Object? error;

  @override
  Future<List<Project>> getOpenProjects() async {
    if (error != null) throw error!;
    return openProjects;
  }

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async => [];

  @override
  Future<Project> getProjectDetail(String projectId) =>
      throw UnimplementedError();

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) => throw UnimplementedError();

  @override
  Future<Project> updateProject(Project project) => throw UnimplementedError();
}

void main() {
  test('OpenProjectsBloc emite [loading, success] y filtra por ciudad', () async {
    final repo = _FakeOpenProjectRepo()
      ..openProjects = [
        Project(
          id: 'p1',
          title: 'Sala Norte',
          clientName: 'Ana',
          city: 'Cali',
          neighborhood: 'Granada',
          surfaces: const [],
          status: ProjectStatus.published,
          createdAt: DateTime(2026),
        ),
        Project(
          id: 'p2',
          title: 'Cocina Centro',
          clientName: 'Luis',
          city: 'Bogotá',
          neighborhood: 'Chapinero',
          surfaces: const [],
          status: ProjectStatus.published,
          createdAt: DateTime(2026),
        ),
      ];
    final bloc = OpenProjectsBloc(GetOpenProjectsUseCase(repo));
    addTearDown(bloc.close);

    bloc.add(const LoadOpenProjects());
    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<OpenProjectsState>()
            .having((s) => s.status, 'status', OpenProjectsStatus.loading),
        isA<OpenProjectsState>()
            .having((s) => s.status, 'status', OpenProjectsStatus.success)
            .having((s) => s.filteredProjects.length, 'count', 2),
      ]),
    );

    bloc.add(const OpenProjectsCityChanged('Cali'));
    await expectLater(
      bloc.stream,
      emits(
        isA<OpenProjectsState>()
            .having((s) => s.filteredProjects.length, 'filtered', 1)
            .having((s) => s.filteredProjects.first.id, 'id', 'p1'),
      ),
    );
  });

  test('OpenProjectsBloc emite [loading, failure] cuando falla', () async {
    final repo = _FakeOpenProjectRepo()
      ..error = const ProjectFailure('Sin conexión');
    final bloc = OpenProjectsBloc(GetOpenProjectsUseCase(repo));
    addTearDown(bloc.close);

    bloc.add(const LoadOpenProjects());
    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<OpenProjectsState>()
            .having((s) => s.status, 'status', OpenProjectsStatus.loading),
        isA<OpenProjectsState>()
            .having((s) => s.status, 'status', OpenProjectsStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Sin conexión'),
      ]),
    );
  });
}
