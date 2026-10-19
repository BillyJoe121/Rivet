import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../projects/project_detail_screen.dart';
import '../proposals/create_proposal_screen.dart';

/// Vista de inicio para el rol Contratista ("Hola, Carlos").
class ContractorHomeView extends StatelessWidget {
  const ContractorHomeView({super.key, required this.onSwitchRole});

  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final availableProject = MockData.projects.first;

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.clay600,
              child: const Text('CM', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, Carlos Mendoza', style: AppTypography.subheading.copyWith(fontSize: 16)),
                Text('Maestro Pintor · Cali Sur', style: AppTypography.caption),
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
          // Tarjeta de Resumen Financiero y Trabajos
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Balance y Trabajos', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
                    const AppBadge(text: 'Simulado V1', variant: AppBadgeVariant.neutral),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppStatTile(
                        label: 'MANO DE OBRA PENDIENTE',
                        value: '\$1.450.000',
                        subtitle: '2 proyectos por liberar',
                        highlight: true,
                        icon: Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppStatTile(
                        label: 'TRABAJOS ACTIVOS',
                        value: '2 obras',
                        subtitle: '1 visita agendada',
                        icon: Icons.handyman_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Solicitud Reciente para Cotizar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nueva Solicitud en tu Zona', style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
              const AppBadge(text: 'Valle del Lili', variant: AppBadgeVariant.info),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

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
                          Text(availableProject.title, style: AppTypography.subheading),
                          const SizedBox(height: 2),
                          Text('${availableProject.city} · ${availableProject.neighborhood}', style: AppTypography.caption),
                        ],
                      ),
                    ),
                    const AppBadge(text: 'Sin Ofertar Aún', variant: AppBadgeVariant.warning),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  availableProject.description,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Área calculada: ${availableProject.totalAreaM2.toStringAsFixed(1)} m²',
                        style: AppTypography.badgeText.copyWith(color: AppColors.brand700),
                      ),
                    ),
                    Text(
                      '3 superficies medidas',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Ver Dossier',
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: availableProject)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton(
                        text: 'Cotizar Obra',
                        variant: AppButtonVariant.primary,
                        icon: Icons.send_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CreateProposalScreen(project: availableProject)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Banner Bodega con Tarifa Profesional
          AppCard(
            backgroundColor: AppColors.brandLight,
            borderColor: AppColors.brand700.withValues(alpha: 0.2),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brand700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.percent, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tarifa Profesional Activa', style: AppTypography.subheading),
                      const SizedBox(height: 2),
                      Text(
                        'FerreCasa Central te autorizó precios especiales en vinilos y estucos.',
                        style: AppTypography.caption,
                      ),
                    ],
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
