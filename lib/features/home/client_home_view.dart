import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../projects/create_project_screen.dart';
import '../projects/project_detail_screen.dart';
import '../proposals/proposals_compare_screen.dart';
import '../contractors/contractor_detail_screen.dart';

/// Vista de inicio para el rol Cliente ("Hola, Juan").
class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key, required this.onSwitchRole});

  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final activeProject = MockData.projects.first;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.brand700,
              child: const Text('JP', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Juan Camilo', style: AppTypography.subheading.copyWith(fontSize: 16)),
                Text('Valle del Lili · Cali', style: AppTypography.caption),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Notificaciones',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Banner de Creación de Proyecto
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            backgroundColor: AppColors.brand800,
            borderColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBadge(
                  text: 'Cotización Gratuita',
                  variant: AppBadgeVariant.brand,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '¿Tienes paredes por pintar o estucar?',
                  style: AppTypography.subheading.copyWith(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Mide tu espacio, sube fotos privadas y recibe propuestas comparables sin intermediarios.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.leaf300),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  text: 'Crear nueva solicitud de cotización',
                  variant: AppButtonVariant.secondary,
                  icon: Icons.add_circle_outline,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Proyecto en Curso con Ofertas Recibidas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mi Proyecto Activo', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
              const AppBadge(text: '2 Ofertas Listas', variant: AppBadgeVariant.warning),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: activeProject)),
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
                          Text(activeProject.title, style: AppTypography.subheading),
                          const SizedBox(height: 2),
                          Text('${activeProject.neighborhood} · Creado hace 2 días', style: AppTypography.caption),
                        ],
                      ),
                    ),
                    const AppBadge(text: 'Publicado', variant: AppBadgeVariant.brand),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppStatTile(
                        label: 'ÁREA TOTAL',
                        value: '${activeProject.totalAreaM2.toStringAsFixed(1)} m²',
                        icon: Icons.square_foot,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppStatTile(
                        label: 'SUPERFICIES',
                        value: '${activeProject.surfaces.length} zonas',
                        icon: Icons.layers_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  text: 'Comparar las 2 ofertas recibidas',
                  variant: AppButtonVariant.primary,
                  icon: Icons.compare_arrows,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProposalsCompareScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Profesionales destacados en la zona
          Text('Pintores verificados en Cali', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
          const SizedBox(height: AppSpacing.xs),
          Text('Evaluados por clientes reales en mano de obra y cumplimiento.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ...MockData.contractors.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ContractorDetailScreen(contractor: c)),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.brandLight,
                        child: Text(
                          c.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: const TextStyle(color: AppColors.brand700, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(c.name, style: AppTypography.subheading),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, color: AppColors.brand700, size: 16),
                              ],
                            ),
                            Text(c.trade, style: AppTypography.caption),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.clay600, size: 14),
                                const SizedBox(width: 2),
                                Text('${c.rating}', style: AppTypography.badgeText),
                                Text(' (${c.reviewCount} trabajos)', style: AppTypography.caption),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.ink500),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
