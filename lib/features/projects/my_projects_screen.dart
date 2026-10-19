import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'create_project_screen.dart';
import 'project_detail_screen.dart';
import '../proposals/create_proposal_screen.dart';

/// Pantalla de listado y filtrado de proyectos con diseño editorial y fondo orgánico (P-016 / P-017).
class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({
    super.key,
    this.forContractor = false,
    this.showBidsOnly = false,
  });

  final bool forContractor;
  final bool showBidsOnly;

  @override
  State<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final title = widget.forContractor
        ? (widget.showBidsOnly ? 'Mis Propuestas' : 'Oportunidades')
        : 'Mis Proyectos';

    final projects = MockData.projects;

    return RivetScaffold(
      title: title,
      showBackButton: false,
      backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
      actions: [
        if (!widget.forContractor)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.brand700, size: 24),
            tooltip: 'Crear solicitud',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
              );
            },
          ),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppSegmentedControl<int>(
            items: const {
              0: 'Todos (2)',
              1: 'En curso (1)',
              2: 'Completados (0)',
            },
            selected: _selectedFilter,
            onChanged: (val) => setState(() => _selectedFilter = val),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (_selectedFilter == 2)
            const AppEmptyState(
              title: 'No hay proyectos finalizados',
              message: 'Los proyectos terminados y con confirmación mutua aparecerán aquí.',
              icon: Icons.assignment_turned_in_outlined,
            )
          else ...[
            ...projects.map((proj) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(
                            project: proj,
                            isContractorView: widget.forContractor,
                          ),
                        ),
                      );
                    },
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
                                    style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${proj.city} · ${proj.neighborhood}', style: AppTypography.caption),
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
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          proj.description,
                          style: AppTypography.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            const Icon(Icons.square_foot, size: 16, color: AppColors.brand700),
                            const SizedBox(width: 4),
                            Text(
                              '${proj.totalAreaM2.toStringAsFixed(1)} m²',
                              style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink900),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            const Icon(Icons.layers_outlined, size: 16, color: AppColors.brand700),
                            const SizedBox(width: 4),
                            Text(
                              '${proj.surfaces.length} paredes',
                              style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink900),
                            ),
                          ],
                        ),
                        if (widget.forContractor && !widget.showBidsOnly) ...[
                          const SizedBox(height: AppSpacing.md),
                          AppButton(
                            text: 'Postular Cotización',
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.sm,
                            trailingIcon: Icons.chevron_right,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateProposalScreen(project: proj),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
          ],
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
