import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/widgets/widgets.dart';
import '../../../injection_container.dart';
import '../../supplier/material_price_tier.dart';
import 'contractor_project_detail_screen.dart';
import 'open_projects_bloc.dart';

/// Listado de proyectos abiertos disponibles para que el contratista cotice (22:144423).
class OpenProjectsScreen extends StatelessWidget {
  const OpenProjectsScreen({super.key});

  static Widget withBloc() {
    return BlocProvider<OpenProjectsBloc>(
      create: (_) => sl<OpenProjectsBloc>()..add(const LoadOpenProjects()),
      child: const OpenProjectsScreen(),
    );
  }

  static Route<void> route() {
    return RivetPageRoute<void>(builder: (_) => withBloc());
  }

  @override
  Widget build(BuildContext context) => const _OpenProjectsView();
}

class _OpenProjectsView extends StatefulWidget {
  const _OpenProjectsView();

  @override
  State<_OpenProjectsView> createState() => _OpenProjectsViewState();
}

class _OpenProjectsViewState extends State<_OpenProjectsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenProjectsBloc, OpenProjectsState>(
      builder: (context, state) {
        final filtered = state.filteredProjects;
        final cities = state.availableCities;

        return RivetScaffold(
          title: 'Proyectos\ndisponibles',
          showBackButton: Navigator.of(context).canPop(),
          backgroundImagePath: AppHeroImages.paintRoller,
          body: AppPageBody(
            onRefresh: () async {
              context.read<OpenProjectsBloc>().add(const LoadOpenProjects());
            },
            fixedHeader: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSearchBar(
                  controller: _searchController,
                  hintText: 'Buscar por título, ciudad o barrio...',
                  onChanged: (value) => context.read<OpenProjectsBloc>().add(
                    OpenProjectsSearchChanged(value),
                  ),
                ),
                if (cities.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppSegmentedControl<String>(
                    items: {
                      '': 'Todas',
                      for (final city in cities) city: city,
                    },
                    selected: state.selectedCity ?? '',
                    onChanged: (val) => context.read<OpenProjectsBloc>().add(
                      OpenProjectsCityChanged(val.isEmpty ? null : val),
                    ),
                  ),
                ],
              ],
            ),
            children: [
              if (state.isLoading && state.projects.isEmpty)
                const AppLoadingState(label: 'Cargando proyectos disponibles')
              else if (state.isFailure && state.projects.isEmpty)
                AppErrorState(
                  message:
                      state.errorMessage ??
                      'No pudimos cargar los proyectos disponibles.',
                  onRetry: () => context.read<OpenProjectsBloc>().add(
                    const LoadOpenProjects(),
                  ),
                )
              else if (filtered.isEmpty)
                AppEmptyState(
                  title: state.projects.isEmpty
                      ? 'No hay proyectos abiertos ahora'
                      : 'Sin resultados para tu búsqueda',
                  message: state.projects.isEmpty
                      ? 'Cuando un propietario publique una obra de pintura o estuco, la verás aquí.'
                      : 'Prueba con otro término o limpia el filtro de ciudad.',
                  icon: LucideIcons.search,
                  actionLabel: state.projects.isEmpty ? null : 'Limpiar filtros',
                  onAction: state.projects.isEmpty
                      ? null
                      : () {
                          _searchController.clear();
                          context.read<OpenProjectsBloc>()
                            ..add(const OpenProjectsSearchChanged(''))
                            ..add(const OpenProjectsCityChanged(null));
                        },
                )
              else
                for (final project in filtered) ...[
                  _OpenProjectCard(
                    project: project,
                    onTap: () => Navigator.of(context).push(
                      ContractorProjectDetailScreen.route(project),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        );
      },
    );
  }
}

class _OpenProjectCard extends StatelessWidget {
  const _OpenProjectCard({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
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
                    Text(project.title, style: AppTypography.subheading),
                    const SizedBox(height: 2),
                    Text(
                      '${project.city} · ${project.neighborhood}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const AppBadge(text: 'Abierto', variant: AppBadgeVariant.brand),
            ],
          ),
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              project.description,
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
                size: 15,
                color: AppColors.ink700,
              ),
              const SizedBox(width: 4),
              Text(
                '${project.totalAreaM2.toStringAsFixed(1)} m² · ${project.surfaces.length} muros',
                style: AppTypography.captionStrong,
              ),
              const Spacer(),
              Text(
                project.budgetEstimateCop > 0
                    ? '\$ ${formatCop(project.budgetEstimateCop)}'
                    : 'Por cotizar',
                style: AppTypography.subheading.copyWith(
                  color: AppColors.brand700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.brand700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
