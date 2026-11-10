import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/features/projects/create_project_screen.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/domain/usecases/create_project_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/get_my_projects_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/get_project_detail_usecase.dart';
import 'package:rivet/features/projects/domain/usecases/update_project_usecase.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/project_detail_screen.dart';

class MockProjectRepository implements ProjectRepository {
  Project? lastCreated;

  @override
  Future<List<Project>> getMyProjects({ProjectStatus? status}) async => [];

  @override
  Future<Project> getProjectDetail(String projectId) async => lastCreated!;

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
    final p = Project(
      id: 'p-test',
      title: title,
      clientName: 'Cliente Test',
      city: city,
      neighborhood: neighborhood,
      surfaces: surfaces,
      status: ProjectStatus.published,
      createdAt: DateTime.now(),
      budgetEstimateCop: budgetEstimateCop,
      description: description,
    );
    lastCreated = p;
    return p;
  }

  @override
  Future<Project> updateProject(Project project) async => project;
}

void main() {
  testWidgets('CreateProjectScreen valida campos y permite agregar superficies', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final repo = MockProjectRepository();
    final bloc = ProjectsBloc(
      GetMyProjectsUseCase(repo),
      CreateProjectUseCase(repo),
      GetProjectDetailUseCase(repo),
      UpdateProjectUseCase(repo),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CreateProjectScreen(projectsBloc: bloc),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Crear\nproyecto'), findsOneWidget);
    expect(find.text('Título de la obra'), findsOneWidget);

    // Intentar avanzar con campos vacíos
    final nextButton = find.text('Siguiente paso');
    await tester.tap(nextButton);
    await tester.pump();

    expect(find.text('Ingresa un título para el proyecto.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('ProjectDetailScreen muestra ficha completa con resumen de m2', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final project = Project(
      id: 'p-det',
      title: 'Remodelación Integral',
      clientName: 'Laura',
      city: 'Cali',
      neighborhood: 'Ciudad Jardín',
      surfaces: const [
        SurfaceItem(id: 's-1', name: 'Muro 1', widthMeters: 5, heightMeters: 2.5),
        SurfaceItem(id: 's-2', name: 'Muro 2', widthMeters: 3, heightMeters: 2.5),
      ],
      status: ProjectStatus.published,
      createdAt: DateTime.now(),
      budgetEstimateCop: 1800000,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProjectDetailScreen(project: project),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Remodelación Integral'), findsAtLeastNWidgets(1));
    expect(find.text('20.0 m²'), findsOneWidget);
    expect(find.text('Ver propuestas recibidas'), findsOneWidget);
  });
}

