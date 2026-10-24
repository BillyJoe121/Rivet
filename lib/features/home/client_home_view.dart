import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../auth/auth_service.dart';
import '../projects/create_project_screen.dart';
import '../projects/project_detail_screen.dart';
import 'widgets/client_home_cards.dart';

/// Inicio del propietario: saludo, publicar un proyecto y sus proyectos.
/// Los demás destinos viven en la barra inferior y en "Más".
class ClientHomeView extends StatefulWidget {
  const ClientHomeView({super.key, required this.onOpenProjects});

  /// Abre la pestaña Proyectos del shell ("Ver todos").
  final VoidCallback onOpenProjects;

  @override
  State<ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<ClientHomeView> {
  late final Future<String> _firstName = _loadFirstName();

  Future<String> _loadFirstName() async {
    try {
      final user = await AuthService.instance.getCurrentUser();
      final first = user?.fullName.trim().split(' ').first ?? '';
      return first.isEmpty ? '' : first[0].toUpperCase() + first.substring(1);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = MockData.projects.take(2).toList();

    return FutureBuilder<String>(
      future: _firstName,
      builder: (context, snapshot) {
        final name = snapshot.data ?? '';
        return RivetScaffold(
          showBackButton: false,
          title: name.isEmpty ? 'Hola' : 'Hola, $name',
          backgroundImagePath: 'Fondos/Sala minimalista con plantas y luz suave.png',
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text(
                '¿Qué vas a mejorar hoy?',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.ink700),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ClientPublishCard(
                onPublish: () => AppNavigator.push(context, const CreateProjectScreen()),
              ),
              if (projects.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                AppSectionHeader(
                  title: 'Tus proyectos',
                  actionLabel: 'Ver todos',
                  onAction: widget.onOpenProjects,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final project in projects)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ClientProjectCard(
                      project: project,
                      proposalCount: MockData.proposals.where((p) => p.projectId == project.id).length,
                      onTap: () => AppNavigator.push(context, ProjectDetailScreen(project: project)),
                    ),
                  ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
