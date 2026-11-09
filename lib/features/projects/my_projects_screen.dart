import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'create_project_screen.dart';
import 'presentation/bloc/projects_bloc.dart';
import 'project_detail_screen.dart';
import 'projects_service.dart';

/// Pantalla de listado y filtrado de proyectos con Clean Architecture y BLoC (P-016).
class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({
    super.key,
    this.forContractor = false,
    this.showBidsOnly = false,
    this.projectsBloc,
  });

  final bool forContractor;
  final bool showBidsOnly;
  final ProjectsBloc? projectsBloc;

  @override
  Widget build(BuildContext context) {
    if (projectsBloc != null) {
      return BlocProvider<ProjectsBloc>.value(
        value: projectsBloc!,
        child: _MyProjectsView(
          forContractor: forContractor,
          showBidsOnly: showBidsOnly,
        ),
      );
    }

    try {
      context.read<ProjectsBloc>();
      return _MyProjectsView(
        forContractor: forContractor,
        showBidsOnly: showBidsOnly,
      );
    } catch (_) {
      return BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(
          ProjectsService.instance.getMyProjectsUseCase,
          ProjectsService.instance.createProjectUseCase,
          ProjectsService.instance.getProjectDetailUseCase,
        )..add(const LoadProjects()),
        child: _MyProjectsView(
          forContractor: forContractor,
          showBidsOnly: showBidsOnly,
        ),
      );
    }
  }
}

class _MyProjectsView extends StatelessWidget {
  const _MyProjectsView({
    required this.forContractor,
    required this.showBidsOnly,
  });

  final bool forContractor;
  final bool showBidsOnly;

  @override
  Widget build(BuildContext context) {
    final title = forContractor
        ? (showBidsOnly ? 'Mis Propuestas' : 'Oportunidades')
        : 'Mis Proyectos';

    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        final projects = state.filteredProjects;

        return RivetScaffold(
          title: title,
          showBackButton: false,
          backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.sm),
              AppSegmentedControl<int>(
                items: {
                  0: 'Todos (${state.projects.length})',
                  1: 'En curso (${state.projects.where((p) => p.status != ProjectStatus.completed).length})',
                  2: 'Completados (${state.projects.where((p) => p.status == ProjectStatus.completed).length})',
                },
                selected: state.selectedTab,
                onChanged: (val) {
                  context.read<ProjectsBloc>().add(FilterProjectsByTab(val));
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isLoading && state.projects.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.brand700),
                    ),
                  ),
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
                  actionLabel: state.selectedTab == 0 ? 'Publicar proyecto' : null,
                  onAction: state.selectedTab == 0
                      ? () => _openCreateProject(context)
                      : null,
                )
              else
                for (final proj in projects)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailScreen(project: proj),
                          ),
                        );
                      },
                      child: AppCard(
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
                                        proj.title,
                                        style: AppTypography.subheading.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${proj.city} · ${proj.neighborhood}',
                                        style: AppTypography.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                AppBadge(
                                  text: proj.status.label,
                                  variant: proj.status == ProjectStatus.published
                                      ? AppBadgeVariant.brand
                                      : AppBadgeVariant.warning,
                                ),
                              ],
                            ),
                            if (proj.description.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                proj.description,
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
                                Text(
                                  '${proj.totalAreaM2.toStringAsFixed(1)} m²',
                                  style: AppTypography.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink900,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                const Icon(
                                  LucideIcons.layers,
                                  size: 16,
                                  color: AppColors.brand700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${proj.surfaces.length} paredes',
                                  style: AppTypography.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: 'Nuevo proyecto',
                icon: LucideIcons.plus,
                onPressed: () => _openCreateProject(context),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        );
      },
    );
  }

  void _openCreateProject(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateProjectScreen(),
      ),
    );
  }
}
