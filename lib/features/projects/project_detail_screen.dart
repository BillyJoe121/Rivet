import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../core/data/mock_data.dart';
import '../proposals/proposal_detail_screen.dart';
import '../proposals/create_proposal_screen.dart';

/// Dossier y detalle completo de un proyecto (P-013 / P-018).
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
    this.isContractorView = false,
  });

  final Project project;
  final bool isContractorView;

  @override
  Widget build(BuildContext context) {
    final gallons = (project.totalAreaM2 / 25.0).ceil();

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Dossier de Obra',
        subtitle: project.city,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Tarjeta Principal
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(project.neighborhood, style: AppTypography.caption),
                    AppBadge(text: project.status.label, variant: AppBadgeVariant.brand),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(project.title, style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(project.description, style: AppTypography.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppStatTile(
                        label: 'ÁREA TOTAL',
                        value: '${project.totalAreaM2.toStringAsFixed(1)} m²',
                        icon: Icons.square_foot,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppStatTile(
                        label: 'PINTURA ORIENTATIVA',
                        value: '$gallons Galones',
                        subtitle: '2 manos vinilo',
                        icon: Icons.format_paint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Lista de Superficies Medidas (P-009 / P-013)
          Text('Superficies Registradas (${project.surfaces.length})', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text('Dimensiones confirmadas por el cliente.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ...project.surfaces.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.brandLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.crop_free, color: AppColors.brand700, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name, style: AppTypography.subheading.copyWith(fontSize: 14)),
                            Text('${s.widthMeters} m × ${s.heightMeters} m · ${s.finishType}', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Text('${s.areaM2.toStringAsFixed(1)} m²', style: AppTypography.badgeText),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: AppSpacing.xxl),

          // Foto del espacio minimizada
          Text('Esquema visual del espacio (P-012)', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text('Imagen con objetos privados difuminados mediante IA.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'Fondos/Salón Minimalista en Verde y Crema.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.surfaceSubtle),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Botón de acción según rol
          if (isContractorView) ...[
            AppButton(
              text: 'Postular Cotización a esta Obra',
              icon: Icons.send_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateProposalScreen(project: project)),
                );
              },
            ),
          ] else ...[
            AppButton(
              text: 'Ver Propuesta Recibida',
              icon: Icons.description_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProposalDetailScreen(proposal: MockData.proposals.first),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
