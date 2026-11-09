import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../proposals/received_proposals_screen.dart';
import '../supplier/material_price_tier.dart';

/// Ficha completa y expediente del proyecto para el cliente (P-013).
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: project.title,
      showBackButton: true,
      backgroundImagePath: project.imageAsset ?? 'Fondos/Checklist, plantas y cajas sostenibles.png',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.sm),
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
                            project.title,
                            style: AppTypography.sectionTitle.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${project.city} · ${project.neighborhood}',
                            style: AppTypography.caption.copyWith(color: AppColors.ink700),
                          ),
                        ],
                      ),
                    ),
                    AppBadge(
                      text: project.status.label,
                      variant: project.status == ProjectStatus.published
                          ? AppBadgeVariant.brand
                          : AppBadgeVariant.warning,
                    ),
                  ],
                ),
                if (project.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    project.description,
                    style: AppTypography.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.coins, color: AppColors.brand700, size: 22),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Presupuesto orientativo', style: AppTypography.caption),
                          Text(
                            project.budgetEstimateCop > 0
                                ? '\$ ${formatCop(project.budgetEstimateCop)} COP'
                                : 'Por cotizar',
                            style: AppTypography.subheading.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Resumen de superficies', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.sm),
                AppSpecRow(
                  icon: LucideIcons.ruler,
                  label: 'Área total calculada',
                  value: '${project.totalAreaM2.toStringAsFixed(1)} m²',
                ),
                AppSpecRow(
                  icon: LucideIcons.layers,
                  label: 'Superficies registradas',
                  value: '${project.surfaces.length} paredes',
                ),
                const SizedBox(height: AppSpacing.md),
                for (final surface in project.surfaces)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.paper100,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(color: AppColors.line300, width: AppSpacing.strokeCard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(surface.name, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            '${surface.widthMeters}m × ${surface.heightMeters}m (${surface.areaM2.toStringAsFixed(1)} m²)',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            text: 'Ver cotizaciones recibidas',
            icon: LucideIcons.chevronRight,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReceivedProposalsScreen(projectId: project.id),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

