import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../auth/auth_service.dart';
import '../auth/domain/entities/rivet_user.dart';
import '../under_construction/under_construction_screen.dart';
import 'widgets/client_home_cards.dart';

/// Inicio del propietario: saludo y sus proyectos.
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

  // Nombre de la sesión ya conocida, para que el saludo no cambie al cargar.
  late final String _cachedFirstName = () {
    try {
      return _firstNameOf(AuthService.instance.currentUser);
    } catch (_) {
      return '';
    }
  }();

  Future<String> _loadFirstName() async {
    try {
      return _firstNameOf(await AuthService.instance.getCurrentUser());
    } catch (_) {
      return '';
    }
  }

  static String _firstNameOf(RivetUser? user) {
    final first = user?.fullName.trim().split(' ').first ?? '';
    return first.isEmpty ? '' : first[0].toUpperCase() + first.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final projects = MockData.projects.take(2).toList();

    return FutureBuilder<String>(
      future: _firstName,
      initialData: _cachedFirstName,
      builder: (context, snapshot) {
        final name = snapshot.data ?? '';
        return RivetScaffold(
          showBackButton: false,
          showWordmark: true,
          title: name.isEmpty ? 'Hola' : 'Hola, $name',
          backgroundImagePath: 'Fondos/Sala minimalista con plantas y luz suave.png',
          actions: [
            // Notificaciones aún no está disponible.
            AppNotificationButton(
              onPressed: () => AppNavigator.push(
                context,
                const UnderConstructionScreen(section: 'Notificaciones'),
              ),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.sm),
              Text(
                '¿Qué vas a mejorar hoy?',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.ink700),
              ),
              const SizedBox(height: AppSpacing.xxl),
              if (projects.isNotEmpty) ...[
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
                      onTap: () => AppNavigator.push(
                        context,
                        const UnderConstructionScreen(section: 'Proyectos'),
                      ),
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
