import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../messaging/messaging_screens.dart';
import '../proposals/received_proposals_screen.dart';
import '../supplier/material_price_tier.dart';
import 'create_project_screen.dart';
import 'presentation/bloc/projects_bloc.dart';
import 'project_materials_screen.dart';

/// Ficha completa y expediente del proyecto para el cliente (P-013).
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  final Project project;

  Project _resolveLiveProject(BuildContext context) {
    try {
      final state = context.watch<ProjectsBloc>().state;
      for (final item in state.projects) {
        if (item.id == project.id) return item;
      }
      if (state.selectedProject?.id == project.id) {
        return state.selectedProject!;
      }
    } catch (_) {}
    return project;
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = _resolveLiveProject(context);

    return RivetScaffold(
      title: 'Detalle del\nproyecto',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.lounge,
      body: AppPageBody(
        footer: AppButton(
          text: 'Ver propuestas recibidas',
          showChevron: true,
          onPressed: () => AppNavigator.push(
            context,
            ReceivedProposalsScreen(projectId: currentProject.id),
          ),
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentProject.title,
                            style: AppTypography.sectionTitle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${currentProject.city} · ${currentProject.neighborhood}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppBadge(
                      text: currentProject.status.label,
                      variant: currentProject.status == ProjectStatus.published
                          ? AppBadgeVariant.brand
                          : AppBadgeVariant.warning,
                    ),
                  ],
                ),
                if (currentProject.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    currentProject.description,
                    style: AppTypography.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.coins,
                        color: AppColors.brand700,
                        size: 22,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Presupuesto orientativo',
                              style: AppTypography.caption,
                            ),
                            Text(
                              currentProject.budgetEstimateCop > 0
                                  ? '\$ ${formatCop(currentProject.budgetEstimateCop)} COP'
                                  : 'Por cotizar',
                              style: AppTypography.subheading.copyWith(
                                color: AppColors.brand700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Resumen de superficies', style: AppTypography.subheading),
                const SizedBox(height: AppSpacing.sm),
                AppSpecRow(
                  icon: LucideIcons.ruler,
                  label: 'Área total calculada',
                  value: '${currentProject.totalAreaM2.toStringAsFixed(1)} m²',
                ),
                AppSpecRow(
                  icon: LucideIcons.layers,
                  label: 'Superficies registradas',
                  value: '${currentProject.surfaces.length} paredes',
                ),
                for (var i = 0; i < currentProject.surfaces.length; i++)
                  AppSpecRow(
                    icon: LucideIcons.square,
                    label: currentProject.surfaces[i].name,
                    value:
                        '${currentProject.surfaces[i].widthMeters} × ${currentProject.surfaces[i].heightMeters} m · ${currentProject.surfaces[i].areaM2.toStringAsFixed(1)} m²',
                    showDivider: i < currentProject.surfaces.length - 1,
                  ),
                const Divider(height: AppSpacing.xxl, color: AppColors.line300),
                Text('Gestión del expediente', style: AppTypography.subheading),
                const SizedBox(height: AppSpacing.xs),
                AppListTile(
                  leadingIcon: LucideIcons.paintBucket,
                  title: 'Lista de materiales del proyecto',
                  subtitle: currentProject.materials.isEmpty
                      ? 'Configura o agrega insumos desde la Bodega'
                      : '${currentProject.materials.length} referencias · \$ ${formatCop(currentProject.materialsTotalCop)} COP',
                  onTap: () => AppNavigator.push(
                    context,
                    ProjectMaterialsScreen(
                      projectId: currentProject.id,
                      initialProject: currentProject,
                    ),
                  ),
                ),
                AppListTile(
                  leadingIcon: LucideIcons.pencil,
                  title: 'Editar datos, medidas o fotos',
                  subtitle: 'Abrir el asistente en modo edición',
                  onTap: () => AppNavigator.push(
                    context,
                    CreateProjectScreen(initialProject: currentProject),
                  ),
                ),
                AppListTile(
                  leadingIcon: LucideIcons.messageSquare,
                  title: 'Conversaciones y contraofertas',
                  subtitle: 'Abrir chat con contratistas interesados',
                  showDivider: false,
                  onTap: () => AppNavigator.push(
                    context,
                    ProjectChatScreen(
                      conversationId: 'conv-001',
                      projectTitle: currentProject.title,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
