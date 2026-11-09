import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/models/models.dart';
import 'package:rivet/core/widgets/app_back_button.dart';
import 'package:rivet/features/home/app_shell.dart';
import 'package:rivet/features/home/widgets/kit/kit.dart';
import 'package:rivet/features/projects/my_projects_screen.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/project_detail_screen.dart';
import 'package:rivet/features/projects/projects_service.dart';
import 'package:rivet/features/supplier/catalog_service.dart';
import 'package:rivet/features/supplier/materials_catalog_screen.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester, UserRole role) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProjectsBloc>(
            create: (_) => ProjectsBloc(
              ProjectsService.instance.getMyProjectsUseCase,
              ProjectsService.instance.createProjectUseCase,
              ProjectsService.instance.getProjectDetailUseCase,
            ),
          ),
          BlocProvider<CatalogBloc>(
            create: (_) => CatalogBloc(
              CatalogService.instance.getCatalogMaterialsUseCase,
            ),
          ),
        ],
        child: MaterialApp(home: AppShell(initialRole: role)),
      ),
    );
    await tester.pumpAndSettle();
  }

  // La pantalla en construcción anima en bucle: pumpAndSettle no terminaría.
  Future<void> advance(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('Más abre el panel sin cambiar la pantalla y lo cierra al tocar fuera', (tester) async {
    await pumpShell(tester, UserRole.client);

    expect(find.text('Tus proyectos'), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsNothing);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsOneWidget);
    expect(find.text('Tus proyectos'), findsOneWidget);

    await tester.tapAt(const Offset(20, 200));
    await tester.pumpAndSettle();
    expect(find.text('Mi perfil').hitTestable(), findsNothing);
  });

  testWidgets('Un destino del panel sin construir muestra la pantalla en construcción', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Propuestas'));
    await advance(tester);

    expect(find.text('Pantalla en construcción'), findsOneWidget);
    expect(find.text('Esta sección aún no está disponible.'), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsNothing);
    // Pestaña raíz del shell: sin botón volver.
    expect(find.bySemanticsLabel('Volver'), findsNothing);
  });

  testWidgets('Ver todos lleva a la pestaña Proyectos (MyProjectsScreen)', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.text('Ver todos'));
    await tester.pumpAndSettle();

    expect(find.byType(MyProjectsScreen), findsOneWidget);
  });

  testWidgets('Una tarjeta de proyecto abre ProjectDetailScreen con volver', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.byIcon(Icons.chevron_right).first);
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.bySemanticsLabel('Volver'), findsOneWidget);
  });

  testWidgets('Pestaña Contratistas está en construcción y Bodega abre MaterialsCatalogScreen', (tester) async {
    await pumpShell(tester, UserRole.client);

    await tester.tap(find.text('Contratistas'));
    await advance(tester);
    expect(find.text('Pantalla en construcción'), findsOneWidget);

    await tester.tap(find.text('Bodega'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialsCatalogScreen), findsOneWidget);
  });

  testWidgets('El contratista tiene Bodega y Mi perfil en Más', (tester) async {
    await pumpShell(tester, UserRole.contractor);

    await tester.tap(find.text('Más'));
    await tester.pumpAndSettle();

    expect(find.text('Bodega').hitTestable(), findsOneWidget);
    expect(find.text('Mi perfil').hitTestable(), findsOneWidget);

    await tester.tap(find.text('Bodega'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialsCatalogScreen), findsOneWidget);
  });

  testWidgets('El inicio del contratista no tiene accesos rápidos ni avatar', (tester) async {
    await pumpShell(tester, UserRole.contractor);

    expect(find.text('Proyectos disponibles'), findsNothing);
    expect(find.text('Trabajos activos'), findsNothing);
    expect(find.byType(ProInitialsAvatar), findsNothing);
  });

  for (final role in [UserRole.client, UserRole.contractor]) {
    testWidgets('La campana del inicio (${role.name}) abre Notificaciones en construcción', (tester) async {
      await pumpShell(tester, role);

      await tester.tap(find.bySemanticsLabel('Notificaciones'));
      await advance(tester);

      expect(find.text('Notificaciones'), findsOneWidget);
      expect(find.text('Pantalla en construcción'), findsOneWidget);
    });
  }

  testWidgets('Una entrada de actividad reciente abre la pantalla en construcción', (tester) async {
    await pumpShell(tester, UserRole.contractor);

    final row = find.byType(ProOptionRow).at(1);
    await tester.ensureVisible(row);
    await tester.tap(row);
    await advance(tester);

    expect(find.text('Pantalla en construcción'), findsOneWidget);
  });

  for (final role in [UserRole.client, UserRole.contractor]) {
    testWidgets('Mi perfil (${role.name}): Editar abre construcción y volver regresa a Inicio', (tester) async {
      tester.view.physicalSize = const Size(412, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpShell(tester, role);
      final homeMarker = role == UserRole.client ? 'Tus proyectos' : 'Mi trabajo en curso';
      expect(find.text(homeMarker), findsOneWidget);

      await tester.tap(find.text('Más'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mi perfil'));
      await tester.pumpAndSettle();
      expect(find.text('Información personal'), findsOneWidget);

      // Editar abre la pantalla en construcción y se puede volver.
      await tester.tap(find.text('Editar'));
      await advance(tester);
      expect(find.text('Pantalla en construcción'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Volver'));
      await advance(tester);
      expect(find.text('Información personal'), findsOneWidget);

      // El botón volver del perfil lleva a Inicio dentro del shell.
      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();
      expect(find.text(homeMarker), findsOneWidget);
      expect(find.text('Información personal'), findsNothing);
    });
  }
}
