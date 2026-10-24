import 'package:flutter/material.dart';

import '../../core/models/models.dart';
import '../../core/utils/app_page_route.dart';
import '../under_construction/under_construction_screen.dart';
import 'widgets/kit/kit.dart';
import 'widgets/pro_home_cards.dart';
import 'widgets/pro_home_mock.dart';

/// Inicio del contratista ("Hola, Carlos").
class ContractorHomeView extends StatelessWidget {
  const ContractorHomeView({super.key, required this.onSwitchRole});

  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    // Proyectos, trabajos, actividad y notificaciones aún no están disponibles.
    VoidCallback open(String section) =>
        () => AppNavigator.push(context, UnderConstructionScreen(section: section));

    return ProScreen(
      backgroundAsset: ProAssets.headerBotanical,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProBrandHeader(title: 'Hola, Carlos', onBellTap: open('Notificaciones')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                ProFeaturedProjectCard(project: ContractorHomeMock.nearbyProject, onTap: open('Proyectos')),
                ProSectionHeader('Mi trabajo en curso', linkLabel: 'Ver todos', onLinkTap: open('Trabajos')),
                ProProjectCard(project: ContractorHomeMock.ongoingWork, onTap: open('Trabajos')),
                ProSectionHeader('Actividad reciente', linkLabel: 'Ver todos', onLinkTap: open('Actividad')),
                // Cada entrada llevará a su proyecto cuando exista esa pantalla.
                ProActivityCard(items: ContractorHomeMock.activity, onTap: (_) => open('Proyectos')()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
