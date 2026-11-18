import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import 'create_project_screen.dart';
import 'presentation/bloc/projects_bloc.dart';
import 'project_detail_screen.dart';
import 'domain/repositories/project_repository.dart';

/// Pantalla de listado y filtrado de proyectos con Clean Architecture y BLoC (P-016).
///
/// Espera un [ProjectsBloc] en el contexto; [withBloc] y [route] lo arman y
/// piden la lista al abrir.
class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({
    super.key,
    this.forContractor = false,
    this.showBidsOnly = false,
  });

  final bool forContractor;
  final bool showBidsOnly;

  /// Pantalla con su [ProjectsBloc] cargando los proyectos.
  static Widget withBloc({bool forContractor = false, bool showBidsOnly = false}) {
    return BlocProvider<ProjectsBloc>(
      create: (context) => resolveBloc<ProjectsBloc>(
        () => ProjectsBloc.fromRepository(context.read<ProjectRepository>()),
      )..add(const LoadProjects()),
      child: MyProjectsScreen(
        forContractor: forContractor,
        showBidsOnly: showBidsOnly,
      ),
    );
  }

  static Route<void> route({bool forContractor = false, bool showBidsOnly = false}) {
    return RivetPageRoute<void>(
      builder: (_) => withBloc(
        forContractor: forContractor,
        showBidsOnly: showBidsOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = forContractor
        ? (showBidsOnly ? 'Mis\npropuestas' : 'Oportunidades')
        : 'Mis\nproyectos';

    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        final projects = state.filteredProjects;

        return RivetScaffold(
          title: title,
          showBackButton: true,
          backgroundImagePath: AppHeroImages.planning,
          body: AppPageBody(
            onRefresh: () async {
              context.read<ProjectsBloc>().add(const LoadProjects());
            },
            fixedHeader: AppSegmentedControl<int>(
              items: {
                0: 'Todos (${state.projects.length})',
                1:
                    'En curso (${state.projects.where((p) => p.status != ProjectStatus.completed).length})',
                2:
                    'Completados (${state.projects.where((p) => p.status == ProjectStatus.completed).length})',
              },
              selected: state.selectedTab,
              onChanged: (val) {
                context.read<ProjectsBloc>().add(FilterProjectsByTab(val));
              },
            ),
            footer: AppButton(
              text: 'Nuevo proyecto',
              icon: LucideIcons.plus,
              showChevron: true,
              onPressed: () => _openCreateProject(context),
            ),
            children: [
              if (state.isWaiting && state.projects.isEmpty)
                const AppLoadingState(label: 'Cargando tus proyectos')
              else if (state.isFailure && state.projects.isEmpty)
                AppErrorState(
                  message:
                      state.errorMessage ?? 'No pudimos cargar tus proyectos.',
                  onRetry: () =>
                      context.read<ProjectsBloc>().add(const LoadProjects()),
                )
              else if (projects.isEmpty)
                AppEmptyState(
                  title: state.selectedTab == 2
                      ? 'No hay proyectos finalizados'
                      : 'Aún no tienes proyectos publicados',
                  message: state.selectedTab == 2
                      ? 'Los proyectos terminados y con confirmación mutua aparecerán aquí.'
                      : 'Publica tu primer proyecto para recibir propuestas de profesionales de tu zona.',
                  icon: state.selectedTab == 2
                      ? LucideIcons.checkCheck
                      : LucideIcons.folderPlus,
                  actionLabel:
                      state.selectedTab == 0 ? 'Publicar proyecto' : null,
                  onAction: state.selectedTab == 0
                      ? () => _openCreateProject(context)
                      : null,
                )
              else
                for (var i = 0; i < projects.length; i++) ...[
                  AppCard(
                    backgroundColor: AppColors.paper100,
                    onTap: () => _openDetail(context, projects[i]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    projects[i].title,
                                    style: AppTypography.subheading,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${projects[i].city} · ${projects[i].neighborhood}',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            AppBadge(
                              text: projects[i].status.label,
                              variant:
                                  projects[i].status == ProjectStatus.published
                                  ? AppBadgeVariant.brand
                                  : AppBadgeVariant.warning,
                            ),
                          ],
                        ),
                        if (projects[i].description.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            projects[i].description,
                            style: AppTypography.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.ruler,
                              size: 16,
                              color: AppColors.brand700,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${projects[i].totalAreaM2.toStringAsFixed(1)} m²',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.captionStrong,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            const Icon(
                              LucideIcons.layers,
                              size: 16,
                              color: AppColors.brand700,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${projects[i].surfaces.length} paredes',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.captionStrong,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (i < projects.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openDetail(BuildContext context, Project project) async {
    final bloc = context.read<ProjectsBloc>();
    await Navigator.of(context).push(ProjectDetailScreen.route(project));
    bloc.add(const LoadProjects());
  }

  Future<void> _openCreateProject(BuildContext context) async {
    final bloc = context.read<ProjectsBloc>();
    final saved = await Navigator.of(context).push(CreateProjectScreen.route());
    if (saved != null) bloc.add(const LoadProjects());
  }
}
