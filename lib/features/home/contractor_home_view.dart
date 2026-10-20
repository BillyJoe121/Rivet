import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';
import '../projects/my_projects_screen.dart';
import '../projects/project_detail_screen.dart';
import 'widgets/kit/kit.dart';
import 'widgets/pro_home_cards.dart';
import 'widgets/pro_home_mock.dart';

/// Inicio del contratista ("Hola, Carlos").
class ContractorHomeView extends StatelessWidget {
  const ContractorHomeView({super.key, required this.onSwitchRole});

  final ValueChanged<UserRole> onSwitchRole;

  @override
  Widget build(BuildContext context) {
    final project = MockData.projects.first;
    void openProject() => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project, isContractorView: true)),
        );
    void openProjects() => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyProjectsScreen(forContractor: true)),
        );

    return ProScreen(
      backgroundAsset: ProAssets.headerBotanical,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBrandHeader(initials: 'CR', title: 'Hola, Carlos'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                ProFeaturedProjectCard(project: ContractorHomeMock.nearbyProject, onTap: openProject),
                Row(
                  spacing: 8,
                  children: [
                    for (final access in ContractorHomeMock.quickAccess)
                      Expanded(
                        child: ProQuickAccess(icon: access.icon, label: access.label, onTap: openProjects),
                      ),
                  ],
                ),
                ProSectionHeader('Mi trabajo en curso', linkLabel: 'Ver todos', onLinkTap: openProjects),
                ProProjectCard(project: ContractorHomeMock.ongoingWork, onTap: openProject),
                ProSectionHeader('Actividad reciente', linkLabel: 'Ver todos', onLinkTap: openProjects),
                ProActivityCard(items: ContractorHomeMock.activity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
