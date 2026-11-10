import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/domain/usecases/create_project_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/get_my_projects_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/get_project_detail_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/update_project_usecase.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';

class FakeProjectRepository implements ProjectRepository {
  List<Project> projects = [];
  Exception? errorToThrow;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async {
    if (errorToThrow != null) throw errorToThrow!;
    if (status != null) {
      return projects.where((p) => p.status == status).toList();
    }
    return List<Project>.from(projects);
  }

  @override
  Future<Project> getProjectDetail(String projectId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return projects.firstWhere((p) => p.id == projectId);
  }

  @override
  Future<Project> createProject({
    required String title,
    required String description,
    required String city,
    required String neighborhood,
    required List<SurfaceItem> surfaces,
    required int budgetEstimateCop,
    String? imageAsset,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    final p = Project(
      id: 'p-new',
      title: title,
      clientName: 'Juan',
      city: city,
      neighborhood: neighborhood,
      surfaces: surfaces,
      status: ProjectStatus.published,
      createdAt: DateTime.now(),
      budgetEstimateCop: budgetEstimateCop,
      description: description,
    );
    projects.add(p);
    return p;
  }

  @override
  Future<Project> updateProject(Project project) async {
    if (errorToThrow != null) throw errorToThrow!;
    projects = [for (final p in projects) p.id == project.id ? project : p];
    return project;
  }
}

void main() {
  late FakeProjectRepository repo;
  late ProjectsBloc bloc;

  final sampleProject = Project(
    id: 'p-1',
    title: 'Pintura Sala',
    clientName: 'Cliente Prueba',
    city: 'Cali',
    neighborhood: 'Granada',
    surfaces: const [
      SurfaceItem(id: 's-1', name: 'Pared 1', widthMeters: 4, heightMeters: 2.5),
    ],
    status: ProjectStatus.published,
    createdAt: DateTime.now(),
  );

  setUp(() {
    repo = FakeProjectRepository();
    repo.projects = [sampleProject];
    bloc = ProjectsBloc(
      GetMyProjectsUseCase(repo),
      CreateProjectUseCase(repo),
      GetProjectDetailUseCase(repo),
      UpdateProjectUseCase(repo),
    );
  });

  test('UpdateProjectSubmitted reemplaza el proyecto en la lista', () async {
    bloc.add(const LoadProjects());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<ProjectsState>().having((s) => s.isSuccess, 'success', true)),
    );

    bloc.add(UpdateProjectSubmitted(sampleProject.copyWith(title: 'Pintura Comedor')));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProjectsState>().having((s) => s.status, 'status', ProjectsStatus.loading),
        isA<ProjectsState>()
            .having((s) => s.status, 'status', ProjectsStatus.success)
            .having((s) => s.projects.length, 'count', 1)
            .having((s) => s.projects.first.title, 'title', 'Pintura Comedor'),
      ]),
    );
  });

  test('UpdateProjectSubmitted emite failure si el título queda vacío', () async {
    bloc.add(UpdateProjectSubmitted(sampleProject.copyWith(title: ' ')));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProjectsState>().having((s) => s.status, 'status', ProjectsStatus.loading),
        isA<ProjectsState>()
            .having((s) => s.status, 'status', ProjectsStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Ingresa un título para el proyecto.'),
      ]),
    );
  });

  test('LoadProjects emite failure y luego se recupera al reintentar', () async {
    repo.errorToThrow = Exception('Sin conexión');
    bloc.add(const LoadProjects());
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<ProjectsState>()
            .having((s) => s.status, 'status', ProjectsStatus.failure)
            .having((s) => s.errorMessage, 'error', 'Sin conexión'),
      ),
    );

    repo.errorToThrow = null;
    bloc.add(const LoadProjects());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<ProjectsState>().having((s) => s.isSuccess, 'success', true)),
    );
  });

  tearDown(() => bloc.close());

  test('estado inicial de ProjectsBloc', () {
    expect(bloc.state.status, ProjectsStatus.initial);
    expect(bloc.state.projects, isEmpty);
    expect(bloc.state.selectedTab, 0);
  });

  test('LoadProjects emite [loading, success] con lista de proyectos', () async {
    bloc.add(const LoadProjects());

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProjectsState>().having((s) => s.status, 'status', ProjectsStatus.loading),
        isA<ProjectsState>()
            .having((s) => s.status, 'status', ProjectsStatus.success)
            .having((s) => s.projects.length, 'count', 1),
      ]),
    );
  });

  test('CreateProjectSubmitted emite [loading, success] y agrega el nuevo proyecto', () async {
    bloc.add(const LoadProjects());
    await expectLater(
      bloc.stream,
      emitsThrough(isA<ProjectsState>().having((s) => s.status, 'status', ProjectsStatus.success)),
    );

    bloc.add(
      const CreateProjectSubmitted(
        title: 'Nuevo Muro',
        description: 'Detalles de obra',
        city: 'Cali',
        neighborhood: 'San Fernando',
        surfaces: [
          SurfaceItem(id: 's-2', name: 'Pared 2', widthMeters: 3, heightMeters: 2),
        ],
        budgetEstimateCop: 500000,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<ProjectsState>().having((s) => s.status, 'status', ProjectsStatus.loading),
        isA<ProjectsState>()
            .having((s) => s.status, 'status', ProjectsStatus.success)
            .having((s) => s.projects.length, 'count', 2)
            .having((s) => s.selectedProject?.title, 'title', 'Nuevo Muro'),
      ]),
    );
  });

  test('FilterProjectsByTab actualiza selectedTab', () async {
    bloc.add(const FilterProjectsByTab(1));

    await expectLater(
      bloc.stream,
      emits(
        isA<ProjectsState>().having((s) => s.selectedTab, 'selectedTab', 1),
      ),
    );
  });
}

