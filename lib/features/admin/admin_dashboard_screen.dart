import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'admin_dispute_resolution_screen.dart';

/// Panel administrativo interno de supervisión (P-045).
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Panel Administrativo',
        subtitle: 'Supervisión Interna Rivet',
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Métricas Generales
            Text('Resumen de Operación (P-045)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: AppStatTile(
                    label: 'OBRAS ACTIVAS',
                    value: '14 obras',
                    subtitle: 'Cali y alrededores',
                    icon: Icons.foundation,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppStatTile(
                    label: 'CONTRATISTAS',
                    value: '42 activos',
                    subtitle: 'Verificados',
                    icon: Icons.engineering,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppStatTile(
                    label: 'BODEGAS / PROV',
                    value: '6 sedes',
                    subtitle: 'FerreCasa y aliados',
                    icon: Icons.storefront,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppStatTile(
                    label: 'CASOS ABIERTOS',
                    value: '1 caso',
                    subtitle: 'En mediación',
                    highlight: true,
                    icon: Icons.gavel,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Acciones Rápidas
            Text('Gestión y Políticas de Plataforma', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDisputeResolutionScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.brandLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.rule, color: AppColors.brand700),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resolución de Casos y Políticas (P-046 / P-047)', style: AppTypography.subheading.copyWith(fontSize: 14)),
                        Text('Gestionar mediaciones, tarifas comerciales y plazos de garantía.', style: AppTypography.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.ink500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
