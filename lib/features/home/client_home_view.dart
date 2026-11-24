import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../../injection_container.dart';
import '../auth/domain/entities/rivet_user.dart';
import '../auth/presentation/bloc/auth/auth_bloc.dart';
import '../messaging/client_notifications_screen.dart';
import '../projects/domain/repositories/project_repository.dart';
import '../projects/project_detail_screen.dart';
import '../proposals/domain/repositories/proposal_repository.dart';
import 'client_home_bloc.dart';
import 'widgets/client_home_cards.dart';

/// Inicio del propietario: saludo y sus proyectos reales.
/// Los demás destinos viven en la barra inferior y en "Más".
class ClientHomeView extends StatelessWidget {
  const ClientHomeView({super.key, required this.onOpenProjects});

  /// Abre la pestaña Proyectos del shell ("Ver todos").
  final VoidCallback onOpenProjects;

  /// Crea el inicio del cliente conectado a [ClientHomeBloc] vía GetIt o contexto.
  static Widget withBloc({required VoidCallback onOpenProjects}) {
    return BlocProvider<ClientHomeBloc>(
      create: (context) => resolveBloc<ClientHomeBloc>(
        () => ClientHomeBloc.fromRepositories(
          context.read<ProjectRepository>(),
          context.read<ProposalRepository>(),
        ),
      )..add(const LoadClientHome()),
      child: ClientHomeView(onOpenProjects: onOpenProjects),
    );
  }

  static String _firstNameOf(RivetUser? user) {
    final first = user?.fullName.trim().split(' ').first ?? '';
    return first.isEmpty ? '' : first[0].toUpperCase() + first.substring(1);
  }

  Future<void> _openDetail(BuildContext context, dynamic project) async {
    final bloc = context.read<ClientHomeBloc>();
    await Navigator.of(context).push(ProjectDetailScreen.route(project));
    if (bloc.isClosed) return;
    bloc.add(const LoadClientHome());
  }

  @override
  Widget build(BuildContext context) {
    final name = _firstNameOf(
      context.select((AuthBloc bloc) => bloc.state.user),
    );

    return BlocBuilder<ClientHomeBloc, ClientHomeState>(
      builder: (context, state) {
        final projects = state.featuredProjects;

        return RivetScaffold(
          showBackButton: false,
          showWordmark: true,
          title: name.isEmpty ? 'Hola' : 'Hola, $name',
          backgroundImagePath:
              'Fondos/Sala minimalista con plantas y luz suave.png',
          actions: [
            AppNotificationButton(
              onPressed: () => Navigator.of(context).push(
                ClientNotificationsScreen.route(),
              ),
            ),
          ],
          body: RefreshIndicator(
            color: AppColors.brand700,
            onRefresh: () async {
              context.read<ClientHomeBloc>().add(const LoadClientHome());
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '¿Qué vas a mejorar hoy?',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.ink700,
                  ),
                ),
                const SizedBox(height: 54),
                if (state.isLoading && state.projects.isEmpty)
                  const AppLoadingState(label: 'Cargando tus proyectos')
                else if (state.isFailure && state.projects.isEmpty)
                  AppErrorState(
                    message:
                        state.errorMessage ?? 'No pudimos cargar tus proyectos.',
                    onRetry: () => context.read<ClientHomeBloc>().add(
                      const LoadClientHome(),
                    ),
                  )
                else if (projects.isEmpty)
                  AppEmptyState(
                    title: 'Aún no tienes proyectos',
                    message:
                        'Publica tu primer proyecto para recibir cotizaciones de contratistas verificados.',
                    icon: LucideIcons.folderPlus,
                    actionLabel: 'Ir a Proyectos',
                    onAction: onOpenProjects,
                  )
                else ...[
                  AppSectionHeader(
                    title: 'Tus proyectos',
                    actionLabel: 'Ver todos',
                    onAction: onOpenProjects,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final project in projects)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ClientProjectCard(
                        project: project,
                        proposalCount: state.proposalCountFor(project.id),
                        onTap: () => _openDetail(context, project),
                      ),
                    ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        );
      },
    );
  }
}
