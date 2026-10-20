import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'widgets/account_proposal_widgets.dart';

/// Propuestas enviadas y trabajos del contratista (Figma 22:145904).
class MyProposalsScreen extends StatefulWidget {
  const MyProposalsScreen({super.key});

  @override
  State<MyProposalsScreen> createState() => _MyProposalsScreenState();
}

class _MyProposalsScreenState extends State<MyProposalsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerPapers,
      bottomNav: const ProBottomNav(active: ProNavDestination.home),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Mis propuestas y trabajos',
            lucideChevron: true,
            height: 126,
            titleWidth: 213,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 3,
              children: [
                AccountTabs(
                  labels: const ['Propuestas', 'Trabajos'],
                  selected: _tab,
                  onSelect: (i) => setState(() => _tab = i),
                ),
                const Row(
                  spacing: 7,
                  children: [
                    Expanded(child: AccountCountCard(value: '2', label: 'Borradores')),
                    Expanded(child: AccountCountCard(value: '5', label: 'Enviadas')),
                    Expanded(child: AccountCountCard(value: '1', label: 'Aceptada')),
                  ],
                ),
                const ProSectionHeader('Mis propuestas', linkLabel: 'Más recientes'),
                const AccountProposalRow(
                  image: ProAssets.roughWork,
                  title: 'Pintura interior',
                  status: 'Borrador',
                  statusBackground: ProColors.warningLight,
                  statusColor: ProColors.sun300,
                  details: 'Apartamento en Cedritos\n♧ 120 m² · Bogotá D.C.\n\$ 2.800.000',
                ),
                const AccountProposalRow(
                  image: ProAssets.kitchenGreen,
                  title: 'Renovación cocina',
                  status: 'Enviada',
                  statusBackground: ProColors.infoLight,
                  statusColor: ProColors.brand700,
                  details: 'Casa en Envigado\n♧ 85 m² · Envigado\n\$ 4.200.000',
                ),
                const AccountProposalRow(
                  image: ProAssets.gardenHouse,
                  title: 'Pintura exterior',
                  status: 'Rechazada',
                  statusBackground: ProColors.dangerLight,
                  statusColor: ProColors.brand700,
                  details: 'Casa campestre\n♧ 200 m² · Medellín\n\$ 5.100.000',
                ),
                const ProSectionHeader('Trabajos activos', linkLabel: 'Ver todos'),
                const AccountJobRow(
                  image: ProAssets.paintingRoom,
                  title: 'Pintar sala',
                  status: 'En curso',
                  statusBackground: ProColors.successLight,
                  statusColor: ProColors.brand700,
                  client: 'Juan Pérez · Bogotá D.C.',
                  progress: 0.3,
                  progressWidth: 200,
                  progressLabel: '2 de 4 etapas',
                ),
                const AccountJobRow(
                  image: ProAssets.modernHouse,
                  title: 'Estuco y fachada',
                  status: 'Finalizado',
                  statusBackground: ProColors.brandLight,
                  statusColor: ProColors.brand700,
                  client: 'María González · Envigado',
                  progress: 120 / 182,
                  progressWidth: 182,
                  progressLabel: '100% completado',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
