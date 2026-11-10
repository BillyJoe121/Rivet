import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/core/widgets/widgets.dart';
import 'package:rivet/features/home/app_shell.dart';
import 'package:rivet/features/projects/my_projects_screen.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/project_detail_screen.dart';
import 'package:rivet/features/projects/projects_service.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';
import 'package:rivet/features/proposals/proposals_service.dart';
import 'package:rivet/features/supplier/catalog_service.dart';
import 'package:rivet/features/supplier/materials_catalog_screen.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProjectsBloc>(
            create: (_) => ProjectsBloc(
              ProjectsService.instance.getMyProjectsUseCase,
              ProjectsService.instance.createProjectUseCase,
              ProjectsService.instance.getProjectDetailUseCase,
              ProjectsService.instance.updateProjectUseCase,
            )..add(const LoadProjects()),
          ),
          BlocProvider<ProposalsBloc>(
            create: (_) => ProposalsBloc(
              ProposalsService.instance.getReceivedProposalsUseCase,
              ProposalsService.instance.acceptProposalUseCase,
            )..add(const LoadReceivedProposals()),
          ),
          BlocProvider<CatalogBloc>(
            create: (_) => CatalogBloc(
              CatalogService.instance.getCatalogMaterialsUseCase,
            )..add(const LoadCatalogProducts()),
          ),
        ],
        child: const MaterialApp(home: AppShell(initialRole: UserRole.client)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openProjectDetail(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.chevron_right).first);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);
  }

  testWidgets('La barra sigue visible en una pantalla interna', (tester) async {
    await pumpShell(tester);
    await openProjectDetail(tester);

    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.text('Bodega').hitTestable(), findsOneWidget);
  });

  testWidgets('Tocar un botón de la barra inferior siempre lleva a la pantalla raíz de esa sección', (tester) async {
    await pumpShell(tester);
    await openProjectDetail(tester);

    await tester.tap(find.text('Bodega'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialsCatalogScreen), findsOneWidget);
    expect(find.byType(ProjectDetailScreen), findsNothing);

    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsNothing);
    expect(find.text('Tus proyectos'), findsOneWidget);
  });

  testWidgets('Tocar el destino activo vuelve a su primera pantalla', (tester) async {
    await pumpShell(tester);
    await openProjectDetail(tester);

    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsNothing);
    expect(find.text('Tus proyectos'), findsOneWidget);
  });

  testWidgets('Atrás del sistema cierra la pantalla interna y luego vuelve a Inicio', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Proyectos'));
    await tester.pumpAndSettle();
    expect(find.byType(MyProjectsScreen), findsOneWidget);

    await tester.tap(find.byType(AppCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectDetailScreen), findsNothing);
    expect(find.byType(MyProjectsScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MyProjectsScreen), findsNothing);
    expect(find.text('Tus proyectos'), findsOneWidget);
  });

  testWidgets('Atrás del sistema cierra primero el panel Más', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsNothing);
    expect(find.text('Tus proyectos'), findsOneWidget);
  });

  testWidgets('Tocar una zona vacía oculta el teclado', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => KeyboardDismisser(child: child!),
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: focusNode),
              const SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(200, 500));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });
}
