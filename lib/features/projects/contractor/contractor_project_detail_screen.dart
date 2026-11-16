import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/widgets/widgets.dart';
import '../../proposals/contractor/create_proposal_screen.dart';
import '../../supplier/material_price_tier.dart';

/// Detalle de un proyecto abierto visto por el contratista (22:144487).
class ContractorProjectDetailScreen extends StatelessWidget {
  const ContractorProjectDetailScreen({super.key, required this.project});

  final Project project;

  static Route<void> route(Project project) {
    return RivetPageRoute<void>(
      builder: (_) => ContractorProjectDetailScreen(project: project),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Detalle del\nproyecto',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.lounge,
      body: AppPageBody(
        footer: AppButton(
          text: 'Crear y enviar propuesta',
          showChevron: true,
          onPressed: () => Navigator.of(context).push(
            CreateProposalScreen.route(project: project),
          ),
        ),
        children: [
          AppCard(
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
                          Text(project.title, style: AppTypography.sectionTitle),
                          const SizedBox(height: 4),
                          Text(
                            '${project.city} · ${project.neighborhood}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.ink700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const AppBadge(
                      text: 'Abierto',
                      variant: AppBadgeVariant.brand,
                    ),
                  ],
                ),
                if (project.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(project.description, style: AppTypography.bodySmall),
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
                              'Presupuesto estimado del cliente',
                              style: AppTypography.caption,
                            ),
                            Text(
                              project.budgetEstimateCop > 0
                                  ? '\$ ${formatCop(project.budgetEstimateCop)} COP'
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
                Text('Superficies a intervenir', style: AppTypography.subheading),
                const SizedBox(height: AppSpacing.sm),
                AppSpecRow(
                  icon: LucideIcons.ruler,
                  label: 'Área total calculada',
                  value: '${project.totalAreaM2.toStringAsFixed(1)} m²',
                ),
                AppSpecRow(
                  icon: LucideIcons.layers,
                  label: 'Cantidad de muros',
                  value: '${project.surfaces.length}',
                ),
                for (var i = 0; i < project.surfaces.length; i++)
                  AppSpecRow(
                    icon: LucideIcons.square,
                    label: project.surfaces[i].name,
                    value:
                        '${project.surfaces[i].widthMeters} × ${project.surfaces[i].heightMeters} m · ${project.surfaces[i].finishType}',
                    showDivider: i < project.surfaces.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
