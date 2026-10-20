import 'package:flutter/material.dart';
import '../home/widgets/kit/kit.dart';
import 'admin_dispute_resolution_screen.dart';
import 'widgets/admin_widgets.dart';

/// Panel administrativo interno de supervisión (P-045).
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerPapers,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Panel Administrativo',
            lucideChevron: true,
            height: 120,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            titleWidth: 300,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: ProColors.brandLight,
                      borderRadius: BorderRadius.circular(ProRadii.xl),
                    ),
                    child: Text(
                      'Supervisión Interna Rivet',
                      style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Resumen de Operación (P-045)', style: ProText.subheading),
                Row(
                  spacing: 8,
                  children: const [
                    Expanded(
                      child: AdminStatTile(
                        label: 'OBRAS ACTIVAS',
                        value: '14 obras',
                        subtitle: 'Cali y alrededores',
                        icon: LucideIcon.house,
                      ),
                    ),
                    Expanded(
                      child: AdminStatTile(
                        label: 'CONTRATISTAS',
                        value: '42 activos',
                        subtitle: 'Verificados',
                        icon: LucideIcon.briefcase,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: const [
                    Expanded(
                      child: AdminStatTile(
                        label: 'BODEGAS / PROV',
                        value: '6 sedes',
                        subtitle: 'FerreCasa y aliados',
                        icon: LucideIcon.store,
                      ),
                    ),
                    Expanded(
                      child: AdminStatTile(
                        label: 'CASOS ABIERTOS',
                        value: '1 caso',
                        subtitle: 'En mediación',
                        highlight: true,
                        icon: LucideIcon.circleAlert,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Gestión y Políticas de Plataforma', style: ProText.subheading),
                ProCard(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminDisputeResolutionScreen()),
                    );
                  },
                  child: const ProOptionRow(
                    icon: LucideIcon.shieldCheck,
                    title: 'Resolución de Casos y Políticas (P-046 / P-047)',
                    subtitle: 'Gestionar mediaciones, tarifas comerciales y plazos de garantía.',
                    showDivider: false,
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
