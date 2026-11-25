import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import '../supplier/material_price_tier.dart';
import '../supplier/materials_catalog_screen.dart';
import 'presentation/bloc/projects_bloc.dart';

/// Lista editable de materiales de un proyecto para el cliente (P-014).
class ProjectMaterialsScreen extends StatelessWidget {
  const ProjectMaterialsScreen({
    super.key,
    required this.projectId,
    this.initialProject,
  });

  final String projectId;
  final Project? initialProject;

  /// Pantalla con su propio [ProjectsBloc] cargando el detalle del proyecto.
  static Widget withBloc(Project project) {
    return BlocProvider<ProjectsBloc>(
      create: (_) => sl<ProjectsBloc>()..add(LoadProjectDetail(project.id)),
      child: ProjectMaterialsScreen(
        projectId: project.id,
        initialProject: project,
      ),
    );
  }

  static Route<void> route(Project project) {
    return RivetPageRoute<void>(builder: (_) => withBloc(project));
  }

  @override
  Widget build(BuildContext context) {
    return _ProjectMaterialsView(
      projectId: projectId,
      initialProject: initialProject,
    );
  }
}

class _ProjectMaterialsView extends StatelessWidget {
  const _ProjectMaterialsView({
    required this.projectId,
    this.initialProject,
  });

  final String projectId;
  final Project? initialProject;

  Project? _resolveProject(ProjectsState state) {
    for (final p in state.projects) {
      if (p.id == projectId) return p;
    }
    if (state.selectedProject?.id == projectId) {
      return state.selectedProject;
    }
    return initialProject;
  }

  void _updateQuantity(
    BuildContext context,
    Project project,
    String productId,
    int quantity,
  ) {
    final nextMaterials = <ProjectMaterial>[];
    for (final item in project.materials) {
      if (item.productId == productId) {
        if (quantity > 0) {
          nextMaterials.add(item.withQuantity(quantity));
        }
      } else {
        nextMaterials.add(item);
      }
    }
    context.read<ProjectsBloc>().add(
      UpdateProjectSubmitted(project.copyWith(materials: nextMaterials)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        final project = _resolveProject(state);
        final materials = project?.materials ?? const <ProjectMaterial>[];

        return RivetScaffold(
          title: 'Lista de\nmateriales',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.paintShelf,
          body: AppPageBody(
            footer: AppButton(
              text: 'Agregar desde la Bodega Rivet',
              icon: LucideIcons.plus,
              showChevron: true,
              onPressed: () => Navigator.of(context).push(
                MaterialsCatalogScreen.route(preselectedProjectId: projectId),
              ),
            ),
            children: [
              if (project == null && state.isLoading)
                const AppLoadingState(label: 'Cargando materiales del proyecto')
              else if (project == null)
                const AppErrorState(
                  message:
                      'No encontramos el proyecto para mostrar su lista de materiales.',
                )
              else ...[
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: AppTypography.subheading,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${materials.length} referencias seleccionadas',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),
                      AppBadge(
                        text: '\$ ${formatCop(project.materialsTotalCop)} COP',
                        variant: AppBadgeVariant.brand,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (materials.isEmpty)
                  AppEmptyState(
                    title: 'Aún no has agregado materiales',
                    message:
                        'Explora la Bodega Rivet para sumar pinturas, estucos y herramientas a este proyecto.',
                    icon: LucideIcons.paintBucket,
                    actionLabel: 'Ir a la Bodega',
                    onAction: () => Navigator.of(context).push(
                      MaterialsCatalogScreen.route(
                        preselectedProjectId: projectId,
                      ),
                    ),
                  )
                else
                  for (final item in materials) ...[
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: AppTypography.subheading),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.unit} · \$ ${formatCop(item.unitPriceCop)} c/u',
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subtotal: \$ ${formatCop(item.subtotalCop)} COP',
                                  style: AppTypography.labelStrong.copyWith(
                                    color: AppColors.brand700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppQuantityStepper(
                            value: item.quantity,
                            min: 1,
                            onChanged: (next) => _updateQuantity(
                              context,
                              project,
                              item.productId,
                              next,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Quitar material',
                            onPressed: () => _updateQuantity(
                              context,
                              project,
                              item.productId,
                              0,
                            ),
                            icon: const Icon(
                              LucideIcons.trash2,
                              size: 18,
                              color: AppColors.danger700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
              ],
            ],
          ),
        );
      },
    );
  }
}

